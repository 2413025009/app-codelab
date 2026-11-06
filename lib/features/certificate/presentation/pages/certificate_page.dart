// FILE: lib/features/certificate/presentation/pages/certificate_page.dart
//
// TUGAS: layar "Sertifikat Kompetensi" (route
// `/sertifikat-kompetensi-siswa/:certId`) — Minggu 12.
//
// ISI:
//   1. Pratinjau 2 halaman A4 landscape (piagam depan + transkrip belakang)
//      yang dirender langsung dari data backend GET /verify/{certId}.
//      Halaman 1: logo, nomor sertifikat, nama penerima, kalimat kelulusan,
//      judul/deskripsi, chip JP/tingkat/predikat, tanggal, tanda tangan
//      Devwan Hidayawan. Halaman 2: silabus bab (modul) ATAU instruksi +
//      aturan + hasil uji (tantangan).
//   2. Tombol "Buka Halaman Verifikasi" (membuka URL cetak PDF resmi
//      https://api.codelab-ai.web.id/verify/{certId} di browser perangkat).
//   3. Tombol "Bagikan Sertifikat" (menyalin tautan verifikasi).
//
// WAJIB DIUBAH BILA: tata letak piagam berubah — halaman web resmi memakai
// template yang sama di backend (certificate_page.go); jaga keduanya sejalan.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/certificate_models.dart';
import '../../domain/certificate_repository.dart';
import '../certificate_doc_labels.dart';

class CertificatePage extends StatefulWidget {
  const CertificatePage({super.key, required this.certId});

  final String certId;

  @override
  State<CertificatePage> createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  late Future<CertificateVerification> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<CertificateVerification> _load() {
    return context.read<CertificateRepository>().getVerification(
      widget.certId,
    );
  }

  Future<void> _openWeb(String url) async {
    final l10n = AppLocalizations.of(context);
    // Halaman verifikasi web menyediakan pengalih ID | EN; bahasa Arab tetap
    // memakai dokumen Arab di dalam aplikasi (tanpa memaksa web ke Arab).
    final doc = CertificateDocLabels.of(context);
    final webLang = doc.languageCode == 'en' ? 'en' : 'id';
    final withLang = _withLangParam(url, webLang);
    final uri = Uri.tryParse(withLang);
    if (uri == null) {
      showAppSnack(context, l10n.certLoadFailed);
      return;
    }
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) showAppSnack(context, l10n.certLoadFailed);
    } catch (_) {
      if (mounted) showAppSnack(context, l10n.certLoadFailed);
    }
  }

  Future<void> _share(String url) async {
    final l10n = AppLocalizations.of(context);
    try {
      await Clipboard.setData(ClipboardData(text: url));
      if (mounted) showAppSnack(context, l10n.certShareCopied);
    } catch (_) {
      if (mounted) showAppSnack(context, l10n.certShareFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: Text(l10n.certScreenTitle),
        actions: [
          IconButton(
            tooltip: l10n.certShareAction,
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () => _share(CertificateLinks.verify(widget.certId)),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
      ),
      body: FutureBuilder<CertificateVerification>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.certLoading,
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
                  ),
                ],
              ),
            );
          }
          final data = snapshot.data;
          if (snapshot.hasError || data == null) {
            return _CertError(
              message: l10n.certLoadFailed,
              retryLabel: l10n.dashRetryButton,
              onRetry: () => setState(() => _future = _load()),
            );
          }
          return _CertBody(
            data: data,
            onOpenWeb: () => _openWeb(
              data.verifyUrl.isNotEmpty
                  ? data.verifyUrl
                  : CertificateLinks.verify(data.certId),
            ),
            onShare: () => _share(
              data.verifyUrl.isNotEmpty
                  ? data.verifyUrl
                  : CertificateLinks.verify(data.certId),
            ),
          );
        },
      ),
    );
  }
}

class _CertError extends StatelessWidget {
  const _CertError({
    required this.message,
    required this.retryLabel,
    required this.onRetry,
  });

  final String message;
  final String retryLabel;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.workspace_premium_outlined, size: 46, color: p.textMuted),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.bodyM.copyWith(color: p.textMuted),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: retryLabel,
              leadingIcon: Icons.refresh,
              onPressed: onRetry,
              expand: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _CertBody extends StatelessWidget {
  const _CertBody({
    required this.data,
    required this.onOpenWeb,
    required this.onShare,
  });

  final CertificateVerification data;
  final VoidCallback onOpenWeb;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    // Bahasa dokumen mengikuti bahasa aplikasi aktif (id/en/ar).
    final doc = CertificateDocLabels.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.md,
        AppSpacing.screen,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ringkasan judul + jenis sertifikat.
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.topic,
                      style: AppTypography.titleM.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.certId,
                      style: AppTypography.codeSm.copyWith(color: p.primary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: data.isChallenge
                      ? p.accent.withValues(alpha: 0.18)
                      : p.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  data.isChallenge
                      ? l10n.profileCertChallengeDone
                      : l10n.profileCertReady,
                  style: AppTypography.caption.copyWith(
                    color: data.isChallenge ? p.warningText : p.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Halaman 1: piagam depan ─────────────────────────────────────
          Text(
            l10n.certPageOne,
            style: AppTypography.label.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _CertPageShell(
            child: _CertificateFrontPage(data: data, doc: doc),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Halaman 2: transkrip belakang ──────────────────────────────
          Text(
            l10n.certPageTwo,
            style: AppTypography.label.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _CertPageShell(
            child: _CertificateBackPage(data: data, doc: doc),
          ),
          const SizedBox(height: AppSpacing.md),

          Text(
            l10n.certPdfHint,
            style: AppTypography.caption.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.lg),

          AppButton(
            label: l10n.certOpenWeb,
            leadingIcon: Icons.open_in_new_rounded,
            onPressed: onOpenWeb,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.certShareAction,
            kind: AppButtonKind.secondary,
            leadingIcon: Icons.ios_share_rounded,
            onPressed: onShare,
          ),
        ],
      ),
    );
  }
}

/// Bingkai halaman A4 landscape (rasio 1040 : 720) yang menyesuaikan lebar
/// layar ponsel. Isi halaman diskalakan agar tetap terbaca.
class _CertPageShell extends StatelessWidget {
  const _CertPageShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return LayoutBuilder(
      builder: (context, constraints) {
        const canvasWidth = 1040.0;
        const canvasHeight = 720.0;
        final scale = constraints.maxWidth / canvasWidth;
        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: p.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          height: canvasHeight * scale,
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

/// Palet tetap halaman piagam (dokumen cetak selalu terang, tidak ikut mode
/// gelap aplikasi — sama seperti PDF hasil cetak di web).
const _docSurface = Color(0xFFFFFFFF);
const _docNavy = Color(0xFF161B27);
const _docSlate = Color(0xFF2B303D);
const _docPrimary = Color(0xFF2F6FED);
const _docText = Color(0xFF1F2430);
const _docMuted = Color(0xFF5B6475);
const _docOutline = Color(0xFFE4E1D9);
const _docSurfaceAlt = Color(0xFFF1EFE9);
const _docSuccess = Color(0xFF2FA36B);
const _docAccent = Color(0xFFFFC145);

/// HALAMAN 1 — Piagam Kompetensi Kelulusan (A4 landscape, kanvas 1040×720).
class _CertificateFrontPage extends StatelessWidget {
  const _CertificateFrontPage({required this.data, required this.doc});

  final CertificateVerification data;
  final CertificateDocLabels doc;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isChallenge = data.isChallenge;
    final issued = data.issuedAt;
    final valid = data.validUntil;

    return Container(
      color: _docSurface,
      child: Stack(
        children: [
          // Bingkai navy tebal + garis slate tipis.
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: _docNavy, width: 10),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(color: _docSlate, width: 1.5),
              ),
            ),
          ),
          // Pita segel kanan atas.
          Positioned(
            top: 0,
            right: 56,
            child: Container(
              width: 176,
              padding: const EdgeInsets.fromLTRB(12, 22, 12, 18),
              color: _docNavy,
              child: Column(
                children: [
                  Text(
                    isChallenge ? doc.ribbonChallenge : doc.ribbonModule,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      color: Colors.white,
                      fontSize: 12.5,
                      height: 1.35,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: 104,
                    height: 104,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.4,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'VERIFIED',
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            color: Color(0xCCFFFFFF),
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        Text(
                          'AI',
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            color: Colors.white,
                            fontSize: 24,
                            height: 1.1,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'CODELAB',
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            color: Color(0xE6FFFFFF),
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Isi utama.
          Padding(
            padding: const EdgeInsets.fromLTRB(34, 30, 34, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kepala: logo + nama brand + akreditasi, nomor sertifikat.
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: _docNavy,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.terminal_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  'CodeLab',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sans,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: _docNavy,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                                Text(
                                  'AI',
                                  style: TextStyle(
                                    fontFamily: AppFonts.sans,
                                    fontSize: 21,
                                    fontWeight: FontWeight.w800,
                                    color: _docPrimary,
                                    letterSpacing: -0.6,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              doc.platformTagline,
                              style: const TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: 9.5,
                                color: _docMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Container(width: 1.5, height: 26, color: _docOutline),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.workspace_premium_rounded,
                          size: 18,
                          color: _docPrimary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isChallenge
                              ? 'Automated Judge Verified'
                              : doc.accreditationValue,
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: _docText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _docNavy,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: _docAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Text(
                                data.certId,
                                style: const TextStyle(
                                  fontFamily: AppFonts.mono,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isChallenge
                                ? _docAccent.withValues(alpha: 0.2)
                                : _docPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isChallenge ? doc.kindChallenge : doc.kindModule,
                            style: TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: isChallenge
                                  ? const Color(0xFF7C5800)
                                  : _docPrimary,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Tengah: penerima, kalimat kelulusan, judul, chip metadata.
                SizedBox(
                  width: 700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.certGivenTo,
                        style: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 13,
                          color: _docMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.student.name.isEmpty
                            ? l10n.profileNewStudent
                            : data.student.name,
                        style: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 40,
                          height: 1.12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.0,
                          color: _docPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isChallenge
                            ? doc.completionChallenge
                            : doc.completionModule,
                        style: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 12,
                          color: _docMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data.description.isEmpty
                            ? data.topic
                            : '${data.topic}: ${data.description}',
                        style: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 20,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: _docPrimary,
                        ),
                      ),
                      const SizedBox(height: 13),
                      Wrap(
                        spacing: 7,
                        runSpacing: 7,
                        children: [
                          _DocChip(
                            bold: isChallenge
                                ? doc.rewardAndDuration
                                : doc.accreditation,
                            text: isChallenge
                                ? '+${data.xpReward} XP (${data.estimatedMinutes} ${_minuteUnit(doc.languageCode)})'
                                : '${data.accreditationJp} ${_jpUnit(doc.languageCode)} (${data.effectiveJp} JP)',
                          ),
                          _DocChip(bold: doc.level, text: _levelLabel(data.level)),
                          _DocChip(
                            bold: doc.predicate,
                            text: doc.predicateValue,
                            success: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Kaki: tanda tangan + QR verifikasi.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _dateLabel(issued),
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _docMuted,
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          height: 52,
                          child: CustomPaint(
                            painter: _SignaturePainter(),
                          ),
                        ),
                        const Text(
                          'Devwan Hidayawan',
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: _docText,
                          ),
                        ),
                        Text(
                          doc.instructorRole,
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 10,
                            color: _docMuted,
                          ),
                        ),
                        Text(
                          'CodeLab AI: ${doc.platformTagline}',
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 10,
                            color: _docMuted,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _docOutline),
                            ),
                            child: _DynamicQr(certId: data.certId),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            doc.verifyHeading,
                            style: const TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: _docText,
                            ),
                          ),
                          Text(
                            'https://api.codelab-ai.web.id/verify/${data.certId}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: AppFonts.mono,
                              fontSize: 9.5,
                              color: _docMuted,
                              decoration: TextDecoration.underline,
                              decorationStyle: TextDecorationStyle.dotted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${doc.validUntil} ${_dateLabel(valid)}',
                            style: const TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 10,
                              color: _docMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// HALAMAN 2 — Transkrip silabus (modul) atau evaluasi tantangan.
class _CertificateBackPage extends StatelessWidget {
  const _CertificateBackPage({required this.data, required this.doc});

  final CertificateVerification data;
  final CertificateDocLabels doc;

  @override
  Widget build(BuildContext context) {
    final isChallenge = data.isChallenge;
    final chapters = data.chapters;

    return Container(
      color: _docSurface,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: _docOutline, width: 2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 36, 36, 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Kepala halaman 2.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: _docPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: _docPrimary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.terminal_rounded,
                              size: 18,
                              color: _docPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        const Text(
                          'CodeLab',
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _docText,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const Text(
                          'AI',
                          style: TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: _docPrimary,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isChallenge
                              ? doc.challengeAttachment
                              : doc.moduleAttachment,
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 10.5,
                            color: _docMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      doc.pageOf,
                      style: const TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: _docMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: _docOutline),
                const SizedBox(height: 12),

                // Pasangan logo + topik.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: _docPrimary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: _docPrimary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.terminal_rounded,
                          size: 22,
                          color: _docPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'CodeLab',
                      style: TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: _docText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'AI',
                      style: TextStyle(
                        fontFamily: AppFonts.sans,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: _docPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Container(width: 1, height: 30, color: _docOutline),
                    const SizedBox(width: 30),
                    Container(
                      width: 38,
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _docSurfaceAlt,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.data_object_rounded,
                        size: 20,
                        color: _docPrimary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.topic,
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _docText,
                          ),
                        ),
                        Text(
                          isChallenge
                              ? '${data.category} • ${data.difficulty}'
                              : '${doc.curriculumTag} • ${chapters.length} ${_chapterUnit(doc.languageCode)}',
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: _docMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Ringkasan.
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _docSurfaceAlt.withValues(alpha: 0.62),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _summaryText(data, doc),
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontFamily: AppFonts.sans,
                      fontSize: 11.4,
                      height: 1.6,
                      color: _docText,
                    ),
                  ),
                ),
                const SizedBox(height: 11),

                // Daftar bab / kriteria uji.
                Text(
                  isChallenge ? doc.criteriaHeading : doc.chaptersCompleted,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: _docText,
                  ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: isChallenge
                      ? _ChallengeCriteriaList(data: data, doc: doc)
                      : _ChapterList(chapters: chapters, doc: doc),
                ),

                // Evaluasi: MODUL hanya menyebut 7 tipe slide interaktif
                // (tanpa tantangan/unit test); TANTANGAN menyebut sandbox +
                // kelulusan test case 100%.
                const SizedBox(height: 6),
                Text(
                  isChallenge ? doc.evalChallenge : doc.evalModule,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: _docText,
                  ),
                ),
                const SizedBox(height: 3),
                for (final line in _evaluationLines(data, doc))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 4, right: 6),
                          child: Icon(
                            Icons.circle,
                            size: 4,
                            color: _docPrimary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 10.4,
                              height: 1.45,
                              color: _docText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Footer metadata.
                Container(height: 1, color: _docOutline),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _DocChip(
                            bold: isChallenge
                                ? doc.durationAndScore
                                : doc.totalEffective,
                            text: isChallenge
                                ? '${data.estimatedMinutes} ${_minuteUnit(doc.languageCode)} • 100/100'
                                : '${data.effectiveJp} ${_jpUnit(doc.languageCode)} (JP)',
                          ),
                          _DocChip(
                            bold: '',
                            text: isChallenge
                                ? 'Automated Judge Verified (+${data.xpReward} XP)'
                                : '${doc.accreditationValue} (${data.accreditationJp} JP)',
                            success: true,
                          ),
                          _DocChip(bold: doc.level, text: _levelLabel(data.level)),
                          _DocChip(
                            bold: doc.predicate,
                            text: doc.predicateValue,
                            success: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          doc.instructorFooter,
                          style: const TextStyle(
                            fontFamily: AppFonts.sans,
                            fontSize: 9.5,
                            color: _docMuted,
                          ),
                        ),
                        Text(
                          'REG: ${data.certId}',
                          style: const TextStyle(
                            fontFamily: AppFonts.mono,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: _docText,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Daftar bab modul: mode ringkas (judul + durasi) bila lebih dari 6 bab agar
/// tetap muat satu halaman A4 landscape, sama seperti kanvas PDF di web.
class _ChapterList extends StatelessWidget {
  const _ChapterList({required this.chapters, required this.doc});

  final List<CertificateChapter> chapters;
  final CertificateDocLabels doc;

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return Center(
        child: Text(
          doc.syllabusUnavailable,
          style: const TextStyle(fontFamily: AppFonts.sans, color: _docMuted),
        ),
      );
    }
    final compact = chapters.length > 6;
    if (compact) {
      return SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < chapters.length; i += 2)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: _ChapterRow(chapter: chapters[i], doc: doc),
                    ),
                    const SizedBox(width: 22),
                    Expanded(
                      child: i + 1 < chapters.length
                          ? _ChapterRow(chapter: chapters[i + 1], doc: doc)
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final c in chapters)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 3, right: 7),
                    child: Icon(Icons.circle, size: 5, color: _docPrimary),
                  ),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: c.title,
                            style: const TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 10.9,
                              fontWeight: FontWeight.w800,
                              color: _docText,
                            ),
                          ),
                          if (c.description.isNotEmpty)
                            TextSpan(
                              text: ' : ${c.description}',
                              style: const TextStyle(
                                fontFamily: AppFonts.sans,
                                fontSize: 10.9,
                                color: _docMuted,
                              ),
                            ),
                          TextSpan(
                            text:
                                '  (${_minutesLabel(c.minutes, doc.languageCode)})',
                            style: const TextStyle(
                              fontFamily: AppFonts.sans,
                              fontSize: 10,
                              color: _docMuted,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChapterRow extends StatelessWidget {
  const _ChapterRow({required this.chapter, required this.doc});

  final CertificateChapter chapter;
  final CertificateDocLabels doc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, size: 5, color: _docPrimary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            chapter.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: AppFonts.sans,
              fontSize: 10.8,
              fontWeight: FontWeight.w800,
              color: _docText,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _minutesLabel(chapter.minutes, doc.languageCode),
          style: const TextStyle(
            fontFamily: AppFonts.sans,
            fontSize: 9.8,
            color: _docMuted,
          ),
        ),
      ],
    );
  }
}

/// Daftar aturan + test case untuk sertifikat tantangan.
class _ChallengeCriteriaList extends StatelessWidget {
  const _ChallengeCriteriaList({required this.data, required this.doc});

  final CertificateVerification data;
  final CertificateDocLabels doc;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < data.rules.length; i++) {
      final rule = data.rules[i];
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                rule.positive
                    ? Icons.check_circle_rounded
                    : Icons.cancel_rounded,
                size: 11,
                color: rule.positive ? _docPrimary : const Color(0xFFD93F45),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${doc.rulePrefix} ${i + 1}: ',
                        style: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 10.9,
                          fontWeight: FontWeight.w800,
                          color: _docText,
                        ),
                      ),
                      TextSpan(
                        text: rule.text,
                        style: const TextStyle(
                          fontFamily: AppFonts.sans,
                          fontSize: 10.9,
                          color: _docText,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
    }
    for (final tc in data.testCases) {
      final kind = tc.hidden ? doc.hiddenTestCase : doc.publicTestCase;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 11,
                color: _docSuccess,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${tc.title} — $kind • 100/100',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: AppFonts.sans,
                    fontSize: 10.7,
                    color: _docText,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows),
    );
  }
}

/// QR Code dinamis pada piagam: gambar PNG yang dirender server dari nomor
/// sertifikat (GET /verify/qr/{certId}). Bila gagal dimuat (mis. offline),
/// tampil ikon QR netral agar dokumen tetap rapi — nomor & tautan verifikasi
/// tetap tercetak di sebelahnya.
class _DynamicQr extends StatelessWidget {
  const _DynamicQr({required this.certId});

  final String certId;

  @override
  Widget build(BuildContext context) {
    final url = CertificateLinks.qrImage(certId);
    const fallback = Icon(
      Icons.qr_code_2_rounded,
      size: 84,
      color: _docNavy,
    );
    if (url.isEmpty) return fallback;
    return Image.network(
      url,
      width: 84,
      height: 84,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.none,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => fallback,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : fallback,
    );
  }
}

/// Chip metadata abu-abu pada dokumen (bukan chip interaktif aplikasi).
class _DocChip extends StatelessWidget {
  const _DocChip({
    required this.bold,
    required this.text,
    this.success = false,
  });

  final String bold;
  final String text;
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? _docSuccess : _docText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: success
            ? _docSuccess.withValues(alpha: 0.1)
            : _docSurfaceAlt,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            if (bold.isNotEmpty)
              TextSpan(
                text: '$bold ',
                style: TextStyle(
                  fontFamily: AppFonts.sans,
                  fontSize: 10.2,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            TextSpan(
              text: text,
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 10.2,
                fontWeight: success ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tanda tangan vektor replika (kurva Bezier), sama dengan prototipe.
class _SignaturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _docText
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final scaleX = size.width / 220;
    final scaleY = size.height / 70;
    canvas.save();
    canvas.scale(scaleX, scaleY);

    final main = Path()
      ..moveTo(12, 52)
      ..cubicTo(28, 15, 34, 8, 42, 22)
      ..cubicTo(50, 36, 52, 58, 65, 30)
      ..cubicTo(72, 15, 82, 20, 88, 35)
      ..cubicTo(94, 50, 102, 44, 114, 26)
      ..cubicTo(122, 14, 134, 22, 138, 38)
      ..cubicTo(142, 54, 158, 28, 168, 22)
      ..cubicTo(176, 18, 192, 14, 206, 18);
    canvas.drawPath(main, paint);

    final underline = Path()
      ..moveTo(28, 38)
      ..cubicTo(65, 34, 120, 32, 185, 36);
    canvas.drawPath(
      underline,
      Paint()
        ..color = _docText.withValues(alpha: 0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round,
    );

    final flourish = Path()
      ..moveTo(45, 42)
      ..quadraticBezierTo(70, 56, 105, 48);
    canvas.drawPath(
      flourish,
      Paint()
        ..color = _docText.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Menambahkan parameter `lang` pada tautan verifikasi agar halaman cetak web
/// memakai bahasa yang sama dengan aplikasi (id/en).
String _withLangParam(String url, String lang) {
  final uri = Uri.tryParse(url);
  if (uri == null) return url;
  if (uri.queryParameters.containsKey('lang')) return url;
  return uri.replace(queryParameters: {...uri.queryParameters, 'lang': lang})
      .toString();
}

/// Kalimat ringkasan halaman 2 — modul TIDAK menyebut tantangan/unit test.
String _summaryText(CertificateVerification data, CertificateDocLabels doc) {
  if (doc.languageCode == 'en') {
    if (data.isChallenge) {
      final criteria = data.rules.length + data.testCases.length;
      return 'Coding Challenge ${data.topic} (${data.category}) on CodeLab AI evaluates '
          'practical problem-solving: ${data.instruction} The submitted solution was '
          'verified automatically and passed all $criteria validation criteria and '
          'automated test cases (public + hidden) with a perfect score of 100/100 '
          '(+${data.xpReward} XP).';
    }
    return 'The ${data.topic} interactive learning module (${_levelLabel(data.level, 'en')}) '
        'on CodeLab AI focuses on mastering core competencies: ${data.description}. '
        'Through a structured syllabus of ${data.chapters.length} chapters '
        '(${data.effectiveJp} effective hours / ${data.accreditationJp} accredited hours), '
        'the student mastered theoretical slides, interactive exercises (Tap-to-Fill, '
        'Bug Hunter, Output Predict, Type Code), and chapter mastery quizzes.';
  }
  if (doc.languageCode == 'ar') {
    if (data.isChallenge) {
      final criteria = data.rules.length + data.testCases.length;
      return 'تحدي البرمجة ${data.topic} (${data.category}) على منصة CodeLab AI يقيس مهارة '
          'حل المشكلات البرمجية مباشرة: ${data.instruction} تم التحقق من الحل آليًا '
          'ونجح في جميع $criteria من المعايير وحالات الاختبار (عامة ومخفية) بدرجة '
          'كاملة 100/100 (+${data.xpReward} XP).';
    }
    return 'يركّز المودول التعليمي التفاعلي ${data.topic} على منصة CodeLab AI على إتقان '
        'الكفاءات الأساسية: ${data.description}. عبر منهج منظم من ${data.chapters.length} '
        'فصول (${data.effectiveJp} ساعة فعلية / ${data.accreditationJp} ساعة معتمدة)، '
        'درس الطالب النظريات والتمارين التفاعلية (Tap-to-Fill، Bug Hunter، Output Predict، '
        'Type Code) واختبارات إتقان كل فصل.';
  }
  if (data.isChallenge) {
    final criteria = data.rules.length + data.testCases.length;
    return 'Tantangan Koding ${data.topic} (${data.category}) pada platform CodeLab AI '
        'menguji kemampuan pemecahan masalah algoritmik secara langsung: ${data.instruction} '
        'Kode solusi siswa telah diverifikasi otomatis dan lulus seluruh $criteria kriteria '
        '& kasus uji (public + hidden test cases) dengan skor sempurna 100/100 '
        '(+${data.xpReward} XP).';
  }
  return 'Modul pembelajaran interaktif ${data.topic} tingkat ${_levelLabel(data.level, 'id')} '
      'pada platform CodeLab AI ini memfokuskan siswa pada penguasaan kompetensi: '
      '${data.description}. Melalui silabus terstruktur sebanyak ${data.chapters.length} bab '
      '(${data.effectiveJp} jam pelajaran efektif / ${data.accreditationJp} JP akreditasi), '
      'siswa mempelajari materi teori bertahap, latihan interaktif per slide (Tap-to-Fill, '
      'Bug Hunter, Output Predict, Type Code), serta evaluasi kuis pemahaman di setiap '
      'akhir bab.';
}

/// Daftar butir evaluasi halaman 2. Modul hanya membahas 7 tipe slide
/// interaktif; tantangan hanya membahas sandbox + kelulusan test case.
List<String> _evaluationLines(
  CertificateVerification data,
  CertificateDocLabels doc,
) {
  final en = doc.languageCode == 'en';
  final ar = doc.languageCode == 'ar';
  if (data.isChallenge) {
    if (en) {
      return const [
        'Automated code execution in an isolated Python 3 sandbox environment',
        '100% pass rate on public and hidden test cases (submissions.score = 100)',
      ];
    }
    if (ar) {
      return const [
        'تنفيذ آلي للكود في بيئة Python 3 معزولة',
        'نجاح 100% في جميع حالات الاختبار العامة والمخفية (submissions.score = 100)',
      ];
    }
    return const [
      'Eksekusi kode program otomatis pada lingkungan sandbox Python 3 terisolasi',
      'Kelulusan 100% pada seluruh Public Test Cases maupun Hidden Test Cases (submissions.score = 100)',
    ];
  }
  if (en) {
    return [
      'Interactive learning across 7 slide types per chapter (Theory, Tap-to-Fill, Bug Hunter, Output Predict, Type Code, Quiz, Summary)',
      '100% completion of chapter mastery quizzes across all ${data.chapters.length} syllabus chapters',
    ];
  }
  if (ar) {
    return [
      'تعلّم تفاعلي عبر 7 أنواع من الشرائح في كل فصل (Theory، Tap-to-Fill، Bug Hunter، Output Predict، Type Code، Quiz، Outro)',
      'إتمام 100% لاختبارات إتقان المفاهيم في جميع ${data.chapters.length} فصول المنهج',
    ];
  }
  return [
    'Pembelajaran interaktif 7 tipe slide per bab (Theory, Tap-to-Fill, Bug Hunter, Output Predict, Type Code, Quiz, Outro)',
    'Ketuntasan 100% evaluasi kuis pemahaman konsep pada seluruh ${data.chapters.length} bab silabus modul',
  ];
}

String _levelLabel(String raw, [String lang = 'id']) {
  final advanced = const {'advanced', 'mahir', 'hard', 'sulit'}.contains(
    raw.toLowerCase(),
  );
  final intermediate = const {
    'intermediate',
    'menengah',
    'medium',
  }.contains(raw.toLowerCase());
  if (lang == 'en') {
    if (advanced) return 'Advanced';
    if (intermediate) return 'Intermediate';
    return 'Beginner';
  }
  if (lang == 'ar') {
    if (advanced) return 'متقدم';
    if (intermediate) return 'متوسط';
    return 'مبتدئ';
  }
  if (advanced) return 'Mahir';
  if (intermediate) return 'Menengah';
  return 'Pemula';
}

/// Satuan durasi sesuai bahasa dokumen.
String _minuteUnit(String lang) => lang == 'en' ? 'min' : (lang == 'ar' ? 'دقيقة' : 'menit');
String _hourUnit(String lang) => lang == 'en' ? 'hr' : (lang == 'ar' ? 'ساعة' : 'jam');
String _jpUnit(String lang) => lang == 'en' ? 'Accredited Hours' : (lang == 'ar' ? 'ساعة معتمدة' : 'Jam Pelajaran');
String _chapterUnit(String lang) => lang == 'en' ? 'Chapters' : (lang == 'ar' ? 'فصول' : 'Bab');

/// Durasi bab tanpa "00 menit": 120 → "2 jam", 150 → "2 jam 30 menit".
String _minutesLabel(int total, [String lang = 'id']) {
  if (total <= 0) return '—';
  final h = total ~/ 60;
  final m = total % 60;
  final parts = <String>[];
  if (h > 0) parts.add('$h ${_hourUnit(lang)}');
  if (m > 0) parts.add('$m ${_minuteUnit(lang)}');
  return parts.join(' ');
}

const _monthNames = <String>[
  '',
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];

String _dateLabel(DateTime? date) {
  if (date == null) return '—';
  final local = date.toLocal();
  return '${local.day} ${_monthNames[local.month]} ${local.year}';
}
