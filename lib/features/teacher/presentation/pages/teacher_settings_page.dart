// FILE: lib/features/teacher/presentation/pages/teacher_settings_page.dart
//
// TUGAS: Halaman Pengaturan & Edit Data Pribadi Pengajar (/pengaturan-pengajar).
// Mengelola perubahan profil pengajar (foto, Nama, Telepon, Bio, Alamat,
// Kode Kepegawaian/NIP), serta preferensi lokal (bahasa, tema & efek suara)
// dengan styling label di atas border input.
// Tombol keluar akun sengaja hanya ada di halaman Profil Pengajar.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/services/app_preferences.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/phone.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/admin_help_tile.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../../core/widgets/notification_settings_section.dart';
import '../../../../core/widgets/theme_mode_tile.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../profile/presentation/widgets/change_password_sheet.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';

class TeacherSettingsPage extends StatefulWidget {
  const TeacherSettingsPage({super.key});

  @override
  State<TeacherSettingsPage> createState() => _TeacherSettingsPageState();
}

class _TeacherSettingsPageState extends State<TeacherSettingsPage> {
  /// Pintasan kamus UI supaya semua pembangun layar ini konsisten.
  AppLocalizations get l10n => AppLocalizations.of(context);

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final TextEditingController _addressController;
  late final TextEditingController _staffCodeController;

  bool _isEditing = false;
  bool _isSaving = false;
  bool _isUploadingAvatar = false;
  bool _sfxEnabled = SoundService.sfxEnabled;
  bool _labSfxEnabled = SoundService.labSfxEnabled;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(
      text: phoneInputValue(user?.phone ?? ''),
    );
    _bioController = TextEditingController(text: user?.bio ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _staffCodeController = TextEditingController(text: user?.staffCode ?? '');
    _sfxEnabled = SoundService.sfxEnabled;
    _labSfxEnabled = SoundService.labSfxEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _staffCodeController.dispose();
    super.dispose();
  }

  /// Sinkronkan isi kolom dengan data user terbaru (dipakai saat masuk mode
  /// edit dan setelah tersimpan supaya tampilan selalu mulai dari data DB).
  void _syncFieldsToUser() {
    final user = context.read<AuthCubit>().state.user;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _phoneController.text = phoneInputValue(user?.phone ?? '');
    _bioController.text = user?.bio ?? '';
    _addressController.text = user?.address ?? '';
    _staffCodeController.text = user?.staffCode ?? '';
  }

  /// Masuk mode edit: semua kolom profil jadi bisa diubah, tombol berubah
  /// menjadi "Simpan Perubahan".
  void _startEditing() {
    _syncFieldsToUser();
    setState(() => _isEditing = true);
  }

  /// Keluar mode edit TANPA menyimpan: isi kolom dikembalikan ke data user
  /// dan error validasi dibersihkan.
  void _cancelEditing() {
    _syncFieldsToUser();
    _formKey.currentState?.reset();
    setState(() => _isEditing = false);
  }

  Future<void> _reloadProfile() async {
    await context.read<AuthCubit>().restoreSession();
    if (!mounted) return;
    setState(_syncFieldsToUser);
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
        showAppSnack(context, l10n.tSettingsAvatarTooBig);
        return;
      }

      setState(() => _isUploadingAvatar = true);
      await cubit.uploadAvatar(
        bytes: bytes,
        fileName: picked.name.trim().isEmpty ? 'avatar.jpg' : picked.name,
      );
      if (mounted) {
        showAppSnack(context, l10n.settingsAvatarUpdated);
      }
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.messageL10n(l10n));
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          l10n.settingsAvatarProcessFailed,
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
          l10n.settingsAvatarDeleteTitle,
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        content: Text(
          l10n.settingsAvatarDeleteBody,
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.actionCancel, style: TextStyle(color: p.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: p.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isUploadingAvatar = true);
    try {
      await cubit.deleteAvatar();
      if (mounted) showAppSnack(context, l10n.settingsAvatarDeleted);
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.messageL10n(l10n));
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          l10n.settingsAvatarDeleteFailed,
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
        email: _emailController.text.trim(),
        phone: normalizePhone(_phoneController.text),
        bio: _bioController.text.trim(),
        address: _addressController.text.trim(),
        staffCode: _staffCodeController.text.trim(),
      );
      if (mounted) {
        SoundService.playProfileSaved();
        showAppSnack(context, l10n.settingsProfileSaved);
        setState(() {
          _isEditing = false;
          _syncFieldsToUser();
        });
      }
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.messageL10n(l10n));
    } catch (_) {
      if (mounted) {
        showAppSnack(
          context,
          l10n.settingsProfileSaveFailed,
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _openChangePassword() {
    showAppSheet<void>(
      context,
      title: l10n.settingsChangePassword,
      subtitle: l10n.settingsChangePasswordSheetSubtitle,
      builder: (_) => const ChangePasswordSheet(),
    );
  }

  /// Pilih bahasa antarmuka (Indonesia / English / العربية), sama seperti
  /// pengaturan siswa — nilai langsung disimpan ke preferensi lokal.
  Future<void> _pickLanguage() async {
    final l10n = AppLocalizations.of(context);
    Locale? selected;
    await showAppSheet<void>(
      context,
      leadingIcon: Icons.translate_rounded,
      title: l10n.settingsLanguageSheetTitle,
      subtitle: l10n.settingsLanguageSheetSubtitle,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) {
          final currentCode = AppPreferences.instance.locale.languageCode;
          void pick(String code) {
            setSheetState(() {});
            selected = Locale(code);
            Navigator.of(ctx).pop();
          }

          return RadioGroup<String>(
            groupValue: currentCode,
            onChanged: (v) {
              if (v != null) pick(v);
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  value: 'id',
                  title: Text(l10n.languageIndonesian),
                ),
                RadioListTile<String>(
                  value: 'en',
                  title: Text(l10n.languageEnglish),
                ),
                RadioListTile<String>(
                  value: 'ar',
                  title: Text(l10n.languageArabic),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
    if (selected != null && mounted) {
      await AppPreferences.instance.setLocale(selected!);
      if (mounted) setState(() {});
    }
  }

  /// Dekorasi kolom profil: mode baca tampil datar tanpa border, mode edit
  /// tampil sebagai bidang putih ber-border biru (senada dengan pengaturan
  /// profil siswa).
  InputDecoration _profileInputDecoration({String? hintText}) {
    final p = context.palette;
    if (_isEditing) {
      return InputDecoration(
        hintText: hintText,
        isDense: true,
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: p.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: p.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: p.primary, width: 1.5),
        ),
      );
    }
    return InputDecoration(
      hintText: hintText,
      isDense: true,
      filled: true,
      fillColor: p.surfaceAlt.withValues(alpha: 0.45),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
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
          readOnly: !_isEditing,
          showCursor: _isEditing,
          decoration: _profileInputDecoration(hintText: hintText ?? label),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final user = context.watch<AuthCubit>().state.user;
    final schoolName = user?.schoolName?.trim() ?? '';
    final hasAvatar = user?.avatarUrl?.trim().isNotEmpty ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTitle,
              style: AppTypography.titleM.copyWith(
                color: p.text,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.settingsChangePasswordSheetSubtitle,
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
                                    name: user?.name ?? l10n.tSettingsFallbackTeacher,
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
                                l10n.settingsChangePhoto,
                                style: AppTypography.labelL.copyWith(
                                  color: p.text,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l10n.settingsAvatarMaxSize,
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
                                      hasAvatar ? l10n.settingsChangePhoto : l10n.settingsChangePhoto,
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
                                      label: Text(l10n.actionDelete),
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

                        // Section 1 & 2: Identitas + Bio & Kontak.
                        // Digabung dalam satu kartu supaya tombol "Edit Data" /
                        // "Simpan Perubahan" tampil inline di bawah data profil,
                        // bukan sebagai bar mengambang di bawah layar.
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
                                    l10n.tSettingsIdentityTitle,
                                    style: AppTypography.titleM.copyWith(
                                      color: p.text,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),
                              if (_isEditing)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.only(
                                    bottom: AppSpacing.md,
                                  ),
                                  decoration: BoxDecoration(
                                    color: p.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_note_rounded,
                                        size: 18,
                                        color: p.primary,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          l10n.settingsEditModeHint,
                                          style: AppTypography.caption.copyWith(
                                            color: p.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              _buildLabeledInput(
                                context: context,
                                label: l10n.tSettingsNameDegree(l10n.settingsFieldFullName),
                                controller: _nameController,
                                hintText:
                                    'Contoh: Drs. Bambang Sutrisno, M.Kom',
                                validator: (v) => Validators.name(v, l10n),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _buildLabeledInput(
                                context: context,
                                label: l10n.settingsFieldStaffCode,
                                controller: _staffCodeController,
                                hintText: 'Contoh: 19850723 201001 1 008',
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // Asal Sekolah (Dapodik Verified)
                              Text(
                                l10n.settingsFieldAffiliatedSchool,
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
                                                ? l10n.settingsFieldAffiliatedSchool
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
                                                  l10n.settingsBadgeVerified,
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
                              const SizedBox(height: AppSpacing.lg),
                              Divider(
                                height: 1,
                                color: p.outline.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Icon(
                                    Icons.contact_mail_rounded,
                                    size: 20,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  Text(
                                    l10n.tSettingsBioContact,
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
                                    l10n.settingsFieldTeacherBio,
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
                                readOnly: !_isEditing,
                                showCursor: _isEditing,
                                onChanged: (_) => setState(() {}),
                                decoration: _profileInputDecoration(
                                  hintText:
                                      l10n.tSettingsBioHint,
                                ).copyWith(counterText: ''),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              _buildLabeledInput(
                                context: context,
                                label: l10n.settingsFieldAddress,
                                controller: _addressController,
                                hintText: l10n.tSettingsAddressHint,
                                maxLines: 2,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // WhatsApp dengan prefix bendera +62
                              Text(
                                l10n.settingsFieldPhone,
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
                                      readOnly: !_isEditing,
                                      showCursor: _isEditing,
                                      validator: (value) {
                                        final digits = normalizePhone(
                                          value ?? '',
                                        );
                                        if (digits.isEmpty) return null;
                                        if (digits.length < 8 ||
                                            digits.length > 15) {
                                          return l10n.settingsPhoneIncomplete;
                                        }
                                        return null;
                                      },
                                      decoration: _profileInputDecoration(
                                        hintText: '81234567890',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // Email akun bisa diubah, wajib @smk.belajar.id.
                              _buildLabeledInput(
                                context: context,
                                label: '${l10n.settingsFieldTeacherEmail} (${l10n.settingsEmailAside})',
                                controller: _emailController,
                                hintText: 'nama@smk.belajar.id',
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) =>
                                    Validators.schoolEmail(v, l10n),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              if (_isEditing) ...[
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: l10n.settingsSaveChanges,
                                        loading: _isSaving,
                                        onPressed: _handleSave,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: AppButton(
                                        label: l10n.settingsCancelEdit,
                                        kind: AppButtonKind.secondary,
                                        leadingIcon: Icons.close_rounded,
                                        onPressed: _isSaving
                                            ? null
                                            : _cancelEditing,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else
                                AppButton(
                                  label: l10n.settingsEditData,
                                  kind: AppButtonKind.secondary,
                                  leadingIcon: Icons.edit_outlined,
                                  onPressed: _startEditing,
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
                                    l10n.tSettingsSecurityTitle,
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
                                  l10n.tSettingsChangePassword,
                                  style: AppTypography.labelL.copyWith(
                                    color: p.text,
                                  ),
                                ),
                                subtitle: Text(
                                  l10n.settingsChangePasswordSubtitle,
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                ),
                                onTap: _openChangePassword,
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              Divider(
                                height: 1,
                                color: p.outline.withValues(alpha: 0.5),
                              ),
                              const AdminHelpTile(
                                contentPadding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Section 4: Preferensi Aplikasi (disimpan lokal).
                        Text(
                          l10n.settingsPreferencesHeader,
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
                              // Pilihan bahasa antarmuka (id/en/ar), sama
                              // seperti pengaturan siswa.
                              ListTile(
                                leading: Icon(
                                  Icons.translate,
                                  color: p.primary,
                                ),
                                title: Text(l10n.settingsLanguage),
                                subtitle: Text(
                                  l10n.settingsLanguageSubtitle,
                                  style: AppTypography.caption.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AppPreferences.instance.languageLabel,
                                      style: AppTypography.bodyM.copyWith(
                                        color: p.textMuted,
                                      ),
                                    ),
                                    const Icon(Icons.chevron_right),
                                  ],
                                ),
                                onTap: _pickLanguage,
                              ),
                              Divider(
                                height: 1,
                                color: p.outline.withValues(alpha: 0.5),
                              ),
                              // Minggu 13: tiga pilihan tema — Terang, Gelap,
                              // dan Ikuti Sistem (sama seperti Pengaturan siswa).
                              const ThemeModeTile(),
                              // Minggu 13: notifikasi dibuka lewat modal.
                              // Pengajar tetap punya tombol uji coba di dalamnya.
                              const NotificationSettingsTile(
                                showTestButton: true,
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
                                title: Text(l10n.settingsSfx),
                                subtitle: Text(
                                  l10n.settingsSfxSubtitle,
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
                                title: Text(l10n.settingsLabSfx),
                                subtitle: Text(
                                  l10n.settingsLabSfxSubtitle,
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
                        const SizedBox(height: AppSpacing.xxl),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'CodeLab AI Studio v2.4.0 (Build 384)',
                                style: AppTypography.caption.copyWith(
                                  color: p.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '© 2025 CodeLab AI Inc. All rights reserved.',
                                style: AppTypography.caption.copyWith(
                                  color: p.textMuted.withValues(alpha: 0.7),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Devwan Hidayawan 2413025009',
                                style: AppTypography.caption.copyWith(
                                  color: p.textMuted.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
