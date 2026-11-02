// FILE: lib/features/teacher/presentation/pages/teacher_slide_editor_page.dart
//
// TUGAS: Layar editor satu slide. Dipanggil dari Bab Builder dengan URL
// /editor-slide-pengajar/:lessonId/:babId/:type/:index sehingga setiap tipe slide
// punya layar dan tautan sendiri.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../lesson/presentation/pages/lesson_reader_page.dart';
import '../../domain/slide_adapter.dart';
import '../../domain/slide_templates.dart';
import '../../domain/teacher_models.dart';
import '../cubit/teacher_cubit.dart';
import '../widgets/slide_type_forms.dart';

/// Data yang dikirim dari Bab Builder lewat `GoRouter.extra`.
class SlideEditorArgs {
  const SlideEditorArgs({required this.slide, this.xpReward = 50});

  final Map<String, dynamic> slide;
  final int xpReward;
}

class TeacherSlideEditorPage extends StatefulWidget {
  const TeacherSlideEditorPage({
    super.key,
    required this.lessonId,
    required this.babId,
    required this.slideType,
    required this.slideIndex,
    this.initialSlide,
    this.xpReward = 50,
  });

  final String lessonId;
  final String babId;
  final String slideType;
  final int slideIndex;
  final Map<String, dynamic>? initialSlide;
  final int xpReward;

  @override
  State<TeacherSlideEditorPage> createState() => _TeacherSlideEditorPageState();
}

class _TeacherSlideEditorPageState extends State<TeacherSlideEditorPage> {
  late String _type;
  late Map<String, dynamic> _slide;
  late int _xpReward;
  int _formVersion = 0;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _loadError;
  Bab? _loadedBab;

  @override
  void initState() {
    super.initState();
    _type = SlideTemplates.normalize(widget.slideType);
    _xpReward = widget.xpReward;
    _slide = widget.initialSlide != null
        ? SlideTemplates.copy(widget.initialSlide!)
        : SlideTemplates.create(_type, xpReward: _xpReward);
    _slide['type'] = _type;

    // Kalau halaman dibuka lewat URL langsung (mis. refresh browser), data
    // slide tidak ikut terkirim lewat `extra`. Ambil ulang dari server agar
    // tombol Simpan tidak menimpa slide asli dengan template kosong.
    if (widget.initialSlide == null && widget.babId != 'baru') {
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadSlide());
    }
  }

  Future<void> _loadSlide() async {
    if (!mounted) return;
    final cubit = context.read<TeacherCubit>();
    await cubit.loadBabs(widget.lessonId);
    if (!mounted) return;

    Bab? bab;
    for (final item in cubit.state.babs) {
      if (item.id == widget.babId) {
        bab = item;
        break;
      }
    }
    final slides = bab?.slides ?? const <Map<String, dynamic>>[];
    if (widget.slideIndex < 0 || widget.slideIndex >= slides.length) {
      setState(() {
        _isLoading = false;
        _loadError =
            cubit.state.errorMessage ??
            'Slide tidak ditemukan. Buka Bab Builder untuk memilih slide lain.';
      });
      return;
    }

    final loaded = SlideTemplates.copy(slides[widget.slideIndex]);
    if (bab != null) _xpReward = bab.xpReward;
    if (SlideTemplates.normalize(loaded['type']) == 'OUTRO') {
      loaded['xp_preview'] = _xpReward;
    }
    setState(() {
      _loadedBab = bab;
      _slide = loaded;
      _type = SlideTemplates.normalize(loaded['type']);
      _slide['type'] = _type;
      _formVersion++;
      _isLoading = false;
      _loadError = null;
    });
  }

  void _backToBabEditor() {
    if (widget.babId == 'baru') {
      context.go(AppRoutes.teacherBabCreate(widget.lessonId));
    } else {
      context.go(AppRoutes.teacherBabEdit(widget.lessonId, widget.babId));
    }
  }

  void _applyTemplate() {
    setState(() {
      _slide = SlideTemplates.create(
        _type,
        id: _slide['id'] as String?,
        xpReward: _xpReward,
      );
      _formVersion++;
    });
    showAppSnack(
      context,
      'Template awal ${SlideTemplates.label(_type)} dipakai.',
    );
  }

  void _preview() {
    final title = (_slide['title'] as String?)?.trim();
    final previewData = SlideAdapter.singleSlidePreview(
      id: '${widget.lessonId}_${widget.slideIndex}',
      title: title == null || title.isEmpty
          ? SlideTemplates.label(_type)
          : title,
      xpReward: _xpReward,
      slide: _slide,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LessonReaderPage(
          lessonId: widget.lessonId,
          isTeacherPreview: true,
          previewData: previewData,
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_isSaving) return;
    final result = SlideTemplates.copy(_slide);

    // Bersihkan + periksa isian sebelum keluar dari halaman ini. Kalau ada
    // yang kurang, penyimpanan dibatalkan dan guru tetap di form dengan
    // isian yang sudah diketik (tidak ada data yang hilang).
    final validation = _SlideGuard(result, _type).run();
    if (validation != null) {
      showAppSnack(context, validation);
      return;
    }

    if (SlideTemplates.normalize(result['type']) == 'OUTRO') {
      result['xp_preview'] = _xpReward;
    }

    // Jalur normal: dibuka dari Bab Builder, hasil dikembalikan ke halaman
    // induk yang akan menyimpan seluruh daftar slide.
    if (widget.initialSlide != null) {
      if (context.canPop()) {
        context.pop(result);
      } else {
        _backToBabEditor();
      }
      return;
    }

    // URL langsung (refresh/bookmark) tidak punya halaman induk yang menunggu
    // hasil. Simpan slide ini langsung ke bab agar tombol Simpan tidak menjadi
    // tombol kosong.
    if (widget.babId == 'baru') {
      showAppSnack(
        context,
        'Bab baru belum tersimpan. Tambahkan slide dari Bab Builder agar tersimpan bersama bab.',
      );
      _backToBabEditor();
      return;
    }

    final bab = _loadedBab;
    if (bab == null ||
        widget.slideIndex < 0 ||
        widget.slideIndex >= bab.slides.length) {
      showAppSnack(
        context,
        'Slide tidak dapat disimpan. Buka Bab Builder untuk memuat ulang bab.',
      );
      return;
    }

    final cubit = context.read<TeacherCubit>();
    final updatedSlides = bab.slides
        .map((slide) => SlideTemplates.copy(slide))
        .toList();
    updatedSlides[widget.slideIndex] = result;

    setState(() => _isSaving = true);
    final saved = await cubit.updateBab(
      widget.babId,
      widget.lessonId,
      title: bab.title,
      xpReward: bab.xpReward,
      slides: updatedSlides,
    );
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (saved == null) {
      showAppSnack(
        context,
        cubit.state.errorMessage ?? 'Slide gagal disimpan. Coba lagi.',
      );
      cubit.clearMessages();
      return;
    }

    showAppSnack(context, 'Slide tersimpan ke bab.');
    _backToBabEditor();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editor Slide')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Editor Slide')),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_off_rounded, size: 48, color: p.textMuted),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Slide Tidak Dapat Dimuat',
                    style: AppTypography.titleM.copyWith(color: p.text),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    _loadError!,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyM.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  AppButton(
                    label: 'Buka Bab Builder',
                    leadingIcon: Icons.menu_book_rounded,
                    onPressed: _backToBabEditor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final title = (_slide['title'] as String?)?.trim();
    final displayTitle = title == null || title.isEmpty
        ? SlideTemplates.label(_type)
        : title;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor Slide'),
        actions: [
          IconButton(
            tooltip: 'Pratinjau slide',
            icon: const Icon(Icons.remove_red_eye_outlined),
            onPressed: _preview,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: p.primaryContainer.withAlpha(25),
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.primary.withAlpha(60)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: p.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  SlideTemplates.badge(_type),
                                  style: AppTypography.labelSm.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  'Slide ${widget.slideIndex + 1} • ${SlideTemplates.label(_type)}',
                                  style: AppTypography.labelSm.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            displayTitle,
                            style: AppTypography.titleM.copyWith(
                              color: p.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            SlideTemplates.description(_type),
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton.icon(
                      onPressed: _preview,
                      icon: const Icon(
                        Icons.play_circle_outline_rounded,
                        size: 18,
                      ),
                      label: const Text('Pratinjau sebagai Siswa'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: p.primary,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        side: BorderSide(color: p.primary.withAlpha(120)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SlideTypeForm(
                      key: ValueKey('${_type}_$_formVersion'),
                      type: _type,
                      slide: _slide,
                      xpReward: _xpReward,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton.icon(
                      onPressed: _applyTemplate,
                      icon: const Icon(Icons.restart_alt_rounded, size: 18),
                      label: const Text('Pakai Template Awal'),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.screen),
              decoration: BoxDecoration(
                color: p.surface,
                border: Border(top: BorderSide(color: p.outline)),
              ),
              child: AppButton(
                label: 'Simpan Slide',
                leadingIcon: Icons.check_circle_outline_rounded,
                loading: _isSaving,
                onPressed: _save,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Membersihkan dan memeriksa isi slide sebelum dikirim ke Bab Builder.
///
/// Tiga tugasnya:
/// 1. Membuang karakter kontrol yang tidak terlihat (null byte, escape
///    sequence) supaya isian tidak bisa dipakai menyusupkan perintah ke
///    JSON/penyimpanan, serta menyeragamkan akhir baris menjadi `\n`.
/// 2. Menolak teks yang melebihi batas panjang kolomnya.
/// 3. Memastikan field penting terisi dan cocok dengan cara slide dibaca
///    siswa, sehingga tidak ada slide "setengah jadi" yang tersimpan.
///
/// Hasil pembersihan langsung ditulis kembali ke [slide] agar yang disimpan
/// adalah versi bersih, bukan teks mentah.
class _SlideGuard {
  _SlideGuard(this.slide, this.type);

  final Map<String, dynamic> slide;
  final String type;

  static const _codeLangs = ['HTML', 'CSS', 'JavaScript', 'Python'];
  static const _choiceLetters = ['A', 'B', 'C', 'D'];

  // Batas panjang per jenis isian.
  static const _titleMax = 120;
  static const _shortMax = 300;
  static const _hintMax = 400;
  static const _longMax = 4000;
  static const _codeMax = 8000;
  static const _optionMax = 200;

  static const _controlChars =
      r'[\u0000-\u0008\u000B\u000C\u000E-\u001F\u007F]';

  String? _error;

  /// Menjalankan seluruh pemeriksaan. `null` berarti isian lolos.
  String? run() {
    switch (type) {
      case 'TAP_TO_FILL':
        _required('title', 'Judul latihan', max: _titleMax);
        _optional('prompt', 'Instruksi', max: _shortMax, multiline: true);
        _tapTemplate();
        _codeLang('HTML');
        break;

      case 'TYPE_CODE':
        _required('title', 'Judul soal', max: _titleMax);
        _optional('prompt', 'Instruksi', max: _shortMax, multiline: true);
        final code = _required(
          'code',
          'Kode soal',
          max: _codeMax,
          multiline: true,
        );
        if (code.isNotEmpty && !code.contains('[KETIK_DISINI]')) {
          _fail(
            'Kode soal belum punya penanda [KETIK_DISINI] sebagai tempat '
            'siswa mengetik.',
          );
        }
        _required('answer', 'Kata kunci jawaban', max: _optionMax);
        _optional('hint', 'Petunjuk', max: _hintMax, multiline: true);
        break;

      case 'OUTPUT_PREDICT':
        _required('title', 'Judul slide', max: _titleMax);
        _optional('prompt', 'Instruksi', max: _shortMax, multiline: true);
        _required('code', 'Blok kode', max: _codeMax, multiline: true);
        _choices('options', 'pilihan output');
        _optional('explanation', 'Penjelasan', max: _longMax, multiline: true);
        break;

      case 'BUG_HUNTER':
        _required('title', 'Judul tantangan', max: _titleMax);
        _optional('scenario', 'Skenario', max: _shortMax, multiline: true);
        final buggy = _required(
          'buggy_code',
          'Kode program',
          max: _codeMax,
          multiline: true,
        );
        _bugTarget(buggy);
        _optional('error_type', 'Jenis error', max: 60);
        _optional(
          'bug_hint',
          'Pesan indikator',
          max: _hintMax,
          multiline: true,
        );
        _optional('fix', 'Kode perbaikan', max: _codeMax, multiline: true);
        if ((slide['bug_hint'] as String?)?.isEmpty ?? true) {
          if ((slide['fix'] as String?)?.isEmpty ?? true) {
            _fail(
              'Isi "Pesan Indikator" atau "Kode Perbaikan Valid" agar siswa '
              'mendapat penjelasan setelah menjawab.',
            );
          }
        }
        if ((slide['error_type'] as String?)?.isEmpty ?? true) {
          slide['error_type'] = 'SyntaxError';
        }
        break;

      case 'QUIZ':
        _required('title', 'Judul slide', max: _titleMax);
        _required(
          'question',
          'Pertanyaan kuis',
          max: _shortMax,
          multiline: true,
        );
        _choices('options', 'pilihan jawaban');
        _optional('explanation', 'Umpan balik', max: _longMax, multiline: true);
        break;

      case 'OUTRO':
        _required('title', 'Judul slide penutup', max: _titleMax);
        _required(
          'summary',
          'Rangkuman materi',
          max: _longMax,
          multiline: true,
        );
        final concepts = _list(
          slide['mastered_concepts'],
          label: 'Konsep yang dikuasai',
          max: 60,
          limit: 12,
        );
        slide['mastered_concepts'] = concepts;
        if (concepts.isEmpty) {
          _fail('Isi minimal satu konsep yang dikuasai.');
        }
        break;

      case 'THEORY':
      default:
        _required('title', 'Judul materi teori', max: _titleMax);
        _required(
          'content',
          'Konten penjelasan',
          max: _longMax,
          multiline: true,
        );
        _codeLang('Python');
        _optional(
          'sample_code',
          'Cuplikan kode sampel',
          max: _codeMax,
          multiline: true,
        );
        break;
    }
    return _error;
  }

  void _fail(String message) => _error ??= message;

  /// Membersihkan satu teks: akhir baris diseragamkan, karakter kontrol
  /// dibuang, spasi berlebih dirapikan, lalu panjangnya diperiksa.
  String _clean(
    Object? raw, {
    required int max,
    required String label,
    bool multiline = false,
  }) {
    var value = (raw is String ? raw : raw?.toString() ?? '')
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');
    value = value.replaceAll(RegExp(_controlChars), '');
    if (!multiline) {
      value = value.replaceAll(RegExp(r'\s+'), ' ');
    }
    value = value.trim();
    if (value.length > max) {
      _fail('$label terlalu panjang (maksimal $max karakter).');
    }
    return value;
  }

  String _required(
    String key,
    String label, {
    int max = _shortMax,
    bool multiline = false,
  }) {
    final value = _clean(
      slide[key],
      max: max,
      label: label,
      multiline: multiline,
    );
    slide[key] = value;
    if (value.isEmpty) _fail('$label wajib diisi.');
    return value;
  }

  void _optional(
    String key,
    String label, {
    int max = _shortMax,
    bool multiline = false,
  }) {
    slide[key] = _clean(
      slide[key],
      max: max,
      label: label,
      multiline: multiline,
    );
  }

  List<String> _list(
    Object? raw, {
    required String label,
    int max = _optionMax,
    int limit = 12,
  }) {
    final values = <String>[];
    if (raw is List) {
      for (final item in raw) {
        final value = _clean(item, max: max, label: label);
        if (value.isNotEmpty) values.add(value);
      }
    }
    if (values.length > limit) {
      _fail('$label maksimal $limit butir.');
      return values.sublist(0, limit);
    }
    return values;
  }

  /// Bahasa kode hanya boleh salah satu dari daftar yang dikenal adapter;
  /// nilai lain akan jatuh ke [fallback] supaya nama berkas tidak ngawur.
  void _codeLang(String fallback) {
    final raw = _clean(
      slide['code_lang'],
      max: 20,
      label: 'Bahasa kode',
    ).toLowerCase();
    var value = fallback;
    for (final lang in _codeLangs) {
      if (lang.toLowerCase() == raw) value = lang;
    }
    slide['code_lang'] = value;
  }

  /// Empat pilihan A–D harus terisi semua dan punya kunci yang sah.
  void _choices(String key, String label) {
    final options = _list(slide[key], label: label, limit: 4);
    while (options.length < 4) {
      options.add('');
    }
    slide[key] = options;

    for (var i = 0; i < options.length; i++) {
      if (options[i].isEmpty) {
        _fail('Pilihan ${_choiceLetters[i]} pada $label masih kosong.');
      }
    }

    final answer = _clean(
      slide['answer'],
      max: 40,
      label: 'Kunci jawaban',
    ).toUpperCase();
    if (!_choiceLetters.contains(answer)) {
      _fail('Pilih salah satu kunci jawaban A–D pada $label.');
      return;
    }
    slide['answer'] = answer;
  }

  /// Memeriksa template slot ___1___ beserta kunci dan pengecohnya.
  void _tapTemplate() {
    final template = _required(
      'template',
      'Template kode',
      max: _codeMax,
      multiline: true,
    );
    final slots = RegExp(r'_{2,}\d*_{2,}').allMatches(template).length;
    if (template.isNotEmpty && slots == 0) {
      _fail(
        'Template kode belum punya slot. Tandai bagian kosong dengan '
        '___1___, ___2___, dan seterusnya.',
      );
    }

    var blanks = _list(slide['blanks'], label: 'Kunci jawaban slot', limit: 40);
    if (blanks.length > slots) blanks = blanks.sublist(0, slots);
    while (blanks.length < slots) {
      blanks.add('');
    }
    for (var i = 0; i < slots; i++) {
      if (blanks[i].isEmpty) {
        _fail('Kunci jawaban slot ${i + 1} masih kosong.');
      }
    }
    slide['blanks'] = blanks;

    final distractors = _list(
      slide['distractors'],
      label: 'Pengecoh',
      max: 60,
      limit: 8,
    );
    slide['distractors'] = distractors;
    if (distractors.isEmpty) {
      _fail('Tambahkan minimal satu pengecoh agar soal bisa dipilih.');
    } else if (distractors.every(blanks.contains)) {
      _fail(
        'Semua pengecoh sama dengan kunci jawaban. Tambahkan pilihan lain.',
      );
    }
  }

  /// Nomor baris bug harus menunjuk baris yang benar-benar ada.
  void _bugTarget(String buggyCode) {
    final lineCount = buggyCode.isEmpty ? 1 : buggyCode.split('\n').length;
    final raw = _clean(
      slide['target_line'],
      max: 8,
      label: 'Target nomor baris',
    );
    final line = int.tryParse(raw);
    if (line == null) {
      _fail('Target nomor baris harus berupa angka.');
      return;
    }
    if (line < 1 || line > lineCount) {
      _fail(
        'Target nomor baris harus antara 1 dan $lineCount sesuai jumlah '
        'baris kode.',
      );
      return;
    }
    slide['target_line'] = line;

    // Adapter siswa mendahulukan `bug_line_index` bila ada. Hapus sisa nilai
    // lama supaya nomor baris yang diisi di form benar-benar dipakai.
    slide.remove('bug_line_index');
  }
}
