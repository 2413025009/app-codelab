// FILE: lib/core/services/notification_preferences.dart
//
// TUGAS: preferensi notifikasi HP yang tersimpan di perangkat (Minggu 13).
//
// DIPISAH dari `AppPreferences` karena tanggung jawabnya berbeda: AppPreferences
// mengatur TEMA & BAHASA, sedangkan berkas ini mengatur izin/saklar notifikasi.
// Keduanya sama-sama `ChangeNotifier` agar UI bisa bereaksi langsung.
//
// WAJIB DIUBAH BILA: menambah jenis notifikasi baru → tambahkan field + getter +
// setter di sini, lalu pakai di layar Pengaturan dan pemanggil notifikasinya.
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationPreferences extends ChangeNotifier {
  NotificationPreferences._();

  static final NotificationPreferences instance = NotificationPreferences._();

  static const _storage = FlutterSecureStorage();
  static const _keyEnabled = 'codelab_notifications_enabled';
  static const _keyCertificate = 'codelab_notify_certificate';
  static const _keyDownload = 'codelab_notify_download';
  static const _keyReminder = 'codelab_notify_reminder';
  static const _keyMaterial = 'codelab_notify_material';
  static const _keySession = 'codelab_notify_session';

  /// Saklar induk. Bila dimatikan, SEMUA notifikasi berhenti — tanpa
  /// menghapus pilihan per jenis, sehingga menyalakannya kembali memulihkan
  /// pengaturan sebelumnya.
  bool _enabled = true;
  bool _certificate = true;
  bool _download = true;
  bool _reminder = true;
  bool _material = true;
  bool _session = true;

  bool get enabled => _enabled;
  bool get certificateEnabled => _enabled && _certificate;
  bool get downloadEnabled => _enabled && _download;
  bool get reminderEnabled => _enabled && _reminder;
  bool get materialEnabled => _enabled && _material;
  bool get sessionEnabled => _enabled && _session;

  /// Nilai mentah per jenis (tanpa dipengaruhi saklar induk) — dipakai
  /// Pengaturan agar pilihan pengguna tidak tampak berubah saat induk dimatikan.
  bool get certificateRaw => _certificate;
  bool get downloadRaw => _download;
  bool get reminderRaw => _reminder;
  bool get materialRaw => _material;
  bool get sessionRaw => _session;

  Future<void> init() async {
    try {
      _enabled = await _readBool(_keyEnabled, true);
      _certificate = await _readBool(_keyCertificate, true);
      _download = await _readBool(_keyDownload, true);
      _reminder = await _readBool(_keyReminder, true);
      _material = await _readBool(_keyMaterial, true);
      _session = await _readBool(_keySession, true);
      notifyListeners();
    } catch (_) {
      // Penyimpanan tidak tersedia: pakai default aman (semua aktif).
    }
  }

  Future<void> setEnabled(bool value) => _write(_keyEnabled, value, () => _enabled = value);
  Future<void> setCertificate(bool value) =>
      _write(_keyCertificate, value, () => _certificate = value);
  Future<void> setDownload(bool value) =>
      _write(_keyDownload, value, () => _download = value);
  Future<void> setReminder(bool value) =>
      _write(_keyReminder, value, () => _reminder = value);
  Future<void> setMaterial(bool value) =>
      _write(_keyMaterial, value, () => _material = value);
  Future<void> setSession(bool value) =>
      _write(_keySession, value, () => _session = value);

  Future<bool> _readBool(String key, bool fallback) async {
    final raw = await _storage.read(key: key);
    if (raw == null) return fallback;
    return raw == 'true';
  }

  Future<void> _write(String key, bool value, void Function() apply) async {
    apply();
    notifyListeners();
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (_) {
      // Gagal menyimpan tidak membatalkan perubahan yang sudah tampil.
    }
  }
}
