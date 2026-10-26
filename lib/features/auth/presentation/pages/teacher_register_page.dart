// FILE: lib/features/auth/presentation/pages/teacher_register_page.dart
//
// TUGAS: pendaftaran akun Guru/Pengajar berpagar kode sekolah resmi
// (Minggu 9 — terjemahan Stitch v3 `registrasi_pilihan_role_siswa_guru_
// verifikasi_sekolah` + PROMPT.md Bagian 3 `RegisterRoleSchoolSection`).
//
// FUNGSI YANG DIKELOLA:
//   - Pemilihan peran (kartu "Siswa Belajar" / "Guru / Instruktur") —
//     tap siswa kembali ke regristrasi akun biasa + SFX playButtonClick.
//   - Verifikasi Kode Registrasi Sekolah: dengan debounce, kode diketik
//     diperiksa via AuthRepository.verifySchool → kartu sekolah read-only
//     muncul (badge "Sekolah Terdaftar Resmi"), kode salah tampilkan galat
//     suportif tanpa menyalahkan.
//   - Form identitas pendidik: Nama Lengkap & Gelar, Email, Kata Sandi
//     (checklist keamanan sama seperti register siswa).
//   - Submit: AuthCubit.registerTeacher (role "teacher" + terafiliasi
//     sekolah), lalu arahkan ke halaman login dengan email terisi.
//
// SRC & KOLOM DB: backend POST /auth/register/teacher (users.role=teacher,
// users.school_id dari schools.school_code) + GET /schools/verify.
//
// WAJIB DIUBAH BILA: kolom profil guru baru (NIP/gelar) ditambahkan ke
// kontrak TeacherRegisterRequest backend.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/auth_repository.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';
import 'register_page.dart' show AppTagBanner;

class TeacherRegisterPage extends StatefulWidget {
  const TeacherRegisterPage({super.key});

  @override
  State<TeacherRegisterPage> createState() => _TeacherRegisterPageState();
}

class _TeacherRegisterPageState extends State<TeacherRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _schoolCode = TextEditingController();
  Timer? _debounce;

  VerifiedSchool? _school; // hasil verifikasi kode sekolah (kartu read-only)
  String? _verifyError;
  bool _verifying = false;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _email, _password, _confirm, _schoolCode]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in [_name, _email, _password, _confirm, _schoolCode]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _codeMatchesVerified =>
      _school != null && _school!.schoolCode == _schoolCode.text;

  bool get _formReady =>
      Validators.name(_name.text) == null &&
      Validators.email(_email.text) == null &&
      Validators.newPassword(_password.text) == null &&
      Validators.confirmPassword(_confirm.text, _password.text) == null &&
      _codeMatchesVerified;

  /// Minggu 9: popup sukses pendaftaran pendidik + imbauan masuk.
  Future<void> _showRegisteredSuccess() {
    final p = context.palette;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: p.surface,
        icon: Container(
          width: 64,
          height: 64,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: p.successContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.celebration_rounded, size: 30, color: p.success),
        ),
        title: Text(
          'Pendaftaran Berhasil! 🎉',
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        content: Text(
          'Akun pengajarmu sudah dibuat untuk ${_school?.name ?? 'sekolahmu'}.\n\nSilakan masuk (login) menggunakan email dan kata sandi yang baru saja kamu buat.',
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Masuk Sekarang',
              style: AppTypography.label.copyWith(color: p.primary),
            ),
          ),
        ],
      ),
    );
  }

  /// Kode sekolah diketik: kartu lama hangus bila teks berubah, lalu
  /// verifikasi dijalankan dengan debounce (400 ms) bila cukup panjang.
  void _onSchoolCodeChanged(String value) {
    setState(() {
      if (_school != null) _school = null;
    });
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _verifySchoolCode);
  }

  Future<void> _verifySchoolCode() async {
    final code = _schoolCode.text;
    if (code.trim().length < 6) return; // masih mengetik — jangan galat dini
    setState(() => _verifying = true);
    try {
      final school = await context.read<AuthRepository>().verifySchool(
        schoolCode: code,
      );
      if (!mounted || code != _schoolCode.text) {
        return; // teks berganti saat verifikasi
      }
      setState(() {
        _school = school;
        _verifyError = null;
      });
    } on AuthFailure catch (e) {
      if (!mounted) return;
      setState(() {
        _school = null;
        _verifyError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _school = null;
        _verifyError = const AuthFailure(AuthFailureType.network).message;
      });
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_codeMatchesVerified) {
      setState(() {
        _error =
            'Verifikasi sekolah dulu — ketik kode resmi lalu tunggu kartu hijau muncul.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      await context.read<AuthCubit>().registerTeacher(
        name: _name.text,
        email: email,
        password: _password.text,
        schoolCode: _schoolCode.text,
      );
      if (!mounted) return;
      // Popup sukses dulu, lalu kembali ke Login dengan email terisi.
      await _showRegisteredSuccess();
      if (!mounted) return;
      context.go(
        Uri(
          path: AppRoutes.login,
          queryParameters: {'registered': '1', 'email': email},
        ).toString(),
      );
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.register),
        ),
        title: const Text('Registrasi Akun Pendidik'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.sm,
            AppSpacing.screen,
            AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: AppTagBanner(label: 'Kemitraan Instansi'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'Pilih Peran Akunmu',
                      style: AppTypography.titleL.copyWith(
                        color: p.text,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Sesuaikan pengalaman belajar atau manajemen lab komputer sekolahmu.',
                      style: AppTypography.bodyL.copyWith(color: p.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _RoleSwitcher(isTeacher: true),
                    const SizedBox(height: AppSpacing.xl),
                    _SectionHeader(
                      icon: Icons.verified_outlined,
                      title: 'Verifikasi Sekolah & Lab',
                      trailing: Text.rich(
                        TextSpan(
                          children: [
                            WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _codeMatchesVerified
                                      ? p.success
                                      : p.textMuted,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            const WidgetSpan(child: SizedBox(width: 6)),
                            TextSpan(
                              text: _codeMatchesVerified
                                  ? 'Terkoneksi'
                                  : 'Menunggu kode',
                            ),
                          ],
                        ),
                        style: AppTypography.caption.copyWith(
                          color: p.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppTextField(
                      label: 'Kode Registrasi Sekolah / Lab',
                      hintAside: 'Dari dinas/sekolah',
                      controller: _schoolCode,
                      hint: 'Contoh: SWADHIPA2-NTR',
                      prefixIcon: Icons.apartment_rounded,
                      textInputAction: TextInputAction.next,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      onChanged: _onSchoolCodeChanged,
                      validator: (v) => _codeMatchesVerified
                          ? null
                          : 'Ketik kode sekolah resmi hingga kartu hijau muncul.',
                      suffixWidget: _verifying
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Guru wajib memasukkan kode sekolah resmi agar terafiliasi dengan laboratorium sekolah.',
                      style: AppTypography.bodyM.copyWith(color: p.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_verifyError != null) ...[
                      FormBanner(message: _verifyError!),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _codeMatchesVerified
                          ? VerifiedSchoolCard(
                              school: _school!,
                              key: const ValueKey('school-card'),
                            )
                          : const SizedBox.shrink(
                              key: ValueKey('school-empty'),
                            ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    _SectionHeader(
                      icon: Icons.badge_rounded,
                      title: 'Data Pendidik Terdaftar',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Lengkapi identitas pendidik untuk verifikasi sertifikat lab.',
                      style: AppTypography.bodyM.copyWith(color: p.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (_error != null) ...[
                      FormBanner(message: _error!),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    AppTextField(
                      label: 'Nama Lengkap & Gelar',
                      hintAside: 'Contoh: Budi Santoso, S.Kom',
                      controller: _name,
                      hint: 'Budi Santoso, S.Kom',
                      prefixIcon: Icons.person_outline_rounded,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: Validators.name,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Email Pendidik / Instansi',
                      hintAside: 'Email kantor',
                      controller: _email,
                      hint: 'budi.guru@smk.belajar.id',
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newUsername],
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Kata Sandi',
                      controller: _password,
                      hint: 'Kombinasi sandi kuat',
                      obscure: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: Validators.newPassword,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Minggu 9: konfirmasi sandi wajib sama persis.
                    AppTextField(
                      label: 'Konfirmasi Kata Sandi',
                      hintAside: 'Sama persis',
                      controller: _confirm,
                      hint: 'Ketik ulang kata sandimu',
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (v) =>
                          Validators.confirmPassword(v, _password.text),
                      onSubmitted: (_) => _formReady ? _submit() : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PasswordChecklist(password: _password.text),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'Lanjutkan Pendaftaran Akun',
                      trailingIcon: Icons.arrow_forward_rounded,
                      loading: _loading,
                      onPressed: _formReady ? _submit : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sudah punya akun?',
                          style: AppTypography.bodyL.copyWith(
                            color: p.textMuted,
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            minimumSize: const Size(
                              AppSizes.minTouch,
                              AppSizes.minTouch,
                            ),
                          ),
                          onPressed: () => context.go(AppRoutes.login),
                          child: Text(
                            'Masuk',
                            style: AppTypography.label.copyWith(
                              color: p.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kartu pilihan peran dua arah (Stitch: segmented control membesar).
/// PENTING: IntrinsicHeight wajib — Row.stretch di dalam scroll (Column
/// ber-tinggi-tak-terbatas) memaksa constraint h=Infinity → crash layout
/// (penyebab whitescreen /register-teacher).
class _RoleSwitcher extends StatelessWidget {
  const _RoleSwitcher({required this.isTeacher});

  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _RoleCard(
              icon: Icons.school_outlined,
              chip: 'Belajar Mandiri',
              title: 'Siswa Belajar',
              description: 'Akses modul koding praktis & AI tutor 24/7',
              selected: !isTeacher,
              onTap: () {
                SoundService.playButtonClick();
                context.go(AppRoutes.register);
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _RoleCard(
              icon: Icons.cast_for_education_rounded,
              chip: 'Akses Pendidik',
              title: 'Guru / Instruktur',
              description: 'Kelola lab kelas, kurikulum & pantau siswa',
              selected: isTeacher,
              onTap: () => SoundService.playButtonClick(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.chip,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String chip;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected
            ? p.primaryContainer.withValues(alpha: 0.55)
            : p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(
          color: selected ? p.primary : p.outline,
          width: selected ? 1.4 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: AppRadius.cardBorder,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: selected ? p.primary : p.surfaceAlt,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: selected ? Colors.white : p.textMuted,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  if (selected)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: p.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                height: AppSizes.tagHeight,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? p.primary : p.surfaceAlt,
                  borderRadius: AppRadius.pillBorder,
                ),
                child: Text(
                  chip,
                  style: AppTypography.caption.copyWith(
                    color: selected ? Colors.white : p.textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: AppTypography.label.copyWith(
                  color: p.text,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: AppTypography.caption.copyWith(
                  color: p.textMuted,
                  fontSize: 12.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Baris judul seksi berikon (patokan: layar Stitch v3).
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Row(
      children: [
        Icon(icon, size: 20, color: p.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTypography.label.copyWith(color: p.text, fontSize: 17),
          ),
        ),
        ?trailing,
      ],
    );
  }
}
