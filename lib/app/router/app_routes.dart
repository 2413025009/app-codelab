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
