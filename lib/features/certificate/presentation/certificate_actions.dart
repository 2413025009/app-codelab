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

import '../../../app/router/app_routes.dart';
import '../../../core/widgets/app_snack.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/certificate_models.dart';
import '../domain/certificate_repository.dart';

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
