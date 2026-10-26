// FILE: lib/features/teacher/presentation/pages/teacher_profile_page.dart
//
// TUGAS (Minggu 9): profil pengajar dengan edit INLINE — tanpa modal.
// Konsepnya sama seperti Pengaturan siswa: tanpa mode edit seluruh data
// tampil read-only; tap "Edit Data" → kolom berubah menjadi input dengan
// border berwarna utama ditutup tombol Simpan/Batal. Email & afiliasi
// sekolah tetap read-only pasca verifikasi kode sekolah (PROMPT.md §3).
//
// Minggu 9 (owner): data pengajar bertambah Alamat & Kode Kepegawaian
// (NIP/NIK) — tersimpan via PUT /me (kolom address & staff_code, migrasi
// 000018). Daftar kelas & siswa yang dikelola menyusul pada Minggu 11.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_refresh.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';

class TeacherProfilePage extends StatefulWidget {
  const TeacherProfilePage({super.key});

  @override
  State<TeacherProfilePage> createState() => _TeacherProfilePageState();
}

class _TeacherProfilePageState extends State<TeacherProfilePage> {
  final _formKey = GlobalKey<FormState>();
  // Kolom profil pengajar — diisi ulang setiap masuk/keluar mode edit.
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _staffCodeCtrl = TextEditingController();

  /// Pola sama seperti Pengaturan siswa: mode BACA dulu, edit menyala
  /// saat tombol "Edit Data" ditekan (bukan lagi lewat modal).
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    _addressCtrl.dispose();
    _staffCodeCtrl.dispose();
    super.dispose();
  }

  void _syncFields(AuthUser user) {
    void set(TextEditingController c, String v) {
      if (c.text != v) c.text = v;
    }

    set(_nameCtrl, user.name);
    set(_phoneCtrl, user.phone ?? '');
    set(_bioCtrl, user.bio ?? '');
    set(_addressCtrl, user.address ?? '');
    set(_staffCodeCtrl, user.staffCode ?? '');
  }

  void _startEditing(AuthUser user) {
    _syncFields(user);
    setState(() => _isEditing = true);
  }

  /// Keluar mode edit TANPA menyimpan: kolom kembali ke data user terbaru.
  void _cancelEditing(AuthUser user) {
    _syncFields(user);
    _formKey.currentState?.reset();
    setState(() => _isEditing = false);
  }

  /// Afiliasi sekolah sengaja TIDAK dikirim — read-only pasca verifikasi
  /// kode sekolah; yang berubah hanya data diri + kepegawaian.
  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cubit = context.read<AuthCubit>();
    setState(() => _isSaving = true);
    try {
      await cubit.updateProfile(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        staffCode: _staffCodeCtrl.text.trim(),
      );
      if (mounted) {
        setState(() => _isEditing = false);
        showAppSnack(context, 'Profil pengajar berhasil diperbarui.');
      }
    } on AuthFailure catch (e) {
      if (mounted) showAppSnack(context, e.message);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final first = parts.isEmpty ? 'G' : parts.first[0];
    final second = parts.length > 1 ? parts.last[0] : '';
    return ('$first$second').toUpperCase();
  }

  /// Dekorasi kolom identik Pengaturan siswa supaya konsep editnya nyaris
  /// tidak bisa dibedakan: mode BACA = chip abu datar tanpa border; mode
  /// EDIT = bidang putih ber-border warna utama (jelas sedang diedit).
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

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: AppTypography.label.copyWith(
        color: context.palette.text,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.teacherHome),
        ),
        title: const Text('Profil Pengajar'),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.user;
          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Center(
            // Minggu 9 (owner): tarik layar dari atas → muat ulang profil
            // pengajar dari server (lingkaran mengikuti tarikan).
            child: AppRefresh(
              onRefresh: () => context.read<AuthCubit>().restoreSession(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- Kartu identitas pengajar ---
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: p.surface,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(color: p.outline),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: p.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                _initials(user.name),
                                style: AppTypography.titleL.copyWith(
                                  color: p.primary,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              user.name,
                              textAlign: TextAlign.center,
                              style: AppTypography.titleM.copyWith(
                                color: p.text,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Container(
                              height: AppSizes.tagHeight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: p.primaryContainer,
                                borderRadius: AppRadius.pillBorder,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.cast_for_education_rounded,
                                    size: 14,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    'Guru / Pengajar',
                                    style: AppTypography.caption.copyWith(
                                      color: p.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              user.email,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyM.copyWith(
                                color: p.textMuted,
                              ),
                            ),
                            // Minggu 9: bio pribadi pengajar tampil rata tengah,
                            // selaras dengan kartu identitas profil siswa.
                            if ((user.bio ?? '').trim().isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                user.bio!.trim(),
                                textAlign: TextAlign.center,
                                style: AppTypography.bodyM.copyWith(
                                  color: p.textMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // --- Data pengajar — edit INLINE (tanpa modal) ---
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: p.surface,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(color: p.outline),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.badge_rounded,
                                    size: 20,
                                    color: p.primary,
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      'Data Pengajar',
                                      style: AppTypography.label.copyWith(
                                        color: p.text,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  if (!_isEditing)
                                    IconButton(
                                      tooltip: 'Edit data pengajar',
                                      icon: Icon(
                                        Icons.edit_rounded,
                                        size: 18,
                                        color: p.primary,
                                      ),
                                      onPressed: () => _startEditing(user),
                                    )
                                  else
                                    IconButton(
                                      tooltip: 'Batalkan edit',
                                      icon: Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: p.textMuted,
                                      ),
                                      onPressed: _isSaving
                                          ? null
                                          : () => _cancelEditing(user),
                                    ),
                                ],
                              ),
                              if (_isEditing) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.md,
                                  ),
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
                                _fieldLabel('Nama & Gelar'),
                                const SizedBox(height: AppSpacing.xs),
                                TextFormField(
                                  controller: _nameCtrl,
                                  maxLength: 40,
                                  textInputAction: TextInputAction.next,
                                  validator: Validators.name,
                                  decoration: _fieldDecoration(
                                    Icons.badge_outlined,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                _fieldLabel('Telepon'),
                                const SizedBox(height: AppSpacing.xs),
                                TextFormField(
                                  controller: _phoneCtrl,
                                  maxLength: 25,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  decoration: _fieldDecoration(
                                    Icons.call_outlined,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                _fieldLabel('Bio Pengajar'),
                                const SizedBox(height: AppSpacing.xs),
                                TextFormField(
                                  controller: _bioCtrl,
                                  maxLines: 3,
                                  maxLength: 120,
                                  decoration: _fieldDecoration(null),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                // Minggu 9 (owner): data kepegawaian pengajar.
                                _fieldLabel('Alamat'),
                                const SizedBox(height: AppSpacing.xs),
                                TextFormField(
                                  controller: _addressCtrl,
                                  maxLength: 255,
                                  textInputAction: TextInputAction.next,
                                  decoration: _fieldDecoration(
                                    Icons.home_outlined,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                _fieldLabel('Kode Kepegawaian (NIP/NIK)'),
                                const SizedBox(height: AppSpacing.xs),
                                TextFormField(
                                  controller: _staffCodeCtrl,
                                  maxLength: 64,
                                  textInputAction: TextInputAction.done,
                                  decoration: _fieldDecoration(
                                    Icons.work_outline,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.lg),
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
                                        onPressed: _isSaving
                                            ? null
                                            : () => _cancelEditing(user),
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                const SizedBox(height: AppSpacing.md),
                                _DataRow(
                                  label: 'Nama & Gelar',
                                  value: user.name,
                                ),
                                _DataRow(
                                  label: 'Telepon',
                                  value: user.phone ?? '-',
                                ),
                                _DataRow(
                                  label: 'Bio Pengajar',
                                  value: user.bio ?? '-',
                                ),
                                // Minggu 9 (owner): data kepegawaian pengajar
                                // ikut tampil pada mode baca.
                                _DataRow(
                                  label: 'Alamat',
                                  value: user.address ?? '-',
                                ),
                                _DataRow(
                                  label: 'Kode Kepegawaian',
                                  value: user.staffCode ?? '-',
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // --- Afiliasi sekolah READ-ONLY (Minggu 9) ---
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: p.successContainer,
                          borderRadius: AppRadius.cardBorder,
                          border: Border.all(
                            color: p.success.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_rounded,
                                  size: 20,
                                  color: p.success,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'Sekolah Terafiliasi',
                                    style: AppTypography.label.copyWith(
                                      color: p.text,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.lock_outline_rounded,
                                  size: 16,
                                  color: p.success,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              user.schoolName ?? 'Belum terafiliasi',
                              style: AppTypography.label.copyWith(
                                color: p.text,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Hasil verifikasi kode sekolah resmi — data instansi bersifat read-only dan tidak dapat diubah oleh instruktur.',
                              style: AppTypography.caption.copyWith(
                                color: p.success,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: 'Buka Pengaturan',
                        kind: AppButtonKind.secondary,
                        leadingIcon: Icons.settings_outlined,
                        // Minggu 9 (owner): push (bukan go) agar tombol
                        // kembali di Pengaturan punya riwayat stack.
                        onPressed: () => context.push(AppRoutes.settings),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: 'Keluar Akun',
                        kind: AppButtonKind.text,
                        onPressed: () => context.read<AuthCubit>().logout(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Baris pasangan label-nilai pada kartu data pengajar (mode baca).
class _DataRow extends StatelessWidget {
  const _DataRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTypography.bodyM.copyWith(
                color: p.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.bodyM.copyWith(color: p.text),
            ),
          ),
        ],
      ),
    );
  }
}
