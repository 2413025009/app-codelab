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
    final slide = widget.slide;
    final codeLang = slide['code_lang'] as String? ?? 'Python';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SlideFormField(
          label: 'Judul Materi Teori',
          initialValue: slide['title'] as String? ?? '',
          hint: 'Contoh: Struktur Dasar Dokumen HTML5',
          help:
              'Judul tampil paling atas di layar siswa.\n'
              '- Buat ringkas dan spesifik, maksimal 120 karakter.\n'
              '- Sebut inti konsepnya, bukan nama bab.',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Konten Penjelasan (mendukung Markdown)',
          initialValue: slide['content'] as String? ?? '',
          hint: 'Tuliskan konsep utama, poin-poin, atau contoh...',
          maxLines: 6,
          help:
              'Cara menulis isi materi:\n'
              '- Pisahkan paragraf dengan satu baris kosong.\n'
              '- Baris yang diawali "- " atau "* " otomatis jadi butir daftar.\n'
              '- Selain itu teks ditampilkan apa adanya: **tebal**, # judul, '
              'tautan, dan `kode` tidak diformat.\n'
              '\n'
              'Contoh:\n'
              'HTML adalah bahasa penanda untuk menyusun halaman web.\n'
              '\n'
              '- Tag dibuka lalu ditutup.\n'
              '- Atribut menempel pada tag pembuka.',
          onChanged: (value) => slide['content'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideChipPicker(
          label: 'Bahasa Kode Sampel',
          values: const ['HTML', 'CSS', 'JavaScript', 'Python'],
          selected: codeLang,
          help:
              'Hanya menentukan nama berkas pada kartu kode:\n'
              '- HTML → index.html\n'
              '- CSS → style.css\n'
              '- JavaScript → script.js\n'
              '- Python → script.py',
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
          help:
              'Kode contoh yang tampil di kotak kode di bawah penjelasan.\n'
              '- Kosongkan bila slide tidak perlu contoh kode.\n'
              '- Tulis kode aslinya saja, tanpa penanda blok markdown.\n'
              '- Maksimal 8000 karakter.',
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
          help:
              'Judul tampil di kepala soal, maksimal 120 karakter.\n'
              'Contoh: "Lengkapi Tag Penutup HTML".',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Instruksi Singkat',
          initialValue: slide['prompt'] as String? ?? '',
          hint: 'Instruksi pengerjaan bagi siswa...',
          maxLines: 2,
          help:
              'Satu sampai dua kalimat arahan sebelum siswa mengetuk slot.\n'
              '- Jelaskan bagian mana yang harus dilengkapi.\n'
              '- Jangan sebut jawabannya di sini.',
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Template Kode (gunakan ___1___ untuk slot)',
          initialValue: _template,
          hint: 'x = ___1___\nprint(x)',
          maxLines: 4,
          monospace: true,
          help:
              'Tempel kode di sini, lalu tandai bagian kosong dengan '
              '___1___, ___2___, dan seterusnya.\n'
              '- Penanda dikenali selama memakai minimal dua garis bawah di '
              'awal dan akhir, dengan angka opsional di tengah.\n'
              '- Urutan slot mengikuti urutan kemunculannya di dalam kode.\n'
              '- Satu slot berarti satu jawaban; jangan menaruh dua slot '
              'untuk jawaban yang sama.\n'
              '\n'
              'Contoh:\nx = ___1___\nprint(x)',
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
          label: 'Kunci jawaban per slot ($_slotCount slot terdeteksi)',
          help:
              'Isi jawaban benar untuk setiap slot sesuai urutan kemunculan.\n'
              '- Spasi di awal/akhir diabaikan, tetapi huruf besar-kecil '
              'dihitung: tulis "print", bukan "Print".\n'
              '- Tulis persis seperti yang seharusnya ada di dalam kode.\n'
              '- Jumlah isian mengikuti jumlah slot yang terdeteksi.',
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
          help:
              'Kata tambahan yang muncul sebagai pilihan, tetapi bukan '
              'jawaban benar.\n'
              '- Pisahkan dengan koma.\n'
              '- Pengecoh yang sama dengan kunci otomatis dibuang.\n'
              '- Sisakan minimal satu agar siswa benar-benar harus memilih.',
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
          help:
              'Menentukan nama berkas pada kartu kode:\n'
              '- HTML → index.html\n'
              '- CSS → style.css\n'
              '- JavaScript → script.js\n'
              '- Python → script.py',
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
          help:
              'Judul tampil di kepala soal, maksimal 120 karakter.\n'
              'Contoh: "Deklarasi Variabel Python".',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Instruksi Interaktif',
          initialValue: slide['prompt'] as String? ?? '',
          hint: 'Ketikkan kata kunci untuk mendeklarasikan variabel...',
          maxLines: 2,
          help:
              'Arahan singkat yang dibaca siswa sebelum mengetik.\n'
              '- Sebutkan apa yang harus dicari tanpa memberi jawabannya.\n'
              '- Maksimal 300 karakter.',
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kode Soal ([KETIK_DISINI] = titik input)',
          initialValue: slide['code'] as String? ?? '',
          hint: '[KETIK_DISINI] nama_siswa = "Ahmad"',
          maxLines: 4,
          monospace: true,
          help:
              'Tulis potongan kode, lalu ganti bagian yang harus diisi dengan '
              '[KETIK_DISINI].\n'
              '- Penanda itu berubah menjadi kotak input di layar siswa.\n'
              '- Boleh lebih dari satu penanda dalam satu slide.\n'
              '- Tanpa penanda, siswa tidak punya tempat mengetik jawaban.',
          onChanged: (value) => slide['code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kata Kunci Jawaban Benar',
          initialValue: slide['answer'] as String? ?? '',
          hint: 'Contoh: def / const / let',
          help:
              'Jawaban yang dianggap benar.\n'
              '- Perbandingan mengabaikan spasi awal/akhir dan huruf '
              'besar-kecil, jadi "Print" sama dengan "print".\n'
              '- Isi satu kata kunci atau ekspresi pendek saja.',
          onChanged: (value) => slide['answer'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Petunjuk Jika Salah (AI Hint)',
          initialValue: slide['hint'] as String? ?? '',
          hint: 'Ingat penulisan huruf kecil semua.',
          maxLines: 2,
          help:
              'Bantuan yang muncul ketika jawaban siswa salah.\n'
              '- Beri petunjuk arah, jangan tulis jawabannya langsung.\n'
              '- Satu sampai dua kalimat sudah cukup.',
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
          help:
              'Judul tampil di kepala slide, maksimal 120 karakter.\n'
              'Contoh: "Tebak Output Operator Modulo".',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Instruksi Tantangan',
          initialValue: slide['prompt'] as String? ?? '',
          hint: 'Apakah output yang dicetak ke terminal?',
          maxLines: 2,
          help:
              'Pertanyaan singkat di atas blok kode.\n'
              'Biasanya cukup: "Apakah output yang dicetak ke terminal?".',
          onChanged: (value) => slide['prompt'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Blok Kode Sumber Program',
          initialValue: slide['code'] as String? ?? '',
          maxLines: 5,
          monospace: true,
          help:
              'Kode yang dibaca siswa untuk menebak output.\n'
              '- Tulis persis seperti program aslinya.\n'
              '- Kode hanya ditampilkan, tidak dijalankan, jadi hasilnya harus '
              'bisa ditebak dari isi kode.',
          onChanged: (value) => slide['code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFieldLabel(
          label: 'Opsi output terminal (pilih satu jawaban benar)',
          help:
              'Isi keempat pilihan (A sampai D).\n'
              '- Ketuk lingkaran di kiri untuk menandai kunci jawaban.\n'
              '- Satu pilihan harus persis sama dengan output sebenarnya.\n'
              '- Jangan biarkan pilihan kosong: pilihan kosong tetap tampil '
              'di layar siswa.',
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
          help:
              'Muncul setelah siswa menjawab, benar maupun salah.\n'
              'Jelaskan alasan output itu muncul, misalnya urutan operasi '
              'atau tipe data yang terlibat.',
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
          help:
              'Judul tampil di kepala tantangan, maksimal 120 karakter.\n'
              'Contoh: "Mencari Kesalahan Loop For".',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Skenario Error & Target Belajar',
          initialValue: slide['scenario'] as String? ?? '',
          hint: 'Deskripsi konteks masalah...',
          maxLines: 2,
          help:
              'Konteks singkat masalah yang dihadapi siswa; tampil sebagai '
              'instruksi di atas kode.\n'
              'Ceritakan situasinya, jangan sebut nomor baris yang salah.',
          onChanged: (value) => slide['scenario'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kode Program Lengkap (dengan bug)',
          initialValue: slide['buggy_code'] as String? ?? '',
          maxLines: 6,
          monospace: true,
          help:
              'Seluruh kode yang mengandung bug.\n'
              '- Nomor baris dihitung dari 1 mengikuti urutan baris di kotak '
              'ini, termasuk baris kosong.\n'
              '- Sisipkan bug yang benar-benar bisa dijelaskan oleh "Jenis '
              'Error" dan "Kode Perbaikan".',
          onChanged: (value) => slide['buggy_code'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Target Nomor Baris Bug',
          initialValue: slide['target_line']?.toString() ?? '1',
          hint: 'Contoh: 2',
          keyboardType: TextInputType.number,
          help:
              'Nomor baris yang benar, dihitung dari 1.\n'
              '- Harus berada di antara 1 dan jumlah baris kode di atas.\n'
              '- Bila di luar jangkauan, layar siswa mengunci ke baris '
              'terdekat sehingga jawaban tidak pernah cocok.',
          onChanged: (value) => slide['target_line'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Jenis Error',
          initialValue: slide['error_type'] as String? ?? 'SyntaxError',
          hint: 'SyntaxError / IndentationError / NameError',
          help:
              'Label kategori galat yang tampil ke siswa.\n'
              'Contoh: SyntaxError, IndentationError, NameError.',
          onChanged: (value) => slide['error_type'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Pesan Indikator / Hint Letak Bug',
          initialValue: slide['bug_hint'] as String? ?? '',
          hint: 'Kurang tanda titik dua (:) di akhir pernyataan for',
          maxLines: 2,
          help:
              'Teks ini menjadi penjelasan yang muncul setelah siswa '
              'menjawab.\n'
              '- Jelaskan aturan yang dilanggar di baris tersebut.\n'
              '- Bila dikosongkan, "Kode Perbaikan Valid" yang dipakai '
              'sebagai penjelasan.',
          onChanged: (value) => slide['bug_hint'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Kode Perbaikan Valid',
          initialValue: slide['fix'] as String? ?? '',
          hint: 'for i in range(10):',
          maxLines: 3,
          monospace: true,
          help:
              'Cuplikan perbaikan yang benar untuk baris yang ditandai.\n'
              '- Dipakai sebagai contoh solusi sekaligus penjelasan cadangan '
              'bila "Pesan Indikator" kosong.\n'
              '- Tulis hanya bagian yang diperbaiki, bukan seluruh program.',
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
          help:
              'Judul tampil di kepala kuis, maksimal 120 karakter.\n'
              'Contoh: "Memahami Tipe Data".',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Pertanyaan Kuis',
          initialValue: slide['question'] as String? ?? '',
          hint: 'Tuliskan pertanyaan konseptual...',
          maxLines: 3,
          help:
              'Pertanyaan dengan satu jawaban benar.\n'
              '- Ajukan satu konsep saja, jangan digabung.\n'
              '- Maksimal 300 karakter.',
          onChanged: (value) => slide['question'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFieldLabel(
          label: 'Daftar pilihan jawaban (pilih satu kunci benar)',
          help:
              'Isi keempat pilihan (A sampai D).\n'
              '- Ketuk lingkaran di kiri untuk menandai kunci jawaban.\n'
              '- Jangan biarkan pilihan kosong karena tetap tampil sebagai '
              'opsi kosong di layar siswa.',
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
          help:
              'Muncul setelah siswa menjawab, benar maupun salah.\n'
              'Jelaskan mengapa kunci jawabannya benar dan, bila perlu, '
              'mengapa pengecohnya salah.',
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
          help:
              'Judul tampil di kepala slide penutup, maksimal 120 karakter.\n'
              'Contoh: "Rangkuman Bab".',
          onChanged: (value) => slide['title'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Rangkuman Materi & Capaian',
          initialValue: slide['summary'] as String? ?? '',
          hint: 'Ringkasan capaian siswa setelah menuntaskan bab...',
          maxLines: 4,
          help:
              'Ringkasan yang dibaca siswa di akhir bab.\n'
              '- Sebut kembali konsep utama yang baru dipelajari.\n'
              '- Beri penutup yang memotivasi, bukan soal baru.',
          onChanged: (value) => slide['summary'] = value,
        ),
        const SizedBox(height: AppSpacing.md),
        SlideFormField(
          label: 'Konsep yang Dikuasai (pisahkan dengan koma)',
          initialValue: concepts,
          hint: 'Variabel, Percabangan, Perulangan',
          help:
              'Daftar konsep yang dianggap dikuasai setelah bab ini.\n'
              '- Pisahkan dengan koma, misalnya: Variabel, Perulangan.\n'
              '- Setiap konsep tampil sebagai label capaian.\n'
              '- Isi minimal satu konsep.',
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
