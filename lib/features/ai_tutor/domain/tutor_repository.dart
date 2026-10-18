// FILE: lib/features/ai_tutor/domain/tutor_repository.dart
// TUGAS: kontrak layanan AI Tutor ke gateway (POST /tutor/hint + GET
// /tutor/quota read-only); kuota 5x/hari tetap dihitung server (PRD).
// FUNGSI YANG DIKELOLA: fetchHint (level 1..3) dan getQuota (tanpa konsumsi).
// WAJIB DIUBAH BILA: kontrak endpoint tutor berubah.
import 'tutor_models.dart';

/// Kontrak layanan AI Tutor (P0-6): endpoint nyata POST /tutor/hint.
/// Respons membawa petunjuk + status kuota harian server (5x/hari).
abstract interface class TutorRepository {
  /// Ambil petunjuk level [hintLevel] (1=Konsep, 2=Logika, 3=Sintaks).
  /// Melempar [ApiChallengeException] untuk error kontrak API; kegagalan
  /// jaringan dilempar apa adanya — pemanggil menentukan fallback offline.
  Future<TutorHintResult> fetchHint({
    required String challengeId,
    required String studentCode,
    required int hintLevel,
    String? errorMessage,
  });

  /// Baca kuota hari ini (GET /tutor/quota) TANPA menarik slot — dipanggil
  /// ketika sheet/halaman pertama kali membuka tutor agar badge kuota
  /// memang angka server. Error jaringan dilempar apa adanya.
  Future<TutorQuotaSnapshot> getQuota();
}
