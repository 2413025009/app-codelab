// FILE: lib/core/config/app_config.dart
//
// TUGAS: satu sumber kebenaran alamat server untuk seluruh aplikasi.
//
// ATURAN PILIH ALAMAT (dari yang paling kuat):
//   1. --dart-define=API_BASE_URL=... → dipakai apa adanya (mis. server
//      produksi https://api.codelab-ai.web.id/api/v1).
//   2. Tanpa dart-define → default pengembangan LOKAL:
//      web/komputer = http://localhost:8080/api/v1
//      Android Emulator = http://10.0.2.2:8080/api/v1 (alias komputer
//      tuan rumah, jangan localhost — emulator punya jaringan sendiri).
//
// URL dokumentasi (Swagger) menunjuk ke produksi — hanya untuk dilihat /
// di-link dari UI (mis. Settings), tidak pernah dipakai oleh Dio.
//
// WAJIB DIUBAH BILA: domain produksi berpindah → cukup ganti kProdBaseUrl
// di bawah, atau kirim dart-define baru saat menjalankan aplikasi.
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  AppConfig._(); // statis murni — kelas ini tidak boleh dibuat objeknya.

  /// Override lewat --dart-define (string kosong = tanpa override).
  static const String _overrideUrl = String.fromEnvironment('API_BASE_URL');
  static const String _overrideDocs = String.fromEnvironment('API_DOCS_URL');

  /// Alamat server produksi (backend-api-gateway di cPanel).
  static const String kProdBaseUrl = 'https://api.codelab-ai.web.id/api/v1';
  static const String kProdDocsUrl =
      'https://api.codelab-ai.web.id/api/docs/index.html';

  /// Base url yang dipakai SEMUA Dio (ApiClient utama + refresh token),
  /// sehingga tidak ada lagi alamat yang tertulis dobel di api_client.dart.
  static String get apiBaseUrl {
    if (_overrideUrl.isNotEmpty) return _overrideUrl;
    if (kIsWeb) return 'http://localhost:8080/api/v1';
    return Platform.isAndroid
        ? 'http://10.0.2.2:8080/api/v1'
        : 'http://localhost:8080/api/v1';
  }

  /// Tautan dokumentasi API — BUKAN base url permintaan.
  /// Default: halaman dokumentasi produksi.
  static String get apiDocsUrl =>
      _overrideDocs.isNotEmpty ? _overrideDocs : kProdDocsUrl;

  /// true bila aplikasi sedang melesat ke server cloud (bukan localhost).
  static bool get usesCloudApi => apiBaseUrl.startsWith('https://');
}
