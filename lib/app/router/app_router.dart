import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/teacher_register_page.dart';
import '../../features/teacher/presentation/pages/teacher_home_page.dart';
import '../../features/teacher/presentation/pages/teacher_profile_page.dart';
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
      final path = state.matchedLocation;
      final isLogin = path == AppRoutes.login;
      final isRegister = path == AppRoutes.register || path == AppRoutes.registerTeacher;
      final isTeacherHome = path == AppRoutes.teacherHome;

      if (!isAuthenticated && !isLogin && !isRegister) {
        return AppRoutes.login;
      }

      if (isAuthenticated && (isLogin || isRegister)) {
        return isTeacher ? AppRoutes.teacherHome : AppRoutes.dashboard;
      }

      // Guru hanya diizinkan di area guru (ruang kelas & profil), regristrasi
      // guru, dan pengaturan — sisanya dialihkan ke ruang kelas.
      final isTeacherArea =
          isTeacherHome || path == AppRoutes.teacherProfile || path == AppRoutes.settings;
      if (isAuthenticated && isTeacher && !isTeacherArea) {
        return AppRoutes.teacherHome;
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
      GoRoute(
        path: AppRoutes.teacherHome,
        builder: (context, state) => const TeacherHomePage(),
      ),
      GoRoute(
        path: AppRoutes.teacherProfile,
        builder: (context, state) => const TeacherProfilePage(),
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
