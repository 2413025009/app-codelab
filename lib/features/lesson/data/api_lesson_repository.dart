import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../challenges/domain/challenge_exceptions.dart';
import '../domain/lesson_parser.dart';
import '../domain/lesson_repository.dart';
import '../domain/slide_models.dart';
import 'mock_lesson_repository.dart';

class ApiLessonRepository implements LessonRepository {
  ApiLessonRepository({ApiClient? client, MockLessonRepository? fallback})
      : _client = client ?? ApiClient(),
        _fallback = fallback ?? const MockLessonRepository();

  final ApiClient _client;
  final MockLessonRepository _fallback;

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
        return _fallback.getLessonDetail(id);
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> saveProgress({
    required String id,
    required int currentSlideIndex,
    required double progressPercent,
    required bool completed,
  }) async {
    try {
      await _client.dio.post<Map<String, dynamic>>(
        '/lessons/$id/progress',
        data: {
          'currentSlideIndex': currentSlideIndex,
          'progressPercent': progressPercent,
          'completed': completed,
        },
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiChallengeException.fromResponse(
          e.response?.statusCode ?? 0,
          e.response?.data,
        );
      }
      if (ApiClient.isNetworkError(e)) {
        await _fallback.saveProgress(
          id: id,
          currentSlideIndex: currentSlideIndex,
          progressPercent: progressPercent,
          completed: completed,
        );
      } else {
        rethrow;
      }
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
              progressPercent: (raw['progressPercent'] as num?)?.toDouble() ?? 0.0,
              currentSlideIndex: raw['currentSlideIndex'] as int? ?? 1,
              requiredLessonTitle: raw['requiredLessonTitle'] as String?,
              slides: const [],
              contentMarkdown: '',
            ),
          );
        }
      }
      return list;
    } on DioException catch (e) {
      if (ApiClient.isNetworkError(e)) {
        return _fallback.listAllLessons();
      }
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
