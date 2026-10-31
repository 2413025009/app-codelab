// FILE: lib/features/class/domain/class_exceptions.dart
// TUGAS: penolakan server fitur kelas yang WAJIB terlihat jujur di UI
// (tidak ditelan data tiruan), mengikuti pola ApiChallengeException.
//
// KODE STABIL DARI BACKEND (minggu 10):
//   - CLASS_CODE_NOT_FOUND  (422) kode rombel salah / kelas sudah tutup
//   - ALREADY_MEMBER        (409) siswa sudah ada di kelas ini
//   - ALREADY_IN_A_CLASS    (409) siswa masih tergabung di kelas lain
//   - FORBIDDEN             (403) bukan akun siswa / bukan anggota kelas
//   - NOT_A_MEMBER          (404) siswa belum tergabung di kelas itu

/// Throws yang membawa pesan siap-tampil bawaan server (bahasa Indonesia).
class ApiClassException implements Exception {
  const ApiClassException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  final int statusCode;

  /// Kode stabil dari backend (lihat daftar di kepala berkas).
  final String code;
  final String message;

  factory ApiClassException.fromResponse(int statusCode, dynamic body) {
    String code = 'INTERNAL_ERROR';
    String message = 'Ada kendala di sisi server.';

    if (body is Map<String, dynamic>) {
      final err = body['error'];
      if (err is Map<String, dynamic>) {
        code = err['code'] as String? ?? code;
        message = err['message'] as String? ?? message;
      }
    }

    return ApiClassException(
      statusCode: statusCode,
      code: code,
      message: message,
    );
  }

  /// Bila siswa memang sudah menggendong keanggotaan lain (409 konflik).
  bool get isAlreadyInAClass =>
      code == 'ALREADY_MEMBER' || code == 'ALREADY_IN_A_CLASS';

  @override
  String toString() => 'ApiClassException($statusCode, $code, $message)';
}
