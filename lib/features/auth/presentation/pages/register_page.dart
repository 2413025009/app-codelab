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
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';
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
  final _confirm = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _email, _password, _confirm]) {
      c.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _formReady {
    final l10n = AppLocalizations.of(context);
    return Validators.name(_name.text, l10n) == null &&
        Validators.email(_email.text, l10n) == null &&
        Validators.newPassword(_password.text, l10n) == null &&
        Validators.confirmPassword(_confirm.text, _password.text, l10n) ==
            null;
  }

  /// Minggu 9: popup konfirmasi bahwa pendaftaran sukses + imbauan login.
  Future<void> _showRegisteredSuccess() {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
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
          l10n.registerSuccessTitle,
          style: AppTypography.titleM.copyWith(color: p.text),
        ),
        content: Text(
          l10n.registerSuccessBody,
          style: AppTypography.bodyM.copyWith(color: p.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              l10n.loginSubmit,
              style: AppTypography.label.copyWith(color: p.primary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _email.text.trim();
      await context.read<AuthCubit>().register(
        name: _name.text,
        email: email,
        password: _password.text,
      );
      if (!mounted) return;
      // Minggu 9: popup sukses dulu, lalu ke Login dengan email terisi (PRD §9).
      await _showRegisteredSuccess();
      if (!mounted) return;
      context.go(
        Uri(
          path: AppRoutes.login,
          queryParameters: {'registered': '1', 'email': email},
        ).toString(),
      );
    } on AuthFailure catch (e) {
      if (mounted) {
        setState(() => _error = e.messageL10n(AppLocalizations.of(context)));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.authBackTooltip,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go(AppRoutes.login),
        ),
        title: Text(l10n.registerTitle),
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppTagBanner(label: l10n.registerTagBanner),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.registerHeading,
                      style: AppTypography.titleL.copyWith(
                        color: p.text,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.registerSubheading,
                      style: AppTypography.bodyL.copyWith(color: p.textMuted),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (_error != null) ...[
                      FormBanner(message: _error!),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                    AppTextField(
                      label: l10n.registerNameLabel,
                      hintAside: l10n.registerNameHintAside,
                      controller: _name,
                      hint: 'Muhammad Farhan',
                      prefixIcon: Icons.badge_outlined,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.name],
                      validator: (v) => Validators.name(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.registerEmailLabel,
                      hintAside: l10n.registerEmailHintAside,
                      controller: _email,
                      hint: 'farhan@smk.belajar.id',
                      prefixIcon: Icons.alternate_email_rounded,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newUsername],
                      validator: (v) => Validators.email(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField(
                      label: l10n.authPasswordLabel,
                      controller: _password,
                      hint: l10n.authPasswordStrengthHint,
                      obscure: true,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (v) => Validators.newPassword(v, l10n),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    // Minggu 9: konfirmasi sandi wajib sama persis.
                    AppTextField(
                      label: l10n.registerConfirmLabel,
                      hintAside: l10n.authSameExactlyHintAside,
                      controller: _confirm,
                      hint: l10n.authRetypePasswordHint,
                      obscure: true,
                      textInputAction: TextInputAction.done,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (v) =>
                          Validators.confirmPassword(v, _password.text, l10n),
                      onSubmitted: (_) => _formReady ? _submit() : null,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PasswordChecklist(password: _password.text),
                    const SizedBox(height: AppSpacing.lg),
                    const _CommunityNote(),
                    const SizedBox(height: AppSpacing.xl),
                    AppButton(
                      label: l10n.registerSubmit,
                      trailingIcon: Icons.arrow_forward_rounded,
                      loading: _loading,
                      onPressed: _formReady ? _submit : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.authAlreadyHaveAccount,
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
                            l10n.authLoginLink,
                            style: AppTypography.label.copyWith(
                              color: p.primary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    // Minggu 9: pendaftaran khusus pendidik berpagar kode sekolah.
                    Align(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          minimumSize: const Size(
                            AppSizes.minTouch,
                            AppSizes.minTouch,
                          ),
                        ),
                        onPressed: () => context.go(AppRoutes.registerTeacher),
                        child: Text(
                          l10n.registerTeacherLink,
                          style: AppTypography.label.copyWith(
                            color: p.primary,
                            fontSize: 15,
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
      decoration: BoxDecoration(
        color: p.primaryContainer,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_outlined, size: 16, color: p.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: p.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
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
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: p.primaryContainer.withValues(alpha: 0.6),
        borderRadius: AppRadius.cardBorder,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: p.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.code_rounded, color: p.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: AppTypography.bodyM.copyWith(color: p.textMuted),
                children: [
                  TextSpan(text: '${l10n.registerCommunityPrefix} '),
                  TextSpan(
                    text: '12.400+',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: p.text,
                    ),
                  ),
                  TextSpan(
                    text: ' ${l10n.registerCommunitySuffix}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
