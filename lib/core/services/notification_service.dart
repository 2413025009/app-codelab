// FILE: lib/core/services/notification_service.dart
//
// TUGAS: lima notifikasi sistem HP untuk siswa (Minggu 13).
//
// DAFTAR NOTIFIKASI (sesuai TODO Minggu 13):
//   1. Sertifikat Kompetensi terbit     → siswa menuntaskan modul / lulus tantangan
//   2. Unduhan PDF e-Sertifikat selesai → berkas PDF dibuka/diunduh dari Profil
//   3. Pengingat harian + kuota AI Tutor 5/5 kembali penuh (terjadwal harian)
//   4. Modul kelas baru dari pengajar   → modul `published` baru di kelas siswa
//   5. Sesi dicabut (perangkat lain) + saklar & tombol uji di Pengaturan
//
// PRINSIP:
//   * SEMUA panggilan dibungkus try/catch: notifikasi TIDAK BOLEH menggagalkan
//     alur belajar. Bila izin ditolak atau plugin tidak tersedia (web/desktop),
//     aplikasi tetap berjalan normal tanpa notifikasi.
//   * Saklar aktif/nonaktif disimpan di perangkat lewat [AppPreferences].
//   * Tidak ada teks Indonesia di sini — semua teks diambil dari L10n pemanggil
//     (id/en/ar), karena isi notifikasi adalah teks antarmuka.
//
// WAJIB DIUBAH BILA: menambah jenis notifikasi → tambah method publik di kelas
// ini + kanal Android baru di `_channels`, lalu panggil dari layar terkait.
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Kanal notifikasi Android (harus stabil: ID kanal yang sudah terpasang di HP
/// pengguna tidak bisa diubah tanpa membuat kanal baru).
abstract final class NotificationChannels {
  static const certificate = 'codelab_certificate';
  static const download = 'codelab_download';
  static const reminder = 'codelab_reminder';
  static const material = 'codelab_material';
  static const session = 'codelab_session';
}

/// ID notifikasi tetap (bukan acak) agar notifikasi lama tertimpa, bukan
/// menumpuk puluhan baris di laci notifikasi.
abstract final class NotificationIds {
  static const certificateIssued = 1001;
  static const certificateDownloaded = 1002;
  static const dailyReminder = 1003;
  static const newMaterial = 1004;
  static const sessionRevoked = 1005;

  /// Pengingat harian memakai rentang ID agar bisa dijadwalkan berulang.
  static const dailyReminderBase = 2000;
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// True bila plugin benar-benar siap dipakai di perangkat ini.
  bool get isAvailable => _initialized && !kIsWeb;

  /// Dipanggil sekali saat aplikasi dibuka (main.dart).
  ///
  /// Tidak pernah melempar: kegagalan inisialisasi hanya membuat notifikasi
  /// tidak tampil, alur belajar tetap jalan.
  Future<void> init() async {
    if (_initialized || kIsWeb) return;
    try {
      // Database zona waktu dibutuhkan penjadwalan (notifikasi 3).
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation(_localTimezoneName()));

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwin = DarwinInitializationSettings(
        // Izin diminta eksplisit lewat requestPermission(), bukan diam-diam
        // saat start, sehingga pengguna tahu kenapa diminta.
        requestAlertPermission: false,
        requestSoundPermission: false,
        requestBadgePermission: false,
      );
      const settings = InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      );
      await _plugin.initialize(settings: settings);
      _initialized = true;
    } catch (_) {
      // Plugin tidak tersedia (mis. platform tanpa dukungan) — abaikan.
      _initialized = false;
    }
  }

  /// Meminta izin notifikasi (Android 13+ / iOS). Mengembalikan true bila
  /// diizinkan. Tidak pernah melempar.
  Future<bool> requestPermission() async {
    if (!isAvailable) return false;
    try {
      if (Platform.isAndroid) {
        final android = _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        final granted = await android?.requestNotificationsPermission();
        return granted ?? false;
      }
      if (Platform.isIOS || Platform.isMacOS) {
        final darwin = _plugin
            .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin>();
        final granted = await darwin?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Notifikasi 1 ───────────────────────────────────────────────────────────
  /// Sertifikat kompetensi terbit (modul tuntas 100% / tantangan lulus).
  Future<void> showCertificateIssued({
    required String title,
    required String body,
    String? payload,
  }) {
    return _show(
      id: NotificationIds.certificateIssued,
      channel: _channelFor(NotificationChannels.certificate),
      title: title,
      body: body,
      payload: payload,
    );
  }

  // ── Notifikasi 2 ───────────────────────────────────────────────────────────
  /// Unduhan PDF e-Sertifikat selesai (berkas berhasil dibuka/diunduh).
  Future<void> showCertificateDownloaded({
    required String title,
    required String body,
  }) {
    return _show(
      id: NotificationIds.certificateDownloaded,
      channel: _channelFor(NotificationChannels.download),
      title: title,
      body: body,
    );
  }

  // ── Notifikasi 3 ───────────────────────────────────────────────────────────
  /// Pengingat belajar harian + kuota AI Tutor kembali penuh (5/5).
  ///
  /// Dijadwalkan BERULANG setiap hari pada [hour]:[minute] waktu setempat.
  /// Dipanggil setelah login berhasil dan setiap kali pengguna mengubah saklar.
  Future<void> scheduleDailyReminder({
    required String title,
    required String body,
    int hour = 19,
    int minute = 0,
  }) async {
    if (!isAvailable) return;
    try {
      await _plugin.zonedSchedule(
        id: NotificationIds.dailyReminder,
        title: title,
        body: body,
        scheduledDate: _nextInstanceOf(hour, minute),
        notificationDetails: NotificationDetails(
          android: _channelFor(NotificationChannels.reminder),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // ulangi tiap hari
      );
    } catch (_) {
      // Penjadwalan bisa ditolak (izin/ketepatan waktu) — bukan galat fatal.
    }
  }

  /// Membatalkan pengingat harian (dipakai saat saklar notifikasi dimatikan).
  Future<void> cancelDailyReminder() async {
    if (!isAvailable) return;
    try {
      await _plugin.cancel(id: NotificationIds.dailyReminder);
    } catch (_) {
      // abaikan
    }
  }

  // ── Notifikasi 4 ───────────────────────────────────────────────────────────
  /// Modul/bab baru dari pengajar kelas siswa.
  Future<void> showNewMaterial({
    required String title,
    required String body,
    String? payload,
  }) {
    return _show(
      id: NotificationIds.newMaterial,
      channel: _channelFor(NotificationChannels.material),
      title: title,
      body: body,
      payload: payload,
    );
  }

  // ── Notifikasi 5 ───────────────────────────────────────────────────────────
  /// Sesi dicabut karena akun dipakai masuk di perangkat lain.
  Future<void> showSessionRevoked({
    required String title,
    required String body,
  }) {
    return _show(
      id: NotificationIds.sessionRevoked,
      channel: _channelFor(NotificationChannels.session),
      title: title,
      body: body,
    );
  }

  /// Tombol "Kirim Notifikasi Uji Coba" di Pengaturan.
  Future<bool> showTestNotification({
    required String title,
    required String body,
  }) async {
    if (!isAvailable) return false;
    try {
      await _plugin.show(
        id: 9999,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: _channelFor(NotificationChannels.reminder),
          iOS: const DarwinNotificationDetails(),
        ),
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  Future<void> _show({
    required int id,
    required AndroidNotificationDetails channel,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!isAvailable) return;
    try {
      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: channel,
          iOS: const DarwinNotificationDetails(),
        ),
        payload: payload,
      );
    } catch (_) {
      // Notifikasi gagal tampil tidak boleh mengganggu alur aplikasi.
    }
  }

  /// Definisi kanal Android. Kanal ditentukan di sisi aplikasi agar pengguna
  /// bisa mematikan satu jenis notifikasi tanpa mematikan semuanya.
  AndroidNotificationDetails _channelFor(String channelId) {
    final (name, description) = switch (channelId) {
      NotificationChannels.certificate => (
        'Sertifikat',
        'Kabar saat sertifikat kompetensi terbit',
      ),
      NotificationChannels.download => (
        'Unduhan',
        'Kabar saat e-Sertifikat PDF selesai diunduh',
      ),
      NotificationChannels.reminder => (
        'Pengingat Belajar',
        'Pengingat harian dan kuota AI Tutor kembali penuh',
      ),
      NotificationChannels.material => (
        'Modul Baru',
        'Modul atau bab baru dari pengajar kelasmu',
      ),
      NotificationChannels.session => (
        'Sesi Akun',
        'Pemberitahuan keamanan sesi akun',
      ),
      _ => ('CodeLab AI', 'Notifikasi aplikasi'),
    };
    return AndroidNotificationDetails(
      channelId,
      name,
      channelDescription: description,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: const BigTextStyleInformation(''),
    );
  }

  /// Waktu setempat perangkat. Bila tidak dikenali, jatuh ke UTC agar
  /// penjadwalan tetap berjalan (tidak melempar).
  String _localTimezoneName() {
    try {
      final offset = DateTime.now().timeZoneOffset;
      // Nama zona yang tersedia di package timezone; pilih yang jamnya cocok.
      final candidates = <String>[
        if (offset.inHours == 7) 'Asia/Jakarta',
        if (offset.inHours == 8) 'Asia/Makassar',
        if (offset.inHours == 9) 'Asia/Jayapura',
      ];
      return candidates.isNotEmpty ? candidates.first : 'UTC';
    } catch (_) {
      return 'UTC';
    }
  }

  /// Instance berikutnya pada jam [hour]:[minute] (hari ini bila belum lewat,
  /// besok bila sudah).
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
