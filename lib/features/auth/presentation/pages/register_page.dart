import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/auth_repository.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _email, _password]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _formReady =>
      Validators.name(_name.text) == null &&
      Validators.email(_email.text) == null &&
      Validators.newPassword(_password.text) == null;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      await context.read<AuthCubit>().register(name: _name.text, email: email, password: _password.text);
      if (!mounted) return;
      // Open question in PRD §9: after register we return to Login with the email filled in.
      context.go(Uri(path: AppRoutes.login, queryParameters: {'registered': '1', 'email': email}).toString());
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
          onPressed: () => context.go(AppRoutes.login),
        ),
        title: const Text('Daftar Akun'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppTagBanner(label: 'Platform Belajar Coding RPL'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('Yuk, buat akunmu', style: AppTypography.titleL.copyWith(color: p.text, fontSize: 28)),
                    const SizedBox(height: AppSpacing.sm),
                    Text('Untuk siswa SMK/SMA jurusan RPL.', style: AppTypography.bodyL.copyWith(color: p.textMuted)),
                    const SizedBox(height: AppSpacing.xl),
                    if (_error != null) ...[
                      FormBanner(message: _error!),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    AppTextField(
                      label: 'Nama Lengkap',
                      hintAside: 'Sesuai absen kelas',
                      controller: _name,
                      hint: 'Muhammad Farhan',
                      prefixIcon: Icons.badge_outlined,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: Validators.name,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: 'Email Pelajar / Pribadi',
                      hintAside: '.belajar.id',
                      controller: _email,
                      hint: 'farhan@smk.belajar.id',
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
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: Validators.newPassword,
                      onSubmitted: (_) => _formReady ? _submit() : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _PasswordChecklist(password: _password.text),
                    const SizedBox(height: AppSpacing.lg),
                    const _CommunityNote(),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: 'Buat Akun',
                      trailingIcon: Icons.arrow_forward_rounded,
                      loading: _loading,
                      onPressed: _formReady ? _submit : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun?', style: AppTypography.bodyL.copyWith(color: p.textMuted)),
                        TextButton(
                          style: TextButton.styleFrom(minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch)),
                          onPressed: () => context.go(AppRoutes.login),
                          child: Text('Masuk', style: AppTypography.label.copyWith(color: p.primary, fontSize: 16)),
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

class AppTagBanner extends StatelessWidget {
  const AppTagBanner({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      height: AppSizes.tagHeight + 4,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: p.primaryContainer, borderRadius: AppRadius.pillBorder),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined, size: 16, color: p.primary),
          const SizedBox(width: 8),
          Text(label, style: AppTypography.caption.copyWith(color: p.primary, fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}

class _PasswordChecklist extends StatelessWidget {
  const _PasswordChecklist({required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final okLength = Validators.hasMinLength(password);
    final okChar = Validators.hasDigitOrSymbol(password);
    final status = password.isEmpty
        ? 'Belum diisi'
        : (okLength && okChar ? 'Sangat Bagus!' : 'Perlu ditingkatkan');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'KEAMANAN SANDI',
                  style: AppTypography.caption.copyWith(color: p.textMuted, fontWeight: FontWeight.w700, letterSpacing: 0.6),
                ),
              ),
              Text(status, style: AppTypography.caption.copyWith(color: p.textMuted, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _CheckRow(ok: okLength, label: 'Minimal 8 karakter'),
          const SizedBox(height: AppSpacing.sm),
          _CheckRow(ok: okChar, label: 'Ada angka atau simbol'),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.ok, required this.label});

  final bool ok;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      label: '$label, ${ok ? 'terpenuhi' : 'belum terpenuhi'}',
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: ok ? p.success : p.surfaceAlt,
              shape: BoxShape.circle,
              border: ok ? null : Border.all(color: p.textMuted, width: 1.5),
            ),
            child: ok ? const Icon(Icons.check_rounded, size: 16, color: Colors.white) : null,
          ),
          const SizedBox(width: 12),
          Text(label, style: AppTypography.bodyL.copyWith(color: ok ? p.text : p.textMuted, fontSize: 15)),
        ],
      ),
    );
  }
}

class _CommunityNote extends StatelessWidget {
  const _CommunityNote();

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: p.primaryContainer.withValues(alpha: 0.6), borderRadius: AppRadius.cardBorder),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: p.primaryContainer, shape: BoxShape.circle),
            child: Icon(Icons.code_rounded, color: p.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppTypography.bodyM.copyWith(color: p.textMuted),
                children: [
                  const TextSpan(text: 'Gabung bersama '),
                  TextSpan(text: '12.400+', style: TextStyle(fontWeight: FontWeight.w700, color: p.text)),
                  const TextSpan(text: ' rekan RPL yang mulai belajar logika algoritma, Git, dan web dev hari ini.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
