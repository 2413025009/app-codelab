// FILE: lib/app/router/student_routes.dart
//
// TUGAS: rute area siswa — kerangka navigasi bawah (dashboard, tantangan,
// playground, profil) plus halaman materi, sertifikat, dan pengaturan.
import 'package:go_router/go_router.dart';

import '../../features/certificate/presentation/pages/certificate_catalog_page.dart';
import '../../features/certificate/presentation/pages/certificate_page.dart';
import '../../features/challenges/presentation/pages/challenge_catalog_page.dart';
import '../../features/challenges/presentation/pages/challenge_detail_page.dart';
import '../../features/challenges/presentation/pages/submission_history_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/lesson/presentation/pages/lesson_catalog_page.dart';
import '../../features/lesson/presentation/pages/lesson_reader_page.dart';
import '../../features/playground/presentation/pages/playground_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

/// Seluruh rute area siswa. Semua URL mengikuti konvensi NAMALAYAR-ROLE.
List<RouteBase> studentRoutes() {
  return [
    // Kerangka navigasi bawah siswa.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.dashboard,
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.challenges,
              builder: (context, state) => const ChallengeCatalogPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.playground,
              builder: (context, state) => const PlaygroundPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // Halaman siswa yang dibuka di atas kerangka navigasi.
    GoRoute(
      path: AppRoutes.catalog,
      builder: (context, state) => const LessonCatalogPage(),
    ),
    GoRoute(
      path: AppRoutes.certificateCatalog,
      builder: (context, state) => const CertificateCatalogPage(),
    ),
    GoRoute(
      path: AppRoutes.certificatePattern,
      builder: (context, state) {
        final certId = state.pathParameters['certId'] ?? '';
        return CertificatePage(certId: certId);
      },
    ),
    GoRoute(
      path: AppRoutes.lessonPattern,
      builder: (context, state) {
        final lessonId = state.pathParameters['id'] ?? '';
        return LessonReaderPage(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: AppRoutes.challengePattern,
      builder: (context, state) {
        final challengeId = state.pathParameters['id'] ?? '';
        return ChallengeDetailPage(challengeId: challengeId);
      },
    ),
    GoRoute(
      path: AppRoutes.historyPattern,
      builder: (context, state) {
        final challengeId = state.pathParameters['id'] ?? '';
        return SubmissionHistoryPage(challengeId: challengeId);
      },
    ),
    GoRoute(
      path: AppRoutes.lab,
      builder: (context, state) {
        final initialCode = state.extra as String?;
        return PlaygroundPage(initialCode: initialCode);
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ];
}
