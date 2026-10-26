// FILE: lib/features/auth/data/api_auth_repository.dart
// TUGAS: autentikasi nyata ke gateway Go (POST /auth/*, GET dan PUT /me).
// FUNGSI YANG DIKELOLA: login, register, registerTeacher, verifySchool,
// updateProfile, restoreSession — error API jujur lewat AuthFailure.
// KEBIJAKAN WEEK 9 (owner): data 100% dari database/REST — fallback mock
// dihapus; server tidak terjangkau → AuthFailure(network), tanpa data tiruan.
// KOLOM DB: users (name, email, phone, nisn, class_name, school_name,
// bio, role, school_id).
// WAJIB DIUBAH BILA: kontrak endpoint auth atau bentuk AuthUser berubah.
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/token_store.dart';
import '../domain/auth_repository.dart';

/// Real authentication against the Go gateway (POST /auth/*, GET|PUT /me)
/// with encrypted token persistence via [TokenStore].
///
/// Error architecture (Week 9, no mock fallback):
/// * API answered with an error (bad credentials, email taken, 401/409/422)
///   → surfaced to the UI as [AuthFailure].
/// * Network unreachable (backend off / no connection) → [AuthFailure]
///   network — diperlihatkan jujur ke UI, bukan data tiruan.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: {'email': email.trim(), 'password': password},
      );
      final access = res.data?['accessToken'] as String? ?? '';
      final refresh = res.data?['refreshToken'] as String?;
      if (access.isEmpty) throw const AuthFailure(AuthFailureType.network);
      await TokenStore.save(accessToken: access, refreshToken: refresh);

      final user = await _fetchMe();
      return user;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 401) {
          throw const AuthFailure(AuthFailureType.invalidCredentials);
        }
        throw const AuthFailure(AuthFailureType.network);
      }
      // Timeout/connection error → offline. Jujur, tanpa data tiruan.
      throw const AuthFailure(AuthFailureType.network);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        throw const AuthFailure(AuthFailureType.network);
      }
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nisn,
    String? schoolName,
    String? className,
  }) async {
    try {
      await _client.dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'nisn': nisn,
          'schoolName': schoolName,
          'className': className,
        },
      );
      // Register tidak mengembalikan token → langsung login setelahnya.
      await login(email: email, password: password);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 409) throw const AuthFailure(AuthFailureType.emailTaken);
        throw const AuthFailure(AuthFailureType.network);
      }
      throw const AuthFailure(AuthFailureType.network);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        throw const AuthFailure(AuthFailureType.network);
      }
      rethrow;
    }
  }

  @override
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String password,
    required String schoolCode,
  }) async {
    try {
      await _client.dio.post<Map<String, dynamic>>(
        '/auth/register/teacher',
        data: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
          'schoolCode': schoolCode.trim(),
        },
      );
      // Register tidak mengembalikan token → langsung login setelahnya.
      await login(email: email, password: password);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 409) throw const AuthFailure(AuthFailureType.emailTaken);
        if (status == 422) {
          throw const AuthFailure(AuthFailureType.schoolCodeNotFound);
        }
        throw const AuthFailure(AuthFailureType.network);
      }
      throw const AuthFailure(AuthFailureType.network);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        throw const AuthFailure(AuthFailureType.network);
      }
      rethrow;
    }
  }

  @override
  Future<VerifiedSchool> verifySchool({required String schoolCode}) async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/schools/verify',
        queryParameters: {'code': schoolCode.trim()},
      );
      final j = res.data ?? const {};
      return VerifiedSchool(
        schoolCode: (j['schoolCode'] as String? ?? '').trim(),
        name: j['name'] as String? ?? '',
        address: j['address'] as String? ?? '',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 422) {
          throw const AuthFailure(AuthFailureType.schoolCodeNotFound);
        }
        throw const AuthFailure(AuthFailureType.network);
      }
      // Offline → verifikasi memang butuh database; error jujur ke UI.
      throw const AuthFailure(AuthFailureType.network);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        throw const AuthFailure(AuthFailureType.network);
      }
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      // Minggu 9: ganti sandi butuh sesi aktif — ApiClient menyelipkan
      // access token; server memverifikasi sandi lama sebelum menulis.
      await _client.dio.post<Map<String, dynamic>>(
        '/auth/change-password',
        data: {
          'oldPassword': oldPassword,
          'newPassword': newPassword,
          'confirmPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 400) {
          throw const AuthFailure(AuthFailureType.wrongOldPassword);
        }
        if (status == 422) {
          throw const AuthFailure(AuthFailureType.passwordPolicy);
        }
        throw const AuthFailure(AuthFailureType.network);
      }
      throw const AuthFailure(AuthFailureType.network);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        throw const AuthFailure(AuthFailureType.network);
      }
      rethrow;
    }
  }

  @override
  Future<AuthUser> updateProfile({
    required String name,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
    String? address,
    String? staffCode,
  }) async {
    try {
      final res = await _client.dio.put<Map<String, dynamic>>(
        '/me',
        data: {
          'name': name.trim(),
          'phone': phone,
          'bio': bio,
          'schoolName': schoolName,
          'className': className,
          'nisn': nisn,
          // Minggu 9: alamat + kode kepegawaian pengajar.
          'address': address,
          'staffCode': staffCode,
        },
      );
      return _userFromJson(res.data ?? const {});
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 401) {
          throw const AuthFailure(AuthFailureType.invalidCredentials);
        }
        throw const AuthFailure(AuthFailureType.network);
      }
      throw const AuthFailure(AuthFailureType.network);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        throw const AuthFailure(AuthFailureType.network);
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await TokenStore.clear();
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final token = await TokenStore.restore();
    if (token == null || token.isEmpty) return null;

    try {
      return await _fetchMe();
    } on DioException catch (e) {
      if (ApiClient.isNetworkError(e)) {
        // Server belum terjangkau: token DIPERTAHANKAN, dicoba lagi nanti
        // (tidak gugurkan sesi hanya karena jaringan sedang renggang).
        return null;
      }
      await TokenStore.clear(); // Ditolak server (401 dst) → sesi gugur.
      return null;
    } catch (_) {
      await TokenStore.clear();
      return null;
    }
  }

  Future<AuthUser> _fetchMe() async {
    final res = await _client.dio.get<Map<String, dynamic>>('/me');
    return _userFromJson(res.data ?? const {});
  }

  AuthUser _userFromJson(Map<String, dynamic> j) {
    return AuthUser(
      name: j['name'] as String? ?? '',
      email: j['email'] as String? ?? '',
      role: j['role'] as String? ?? 'student',
      nisn: j['nisn'] as String?,
      schoolName: j['schoolName'] as String?,
      className: j['className'] as String?,
      phone: j['phone'] as String?,
      bio: j['bio'] as String?,
      address: j['address'] as String?,
      staffCode: j['staffCode'] as String?,
      xpPoints: j['xpPoints'] as int? ?? 0,
      avatarUrl: j['avatarUrl'] as String?,
    );
  }
}
