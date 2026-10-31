// FILE: lib/features/teacher/presentation/pages/teacher_material_form_page.dart
//
// TUGAS: formulir tambah/edit materi pembelajaran guru (Minggu 11).
// Berdasarkan desain Stitch v3: form_tambah_edit_materi.

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
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';

class TeacherMaterialFormPage extends StatefulWidget {
  const TeacherMaterialFormPage({super.key, this.lessonId, this.initialLesson});

  final String? lessonId;
  final TeacherLesson? initialLesson;

  @override
  State<TeacherMaterialFormPage> createState() =>
      _TeacherMaterialFormPageState();
}

class _TeacherMaterialFormPageState extends State<TeacherMaterialFormPage> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _iconController = TextEditingController(text: 'terminal');

  String _selectedTopic = 'Python Dasar';
  String _selectedLevel = 'beginner';
  bool _isSubmitting = false;
  bool _isDirty = false;
  bool _isLoading = false;
  String? _loadError;

  final List<String> _topics = ['Python Dasar', 'HTML', 'CSS', 'JavaScript'];

  final List<String> _iconPresets = [
    'terminal',
    'code',
    'database',
    'javascript',
    'html',
    'css',
    'psychology',
    'phone_android',
    'shield',
    'data_object',
  ];

  IconData _resolveIcon(String code) {
    switch (code.trim().toLowerCase()) {
      case 'code':
        return Icons.code_rounded;
      case 'html':
        return Icons.html_rounded;
      case 'css':
        return Icons.css_rounded;
      case 'javascript':
      case 'js':
        return Icons.javascript_rounded;
      case 'database':
      case 'db':
        return Icons.storage_rounded;
      case 'psychology':
      case 'ai':
        return Icons.psychology_rounded;
      case 'phone_android':
      case 'mobile':
        return Icons.phone_android_rounded;
      case 'shield':
      case 'security':
        return Icons.shield_rounded;
      case 'data_object':
        return Icons.data_object_rounded;
      case 'terminal':
      default:
        return Icons.terminal_rounded;
    }
  }

  final Map<String, String> _levels = {
    'beginner': 'Pemula',
    'intermediate': 'Menengah',
    'advanced': 'Mahir',
  };

  final Map<String, String> _levelDescriptions = {
    'beginner':
        'Level dasar: ditujukan bagi siswa yang baru mengenal logika pemrograman.',
    'intermediate':
        'Level menengah: percabangan lanjutan, perulangan, & manipulasi data.',
    'advanced':
        'Level mahir: algoritma rekursif kompleks & optimasi pemecahan masalah.',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialLesson != null) {
      _hydrateFromLesson(widget.initialLesson!);
    } else if (widget.lessonId != null) {
      final materials = context.read<TeacherCubit>().state.materials;
      final found = materials.where((m) => m.id == widget.lessonId).firstOrNull;
      if (found != null) {
        _hydrateFromLesson(found);
      } else {
        // URL edit dibuka langsung (refresh/bookmark) tanpa data `extra`.
        // Muat dari server agar simpan tidak menimpa materi dengan form kosong.
        _isLoading = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadLesson());
      }
    }

    _titleController.addListener(() {
      if (!_suppressDirty) setState(() => _isDirty = true);
    });
    _descController.addListener(() {
      if (!_suppressDirty) setState(() => _isDirty = true);
    });
    _iconController.addListener(() {
      if (!_suppressDirty) setState(() => _isDirty = true);
    });
  }

  bool _suppressDirty = false;

  void _hydrateFromLesson(TeacherLesson lesson) {
    _suppressDirty = true;
    _titleController.text = lesson.title;
    _descController.text = lesson.description;
    _selectedTopic = lesson.topic;
    _selectedLevel = lesson.level;
    _iconController.text = lesson.iconCode;
    _suppressDirty = false;
  }

  Future<void> _loadLesson() async {
    if (!mounted) return;
    final cubit = context.read<TeacherCubit>();
    final found = await cubit.findMaterial(widget.lessonId!);
    if (!mounted) return;

    if (found == null) {
      setState(() {
        _isLoading = false;
        _loadError =
            'Materi tidak ditemukan. Kembali ke Studio Materi untuk memilih materi lain.';
      });
      return;
    }

    setState(() {
      _hydrateFromLesson(found);
      _isLoading = false;
      _loadError = null;
      _isDirty = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.lessonId != null || widget.initialLesson != null;
  String? get _currentLessonId => widget.lessonId ?? widget.initialLesson?.id;

  Future<void> _handleSave({bool continueToBabs = false}) async {
    if (_isSubmitting || _isLoading) return;
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      showAppSnack(context, 'Nama materi wajib diisi.');
      return;
    }

    setState(() => _isSubmitting = true);
    final cubit = context.read<TeacherCubit>();

    final iconCode = _iconController.text.trim().isEmpty
        ? 'terminal'
        : _iconController.text.trim();
    TeacherLesson? savedLesson;
    if (_isEdit && _currentLessonId != null) {
      savedLesson = await cubit.updateMaterial(
        _currentLessonId!,
        title: title,
        topic: _selectedTopic,
        level: _selectedLevel,
        description: _descController.text.trim(),
        iconCode: iconCode,
      );
    } else {
      savedLesson = await cubit.createMaterial(
        title: title,
        topic: _selectedTopic,
        level: _selectedLevel,
        description: _descController.text.trim(),
        iconCode: iconCode,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (savedLesson != null) {
      _isDirty = false;
      showAppSnack(
        context,
        _isEdit
            ? 'Materi berhasil diperbarui.'
            : 'Materi tersimpan sebagai draft.',
      );
      if (continueToBabs) {
        context.pushReplacement(AppRoutes.teacherBabList(savedLesson.id));
      } else if (context.canPop()) {
        context.pop(savedLesson);
      } else {
        context.go(AppRoutes.teacherStudio);
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_isDirty) return true;
    final p = context.palette;

    final shouldPop = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
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
                Text(
                  'Perubahan Belum Disimpan',
                  style: AppTypography.titleM.copyWith(color: p.text),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Ada revisi pada form materi ini. Simpan perubahan sebagai draft terlebih dahulu atau abaikan?',
                  style: AppTypography.bodyM.copyWith(color: p.textMuted),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: 'Simpan Draft & Keluar',
                  leadingIcon: Icons.bookmark_added_outlined,
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                    _handleSave(continueToBabs: false);
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Buang Perubahan',
                  kind: AppButtonKind.secondary,
                  onPressed: () => Navigator.of(ctx).pop(true),
                ),
                const SizedBox(height: AppSpacing.xs),
                AppButton(
                  label: 'Lanjut Mengedit',
                  kind: AppButtonKind.text,
                  onPressed: () => Navigator.of(ctx).pop(false),
                ),
              ],
            ),
          ),
        );
      },
    );

    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Materi')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_loadError != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Materi')),
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
                    'Materi Tidak Dapat Dimuat',
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
                    label: 'Buka Studio Materi',
                    leadingIcon: Icons.menu_book_rounded,
                    onPressed: () => context.go(AppRoutes.teacherStudio),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return PopScope(
      canPop: !_isDirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final ok = await _onWillPop();
        if (ok && mounted) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit ? 'Edit Materi' : 'Tambah Materi Baru'),
          actions: [
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
                  Icon(Icons.check_circle_rounded, size: 14, color: p.primary),
                  const SizedBox(width: 4),
                  Text(
                    _isEdit ? 'Mode Edit' : 'Materi Baru',
                    style: AppTypography.labelSm.copyWith(color: p.primary),
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
                      // Subheader
                      Text(
                        _isEdit
                            ? 'Ubah Pengaturan Materi'
                            : 'Konfigurasi Materi Baru',
                        style: AppTypography.titleL.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Konfigurasikan judul, track kurikulum, dan level kesulitan untuk ditampilkan ke siswa.',
                        style: AppTypography.bodyM.copyWith(color: p.textMuted),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Field: Nama Materi
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nama Materi *',
                            style: AppTypography.labelL.copyWith(color: p.text),
                          ),
                          Text(
                            '${_titleController.text.length}/150',
                            style: AppTypography.codeSm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextField(
                        controller: _titleController,
                        maxLength: 150,
                        decoration: InputDecoration(
                          hintText: 'Contoh: Dasar Algoritma & Python RPL',
                          counterText: '',
                          filled: true,
                          fillColor: p.surface,
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Field: Deskripsi Singkat
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deskripsi Singkat *',
                            style: AppTypography.labelL.copyWith(color: p.text),
                          ),
                          Text(
                            '${_descController.text.length}/300',
                            style: AppTypography.codeSm.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextField(
                        controller: _descController,
                        maxLines: 3,
                        maxLength: 300,
                        decoration: InputDecoration(
                          hintText:
                              'Jelaskan capaian materi dalam 2-3 kalimat ringkas...',
                          counterText: '',
                          filled: true,
                          fillColor: p.surface,
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Field: Kode Ikon Materi
                      Text(
                        'Kode Ikon Materi *',
                        style: AppTypography.labelL.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Pilih preset ikon atau ketik nama kode ikon (misal: terminal, html, css, javascript, database, psychology, shield, phone_android).',
                        style: AppTypography.caption.copyWith(
                          color: p.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextField(
                        controller: _iconController,
                        decoration: InputDecoration(
                          hintText: 'Contoh: terminal',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Icon(
                              _resolveIcon(_iconController.text),
                              color: p.primary,
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 44,
                          ),
                          filled: true,
                          fillColor: p.surface,
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.outline),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.outline),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.cardBorder,
                            borderSide: BorderSide(color: p.primary, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _iconPresets.map((code) {
                          final isSelected =
                              _iconController.text.trim().toLowerCase() == code;
                          return ChoiceChip(
                            avatar: Icon(
                              _resolveIcon(code),
                              size: 16,
                              color: isSelected ? Colors.white : p.primary,
                            ),
                            label: Text(code),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _iconController.text = code;
                                  _isDirty = true;
                                });
                              }
                            },
                            selectedColor: p.primary,
                            labelStyle: AppTypography.caption.copyWith(
                              color: isSelected ? Colors.white : p.text,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            backgroundColor: p.surfaceAlt,
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Field: Topik / Track
                      Text(
                        'Topik / Track Kurikulum *',
                        style: AppTypography.labelL.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _topics.map((t) {
                          final selected = _selectedTopic == t;
                          return ChoiceChip(
                            label: Text(t),
                            selected: selected,
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedTopic = t;
                                  _isDirty = true;
                                });
                              }
                            },
                            selectedColor: p.primary,
                            labelStyle: AppTypography.labelM.copyWith(
                              color: selected ? Colors.white : p.text,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                            backgroundColor: p.surfaceAlt,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: selected ? p.primary : p.outline,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Field: Level Pembelajaran
                      Text(
                        'Tingkat Kesulitan *',
                        style: AppTypography.labelL.copyWith(color: p.text),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: p.surfaceAlt,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: _levels.entries.map((entry) {
                            final selected = _selectedLevel == entry.key;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedLevel = entry.key;
                                    _isDirty = true;
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? p.primary
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: selected
                                        ? [
                                            BoxShadow(
                                              color: p.primary.withAlpha(50),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Text(
                                    entry.value,
                                    style: AppTypography.labelM.copyWith(
                                      color: selected
                                          ? Colors.white
                                          : p.textMuted,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _levelDescriptions[_selectedLevel] ?? '',
                        style: AppTypography.bodySm.copyWith(
                          color: p.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Info Banner
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: p.primaryContainer.withAlpha(30),
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(color: p.primary.withAlpha(60)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: p.primary,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                'Materi baru disimpan sebagai Draft. Materi hanya terlihat oleh siswa setelah kamu menekan tombol "Terbitkan".',
                                style: AppTypography.bodySm.copyWith(
                                  color: p.text,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        label: 'Simpan Draft',
                        kind: AppButtonKind.secondary,
                        leadingIcon: Icons.bookmark_border_rounded,
                        loading: _isSubmitting,
                        onPressed: _handleSave,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        label: 'Lanjut ke Bab',
                        leadingIcon: Icons.arrow_forward_rounded,
                        loading: _isSubmitting,
                        onPressed: () => _handleSave(continueToBabs: true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
