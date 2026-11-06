// FILE: lib/app/router/legacy_routes.dart
//
// TUGAS: menerjemahkan URL lama ke konvensi NAMALAYAR-ROLE tanpa memutus
// tautan yang mungkin sudah dibagikan. Semua fungsi di sini murni (tanpa
// akses state) sehingga mudah diuji dan tidak memperbesar app_router.dart.
import 'app_routes.dart';

/// Menerjemahkan URL Studio versi lama ke URL baru yang mengikuti judul layar
/// plus akhiran peran (konvensi NAMALAYAR-ROLE).
/// Contoh: /studio-pengajar/materi/12/babs/3/edit → /edit-bab-pengajar/12/3
///         /materi-pengajar/12/silabus/3/edit    → /edit-bab-pengajar/12/3
///         /edit-bab/12/3                        → /edit-bab-pengajar/12/3
String? legacyTeacherPath(String path) {
  // Analisa kelas: nama paling lama "/analitik-pengajar", lalu
  // "/analisa-pengajar" sebelum akhiran peran ditambahkan.
  const legacyAnalytics = ['/analitik-pengajar', '/analisa-pengajar'];
  for (final legacy in legacyAnalytics) {
    if (path == legacy) return AppRoutes.teacherAnalytics;
    if (path.startsWith('$legacy/')) {
      return AppRoutes.teacherAnalyticsRoute(path.substring(legacy.length + 1));
    }
  }

  // Nama judul tanpa akhiran peran (versi sebelum konvensi ini).
  final fromTitle = _legacyTitlePath(path);
  if (fromTitle != null) return fromTitle;

  // Format Minggu 11: /materi-pengajar/...
  final fromMateri = _legacyMaterialPath(
    path,
    base: '/materi-pengajar',
    babSegment: 'silabus',
  );
  if (fromMateri != null) return fromMateri;

  // Format paling lama: /studio-pengajar/materi/...
  final fromStudio = _legacyMaterialPath(
    path,
    base: '/studio-pengajar/materi',
    babSegment: 'babs',
  );
  if (fromStudio != null) return fromStudio;

  if (path.startsWith('/studio-pengajar')) return AppRoutes.teacherStudio;
  return null;
}

/// Menerjemahkan URL area siswa & auth lama (termasuk nama tanpa akhiran
/// peran: /catalog, /challenge/:id, /settings) ke konvensi NAMALAYAR-ROLE.
String? legacyStudentPath(String path) {
  // Auth.
  if (path == '/login') return AppRoutes.login;
  if (path == '/register') return AppRoutes.register;
  if (path == '/register-teacher') return AppRoutes.registerTeacher;

  // Pengaturan guru sebelum judulnya "Pengaturan Profil".
  if (path == '/pengaturan-pengajar') return AppRoutes.teacherSettings;
  if (path == '/dashboard-pengajar/arsip') {
    return AppRoutes.teacherArchivedClasses;
  }

  // Tab siswa sebelum memakai nama judul layarnya.
  if (path == '/challenges-siswa') return AppRoutes.challenges;
  if (path == '/playground-siswa') return AppRoutes.playground;
  if (path == '/profile-siswa') return AppRoutes.profile;
  if (path == '/settings') return AppRoutes.settings;
  if (path == '/catalog') return AppRoutes.catalog;
  if (path == '/lab') return AppRoutes.lab;

  // Halaman pushed siswa.
  final history = RegExp(r'^/challenge/([^/]+)/history$').firstMatch(path);
  if (history != null) return AppRoutes.history(history.group(1)!);

  final challenge = RegExp(r'^/challenge/([^/]+)$').firstMatch(path);
  if (challenge != null) return AppRoutes.challenge(challenge.group(1)!);

  final lesson = RegExp(r'^/lesson/([^/]+)$').firstMatch(path);
  if (lesson != null) return AppRoutes.lesson(lesson.group(1)!);

  return null;
}

/// Menerjemahkan URL yang memakai judul layar saja (tanpa `-pengajar`).
String? _legacyTitlePath(String path) {
  if (path == '/studio-materi') return AppRoutes.teacherStudio;
  if (path == '/tambah-materi') return AppRoutes.teacherMaterialCreate;

  final materialEdit = RegExp(r'^/edit-materi/([^/]+)$').firstMatch(path);
  if (materialEdit != null) {
    return AppRoutes.teacherMaterialEdit(materialEdit.group(1)!);
  }

  final slide = RegExp(
    r'^/editor-slide/([^/]+)/([^/]+)/([^/]+)/(\d+)$',
  ).firstMatch(path);
  if (slide != null) {
    return AppRoutes.teacherSlideEditor(
      lessonId: slide.group(1)!,
      babId: slide.group(2)!,
      type: slide.group(3)!,
      index: int.parse(slide.group(4)!),
    );
  }

  final babEdit = RegExp(r'^/edit-bab/([^/]+)/([^/]+)$').firstMatch(path);
  if (babEdit != null) {
    return AppRoutes.teacherBabEdit(babEdit.group(1)!, babEdit.group(2)!);
  }

  final babCreate = RegExp(r'^/bab-builder/([^/]+)$').firstMatch(path);
  if (babCreate != null) {
    return AppRoutes.teacherBabCreate(babCreate.group(1)!);
  }

  final babList = RegExp(r'^/silabus-bab/([^/]+)$').firstMatch(path);
  if (babList != null) {
    return AppRoutes.teacherBabList(babList.group(1)!);
  }

  return null;
}

/// Menerjemahkan satu keluarga URL Studio lama (materi, bab, dan slide).
///
/// [base] adalah awalan sebelum segmen materi, [babSegment] adalah nama segmen
/// daftar bab pada versi tersebut (`silabus` atau `babs`).
String? _legacyMaterialPath(
  String path, {
  required String base,
  required String babSegment,
}) {
  if (path == base) return AppRoutes.teacherStudio;
  if (path == '$base/baru') return AppRoutes.teacherMaterialCreate;

  final materialEdit = RegExp('^$base/([^/]+)/edit\$').firstMatch(path);
  if (materialEdit != null) {
    return AppRoutes.teacherMaterialEdit(materialEdit.group(1)!);
  }

  final slide = RegExp(
    '^$base/([^/]+)/$babSegment/([^/]+)/slide/([^/]+)/(\\d+)\$',
  ).firstMatch(path);
  if (slide != null) {
    return AppRoutes.teacherSlideEditor(
      lessonId: slide.group(1)!,
      babId: slide.group(2)!,
      type: slide.group(3)!,
      index: int.parse(slide.group(4)!),
    );
  }

  final babEdit = RegExp(
    '^$base/([^/]+)/$babSegment/([^/]+)/edit\$',
  ).firstMatch(path);
  if (babEdit != null) {
    return AppRoutes.teacherBabEdit(babEdit.group(1)!, babEdit.group(2)!);
  }

  final babCreate = RegExp(
    '^$base/([^/]+)/$babSegment/baru\$',
  ).firstMatch(path);
  if (babCreate != null) {
    return AppRoutes.teacherBabCreate(babCreate.group(1)!);
  }

  final babList = RegExp('^$base/([^/]+)/$babSegment\$').firstMatch(path);
  if (babList != null) {
    return AppRoutes.teacherBabList(babList.group(1)!);
  }

  return null;
}
