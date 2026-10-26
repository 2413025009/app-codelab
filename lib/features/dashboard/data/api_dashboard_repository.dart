import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../domain/dashboard_repository.dart';

class ApiDashboardRepository implements DashboardRepository {
  ApiDashboardRepository({ApiClient? client}) : _client = client ?? ApiClient();

  final ApiClient _client;

  @override
  Future<DashboardData> load({
    required String studentEmail,
    void Function(int done, int total, String stage)? onProgress,
  }) async {
    void step(int done, String label) => onProgress?.call(done, 5, label);
    try {
      step(0, 'Menyambung ke server…');
      // Lima GET paralel (P1-8): /challenges ikut supaya KPI "N tantangan
      // selesai" memakai angka tantangan, bukan bab selesai /me. Progres =
      // jumlah GET yang BENAR-BENAR pulang dari jaringan (bukan animasi).
      final meF = _client.dio.get<Map<String, dynamic>>('/me').then((r) {
        step(1, 'Profil siswa terbaca');
        return r;
      });
      final progressF = _client.dio
          .get<Map<String, dynamic>>('/me/progress')
          .then((r) {
            step(2, 'Kemajuan bab terbaca');
            return r;
          });
      final skillsF = _client.dio.get<Map<String, dynamic>>('/me/skills').then((
        r,
      ) {
        step(3, 'Radar skill terbaca');
        return r;
      });
      final lessonsF = _client.dio.get<Map<String, dynamic>>('/lessons').then((
        r,
      ) {
        step(4, 'Katalog materi terbaca');
        return r;
      });
      final challengesF = _client.dio
          .get<Map<String, dynamic>>('/challenges')
          .then((r) {
            step(5, 'Catatan tantangan terbaca');
            return r;
          });
      final responses = await Future.wait([
        meF,
        progressF,
        skillsF,
        lessonsF,
        challengesF,
      ]);
      step(5, 'Menyusun dashboard…');

      final meData = responses[0].data ?? {};
      final progressData = responses[1].data ?? {};
      final skillsData = responses[2].data ?? {};
      final lessonsData = responses[3].data ?? {};
      final challengesData = responses[4].data ?? {};

      // Dua KPI berbeda: completedCount /me = BAB selesai;
      // completed /challenges = TANTANGAN selesai (P1-8).
      final completedChallenges = challengesData['completed'] as int? ?? 0;
      // XP resmi siswa dari DB (UserResponse.xpPoints pada GET /me) dipakai
      // halaman profil agar tidak menampilkan XP usang dari sesi lama.
      final userXp = (meData['xpPoints'] as num?)?.toInt();
      // Total seluruh tantangan pada DB (ChallengeCatalogResponse.total) —
      // dipakai kartu statistik "x/y Tantangan".
      final totalChallenges = (challengesData['total'] as num?)?.toInt() ?? 0;

      // Current resume info
      ResumeInfo? resume;
      final currentMap = progressData['current'] as Map<String, dynamic>?;
      if (currentMap != null) {
        resume = ResumeInfo(
          lessonId: currentMap['id'] as String? ?? '',
          topic: currentMap['topic'] as String? ?? 'Python Dasar',
          title: currentMap['title'] as String? ?? 'Bab Lanjutan',
          description: 'Lanjutkan progres belajar pada bab ini.',
          progress:
              ((currentMap['progressPercent'] as num?)?.toDouble() ?? 0) /
              100.0,
        );
      }

      // Skills radar
      final skillsMap = <String, double>{
        'Logika': 0,
        'Variabel': 0,
        'Perulangan': 0,
        'Fungsi': 0,
      };
      final skillsList = skillsData['skills'] as List<dynamic>?;
      if (skillsList != null) {
        for (final item in skillsList) {
          if (item is Map<String, dynamic>) {
            final name = item['name'] as String?;
            final score = (item['score'] as num?)?.toDouble() ?? 0.0;
            if (name != null) {
              skillsMap[name] = score;
            }
          }
        }
      }

      // Modules list
      final lessonItems = lessonsData['items'] as List<dynamic>? ?? [];
      final modules = <LearningModule>[];
      var firstId = 'pengenalan-variabel';

      for (var i = 0; i < lessonItems.length; i++) {
        final item = lessonItems[i] as Map<String, dynamic>;
        final id = item['id'] as String? ?? '';
        if (i == 0) firstId = id;

        final statusStr = item['status'] as String? ?? 'locked';
        final status = switch (statusStr) {
          'completed' => ModuleStatus.completed,
          'active' => ModuleStatus.active,
          // Minggu 9: bab terbuka (bukan lagi terkunci berantai).
          'available' => ModuleStatus.available,
          _ => ModuleStatus.locked,
        };

        modules.add(
          LearningModule(
            id: id,
            order: item['orderIndex'] as int? ?? (i + 1),
            title: item['title'] as String? ?? 'Modul ${i + 1}',
            description: item['topic'] as String? ?? 'Kurikulum Dasar',
            topic: item['topic'] as String? ?? '',
            status: status,
            requirement: item['requiredLessonTitle'] != null
                ? 'Selesaikan ${item['requiredLessonTitle']} dulu'
                : null,
          ),
        );
      }

      if (modules.isEmpty) {
        throw Exception('No modules returned from API');
      }

      return DashboardData(
        completedChallenges: completedChallenges,
        totalChallenges: totalChallenges,
        userXp: userXp,
        resume: resume,
        firstLessonId: firstId,
        skills: skillsMap,
        pathTitle: 'Python Dasar & Web',
        pathSubtitle: 'Alur kurikulum bertahap untuk siswa SMK',
        modules: modules,
      );
    } on DioException {
      // Jawaban server (401/403/4xx/5xx) maupun offline diteruskan supaya
      // UI jujur — Week 9 tidak ada lagi fallback data tiruan.
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
