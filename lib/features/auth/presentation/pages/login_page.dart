import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/auth_repository.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.prefillEmail, this.justRegistered = false});

  final String? prefillEmail;
  final bool justRegistered;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late final _email = TextEditingController(text: widget.prefillEmail);
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await context.read<AuthCubit>().login(email: _email.text, password: _password.text);
      // Router redirect moves us to the dashboard once authenticated.
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen, vertical: AppSpacing.xl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const WelcomeIllustration(),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    'Selamat datang kembali',
                    textAlign: TextAlign.center,
                    style: AppTypography.display.copyWith(color: p.text),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Lanjutkan belajar koding dari mana kamu berhenti.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyL.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.justRegistered && _error == null) ...[
                            const FormBanner(
                              isError: false,
                              message: 'Akunmu sudah dibuat. Silakan masuk untuk mulai belajar.',
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          if (_error != null) ...[
                            FormBanner(message: _error!),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          AppTextField(
                            label: 'Email',
                            controller: _email,
                            hint: 'nama@smk.belajar.id',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            validator: Validators.email,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            label: 'Kata Sandi',
                            controller: _password,
                            hint: 'Masukkan kata sandi',
                            obscure: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            validator: Validators.loginPassword,
                            onSubmitted: (_) => _submit(),
                          ),
                          // "Lupa kata sandi?" stays hidden until a reset endpoint exists (DESIGN.md §5.1).
                          const SizedBox(height: AppSpacing.xl),
                          AppButton(label: 'Masuk Sekarang', loading: _loading, onPressed: _submit),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Belum punya akun?', style: AppTypography.bodyL.copyWith(color: p.textMuted)),
                      TextButton(
                        style: TextButton.styleFrom(minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch)),
                        onPressed: () => context.go(AppRoutes.register),
                        child: Text('Daftar', style: AppTypography.label.copyWith(color: p.primary, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
