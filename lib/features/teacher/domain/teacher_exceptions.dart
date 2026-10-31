// FILE: lib/features/teacher/domain/teacher_exceptions.dart
//
// TUGAS: penolakan server fitur instruktur & studio materi guru
// yang wajib terlihat jujur di antarmuka pengguna.

/// Throws yang membawa pesan siap-tampil dari server.
class ApiTeacherException implements Exception {
  const ApiTeacherException({
    required this.statusCode,
    required this.code,
    required this.message,
  });

  final int statusCode;
  final String code;
  final String message;

  factory ApiTeacherException.fromResponse(int statusCode, dynamic body) {
    String code = 'INTERNAL_ERROR';
    String message = 'Ada kendala pada server.';

    if (body is Map<String, dynamic>) {
      final err = body['error'];
      if (err is Map<String, dynamic>) {
        code = err['code'] as String? ?? code;
        message = err['message'] as String? ?? message;
      }
    }

    return ApiTeacherException(
      statusCode: statusCode,
      code: code,
      message: message,
    );
  }

  @override
  String toString() => 'ApiTeacherException($statusCode, $code, $message)';
}
