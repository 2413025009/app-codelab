// FILE: lib/features/certificate/presentation/certificate_actions.dart
//
// TUGAS: aksi bersama untuk membuka e-Sertifikat Kompetensi dari layar mana
// pun (peta belajar, katalog materi) — Minggu 12.
//
// ALUR:
//   1. Ambil daftar sertifikat resmi dari backend (GET /me/certificates).
//   2. Cari modul yang cocok dengan topik.
//   3. Bila eligible + nomor sertifikat ada → buka
//      `/sertifikat-kompetensi-siswa/:certId`.
//   4. Bila belum layak → tampilkan alasan ramah + progres (bukan galat).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/widgets/app_snack.dart';
import '../../../l10n/app_localizations.dart';
import '../../notifications/notification_events.dart';
import '../domain/certificate_models.dart';
import '../domain/certificate_repository.dart';

/// Buka pratinjau satu sertifikat (fungsi "lihat", bukan "unduh").
void openCertificatePreview(BuildContext context, String certId) {
  final id = certId.trim();
  if (id.isEmpty) return;
  context.push(AppRoutes.certificate(id));
}

/// Unduh PDF resmi 2 halaman (depan + belakang) langsung dari backend.
///
/// Berkas dikirim dengan `Content-Disposition: attachment`, jadi browser /
/// perangkat menyimpannya sebagai satu PDF utuh — tidak membuka halaman
/// verifikasi HTML dan tidak meminta pengguna mencetak manual.
Future<void> downloadCertificatePdf(
  BuildContext context,
  String certId,
) async {
  final l10n = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode == 'en'
      ? 'en'
      : 'id';
  final raw = CertificateLinks.pdf(certId, lang: lang);
  final uri = Uri.tryParse(raw);
  if (uri == null || raw.isEmpty) {
    showAppSnack(context, l10n.certDownloadFailed);
    return;
  }
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      if (context.mounted) showAppSnack(context, l10n.certDownloadFailed);
      return;
    }
    // Minggu 13 (Notifikasi 2): kabari setelah berkas BENAR-BENAR terbuka
    // (browser/penampil PDF menerima tautan unduhan), bukan sebelumnya.
    if (context.mounted) {
      await NotificationEvents.certificateDownloaded(context, certId);
    }
  } catch (_) {
    if (context.mounted) showAppSnack(context, l10n.certDownloadFailed);
  }
}

/// Buka sertifikat modul untuk [topic] bila sudah layak terbit.
Future<void> openModuleCertificate(BuildContext context, String topic) async {
  final l10n = AppLocalizations.of(context);
  final repo = context.read<CertificateRepository>();

  MyCertificates certs;
  try {
    certs = await repo.getMyCertificates();
  } catch (_) {
    if (context.mounted) showAppSnack(context, l10n.certLoadFailed);
    return;
  }
  if (!context.mounted) return;

  final wanted = topic.trim().toLowerCase();
  ModuleCertificate? match;
  for (final m in certs.moduleCertificates) {
    if (m.topic.trim().toLowerCase() == wanted) {
      match = m;
      break;
    }
  }

  if (match == null) {
    // Modul belum terdaftar pada daftar sertifikat (mis. materi guru baru).
    showAppSnack(context, l10n.certNotEligible);
    return;
  }
  if (!match.eligible || match.certId.trim().isEmpty) {
    showAppSnack(context, l10n.certProgressLockedHint(match.progressInt));
    return;
  }
  context.push(AppRoutes.certificate(match.certId.trim()));
}
