// FILE: lib/features/teacher/presentation/widgets/slide_type_forms.dart
//
// TUGAS: Form editor khusus untuk tujuh tipe slide. Setiap tipe punya kelas
// sendiri (template layar per tipe) supaya Bab Builder tidak lagi menumpuk
// semua editor di dalam satu halaman.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/slide_templates.dart';
import 'slide_field_help.dart';

/// Memilih form yang tepat berdasarkan tipe slide.
class SlideTypeForm extends StatelessWidget {
  const SlideTypeForm({
    super.key,
    required this.type,
    required this.slide,
    required this.xpReward,
    required this.onChanged,
  });

  final String type;
  final Map<String, dynamic> slide;
  final int xpReward;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    switch (SlideTemplates.normalize(type)) {
      case 'TAP_TO_FILL':
        return TapToFillSlideForm(slide: slide, onChanged: onChanged);
      case 'TYPE_CODE':
        return TypeCodeSlideForm(slide: slide, onChanged: onChanged);
      case 'OUTPUT_PREDICT':
        return OutputPredictSlideForm(slide: slide, onChanged: onChanged);
      case 'BUG_HUNTER':
        return BugHunterSlideForm(slide: slide, onChanged: onChanged);
      case 'QUIZ':
        return QuizSlideForm(slide: slide, onChanged: onChanged);
      case 'OUTRO':
        return OutroSlideForm(
          slide: slide,
          xpReward: xpReward,
          onChanged: onChanged,
        );
      case 'THEORY':
      default:
        return TheorySlideForm(slide: slide, onChanged: onChanged);
    }
  }
}

/// Field teks standar dengan label yang konsisten di semua form.
class SlideFormField extends StatelessWidget {
  const SlideFormField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.hint,
    this.help,
    this.maxLines = 1,
    this.monospace = false,
    this.keyboardType,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? hint;

  /// Panduan pengisian yang muncul saat tombol "?" ditekan. Statis di kode,
  /// tidak pernah disimpan ke database.
  final String? help;

  final int maxLines;
  final bool monospace;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideFieldLabel(label: label, help: help),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: monospace
              ? const TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 13,
                  height: 1.4,
                )
              : null,
          decoration: InputDecoration(
            hintText: hint ?? label,
            isDense: true,
            filled: true,
            fillColor: p.surfaceAlt,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: p.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: p.outline.withAlpha(120)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: p.primary, width: 1.5),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class SlideChipPicker extends StatelessWidget {
  const SlideChipPicker({
    super.key,
    required this.label,
    required this.values,
    required this.selected,
    required this.onSelected,
    this.help,
  });

  final String label;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;

  /// Panduan pengisian yang muncul saat tombol "?" ditekan.
  final String? help;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideFieldLabel(label: label, help: help),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: values.map((value) {
            final isSelected = value == selected;
            return InkWell(
              onTap: () => onSelected(value),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? p.primary : p.surfaceAlt,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? p.primary : p.outline),
                ),
                child: Text(
                  value,
                  style: AppTypography.labelSm.copyWith(
                    color: isSelected ? Colors.white : p.text,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. TEORI & KONSEP
// ─────────────────────────────────────────────────────────────────────────────

class TheorySlideForm extends StatefulWidget {
  const TheorySlideForm({
    super.key,
    required this.slide,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final VoidCallback onChanged;

  @override
  State<TheorySlideForm> createState() => _TheorySlideFormState();
}

class _TheorySlideFormState extends State<TheorySlideForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    final codeLang = slide['code_lang'] as String? ?? 'Python';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldTheoryTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintTheoryTitleExample,
          help: l10n.tSlideFormHelpTheoryTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldTheoryContent,
          initialValue: slide['content'] as String? ?? '',
          hint: l10n.tSlideFormHintTheoryContent,
          maxLines: 6,
          help: l10n.tSlideFormHelpTheoryContent,
          onChanged: (value) => slide['content'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideChipPicker(
          label: l10n.tSlideFieldCodeLanguage,
          values: const ['HTML', 'CSS', 'JavaScript', 'Python'],
          selected: codeLang,
          help: l10n.tSlideFormHelpCodeFileSample,
          onSelected: (value) {
            setState(() => slide['code_lang'] = value);
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldSampleCode,
          initialValue: slide['sample_code'] as String? ?? '',
          hint: '<h1>Halo Dunia</h1>',
          maxLines: 4,
          monospace: true,
          help: l10n.tSlideFormHelpSampleCode,
          onChanged: (value) => slide['sample_code'] = value,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. LENGKAPI KODE (TAP)
// ─────────────────────────────────────────────────────────────────────────────

class TapToFillSlideForm extends StatefulWidget {
  const TapToFillSlideForm({
    super.key,
    required this.slide,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final VoidCallback onChanged;

  @override
  State<TapToFillSlideForm> createState() => _TapToFillSlideFormState();
}

class _TapToFillSlideFormState extends State<TapToFillSlideForm> {
  late List<String> _blanks;
  late String _template;

  @override
  void initState() {
    super.initState();
    _template = widget.slide['template'] as String? ?? '';
    _blanks = ((widget.slide['blanks'] as List?) ?? const [])
        .map((e) => e.toString())
        .toList();
    _syncBlanks();
  }

  int get _slotCount => RegExp(r'_{2,}\d*_{2,}').allMatches(_template).length;

  void _syncBlanks() {
    while (_blanks.length < _slotCount) {
      _blanks.add('');
    }
    if (_blanks.length > _slotCount) {
      _blanks = _blanks.sublist(0, _slotCount);
    }
    widget.slide['blanks'] = List<String>.from(_blanks);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    final distractors = ((slide['distractors'] as List?) ?? const [])
        .map((e) => e.toString())
        .join(', ');
    final codeLang = slide['code_lang'] as String? ?? 'HTML';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldExerciseTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintExerciseTitleExample,
          help: l10n.tSlideFormHelpExerciseTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldInstruction,
          initialValue: slide['prompt'] as String? ?? '',
          hint: l10n.tSlideFormHintShortInstruction,
          maxLines: 2,
          help: l10n.tSlideFormHelpShortInstruction,
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldCodeTemplate,
          initialValue: _template,
          hint: 'x = ___1___\nprint(x)',
          maxLines: 4,
          monospace: true,
          help: l10n.tSlideFormHelpCodeTemplate,
          onChanged: (value) {
            slide['template'] = value;
            setState(() {
              _template = value;
              _syncBlanks();
            });
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFieldLabel(
          label: l10n.tSlideFormSlotAnswerCount(_slotCount),
          help: l10n.tSlideFormHelpSlotAnswers,
        ),
        const SizedBox(height: 6),
        if (_slotCount == 0)
          Text(
            l10n.tSlideFormNoSlotsHint,
            style: AppTypography.bodySm.copyWith(
              color: context.palette.textMuted,
            ),
          )
        else
          for (var i = 0; i < _slotCount; i++) ...[
            SlideFormField(
              key: ValueKey('tap_blank_$i'),
              label: l10n.tSlideFormSlot(i + 1),
              initialValue: i < _blanks.length ? _blanks[i] : '',
              hint: l10n.tSlideFormSlotAnswerHint(i + 1),
              onChanged: (value) {
                if (i < _blanks.length) _blanks[i] = value;
                slide['blanks'] = List<String>.from(_blanks);
              },
            ),
            if (i != _slotCount - 1) const SizedBox(height: AppSpacing.sm),
          ],
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldDistractors,
          initialValue: distractors,
          hint: '20, print, console.log',
          help: l10n.tSlideFormHelpDistractors,
          onChanged: (value) {
            slide['distractors'] = value
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SlideChipPicker(
          label: l10n.tSlideFieldCodeLanguage,
          values: const ['HTML', 'CSS', 'JavaScript', 'Python'],
          selected: codeLang,
          help: l10n.tSlideFormHelpCodeFile,
          onSelected: (value) {
            setState(() => slide['code_lang'] = value);
            widget.onChanged();
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. KETIK KATA KUNCI
// ─────────────────────────────────────────────────────────────────────────────

class TypeCodeSlideForm extends StatefulWidget {
  const TypeCodeSlideForm({
    super.key,
    required this.slide,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final VoidCallback onChanged;

  @override
  State<TypeCodeSlideForm> createState() => _TypeCodeSlideFormState();
}

class _TypeCodeSlideFormState extends State<TypeCodeSlideForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldQuestionTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintQuestionTitleExample,
          help: l10n.tSlideFormHelpQuestionTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldInstruction,
          initialValue: slide['prompt'] as String? ?? '',
          hint: l10n.tSlideFormHintInteractiveInstruction,
          maxLines: 2,
          help: l10n.tSlideFormHelpInteractiveInstruction,
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldQuestionCode,
          initialValue: slide['code'] as String? ?? '',
          hint: '[KETIK_DISINI] nama_siswa = "Ahmad"',
          maxLines: 4,
          monospace: true,
          help: l10n.tSlideFormHelpQuestionCode,
          onChanged: (value) => slide['code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldAnswerKeyword,
          initialValue: slide['answer'] as String? ?? '',
          hint: l10n.tSlideFormHintAnswerKeywordExample,
          help: l10n.tSlideFormHelpAnswerKeyword,
          onChanged: (value) => slide['answer'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldHint,
          initialValue: slide['hint'] as String? ?? '',
          hint: l10n.tSlideFormHintWrongHint,
          maxLines: 2,
          help: l10n.tSlideFormHelpWrongHint,
          onChanged: (value) => slide['hint'] = value,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. TEBAK OUTPUT TERMINAL
// ─────────────────────────────────────────────────────────────────────────────

class OutputPredictSlideForm extends StatefulWidget {
  const OutputPredictSlideForm({
    super.key,
    required this.slide,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final VoidCallback onChanged;

  @override
  State<OutputPredictSlideForm> createState() => _OutputPredictSlideFormState();
}

class _OutputPredictSlideFormState extends State<OutputPredictSlideForm> {
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _options = ((widget.slide['options'] as List?) ?? const [])
        .map((e) => e.toString())
        .toList();
    while (_options.length < 4) {
      _options.add('');
    }
    widget.slide['options'] = List<String>.from(_options);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    final answer = slide['answer'] as String? ?? 'A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldSlideTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintSlideTitleExample,
          help: l10n.tSlideFormHelpSlideTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldInstruction,
          initialValue: slide['prompt'] as String? ?? '',
          hint: l10n.tSlideFormHintChallengeInstruction,
          maxLines: 2,
          help: l10n.tSlideFormHelpChallengeInstruction,
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldCodeBlock,
          initialValue: slide['code'] as String? ?? '',
          maxLines: 5,
          monospace: true,
          help: l10n.tSlideFormHelpSourceCode,
          onChanged: (value) => slide['code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFieldLabel(
          label: l10n.tSlideFieldOutputChoices,
          help: l10n.tSlideFormHelpOutputChoices,
        ),
        const SizedBox(height: 6),
        for (var i = 0; i < 4; i++) ...[
          _ChoiceField(
            letter: String.fromCharCode(65 + i),
            value: _options[i],
            selected: answer == String.fromCharCode(65 + i),
            dark: true,
            onSelect: () {
              setState(() => slide['answer'] = String.fromCharCode(65 + i));
              widget.onChanged();
            },
            onChanged: (value) {
              _options[i] = value;
              slide['options'] = List<String>.from(_options);
            },
          ),
          if (i != 3) const SizedBox(height: 6),
        ],
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldExplanation,
          initialValue: slide['explanation'] as String? ?? '',
          hint: l10n.tSlideFormHintOutputExplanation,
          maxLines: 3,
          help: l10n.tSlideFormHelpOutputExplanation,
          onChanged: (value) => slide['explanation'] = value,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. BUG HUNTER
// ─────────────────────────────────────────────────────────────────────────────

class BugHunterSlideForm extends StatefulWidget {
  const BugHunterSlideForm({
    super.key,
    required this.slide,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final VoidCallback onChanged;

  @override
  State<BugHunterSlideForm> createState() => _BugHunterSlideFormState();
}

class _BugHunterSlideFormState extends State<BugHunterSlideForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldChallengeTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintChallengeTitleExample,
          help: l10n.tSlideFormHelpChallengeTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldScenario,
          initialValue: slide['scenario'] as String? ?? '',
          hint: l10n.tSlideFormHintScenario,
          maxLines: 2,
          help: l10n.tSlideFormHelpScenario,
          onChanged: (value) => slide['scenario'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldProgramCode,
          initialValue: slide['buggy_code'] as String? ?? '',
          maxLines: 6,
          monospace: true,
          help: l10n.tSlideFormHelpBuggyCode,
          onChanged: (value) => slide['buggy_code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldTargetLine,
          initialValue: slide['target_line']?.toString() ?? '1',
          hint: l10n.tSlideFormHintTargetLineExample,
          keyboardType: TextInputType.number,
          help: l10n.tSlideFormHelpTargetLine,
          onChanged: (value) => slide['target_line'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldErrorType,
          initialValue: slide['error_type'] as String? ?? 'SyntaxError',
          hint: 'SyntaxError / IndentationError / NameError',
          help: l10n.tSlideFormHelpErrorType,
          onChanged: (value) => slide['error_type'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldBugHint,
          initialValue: slide['bug_hint'] as String? ?? '',
          hint: l10n.tSlideFormHintBugHint,
          maxLines: 2,
          help: l10n.tSlideFormHelpBugHint,
          onChanged: (value) => slide['bug_hint'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldFixCode,
          initialValue: slide['fix'] as String? ?? '',
          hint: 'for i in range(10):',
          maxLines: 3,
          monospace: true,
          help: l10n.tSlideFormHelpFixCode,
          onChanged: (value) => slide['fix'] = value,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. KUIS PILIHAN GANDA
// ─────────────────────────────────────────────────────────────────────────────

class QuizSlideForm extends StatefulWidget {
  const QuizSlideForm({
    super.key,
    required this.slide,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final VoidCallback onChanged;

  @override
  State<QuizSlideForm> createState() => _QuizSlideFormState();
}

class _QuizSlideFormState extends State<QuizSlideForm> {
  late List<String> _options;

  @override
  void initState() {
    super.initState();
    _options = ((widget.slide['options'] as List?) ?? const [])
        .map((e) => e.toString())
        .toList();
    while (_options.length < 4) {
      _options.add('');
    }
    widget.slide['options'] = List<String>.from(_options);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    final answer = slide['answer'] as String? ?? 'A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldSlideTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintQuizTitleExample,
          help: l10n.tSlideFormHelpQuizTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldQuizQuestion,
          initialValue: slide['question'] as String? ?? '',
          hint: l10n.tSlideFormHintQuizQuestion,
          maxLines: 3,
          help: l10n.tSlideFormHelpQuizQuestion,
          onChanged: (value) => slide['question'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFieldLabel(
          label: l10n.tSlideFieldAnswerChoices,
          help: l10n.tSlideFormHelpAnswerChoices,
        ),
        const SizedBox(height: 6),
        for (var i = 0; i < 4; i++) ...[
          _ChoiceField(
            letter: String.fromCharCode(65 + i),
            value: _options[i],
            selected: answer == String.fromCharCode(65 + i),
            onSelect: () {
              setState(() => slide['answer'] = String.fromCharCode(65 + i));
              widget.onChanged();
            },
            onChanged: (value) {
              _options[i] = value;
              slide['options'] = List<String>.from(_options);
            },
          ),
          if (i != 3) const SizedBox(height: 6),
        ],
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldFeedback,
          initialValue: slide['explanation'] as String? ?? '',
          hint: l10n.tSlideFormHintFeedback,
          maxLines: 3,
          help: l10n.tSlideFormHelpFeedback,
          onChanged: (value) => slide['explanation'] = value,
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. RANGKUMAN & KLAIM XP
// ─────────────────────────────────────────────────────────────────────────────

class OutroSlideForm extends StatefulWidget {
  const OutroSlideForm({
    super.key,
    required this.slide,
    required this.xpReward,
    required this.onChanged,
  });

  final Map<String, dynamic> slide;
  final int xpReward;
  final VoidCallback onChanged;

  @override
  State<OutroSlideForm> createState() => _OutroSlideFormState();
}

class _OutroSlideFormState extends State<OutroSlideForm> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final slide = widget.slide;
    final concepts = ((slide['mastered_concepts'] as List?) ?? const [])
        .map((e) => e.toString())
        .join(', ');
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: l10n.tSlideFieldOutroTitle,
          initialValue: slide['title'] as String? ?? '',
          hint: l10n.tSlideFormHintOutroTitleExample,
          help: l10n.tSlideFormHelpOutroTitle,
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldSummary,
          initialValue: slide['summary'] as String? ?? '',
          hint: l10n.tSlideFormHintSummary,
          maxLines: 4,
          help: l10n.tSlideFormHelpSummary,
          onChanged: (value) => slide['summary'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: l10n.tSlideFieldMasteredConcepts,
          initialValue: concepts,
          hint: l10n.tSlideFormHintMasteredConcepts,
          help: l10n.tSlideFormHelpMasteredConcepts,
          onChanged: (value) {
            slide['mastered_concepts'] = value
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: p.primaryContainer.withAlpha(25),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.primaryContainer.withAlpha(60)),
          ),
          child: Row(
            children: [
              Icon(Icons.military_tech_rounded, size: 20, color: p.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  l10n.tSlideFormXpNote(widget.xpReward),
                  style: AppTypography.bodySm.copyWith(color: p.primary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper bersama
// ─────────────────────────────────────────────────────────────────────────────

class _ChoiceField extends StatelessWidget {
  const _ChoiceField({
    required this.letter,
    required this.value,
    required this.selected,
    required this.onSelect,
    required this.onChanged,
    this.dark = false,
  });

  final String letter;
  final String value;
  final bool selected;
  final VoidCallback onSelect;
  final ValueChanged<String> onChanged;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final background = dark ? const Color(0xFF161B27) : p.surfaceAlt;
    final border = selected
        ? p.primary
        : (dark ? Colors.transparent : p.outline);
    final textColor = dark ? const Color(0xFFDAE2FF) : p.text;
    final letterColor = dark ? Colors.white70 : p.text;

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: selected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? p.primary
                      : (dark ? Colors.white38 : p.outline),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: p.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            Text(
              '$letter: ',
              style: AppTypography.codeSm.copyWith(
                color: letterColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: TextFormField(
                initialValue: value,
                style: TextStyle(
                  fontFamily: 'JetBrains Mono',
                  fontSize: 12.5,
                  color: textColor,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
