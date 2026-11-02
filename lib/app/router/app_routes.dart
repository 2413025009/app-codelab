/// Route paths. Use these constants instead of string literals.
///
/// Konvensi NAMALAYAR-ROLE (lihat AGENTS.md): URL diambil dari judul yang
/// tampil di app bar / `h1` layar, huruf kecil, spasi jadi tanda hubung, lalu
/// ditutup akhiran peran pemakai layar (`-pengajar` / `-siswa`). Bila judul
/// layar sudah memuat kata perannya sendiri (mis. "Profil Pengajar"), akhiran
/// tidak diulang.
abstract final class AppRoutes {
  // ── Auth ──────────────────────────────────────────────────────────────────
  // Layar masuk tidak punya judul app bar (h1-nya sapaan "Selamat datang
  // kembali"), jadi URL memakai nama tindakannya.
  static const login = '/masuk';

  /// Minggu 9: pendaftaran akun guru berpagar kode sekolah (Stitch v3).
  static const register = '/daftar-akun';
  static const registerTeacher = '/registrasi-akun-pendidik';

  // ── Area pengajar ─────────────────────────────────────────────────────────
  static const teacherHome = '/dashboard-pengajar';

  /// Judul layar "Profil Pengajar" sudah memuat kata peran → tanpa akhiran.
  static const teacherProfile = '/profile-pengajar';
  static const teacherSettings = '/pengaturan-profil-pengajar';

  /// Kelas yang sudah diarsipkan (punya layar sendiri, bukan tersembunyi).
  static const teacherArchivedClasses = '/arsip-kelas-pengajar';

  // ── Studio Materi Pengajar (Minggu 11-12) ──────────────────────────────────
  //   /studio-materi-pengajar              → "Studio Materi" (daftar materi)
  //   /tambah-materi-pengajar              → "Tambah Materi Baru"
  //   /edit-materi-pengajar/:id            → "Edit Materi"
  //   /silabus-bab-pengajar/:lessonId      → "Silabus & Bab"
  //   /bab-builder-pengajar/:lessonId      → "Bab Builder"
  //   /edit-bab-pengajar/:lessonId/:babId  → "Edit Bab"
  //   /editor-slide-pengajar/:lessonId/:babId/:type/:index → "Editor Slide"
  //   /analisa-kelas-pengajar              → pilih kelas (daftar kelas guru)
  //   /analisa-kelas-pengajar/:classId     → analisa satu kelas
  static const teacherStudio = '/studio-materi-pengajar';

  static const teacherAnalytics = '/analisa-kelas-pengajar';
  static String teacherAnalyticsRoute(String classId) =>
      '/analisa-kelas-pengajar/$classId';

  static const teacherMaterialCreate = '/tambah-materi-pengajar';
  static const teacherMaterialEditPattern = '/edit-materi-pengajar/:id';
  static String teacherMaterialEdit(String id) => '/edit-materi-pengajar/$id';

  static const teacherBabListPattern = '/silabus-bab-pengajar/:lessonId';
  static String teacherBabList(String lessonId) =>
      '/silabus-bab-pengajar/$lessonId';

  static const teacherBabCreatePattern = '/bab-builder-pengajar/:lessonId';
  static String teacherBabCreate(String lessonId) =>
      '/bab-builder-pengajar/$lessonId';

  static const teacherBabEditPattern = '/edit-bab-pengajar/:lessonId/:babId';
  static String teacherBabEdit(String lessonId, String babId) =>
      '/edit-bab-pengajar/$lessonId/$babId';

  /// Editor slide khusus per tipe (THEORY, TAP_TO_FILL, TYPE_CODE, dst).
  /// `index` adalah posisi slide di dalam bab; bab baru memakai `baru`.
  static const teacherSlideEditorPattern =
      '/editor-slide-pengajar/:lessonId/:babId/:type/:index';
  static String teacherSlideEditor({
    required String lessonId,
    required String babId,
    required String type,
    required int index,
  }) => '/editor-slide-pengajar/$lessonId/$babId/${type.toLowerCase()}/$index';

  // ── Area siswa (bottom-navigation tabs + halaman pushed) ──────────────────
  static const dashboard = '/dashboard-siswa';
  static const challenges = '/katalog-tantangan-siswa';
  static const playground = '/python-sandbox-siswa';
  static const profile = '/profil-kompetensi-siswa';
  static const settings = '/pengaturan-siswa';

  /// Katalog seluruh materi kurikulum + materi guru kelas.
  static const catalog = '/katalog-materi-siswa';

  /// Pembaca materi. Layarnya hanya menampilkan bar progres di app bar, jadi
  /// nama URL memakai sebutan layarnya sendiri.
  static const lessonPattern = '/baca-materi-siswa/:id';
  static String lesson(String id) => '/baca-materi-siswa/$id';

  static const challengePattern = '/tantangan-koding-siswa/:id';
  static String challenge(String id) => '/tantangan-koding-siswa/$id';

  static const historyPattern = '/riwayat-submisi-siswa/:id';
  static String history(String id) => '/riwayat-submisi-siswa/$id';

  /// Playground layar penuh (dibuka dari riwayat / proyek).
  static const lab = '/python-sandbox-siswa/lab';
}
