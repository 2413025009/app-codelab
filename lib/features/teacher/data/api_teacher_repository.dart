// FILE: lib/features/teacher/data/api_teacher_repository.dart
//
// TUGAS: kurir REST fitur instruktur & studio materi guru (Minggu 11-12)
// via ApiClient (token otomatis, penanganan refresh 401).

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../class/domain/class_repository.dart';
import '../domain/teacher_exceptions.dart';
import '../domain/teacher_models.dart';
import '../domain/teacher_repository.dart';

class ApiTeacherRepository implements TeacherRepository {
  ApiTeacherRepository();

  final _dio = ApiClient().dio;

  // ─── Materi ────────────────────────────────────────────────────────────────

  @override
  Future<List<TeacherLesson>> listMaterials({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null &&
          status.isNotEmpty &&
          status != 'all' &&
          status != 'semua') {
        queryParams['status'] = status;
      }
      final res = await _dio.get<Map<String, dynamic>>(
        '/teacher/materis',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      final items = res.data?['items'];
      return [
        for (final item in (items is List ? items : const []))
          _parseLesson(item),
      ];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<TeacherLesson> createMaterial({
    required String title,
    required String topic,
    required String level,
    required String description,
    String iconCode = 'terminal',
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/teacher/materis',
        data: {
          'title': title,
          'topic': topic,
          'level': level,
          'description': description,
          'iconCode': iconCode,
        },
      );
      return _parseLesson(res.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<TeacherLesson> updateMaterial(
    String lessonId, {
    required String title,
    required String topic,
    required String level,
    required String description,
    String? iconCode,
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'topic': topic,
        'level': level,
        'description': description,
      };
      if (iconCode != null && iconCode.isNotEmpty) {
        data['iconCode'] = iconCode;
      }
      final res = await _dio.patch<Map<String, dynamic>>(
        '/teacher/materis/$lessonId',
        data: data,
      );
      return _parseLesson(res.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> publishMaterial(String lessonId) async {
    try {
      await _dio.post<dynamic>('/teacher/materis/$lessonId/publish');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> unpublishMaterial(String lessonId) async {
    try {
      await _dio.post<dynamic>('/teacher/materis/$lessonId/unpublish');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteMaterial(String lessonId) async {
    try {
      await _dio.delete<dynamic>('/teacher/materis/$lessonId');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<TeacherLesson> duplicateMaterial(String lessonId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/teacher/materis/$lessonId/duplicate',
      );
      return _parseLesson(res.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─── Bab ───────────────────────────────────────────────────────────────────

  @override
  Future<List<Bab>> listBabs(String lessonId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/teacher/materis/$lessonId/babs',
      );
      final items = res.data?['items'];
      return [
        for (final item in (items is List ? items : const [])) _parseBab(item),
      ];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<Bab> createBab(
    String lessonId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/teacher/materis/$lessonId/babs',
        data: {'title': title, 'xpReward': xpReward, 'slides': slides},
      );
      return _parseBab(res.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<Bab> updateBab(
    String babId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/teacher/babs/$babId',
        data: {'title': title, 'xpReward': xpReward, 'slides': slides},
      );
      return _parseBab(res.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteBab(String babId) async {
    try {
      await _dio.delete<dynamic>('/teacher/babs/$babId');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> moveBab(String babId, String direction) async {
    try {
      await _dio.post<dynamic>(
        '/teacher/babs/$babId/move',
        data: {'direction': direction},
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─── Kelas ─────────────────────────────────────────────────────────────────

  @override
  Future<List<ClassInfo>> listClasses() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/classes');
      final items = res.data?['items'];
      return [
        for (final item in (items is List ? items : const []))
          _parseClass(item),
      ];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<ClassInfo>> listArchivedClasses() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/classes/archived');
      final items = res.data?['items'];
      return [
        for (final item in (items is List ? items : const []))
          _parseClass(item),
      ];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ClassInfo> createClass({
    required String name,
    required String academicYear,
    String scheduleNote = '',
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/classes',
        data: {'name': name, 'academicYear': academicYear},
      );
      final room = _parseClass(res.data);
      if (scheduleNote.isNotEmpty) {
        return updateClass(
          room.id,
          name: name,
          academicYear: academicYear,
          scheduleNote: scheduleNote,
        );
      }
      return room;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ClassInfo> updateClass(
    String classId, {
    required String name,
    required String academicYear,
    required String scheduleNote,
  }) async {
    try {
      final res = await _dio.patch<Map<String, dynamic>>(
        '/classes/$classId/teacher',
        data: {
          'name': name,
          'academicYear': academicYear,
          'scheduleNote': scheduleNote,
        },
      );
      return _parseClass(res.data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<String> regenerateCode(String classId) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/classes/$classId/regenerate-code',
      );
      return res.data?['classCode'] as String? ?? '';
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> archiveClass(String classId) async {
    try {
      await _dio.delete<dynamic>('/classes/$classId');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> restoreClass(String classId) async {
    try {
      await _dio.post<dynamic>('/classes/$classId/restore');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<List<StudentRosterRow>> classRoster(String classId) async {
    try {
      final res = await _dio.get<dynamic>('/teacher/classes/$classId/students');
      final data = res.data;
      return [
        for (final item in (data is List ? data : const []))
          _parseRosterRow(item),
      ];
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> removeStudentFromClass(String classId, String studentId) async {
    try {
      await _dio.delete<dynamic>('/teacher/classes/$classId/students/$studentId');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<ClassAnalytics> classAnalytics(String classId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/teacher/classes/$classId/analytics',
      );
      final data = res.data ?? {};
      final bars = data['trackBars'] as List? ?? [];
      final hardest = data['hardestChapters'] as List? ?? [];

      return ClassAnalytics(
        memberCount: data['memberCount'] is int
            ? data['memberCount'] as int
            : int.tryParse('${data['memberCount']}') ?? 0,
        trackBars: [
          for (final b in bars)
            TrackBar(
              track: b['track'] as String? ?? '',
              avgPercent: (b['avgPercent'] as num?)?.toDouble() ?? 0.0,
              completedCount: b['completedCount'] is int
                  ? b['completedCount'] as int
                  : int.tryParse('${b['completedCount']}') ?? 0,
            ),
        ],
        hardestChapters: [
          for (final h in hardest)
            HardestChapter(
              lessonTitle: h['lessonTitle'] as String? ?? '',
              failCount: h['failCount'] is int
                  ? h['failCount'] as int
                  : int.tryParse('${h['failCount']}') ?? 0,
              challengeSlug: h['challengeSlug'] as String? ?? '',
            ),
        ],
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  // ─── Helpers Parsing ────────────────────────────────────────────────────────

  TeacherLesson _parseLesson(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const ApiTeacherException(
        statusCode: 500,
        code: 'INTERNAL_ERROR',
        message: 'Format data materi tidak valid.',
      );
    }
    return TeacherLesson(
      id: '${data['id'] ?? ''}',
      title: data['title'] as String? ?? '',
      topic: data['topic'] as String? ?? '',
      level: data['level'] as String? ?? '',
      description: data['description'] as String? ?? '',
      iconCode: data['iconCode'] as String? ?? 'terminal',
      status: data['status'] as String? ?? 'draft',
      babCount: data['babCount'] is int
          ? data['babCount'] as int
          : int.tryParse('${data['babCount']}') ?? 0,
      totalXp: data['totalXp'] is int
          ? data['totalXp'] as int
          : int.tryParse('${data['totalXp']}') ?? 0,
      updatedAt: data['updatedAt'] as String?,
    );
  }

  Bab _parseBab(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const ApiTeacherException(
        statusCode: 500,
        code: 'INTERNAL_ERROR',
        message: 'Format data bab tidak valid.',
      );
    }
    final rawSlides = data['slides'];
    final slidesList = <Map<String, dynamic>>[];
    if (rawSlides is List) {
      for (final s in rawSlides) {
        if (s is Map<String, dynamic>) {
          slidesList.add(s);
        } else if (s is Map) {
          slidesList.add(Map<String, dynamic>.from(s));
        }
      }
    }

    return Bab(
      id: '${data['id'] ?? ''}',
      lessonId: '${data['lessonId'] ?? ''}',
      title: data['title'] as String? ?? '',
      orderIndex: data['orderIndex'] is int
          ? data['orderIndex'] as int
          : int.tryParse('${data['orderIndex']}') ?? 0,
      xpReward: data['xpReward'] is int
          ? data['xpReward'] as int
          : int.tryParse('${data['xpReward']}') ?? 50,
      slides: slidesList,
      contentMarkdown: data['contentMarkdown'] as String? ?? '',
      updatedAt: data['updatedAt'] as String?,
    );
  }

  ClassInfo _parseClass(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const ApiTeacherException(
        statusCode: 500,
        code: 'INTERNAL_ERROR',
        message: 'Format data kelas tidak valid.',
      );
    }
    return ClassInfo(
      id: '${data['id'] ?? ''}',
      name: data['name'] as String? ?? '',
      classCode: data['classCode'] as String? ?? '',
      status: data['status'] as String? ?? 'active',
      schoolName: data['schoolName'] as String? ?? '',
      teacherName: data['teacherName'] as String? ?? '',
      memberCount: data['memberCount'] is int
          ? data['memberCount'] as int
          : int.tryParse('${data['memberCount']}') ?? 0,
      academicYear: data['academicYear'] as String? ?? '',
      scheduleNote: data['scheduleNote'] as String? ?? '',
    );
  }

  StudentRosterRow _parseRosterRow(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return const StudentRosterRow(
        studentId: '',
        name: '',
        avatarUrl: '',
        xpPoints: 0,
        lastBabTitle: '',
        completedCount: 0,
      );
    }
    return StudentRosterRow(
      studentId: '${data['studentId'] ?? ''}',
      name: data['name'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String? ?? '',
      xpPoints: data['xpPoints'] is int
          ? data['xpPoints'] as int
          : int.tryParse('${data['xpPoints']}') ?? 0,
      lastBabTitle: data['lastBabTitle'] as String? ?? '',
      completedCount: data['completedCount'] is int
          ? data['completedCount'] as int
          : int.tryParse('${data['completedCount']}') ?? 0,
      practiceCompletedCount: data['practiceCompletedCount'] is int
          ? data['practiceCompletedCount'] as int
          : int.tryParse('${data['practiceCompletedCount']}') ?? 0,
    );
  }

  Never _handleDioError(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      throw ApiTeacherException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
    throw e;
  }
}
