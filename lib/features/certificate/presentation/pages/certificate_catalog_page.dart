// FILE: lib/features/certificate/presentation/pages/certificate_catalog_page.dart
//
// TUGAS: layar "Katalog Sertifikat" (route `/katalog-sertifikat-siswa`).
//
// MENGAPA DIPISAH: sebelumnya seluruh daftar sertifikat modul & tantangan
// ditumpuk di halaman Profil, bercampur dengan kartu identitas, kelas, dan
// peta kompetensi. Layar ini menjadi satu tempat khusus untuk:
//   1. Ringkasan jumlah sertifikat yang siap diunduh.
//   2. Daftar sertifikat modul + tantangan beserta progres kelayakannya.
//   3. Aksi "Unduh PDF" yang langsung mengunduh dokumen 2 halaman dari
//      backend (bukan membuka halaman pratinjau HTML).
//   4. Aksi "Lihat" untuk membuka pratinjau `/sertifikat-kompetensi-siswa/:certId`.
//
// SUMBER DATA: GET /api/v1/me/certificates — tidak ada data tiruan.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/topic_icons.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/certificate_models.dart';
import '../../domain/certificate_repository.dart';
import '../certificate_actions.dart';

class CertificateCatalogPage extends StatefulWidget {
  const CertificateCatalogPage({super.key});

  @override
  State<CertificateCatalogPage> createState() => _CertificateCatalogPageState();
}

class _CertificateCatalogPageState extends State<CertificateCatalogPage> {
  late Future<MyCertificates> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<MyCertificates> _load() {
    return context.read<CertificateRepository>().getMyCertificates();
  }

  Future<void> _refresh() async {
    final future = _load();
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // FutureBuilder menampilkan galat jujur; RefreshIndicator cukup berhenti.
    }
  }

  void _retry() {
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(title: Text(l10n.certCatalogTitle)),
      body: FutureBuilder<MyCertificates>(
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
          if (snapshot.hasError || snapshot.data == null) {
            return _CatalogError(
              message: l10n.certLoadFailed,
              retryLabel: l10n.dashRetryButton,
              onRetry: _retry,
            );
          }
          return _CatalogBody(
            certificates: snapshot.data!,
            onRefresh: _refresh,
          );
        },
      ),
    );
  }
}

class _CatalogBody extends StatelessWidget {
  const _CatalogBody({
    required this.certificates,
    required this.onRefresh,
  });

  final MyCertificates certificates;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    final modules = [...certificates.moduleCertificates]
      ..sort((a, b) {
        final byReady = _ready(b).compareTo(_ready(a));
        return byReady != 0 ? byReady : a.topic.compareTo(b.topic);
      });
    final challenges = [...certificates.challengeCertificates]
      ..sort((a, b) {
        final byReady = _ready(b).compareTo(_ready(a));
        return byReady != 0 ? byReady : a.title.compareTo(b.title);
      });
    final readyCount =
        modules.where((m) => m.eligible && m.certId.trim().isNotEmpty).length +
        challenges
            .where((c) => c.eligible && c.certId.trim().isNotEmpty)
            .length;
    final isEmpty = modules.isEmpty && challenges.isEmpty;

    return AppRefresh(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.md,
          AppSpacing.screen,
          AppSpacing.xxl,
        ),
        children: [
          _ReadySummary(readyCount: readyCount),
          const SizedBox(height: AppSpacing.lg),
          if (isEmpty)
            _EmptyState(
              title: l10n.certEmptyTitle,
              body: l10n.certEmptyBody,
            )
          else ...[
            if (modules.isNotEmpty) ...[
              _SectionHeader(
                title: l10n.certModuleSectionTitle,
                count: modules.length,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final module in modules) ...[
                _ModuleCertificateCard(certificate: module),
                const SizedBox(height: AppSpacing.sm),
              ],
              const SizedBox(height: AppSpacing.md),
            ],
            if (challenges.isNotEmpty) ...[
              _SectionHeader(
                title: l10n.certChallengeSectionTitle,
                count: challenges.length,
              ),
              const SizedBox(height: AppSpacing.sm),
              for (final challenge in challenges) ...[
                _ChallengeCertificateCard(certificate: challenge),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ],
          if (!isEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.certPdfHint,
              style: AppTypography.caption.copyWith(color: p.textMuted),
            ),
          ],
        ],
      ),
    );
  }

  static int _ready(Object certificate) {
    if (certificate is ModuleCertificate) {
      return certificate.eligible && certificate.certId.trim().isNotEmpty
          ? 1
          : 0;
    }
    if (certificate is ChallengeCertificate) {
      return certificate.eligible && certificate.certId.trim().isNotEmpty
          ? 1
          : 0;
    }
    return 0;
  }
}

class _ReadySummary extends StatelessWidget {
  const _ReadySummary({required this.readyCount});

  final int readyCount;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.primary,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: p.primary.withValues(alpha: 0.24),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.certReadyCount(readyCount),
                  style: AppTypography.titleM.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  l10n.certCatalogSubtitle,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.35,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.titleM.copyWith(
              color: p.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(
            color: p.primaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: AppTypography.caption.copyWith(
              color: p.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModuleCertificateCard extends StatelessWidget {
  const _ModuleCertificateCard({required this.certificate});

  final ModuleCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final ready = certificate.eligible && certificate.certId.trim().isNotEmpty;
    final progress = (certificate.progressPercent / 100).clamp(0.0, 1.0);

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: ready
          ? () => openCertificatePreview(context, certificate.certId)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _CertificateIcon(
                icon: topicIcon(certificate.topic),
                active: ready,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.topic,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _moduleMeta(l10n, certificate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusPill(ready: ready),
            ],
          ),
          if (!ready) ...[
            const SizedBox(height: AppSpacing.md),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 7,
                backgroundColor: p.surfaceAlt,
                color: p.primary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.certChapterCountInline(
                    certificate.completedChapters,
                    certificate.totalChapters,
                  ),
                  style: AppTypography.caption.copyWith(color: p.textMuted),
                ),
                Text(
                  '${certificate.progressInt}%',
                  style: AppTypography.caption.copyWith(
                    color: p.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.md),
            _CertificateActions(certificateId: certificate.certId),
          ],
        ],
      ),
    );
  }

  static String _moduleMeta(
    AppLocalizations l10n,
    ModuleCertificate certificate,
  ) {
    final level = certificate.level.trim();
    final teacher = certificate.teacherName.trim();
    if (teacher.isNotEmpty) return '$level · $teacher';
    if (level.isNotEmpty) return level;
    return l10n.certModuleSectionTitle;
  }
}

class _ChallengeCertificateCard extends StatelessWidget {
  const _ChallengeCertificateCard({required this.certificate});

  final ChallengeCertificate certificate;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final ready = certificate.eligible && certificate.certId.trim().isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      onTap: ready
          ? () => openCertificatePreview(context, certificate.certId)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _CertificateIcon(
                icon: Icons.workspace_premium_outlined,
                active: ready,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _challengeMeta(l10n, certificate),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _StatusPill(ready: ready),
            ],
          ),
          if (ready) ...[
            const SizedBox(height: AppSpacing.md),
            _CertificateActions(certificateId: certificate.certId),
          ],
        ],
      ),
    );
  }

  static String _challengeMeta(
    AppLocalizations l10n,
    ChallengeCertificate certificate,
  ) {
    final category = certificate.category.trim();
    final difficulty = certificate.difficulty.trim();
    if (category.isNotEmpty && difficulty.isNotEmpty) {
      return '$category · $difficulty';
    }
    if (category.isNotEmpty) return category;
    if (difficulty.isNotEmpty) return difficulty;
    return l10n.certChallengeSectionTitle;
  }
}

class _CertificateActions extends StatelessWidget {
  const _CertificateActions({required this.certificateId});

  final String certificateId;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: l10n.certDownloadPdf,
            leadingIcon: Icons.download_rounded,
            onPressed: () => downloadCertificatePdf(context, certificateId),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Tooltip(
          message: l10n.certOpenPreview,
          child: SizedBox(
            width: AppSizes.buttonHeight,
            height: AppSizes.buttonHeight,
            child: Material(
              color: p.surfaceAlt,
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () =>
                    openCertificatePreview(context, certificateId),
                child: Icon(
                  Icons.visibility_outlined,
                  color: p.text,
                  size: 21,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CertificateIcon extends StatelessWidget {
  const _CertificateIcon({required this.icon, required this.active});

  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: active
            ? p.success.withValues(alpha: 0.14)
            : p.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: active ? p.success : p.primary,
        size: 22,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.ready});

  final bool ready;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final color = ready ? p.success : p.textMuted;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        ready ? l10n.profileCertReady : l10n.certNotEligibleShort,
        style: AppTypography.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: p.primaryContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.workspace_premium_outlined,
              color: p.primary,
              size: 34,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.titleM.copyWith(
              color: p.text,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            body,
            textAlign: TextAlign.center,
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
        ],
      ),
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({
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
            Icon(Icons.cloud_off_outlined, size: 44, color: p.textMuted),
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
