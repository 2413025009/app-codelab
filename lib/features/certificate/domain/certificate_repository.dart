// FILE: lib/features/certificate/domain/certificate_repository.dart
//
// TUGAS: kontrak data e-Sertifikat Kompetensi (Minggu 12).
//
//   - getMyCertificates()   → GET /api/v1/me/certificates
//   - getVerification(id)   → GET /api/v1/verify/{certId}
//
// Seluruh angka dan status kelayakan berasal dari backend; lapisan ini tidak
// pernah mengarang sertifikat sendiri.
import '../../../core/config/app_config.dart';
import 'certificate_models.dart';

/// Alamat publik halaman verifikasi (dipindai lewat QR Code pada piagam).
abstract final class CertificateLinks {
  static const String verifyBase = 'https://api.codelab-ai.web.id/verify';

  /// Tautan verifikasi resmi satu sertifikat.
  static String verify(String certId) => '$verifyBase/$certId';

  /// URL gambar QR Code dinamis yang dirender server (PNG) untuk nomor
  /// sertifikat ini. Mengikuti alamat backend aktif (localhost saat
  /// pengembangan, domain produksi saat rilis) — bukan domain hardcode,
  /// supaya QR tetap bisa dipindai dari lingkungan mana pun.
  static String qrImage(String certId) {
    final id = certId.trim();
    if (id.isEmpty) return '';
    final base = Uri.tryParse(AppConfig.apiBaseUrl);
    if (base == null || base.host.isEmpty) return '';
    return base.replace(path: '/verify/qr/$id', query: null).toString();
  }
}

abstract interface class CertificateRepository {
  /// Daftar dua jenis sertifikat milik siswa yang login.
  Future<MyCertificates> getMyCertificates();

  /// Payload lengkap satu sertifikat (dipakai layar pratinjau).
  Future<CertificateVerification> getVerification(String certId);
}
