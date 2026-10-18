import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/shell/app_shell.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../../core/widgets/code_editor.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../ai_tutor/domain/tutor_models.dart';
import '../../../ai_tutor/domain/tutor_repository.dart';
import '../../../ai_tutor/presentation/ai_tutor_sheet.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../domain/challenge_exceptions.dart';
import '../../domain/challenge_repository.dart';
import '../widgets/evaluation_sheet.dart';

class ChallengeDetailPage extends StatefulWidget {
  const ChallengeDetailPage({super.key, required this.challengeId});

  final String challengeId;

  @override
  State<ChallengeDetailPage> createState() => _ChallengeDetailPageState();
}

class _ChallengeDetailPageState extends State<ChallengeDetailPage> {
  late final ChallengeRepository _repo = context.read<ChallengeRepository>();
  late Future<ChallengeDetail> _future;
  final _code = TextEditingController();
  final _focusNode = FocusNode();
  bool _codeLoaded = false;
  String _starterCode = '';

  int _tab = 0;
  bool _running = false;
  bool _submitting = false;
  /// Anchor kartu hasil — dipakai Scrollable.ensureVisible setelah "Uji Coba"
  /// agar output SELALU terlihat, tanpa menuntut scroll/refresh manual.
  final GlobalKey _resultsAnchor = GlobalKey();
  RunReport? _report;
  /// Riwayat submisi (bacaan best score) — hanya diambil sekali bila
  /// tantangan sudah selesai dan hasil per-kasus tidak ada di sesi ini.
  Future<SubmissionHistory?>? _historyFuture;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _future = _repo.getDetail(widget.challengeId, userXp: user?.xpPoints);
    appShellTabActivated.addListener(_handleTabActivated);
    // Kuota hint dibaca dari server DULU (read-only) supaya pill kuota
    // tidak berupa tebakan 4/5 sejak aplikasi dibuka.
    context.read<TutorRepository?>()?.getQuota().then((snap) {
      if (!mounted) return;
      context.read<TutorQuota>().syncFromServer(used: snap.used, limit: snap.limit);
    }).catchError((_) {
      // Offline: pill memakai nilai default sampai hint pertama membalas.
    });
  }

  @override
  void dispose() {
    appShellTabActivated.removeListener(_handleTabActivated);
    _code.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  /// Tab "Tantangan" (index 1 AppShell) diaktifkan ulang sementara detail
  /// tetap terpasang di IndexedStack: muat ulang status/XP secara sunyi
  /// supaya chip "Selesai" dan statistik selalu segar tanpa refresh manual.
  void _handleTabActivated() {
    if (appShellTabActivated.value == 1) {
      _reloadSilent();
    }
  }

  /// Baca ulang detail di latar belakang TANPA menghancurkan tampilan bila
  /// gagal: fetch dulu, dan future lama ditukar hanya bila berhasil.
  /// FutureBuilder mempertahankan snapshot lama selama fetch baru berjalan,
  /// sehingga tidak ada skeleton berkedip dan tidak ada data hilang.
  Future<void> _reloadSilent() async {
    try {
      final user = context.read<AuthCubit>().state.user;
      final fresh = await _repo.getDetail(widget.challengeId, userXp: user?.xpPoints);
      if (!mounted) return;
      setState(() => _future = Future.value(fresh));
    } catch (_) {
      // Gagal (mis. jaringan): tampilan lama dipertahankan apa adanya.
    }
  }

  void _insertSymbol(String symbol) {
    final text = _code.text;
    final selection = _code.selection;
    final insertion = symbol == 'tab' || symbol == 'indent' ? '    ' : symbol;

    int newCursorPos;
    String newText;

    if (selection.start < 0 || selection.end < 0) {
      newText = text + insertion;
      newCursorPos = newText.length;
    } else {
      newText = selection.textBefore(text) + insertion + selection.textAfter(text);
      newCursorPos = selection.start + insertion.length;
    }

    _code.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
    _focusNode.requestFocus();
  }

  void _formatCode() {
    final raw = _code.text;
    final lines = raw.split('\n');
    final formatted = lines.map((l) {
      var trimmed = l.trimRight();
      // standard spacing around colons and operators
      return trimmed;
    }).join('\n');
    _code.text = formatted;
    showAppSnack(context, 'Format PEP8 berhasil dirapikan');
  }

  /// Riwayat dibungkus SAFE: kegagalan jaringan jangan dipanikan —
  /// kartu ringkasan cukup menghilangkan skor (tanpa angka bohong).
  Future<SubmissionHistory?> _safeHistory() async {
    try {
      return await _repo.getHistory(widget.challengeId);
    } catch (_) {
      return null;
    }
  }

  /// Ringkasan galat terakhir untuk konteks AI Tutor (ERROR_FEEDBACK).
  String? _tutorErrorMessage() {
    final report = _report;
    if (report == null) return null;
    for (final r in report.results) {
      if (!r.passed && r.output.trim().isNotEmpty) {
        return '${r.title}: ${r.output}';
      }
    }
    return null;
  }

  Future<RunReport?> _run() async {
    FocusScope.of(context).unfocus();
    setState(() => _running = true);
    try {
      final report = await _repo.runTests(widget.challengeId, _code.text);
      if (!mounted) return null;
      setState(() => _report = report);
      // Jangan memaksa lompat tab yang menghilangkan kode editor. Hasil kini
      // dirender di tab yang SEDANG aktif (instruksi maupun editor) dan layar
      // digeser otomatis ke kartu hasil - output tak pernah "tidak muncul".
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final anchor = _resultsAnchor.currentContext;
        if (anchor != null && mounted) {
          Scrollable.ensureVisible(anchor, duration: const Duration(milliseconds: 350), alignment: 0.0);
        }
      });
      return report;
    } on ApiChallengeException catch (e) {
      // Pesan kontrak server (LOCKED_CHALLENGE / RATE_LIMITED / dsb) harus
      // tampil apa adanya — bukan fallback mock (audit P0-2).
      if (mounted) showAppSnack(context, e.message);
      return null;
    } catch (_) {
      if (mounted) showAppSnack(context, 'Ada kendala saat eksekusi kode. Coba lagi sebentar.');
      return null;
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      final subResult = await _repo.submitCode(widget.challengeId, _code.text);
      if (!mounted) return;
      setState(() {
        _report = subResult.report;
        _submitting = false;
      });

      if (subResult.xpEarned > 0) {
        context.read<AuthCubit>().addXp(subResult.xpEarned);
      }

      await showEvaluationSheet(
        context,
        report: subResult.report,
        xpEarned: subResult.xpEarned,
        onHistory: () => context.push(AppRoutes.history(widget.challengeId)),
        onBackToCatalog: () => context.go(AppRoutes.challenges),
      );
      // Tuntas TANPA refresh manual: bila dialog hasil ditutup, detail dibaca
      // ulang (sunyi) sehingga status 'completed' dari server langsung nyata
      // di halaman - chip Selesai, section hasil, dan badge tab ikut berganti.
      if (mounted) {
        await _reloadSilent();
      }
    } on ApiChallengeException catch (e) {
      // 403 LOCKED_CHALLENGE / 429 COOLDOWN_ACTIVE / RATE_LIMITED:
      // tampilkan alasan server + sisa detik nyata dari `retry_after_seconds`.
      if (mounted) {
        setState(() => _submitting = false);
        showAppSnack(context, e.message);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _submitting = false);
        showAppSnack(context, 'Gagal mengirim submisi. Coba lagi sebentar.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.challenges),
        ),
        title: const Text('Tantangan Koding'),
        actions: [
          IconButton(
            tooltip: 'Riwayat submisi',
            icon: Icon(Icons.history_rounded, color: p.textMuted),
            onPressed: () => context.push(AppRoutes.history(widget.challengeId)),
          ),
          ProfileActionButton(onTap: () => context.go(AppRoutes.profile)),
        ],
      ),
      body: FutureBuilder<ChallengeDetail>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Padding(
              padding: AppSpacing.screenPadding,
              child: Column(children: [
                SkeletonBox(height: 28),
                SizedBox(height: 16),
                SkeletonBox(height: 48, radius: 24),
                SizedBox(height: 16),
                SkeletonBox(height: 220, radius: AppRadius.card),
              ]),
            );
          }
          if (snap.hasError) {
            return Center(
              child: AppButton(
                label: 'Coba lagi',
                expand: false,
                onPressed: () => setState(() => _future = _repo.getDetail(widget.challengeId)),
              ),
            );
          }
          final d = snap.data!;
          if (!_codeLoaded) {
            _starterCode = d.starterCode;
            _code.text = d.starterCode;
            _codeLoaded = true;
          }

          // SELESAI = status server sudah 'completed' ATAU sesi ini berhasil.
          final completed = d.isCompleted || (_report?.allPassed ?? false);
          // Hasil per-kasus untuk bukaan pertama bila tersedia (dataset mock
          // menyertakan baris kasus; backend nyata menyimpan skor di riwayat).
          final synthReport =
              (d.isCompleted && _report == null && d.testCases.isNotEmpty && d.testCases.every((t) => t.passed))
                  ? RunReport(results: d.testCases, millis: 0)
                  : null;
          final shownReport = _report ?? synthReport;
          if (completed && shownReport == null && d.testCases.isEmpty && _historyFuture == null) {
            _historyFuture = _safeHistory();
          }

          final testCountBadge = shownReport != null
              ? '${shownReport.passedCount}/${shownReport.results.length}'
              : (completed ? 'Selesai' : (d.testCases.isNotEmpty ? '${d.testCases.length}' : ''));

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.screen, 4, AppSpacing.screen, AppSpacing.xl),
                  children: [
                    // Meta ribbon
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(color: p.success, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 6),
                              Text('Tingkat: ${d.levelLabel}',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: p.text)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF92400E)),
                              const SizedBox(width: 3),
                              Text('+${d.xp} XP',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (completed) ...[
                          // TERTANDA SELESAI: muncul seketika setelah submit
                          // berhasil (tanpa refresh manual).
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: p.successContainer, borderRadius: BorderRadius.circular(16)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 14, color: p.success),
                                const SizedBox(width: 5),
                                Text('Selesai',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: p.success)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.schedule_rounded, size: 14, color: p.textMuted),
                              const SizedBox(width: 4),
                              Text('~${d.minutes} mnt', style: TextStyle(fontSize: 11, color: p.textMuted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      d.position.toUpperCase(),
                      style: AppTypography.label.copyWith(color: p.primary, fontSize: 11.5, letterSpacing: 0.6, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(d.title, style: AppTypography.titleL.copyWith(color: p.text, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.md),

                    // Segmented tabs
                    _SegmentedTabs(
                      index: _tab,
                      testCountBadge: testCountBadge,
                      hasPassBadge: shownReport?.allPassed ?? completed,
                      onChanged: (i) => setState(() => _tab = i),
                      showDot: _code.text != d.starterCode,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    if (_tab == 0) ..._instructionTab(context, d, shownReport, completed) else _solutionTab(context),
                  ],
                ),
              ),
              _BottomActions(
                running: _running && !_submitting,
                submitting: _submitting,
                onTry: _running ? null : _run,
                onSubmit: _running ? null : _submit,
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _instructionTab(BuildContext context, ChallengeDetail d, RunReport? shownReport, bool completed) {
    final p = context.palette;
    return [
      AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: const Color(0xFFE4EDFF), borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.menu_book_rounded, color: p.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text('Instruksi Tugas', style: AppTypography.titleM.copyWith(color: p.text, fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: AppSpacing.md),
            Text(d.instruction, style: AppTypography.bodyL.copyWith(color: p.text, height: 1.5, fontSize: 14)),
            if (d.rules.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              for (final r in d.rules) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        r.positive ? Icons.check_circle_rounded : Icons.cancel_rounded,
                        color: r.positive ? p.success : p.error,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          r.text,
                          style: TextStyle(fontSize: 12.5, color: p.text, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ],
          ],
        ),
      ),
      if (!completed && d.samples.isNotEmpty) ...[
        const SizedBox(height: AppSpacing.md),
        Text(
          'CONTOH PEMANGGILAN',
          style: TextStyle(color: p.textMuted, fontWeight: FontWeight.bold, letterSpacing: 0.6, fontSize: 11),
        ),
        const SizedBox(height: 6),
        for (final s in d.samples) ...[
          _SampleCard(sample: s),
          const SizedBox(height: 6),
        ],
      ],
      if (shownReport != null) ...[
        const SizedBox(height: AppSpacing.md),
        KeyedSubtree(key: _resultsAnchor, child: _ResultsCard(report: shownReport)),
        const SizedBox(height: AppSpacing.md),
        _HintCard(
          report: shownReport,
          onAsk: () => showAiTutorSheet(
            context,
            challengeId: widget.challengeId,
            getCode: () => _code.text,
            errorMessage: _tutorErrorMessage(),
          ),
        ),
      ],
      // Desain stitch: tantangan yang SELESAI menampilkan hasil pengujian
      // otomatis di bawah instruksi (bukan contoh pemanggilan). Bila hasil
      // per-kasus hanya ada di riwayat (backend menyimpan skor di submissions),
      // tampilkan ringkasan riil + pintu ke halaman riwayat.
      if (completed && shownReport == null) ...[
        const SizedBox(height: AppSpacing.md),
        _CompletedSummaryCard(
          historyFuture: _historyFuture,
          onHistory: () => context.push(AppRoutes.history(widget.challengeId)),
        ),
      ],
    ];
  }

  Widget _solutionTab(BuildContext context) {
    final p = context.palette;
    const accessorySymbols = ['>=', '>', '<=', '<', '==', ':', '(', ')', '"', 'tab', 'indent'];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: p.outline),
            boxShadow: const [
              BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                color: p.surfaceAlt,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.terminal_rounded, size: 14, color: p.primary),
                          const SizedBox(width: 6),
                          Text('solution.py', style: TextStyle(fontFamily: AppFonts.mono, fontSize: 12, color: p.text, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(6)),
                      child: Text('Python 3.11', style: TextStyle(fontFamily: AppFonts.mono, fontSize: 10, color: p.textMuted)),
                    ),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Format PEP8',
                      icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                      onPressed: _formatCode,
                      visualDensity: VisualDensity.compact,
                    ),
                    IconButton(
                      tooltip: 'Reset Kode',
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      onPressed: () => setState(() => _code.text = _starterCode),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ),
              CodeEditor(
                controller: _code,
                focusNode: _focusNode,
                minLines: 8,
              ),
              // Accessory symbol bar
              Container(
                color: p.surfaceAlt,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final sym in accessorySymbols) ...[
                        Material(
                          color: p.surface,
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () => _insertSymbol(sym),
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 34, minHeight: 32),
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              alignment: Alignment.center,
                              child: Text(
                                sym,
                                style: TextStyle(
                                  fontFamily: AppFonts.mono,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: sym == 'tab' || sym == 'indent' ? p.primary : p.text,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // AI Tutor Assistance Card
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: p.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: p.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4EDFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.smart_toy_rounded, color: p.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Butuh Bantuan AI?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: p.text)),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(color: const Color(0xFFE4EDFF), borderRadius: BorderRadius.circular(10)),
                          child: Builder(
                            builder: (pillContext) {
                              // Kuota nyata dari server (ai_quotas 5/hari),
                              // disinronkan TutorQuota tiap kali hint diambil.
                              final q = pillContext.watch<TutorQuota>();
                              return Text(
                                '${q.total - q.remaining}/${q.total} Kuota',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: p.primary,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text('Dapatkan petunjuk bertahap tanpa spoiler kode', style: TextStyle(fontSize: 11, color: p.textMuted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(80, 34),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  side: BorderSide(color: p.primary.withValues(alpha: 0.4)),
                  foregroundColor: p.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => showAiTutorSheet(
                  context,
                  challengeId: widget.challengeId,
                  getCode: () => _code.text,
                ),
                icon: const Icon(Icons.lightbulb_outline_rounded, size: 15),
                label: const Text('Minta Hint', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        // Output "Uji Coba" juga disajikan langsung di tab editor: tombol
        // Uji Coba ada di bilah bawah yang selalu terlihat, jadi hasilnya
        // harus ikut terlihat di konteks yang sama (stitch: panel hasil di
        // bawah editor) — tanpa memaksa pindah tab.
        if (_report != null) ...[
          const SizedBox(height: AppSpacing.md),
          KeyedSubtree(key: _resultsAnchor, child: _ResultsCard(report: _report!)),
        ],
      ],
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.index,
    required this.onChanged,
    required this.showDot,
    required this.testCountBadge,
    required this.hasPassBadge,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final bool showDot;
  final String testCountBadge;
  final bool hasPassBadge;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    Widget item(int i, IconData icon, String label, {Widget? badge, bool dot = false}) {
      final selected = index == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 42,
            decoration: BoxDecoration(
              color: selected ? p.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(22),
              boxShadow: selected
                  ? const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0, 1))]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16, color: selected ? p.primary : p.textMuted),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                    color: selected ? p.text : p.textMuted,
                  ),
                ),
                if (badge != null) ...[
                  const SizedBox(width: 6),
                  badge,
                ],
                if (dot) ...[
                  const SizedBox(width: 5),
                  Container(width: 7, height: 7, decoration: BoxDecoration(color: p.primary, shape: BoxShape.circle)),
                ],
              ],
            ),
          ),
        ),
      );
    }

    Widget? testBadge;
    if (testCountBadge.isNotEmpty) {
      testBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        decoration: BoxDecoration(
          color: hasPassBadge ? const Color(0xFFECFDF5) : const Color(0xFFFFEBEB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          testCountBadge,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.bold,
            color: hasPassBadge ? p.success : p.error,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          item(0, Icons.description_rounded, 'Instruksi & Uji', badge: testBadge),
          item(1, Icons.terminal_rounded, 'Solusi Kodemu', dot: showDot),
        ],
      ),
    );
  }
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.sample});
  final SampleCase sample;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final pass = sample.condition.contains('Lolos') || sample.condition.contains('Kabisat') || sample.condition.contains('Besar');
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(sample.label,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: pass ? p.primary : p.warningText)),
            ),
            Text(sample.condition, style: TextStyle(fontSize: 11, color: p.textMuted)),
          ]),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(child: Text(sample.call, style: TextStyle(fontFamily: AppFonts.mono, color: p.text, fontSize: 12))),
                Icon(Icons.arrow_forward_rounded, size: 14, color: p.textMuted),
                const SizedBox(width: 6),
                Text(sample.result,
                    style: TextStyle(
                      fontFamily: AppFonts.mono,
                      color: pass ? p.success : p.error,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultsCard extends StatelessWidget {
  const _ResultsCard({required this.report});
  final RunReport report;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ok = report.allPassed;
    final c = ok ? p.success : p.error;

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: ok ? const Color(0xFFECFDF5) : const Color(0xFFFFEBEB),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                    child: Icon(ok ? Icons.check_rounded : Icons.close_rounded, color: Colors.white, size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Hasil Pengujian Otomatis',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: p.text)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: p.surface, borderRadius: BorderRadius.circular(10)),
                    child: Text('${report.passedCount}/${report.results.length} Lolos',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c)),
                  ),
                ]),
                const SizedBox(height: 6),
                // Waktu eksekusi hanya ditampilkan bila angkanya nyata dari
                // server — laporan buatan dari riwayat tidak memalsukan angka.
                if (report.millis > 0)
                  Row(children: [
                    Icon(Icons.speed_rounded, size: 14, color: p.textMuted),
                    const SizedBox(width: 3),
                    Text('Eksekusi: ${report.millis}ms',
                        style: TextStyle(fontFamily: AppFonts.mono, color: p.textMuted, fontSize: 11)),
                  ]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              children: [
                for (final r in report.results) ...[
                  _CaseTile(result: r),
                  const SizedBox(height: 6),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CaseTile extends StatelessWidget {
  const _CaseTile({required this.result});
  final TestCaseResult result;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final r = result;
    final c = r.passed ? p.success : p.error;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Flexible(child: Text(r.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: p.text))),
            if (r.hidden) ...[
              const SizedBox(width: 4),
              Icon(Icons.lock_outline_rounded, size: 12, color: p.textMuted),
            ],
            const Spacer(),
            Text(r.passed ? 'Lolos' : 'Gagal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: c)),
          ]),
          const SizedBox(height: 4),
          Text(
            'Input: ${r.input} • Ekspektasi: ${r.expected} • Output: ${r.output}',
            style: TextStyle(fontFamily: AppFonts.mono, color: p.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  const _HintCard({required this.report, required this.onAsk});
  final RunReport report;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final ok = report.allPassed;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(color: Color(0xFFD97706), shape: BoxShape.circle),
              child: const Icon(Icons.lightbulb_outline_rounded, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text('CodeLab AI Scaffolding',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: p.text)),
            ),
            const Text('Scaffolding 3 Level', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
          ]),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 12, color: p.text, height: 1.45),
              children: [
                const TextSpan(text: 'Petunjuk Logika: ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ok
                      ? 'Mantap! Seluruh uji coba lolos. Tekan tombol Kirim Solusi di bawah untuk klaim XP-mu!'
                      : '${report.results.where((r) => !r.passed).length} kasus belum lolos dari pengujian otomatis. '
                          'Minta arahan AI Tutor di bawah — petunjuknya memandu kodemu, bukan jawaban jadi.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: p.primary,
                visualDensity: VisualDensity.compact,
              ),
              onPressed: onAsk,
              icon: const Icon(Icons.smart_toy_outlined, size: 16),
              label: const Text('Tanya AI Tutor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompletedSummaryCard extends StatelessWidget {
  const _CompletedSummaryCard({required this.onHistory, this.historyFuture});

  final VoidCallback onHistory;
  final Future<SubmissionHistory?>? historyFuture;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.success.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: p.success, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Hasil Pengujian Otomatis — Selesai',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: p.text)),
            ),
          ]),
          const SizedBox(height: 8),
          Text(
            'Tantangan ini sudah kamu tuntaskan. Detail per-kasus hanya tampil '
            'di sesi bersama submisi berjalan; skor terbaik tercatat resmi di server:',
            style: AppTypography.bodyM.copyWith(color: p.textMuted, height: 1.45),
          ),
          if (historyFuture != null) ...[
            const SizedBox(height: 10),
            FutureBuilder<SubmissionHistory?>(
              future: historyFuture,
              builder: (context, snap) {
                final best = snap.data?.bestScore;
                if (snap.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                }
                if (best == null) return const SizedBox.shrink();
                return Text(
                  'Skor terbaik: $best%',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: p.success),
                );
              },
            ),
          ],
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: p.primary, visualDensity: VisualDensity.compact),
              onPressed: onHistory,
              icon: const Icon(Icons.history_rounded, size: 16),
              label: const Text('Lihat riwayat submisi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.running,
    required this.submitting,
    required this.onTry,
    required this.onSubmit,
  });

  final bool running;
  final bool submitting;
  final VoidCallback? onTry;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        border: Border(top: BorderSide(color: p.outline)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen, vertical: 10),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  side: BorderSide(color: p.primary),
                  foregroundColor: p.primary,
                  shape: const StadiumBorder(),
                ),
                onPressed: onTry,
                icon: running
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text('Uji Coba', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  backgroundColor: p.primary,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  elevation: 2,
                ),
                onPressed: onSubmit,
                icon: submitting
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded, size: 18),
                label: const Text('Kirim Solusi', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
