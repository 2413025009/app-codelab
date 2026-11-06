// FILE: lib/features/notifications/new_material_watcher.dart
//
// TUGAS: mendeteksi modul/bab BARU dari pengajar kelas siswa (Minggu 13 —
// notifikasi 4 + lencana "Baru").
//
// CARA KERJA:
//   1. Ambil daftar modul pengajar (GET /student/guru-lessons).
//   2. Bandingkan dengan daftar ID yang pernah dilihat siswa (tersimpan lokal).
//   3. ID baru → notifikasi HP sekali + kumpulan ID "baru" untuk lencana.
//   4. Saat siswa membuka katalog, lencana dihapus (`markAllSeen`).
//
// MENGAPA ID, BUKAN WAKTU: ID stabil dan tidak terpengaruh zona waktu perangkat.
// Menyimpan waktu terakhir dilihat akan salah ketika jam HP tidak akurat.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/services/notification_preferences.dart';
import '../../core/services/notification_service.dart';
import '../../l10n/app_localizations.dart';
import '../lesson/domain/lesson_repository.dart';

class NewMaterialWatcher {
  NewMaterialWatcher._();

  static final NewMaterialWatcher instance = NewMaterialWatcher._();

  static const _storage = FlutterSecureStorage();
  static const _keySeen = 'codelab_seen_guru_lessons';

  /// ID modul pengajar yang sudah dilihat siswa. Disimpan lokal karena hanya
  /// menandai "sudah dibaca", bukan data belajar yang perlu disinkronkan.
  Set<String> _seen = <String>{};

  /// ID modul yang dianggap BARU pada pemeriksaan terakhir (untuk lencana).
  Set<String> _newIds = <String>{};

  Set<String> get newIds => Set.unmodifiable(_newIds);
  bool isNew(String lessonId) => _newIds.contains(lessonId);
  bool get hasNew => _newIds.isNotEmpty;

  Future<void> init() async {
    try {
      final raw = await _storage.read(key: _keySeen);
      if (raw != null && raw.isNotEmpty) {
        _seen = raw.split(',').where((s) => s.trim().isNotEmpty).toSet();
      }
    } catch (_) {
      // Penyimpanan tidak tersedia: anggap belum pernah melihat apa pun —
      // lebih baik muncul lencana daripada diam-diam tidak pernah memberi kabar.
      _seen = <String>{};
    }
  }

  /// Memeriksa modul pengajar dan memberi notifikasi untuk yang benar-benar baru.
  ///
  /// [context] dipakai untuk teks L10n bahasa aktif. Aman dipanggil berkali-kali
  /// (mis. setiap dashboard dibuka): notifikasi hanya muncul sekali per modul.
  Future<void> check(
    LessonRepository repo, {
    required AppLocalizations l10n,
  }) async {
    final lessons = await repo.listGuruLessons();
    if (lessons.isEmpty) {
      _newIds = <String>{};
      return;
    }

    // Pemeriksaan pertama di perangkat (belum ada catatan): jangan banjiri
    // notifikasi untuk semua modul lama — cukup catat semuanya sebagai
    // "sudah dilihat" tanpa berbunyi.
    final firstRun = _seen.isEmpty;

    final fresh = <String>{};
    for (final lesson in lessons) {
      if (lesson.id.isEmpty) continue;
      if (!_seen.contains(lesson.id)) fresh.add(lesson.id);
    }
    _newIds = fresh;

    if (firstRun) {
      await _persist({..._seen, ...lessons.map((l) => l.id)});
      return; // tidak ada notifikasi pada pemeriksaan pertama
    }

    if (fresh.isEmpty) return;

    // Satu notifikasi untuk modul terbaru saja (bukan satu per modul) agar
    // laci notifikasi tidak dibanjiri ketika guru menerbitkan beberapa bab.
    final newest = lessons.firstWhere(
      (l) => fresh.contains(l.id),
      orElse: () => lessons.first,
    );
    if (NotificationPreferences.instance.materialEnabled) {
      await NotificationService.instance.showNewMaterial(
        title: l10n.notifMaterialTitle,
        body: l10n.notifMaterialBody(newest.title),
      );
    }
  }

  /// Dipanggil saat siswa membuka katalog: lencana "Baru" dihapus dan semua
  /// modul saat ini ditandai sudah dilihat.
  Future<void> markAllSeen(LessonRepository repo) async {
    final lessons = await repo.listGuruLessons();
    await _persist({..._seen, ...lessons.map((l) => l.id)});
    _newIds = <String>{};
  }

  Future<void> _persist(Set<String> ids) async {
    _seen = ids;
    try {
      await _storage.write(key: _keySeen, value: ids.join(','));
    } catch (_) {
      // Gagal menyimpan hanya membuat notifikasi bisa muncul lagi — tidak fatal.
    }
  }
}
