// FILE: lib/features/teacher/domain/teacher_repository.dart
//
// Kontrak data Teacher Studio (Minggu 11-12).

import '../../class/domain/class_repository.dart';
import 'teacher_models.dart';

abstract class TeacherRepository {
  // ── Materi ────────────────────────────────────────────────────────────────

  /// Daftar materi milik guru yang login.
  /// [status] = "draft" | "published" | null (semua).
  Future<List<TeacherLesson>> listMaterials({String? status});

  /// Buat materi baru; status awal selalu "draft".
  Future<TeacherLesson> createMaterial({
    required String title,
    required String topic,
    required String level,
    required String description,
    String iconCode = 'terminal',
  });

  /// Edit metadata materi (judul, track, level, deskripsi, ikon).
  Future<TeacherLesson> updateMaterial(
    String lessonId, {
    required String title,
    required String topic,
    required String level,
    required String description,
    String? iconCode,
  });

  /// Terbitkan materi (draft → published).
  Future<void> publishMaterial(String lessonId);

  /// Tarik kembali materi (published → draft).
  Future<void> unpublishMaterial(String lessonId);

  /// Hapus materi (soft delete + bab ikut).
  Future<void> deleteMaterial(String lessonId);

  /// Duplikat materi + bab; hasil = draft baru.
  Future<TeacherLesson> duplicateMaterial(String lessonId);

  // ── Bab ──────────────────────────────────────────────────────────────────

  /// Daftar bab aktif suatu materi, urut order_index.
  Future<List<Bab>> listBabs(String lessonId);

  /// Tambah bab baru di akhir materi.
  Future<Bab> createBab(
    String lessonId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  });

  /// Edit bab (judul, XP, slides → backend serialisasi markdown).
  Future<Bab> updateBab(
    String babId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  });

  /// Hapus bab (soft delete).
  Future<void> deleteBab(String babId);

  /// Pindah urutan bab: "up" atau "down".
  Future<void> moveBab(String babId, String direction);

  // ── Kelas (extended) ──────────────────────────────────────────────────────

  /// Daftar kelas milik guru (GET /classes).
  Future<List<ClassInfo>> listClasses();

  /// Daftar kelas yang sudah diarsipkan (GET /classes/archived).
  Future<List<ClassInfo>> listArchivedClasses();

  /// Buat rombel baru guru (POST /classes).
  Future<ClassInfo> createClass({
    required String name,
    required String academicYear,
    String scheduleNote = '',
  });

  /// Edit nama kelas, tahun ajaran, jam lab.
  Future<ClassInfo> updateClass(
    String classId, {
    required String name,
    required String academicYear,
    required String scheduleNote,
  });

  /// Acak ulang kode kelas; returns kode baru.
  Future<String> regenerateCode(String classId);

  /// Arsipkan kelas (status = 'archived').
  Future<void> archiveClass(String classId);

  /// Pulihkan kelas dari arsip (status = 'active').
  Future<void> restoreClass(String classId);

  /// Leaderboard siswa kelas (XP, bab terakhir, ketuntasan).
  Future<List<StudentRosterRow>> classRoster(String classId);

  /// Hapus siswa dari kelas.
  Future<void> removeStudentFromClass(String classId, String studentId);

  /// Bar 4 track + kartu diagnostik bab tersulit.
  Future<ClassAnalytics> classAnalytics(String classId);
}
