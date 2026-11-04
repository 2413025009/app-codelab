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
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../../core/widgets/avatars.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../widgets/change_password_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  /// Pintasan kamus UI supaya semua pembangun layar ini konsisten.
  AppLocalizations get l10n => AppLocalizations.of(context);

  final _formKey = GlobalKey<FormState>();
  // Minggu 9: pengaturan kini sadar peran — akun guru tidak lagi melihat
  // kolom NISN/Kelas milik siswa, melainkan Alamat + Kode Kepegawaian.
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  late final TextEditingController _nisnController;
  late final TextEditingController _schoolController;
  late final TextEditingController _classController;
  late final TextEditingController _addressController;
  late final TextEditingController _staffCodeController;

  /// Pagar peran akun (siswa vs pengajar); peran tetap sepanjang sesi.
  bool _isTeacher = false;

  /// Kondisi awal halaman: data profil HANYA-BACA. Tap "Edit Data" membuka
  /// semua kolom (termasuk email — wajib berdomain @smk.belajar.id) lalu
  /// tombolnya berubah menjadi "Simpan Perubahan" (+ "Batalkan" untuk membuang
  /// perubahan); mode baca kembali setelah tersimpan atau dibatalkan.
  bool _isEditing = false;
  bool _isSaving = false;
  bool _isUploadingAvatar = false;
  bool _sfxEnabled = SoundService.sfxEnabled;
  bool _labSoundEnabled = SoundService.labSfxEnabled;

  @override
  void initState() {
    super.initState();
    _sfxEnabled = SoundService.sfxEnabled;
    _labSoundEnabled = SoundService.labSfxEnabled;
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    // Nomor disimpan tanpa awalan; kolom isian menampilkan bagian setelah +62.
    _phoneController = TextEditingController(
      text: phoneInputValue(user?.phone ?? ''),
    );
    _bioController = TextEditingController(text: user?.bio ?? '');
    _nisnController = TextEditingController(text: user?.nisn ?? '');
    _schoolController = TextEditingController(text: user?.schoolName ?? '');
    _classController = TextEditingController(text: user?.className ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
    _staffCodeController = TextEditingController(text: user?.staffCode ?? '');
    _isTeacher = (user?.role ?? 'student') == 'teacher';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _nisnController.dispose();
    _schoolController.dispose();
    _classController.dispose();
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
    _nisnController.text = user?.nisn ?? '';
    _schoolController.text = user?.schoolName ?? '';
    _classController.text = user?.className ?? '';
    _addressController.text = user?.address ?? '';
    _staffCodeController.text = user?.staffCode ?? '';
  }

  /// Minggu 9 (owner): tarik layar dari atas → muat ulang data profil dari
  /// server (GET /me via restoreSession), lalu isi ulang seluruh kolom.
  Future<void> _reloadProfile() async {
    await context.read<AuthCubit>().restoreSession();
    if (!mounted) return;
    setState(_syncFieldsToUser);
  }

  /// Minggu 9 (owner): sheet "Ubah Password" — isi sandi lama, baru, dan
  /// konfirmasi dengan checklist keamanan seperti layar registrasi.
  void _openChangePassword() {
    final l10n = AppLocalizations.of(context);
    showAppSheet<void>(
      context,
      title: l10n.settingsChangePassword,
      subtitle: l10n.settingsChangePasswordSheetSubtitle,
      builder: (_) => const ChangePasswordSheet(),
    );
  }

  /// Masuk mode edit: semua kolom jadi bisa ditap, tombol berubah jadi
  /// "Simpan Perubahan".
  void _startEditing() {
    _syncFieldsToUser();
    setState(() => _isEditing = true);
  }

  /// Keluar mode edit TANPA menyimpan: isi kolom dikembalikan ke data user
  /// (perubahan yang belum disimpan dibuang) dan error validasi dibersihkan.
  void _cancelEditing() {
    _syncFieldsToUser();
    _formKey.currentState?.reset();
    setState(() => _isEditing = false);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context);
    setState(() => _isSaving = true);
    try {
      final cubit = context.read<AuthCubit>();
      final phone = normalizePhone(_phoneController.text);
      if (_isTeacher) {
        // Pengajar: afiliasi sekolah read-only pasca verifikasi — tidak
        // ikut payload; kolom kepegawaian (NIP/NIK) & alamat ikut disimpan.
        await cubit.updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone,
          bio: _bioController.text.trim(),
          address: _addressController.text.trim(),
          staffCode: _staffCodeController.text.trim(),
        );
      } else {
        await cubit.updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: phone,
          bio: _bioController.text.trim(),
          nisn: _nisnController.text.trim(),
          schoolName: _schoolController.text.trim(),
          className: _classController.text.trim(),
        );
      }
      if (mounted) {
        SoundService.playProfileSaved();
        showAppSnack(context, l10n.settingsProfileSaved);
        setState(() {
          _isEditing = false;
          _syncFieldsToUser();
        });
      }
    } on AuthFailure catch (e) {
      // EMAIL_TAKEN / EMAIL_DOMAIN / sesi berakhir tampil apa adanya.
      if (mounted) showAppSnack(context, e.messageL10n(l10n));
    } catch (e) {
      if (mounted) {
        showAppSnack(context, l10n.settingsProfileSaveFailed);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _pickAvatar() async {
    if (_isUploadingAvatar) return;
    final l10n = AppLocalizations.of(context);
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
        showAppSnack(context, l10n.settingsAvatarMaxSize);
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
    final l10n = AppLocalizations.of(context);
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
              foregroundColor: p.onPrimary,
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

  /// Pilih bahasa antarmuka (Indonesia / English / العربية).
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
          final currentCode =
              AppPreferences.instance.locale.languageCode;
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

  Future<void> _confirmLogout() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.settingsLogoutTitle),
        content: Text(
          l10n.settingsLogoutBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.palette.error,
              foregroundColor: context.palette.onPrimary,
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l10n.settingsLogoutConfirm),
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

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;

    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'S';
    final school = user?.schoolName ?? '—';
    final className = user?.className ?? '—';

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.actionBack,
          // Minggu 9 (owner): tombol kembali WAJIB selalu bekerja — bila
          // halaman dibuka langsung lewat URL / context.go (tanpa riwayat
          // stack), fallback menuju beranda sesuai peran: dashboard-siswa
          // atau dashboard-pengajar, bukan pop no-op.
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            final isTeacher =
                context.read<AuthCubit>().state.user?.role == 'teacher';
            context.go(isTeacher ? AppRoutes.teacherHome : AppRoutes.dashboard);
          },
        ),
      ),
      // Minggu 9 (owner): tarik layar dari atas → muat ulang profil
      // (lingkaran pemuat mengikuti jarak tarikan).
      body: AppRefresh(
        onRefresh: _reloadProfile,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screen,
            vertical: AppSpacing.md,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top tag
                Center(
                  child: Text(
                    l10n.settingsAccountTag,
                    style: AppTypography.caption.copyWith(
                      color: p.textMuted,
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Avatar & Hero Card
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          UserAvatar(
                            name: user?.name ?? initial,
                            avatarUrl: user?.avatarUrl,
                            size: 92,
                            onTap: _isUploadingAvatar ? null : _pickAvatar,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IgnorePointer(
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: p.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: p.surface,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 16,
                                  color: p.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.name ?? 'Muhammad Farhan',
                            style: AppTypography.titleL.copyWith(color: p.text),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.verified, size: 18, color: p.primary),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: p.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          // Minggu 9 (bug): sebelumnya selalu "Siswa RPL" —
                          // akun guru pun terlabel siswa. Chip kini ikut peran.
                          _isTeacher
                              ? l10n.settingsRoleTeacher
                              : l10n.settingsRoleStudent,
                          style: AppTypography.caption.copyWith(
                            color: p.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        // Guru tanpa Kelas & Jurusan.
                        _isTeacher ? school : '$school • $className',
                        style: AppTypography.caption.copyWith(
                          color: p.textMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (_isUploadingAvatar)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: p.primary,
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton.icon(
                              onPressed: _pickAvatar,
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: Text(l10n.settingsChangePhoto),
                            ),
                            if ((user?.avatarUrl ?? '').isNotEmpty)
                              TextButton.icon(
                                onPressed: _deleteAvatar,
                                style: TextButton.styleFrom(
                                  foregroundColor: p.error,
                                ),
                                icon: const Icon(Icons.delete_outline_rounded),
                                label: Text(l10n.actionDelete),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Form fields card
                AppCard(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_isEditing)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          margin: const EdgeInsets.only(bottom: AppSpacing.md),
                          decoration: BoxDecoration(
                            color: p.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              AppRadius.input,
                            ),
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
                      _buildFieldHeader(l10n.settingsFieldFullName, l10n.settingsFieldFullNameAside),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _nameController,
                        maxLength: 40,
                        readOnly: !_isEditing,
                        showCursor: _isEditing,
                        decoration: _fieldDecoration(Icons.badge_outlined),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return l10n.settingsFullNameEmpty;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      if (!_isTeacher) ...[
                        _buildFieldHeaderWithBadge(
                          l10n.settingsFieldNisn,
                          l10n.settingsBadgeVerifiedDapodik,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _nisnController,
                          maxLength: 20,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.school_outlined),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _buildFieldHeader(l10n.settingsFieldSchool, null),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _schoolController,
                          maxLength: 150,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.domain_outlined),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _buildFieldHeader(l10n.settingsFieldClass, null),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _classController,
                          maxLength: 50,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.category_outlined),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ] else ...[
                        // Minggu 9 (bug): pagar peran pengajar — NISN/Nama
                        // Sekolah/Kelas diganti Alamat + Kode Kepegawaian,
                        // afiliasi sekolah tampil TERKUNCI (verifikasi kode).
                        _buildFieldHeader(l10n.settingsFieldAddress, null),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _addressController,
                          maxLength: 255,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.home_outlined),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _buildFieldHeader(l10n.settingsFieldStaffCode, null),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _staffCodeController,
                          maxLength: 64,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.work_outline),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _buildFieldHeaderWithBadge(
                          l10n.settingsFieldAffiliatedSchool,
                          l10n.settingsBadgeVerified,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          initialValue: school == '—' ? '' : school,
                          readOnly: true,
                          enabled: false,
                          decoration: _lockedDecoration(
                            Icons.account_balance_rounded,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],

                      _buildFieldHeader(l10n.settingsFieldPhone, null),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 25,
                        readOnly: !_isEditing,
                        showCursor: _isEditing,
                        validator: (value) {
                          final digits = normalizePhone(value ?? '');
                          if (digits.isEmpty) return null;
                          if (digits.length < 8 || digits.length > 15) {
                            return l10n.settingsPhoneIncomplete;
                          }
                          return null;
                        },
                        decoration: _fieldDecoration(Icons.call_outlined)
                            .copyWith(
                              prefixText: '+62 ',
                              helperText:
                                  l10n.settingsPhoneHelper,
                              counterText: '',
                            ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildFieldHeader(
                        _isTeacher ? l10n.settingsFieldTeacherEmail : l10n.settingsFieldStudentEmail,
                        l10n.settingsEmailAside,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        maxLength: 254,
                        readOnly: !_isEditing,
                        showCursor: _isEditing,
                        validator: (v) => Validators.schoolEmail(v, l10n),
                        decoration: _fieldDecoration(Icons.alternate_email)
                            .copyWith(counterText: ''),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildFieldHeader(
                        _isTeacher
                            ? l10n.settingsFieldTeacherBio
                            : l10n.settingsFieldStudentBio,
                        l10n.settingsFieldBioAside,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _bioController,
                        maxLines: 3,
                        maxLength: 120,
                        readOnly: !_isEditing,
                        showCursor: _isEditing,
                        decoration: _fieldDecoration(null),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      if (_isEditing) ...[
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: l10n.settingsSaveChanges,
                                loading: _isSaving,
                                onPressed: _saveProfile,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppButton(
                                label: l10n.settingsCancelEdit,
                                kind: AppButtonKind.secondary,
                                leadingIcon: Icons.close_rounded,
                                onPressed: _isSaving ? null : _cancelEditing,
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
                const SizedBox(height: AppSpacing.xl),

                // Preferensi Aplikasi
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
                      ListTile(
                        leading: Icon(Icons.translate, color: p.primary),
                        title: Text(l10n.settingsLanguage),
                        subtitle: Text(
                          AppLocalizations.of(context).settingsLanguageSubtitle,
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
                      SwitchListTile(
                        secondary: Icon(
                          Icons.dark_mode_outlined,
                          color: p.primary,
                        ),
                        title: Text(l10n.settingsDarkMode),
                        subtitle: Text(
                          l10n.settingsDarkModeSubtitle,
                          style: AppTypography.caption.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                        // Cerminkan tampilan yang benar-benar aktif, termasuk
                        // saat tema mengikuti sistem.
                        value: Theme.of(context).brightness == Brightness.dark,
                        activeTrackColor: p.primary,
                        onChanged: (val) async {
                          await AppPreferences.instance.setThemeMode(
                            val ? ThemeMode.dark : ThemeMode.light,
                          );
                          if (mounted) setState(() {});
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
                        value: _labSoundEnabled,
                        activeTrackColor: p.primary,
                        onChanged: (val) {
                          setState(() => _labSoundEnabled = val);
                          SoundService.setLabSfxEnabled(val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Pengaturan Akun & Lab
                Text(
                  l10n.settingsAccountLabHeader,
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
                      // Minggu 9 (bug): baris "Sinkron • Pak Budi (Guru
                      // Pembimbing)" berbingkai siswa — disembunyikan untuk
                      // akun guru.
                      if (!_isTeacher) ...[
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: p.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.sync, color: p.primary, size: 20),
                          ),
                          title: Text(l10n.settingsCurriculum),
                          subtitle: Text(
                            l10n.settingsCurriculumSubtitle,
                            style: AppTypography.caption.copyWith(
                              color: p.textMuted,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: p.surfaceAlt,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.settingsActive,
                              style: AppTypography.caption.copyWith(
                                color: p.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: p.outline.withValues(alpha: 0.5),
                        ),
                      ],
                      ListTile(
                        leading: Icon(
                          Icons.support_agent_outlined,
                          color: p.primary,
                        ),
                        title: Text(l10n.settingsHelpCenter),
                        subtitle: Text(
                          l10n.settingsHelpCenterSubtitle,
                          style: AppTypography.caption.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: p.outline.withValues(alpha: 0.5),
                      ),
                      ListTile(
                        leading: Icon(Icons.password_rounded, color: p.primary),
                        title: Text(l10n.settingsChangePassword),
                        subtitle: Text(
                          l10n.settingsChangePasswordSubtitle,
                          style: AppTypography.caption.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _openChangePassword,
                      ),
                      Divider(
                        height: 1,
                        color: p.outline.withValues(alpha: 0.5),
                      ),
                      ListTile(
                        leading: Icon(Icons.logout, color: p.error),
                        title: Text(
                          l10n.settingsLogout,
                          style: AppTypography.label.copyWith(
                            color: p.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: p.error,
                          size: 18,
                        ),
                        onTap: _confirmLogout,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),

                // Version footer
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
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Dekorasi kolom sesuai mode — inilah yang membuat perbedaannya mencolok:
  ///  - mode BACA : chip datar abu tanpa border, kursor disembunyikan
  ///    → jelas tidak sedang diedit;
  ///  - mode EDIT : bidang putih ber-border biru utama; saat fokus border
  ///    menebal 2px, saat error merah (keduanya warisi tema global) → jelas
  ///    sedang diedit.
  /// DIPAKAI OLEH: semua kolom profil yang membuka lewat tombol "Edit Data".
  InputDecoration _fieldDecoration(IconData? icon) {
    final p = context.palette;
    if (_isEditing) {
      return InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: p.primary) : null,
        counterText: '',
        filled: true,
        fillColor: p.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputBorder,
          borderSide: BorderSide(
            color: p.primary.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
      );
    }
    return InputDecoration(
      prefixIcon: icon != null ? Icon(icon, color: p.textMuted) : null,
      counterText: '',
      filled: true,
      fillColor: p.surfaceAlt.withValues(alpha: 0.45),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }

  /// Dekorasi kolom yang PERMANEN mati (sekolah terafiliasi — hasil
  /// verifikasi kode): selalu tampak pasif di mode mana pun.
  InputDecoration _lockedDecoration(IconData icon) {
    final p = context.palette;
    return InputDecoration(
      prefixIcon: Icon(icon, color: p.textMuted),
      filled: true,
      fillColor: p.surfaceAlt.withValues(alpha: 0.45),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
    );
  }

  Widget _buildFieldHeader(String label, String? aside) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: context.palette.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (aside != null)
          Text(
            aside,
            style: AppTypography.caption.copyWith(
              color: context.palette.textMuted,
            ),
          ),
      ],
    );
  }

  Widget _buildFieldHeaderWithBadge(String label, String badge) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: context.palette.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: context.palette.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            badge,
            style: AppTypography.caption.copyWith(
              color: context.palette.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}

