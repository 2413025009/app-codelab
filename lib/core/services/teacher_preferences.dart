// FILE: lib/core/services/teacher_preferences.dart
//
// TUGAS: preferensi lokal khusus pengajar (bukan data akun server).
// Saklar notifikasi pengumpulan tugas disimpan di perangkat agar pilihan
// guru tidak hilang saat aplikasi ditutup. Belum ada push notification
// backend; nilai ini adalah preferensi yang siap dipakai layanan tersebut.
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TeacherPreferences {
  TeacherPreferences._();

  static const _storage = FlutterSecureStorage();
  static const _keySubmissionNotifications =
      'codelab_teacher_submission_notifications';

  static bool _submissionNotifications = true;

  static bool get submissionNotifications => _submissionNotifications;

  /// Dipanggil sekali saat aplikasi dibuka (main.dart).
  static Future<void> init() async {
    try {
      final value = await _storage.read(key: _keySubmissionNotifications);
      if (value != null) {
        _submissionNotifications = value == 'true';
      }
    } catch (e) {
      debugPrint('TeacherPreferences.init error: $e');
    }
  }

  static Future<void> setSubmissionNotifications(bool enabled) async {
    _submissionNotifications = enabled;
    try {
      await _storage.write(
        key: _keySubmissionNotifications,
        value: enabled.toString(),
      );
    } catch (e) {
      debugPrint('TeacherPreferences.setSubmissionNotifications error: $e');
    }
  }
}
