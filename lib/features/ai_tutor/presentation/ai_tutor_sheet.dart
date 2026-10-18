import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../challenges/domain/challenge_exceptions.dart';
import '../domain/tutor_models.dart';
import '../domain/tutor_repository.dart';

/// Opens the CodeLab AI Tutor bottom sheet (scaffolded hints, Socratic method).
///
/// [challengeId] + [getCode] mengaktifkan backend nyata (P0-6): tiap buka hint
/// memanggil POST /tutor/hint dengan kuota 5x/hari dari server. Saat tanpa
/// backend (offline/demo), sheet jatuh ke script statis [script].
Future<void> showAiTutorSheet(
  BuildContext context, {
  TutorScript script = TutorScript.kkm,
  String? challengeId,
  String Function()? getCode,
  String? errorMessage,
}) {
  final quota = context.read<TutorQuota>();
  final tutorRepo = context.read<TutorRepository?>();
  return showAppSheet<void>(
    context,
    title: 'CodeLab AI Tutor',
    subtitle: 'Scaffolding & Pendamping Belajar',
    leadingIcon: Icons.smart_toy_outlined,
    builder: (_) => AiTutorBody(
      script: script,
      quota: quota,
      tutorRepo: challengeId != null ? tutorRepo : null,
      challengeId: challengeId,
      getCode: getCode,
      errorMessage: errorMessage,
    ),
  );
}

class AiTutorBody extends StatefulWidget {
  const AiTutorBody({
    super.key,
    required this.script,
    required this.quota,
    this.tutorRepo,
    this.challengeId,
    this.getCode,
    this.errorMessage,
  });

  final TutorScript script;
  final TutorQuota quota;

  /// Bila null: mode demo offline (script statis + kuota in-memory).
  final TutorRepository? tutorRepo;
  final String? challengeId;
  final String Function()? getCode;
  final String? errorMessage;

  @override
  State<AiTutorBody> createState() => _AiTutorBodyState();
}

class _AiTutorBodyState extends State<AiTutorBody> {
  int _unlocked = 1; // number of hints available
  int _selected = 0;
  // Ini bukan daftar yang diganti-referensinya — isi slot diganti inplace
  // ketika backend mengirim versi personal, jadi daftarnya bisa final.
  final List<TutorHint> _hints = [];
  bool _fetching = false;

  @override
  void initState() {
    super.initState();
    _hints.addAll(widget.script.hints);
    widget.quota.addListener(_refresh);
    // Buka kuota asli server DULU (tanpa konsumsi) sebelum hint pertama —
    // pill "Sisa kuota" jangan menebak.
    if (widget.tutorRepo != null) _syncQuotaOnce();
  }

  @override
  void dispose() {
    widget.quota.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  bool get _backendMode => widget.tutorRepo != null;

  Future<void> _syncQuotaOnce() async {
    try {
      final snap = await widget.tutorRepo!.getQuota();
      if (!mounted) return;
      widget.quota.syncFromServer(used: snap.used, limit: snap.limit);
    } catch (_) {
      // Kegagalan baca kuota tidak boleh menutup sheet; pill tetap
      // memakai nilai terakhir sampai hint pertama membalas angka server.
    }
  }

  /// Slot demo offline: konsumsi kuota lokal lalu buka hint statis.
  bool _unlockOfflineSlot() {
    if (!widget.quota.consume()) {
      showAppSnack(context, 'Kuota hint hari ini habis. Coba lagi besok.');
      return false;
    }
    setState(() {
      _unlocked++;
      _selected = _unlocked - 1;
    });
    return true;
  }

  Future<void> _unlockNext() async {
    final nextIndex = _unlocked;
    if (nextIndex >= _hints.length) return;

    // Mode demo (tanpa context challenge): kuota in-memory + script statis.
    if (!_backendMode) {
      _unlockOfflineSlot();
      return;
    }

    setState(() => _fetching = true);
    try {
      final result = await widget.tutorRepo!.fetchHint(
        challengeId: widget.challengeId!,
        studentCode: widget.getCode?.call() ?? '',
        hintLevel: nextIndex + 1,
        errorMessage: widget.errorMessage,
      );
      if (!mounted) return;
      // Sinkronisasi kuota dari angka resmi server (P0-6).
      widget.quota.syncFromServer(used: result.quotaUsed, limit: result.quotaLimit);
      setState(() {
        _hints[nextIndex] = result.hint;
        _unlocked++;
        _selected = _unlocked - 1;
      });
    } on ApiChallengeException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 429 || e.isCooldown) {
        widget.quota.exhaust();
        showAppSnack(context, 'Kuota petunjuk hari ini sudah habis. Coba lagi besok untuk berlatih mandiri.');
      } else {
        showAppSnack(context, e.message);
      }
    } on DioException catch (e) {
      if (!mounted) return;
      if (!ApiClient.isNetworkError(e)) {
        // Kegagalan selain jaringan (payload dsb.) → jujur: tanpa fallback,
        // tanpa konsumsi kuota — penyelundupan tidak boleh jadi siluman data.
        showAppSnack(context, 'Petunjuk gagal disiapkan. Coba lagi sebentar.');
        return;
      }
      // Server sungguh tak terjangkau → demo statis dengan slot lokal.
      if (_unlockOfflineSlot()) {
        showAppSnack(context, 'Server petunjuk sedang tidak dapat dihubungi — menampilkan petunjuk bawaan.');
      }
    } catch (_) {
      if (!mounted) return;
      // Error tak terduga: jujur dan jangan buka hint — tidak boleh
      // menyusup melakukan konsumsi kuota palsu.
      showAppSnack(context, 'Petunjuk gagal disiapkan. Coba lagi sebentar.');
    } finally {
      if (mounted) setState(() => _fetching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final hints = _hints;
    final hint = hints[_selected.clamp(0, hints.length - 1)];
    final hasNext = _unlocked < hints.length;

    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(AppSpacing.screen),
      children: [
        // Status row
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: p.primaryContainer, borderRadius: BorderRadius.circular(14)),
                  child: Row(
                    children: [
                      Icon(Icons.psychology_alt_outlined, size: 18, color: p.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('Konsep: ${widget.script.concept}',
                            style: AppTypography.label.copyWith(color: p.primary, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(color: p.successContainer, borderRadius: AppRadius.pillBorder),
                child: Text('Level $_unlocked/${hints.length}',
                    style: AppTypography.caption.copyWith(color: p.success, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Sisa kuota', style: AppTypography.caption.copyWith(color: p.textMuted)),
                  Text('${widget.quota.remaining}/${widget.quota.total}',
                      style: AppTypography.label.copyWith(color: p.text)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: p.primaryContainer, borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.lightbulb_outline_rounded, color: p.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Scaffolding Bertahap', style: AppTypography.titleM.copyWith(color: p.text, fontSize: 18))),
                  AppTagLabel(text: 'Metode Sokratik', color: p.surfaceAlt, fg: p.textMuted),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              _HintTabs(
                labels: [for (final h in hints) h.tabLabel],
                unlocked: _unlocked,
                selected: _selected,
                onSelect: (i) => setState(() => _selected = i),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: p.warningContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(left: BorderSide(color: p.primary, width: 4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates_outlined, size: 20, color: p.warningText),
                        const SizedBox(width: 8),
                        Text('PERTANYAAN PEMANTIK:',
                            style: AppTypography.caption.copyWith(color: p.text, fontWeight: FontWeight.w800, letterSpacing: 0.4)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text('“${hint.question}”',
                        style: AppTypography.bodyL.copyWith(color: p.text, fontStyle: FontStyle.italic)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: p.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('REKOMENDASI ALUR BERPIKIR',
                        style: AppTypography.caption.copyWith(color: p.textMuted, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                    const SizedBox(height: AppSpacing.md),
                    for (var i = 0; i < hint.steps.length; i++) ...[
                      if (i > 0) const SizedBox(height: AppSpacing.md),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 26,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: p.primaryContainer, shape: BoxShape.circle),
                            child: Text('${i + 1}', style: AppTypography.caption.copyWith(color: p.primary, fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(hint.steps[i], style: AppTypography.bodyL.copyWith(color: p.text, fontSize: 15))),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (hasNext) ...[
          AppButton(
            label: _fetching
                ? 'Menyiapkan petunjuk…'
                : 'Buka Hint Berikutnya (${hints[_unlocked].tabLabel.split(': ').last})',
            trailingIcon: _fetching ? null : Icons.arrow_forward_rounded,
            onPressed: _fetching ? null : (widget.quota.hasQuota ? _unlockNext : null),
          ),
          if (!_fetching && !widget.quota.hasQuota) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Kuota petunjuk harian sudah habis (maksimal 5x per hari sesuai PRD). '
              'Setiap beristirahat akan reset besok — sementara ini, tuntaskan di kodemu dulu.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyM.copyWith(color: p.error),
            ),
          ],
        ] else
          Text(
            'Semua hint sudah terbuka. Sekarang coba terapkan di kodemu.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
        const SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}

class AppTagLabel extends StatelessWidget {
  const AppTagLabel({super.key, required this.text, required this.color, required this.fg});
  final String text;
  final Color color;
  final Color fg;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: AppTypography.caption.copyWith(color: fg, fontWeight: FontWeight.w600)),
      );
}

class _HintTabs extends StatelessWidget {
  const _HintTabs({required this.labels, required this.unlocked, required this.selected, required this.onSelect});

  final List<String> labels;
  final int unlocked;
  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: Semantics(
                button: true,
                selected: i == selected,
                label: labels[i] + (i >= unlocked ? ', terkunci' : ''),
                child: GestureDetector(
                  onTap: i < unlocked ? () => onSelect(i) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    constraints: const BoxConstraints(minHeight: AppSizes.minTouch),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: i == selected ? p.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            labels[i].replaceFirst(': ', ': '),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.label.copyWith(
                              fontSize: 12,
                              color: i == selected ? p.primary : (i < unlocked ? p.textMuted : p.textMuted.withValues(alpha: 0.6)),
                            ),
                          ),
                        ),
                        if (i >= unlocked) ...[
                          const SizedBox(width: 4),
                          Icon(Icons.lock_outline_rounded, size: 14, color: p.textMuted.withValues(alpha: 0.6)),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
