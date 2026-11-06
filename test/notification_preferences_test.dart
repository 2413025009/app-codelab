// FILE: test/notification_preferences_test.dart
//
// TUGAS: pengujian saklar notifikasi (Minggu 13).
// Fokus: saklar induk benar-benar mematikan semua jenis TANPA menghapus pilihan
// per jenis, sehingga menyalakannya kembali memulihkan pengaturan sebelumnya.
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/services/notification_preferences.dart';

void main() {
  // Catatan: FlutterSecureStorage tidak tersedia di lingkungan test, sehingga
  // pemanggilan baca/tulis gagal dengan aman (nilai disimpan di memori saja).
  // Justru inilah yang ingin diuji: kegagalan penyimpanan TIDAK boleh
  // membatalkan perubahan yang sudah tampil di UI.

  setUp(() async {
    final prefs = NotificationPreferences.instance;
    await prefs.setEnabled(true);
    await prefs.setCertificate(true);
    await prefs.setDownload(true);
    await prefs.setReminder(true);
    await prefs.setMaterial(true);
    await prefs.setSession(true);
  });

  test('default semua jenis notifikasi aktif', () {
    final prefs = NotificationPreferences.instance;
    expect(prefs.enabled, isTrue);
    expect(prefs.certificateEnabled, isTrue);
    expect(prefs.downloadEnabled, isTrue);
    expect(prefs.reminderEnabled, isTrue);
    expect(prefs.materialEnabled, isTrue);
    expect(prefs.sessionEnabled, isTrue);
  });

  test('saklar induk mematikan semua jenis tanpa menghapus pilihan', () async {
    final prefs = NotificationPreferences.instance;
    await prefs.setEnabled(false);

    expect(prefs.certificateEnabled, isFalse);
    expect(prefs.downloadEnabled, isFalse);
    expect(prefs.reminderEnabled, isFalse);
    expect(prefs.materialEnabled, isFalse);
    expect(prefs.sessionEnabled, isFalse);

    // Pilihan per jenis TETAP tersimpan.
    expect(prefs.certificateRaw, isTrue);
    expect(prefs.downloadRaw, isTrue);
    expect(prefs.reminderRaw, isTrue);
    expect(prefs.materialRaw, isTrue);
    expect(prefs.sessionRaw, isTrue);

    // Menyalakan induk memulihkan semuanya.
    await prefs.setEnabled(true);
    expect(prefs.certificateEnabled, isTrue);
    expect(prefs.reminderEnabled, isTrue);
  });

  test('mematikan satu jenis tidak memengaruhi jenis lain', () async {
    final prefs = NotificationPreferences.instance;
    await prefs.setReminder(false);

    expect(prefs.reminderEnabled, isFalse);
    expect(prefs.certificateEnabled, isTrue);
    expect(prefs.downloadEnabled, isTrue);
    expect(prefs.materialEnabled, isTrue);
    expect(prefs.sessionEnabled, isTrue);
  });

  test('saklar induk mati membuat jenis yang dinyalakan tetap senyap', () async {
    final prefs = NotificationPreferences.instance;
    await prefs.setEnabled(false);
    await prefs.setMaterial(true);

    expect(prefs.materialRaw, isTrue);
    expect(prefs.materialEnabled, isFalse); // induk masih mati
  });
}
