// FILE: lib/features/teacher/domain/teacher_class_filter.dart
//
// TUGAS: menyaring daftar rombel guru di memori — tanpa permintaan jaringan
// tambahan. Dipakai dashboard "Ruang Kelas Saya" untuk pencarian nama/kode
// kelas dan filter tahun ajaran.

import '../../class/domain/class_repository.dart';

/// Saring [classes] berdasarkan [query] (nama atau kode kelas, tidak
/// membedakan huruf besar/kecil) dan [academicYear] (harus sama persis).
///
/// [academicYear] null / kosong berarti semua tahun ajaran ikut tampil.
List<ClassInfo> filterTeacherClasses(
  List<ClassInfo> classes, {
  String query = '',
  String? academicYear,
}) {
  final keyword = query.trim().toLowerCase();
  final year = academicYear?.trim() ?? '';

  return classes.where((room) {
    if (year.isNotEmpty && room.academicYear.trim() != year) {
      return false;
    }
    if (keyword.isEmpty) return true;
    return room.name.toLowerCase().contains(keyword) ||
        room.classCode.toLowerCase().contains(keyword);
  }).toList(growable: false);
}
