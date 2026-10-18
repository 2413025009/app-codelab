import '../domain/dashboard_repository.dart';

/// Static data mirroring the stitch dashboard. The seeded demo student sees
/// progress; any other account sees the empty (new user) state.
class MockDashboardRepository implements DashboardRepository {
  static const demoEmail = 'farhan@smk.belajar.id';

  @override
  Future<DashboardData> load({
    required String studentEmail,
    void Function(int done, int total, String stage)? onProgress,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final isDemo = studentEmail.toLowerCase() == demoEmail;

    // P1-10: dataset mock mensinkron seed DB migrasi 000006 — 6 bab, 2 track
    // (Python Dasar dulu, baru HTML & Web Dasar), slug persis seperti DB.
    const titles = [
      ('pengenalan-variabel', 'Pengenalan & Variabel Python', 'Mengenal struktur penyimpanan nilai pertama'),
      ('tipe-data-operasi', 'Tipe Data & Operasi Hitung', 'Angka, string, boolean, dan operasi hitung'),
      ('percabangan-if-else', 'Percabangan Logika If-Else', 'Evaluasi kondisi boolean & branching'),
      ('struktur-dokumen-web', 'Struktur Dokumen Web Modern', 'Track HTML: HTML5 & struktur dokumen'),
      ('format-teks-semantik', 'Teks, Paragraf & Format Semantik', 'Track HTML: paragraf & semantik'),
      ('link-media-gambar', 'Link Hyperlink & Media Gambar', 'Track HTML: tautan, gambar & aksesibilitas'),
    ];

    final activeIndex = isDemo ? 2 : 0;
    const pythonTopic = 'Python Dasar';
    const htmlTopic = 'HTML & Web Dasar';
    final topics = [
      pythonTopic,
      pythonTopic,
      pythonTopic,
      htmlTopic,
      htmlTopic,
      htmlTopic,
    ];
    final modules = [
      for (var i = 0; i < titles.length; i++)
        LearningModule(
          id: titles[i].$1,
          order: i + 1,
          title: titles[i].$2,
          description: titles[i].$3,
          topic: topics[i],
          status: i < activeIndex
              ? ModuleStatus.completed
              : i == activeIndex
                  ? ModuleStatus.active
                  : ModuleStatus.locked,
          requirement: i > activeIndex ? 'Selesaikan Bab $i dulu' : null,
        ),
    ];

    return DashboardData(
      // Selaras MockChallengeRepository: 8 tantangan seed, 1 selesai (kabisat).
      completedChallenges: isDemo ? 1 : 0,
      totalChallenges: 8,
      userXp: isDemo ? 480 : 0,
      firstLessonId: titles.first.$1,
      resume: isDemo
          ? const ResumeInfo(
              lessonId: 'percabangan-if-else',
              topic: 'Python Dasar',
              title: 'Percabangan Logika If-Else',
              description: 'Memahami evaluasi kondisi bernilai boolean',
              progress: 0.35,
            )
          : null,
      skills: isDemo
          ? const {'Logika': 85, 'Variabel': 90, 'Perulangan': 70, 'Fungsi': 65}
          : const {'Logika': 0, 'Variabel': 0, 'Perulangan': 0, 'Fungsi': 0},
      pathTitle: 'Python Dasar & Web',
      // P1-11: hitung dari data nyata — 6 bab (tanpa +n artifisial).
      pathSubtitle: '${titles.length} Bab Menuju Sertifikat',
      modules: modules,
    );
  }
}
