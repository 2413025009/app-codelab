// FILE: lib/features/class/domain/class_repository.dart
//
// TUGAS: kontrak data Minggu 10 — alur siswa masuk/keluar rombel
// ("wadah monitoring guru", bukan LMS classroom).
//
// FUNGSI YANG DIKELOLA:
//   - previewClass : kartu kelas DARI KODE rombel guru (6 karakter, kolom
//     dengan tanda lipat "RPL-XXX") — tampil SEBELUM siswa gabung.
//   - joinClass    : dudukkan siswa ke rombel aktif via kode.
//   - myClasses    : rombel tempat siswa sedang tergabung (satu kelas aktif).
//   - classDetail  : lembar detail kelas — guru pembimbing + daftar teman.
//   - leaveClass   : hubungkan diri dari rombel (XP & progres tetap aman).
//
// WAJIB DIUBAH BILA: keanggotaan kuis/XP sekelas Minggu 11 menambah butuh
// data baru pada kartu (mis. peringkat) — tambah field pada [ClassInfo].

/// Kartu ringkas satu rombel (pratinjau, gabung, daftar kelas saya).
class ClassInfo {
  const ClassInfo({
    required this.id,
    required this.name,
    required this.classCode,
    required this.status,
    required this.schoolName,
    required this.teacherName,
    required this.memberCount,
    required this.academicYear,
    this.scheduleNote = '',
  });

  final String id;
  final String name;
  final String classCode;
  final String status;
  final String schoolName;

  /// Gelar netas guru pembimbing — blank bila backend tak mengirimnya.
  final String teacherName;
  final int memberCount;
  final String academicYear;

  /// Keterangan jam lab / jadwal rombel guru (Minggu 11-12).
  final String scheduleNote;
}

/// Satu teman sekelas pada lembar detail: nama + avatar (bukan nilai;
/// perbandingan antar siswa tidak perlu jadi sumber membanding-bandingkan).
class Classmate {
  const Classmate({
    required this.studentId,
    required this.name,
    required this.avatarUrl,
  });

  final String studentId;
  final String name;
  final String avatarUrl;
}

/// Lembar detail rombel: kartu kelas + daftar teman sekelas lengkap.
class ClassDetail {
  const ClassDetail({required this.info, required this.members});

  final ClassInfo info;

  /// Seluruh anggota aktif; siswa gelar sendiri ikut menunggu di sini.
  final List<Classmate> members;
}

abstract class ClassRepository {
  /// Kartu kelas aktif berdasarkan kode rombel guru (tidak mengubah apa pun).
  Future<ClassInfo> previewClass(String classCode);

  /// Masukkan siswa yang sedang login ke rombel aktif (satu kelas per siswa).
  /// Bisa menolak dengan kode ALREADY_MEMBER / ALREADY_IN_A_CLASS.
  Future<ClassInfo> joinClass(String classCode);

  /// Rombel yang kini diikuti siswa (umumnya tepat satu).
  Future<List<ClassInfo>> myClasses();

  /// Detail kelas: kartu + guru pembimbing + roster teman. Hanya anggota
  /// kelas / guru pembimbing yang dibolehkan (sisanya 403 dari server).
  Future<ClassDetail> classDetail(String classId);

  /// Tarik mengundurkan diri dari rombel; throws bila bukan anggota.
  Future<void> leaveClass(String classId);
}
