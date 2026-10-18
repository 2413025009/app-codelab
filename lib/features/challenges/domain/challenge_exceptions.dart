// FILE: lib/features/challenges/domain/challenge_exceptions.dart
// TUGAS: menyatakan penolakan server yang wajib terlihat di UI (bukan ditelan mock).
// FUNGSI YANG DIKELOLA: ApiChallengeException (statusCode, code stabil, message,
// retryAfterSeconds) misalnya 403 LOCKED_CHALLENGE dan 429 COOLDOWN_ACTIVE.
// WAJIB DIUBAH BILA: backend menambah kode stabil baru atau bawaan retry.
//
/// Exceptions yang harus DITAMPILKAN ke UI, bukan ditelan fallback mock.
///
/// Sesuai audit P0-2 (server enforce lock) & P1-12 (cooldown server):
/// bila API menjawab dengan status error, UI wajib menampilkan alasan asli —
/// menjalankan fallback mock di jalur ini berbahaya (kartu pencapaian palsu).
class ApiChallengeException implements Exception {
  const ApiChallengeException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.retryAfterSeconds,
  });

  final int statusCode;

  /// Kode stabil dari backend: LOCKED_CHALLENGE, COOLDOWN_ACTIVE,
  /// RATE_LIMITED, VALIDATION_FAILED, INTERNAL_ERROR, dst.
  final String code;
  final String message;

  /// Isi dari `details.retry_after_seconds` untuk 429 (BRIEF_UNIT_TEST §8).
  final int? retryAfterSeconds;

  /// Kapan exception ini bermakna masuk akal untuk dicoba ulang?
  bool get isCooldown => code == 'COOLDOWN_ACTIVE';

  factory ApiChallengeException.fromResponse(int statusCode, dynamic body) {
    String code = 'INTERNAL_ERROR';
    String message = 'Ada kendala di sisi server.';
    int? retryAfter;

    if (body is Map<String, dynamic>) {
      final err = body['error'];
      if (err is Map<String, dynamic>) {
        code = err['code'] as String? ?? code;
        message = err['message'] as String? ?? message;
        final details = err['details'];
        if (details is Map<String, dynamic>) {
          final raw = details['retry_after_seconds'];
          if (raw is int) retryAfter = raw;
          if (raw is String) retryAfter = int.tryParse(raw);
        }
      }
    }

    return ApiChallengeException(
      statusCode: statusCode,
      code: code,
      message: message,
      retryAfterSeconds: retryAfter,
    );
  }

  @override
  String toString() => 'ApiChallengeException($statusCode, $code, $message)';
}
