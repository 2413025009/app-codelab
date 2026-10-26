// FILE: lib/features/challenges/data/api_challenge_repository.dart
// TUGAS: tantangan nyata dari gateway — daftar, detail, uji kode (run),
// kumpulkan jawaban (submit), dan klaim XP.
// FUNGSI YANG DIKELOLA: metode API lewat ApiClient; error API dan error
// jaringan diteruskan jujur sebagai ApiChallengeException (Week 9: tanpa
// fallback data tiruan, data 100% database).
// KOLOM DB: challenges, test_cases, submissions (bacaan untuk mobile).
// WAJIB DIUBAH BILA: kontrak endpoint tantangan berubah di backend.
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/challenge_exceptions.dart';
import '../domain/challenge_repository.dart';

class ApiChallengeRepository implements ChallengeRepository {
  ApiChallengeRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  /// Error dari API (badResponse) maupun jaringan (offline) = keduanya
  /// diteruskan jujur ke UI — Week 9 tidak ada lagi fallback mock.
  static Never _rethrowApiError(DioException e) {
    throw ApiChallengeException.fromResponse(
      e.response?.statusCode ?? 0,
      e.response?.data,
    );
  }

  static ChallengeLevel _levelFrom(String raw) {
    switch (raw.toLowerCase()) {
      case 'advanced':
      case 'mahir':
        return ChallengeLevel.advanced;
      case 'intermediate':
      case 'menengah':
      case 'menengah lanjut':
        return ChallengeLevel.intermediate;
      default:
        return ChallengeLevel.beginner;
    }
  }

  @override
  Future<ChallengeCatalog> getCatalog({int? userXp}) async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>('/challenges');
      final data = res.data;
      if (data == null) throw Exception('Empty response');

      final groupsData = (data['groups'] as List<dynamic>? ?? []);
      final groups = <ChallengeGroup>[];

      for (final g in groupsData) {
        final gMap = g as Map<String, dynamic>;
        final title = gMap['title'] as String? ?? '';
        final challengesData = (gMap['challenges'] as List<dynamic>? ?? []);
        final challenges = <ChallengeSummary>[];

        for (final c in challengesData) {
          final cMap = c as Map<String, dynamic>;
          final diffStr = (cMap['difficulty'] as String? ?? 'Pemula');
          final level = _levelFrom(diffStr);

          final statusStr = (cMap['status'] as String? ?? 'not_started')
              .toLowerCase();
          final status = statusStr == 'completed'
              ? ChallengeStatus.completed
              : (statusStr == 'in_progress'
                    ? ChallengeStatus.inProgress
                    : ChallengeStatus.notStarted);

          challenges.add(
            ChallengeSummary(
              id: cMap['slug'] as String? ?? (cMap['id'] as String? ?? ''),
              title: cMap['title'] as String? ?? '',
              level: level,
              topicTag: cMap['topic_tag'] as String? ?? '',
              xp: cMap['xp_reward'] as int? ?? 25,
              status: status,
              minXpRequired: cMap['min_xp_required'] as int? ?? 0,
              isLocked: cMap['is_locked'] as bool? ?? false,
              isMiniProject: cMap['is_mini_project'] as bool? ?? false,
              estimatedMinutes: cMap['estimated_minutes'] as int? ?? 15,
              testCount: cMap['test_count'] as int? ?? 3,
            ),
          );
        }

        groups.add(
          ChallengeGroup(
            title: title,
            challenges: challenges,
            isMiniProject: title.toLowerCase().contains('mini-proyek'),
          ),
        );
      }

      return ChallengeCatalog(
        total: data['total'] as int? ?? 0,
        completed: data['completed'] as int? ?? 0,
        xpEarned: data['xp_earned'] as int? ?? 0,
        userXp: data['user_xp'] as int? ?? (userXp ?? 0),
        groups: groups,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return _rethrowApiError(e);
      }
      // Hanya offline sungguhan jatuh ke sini: diteruskan jujur (401/403/5xx
      // tetap jawaban server). Week 9: tanpa fallback mock.
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<ChallengeDetail> getDetail(String id, {int? userXp}) async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/challenges/$id',
      );
      final data = res.data;
      if (data == null) throw Exception('Empty response');

      final rulesData = (data['rules'] as List<dynamic>? ?? []);
      final rules = rulesData.map((r) {
        final rMap = r as Map<String, dynamic>;
        return RuleItem(
          text: rMap['text'] as String? ?? '',
          positive: rMap['positive'] as bool? ?? true,
        );
      }).toList();

      final samplesData = (data['samples'] as List<dynamic>? ?? []);
      final samples = samplesData.map((s) {
        final sMap = s as Map<String, dynamic>;
        return SampleCase(
          label: sMap['label'] as String? ?? '',
          condition: sMap['condition'] as String? ?? '',
          call: sMap['call'] as String? ?? '',
          result: sMap['result'] as String? ?? '',
        );
      }).toList();

      return ChallengeDetail(
        id: data['slug'] as String? ?? (data['id'] as String? ?? id),
        title: data['title'] as String? ?? '',
        // Label tampilan seluruhnya bahasa Indonesia ('Pemula'/'Menengah'/'Mahir')
        // — backend mengirim nilai teknis difficulty (beginner/...).
        levelLabel: _levelFrom(
          data['difficulty'] as String? ?? 'beginner',
        ).label,
        xp: data['xp_reward'] as int? ?? 40,
        minutes: data['estimated_minutes'] as int? ?? 10,
        position: data['position'] as String? ?? 'TANTANGAN',
        instruction: data['instruction'] as String? ?? '',
        rules: rules,
        samples: samples,
        starterCode: data['starter_code'] as String? ?? '',
        minXpRequired: data['min_xp_required'] as int? ?? 0,
        isLocked: data['is_locked'] as bool? ?? false,
        category: data['category'] as String? ?? 'Percabangan & Logika',
        // Status dari server menandai tantangan sudah selesai (submisi lolos).
        status: data['status'] as String? ?? 'not_started',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return _rethrowApiError(e);
      }
      rethrow; // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<RunReport> runTests(String challengeId, String code) async {
    try {
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/challenges/$challengeId/run',
        data: {'code': code},
      );
      final data = res.data;
      if (data == null) throw Exception('Empty response');

      final resultsData = (data['results'] as List<dynamic>? ?? []);
      final results = resultsData.map((r) {
        final rMap = r as Map<String, dynamic>;
        return TestCaseResult(
          title: rMap['title'] as String? ?? '',
          input: rMap['input'] as String? ?? '',
          expected: rMap['expected'] as String? ?? '',
          output: rMap['output'] as String? ?? '',
          passed: rMap['passed'] as bool? ?? false,
          hidden: rMap['hidden'] as bool? ?? false,
        );
      }).toList();

      return RunReport(
        results: results,
        millis: data['millis'] as int? ?? 50,
        // Skor resmi server sudah berbobot (P0-5).
        serverScore: data['score'] as int?,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return _rethrowApiError(e);
      }
      rethrow; // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<SubmissionResult> submitCode(String challengeId, String code) async {
    try {
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/challenges/$challengeId/submit',
        data: {'code': code},
      );
      final data = res.data;
      if (data == null) throw Exception('Empty response');

      final reportData = data['report'] as Map<String, dynamic>? ?? {};
      final resultsData = (reportData['results'] as List<dynamic>? ?? []);
      final results = resultsData.map((r) {
        final rMap = r as Map<String, dynamic>;
        return TestCaseResult(
          title: rMap['title'] as String? ?? '',
          input: rMap['input'] as String? ?? '',
          expected: rMap['expected'] as String? ?? '',
          output: rMap['output'] as String? ?? '',
          passed: rMap['passed'] as bool? ?? false,
          hidden: rMap['hidden'] as bool? ?? false,
        );
      }).toList();

      final report = RunReport(
        results: results,
        millis: reportData['millis'] as int? ?? 50,
        serverScore: reportData['score'] as int?,
      );

      final statusStr = data['status'] as String? ?? 'failed';
      final status = statusStr == 'passed'
          ? SubmissionStatus.passed
          : (statusStr == 'error'
                ? SubmissionStatus.error
                : SubmissionStatus.failed);

      return SubmissionResult(
        report: report,
        submissionId: data['submission_id'] as String? ?? '',
        status: status,
        newXpTotal: data['new_xp_total'] as int? ?? 0,
        xpEarned: data['xp_earned'] as int? ?? 0,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return _rethrowApiError(e);
      }
      rethrow; // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<SubmissionHistory> getHistory(String challengeId) async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/challenges/$challengeId/history',
      );
      final data = res.data;
      if (data == null) throw Exception('Empty response');

      final listData = (data['submissions'] as List<dynamic>? ?? []);
      final subs = listData.map((s) {
        final sMap = s as Map<String, dynamic>;
        final statusStr = sMap['status'] as String? ?? 'failed';
        final status = statusStr == 'passed'
            ? SubmissionStatus.passed
            : (statusStr == 'error'
                  ? SubmissionStatus.error
                  : SubmissionStatus.failed);

        return Submission(
          number: sMap['number'] as int? ?? 1,
          status: status,
          score: sMap['score'] as int? ?? 0,
          detail: sMap['detail'] as String? ?? '',
          whenLabel: sMap['when_label'] as String? ?? '',
          code: sMap['code'] as String? ?? '',
          aiReview: sMap['ai_feedback'] as String?,
        );
      }).toList();

      return SubmissionHistory(
        challengeTitle: data['challenge_title'] as String? ?? 'Tantangan',
        context: data['context'] as String? ?? 'Kurikulum Algoritma RPL',
        bestScore: data['best_score'] as int? ?? 0,
        submissions: subs,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        return _rethrowApiError(e);
      }
      rethrow; // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
    } catch (_) {
      rethrow;
    }
  }
}
