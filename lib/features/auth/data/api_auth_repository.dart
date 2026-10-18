// FILE: lib/features/auth/data/api_auth_repository.dart
// TUGAS: autentikasi nyata ke gateway Go (POST /auth/*, GET dan PUT /me).
// FUNGSI YANG DIKELOLA: login, register, updateProfile, restoreSession —
// error API jujur lewat AuthFailure; data tiruan HANYA bila ApiClient.
// isNetworkError bernilai true (server sungguh terputus).
// KOLOM DB: users (name, email, phone, nisn, class_name, school_name, bio).
// WAJIB DIUBAH BILA: kontrak endpoint auth atau bentuk AuthUser berubah.
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/token_store.dart';
import '../domain/auth_repository.dart';
import 'mock_auth_repository.dart';

/// Real authentication against the Go gateway (POST /auth/*, GET|PUT /me)
/// with encrypted token persistence via [TokenStore].
///
/// Error philosophy matches the other repositories:
/// * API answered with an error (bad credentials, email taken, 401/409/422)
///   → surfaced to the UI as [AuthFailure].
/// * Network unreachable (backend off / no connection) → graceful fallback to
///   [MockAuthRepository] so the app stays demoable offline.
class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._fallback, {ApiClient? client})
      : _client = client ?? ApiClient();

  final ApiClient _client;
  final MockAuthRepository _fallback;

  @override
  Future<AuthUser> login({required String email, required String password}) async {
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
        if (status == 401) throw const AuthFailure(AuthFailureType.invalidCredentials);
        throw const AuthFailure(AuthFailureType.network);
      }
      // Timeout/connection error → offline mode.
      return _fallback.login(email: email, password: password);
    } on AuthFailure {
      rethrow;
    } catch (e) {
      // Hanya offline sungguhan yang boleh jatuh ke data tiruan;
      // error lain diperlihatkan jujur.
      if (ApiClient.isNetworkError(e)) {
        return _fallback.login(email: email, password: password);
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
      return _fallback.register(
        name: name,
        email: email,
        password: password,
        nisn: nisn,
        schoolName: schoolName,
        className: className,
      );
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        return _fallback.register(
          name: name,
          email: email,
          password: password,
          nisn: nisn,
          schoolName: schoolName,
          className: className,
        );
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
        },
      );
      return _userFromJson(res.data ?? const {});
    } on DioException catch (e) {
      if (e.type == DioExceptionType.badResponse) {
        final status = e.response?.statusCode;
        if (status == 401) throw const AuthFailure(AuthFailureType.invalidCredentials);
        throw const AuthFailure(AuthFailureType.network);
      }
      // Offline → simpan di mock agar progres demo tidak hilang.
      return _fallback.updateProfile(
        name: name,
        phone: phone,
        bio: bio,
        schoolName: schoolName,
        className: className,
        nisn: nisn,
      );
    } on AuthFailure {
      rethrow;
    } catch (e) {
      if (ApiClient.isNetworkError(e)) {
        return _fallback.updateProfile(
          name: name,
          phone: phone,
          bio: bio,
          schoolName: schoolName,
          className: className,
          nisn: nisn,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await TokenStore.clear();
    await _fallback.logout();
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
      xpPoints: j['xpPoints'] as int? ?? 0,
      avatarUrl: j['avatarUrl'] as String?,
    );
  }
}
