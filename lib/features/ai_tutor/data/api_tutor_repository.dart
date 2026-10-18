// FILE: lib/features/ai_tutor/data/api_tutor_repository.dart
// TUGAS: petunjuk AI nyata dari gateway (POST /tutor/hint + GET /tutor/quota
// read-only; kuota 5x/hari selalu dihitung server sesuai PRD).
// FUNGSI YANG DIKELOLA: fetchHint per level (Konsep/Logika/Sintaks),
// getQuota (baca sisa kuota saat sheet pertama dibuka), sinkron kuota via
// TutorQuota.syncFromServer; error jaringan dibiar naik agar sheet
// menampilkan mode offline memakai TutorScript (tanpa mock terselubung).
// KOLOM DB: ai_quotas (bacaan sisa kuota lewat respons server).
// WAJIB DIUBAH BILA: kontrak /tutor/hint berubah (payload atau bentuk respons).
import 'package:dio/dio.dart';

import '../../challenges/domain/challenge_exceptions.dart';
import '../../../core/network/api_client.dart';
import '../domain/tutor_models.dart';
import '../domain/tutor_repository.dart';

/// Real AI Tutor against the Go gateway (POST /api/v1/tutor/hint).
/// Quota 5x/hari tetap dihitung server-side; respons membawa sisa kuota.
class ApiTutorRepository implements TutorRepository {
  ApiTutorRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  static const _labels = ['Konsep', 'Logika', 'Sintaks'];

  @override
  Future<TutorQuotaSnapshot> getQuota() async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>('/tutor/quota');
      final data = res.data ?? const {};
      final used = data['used'] as int? ?? 0;
      final limit = data['limit'] as int? ?? 5;
      return TutorQuotaSnapshot(
        used: used,
        limit: limit,
        left: data['left'] as int? ?? (limit - used),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiChallengeException.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      }
      rethrow; // offline → pemanggil memakai nilai default
    }
  }

  @override
  Future<TutorHintResult> fetchHint({
    required String challengeId,
    required String studentCode,
    required int hintLevel,
    String? errorMessage,
  }) async {
    try {
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/tutor/hint',
        data: {
          'challenge_id': challengeId,
          'student_code': studentCode,
          'error_message': errorMessage ?? '',
          'hint_level': hintLevel,
        },
      );
      final data = res.data ?? const {};
      final question = data['guided_question'] as String? ?? '';
      final nextStep = data['recommended_next_step'] as String? ?? '';
      final quotaUsed = data['quota_used'] as int? ?? 0;
      final quotaLimit = data['quota_limit'] as int? ?? 5;
      final quotaLeft = data['quota_left'] as int? ?? (quotaLimit - quotaUsed);

      final label = _labels[hintLevel.clamp(1, 3) - 1];

      return TutorHintResult(
        hint: TutorHint(
          tabLabel: 'Hint $hintLevel: $label',
          question: question.isNotEmpty ? question : 'Ayo pikirkan langkahmu berikutnya.',
          steps: [if (nextStep.isNotEmpty) nextStep],
        ),
        quotaUsed: quotaUsed,
        quotaLimit: quotaLimit,
        quotaLeft: quotaLeft.clamp(0, quotaLimit),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        // Kontrak error dari server (QUOTA_EXCEEDED, TUTOR_UNAVAILABLE, dst)
        // dibawa ke sheet sebagai exception bertipe.
        throw ApiChallengeException.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      }
      // Offline → sheet memakai script statis lokal sebagai fallback demo.
      rethrow;
    }
  }
}
