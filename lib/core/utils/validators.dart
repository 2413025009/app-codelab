import '../../l10n/app_localizations.dart';

/// Form validators shared by Login and Register (PRD §5.1).
/// Pesan galat mengikuti bahasa aktif; teks dari server tidak diterjemahkan.
abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  static String? name(String? v, AppLocalizations l10n) =>
      required(v, l10n.validNameRequired);

  static String? email(String? v, AppLocalizations l10n) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return l10n.validEmailRequired;
    if (!_email.hasMatch(value)) {
      return l10n.validEmailFormat;
    }
    return null;
  }

  /// Email akun CodeLab wajib memakai domain sekolah @smk.belajar.id.
  static const schoolEmailDomain = '@smk.belajar.id';

  static String? schoolEmail(String? v, AppLocalizations l10n) {
    final base = email(v, l10n);
    if (base != null) return base;
    final value = v!.trim().toLowerCase();
    if (!value.endsWith(schoolEmailDomain)) {
      return l10n.validSchoolEmailDomain(schoolEmailDomain);
    }
    return null;
  }

  static String? loginPassword(String? v, AppLocalizations l10n) =>
      required(v, l10n.validPasswordRequired);

  static bool hasMinLength(String v) => v.length >= 8;
  static bool hasDigitOrSymbol(String v) => RegExp(r'[0-9\W_]').hasMatch(v);

  static String? newPassword(String? v, AppLocalizations l10n) {
    final s = v ?? '';
    if (s.isEmpty) return l10n.validNewPasswordRequired;
    if (!hasMinLength(s) || !hasDigitOrSymbol(s)) {
      return l10n.validPasswordPolicy;
    }
    return null;
  }

  /// Minggu 9: kolom konfirmasi sandi pada formulir registrasi (siswa & guru).
  static String? confirmPassword(
    String? v,
    String password,
    AppLocalizations l10n,
  ) {
    if (v == null || v.isEmpty) {
      return l10n.validConfirmRequired;
    }
    if (v != password) return l10n.validPasswordMismatch;
    return null;
  }
}
