// FILE: lib/features/certificate/domain/certificate_exceptions.dart
//
// TUGAS: galat khas modul sertifikat agar UI bisa menampilkan pesan yang tepat.
import 'package:dio/dio.dart';

/// Kegagalan memuat sertifikat. [code] stabil untuk pemetaan teks L10n;
/// [message] dari server dipakai apa adanya bila ada.
class ApiCertificateException implements Exception {
  const ApiCertificateException(this.code, this.message);

  final String code;
  final String message;

  static ApiCertificateException fromResponse(
    int statusCode,
    dynamic data,
  ) {
    String? serverMessage;
    String code = 'CLIENT_SERVER_ERROR';
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        serverMessage = error['message'] as String?;
        final serverCode = error['code'] as String?;
        if (serverCode != null && serverCode.isNotEmpty) code = serverCode;
      }
    }
    if (statusCode == 404) {
      return ApiCertificateException(
        'NOT_FOUND',
        serverMessage ?? 'Sertifikat tidak ditemukan.',
      );
    }
    if (statusCode == 401 || statusCode == 403) {
      return ApiCertificateException(
        'UNAUTHORIZED',
        serverMessage ?? 'Sesi sudah berakhir. Silakan masuk lagi.',
      );
    }
    return ApiCertificateException(
      code,
      serverMessage ?? 'Sertifikat belum bisa dimuat. Coba lagi.',
    );
  }

  static ApiCertificateException fromDio(DioException e) {
    if (e.type == DioExceptionType.badResponse) {
      return fromResponse(e.response?.statusCode ?? 0, e.response?.data);
    }
    return const ApiCertificateException(
      'NETWORK',
      'Tidak bisa menghubungi server. Periksa koneksi internetmu.',
    );
  }

  @override
  String toString() => 'ApiCertificateException($code): $message';
}
