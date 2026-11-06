// FILE: lib/features/certificate/data/api_certificate_repository.dart
//
// TUGAS: pengambil data e-Sertifikat Kompetensi dari gateway CodeLab AI.
//
// ENDPOINT:
//   - GET /api/v1/me/certificates  (JWT) → dua kelompok sertifikat milik siswa
//   - GET /api/v1/verify/{certId}  (publik) → payload halaman verifikasi
//
// GALAT: setiap jawaban server yang nyata (4xx/5xx) diteruskan jujur sebagai
// ApiCertificateException — tidak ada data tiruan (Week 9 rule).
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/certificate_exceptions.dart';
import '../domain/certificate_models.dart';
import '../domain/certificate_repository.dart';

class ApiCertificateRepository implements CertificateRepository {
  ApiCertificateRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  @override
  Future<MyCertificates> getMyCertificates() async {
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/me/certificates',
      );
      final data = res.data;
      if (data == null) {
        throw const ApiCertificateException(
          'CLIENT_EMPTY_RESPONSE',
          'Server tidak mengirim data sertifikat.',
        );
      }
      return MyCertificates.fromJson(data);
    } on DioException catch (e) {
      throw ApiCertificateException.fromDio(e);
    }
  }

  @override
  Future<CertificateVerification> getVerification(String certId) async {
    final id = certId.trim();
    if (id.isEmpty) {
      throw const ApiCertificateException(
        'NOT_FOUND',
        'Nomor sertifikat kosong.',
      );
    }
    try {
      final res = await _client.dio.get<Map<String, dynamic>>(
        '/verify/$id',
      );
      final data = res.data;
      if (data == null) {
        throw const ApiCertificateException(
          'CLIENT_EMPTY_RESPONSE',
          'Server tidak mengirim data sertifikat.',
        );
      }
      return CertificateVerification.fromJson(data);
    } on DioException catch (e) {
      throw ApiCertificateException.fromDio(e);
    }
  }
}
