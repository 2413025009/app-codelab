import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/app_sheet.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  // Minggu 9: pengaturan kini sadar peran — akun guru tidak lagi melihat
  // kolom NISN/Kelas milik siswa, melainkan Alamat + Kode Kepegawaian.
  late final TextEditingController _nameController;
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
  /// semua kolom (kecuali email — identitas login) lalu tombolnya berubah
  /// menjadi "Simpan Perubahan" (+ "Batalkan" untuk membuang perubahan);
  /// mode baca kembali setelah tersimpan atau dibatalkan.
  bool _isEditing = false;
  bool _isSaving = false;
  bool _sfxEnabled = SoundService.sfxEnabled;
  bool _labSoundEnabled = SoundService.labSfxEnabled;

  @override
  void initState() {
    super.initState();
    _sfxEnabled = SoundService.sfxEnabled;
    _labSoundEnabled = SoundService.labSfxEnabled;
    final user = context.read<AuthCubit>().state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
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
    _phoneController.text = user?.phone ?? '';
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
    showAppSheet<void>(
      context,
      title: 'Ubah Password',
      subtitle: 'Aturan sandi sama seperti saat kamu mendaftar akun.',
      builder: (_) => const _ChangePasswordSheet(),
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
    setState(() => _isSaving = true);
    try {
      final cubit = context.read<AuthCubit>();
      if (_isTeacher) {
        // Pengajar: afiliasi sekolah read-only pasca verifikasi — tidak
        // ikut payload; kolom kepegawaian (NIP/NIK) & alamat ikut disimpan.
        await cubit.updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          bio: _bioController.text.trim(),
          address: _addressController.text.trim(),
          staffCode: _staffCodeController.text.trim(),
        );
      } else {
        await cubit.updateProfile(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          bio: _bioController.text.trim(),
          nisn: _nisnController.text.trim(),
          schoolName: _schoolController.text.trim(),
          className: _classController.text.trim(),
        );
      }
      if (mounted) {
        SoundService.playProfileSaved();
        showAppSnack(context, 'Perubahan profil berhasil disimpan!');
        setState(() {
          _isEditing = false;
          _syncFieldsToUser();
        });
      }
    } catch (e) {
      if (mounted) {
        showAppSnack(context, 'Gagal menyimpan profil. Coba lagi.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Keluar dari Akun?'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari sesi latihan lab saat ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: context.palette.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
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

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final user = context.watch<AuthCubit>().state.user;

    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'S';
    final school = user?.schoolName ?? '—';
    final className = user?.className ?? '—';
    final email = user?.email ?? '—';

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        title: const Text('Pengaturan'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali',
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
                    'PENGATURAN AKUN',
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
                          CircleAvatar(
                            radius: 46,
                            backgroundColor: p.primary,
                            child: Text(
                              initial,
                              style: AppTypography.display.copyWith(
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: p.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: p.surface, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
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
                              ? 'Guru / Pengajar'
                              : 'Siswa RPL • Tingkat Pemula',
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
                                  'Mode edit aktif — ubah datamu, lalu tekan "Simpan Perubahan".',
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
                      _buildFieldHeader('Nama Lengkap', 'Maks 40 karakter'),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _nameController,
                        maxLength: 40,
                        readOnly: !_isEditing,
                        showCursor: _isEditing,
                        decoration: _fieldDecoration(Icons.badge_outlined),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),

                      if (!_isTeacher) ...[
                        _buildFieldHeaderWithBadge(
                          'NISN / ID Siswa',
                          'Terverifikasi Dapodik',
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

                        _buildFieldHeader('Nama Sekolah / Institusi', null),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _schoolController,
                          maxLength: 150,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.domain_outlined),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _buildFieldHeader('Kelas & Jurusan', null),
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
                        _buildFieldHeader('Alamat', null),
                        const SizedBox(height: AppSpacing.xs),
                        TextFormField(
                          controller: _addressController,
                          maxLength: 255,
                          readOnly: !_isEditing,
                          showCursor: _isEditing,
                          decoration: _fieldDecoration(Icons.home_outlined),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        _buildFieldHeader('Kode Kepegawaian (NIP/NIK)', null),
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
                          'Sekolah Terafiliasi',
                          'Terverifikasi',
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

                      _buildFieldHeader('Nomor Handphone / WhatsApp', null),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 25,
                        readOnly: !_isEditing,
                        showCursor: _isEditing,
                        decoration: _fieldDecoration(Icons.call_outlined),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildFieldHeaderWithBadge(
                        _isTeacher ? 'Email Pengajar' : 'Email Akun Belajar',
                        'Terverifikasi',
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextFormField(
                        initialValue: email,
                        readOnly: true,
                        enabled: false,
                        decoration: _lockedDecoration(Icons.lock_outline),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _buildFieldHeader(
                        _isTeacher
                            ? 'Bio / Catatan Pengajar'
                            : 'Bio / Catatan Belajar',
                        'Maks 120 karakter',
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
                                label: 'Simpan Perubahan',
                                loading: _isSaving,
                                onPressed: _saveProfile,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppButton(
                                label: 'Batalkan',
                                kind: AppButtonKind.secondary,
                                leadingIcon: Icons.close_rounded,
                                onPressed: _isSaving ? null : _cancelEditing,
                              ),
                            ),
                          ],
                        ),
                      ] else
                        AppButton(
                          label: 'Edit Data',
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
                      ListTile(
                        leading: Icon(Icons.translate, color: p.primary),
                        title: const Text('Bahasa Konten'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Indonesia',
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {},
                      ),
                      Divider(
                        height: 1,
                        color: p.outline.withValues(alpha: 0.5),
                      ),
                      ListTile(
                        leading: Icon(Icons.palette_outlined, color: p.primary),
                        title: const Text('Tampilan'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Ikuti Sistem',
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () {},
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
                  'PENGATURAN AKUN & LAB',
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
                          title: const Text('Kurikulum Merdeka'),
                          subtitle: Text(
                            'Sinkron • Pak Budi (Guru Pembimbing)',
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
                              'Aktif',
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
                        title: const Text('Pusat Bantuan Lab'),
                        subtitle: Text(
                          'FAQ Compiler AI & Panduan Guru',
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
                        title: const Text('Ubah Password'),
                        subtitle: Text(
                          'Kata sandi lama & baru dengan checklist keamanan',
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
                          'Keluar Akun (Log Out)',
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

  /// Dekorasi kolom yang PERMANEN mati (email — identitas login): selalu
  /// tampak pasif di mode mana pun, tidak ikut menyala saat mode edit.
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

/// Minggu 9 (owner): sheet "Ubah Password" — dipakai akun siswa maupun
/// pengajar (kontrak sama). Meniru checklist keamanan layar registrasi:
/// minimal 8 karakter, ada angka atau simbol, plus keterangan hidup apakah
/// konfirmasi sudah cocok. Endpoint: POST /auth/change-password (butuh
/// sesi aktif + kata sandi lama yang cocok — galat dari server ditampilkan
/// jujur sebagai banner, mis. sandi lama belum cocok).
class _ChangePasswordSheet extends StatefulWidget {
  const _ChangePasswordSheet();

  @override
  State<_ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _old = TextEditingController();
  final _new = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _saving = false;

  /// Pesan galat dari server (mis. kata sandi lama salah) — tampil banner.
  String? _submitError;

  bool get _confirmMatch =>
      _confirm.text.isNotEmpty && _confirm.text == _new.text;

  bool get _canSubmit =>
      _old.text.isNotEmpty &&
      Validators.newPassword(_new.text) == null &&
      _confirm.text == _new.text &&
      !_saving;

  @override
  void dispose() {
    _old.dispose();
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  /// Setiap ketikan: segarkan checklist/caption + bersihkan banner galat.
  void _onChanged() => setState(() => _submitError = null);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || !_canSubmit) return;
    setState(() => _saving = true);
    try {
      await context.read<AuthCubit>().changePassword(
        oldPassword: _old.text,
        newPassword: _new.text,
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      showAppSnack(context, 'Kata sandi berhasil diubah!');
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _submitError = e.message);
    } catch (_) {
      if (mounted) {
        setState(() => _submitError = 'Gagal mengubah kata sandi. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _passwordDecoration({
    required String label,
    required IconData icon,
    required bool obscure,
    required ValueChanged<bool> toggle,
  }) {
    final p = context.palette;
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: p.primary),
      counterText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: p.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: p.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: p.primary, width: 2),
      ),
      suffixIcon: IconButton(
        tooltip: obscure ? 'Tampilkan sandi' : 'Sembunyikan sandi',
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: p.textMuted,
        ),
        onPressed: () => toggle(!obscure),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.screen,
        right: AppSpacing.screen,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _old,
                obscureText: _obscureOld,
                onChanged: (_) => _onChanged(),
                maxLength: 72,
                validator: (v) => (v == null || v.isEmpty)
                    ? 'Isi kata sandi lama dulu.'
                    : null,
                decoration: _passwordDecoration(
                  label: 'Kata Sandi Lama',
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscureOld,
                  toggle: (v) => setState(() => _obscureOld = v),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _new,
                obscureText: _obscureNew,
                onChanged: (_) => _onChanged(),
                maxLength: 72,
                autofillHints: const [AutofillHints.newPassword],
                validator: Validators.newPassword,
                decoration: _passwordDecoration(
                  label: 'Kata Sandi Baru',
                  icon: Icons.key_outlined,
                  obscure: _obscureNew,
                  toggle: (v) => setState(() => _obscureNew = v),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              // Checklist keamanan — komponen yang sama seperti registrasi.
              PasswordChecklist(password: _new.text),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _confirm,
                obscureText: _obscureConfirm,
                onChanged: (_) => _onChanged(),
                maxLength: 72,
                autofillHints: const [AutofillHints.newPassword],
                validator: (v) => Validators.confirmPassword(v, _new.text),
                decoration: _passwordDecoration(
                  label: 'Konfirmasi Kata Sandi Baru',
                  icon: Icons.repeat_rounded,
                  obscure: _obscureConfirm,
                  toggle: (v) => setState(() => _obscureConfirm = v),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              // Keterangan hidup: apakah konfirmasi sudah cocok.
              Row(
                children: [
                  Icon(
                    _confirmMatch
                        ? Icons.check_circle_rounded
                        : Icons.error_outline_rounded,
                    size: 16,
                    color: _confirmMatch ? p.success : p.textMuted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _confirm.text.isEmpty
                          ? 'Ketik ulang kata sandi baru untuk konfirmasi.'
                          : _confirmMatch
                          ? 'Konfirmasi cocok dengan kata sandi baru.'
                          : 'Konfirmasi belum sama dengan kata sandi baru.',
                      style: AppTypography.caption.copyWith(
                        color: _confirmMatch ? p.success : p.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              if (_submitError != null) ...[
                const SizedBox(height: AppSpacing.md),
                FormBanner(message: _submitError!),
              ],
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: _saving ? 'Menyimpan…' : 'Simpan Kata Sandi',
                onPressed: _canSubmit ? _submit : null,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
