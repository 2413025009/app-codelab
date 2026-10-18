import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../domain/challenge_repository.dart';

/// Result sheet shown after "Kirim Solusi" (stitch: Hasil Evaluasi Akhir v2).
Future<void> showEvaluationSheet(
  BuildContext context, {
  required RunReport report,
  int xpEarned = 0,
  required VoidCallback onHistory,
  required VoidCallback onBackToCatalog,
}) {
  return showAppSheet<void>(
    context,
    title: 'Evaluasi Proyek',
    fullHeight: true,
    builder: (ctx) => _EvaluationBody(
      report: report,
      xpEarned: xpEarned,
      onHistory: () {
        Navigator.of(ctx).pop();
        onHistory();
      },
      onBack: () {
        Navigator.of(ctx).pop();
        onBackToCatalog();
      },
    ),
  );
}

class _EvaluationBody extends StatefulWidget {
  const _EvaluationBody({
    required this.report,
    required this.xpEarned,
    required this.onHistory,
    required this.onBack,
  });

  final RunReport report;
  final int xpEarned;
  final VoidCallback onHistory;
  final VoidCallback onBack;

  @override
  State<_EvaluationBody> createState() => _EvaluationBodyState();
}

class _EvaluationBodyState extends State<_EvaluationBody> {
  int _cooldown = 15;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_cooldown > 0) {
        setState(() => _cooldown--);
      } else {
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ok = widget.report.allPassed;
    final accent = ok ? p.success : p.error;

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: accent.withValues(alpha: 0.3), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(ok ? Icons.check_rounded : Icons.error_outline_rounded, color: Colors.white, size: 36),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          ok ? 'Solusi Diterima!' : 'Solusi Belum Berhasil',
          textAlign: TextAlign.center,
          style: AppTypography.titleL.copyWith(color: p.text, fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          ok
              ? 'Seluruh pengujian publik dan tersembunyi berhasil dilewati tanpa kendala.'
              : 'Jangan patah semangat! ${widget.report.passedCount} dari ${widget.report.results.length} pengujian berhasil. Mari kita telaah kesalahan dan perbaiki bersama AI Tutor.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyM.copyWith(color: p.textMuted, height: 1.45),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Metric Box (nilai akhir + waktu eksekusi) — metrik memori/fiktif
        // dihapus; angka yang tampil adalah yang diukur server secara nyata.
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: p.outline),
            boxShadow: const [
              BoxShadow(color: Color(0x06000000), blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _Metric(
                  label: 'NILAI AKHIR',
                  value: '${widget.report.score}',
                  suffix: '/100',
                  color: accent,
                  badge: ok ? 'Sempurna' : 'Perlu Perbaikan',
                  badgeColor: accent,
                ),
                VerticalDivider(color: p.outline, width: 1),
                _Metric(
                  label: 'EKSEKUSI',
                  value: (widget.report.millis / 1000).toStringAsFixed(2),
                  suffix: ' dtk',
                  badge: 'Cepat',
                  badgeColor: p.success,
                  badgeIcon: Icons.bolt_rounded,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Automated Test Results Header
        Row(
          children: [
            Expanded(
              child: Text(
                'HASIL PENGUJIAN OTOMATIS',
                style: AppTypography.label.copyWith(color: p.textMuted, letterSpacing: 0.6, fontSize: 11.5, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.2)),
              ),
              child: Text(
                '${widget.report.passedCount}/${widget.report.results.length} Lolos',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Test Cases List
        Container(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.outline),
          ),
          child: Column(
            children: [
              for (var i = 0; i < widget.report.results.length; i++) ...[
                if (i > 0) Divider(color: p.outline, height: 1),
                _ResultRow(result: widget.report.results[i]),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Competency Increment Card
        if (ok)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFFE4EDFF),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFC7D9FF)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: p.primary, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.verified_rounded, color: Colors.white, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text('Kompetensi Logika & Algoritma',
                                style: AppTypography.label.copyWith(color: p.text, fontSize: 13, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              widget.xpEarned > 0 ? '+${widget.xpEarned} XP' : '+5 Poin',
                              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: p.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Bukti empiris tercatat otomatis pada portofolio SMK-mu.',
                          style: TextStyle(fontSize: 11, color: p.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.sm),

        // Cooldown Submisi Compiler Notice
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3C7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('⏳', style: TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cooldown Submisi Compiler',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        style: const TextStyle(fontSize: 11, color: Color(0xFF92400E)),
                        children: [
                          if (_cooldown > 0) ...[
                            const TextSpan(text: 'Tunggu '),
                            TextSpan(
                              text: '$_cooldown',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: AppFonts.mono),
                            ),
                            const TextSpan(text: ' detik sebelum dapat mengirim submisi berikutnya untuk stabilitas sandbox container.'),
                          ] else
                            const TextSpan(text: 'Compiler siap menerima submisi kode baru.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        // Action Buttons
        AppButton(
          label: ok ? 'Lanjut ke Tantangan Berikutnya' : 'Perbaiki Solusi Koding',
          trailingIcon: Icons.arrow_forward_rounded,
          onPressed: ok ? widget.onBack : () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: AppSpacing.xs),
        AppButton(
          label: 'Lihat Riwayat Submisi',
          kind: AppButtonKind.text,
          trailingIcon: Icons.history_rounded,
          onPressed: widget.onHistory,
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.suffix,
    required this.badge,
    required this.badgeColor,
    this.color,
    this.badgeIcon,
  });

  final String label;
  final String value;
  final String suffix;
  final String badge;
  final Color badgeColor;
  final Color? color;
  final IconData? badgeIcon;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final c = color ?? p.text;
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TextStyle(color: p.textMuted, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
          const SizedBox(height: 4),
          Text.rich(TextSpan(children: [
            TextSpan(text: value, style: TextStyle(color: c, fontFamily: AppFonts.mono, fontSize: 20, fontWeight: FontWeight.bold)),
            TextSpan(text: suffix, style: TextStyle(color: p.textMuted, fontFamily: AppFonts.mono, fontSize: 11)),
          ])),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (badgeIcon != null) ...[
                Icon(badgeIcon, size: 12, color: badgeColor),
                const SizedBox(width: 2),
              ],
              Text(badge, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 10.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result});
  final TestCaseResult result;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final r = result;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Icon(
            r.hidden ? Icons.lock_outline_rounded : Icons.done_all_rounded,
            color: r.passed ? p.success : p.error,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        r.title,
                        style: AppTypography.label.copyWith(color: p.text, fontSize: 13.5, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (r.hidden) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE4EDFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Hidden',
                          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: p.primary),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  '${r.input} → ${r.output}',
                  style: AppTypography.code.copyWith(color: p.textMuted, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: r.passed ? const Color(0xFFECFDF5) : const Color(0xFFFFEBEB),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              r.passed ? 'Lolos' : 'Gagal',
              style: TextStyle(
                color: r.passed ? p.success : p.error,
                fontWeight: FontWeight.bold,
                fontSize: 11.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
