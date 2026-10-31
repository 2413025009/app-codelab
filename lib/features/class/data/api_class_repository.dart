// FILE: lib/features/class/data/api_class_repository.dart
//
// TUGAS: kurir REST fitur kelas siswa Minggu 10 —
// preview/join/my/detail/leave melalui ApiClient (bearer otomatis, refresh
// 401 sekali). Jawaban salah dari server diteruskan jujur sebagai
// ApiClassException — TIDAK ADA data tiruan (patokan Week 9).
//
// WAJIB DIUBAH BILA: backend menambah field kartu kelas (minggu 11) atau
//ubah alur premium keanggotaan.

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/class_exceptions.dart';
import '../domain/class_repository.dart';

class ApiClassRepository implements ClassRepository {
  ApiClassRepository();

  final _dio = ApiClient().dio;

  @override
  Future<ClassInfo> previewClass(String classCode) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/classes/preview',
        queryParameters: {'code': classCode},
      );
      return _parseClass(res.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiClassException.fromResponse(
          e.response?.statusCode ?? 500,
          e.response?.data,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ClassInfo> joinClass(String classCode) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/classes/join',
        data: {'classCode': classCode},
      );
      return _parseClass(res.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiClassException.fromResponse(
          e.response?.statusCode ?? 500,
          e.response?.data,
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<ClassInfo>> myClasses() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/classes/my');
      final items = res.data?['items'];
      return [
        for (final item in (items is List ? items : const []))
          _parseClass(item),
      ];
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiClassException.fromResponse(
          e.response?.statusCode ?? 500,
          e.response?.data,
        );
      }
      rethrow;
    }
  }

  @override
  Future<ClassDetail> classDetail(String classId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/classes/$classId');
      final data = res.data;
      if (data == null) {
        throw ApiClassException.fromResponse(500, null);
      }
      final members = data['members'];
      return ClassDetail(
        info: _parseClass(data),
        members: [
          for (final m in (members is List ? members : const []))
            _parseMember(m),
        ],
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiClassException.fromResponse(
          e.response?.statusCode ?? 500,
          e.response?.data,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> leaveClass(String classId) async {
    try {
      await _dio.delete<dynamic>('/classes/$classId/me');
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        throw ApiClassException.fromResponse(
          e.response?.statusCode ?? 500,
          e.response?.data,
        );
      }
      rethrow;
    }
  }

  // --- pembedah jawaban server ---

  ClassInfo _parseClass(dynamic data) {
    if (data is! Map<String, dynamic>) {
      throw const ApiClassException(
        statusCode: 500,
        code: 'INTERNAL_ERROR',
        message: 'Format jawaban kelas tidak dikenali.',
      );
    }
    return ClassInfo(
      id: '${data['id'] ?? ''}',
      name: data['name'] as String? ?? '',
      classCode: data['classCode'] as String? ?? '',
      status: data['status'] as String? ?? '',
      schoolName: data['schoolName'] as String? ?? '',
      teacherName: data['teacherName'] as String? ?? '',
      memberCount: data['memberCount'] is int
          ? data['memberCount'] as int
          : int.tryParse('${data['memberCount']}') ?? 0,
      academicYear: data['academicYear'] as String? ?? '',
      scheduleNote: data['scheduleNote'] as String? ?? '',
    );
  }

  Classmate _parseMember(dynamic data) {
    if (data is! Map<String, dynamic>) {
      return const Classmate(studentId: '', name: '', avatarUrl: '');
    }
    return Classmate(
      studentId: '${data['studentId'] ?? ''}',
      name: data['name'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String? ?? '',
    );
  }
}
