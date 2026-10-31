/// Route paths. Use these constants instead of string literals.
abstract final class AppRoutes {
  // Auth
  static const login = '/login';
  static const register = '/register';

  /// Minggu 9: pendaftaran akun guru berpagar kode sekolah (Stitch v3).
  static const registerTeacher = '/register-teacher';

  /// Minggu 9: URL area guru dibedakan dengan akhiran `-pengajar`
  /// (dashboard guru penuh menyusul di Minggu 11).
  static const teacherHome = '/dashboard-pengajar';

  /// Minggu 9: profil pengajar (folder features/teacher) — data guru, bukan siswa.
  static const teacherProfile = '/profile-pengajar';
  static const teacherSettings = '/pengaturan-pengajar';

  /// Kelas yang sudah diarsipkan (punya layar sendiri, bukan tersembunyi).
  static const teacherArchivedClasses = '/dashboard-pengajar/arsip';

  // ── Studio Materi Pengajar (Minggu 11-12) ──────────────────────────────────
  // Tiap layar punya URL sendiri agar mudah dibaca dan di-bookmark:
  //   /materi-pengajar                     → daftar materi
  //   /materi-pengajar/baru                → tambah materi
  //   /materi-pengajar/:id/edit            → edit info materi
  //   /materi-pengajar/:lessonId/silabus   → daftar bab (silabus)
  //   .../silabus/baru                     → bab builder baru
  //   .../silabus/:babId/edit              → bab builder edit
  //   .../silabus/:babId/slide/:type/:index → editor slide per tipe
  static const teacherStudio = '/materi-pengajar';
  static const teacherAnalytics = '/analitik-pengajar';
  static String teacherAnalyticsRoute(String classId) => '/analitik-pengajar/$classId';
  static const teacherMaterialCreate = '/materi-pengajar/baru';
  static const teacherMaterialEditPattern = '/materi-pengajar/:id/edit';
  static String teacherMaterialEdit(String id) => '/materi-pengajar/$id/edit';

  static const teacherBabListPattern = '/materi-pengajar/:lessonId/silabus';
  static String teacherBabList(String lessonId) =>
      '/materi-pengajar/$lessonId/silabus';

  static const teacherBabCreatePattern =
      '/materi-pengajar/:lessonId/silabus/baru';
  static String teacherBabCreate(String lessonId) =>
      '/materi-pengajar/$lessonId/silabus/baru';

  static const teacherBabEditPattern =
      '/materi-pengajar/:lessonId/silabus/:babId/edit';
  static String teacherBabEdit(String lessonId, String babId) =>
      '/materi-pengajar/$lessonId/silabus/$babId/edit';

  /// Editor slide khusus per tipe (THEORY, TAP_TO_FILL, TYPE_CODE, dst).
  /// `index` adalah posisi slide di dalam bab; bab baru memakai `baru`.
  static const teacherSlideEditorPattern =
      '/materi-pengajar/:lessonId/silabus/:babId/slide/:type/:index';
  static String teacherSlideEditor({
    required String lessonId,
    required String babId,
    required String type,
    required int index,
  }) =>
      '/materi-pengajar/$lessonId/silabus/$babId/slide/${type.toLowerCase()}/$index';

  static const teacherClassAnalyticsPattern = '/kelas/:classId/analitik';
  static String teacherClassAnalytics(String classId) =>
      '/kelas/$classId/analitik';

  // Bottom-navigation tabs (inside the shell) — area siswa memakai akhiran
  // `-siswa` agar URL siswa dan pengajar terlihat berbeda (permintaan owner).
  static const dashboard = '/dashboard-siswa';
  static const challenges = '/challenges-siswa';
  static const playground = '/playground-siswa';
  static const profile = '/profile-siswa';
  static const settings = '/settings';

  // Pushed on top of the shell
  static const catalog = '/catalog';

  static const lessonPattern = '/lesson/:id';
  static String lesson(String id) => '/lesson/$id';

  static const challengePattern = '/challenge/:id';
  static String challenge(String id) => '/challenge/$id';

  static const historyPattern = '/challenge/:id/history';
  static String history(String id) => '/challenge/$id/history';

  /// Full-screen playground with a back button (opened from history / project).
  static const lab = '/lab';
}
