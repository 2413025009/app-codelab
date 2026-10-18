// FILE: lib/core/network/token_store.dart
// TUGAS: menyimpan sesi login secara aman di perangkat (Keychain / Keystore / DPAPI).
// FUNGSI YANG DIKELOLA: save, restore, clear — setiap perubahan langsung
// menyinkronkan ApiClient.setToken agar seluruh repositori memakai token baru.
// DATA YANG DIKELOLA: kunci secure storage codelab_access_token & codelab_refresh_token.
// WAJIB DIUBAH BILA: skema sesi backend berubah (mis. umur refresh berbeda).
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart';

/// Persists the session tokens in encrypted device storage (iOS Keychain /
/// Android Keystore / Windows DPAPI). Whenever the store changes,
/// [ApiClient.setToken] is refreshed so every repository picks the new token.
class TokenStore {
  TokenStore._();

  static const _accessKey = 'codelab_access_token';
  static const _refreshKey = 'codelab_refresh_token';

  static const _storage = FlutterSecureStorage();

  static String? _memoryAccess;

  /// Saves both tokens after login / refresh and syncs the in-memory token.
  static Future<void> save({
    required String accessToken,
    String? refreshToken,
  }) async {
    _memoryAccess = accessToken;
    ApiClient.setToken(accessToken);
    await _storage.write(key: _accessKey, value: accessToken);
    if (refreshToken == null || refreshToken.isEmpty) {
      await _storage.delete(key: _refreshKey);
    } else {
      await _storage.write(key: _refreshKey, value: refreshToken);
    }
  }

  /// Restores the token saved from a previous session. Called once at startup.
  static Future<String?> restore() async {
    try {
      final token = await _storage.read(key: _accessKey);
      if (token != null && token.isNotEmpty) {
        _memoryAccess = token;
        ApiClient.setToken(token);
      }
    } on Exception catch (e) {
      debugPrint('TokenStore.restore failed: $e');
    }
    return _memoryAccess;
  }

  /// Reads the refresh token whenever the API returns 401.
  static Future<String?> readRefreshToken() =>
      _storage.read(key: _refreshKey);

  /// Clears every token (logout or irrevocable 401).
  static Future<void> clear() async {
    _memoryAccess = null;
    ApiClient.setToken(null);
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
