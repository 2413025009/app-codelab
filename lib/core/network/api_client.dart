// FILE: lib/core/network/api_client.dart
//
// TUGAS: kurir tunggal REST — semua repositori mengirim permintaan lewat
// Dio milik kelas ini (SRD §2.1 arsitektur & §2.3 daftar endpoint).
//
// FUNGSI YANG DIKELOLA:
//   - ApiClient()        : (1) pilih baseUrl dari AppConfig (lib/core/
//     config/app_config.dart) — default localhost/10.0.2.2 untuk lokal,
//     atau server cloud bila dijalankan dengan
//     --dart-define=API_BASE_URL=https://api.codelab-ai.web.id/api/v1;
//     (2) timeout 8 detik koneksi / 20 detik jawaban;
//     (3) interceptor pembubuh kepala surat Authorization: Bearer {token}
//     pada tiap permintaan.
//   - setToken()/token   : simpan & baca token akses aktif (di-update
//     oleh TokenStore agar satu sumber kebenaran).
//   - onError interceptor: 401 pada endpoint NON-/auth/* → coba
//     POST /auth/refresh SEKALI (banyak 401 bersamaan memakai satu
//     refresh via _refreshInFlight), lalu kirim ulang permintaan dengan
//     token baru; kalau refresh pun gagal → TokenStore dibersihkan dan
//     error diteruskan ke pemanggil.
//   - isNetworkError()   : penentu "sungguh offline" (connection error,
//     timeout, socket). Repositori HANYA boleh jatuh ke data tiruan bila
//     fungsi ini true — 401/403/4xx/5xx adalah jawaban server sungguhan
//     dan WAJIB diperlihatkan jujur ke UI.
//
// WAJIB DIUBAH BILA: skema refresh token berubah atau batas waktu
// (timeout) perlu digeser — alamat server TIDAK lagi diubah di file ini,
// cukup lewat dart-define, lihat core/config/app_config.dart.
import 'dart:async';

import 'dart:io';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import 'token_store.dart';

class ApiClient {
  ApiClient({String? baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null && _token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
        onError: (err, handler) async {
          // Access token kedaluwarsa → coba refresh sekali, lalu ulangi request.
          if (err.response?.statusCode == 401 &&
              !err.requestOptions.path.contains('/auth/')) {
            final refreshed = await _refreshOnce();
            if (refreshed) {
              try {
                final retryResponse = await dio.fetch<Response<dynamic>>(
                  err.requestOptions..headers['Authorization'] = 'Bearer $_token',
                );
                return handler.resolve(retryResponse);
              } on DioException catch (retryErr) {
                return handler.reject(retryErr);
              }
            }
            // Refresh gagal total: bersihkan sesi agar pemanggil melihat 401.
            await TokenStore.clear();
          }
          return handler.next(err);
        },
      ),
    );
  }

  static String? _token;
  static Future<bool>? _refreshInFlight;

  late final Dio dio;

  static void setToken(String? token) {
    _token = token;
  }

  static String? get token => _token;

  /// True bila error berarti server sungguh tidak terjangkau
  /// (offline / putus koneksi / timeout). Jawaban server yang nyata
  /// (401/403/500 dst) BUKAN network error — repositori tidak boleh
  /// menyembunyikannya dengan data tiruan.
  static bool isNetworkError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
        case DioExceptionType.badCertificate:
          return true;
        default:
          return error.error is SocketException ||
              error.error is TimeoutException;
      }
    }
    return error is SocketException || error is TimeoutException;
  }

  /// Deduplicated refresh: many concurrent 401s share one refresh call.
  static Future<bool> _refreshOnce() {
    _refreshInFlight ??= _doRefresh();
    return _refreshInFlight!;
  }

  static Future<bool> _doRefresh() async {
    try {
      final refreshToken = await TokenStore.readRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final res = await dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      final access = res.data?['accessToken'] as String?;
      final refresh = res.data?['refreshToken'] as String?;
      if (access == null || access.isEmpty) return false;

      await TokenStore.save(
        accessToken: access,
        refreshToken: refresh ?? refreshToken,
      );
      return true;
    } on Exception {
      return false;
    } finally {
      Future.microtask(() {
        _refreshInFlight = null; // izinkan refresh berikutnya setelah selesai.
      });
    }
  }
}
