// FILE: lib/core/utils/phone.dart
//
// TUGAS: satu aturan nomor telepon Indonesia di seluruh aplikasi.
// Nomor disimpan tanpa kode negara/awalan lokal: "0812...", "62812...", dan
// "+62 812..." semuanya menjadi "812...". Tampilan menambahkan "+62" kembali.

/// Ambil digit saja, buang awalan 62 atau 0.
String normalizePhone(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.startsWith('62')) return digits.substring(2);
  if (digits.startsWith('0')) return digits.substring(1);
  return digits;
}

/// Teks yang ditampilkan di kolom isian: tanpa "+62", mis. "81234567890".
String phoneInputValue(String raw) => normalizePhone(raw);

/// Teks siap baca: "+62 812-3456-7890" (kelompok 3-4-4-…).
String formatPhoneDisplay(String raw) {
  final digits = normalizePhone(raw);
  if (digits.isEmpty) return '';
  final groups = <String>[];
  var index = 0;
  while (index < digits.length) {
    final size = index == 0 ? 3 : 4;
    final end = (index + size).clamp(0, digits.length);
    groups.add(digits.substring(index, end));
    index = end;
  }
  return '+62 ${groups.join('-')}';
}
