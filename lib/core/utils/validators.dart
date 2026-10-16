/// Form validators shared by Login and Register (PRD §5.1).
abstract final class Validators {
  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? required(String? v, String message) =>
      (v == null || v.trim().isEmpty) ? message : null;

  static String? name(String? v) => required(v, 'Isi nama lengkapmu dulu.');

  static String? email(String? v) {
    if (v == null || v.trim().isEmpty) return 'Isi email kamu dulu.';
    if (!_email.hasMatch(v.trim())) return 'Format email belum benar. Contoh: nama@smk.belajar.id';
    return null;
  }

  static String? loginPassword(String? v) => required(v, 'Isi kata sandi kamu dulu.');

  static bool hasMinLength(String v) => v.length >= 8;
  static bool hasDigitOrSymbol(String v) => RegExp(r'[0-9\W_]').hasMatch(v);

  static String? newPassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return 'Buat kata sandi dulu.';
    if (!hasMinLength(s) || !hasDigitOrSymbol(s)) {
      return 'Minimal 8 karakter dan ada angka atau simbol.';
    }
    return null;
  }
}
