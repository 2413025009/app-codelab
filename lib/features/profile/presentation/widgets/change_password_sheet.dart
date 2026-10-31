// FILE: lib/features/profile/presentation/widgets/change_password_sheet.dart
//
// TUGAS: sheet "Ubah Kata Sandi" bersama untuk akun siswa maupun pengajar.
// Isi sandi lama, sandi baru, dan konfirmasi dengan checklist keamanan yang
// sama seperti layar registrasi. Endpoint: POST /auth/change-password (butuh
// sesi aktif + sandi lama yang cocok — galat server ditampilkan jujur).
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_snack.dart';
import '../../../auth/domain/auth_repository.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/widgets/auth_widgets.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
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
      // Simpan konteks Navigator dulu: sheet ditutup sebelum snack tampil.
      final navigator = Navigator.of(context);
      navigator.pop();
      showAppSnack(navigator.context, 'Kata sandi berhasil diubah!');
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
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Isi kata sandi lama dulu.' : null,
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
