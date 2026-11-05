// FILE: lib/features/teacher/presentation/pages/bab_editor_page.dart
//
// TUGAS: Bab Builder & Slide Editor untuk 7 tipe slide (Minggu 11-12).
// Sesuai Stitch v3: editor_bab_bab_builder_codelab_ai & CONTOH_LESSON.md.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../cubit/teacher_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';
import '../widgets/slide_type_preview_sheet.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';
import '../../domain/slide_adapter.dart';
import '../../domain/slide_templates.dart';
import '../../../lesson/presentation/pages/lesson_reader_page.dart';
import 'teacher_slide_editor_page.dart';

class BabEditorPage extends StatefulWidget {
  const BabEditorPage({
    super.key,
    required this.lessonId,
    this.babId,
    this.initialBab,
  });

  final String lessonId;
  final String? babId;
  final Bab? initialBab;

  @override
  State<BabEditorPage> createState() => _BabEditorPageState();
}

class _BabEditorPageState extends State<BabEditorPage> {
  final _titleController = TextEditingController();
  int _xpReward = 50;
  bool _isSubmitting = false;
  bool _isLoading = false;
  String? _loadError;

  late List<Map<String, dynamic>> _slides;

  @override
  void initState() {
    super.initState();
    if (widget.initialBab != null) {
      _hydrateFromBab(widget.initialBab!);
    } else if (widget.babId != null) {
      // URL dibuka langsung (refresh/bookmark): `extra` tidak ikut terkirim.
      // Jangan pernah menampilkan bab kosong, karena tombol Simpan bisa
      // menimpa isi bab asli dengan template default.
      _slides = [];
      _isLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadBab());
    } else {
      // Default slides for a fresh bab: 1 Theory + 1 Quiz + 1 Outro
      _slides = [
        SlideTemplates.create('THEORY', id: 'slide_1'),
        SlideTemplates.create('QUIZ', id: 'slide_2'),
        SlideTemplates.create('OUTRO', id: 'slide_3', xpReward: _xpReward),
      ];
    }
  }

  void _hydrateFromBab(Bab bab) {
    _titleController.text = bab.title;
    _xpReward = bab.xpReward;
    _slides = bab.slides.map((slide) => SlideTemplates.copy(slide)).toList();
    _syncOutroXp();
  }

  Future<void> _loadBab() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<TeacherCubit>();
    await cubit.loadBabs(widget.lessonId);
    if (!mounted) return;

    final bab = cubit.state.babs
        .where((item) => item.id == widget.babId)
        .firstOrNull;
    if (bab == null) {
      setState(() {
        _isLoading = false;
        _loadError = teacherErrorText(
          l10n,
          cubit.state.errorCode,
          cubit.state.errorMessage ?? l10n.tBabNotFound,
        );
      });
      return;
    }

    setState(() {
      _hydrateFromBab(bab);
      _isLoading = false;
      _loadError = null;
    });
  }

  void _syncOutroXp() {
    for (final slide in _slides) {
      if (SlideTemplates.normalize(slide['type']) == 'OUTRO') {
        slide['xp_preview'] = _xpReward;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.babId != null || widget.initialBab != null;
  String? get _currentBabId => widget.babId ?? widget.initialBab?.id;

  void _adjustXp(int delta) {
    setState(() {
      _xpReward = (_xpReward + delta).clamp(10, 500);
      _syncOutroXp();
    });
  }

  Future<void> _addSlideAndEdit(String type) async {
    final l10n = AppLocalizations.of(context);
    final normalized = SlideTemplates.normalize(type);
    final slide =
        SlideTemplates.create(normalized, xpReward: _xpReward, l10n: l10n);
    final edited = await _pushSlideEditor(slide, _slides.length);
    if (!mounted || edited == null) return;
    setState(() => _slides.add(edited));
  }

  Future<void> _openSlideEditor(int index) async {
    if (index < 0 || index >= _slides.length) return;
    final edited = await _pushSlideEditor(_slides[index], index);
    if (!mounted || edited == null) return;
    setState(() {
      _slides[index] = SlideTemplates.copy(edited);
      // Slide penutup mengikuti XP bab yang aktif.
      if (SlideTemplates.normalize(_slides[index]['type']) == 'OUTRO') {
        _slides[index]['xp_preview'] = _xpReward;
      }
    });
  }

  Future<Map<String, dynamic>?> _pushSlideEditor(
    Map<String, dynamic> slide,
    int index,
  ) {
    final type = SlideTemplates.normalize(slide['type']);
    final babId = _currentBabId ?? 'baru';
    return context.push<Map<String, dynamic>>(
      AppRoutes.teacherSlideEditor(
        lessonId: widget.lessonId,
        babId: babId,
        type: type,
        index: index,
      ),
      extra: SlideEditorArgs(
        slide: SlideTemplates.copy(slide),
        xpReward: _xpReward,
      ),
    );
  }

  String _slideSummary(Map<String, dynamic> slide) {
    final l10n = AppLocalizations.of(context);
    final type = SlideTemplates.normalize(slide['type']);
    final String raw;
    switch (type) {
      case 'TAP_TO_FILL':
        raw = (slide['template'] as String?)?.trim() ?? '';
        break;
      case 'TYPE_CODE':
        raw = (slide['prompt'] as String?)?.trim() ?? '';
        break;
      case 'OUTPUT_PREDICT':
        raw =
            (slide['prompt'] as String?)?.trim() ??
            (slide['code'] as String?)?.trim() ??
            '';
        break;
      case 'BUG_HUNTER':
        raw =
            (slide['scenario'] as String?)?.trim() ??
            (slide['buggy_code'] as String?)?.trim() ??
            '';
        break;
      case 'QUIZ':
        raw = (slide['question'] as String?)?.trim() ?? '';
        break;
      case 'OUTRO':
        raw = (slide['summary'] as String?)?.trim() ?? '';
        break;
      case 'THEORY':
      default:
        raw = (slide['content'] as String?)?.trim() ?? '';
        break;
    }
    if (raw.isEmpty) return l10n.tBabSlideEmptyHint;
    return raw.replaceAll('\n', ' ');
  }

  void _removeSlide(int index) {
    if (_slides.length <= 1) {
      showAppSnack(context, AppLocalizations.of(context).tBabMinSlides);
      return;
    }
    setState(() => _slides.removeAt(index));
  }

  void _moveSlide(int index, int delta) {
    final newIndex = index + delta;
    if (newIndex < 0 || newIndex >= _slides.length) return;
    setState(() {
      final item = _slides.removeAt(index);
      _slides.insert(newIndex, item);
    });
  }

  void _showAddSlidePicker() {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: p.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final slideTypes = [
          {
            'type': 'THEORY',
            'name': l10n.tBabTypeTheoryName,
            'desc': l10n.tBabSheetDescTheory,
            'icon': Icons.menu_book_rounded,
            'badge': l10n.tBabTypeTheoryBadge,
          },
          {
            'type': 'TAP_TO_FILL',
            'name': l10n.tBabTypeTapName,
            'desc': l10n.tBabSheetDescTap,
            'icon': Icons.extension_rounded,
            'badge': l10n.tBabTypeTapBadge,
          },
          {
            'type': 'TYPE_CODE',
            'name': l10n.tBabTypeTypeName,
            'desc': l10n.tBabSheetDescType,
            'icon': Icons.keyboard_rounded,
            'badge': l10n.tBabTypeTypeBadge,
          },
          {
            'type': 'OUTPUT_PREDICT',
            'name': l10n.tBabTypeOutputName,
            'desc':
                l10n.tBabSheetDescOutput,
            'icon': Icons.terminal_rounded,
            'badge': l10n.tBabTypeOutputBadge,
          },
          {
            'type': 'BUG_HUNTER',
            'name': l10n.tBabTypeBugName,
            'desc': l10n.tBabSheetDescBug,
            'icon': Icons.pest_control_rounded,
            'badge': l10n.tBabTypeBugBadge,
          },
          {
            'type': 'QUIZ',
            'name': l10n.tBabTypeQuizName,
            'desc': l10n.tBabSheetDescQuiz,
            'icon': Icons.help_outline_rounded,
            'badge': l10n.tBabTypeQuizBadge,
          },
          {
            'type': 'OUTRO',
            'name': l10n.tBabTypeOutroName,
            'desc': l10n.tBabSheetDescOutro,
            'icon': Icons.celebration_rounded,
            'badge': l10n.tBabTypeOutroBadge,
          },
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.screen),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: p.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Text(
                      l10n.tBabPickerTitle,
                      style: AppTypography.titleM.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: p.primaryContainer.withAlpha(35),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.tBabFormatCount(slideTypes.length),
                        style: AppTypography.labelSm.copyWith(
                          color: p.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.tBabPickerHint,
                  style: AppTypography.bodySm.copyWith(color: p.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: slideTypes.length,
                    separatorBuilder: (_, index) =>
                        const Divider(height: 1, indent: 48),
                    itemBuilder: (ctx, i) {
                      final item = slideTypes[i];
                      final type = item['type'] as String;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: p.primaryContainer.withAlpha(40),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            color: p.primary,
                            size: 20,
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              item['name'] as String,
                              style: AppTypography.labelL.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: p.surfaceAlt,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: p.outline),
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: AppTypography.codeSm.copyWith(
                                  color: p.textMuted,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          item['desc'] as String,
                          style: AppTypography.bodySm.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove_red_eye_outlined,
                                size: 20,
                                color: p.primary,
                              ),
                              tooltip: l10n.tBabPreviewFormatTooltip,
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                SlideTypePreviewSheet.show(
                                  context,
                                  type: type,
                                  onUseType: () => _addSlideAndEdit(type),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add_circle_outline_rounded,
                                size: 20,
                                color: p.primary,
                              ),
                              tooltip: l10n.tBabPickerAddTooltip,
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                _addSlideAndEdit(type);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(ctx).pop();
                          SlideTypePreviewSheet.show(
                            context,
                            type: type,
                            onUseType: () => _addSlideAndEdit(type),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSave() async {
    if (_isSubmitting || _isLoading) return;
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showAppSnack(context, l10n.tBabTitleRequired);
      return;
    }

    if (_slides.isEmpty) {
      showAppSnack(context, l10n.tBabMinSlides);
      return;
    }

    setState(() => _isSubmitting = true);
    final cubit = context.read<TeacherCubit>();

    Bab? result;
    if (_isEdit && _currentBabId != null) {
      result = await cubit.updateBab(
        _currentBabId!,
        widget.lessonId,
        title: title,
        xpReward: _xpReward,
        slides: _slides,
      );
    } else {
      result = await cubit.createBab(
        widget.lessonId,
        title: title,
        xpReward: _xpReward,
        slides: _slides,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (result != null) {
      showAppSnack(
        context,
        _isEdit ? l10n.tBabUpdated : l10n.tBabCreated,
      );
      if (context.canPop()) {
        context.pop(result);
      } else {
        context.go(AppRoutes.teacherBabList(widget.lessonId));
      }
    }
  }

  void _openStudentPreview() {
    if (_slides.isEmpty) {
      showAppSnack(
        context,
        AppLocalizations.of(context).tBabMinSlidesPreview,
      );
      return;
    }
    final previewData = SlideAdapter.toLessonDetailData(
      l10n: AppLocalizations.of(context),
      id: _currentBabId ?? 'preview_bab',
      title: _titleController.text.trim().isEmpty
          ? AppLocalizations.of(context).tBabPreviewFallback
          : _titleController.text.trim(),
      xpReward: _xpReward,
      rawSlides: _slides,
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

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.tBabEditTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.tBabEditTitle)),
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
                    l10n.tBabLoadFailedTitle,
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
                    label: l10n.tBabOpenList,
                    leadingIcon: Icons.menu_book_rounded,
                    onPressed: () =>
                        context.go(AppRoutes.teacherBabList(widget.lessonId)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.tBabEditTitle : l10n.tBabBuilderTitle),
        actions: [
          IconButton(
            tooltip: l10n.tBabPreviewTooltip,
            icon: Icon(Icons.play_circle_outline_rounded, color: p.primary),
            onPressed: _openStudentPreview,
          ),
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: p.primaryContainer.withAlpha(50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bolt_rounded, size: 16, color: p.accent),
                const SizedBox(width: 4),
                Text(
                  '$_xpReward XP',
                  style: AppTypography.codeSm.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                    // Section 1: Bab Metadata Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: p.surface,
                        borderRadius: AppRadius.cardBorder,
                        border: Border.all(color: p.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                l10n.tBabFieldName,
                                style: AppTypography.labelL.copyWith(
                                  color: p.text,
                                ),
                              ),
                              Text(
                                '${_titleController.text.length}/100',
                                style: AppTypography.codeSm.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          TextField(
                            controller: _titleController,
                            maxLength: 100,
                            onChanged: (_) => setState(() {}),
                            decoration: InputDecoration(
                              hintText: l10n.tBabExampleName,
                              counterText: '',
                              filled: true,
                              fillColor: p.surfaceAlt,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: p.outline),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: p.outline),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: p.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),

                          // XP Stepper
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.tBabXpTitle,
                                    style: AppTypography.labelL.copyWith(
                                      color: p.text,
                                    ),
                                  ),
                                  Text(
                                    l10n.tBabXpHint,
                                    style: AppTypography.bodySm.copyWith(
                                      color: p.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: p.surfaceAlt,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: p.outline),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 16),
                                      onPressed: () => _adjustXp(-10),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    Text(
                                      '$_xpReward XP',
                                      style: AppTypography.codeSm.copyWith(
                                        color: p.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 16),
                                      onPressed: () => _adjustXp(10),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // Section 2: Slides Flow Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              l10n.tBabFlowTitle,
                              style: AppTypography.titleM.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: p.primaryContainer.withAlpha(40),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                l10n.tBabSlideCount(_slides.length),
                                style: AppTypography.labelSm.copyWith(
                                  color: p.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: Text(l10n.tBabAddSlide),
                          onPressed: _showAddSlidePicker,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // Slide list items
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _slides.length,
                      itemBuilder: (ctx, index) {
                        final slide = _slides[index];
                        final type = slide['type'] as String? ?? 'THEORY';

                        return Container(
                          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: p.surface,
                            borderRadius: AppRadius.cardBorder,
                            border: Border.all(color: p.outline),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top row: Type chip, Title, Action icons
                              Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: p.surfaceAlt,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${index + 1}',
                                      style: AppTypography.codeSm.copyWith(
                                        color: p.text,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: p.primaryContainer.withAlpha(
                                            35,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          SlideTemplates.label(type, l10n: l10n),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTypography.labelSm.copyWith(
                                            color: p.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (index > 0)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 16,
                                      ),
                                      tooltip: l10n.tBabMoveUp,
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _moveSlide(index, -1),
                                    ),
                                  if (index < _slides.length - 1)
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_downward_rounded,
                                        size: 16,
                                      ),
                                      tooltip: l10n.tBabMoveDown,
                                      visualDensity: VisualDensity.compact,
                                      onPressed: () => _moveSlide(index, 1),
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 18,
                                      color: p.error,
                                    ),
                                    tooltip: l10n.tBabDeleteSlide,
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => _removeSlide(index),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),

                              Text(
                                (slide['title'] as String?)
                                            ?.trim()
                                            .isNotEmpty ==
                                        true
                                    ? slide['title'] as String
                                    : SlideTemplates.label(type, l10n: l10n),
                                style: AppTypography.labelL.copyWith(
                                  color: p.text,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _slideSummary(slide),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySm.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              OutlinedButton.icon(
                                onPressed: () => _openSlideEditor(index),
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: Text(l10n.tBabEditSlideContent),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: p.primary,
                                  side: BorderSide(color: p.outline),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 9,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Section 3: Bento Grid Picker
                    _buildBentoTypePicker(p),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Footer
            Container(
              padding: const EdgeInsets.all(AppSpacing.screen),
              decoration: BoxDecoration(
                color: p.surface,
                border: Border(top: BorderSide(color: p.outline)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: AppButton(
                label: _isEdit ? l10n.tBabSaveChanges : l10n.tBabSaveNew,
                leadingIcon: Icons.check_circle_outline_rounded,
                loading: _isSubmitting,
                onPressed: _handleSave,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBentoTypePicker(AppPalette p) {
    final l10n = AppLocalizations.of(context);
    final types = [
      {
        'type': 'THEORY',
        'name': l10n.tBabTypeTheoryName,
        'desc':
            l10n.tBabBentoDescTheory,
        'icon': Icons.menu_book_rounded,
        'badge': l10n.tBabTypeTheoryBadge,
      },
      {
        'type': 'TAP_TO_FILL',
        'name': l10n.tBabTypeTapName,
        'desc': l10n.tBabBentoDescTap,
        'icon': Icons.extension_rounded,
        'badge': l10n.tBabTypeTapBadge,
      },
      {
        'type': 'TYPE_CODE',
        'name': l10n.tBabTypeTypeName,
        'desc': l10n.tBabBentoDescType,
        'icon': Icons.keyboard_rounded,
        'badge': l10n.tBabTypeTypeBadge,
      },
      {
        'type': 'OUTPUT_PREDICT',
        'name': l10n.tBabTypeOutputName,
        'desc':
            l10n.tBabBentoDescOutput,
        'icon': Icons.terminal_rounded,
        'badge': l10n.tBabTypeOutputBadge,
      },
      {
        'type': 'BUG_HUNTER',
        'name': l10n.tBabTypeBugName,
        'desc': l10n.tBabBentoDescBug,
        'icon': Icons.pest_control_rounded,
        'badge': l10n.tBabTypeBugBadge,
      },
      {
        'type': 'QUIZ',
        'name': l10n.tBabTypeQuizName,
        'desc': l10n.tBabBentoDescQuiz,
        'icon': Icons.help_outline_rounded,
        'badge': l10n.tBabTypeQuizBadge,
      },
    ];

    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: p.primaryContainer.withAlpha(35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle_outline_rounded,
                  size: 18,
                  color: p.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.tBabBentoTitle,
                  style: AppTypography.titleM.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.tBabBentoHint,
            style: AppTypography.bodySm.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (ctx, constraints) {
              final isWide = constraints.maxWidth > 500;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: types.map((item) {
                  final type = item['type'] as String;
                  final width = isWide
                      ? (constraints.maxWidth - 10) / 2
                      : constraints.maxWidth;
                  return SizedBox(
                    width: width,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: p.surfaceAlt.withAlpha(60),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: p.outline),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: p.primaryContainer.withAlpha(40),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  size: 18,
                                  color: p.primary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: p.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: p.outline),
                                ),
                                child: Text(
                                  item['badge'] as String,
                                  style: AppTypography.codeSm.copyWith(
                                    fontSize: 10,
                                    color: p.textMuted,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['name'] as String,
                            style: AppTypography.labelL.copyWith(
                              color: p.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['desc'] as String,
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    side: BorderSide(color: p.outline),
                                  ),
                                  icon: Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 14,
                                    color: p.primary,
                                  ),
                                  label: Text(
                                    l10n.tBabPreviewButton,
                                    style: AppTypography.labelSm.copyWith(
                                      color: p.primary,
                                    ),
                                  ),
                                  onPressed: () {
                                    SlideTypePreviewSheet.show(
                                      context,
                                      type: type,
                                      onUseType: () => _addSlideAndEdit(type),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: p.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  icon: const Icon(Icons.add_rounded, size: 16),
                                  label: Text(
                                    l10n.tBabUseButton,
                                    style: AppTypography.labelSm.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => _addSlideAndEdit(type),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
