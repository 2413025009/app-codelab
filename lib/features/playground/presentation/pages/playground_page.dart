import 'package:flutter/material.dart';

import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/code_editor.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/mini_python_runner.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key, this.initialCode});

  final String? initialCode;

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  static const String _defaultCode = '''# Selamat datang di CodeLab Playground!
# Tulis kode Python-mu di sini

nama = "Siswa"
print(f"Halo, {nama}! Selamat belajar coding.")

nilai = 85
if nilai >= 75:
    print("Selamat, kamu LULUS!")
else:
    print("Tetap semangat, coba lagi!")

total = 0
for i in range(1, 4):
    total += i
print("Jumlah 1-3 =", total)''';

  static const List<String> _symbols = [
    '(',
    ')',
    '{',
    '}',
    '[',
    ']',
    ':',
    '"',
    "'",
    '=',
    '+',
    '-',
    '*',
    '/',
    '#',
    'Tab',
  ];

  late final TextEditingController _codeController;
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _terminalScrollController = ScrollController();
  final MiniPythonRunner _runner = MiniPythonRunner();

  bool _isTerminalExpanded = false;
  List<String> _outputLines = [];
  bool _isSuccess = true;
  int? _executionTimeMs;
  bool _hasRun = false;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: widget.initialCode ?? _defaultCode);
    _editorFocusNode.addListener(_onEditorFocusChange);
  }

  @override
  void dispose() {
    _editorFocusNode.removeListener(_onEditorFocusChange);
    _codeController.dispose();
    _editorFocusNode.dispose();
    _terminalScrollController.dispose();
    super.dispose();
  }

  void _onEditorFocusChange() {
    if (_editorFocusNode.hasFocus && _isTerminalExpanded) {
      setState(() => _isTerminalExpanded = false);
    }
  }

  void _resetCode() {
    setState(() {
      _codeController.text = widget.initialCode ?? _defaultCode;
      _outputLines = [];
      _hasRun = false;
      _executionTimeMs = null;
    });
  }

  Future<void> _runCode() async {
    if (_isRunning) return;
    FocusScope.of(context).unfocus();

    setState(() {
      _isRunning = true;
      _isTerminalExpanded = true;
    });

    final stopwatch = Stopwatch()..start();
    final result = await _runner.run(
      _codeController.text,
      onInput: _promptInput,
      l10n: AppLocalizations.of(context),
    );
    stopwatch.stop();

    if (!mounted) return;
    if (result.ok) {
      SoundService.playLabTerminalPrint();
    } else {
      SoundService.playLabSyntaxError();
    }
    setState(() {
      _outputLines = result.lines;
      _isSuccess = result.ok;
      _executionTimeMs = stopwatch.elapsedMilliseconds;
      _hasRun = true;
      _isRunning = false;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_terminalScrollController.hasClients) {
        _terminalScrollController.animateTo(
          _terminalScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Dialog input() — siswa mengetik jawaban di sini, bukan di terminal.
  Future<String?> _promptInput(String prompt) async {
    if (!mounted) return '';
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final p = context.palette;
        return AlertDialog(
          backgroundColor: p.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.terminal_rounded, size: 20, color: p.primary),
              const SizedBox(width: 8),
              Text('input()', style: AppTypography.label.copyWith(color: p.text)),
            ],
          ),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prompt,
                  style: AppTypography.bodyM.copyWith(color: p.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                TextField(
                  controller: controller,
                  autofocus: true,
                  style: AppTypography.code.copyWith(color: p.text),
                  decoration: InputDecoration(
                    hintText: l10n.playgroundInputHint,
                    border: const OutlineInputBorder(),
                  ),
                  onSubmitted: (v) => Navigator.of(ctx).pop(v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(controller.text),
              child: Text(
                l10n.actionSend,
                style: AppTypography.label.copyWith(color: p.primary),
              ),
            ),
          ],
        );
      },
    );
    return value ?? '';
  }

  void _insertSymbol(String symbol) {
    final text = _codeController.text;
    final selection = _codeController.selection;
    final insertion = symbol == 'Tab' ? '    ' : symbol;

    int newCursorPos;
    String newText;

    if (selection.start < 0 || selection.end < 0) {
      newText = text + insertion;
      newCursorPos = newText.length;
    } else {
      newText = selection.textBefore(text) + insertion + selection.textAfter(text);
      newCursorPos = selection.start + insertion.length;
    }

    _codeController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );
    _editorFocusNode.requestFocus();
  }

  /// Tombol info di AppBar: pesan guru tentang APA YANG BELUM BISA
  /// dilakukan di Python Sandbox. Daftar kemampuan yang sudah ada sengaja
  /// tidak diulang — siswa cukup tahu batasnya agar tidak bingung saat
  /// sesuatu gagal. Teks tinggal di kode aplikasi, bukan di database.
  Future<void> _showSandboxLimits() {
    final l10n = AppLocalizations.of(context);
    return showAppSheet<void>(
      context,
      title: l10n.sandboxSheetTitle,
      subtitle: l10n.sandboxSheetSubtitle,
      leadingIcon: Icons.school_outlined,
      builder: (_) => const _SandboxLimitsBody(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: palette.bg,
      appBar: AppBar(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: AppSpacing.md,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: palette.outline, height: 1),
        ),
        // FittedBox menjaga chip judul tetap utuh (mengecil sedikit) saat
        // layar sempit, sehingga tombol info + Reset + Jalankan tidak
        // saling mendorong keluar layar.
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: palette.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: palette.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.code_rounded, size: 16, color: palette.primary),
                const SizedBox(width: 6),
                Text(
                  'main.py',
                  style: AppTypography.label.copyWith(
                    color: palette.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: palette.primaryContainer,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Python Sandbox',
                    style: AppTypography.caption.copyWith(
                      color: palette.primary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: l10n.sandboxTooltip,
            icon: Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: palette.textMuted,
            ),
            padding: EdgeInsets.zero,
            visualDensity: VisualDensity.compact,
            constraints: const BoxConstraints(minWidth: 30, minHeight: 30),
            onPressed: _showSandboxLimits,
          ),
          TextButton(
            onPressed: _resetCode,
            style: TextButton.styleFrom(
              foregroundColor: palette.textMuted,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 36),
            ),
            child: Text(
              l10n.playgroundReset,
              style: AppTypography.label.copyWith(
                color: palette.textMuted,
                fontSize: 13,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md, left: AppSpacing.xs),
            child: FilledButton.icon(
              onPressed: _isRunning ? null : _runCode,
              icon: const Icon(Icons.play_arrow_rounded, size: 16),
              label: Text(
                _isRunning ? l10n.playgroundRunning : l10n.playgroundRun,
                style: AppTypography.label.copyWith(
                  color: palette.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: palette.onPrimary,
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.pillBorder,
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Code Editor area
          Expanded(
            child: Container(
              color: palette.codeBg,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: CodeEditor(
                  controller: _codeController,
                  focusNode: _editorFocusNode,
                  minLines: 14,
                ),
              ),
            ),
          ),

          // 2. Symbol shortcuts bar
          _buildSymbolBar(palette),

          // 3. Terminal output panel
          _buildTerminalPanel(palette),
        ],
      ),
    );
  }

  Widget _buildSymbolBar(AppPalette palette) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: palette.surfaceAlt,
        border: Border(
          top: BorderSide(color: palette.outline),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
        itemCount: _symbols.length,
        separatorBuilder: (context, index) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final symbol = _symbols[index];
          final isTab = symbol == 'Tab';
          return Material(
            color: palette.surface,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => _insertSymbol(symbol),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: isTab ? 44 : 34,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: palette.outline.withValues(alpha: 0.6),
                  ),
                ),
                child: Text(
                  symbol,
                  style: AppTypography.code.copyWith(
                    color: palette.text,
                    fontWeight: FontWeight.w600,
                    fontSize: isTab ? 11 : 13,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTerminalPanel(AppPalette palette) {
    final l10n = AppLocalizations.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: _isTerminalExpanded ? 200 : 45,
      decoration: BoxDecoration(
        color: palette.codeBg,
        border: Border(
          top: BorderSide(color: palette.outline),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          InkWell(
            onTap: () => setState(() => _isTerminalExpanded = !_isTerminalExpanded),
            child: SizedBox(
              height: 44,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Row(
                  children: [
                    Icon(
                      Icons.terminal_rounded,
                      size: 18,
                      color: palette.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      l10n.playgroundTerminal,
                      style: AppTypography.label.copyWith(
                        color: palette.text,
                        fontSize: 13,
                      ),
                    ),
                    if (_hasRun) ...[
                      const SizedBox(width: AppSpacing.sm),
                      _buildStatusChip(palette),
                    ],
                    const Spacer(),
                    if (_outputLines.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: palette.textMuted,
                        ),
                        tooltip: l10n.playgroundClearTerminal,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () {
                          setState(() {
                            _outputLines = [];
                            _hasRun = false;
                            _executionTimeMs = null;
                          });
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        _isTerminalExpanded
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded,
                        size: 20,
                        color: palette.textMuted,
                      ),
                      tooltip: _isTerminalExpanded
                          ? l10n.playgroundCloseTerminal
                          : l10n.playgroundOpenTerminal,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      onPressed: () => setState(() => _isTerminalExpanded = !_isTerminalExpanded),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Output lines
          if (_isTerminalExpanded)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: palette.outline.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: _outputLines.isEmpty
                    ? Center(
                        child: Text(
                          _isRunning
                              ? l10n.playgroundRunning
                              : _hasRun
                                  ? l10n.playgroundEmptyDone
                                  : l10n.playgroundEmptyIdle,
                          style: AppTypography.code.copyWith(
                            color: palette.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _terminalScrollController,
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _outputLines.length,
                        itemBuilder: (context, index) {
                          final line = _outputLines[index];
                          final isError = !_isSuccess && index == _outputLines.length - 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: SelectableText(
                              line,
                              style: AppTypography.code.copyWith(
                                color: isError ? palette.error : palette.text,
                                fontSize: 12.5,
                                height: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppPalette palette) {
    final color = _isSuccess ? palette.success : palette.error;
    final bgColor = _isSuccess ? palette.successContainer : palette.errorContainer;
    final label = _isSuccess
        ? 'Selesai (${_executionTimeMs ?? 0}ms)'
        : 'Error (${_executionTimeMs ?? 0}ms)';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isSuccess ? Icons.check_circle_rounded : Icons.error_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Isi tombol info sandbox — hanya BATASAN, ditulis dengan suara guru.
class _SandboxLimitsBody extends StatelessWidget {
  const _SandboxLimitsBody();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.lg,
        AppSpacing.screen,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.sandboxIntro,
            style: AppTypography.bodyM.copyWith(
              color: p.textMuted,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SandboxLimit(
            icon: Icons.extension_off_rounded,
            title: l10n.sandboxLimitImportTitle,
            body: l10n.sandboxLimitImportBody,
          ),
          _SandboxLimit(
            icon: Icons.folder_off_outlined,
            title: l10n.sandboxLimitFileTitle,
            body: l10n.sandboxLimitFileBody,
          ),
          _SandboxLimit(
            icon: Icons.image_not_supported_outlined,
            title: l10n.sandboxLimitGuiTitle,
            body: l10n.sandboxLimitGuiBody,
          ),
          _SandboxLimit(
            icon: Icons.account_tree_outlined,
            title: l10n.sandboxLimitOopTitle,
            body: l10n.sandboxLimitOopBody,
          ),
          _SandboxLimit(
            icon: Icons.timer_off_outlined,
            title: l10n.sandboxLimitLimitsTitle,
            body: l10n.sandboxLimitLimitsBody,
          ),
          // Minggu 13: menjelaskan bahwa penilai Playground (di HP) dan
          // penilai tantangan (di server) adalah dua mesin berbeda, sehingga
          // siswa tidak bingung bila hasilnya tidak sama.
          _SandboxLimit(
            icon: Icons.rule_outlined,
            title: l10n.sandboxLimitJudgeTitle,
            body: l10n.sandboxLimitJudgeBody,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: p.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.tips_and_updates_outlined,
                  size: 20,
                  color: p.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.sandboxClosing,
                    style: AppTypography.bodySm.copyWith(
                      color: p.textMuted,
                      height: 1.5,
                    ),
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

/// Satu baris batasan: ikon + judul tegas + penjelasan guru.
class _SandboxLimit extends StatelessWidget {
  const _SandboxLimit({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: p.warningContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: p.warningText),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.label.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: AppTypography.bodySm.copyWith(
                    color: p.textMuted,
                    height: 1.5,
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
