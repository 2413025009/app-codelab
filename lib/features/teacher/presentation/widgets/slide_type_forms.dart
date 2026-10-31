// FILE: lib/features/teacher/presentation/widgets/slide_type_forms.dart
//
// TUGAS: Form editor khusus untuk tujuh tipe slide. Setiap tipe punya kelas
// sendiri (template layar per tipe) supaya Bab Builder tidak lagi menumpuk
// semua editor di dalam satu halaman.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/slide_templates.dart';

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
    this.maxLines = 1,
    this.monospace = false,
    this.keyboardType,
  });

  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  final String? hint;
  final int maxLines;
  final bool monospace;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: p.text,
            fontWeight: FontWeight.w600,
          ),
        ),
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
  });

  final String label;
  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: p.text,
            fontWeight: FontWeight.w600,
          ),
        ),
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
    final slide = widget.slide;
    final codeLang = slide['code_lang'] as String? ?? 'Python';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Materi Teori',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Struktur Dasar Dokumen HTML5',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Konten Penjelasan (mendukung Markdown)',
          initialValue: slide['content'] as String? ?? '',
          hint: 'Tuliskan konsep utama, poin-poin, atau contoh...',
          maxLines: 6,
          onChanged: (value) => slide['content'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideChipPicker(
          label: 'Bahasa Kode Sampel',
          values: const ['HTML', 'CSS', 'JavaScript', 'Python'],
          selected: codeLang,
          onSelected: (value) {
            setState(() => slide['code_lang'] = value);
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Cuplikan Kode Sampel (opsional)',
          initialValue: slide['sample_code'] as String? ?? '',
          hint: '<h1>Halo Dunia</h1>',
          maxLines: 4,
          monospace: true,
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
    final slide = widget.slide;
    final distractors = ((slide['distractors'] as List?) ?? const [])
        .map((e) => e.toString())
        .join(', ');
    final codeLang = slide['code_lang'] as String? ?? 'HTML';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Latihan',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Lengkapi Tag Penutup HTML',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Instruksi Singkat',
          initialValue: slide['prompt'] as String? ?? '',
          hint: 'Instruksi pengerjaan bagi siswa...',
          maxLines: 2,
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Template Kode (gunakan ___1___ untuk slot)',
          initialValue: _template,
          hint: 'x = ___1___\nprint(x)',
          maxLines: 4,
          monospace: true,
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
        Text(
          'Kunci jawaban per slot ($_slotCount slot terdeteksi)',
          style: AppTypography.labelSm.copyWith(
            color: context.palette.text,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        if (_slotCount == 0)
          Text(
            'Tambahkan penanda ___1___, ___2___, dan seterusnya pada template.',
            style: AppTypography.bodySm.copyWith(
              color: context.palette.textMuted,
            ),
          )
        else
          for (var i = 0; i < _slotCount; i++) ...[
            SlideFormField(
              key: ValueKey('tap_blank_$i'),
              label: 'Slot ${i + 1}',
              initialValue: i < _blanks.length ? _blanks[i] : '',
              hint: 'Jawaban benar untuk slot ${i + 1}',
              onChanged: (value) {
                if (i < _blanks.length) _blanks[i] = value;
                slide['blanks'] = List<String>.from(_blanks);
              },
            ),
            if (i != _slotCount - 1) const SizedBox(height: AppSpacing.sm),
          ],
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Pengecoh Tambahan (pisahkan dengan koma)',
          initialValue: distractors,
          hint: '20, print, console.log',
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
          label: 'Bahasa Kode',
          values: const ['HTML', 'CSS', 'JavaScript', 'Python'],
          selected: codeLang,
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
    final slide = widget.slide;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Soal',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Deklarasi Variabel Python',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Instruksi Interaktif',
          initialValue: slide['prompt'] as String? ?? '',
          hint: 'Ketikkan kata kunci untuk mendeklarasikan variabel...',
          maxLines: 2,
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kode Soal ([KETIK_DISINI] = titik input)',
          initialValue: slide['code'] as String? ?? '',
          hint: '[KETIK_DISINI] nama_siswa = "Ahmad"',
          maxLines: 4,
          monospace: true,
          onChanged: (value) => slide['code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kata Kunci Jawaban Benar',
          initialValue: slide['answer'] as String? ?? '',
          hint: 'Contoh: def / const / let',
          onChanged: (value) => slide['answer'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Petunjuk Jika Salah (AI Hint)',
          initialValue: slide['hint'] as String? ?? '',
          hint: 'Ingat penulisan huruf kecil semua.',
          maxLines: 2,
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
    final slide = widget.slide;
    final answer = slide['answer'] as String? ?? 'A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Slide',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Tebak Output Operator Modulo',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Instruksi Tantangan',
          initialValue: slide['prompt'] as String? ?? '',
          hint: 'Apakah output yang dicetak ke terminal?',
          maxLines: 2,
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Blok Kode Sumber Program',
          initialValue: slide['code'] as String? ?? '',
          maxLines: 5,
          monospace: true,
          onChanged: (value) => slide['code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Opsi output terminal (pilih satu jawaban benar)',
          style: AppTypography.labelSm.copyWith(
            color: context.palette.text,
            fontWeight: FontWeight.w600,
          ),
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
          label: 'Penjelasan Logika Output',
          initialValue: slide['explanation'] as String? ?? '',
          hint: 'Mengapa output tersebut yang muncul?',
          maxLines: 3,
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
    final slide = widget.slide;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Tantangan',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Mencari Kesalahan Loop For',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Skenario Error & Target Belajar',
          initialValue: slide['scenario'] as String? ?? '',
          hint: 'Deskripsi konteks masalah...',
          maxLines: 2,
          onChanged: (value) => slide['scenario'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kode Program Lengkap (dengan bug)',
          initialValue: slide['buggy_code'] as String? ?? '',
          maxLines: 6,
          monospace: true,
          onChanged: (value) => slide['buggy_code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Target Nomor Baris Bug',
          initialValue: slide['target_line']?.toString() ?? '1',
          hint: 'Contoh: 2',
          keyboardType: TextInputType.number,
          onChanged: (value) => slide['target_line'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Jenis Error',
          initialValue: slide['error_type'] as String? ?? 'SyntaxError',
          hint: 'SyntaxError / IndentationError / NameError',
          onChanged: (value) => slide['error_type'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Pesan Indikator / Hint Letak Bug',
          initialValue: slide['bug_hint'] as String? ?? '',
          hint: 'Kurang tanda titik dua (:) di akhir pernyataan for',
          maxLines: 2,
          onChanged: (value) => slide['bug_hint'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kode Perbaikan Valid',
          initialValue: slide['fix'] as String? ?? '',
          hint: 'for i in range(10):',
          maxLines: 3,
          monospace: true,
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
    final slide = widget.slide;
    final answer = slide['answer'] as String? ?? 'A';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Slide',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Memahami Tipe Data',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Pertanyaan Kuis',
          initialValue: slide['question'] as String? ?? '',
          hint: 'Tuliskan pertanyaan konseptual...',
          maxLines: 3,
          onChanged: (value) => slide['question'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Daftar pilihan jawaban (pilih satu kunci benar)',
          style: AppTypography.labelSm.copyWith(
            color: context.palette.text,
            fontWeight: FontWeight.w600,
          ),
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
          label: 'Umpan Balik & Pembahasan Jawaban',
          initialValue: slide['explanation'] as String? ?? '',
          hint: 'Mengapa opsi tersebut benar?',
          maxLines: 3,
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
    final slide = widget.slide;
    final concepts = ((slide['mastered_concepts'] as List?) ?? const [])
        .map((e) => e.toString())
        .join(', ');
    final p = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Slide Penutup',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Rangkuman Bab',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Rangkuman Materi & Capaian',
          initialValue: slide['summary'] as String? ?? '',
          hint: 'Ringkasan capaian siswa setelah menuntaskan bab...',
          maxLines: 4,
          onChanged: (value) => slide['summary'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Konsep yang Dikuasai (pisahkan dengan koma)',
          initialValue: concepts,
          hint: 'Variabel, Percabangan, Perulangan',
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
                  'Siswa otomatis mengklaim ${widget.xpReward} XP saat '
                  'mencapai slide ini.',
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
