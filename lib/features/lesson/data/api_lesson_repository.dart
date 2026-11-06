import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../challenges/domain/challenge_exceptions.dart';
import '../domain/lesson_parser.dart';
import '../domain/lesson_repository.dart';
import '../domain/slide_models.dart';

class ApiLessonRepository implements LessonRepository {
  ApiLessonRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  @override
  Future<LessonDetailData> getLessonDetail(String id) async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>('/lessons/$id');
      final data = res.data;
      if (data == null) throw Exception('Empty response');

      final title = data['title'] as String? ?? 'Bab Materi';
      final markdown = data['contentMarkdown'] as String? ?? '';
      final slides = LessonParser.parseSlides(markdown, defaultTitle: title);

      return LessonDetailData(
        id: data['id'] as String? ?? id,
        title: title,
        slug: data['slug'] as String? ?? id,
        topic: data['topic'] as String? ?? 'Python Dasar',
        level: data['level'] as String? ?? 'beginner',
        orderIndex: data['orderIndex'] as int? ?? 1,
        xpReward: data['xpReward'] as int? ?? 50,
        status: data['status'] as String? ?? 'active',
        progressPercent: (data['progressPercent'] as num?)?.toDouble() ?? 0.0,
        currentSlideIndex: data['currentSlideIndex'] as int? ?? 1,
        description: data['description'] as String? ?? '',
        requiredLessonTitle: data['requiredLessonTitle'] as String?,
        slides: slides,
        contentMarkdown: markdown,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        // P2-16: 403 LESSON_LOCKED harus sampai ke UI, bukan ditermockan.
        throw ApiChallengeException.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      }
      if (ApiClient.isNetworkError(e)) {
        rethrow; // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<int> saveProgress({
    required String id,
    required int currentSlideIndex,
    required double progressPercent,
    required bool completed,
  }) async {
    try {
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/lessons/$id/progress',
        data: {
          'currentSlideIndex': currentSlideIndex,
          'progressPercent': progressPercent,
          'completed': completed,
        },
      );
      // Minggu 9: XP yang benar-benar dibayarkan server (bukan reward
      // lokal bab). 0 = bab sudah pernah tuntas → XP tidak dihitung dobel.
      return (res.data?['xpEarned'] as num?)?.toInt() ?? 0;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiChallengeException.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      }
      if (ApiClient.isNetworkError(e)) {
        rethrow; // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<LessonDetailData>> listAllLessons() async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>('/lessons');
      final items = res.data?['items'] as List<dynamic>?;
      if (items == null || items.isEmpty) throw Exception('No lessons');

      final list = <LessonDetailData>[];
      for (final raw in items) {
        if (raw is Map<String, dynamic>) {
          final id = raw['id'] as String? ?? '';
          // We can fetch details or map with empty slides until clicked
          list.add(
            LessonDetailData(
              id: id,
              title: raw['title'] as String? ?? '',
              slug: raw['slug'] as String? ?? '',
              topic: raw['topic'] as String? ?? 'Python Dasar',
              level: raw['level'] as String? ?? 'beginner',
              orderIndex: raw['orderIndex'] as int? ?? 1,
              xpReward: raw['xpReward'] as int? ?? 50,
              status: raw['status'] as String? ?? 'locked',
              progressPercent:
                  (raw['progressPercent'] as num?)?.toDouble() ?? 0.0,
              currentSlideIndex: raw['currentSlideIndex'] as int? ?? 1,
              description: raw['description'] as String? ?? '',
              requiredLessonTitle: raw['requiredLessonTitle'] as String?,
              slides: const [],
              contentMarkdown: '',
            ),
          );
        }
      }
      return list;
    } on DioException {
      // Offline → error jujur ke UI (Week 9: tanpa fallback mock).
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  /// Minggu 13: modul pengajar kelas siswa (GET /student/guru-lessons).
  ///
  /// Kegagalan di sini TIDAK dilempar: penanda "Baru" dan notifikasi modul
  /// baru bersifat tambahan, sedangkan katalog kurikulum tetap harus tampil.
  @override
  Future<List<GuruLessonSummary>> listGuruLessons() async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/student/guru-lessons',
      );
      final items = res.data?['items'] as List<dynamic>? ?? const [];
      final list = <GuruLessonSummary>[];
      for (final raw in items) {
        if (raw is! Map<String, dynamic>) continue;
        list.add(
          GuruLessonSummary(
            id: raw['id'] as String? ?? '',
            title: raw['title'] as String? ?? '',
            topic: raw['topic'] as String? ?? '',
            description: raw['description'] as String? ?? '',
            iconCode: raw['iconCode'] as String? ?? 'terminal',
            babCount: raw['babCount'] as int? ?? 0,
            totalXp: raw['totalXp'] as int? ?? 0,
            teacherName: raw['teacherName'] as String? ?? '',
          ),
        );
      }
      return list;
    } catch (_) {
      // Siswa tanpa kelas / jaringan bermasalah: tidak ada modul guru.
      return const <GuruLessonSummary>[];
    }
  }

  /// Minggu 13: pencarian sampai ke ISI bab (GET /lessons/search).
  ///
  /// Kegagalan dikembalikan sebagai daftar kosong: hasil pencarian tambahan
  /// tidak boleh menghalangi siswa membuka modul yang sudah tampil.
  @override
  Future<List<LessonSearchHit>> searchLessons(String keyword) async {
    final q = keyword.trim();
    if (q.isEmpty) return const <LessonSearchHit>[];
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/lessons/search',
        queryParameters: {'q': q},
      );
      final items = res.data?['items'] as List<dynamic>? ?? const [];
      final list = <LessonSearchHit>[];
      for (final raw in items) {
        if (raw is! Map<String, dynamic>) continue;
        list.add(
          LessonSearchHit(
            lessonId: raw['lessonId'] as String? ?? '',
            lessonTitle: raw['lessonTitle'] as String? ?? '',
            topic: raw['topic'] as String? ?? '',
            source: raw['source'] as String? ?? 'content',
            snippet: raw['snippet'] as String? ?? '',
          ),
        );
      }
      return list;
    } catch (_) {
      return const <LessonSearchHit>[];
    }
  }
}
