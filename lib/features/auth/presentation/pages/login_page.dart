import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/network/session_notice.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../l10n/l10n_ext.dart';
import '../../../notifications/notification_events.dart';
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

  /// Minggu 13: pesan "sesi berakhir" dari server (akun dipakai di perangkat
  /// lain, logout, atau sandi berubah). Ditampilkan SEKALI saat layar masuk
  /// terbuka, lalu dibersihkan agar tidak berulang.
  String? _sessionMessage;

  @override
  void initState() {
    super.initState();
    SessionNotice.message.addListener(_syncSessionMessage);
    _syncSessionMessage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Minggu 13: teruskan bahasa aktif ke AuthCubit agar notifikasi "sesi
    // berakhir" memakai bahasa yang sama dengan antarmuka.
    context.read<AuthCubit>().setLocalizations(AppLocalizations.of(context));
  }

  void _syncSessionMessage() {
    final msg = SessionNotice.message.value;
    if (msg == null) return;
    if (!mounted) return;
    setState(() => _sessionMessage = msg);
    SessionNotice.clear();
  }

  @override
  void dispose() {
    SessionNotice.message.removeListener(_syncSessionMessage);
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
      // Minggu 13 (Notifikasi 3): setelah masuk, pasang pengingat belajar
      // harian + kabar kuota AI Tutor kembali penuh. Kegagalan diabaikan.
      if (mounted) {
        unawaited(NotificationEvents.scheduleDailyReminder(context));
      }
      // Router redirect moves us to the dashboard once authenticated.
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
                    l10n.loginWelcomeTitle,
                    textAlign: TextAlign.center,
                    style: AppTypography.display.copyWith(color: p.text),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.loginWelcomeSubtitle,
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
                          // Sesi berakhir (dipakai di perangkat lain / logout /
                          // sandi berubah) — tampil sebelum pesan lain.
                          if (_sessionMessage != null && _error == null) ...[
                            FormBanner(message: _sessionMessage!),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          if (widget.justRegistered && _error == null) ...[
                            FormBanner(
                              isError: false,
                              message: l10n.loginJustRegisteredBanner,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          if (_error != null) ...[
                            FormBanner(message: _error!),
                            const SizedBox(height: AppSpacing.lg),
                          ],
                          AppTextField(
                            label: l10n.authEmailLabel,
                            controller: _email,
                            hint: 'nama@smk.belajar.id',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.email],
                            validator: (v) => Validators.email(v, l10n),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          AppTextField(
                            label: l10n.authPasswordLabel,
                            controller: _password,
                            hint: l10n.authPasswordHint,
                            obscure: true,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            validator: (v) =>
                                Validators.loginPassword(v, l10n),
                            onSubmitted: (_) => _submit(),
                          ),
                          // "Lupa kata sandi?" stays hidden until a reset endpoint exists (DESIGN.md §5.1).
                          const SizedBox(height: AppSpacing.xl),
                          AppButton(label: l10n.loginSubmit, loading: _loading, onPressed: _submit),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.loginNoAccount, style: AppTypography.bodyL.copyWith(color: p.textMuted)),
                      TextButton(
                        style: TextButton.styleFrom(minimumSize: const Size(AppSizes.minTouch, AppSizes.minTouch)),
                        onPressed: () => context.go(AppRoutes.register),
                        child: Text(l10n.authRegisterLink, style: AppTypography.label.copyWith(color: p.primary, fontSize: 16)),
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
