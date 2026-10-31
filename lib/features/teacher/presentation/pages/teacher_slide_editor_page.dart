// FILE: lib/features/teacher/presentation/pages/teacher_slide_editor_page.dart
//
// TUGAS: Layar editor satu slide. Dipanggil dari Bab Builder dengan URL
// /materi-pengajar/:lessonId/silabus/:babId/slide/:type/:index sehingga
// setiap tipe slide punya layar dan tautan sendiri.

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
