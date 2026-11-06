// FILE: lib/app/router/teacher_routes.dart
//
// TUGAS: rute area pengajar — kerangka navigasi bawah (beranda, studio,
// analisa kelas, profil) plus halaman fitur yang dibuka di atasnya.
import 'package:go_router/go_router.dart';

import '../../features/teacher/domain/teacher_models.dart';
import '../../features/teacher/presentation/pages/bab_editor_page.dart';
import '../../features/teacher/presentation/pages/bab_list_page.dart';
import '../../features/teacher/presentation/pages/teacher_analytics_picker_page.dart';
import '../../features/teacher/presentation/pages/teacher_archived_classes_page.dart';
import '../../features/teacher/presentation/pages/teacher_class_analytics_page.dart';
import '../../features/teacher/presentation/pages/teacher_home_page.dart';
import '../../features/teacher/presentation/pages/teacher_material_form_page.dart';
import '../../features/teacher/presentation/pages/teacher_profile_page.dart';
import '../../features/teacher/presentation/pages/teacher_settings_page.dart';
import '../../features/teacher/presentation/pages/teacher_slide_editor_page.dart';
import '../../features/teacher/presentation/pages/teacher_studio_page.dart';
import '../../features/teacher/presentation/shell/teacher_shell.dart';
import 'app_routes.dart';

/// Seluruh rute area pengajar. Semua URL mengikuti konvensi NAMALAYAR-ROLE.
List<RouteBase> teacherRoutes() {
  return [
    // Kerangka navigasi bawah instruktur/guru (Minggu 11-12).
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return TeacherShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherHome,
              builder: (context, state) => const TeacherHomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherStudio,
              builder: (context, state) => const TeacherStudioPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherAnalytics,
              builder: (context, state) => const TeacherAnalyticsPickerPage(),
              routes: [
                GoRoute(
                  path: ':classId',
                  builder: (context, state) {
                    final classId = state.pathParameters['classId'] ?? '';
                    return TeacherClassAnalyticsPage(classId: classId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.teacherProfile,
              builder: (context, state) => const TeacherProfilePage(),
            ),
          ],
        ),
      ],
    ),

    // Halaman fitur guru yang dibuka di atas kerangka navigasi.
    GoRoute(
      path: AppRoutes.teacherSettings,
      builder: (context, state) => const TeacherSettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.teacherArchivedClasses,
      builder: (context, state) => const TeacherArchivedClassesPage(),
    ),
    GoRoute(
      path: AppRoutes.teacherMaterialCreate,
      builder: (context, state) => const TeacherMaterialFormPage(),
    ),
    GoRoute(
      path: AppRoutes.teacherMaterialEditPattern,
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final initial = state.extra as TeacherLesson?;
        return TeacherMaterialFormPage(lessonId: id, initialLesson: initial);
      },
    ),
    GoRoute(
      path: AppRoutes.teacherBabListPattern,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        return BabListPage(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: AppRoutes.teacherBabCreatePattern,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        return BabEditorPage(lessonId: lessonId);
      },
    ),
    GoRoute(
      path: AppRoutes.teacherBabEditPattern,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        final babId = state.pathParameters['babId'];
        final initial = state.extra as Bab?;
        return BabEditorPage(
          lessonId: lessonId,
          babId: babId,
          initialBab: initial,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.teacherSlideEditorPattern,
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] ?? '';
        final babId = state.pathParameters['babId'] ?? 'baru';
        final type = (state.pathParameters['type'] ?? 'theory').toUpperCase();
        final index = int.tryParse(state.pathParameters['index'] ?? '0') ?? 0;
        final args = state.extra as SlideEditorArgs?;
        return TeacherSlideEditorPage(
          lessonId: lessonId,
          babId: babId,
          slideType: type,
          slideIndex: index,
          initialSlide: args?.slide,
          xpReward: args?.xpReward ?? 50,
        );
      },
    ),
  ];
}
