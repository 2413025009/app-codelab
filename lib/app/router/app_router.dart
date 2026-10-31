import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/teacher_register_page.dart';
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
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/challenges/presentation/pages/challenge_catalog_page.dart';
import '../../features/challenges/presentation/pages/challenge_detail_page.dart';
import '../../features/challenges/presentation/pages/submission_history_page.dart';
import '../../features/lesson/presentation/pages/lesson_catalog_page.dart';
import '../../features/lesson/presentation/pages/lesson_reader_page.dart';
import '../../features/playground/presentation/pages/playground_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../shell/app_shell.dart';
import 'app_routes.dart';

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(this._cubit) {
    _sub = _cubit.stream.listen((_) => notifyListeners());
  }

  final AuthCubit _cubit;
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

GoRouter appRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    refreshListenable: _AuthNotifier(authCubit),
    redirect: (context, state) {
      final isAuthenticated = authCubit.state.isAuthenticated;
      // Minggu 9: guru paruh UTS belum punya dashboard penuh → placeholder.
      final isTeacher = (authCubit.state.user?.role ?? 'student') == 'teacher';
      final rawPath = state.uri.path;
      // Kompatibilitas tautan lama: /studio-pengajar/... → /materi-pengajar/...
      final legacyPath = _legacyTeacherPath(rawPath);
      if (legacyPath != null) return legacyPath;
      final path = rawPath;
      final isLogin = path == AppRoutes.login;
      final isRegister =
          path == AppRoutes.register || path == AppRoutes.registerTeacher;
      final isTeacherHome = path == AppRoutes.teacherHome;

      if (!isAuthenticated && !isLogin && !isRegister) {
        return AppRoutes.login;
      }

      if (isAuthenticated && (isLogin || isRegister)) {
        return isTeacher ? AppRoutes.teacherHome : AppRoutes.dashboard;
      }

      // Guru hanya diizinkan di area guru (ruang kelas, studio materi, profil,
      // pengaturan, analisa) — halaman siswa dialihkan ke ruang kelas.
      final isTeacherArea =
          isTeacherHome ||
          path == AppRoutes.teacherArchivedClasses ||
          path == AppRoutes.teacherProfile ||
          path == AppRoutes.teacherSettings ||
          path == AppRoutes.teacherStudio ||
          path.startsWith('/materi-pengajar/') ||
          path == AppRoutes.teacherAnalytics ||
          path.startsWith('/analisa-pengajar/');
      if (isAuthenticated && isTeacher && !isTeacherArea) {
        return AppRoutes.teacherHome;
      }
      if (isAuthenticated && !isTeacher && isTeacherArea) {
        return AppRoutes.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginPage(
          prefillEmail: state.uri.queryParameters['email'],
          justRegistered: state.uri.queryParameters['registered'] == '1',
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.registerTeacher,
        builder: (context, state) => const TeacherRegisterPage(),
      ),
      // Kerangka navigasi bawah instruktur/guru (Minggu 11-12)
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
      // Halaman fitur guru pushed on top
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
      GoRoute(
        path: AppRoutes.catalog,
        builder: (context, state) => const LessonCatalogPage(),
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
    ],
  );
}

/// Menerjemahkan URL Studio versi lama ke URL baru yang lebih terbaca.
/// Contoh: /studio-pengajar/materi/12/babs/3/edit
///      → /materi-pengajar/12/silabus/3/edit
String? _legacyTeacherPath(String path) {
  // Tautan lama "/analitik-pengajar" diarahkan ke nama baru "/analisa-pengajar".
  const legacyAnalytics = '/analitik-pengajar';
  if (path == legacyAnalytics) return AppRoutes.teacherAnalytics;
  if (path.startsWith('$legacyAnalytics/')) {
    return AppRoutes.teacherAnalyticsRoute(
      path.substring(legacyAnalytics.length + 1),
    );
  }

  if (!path.startsWith('/studio-pengajar')) return null;

  final babEdit = RegExp(
    r'^/studio-pengajar/materi/([^/]+)/babs/([^/]+)/edit$',
  ).firstMatch(path);
  if (babEdit != null) {
    return '/materi-pengajar/${babEdit.group(1)}/silabus/${babEdit.group(2)}/edit';
  }

  final babCreate = RegExp(
    r'^/studio-pengajar/materi/([^/]+)/babs/baru$',
  ).firstMatch(path);
  if (babCreate != null) {
    return '/materi-pengajar/${babCreate.group(1)}/silabus/baru';
  }

  final babList = RegExp(
    r'^/studio-pengajar/materi/([^/]+)/babs$',
  ).firstMatch(path);
  if (babList != null) {
    return '/materi-pengajar/${babList.group(1)}/silabus';
  }

  final materialEdit = RegExp(
    r'^/studio-pengajar/materi/([^/]+)/edit$',
  ).firstMatch(path);
  if (materialEdit != null) {
    return '/materi-pengajar/${materialEdit.group(1)}/edit';
  }

  if (path == '/studio-pengajar/materi/baru') {
    return '/materi-pengajar/baru';
  }

  return AppRoutes.teacherStudio;
}
