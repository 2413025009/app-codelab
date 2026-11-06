// FILE: lib/features/notifications/notification_events.dart
//
// TUGAS: titik panggil kelima notifikasi HP (Minggu 13), terpusat di satu
// berkas agar layar-layar pemanggil tidak perlu tahu detail plugin.
//
// SETIAP fungsi di sini:
//   1. memeriksa saklar pengguna ([NotificationPreferences]) — mati = tidak
//      ada notifikasi sama sekali;
//   2. memakai teks L10n bahasa aktif (id/en/ar), bukan teks Indonesia lepas;
//   3. tidak pernah melempar — notifikasi tidak boleh menggagalkan alur belajar.
//
// WAJIB DIUBAH BILA: menambah jenis notifikasi → tambahkan fungsi di sini,
// jangan memanggil `NotificationService` langsung dari layar.
import 'package:flutter/widgets.dart';

import '../../core/services/notification_preferences.dart';
import '../../core/services/notification_service.dart';
import '../../l10n/app_localizations.dart';

abstract final class NotificationEvents {
  /// Notifikasi 1a — satu modul tuntas 100%.
  ///
  /// Dipanggil SETELAH server mengonfirmasi progres tersimpan, bukan saat
  /// tombol ditekan, agar kabar "sertifikat terbit" tidak mendahului datanya.
  static Future<void> moduleCompleted(
    BuildContext context,
    String topic,
  ) async {
    if (!NotificationPreferences.instance.certificateEnabled) return;
    final l10n = AppLocalizations.of(context);
    await NotificationService.instance.showCertificateIssued(
      title: l10n.notifCertificateTitle,
      body: l10n.notifCertificateBody(topic),
    );
  }

  /// Notifikasi 1b — satu tantangan koding lulus (skor 100).
  static Future<void> challengePassed(
    BuildContext context,
    String challengeTitle,
  ) async {
    if (!NotificationPreferences.instance.certificateEnabled) return;
    final l10n = AppLocalizations.of(context);
    await NotificationService.instance.showCertificateIssued(
      title: l10n.notifChallengeTitle,
      body: l10n.notifChallengeBody(challengeTitle),
    );
  }

  /// Notifikasi 2 — e-Sertifikat PDF berhasil diunduh/dibuka.
  static Future<void> certificateDownloaded(
    BuildContext context,
    String certId,
  ) async {
    if (!NotificationPreferences.instance.downloadEnabled) return;
    final l10n = AppLocalizations.of(context);
    await NotificationService.instance.showCertificateDownloaded(
      title: l10n.notifDownloadTitle,
      body: l10n.notifDownloadBody(certId),
    );
  }

  /// Notifikasi 3 — pengingat belajar harian + kuota AI Tutor 5/5 penuh.
  ///
  /// Dijadwalkan berulang tiap hari pada 19.00 waktu perangkat. Dipanggil
  /// setelah login berhasil dan saat pengguna menyalakan saklar.
  static Future<void> scheduleDailyReminder(BuildContext context) async {
    if (!NotificationPreferences.instance.reminderEnabled) {
      await NotificationService.instance.cancelDailyReminder();
      return;
    }
    final l10n = AppLocalizations.of(context);
    await NotificationService.instance.scheduleDailyReminder(
      title: l10n.notifReminderTitle,
      body: l10n.notifReminderBody,
    );
  }

  /// Notifikasi 4 — pengajar menerbitkan modul/bab baru.
  static Future<void> newMaterial(
    BuildContext context,
    String title,
  ) async {
    if (!NotificationPreferences.instance.materialEnabled) return;
    final l10n = AppLocalizations.of(context);
    await NotificationService.instance.showNewMaterial(
      title: l10n.notifMaterialTitle,
      body: l10n.notifMaterialBody(title),
    );
  }

  /// Notifikasi 5 — sesi dicabut karena akun dipakai di perangkat lain.
  ///
  /// Dipanggil ketika server menolak token dengan `SESSION_REVOKED` yang
  /// alasannya `login_perangkat_baru`. Memakai teks tetap (bukan L10n context)
  /// karena bisa terjadi saat layar masuk sudah terbuka.
  static Future<void> sessionRevoked({
    required String title,
    required String body,
  }) async {
    if (!NotificationPreferences.instance.sessionEnabled) return;
    await NotificationService.instance.showSessionRevoked(
      title: title,
      body: body,
    );
  }
}
