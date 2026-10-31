// FILE: lib/features/teacher/presentation/pages/teacher_settings_page.dart
//
// TUGAS: Halaman Pengaturan & Edit Data Pribadi Pengajar (/pengaturan-pengajar).
// Mengelola perubahan profil pengajar (foto, Nama, Telepon, Bio, Alamat,
// Kode Kepegawaian/NIP), preferensi lokal (notifikasi & efek suara), serta
// opsi sesi (Keluar Akun) dengan styling label di atas border input.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/services/teacher_preferences.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class TeacherSettingsPage extends StatefulWidget {
  const TeacherSettingsPage({super.key});

  @override
  State<TeacherSettingsPage> createState() => _TeacherSettingsPageState();
}

class _TeacherSettingsPageState extends State<TeacherSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final TextEditingController _addressController;
  late final TextEditingController _staffCodeController;

  bool _isSaving = false;
  bool _isUploadingAvatar = false;
  bool _submissionNotifications = TeacherPreferences.submissionNotifications;
  bool _sfxEnabled = SoundService.sfxEnabled;
  bool _labSfxEnabled = SoundService.labSfxEnabled;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _staffCodeController = TextEditingController(text: user?.staffCode ?? '');
    _submissionNotifications = TeacherPreferences.submissionNotifications;
    _sfxEnabled = SoundService.sfxEnabled;
    _labSfxEnabled = SoundService.labSfxEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _staffCodeController.dispose();
    super.dispose();
  }

  Future<void> _reloadProfile() async {
    await context.read<AuthCubit>().restoreSession();
    if (!mounted) return;
    final user = context.read<AuthCubit>().state.user;
    _nameController.text = user?.name ?? '';
    _phoneController.text = user?.phone ?? '';
    _bioController.text = user?.bio ?? '';
    _addressController.text = user?.address ?? '';
    _staffCodeController.text = user?.staffCode ?? '';
    setState(() {});
  }

  Future<void> _pickAvatar() async {
    if (_isUploadingAvatar) return;
    final cubit = context.read<AuthCubit>();
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 85,
      );
      if (picked == null || !mounted) return;

      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      if (bytes.length > 2 * 1024 * 1024) {
        showAppSnack(context, 'Ukuran foto maksimal 2 MB.');
        return;
      }

      setState(() => _isUploadingAvatar = true);
      await cubit.uploadAvatar(
        bytes: bytes,
        fileName: picked.name.trim().isEmpty ? 'avatar.jpg' : picked.name,
      );
      if (mounted) {
        showAppSnack(context, 'Foto profil berhasil diperbarui.');
      }
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.message);
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          'Foto profil gagal diproses. Periksa izin galeri dan koneksi, lalu coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  Future<void> _deleteAvatar() async {
    if (_isUploadingAvatar) return;
    final p = context.palette;
    final cubit = context.read<AuthCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text(
          'Hapus Foto Profil?',
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        content: Text(
          'Foto akan dihapus dari akunmu. Kamu bisa mengunggah foto baru kapan saja.',
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: TextStyle(color: p.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isUploadingAvatar = true);
    try {
      await cubit.deleteAvatar();
      if (mounted) showAppSnack(context, 'Foto profil dihapus.');
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.message);
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          'Foto profil gagal dihapus. Periksa koneksi lalu coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => _isUploadingAvatar = false);
    }
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isSaving = true);
    final cubit = context.read<AuthCubit>();
    try {
      await cubit.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        bio: _bioController.text.trim(),
        address: _addressController.text.trim(),
        staffCode: _staffCodeController.text.trim(),
      );
      if (mounted) {
        showAppSnack(context, 'Data profil pengajar berhasil diperbarui.');
      }
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.message);
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          'Gagal memperbarui profil. Periksa koneksi dan coba lagi.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _confirmLogout() async {
    final p = context.palette;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: p.surface,
        title: Text(
          'Keluar dari Akun Pengajar?',
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        content: Text(
          'Kamu perlu memasukkan email dan kata sandi kembali untuk masuk ke akun pengajar ini.',
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Batal', style: TextStyle(color: p.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<AuthCubit>().logout();
      if (mounted) {
        context.go(AppRoutes.login);
      }
    }
  }

  Future<void> _openChangePasswordDialog() async {
    final p = context.palette;
    final formKey = GlobalKey<FormState>();
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    var submitting = false;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: p.surface,
          title: Text(
            'Ubah Kata Sandi',
            style: AppTypography.titleM.copyWith(color: p.text),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: oldCtrl,
                    obscureText: true,
                    validator: Validators.loginPassword,
                    decoration: const InputDecoration(
                      labelText: 'Kata sandi saat ini',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: newCtrl,
                    obscureText: true,
                    validator: Validators.newPassword,
                    decoration: const InputDecoration(
                      labelText: 'Kata sandi baru',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: confirmCtrl,
                    obscureText: true,
                    validator: (value) =>
                        Validators.confirmPassword(value, newCtrl.text),
                    decoration: const InputDecoration(
                      labelText: 'Ulangi kata sandi baru',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: submitting ? null : () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: submitting
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      setDialogState(() => submitting = true);
                      try {
                        await context.read<AuthCubit>().changePassword(
                          oldPassword: oldCtrl.text,
                          newPassword: newCtrl.text,
                        );
                        if (!ctx.mounted) return;
                        Navigator.of(ctx).pop();
                        if (mounted) {
                          showAppSnack(context, 'Kata sandi berhasil diubah.');
                        }
                      } on AuthFailure catch (e) {
                        if (!ctx.mounted) return;
                        setDialogState(() => submitting = false);
                        showAppSnack(ctx, e.message);
                      } catch (_) {
                        if (!ctx.mounted) return;
                        setDialogState(() => submitting = false);
                        showAppSnack(
                          ctx,
                          'Gagal mengubah kata sandi. Periksa koneksi lalu coba lagi.',
                        );
                      }
                    },
              child: submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    oldCtrl.dispose();
    newCtrl.dispose();
    confirmCtrl.dispose();
  }

  Widget _buildLabeledInput({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    String? hintText,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
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
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText ?? label,
            isDense: true,
            filled: true,
            fillColor: p.surfaceAlt,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: p.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: p.outline.withAlpha(120)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: p.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    String? badgeText,
  }) {
    final p = context.palette;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.labelSm.copyWith(
                color: p.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (badgeText != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: p.primaryContainer.withAlpha(50),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: AppTypography.caption.copyWith(
                    color: p.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: p.surfaceAlt.withAlpha(120),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: p.outline.withAlpha(80)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: p.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  value.isNotEmpty ? value : '-',
                  style: AppTypography.bodyM.copyWith(color: p.text),
                ),
              ),
              Icon(Icons.lock_outline_rounded, size: 16, color: p.textMuted),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;
    final schoolName = user?.schoolName?.trim() ?? '';
    final hasAvatar = user?.avatarUrl?.trim().isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Profil',
              style: AppTypography.titleM.copyWith(
                color: p.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Kelola data pribadi & preferensi akun gurumu',
              style: AppTypography.caption.copyWith(
                color: p.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.teacherHome);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AppRefresh(
                onRefresh: _reloadProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.md,
                    AppSpacing.screen,
                    AppSpacing.xl,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Avatar & Foto Profil Card
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  UserAvatar(
                                    name: user?.name ?? 'Guru',
                                    avatarUrl: user?.avatarUrl,
                                    size: 88,
                                  ),
                                  if (_isUploadingAvatar)
                                    Container(
                                      width: 88,
                                      height: 88,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withAlpha(80),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Foto Profil',
                                style: AppTypography.labelL.copyWith(
                                  color: p.text,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'JPG atau PNG, maksimal 2 MB.',
                                style: AppTypography.caption.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 4,
                                children: [
                                  TextButton.icon(
                                    onPressed: _isUploadingAvatar
                                        ? null
                                        : _pickAvatar,
                                    icon: Icon(
                                      hasAvatar
                                          ? Icons.photo_camera_back_outlined
                                          : Icons.add_a_photo_outlined,
                                      size: 18,
                                    ),
                                    label: Text(
                                      hasAvatar ? 'Ganti Foto' : 'Unggah Foto',
                                    ),
                                  ),
                                  if (hasAvatar)
                                    TextButton.icon(
                                      onPressed: _isUploadingAvatar
                                          ? null
                                          : _deleteAvatar,
                                      icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18,
                                      ),
                                      label: const Text('Hapus Foto'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: p.error,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 1: Identitas Pengajar
                        AppCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.assignment_ind_rounded,
                                    size: 20,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Identitas Pengajar',
                                    style: AppTypography.titleM.copyWith(
                                      color: p.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _buildLabeledInput(
                                context: context,
                                label: 'Nama Lengkap & Gelar *',
                                controller: _nameController,
                                hintText:
                                    'Contoh: Drs. Bambang Sutrisno, M.Kom',
                                validator: Validators.name,
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _buildLabeledInput(
                                context: context,
                                label: 'NIP / NUPTK',
                                controller: _staffCodeController,
                                hintText: 'Contoh: 19850723 201001 1 008',
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // Asal Sekolah (Dapodik Verified)
                              Text(
                                'Unit Satuan Pendidikan',
                                style: AppTypography.labelSm.copyWith(
                                  color: p.text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: p.surfaceAlt,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: p.outline),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: p.primaryContainer.withAlpha(40),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.school_rounded,
                                        size: 20,
                                        color: p.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            schoolName.isEmpty
                                                ? 'Sekolah belum terhubung'
                                                : schoolName,
                                            style: AppTypography.labelL
                                                .copyWith(
                                                  color: p.text,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          if (schoolName.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.verified_rounded,
                                                  size: 14,
                                                  color: p.primary,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Terhubung lewat kode sekolah',
                                                  style: AppTypography.caption
                                                      .copyWith(
                                                        color: p.primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Section 2: Bio & Kontak
                        AppCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.contact_mail_rounded,
                                    size: 20,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Bio & Kontak',
                                    style: AppTypography.titleM.copyWith(
                                      color: p.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Bio Singkat Pengajar',
                                    style: AppTypography.labelSm.copyWith(
                                      color: p.text,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${_bioController.text.length}/120',
                                    style: AppTypography.codeSm.copyWith(
                                      color: p.textMuted,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _bioController,
                                maxLength: 120,
                                maxLines: 3,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText:
                                      'Tuliskan pengalaman mengajar atau bidang spesialisasi kodingmu...',
                                  counterText: '',
                                  isDense: true,
                                  filled: true,
                                  fillColor: p.surfaceAlt,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: p.outline),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: p.outline.withAlpha(120),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: p.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              _buildLabeledInput(
                                context: context,
                                label: 'Alamat',
                                controller: _addressController,
                                hintText: 'Alamat domisili pengajar',
                                maxLines: 2,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // WhatsApp dengan prefix bendera +62
                              Text(
                                'Nomor WhatsApp / Telepon',
                                style: AppTypography.labelSm.copyWith(
                                  color: p.text,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: p.surfaceAlt,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: p.outline),
                                    ),
                                    child: Row(
                                      children: [
                                        const Text(
                                          '🇮🇩',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '+62',
                                          style: AppTypography.labelL.copyWith(
                                            color: p.text,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: '812-7890-1234',
                                        isDense: true,
                                        filled: true,
                                        fillColor: p.surfaceAlt,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: p.outline,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: p.outline.withAlpha(120),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: p.primary,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // Email Kedinasan (Read-only)
                              _buildReadOnlyField(
                                context: context,
                                label: 'Email Akun',
                                value: user?.email ?? '',
                                icon: Icons.alternate_email_rounded,
                                badgeText: 'Terkunci',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Section 3: Keamanan Akun
                        AppCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tune_rounded,
                                    size: 20,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    'Keamanan Akun',
                                    style: AppTypography.titleM.copyWith(
                                      color: p.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: p.surfaceAlt,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.key_rounded,
                                    size: 20,
                                    color: p.text,
                                  ),
                                ),
                                title: Text(
                                  'Ubah Kata Sandi',
                                  style: AppTypography.labelL.copyWith(
                                    color: p.text,
                                  ),
                                ),
                                subtitle: Text(
                                  'Ganti kata sandi akun pengajar',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                ),
                                onTap: _openChangePasswordDialog,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Section 4: Preferensi Aplikasi (disimpan lokal).
                        Text(
                          'PREFERENSI APLIKASI',
                          style: AppTypography.caption.copyWith(
                            color: p.textMuted,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppCard(
                          padding: EdgeInsets.zero,
                          child: Column(
                            children: [
                              SwitchListTile(
                                secondary: Icon(
                                  Icons.notifications_active_outlined,
                                  color: p.primary,
                                ),
                                title: const Text(
                                  'Notifikasi Pengumpulan Tugas',
                                ),
                                subtitle: Text(
                                  'Simpan pilihan notifikasi di perangkat ini',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                value: _submissionNotifications,
                                activeTrackColor: p.primary,
                                onChanged: (val) {
                                  setState(
                                    () => _submissionNotifications = val,
                                  );
                                  TeacherPreferences.setSubmissionNotifications(
                                    val,
                                  );
                                },
                              ),
                              Divider(
                                height: 1,
                                color: p.outline.withValues(alpha: 0.5),
                              ),
                              SwitchListTile(
                                secondary: Icon(
                                  Icons.volume_up_outlined,
                                  color: p.primary,
                                ),
                                title: const Text('Efek Suara Aplikasi'),
                                subtitle: Text(
                                  'Suara popup, notifikasi, dan kuis',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                value: _sfxEnabled,
                                activeTrackColor: p.primary,
                                onChanged: (val) {
                                  setState(() => _sfxEnabled = val);
                                  SoundService.setSfxEnabled(val);
                                },
                              ),
                              Divider(
                                height: 1,
                                color: p.outline.withValues(alpha: 0.5),
                              ),
                              SwitchListTile(
                                secondary: Icon(
                                  Icons.terminal_outlined,
                                  color: p.primary,
                                ),
                                title: const Text('Efek Suara Lab'),
                                subtitle: Text(
                                  'Audio saat eksekusi kode & terminal',
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                value: _labSfxEnabled,
                                activeTrackColor: p.primary,
                                onChanged: (val) {
                                  setState(() => _labSfxEnabled = val);
                                  SoundService.setLabSfxEnabled(val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),

                        // Section 5: Keluar Akun
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: p.error.withAlpha(90)),
                          ),
                          child: InkWell(
                            onTap: _confirmLogout,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    size: 18,
                                    color: p.error,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Keluar dari Akun (Logout)',
                                    style: AppTypography.labelL.copyWith(
                                      color: p.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Sticky Bottom Floating Bar
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
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: p.outline),
                      ),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.teacherHome);
                        }
                      },
                      child: Text(
                        'Batal',
                        style: AppTypography.labelL.copyWith(color: p.text),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded, size: 18),
                      label: Text(
                        _isSaving ? 'Menyimpan...' : 'Simpan Perubahan',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _isSaving ? null : _handleSave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
