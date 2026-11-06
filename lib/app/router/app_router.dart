import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/teacher_register_page.dart';
import '../../features/certificate/presentation/pages/certificate_page.dart';
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
      // Kompatibilitas tautan lama: /materi-pengajar/..., /studio-pengajar/...,
      // /catalog, /challenge/:id, dan sejenisnya dialihkan ke nama URL baru
      // yang mengikuti judul layar + akhiran peran.
      final legacyPath =
          _legacyTeacherPath(rawPath) ?? _legacyStudentPath(rawPath);
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
          path == AppRoutes.teacherMaterialCreate ||
          path.startsWith('/edit-materi-pengajar/') ||
          path.startsWith('/silabus-bab-pengajar/') ||
          path.startsWith('/bab-builder-pengajar/') ||
          path.startsWith('/edit-bab-pengajar/') ||
          path.startsWith('/editor-slide-pengajar/') ||
          path == AppRoutes.teacherAnalytics ||
          path.startsWith('/analisa-kelas-pengajar/');
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
    ],
  );
}

/// Menerjemahkan URL Studio versi lama ke URL baru yang mengikuti judul layar
/// plus akhiran peran (konvensi NAMALAYAR-ROLE).
/// Contoh: /studio-pengajar/materi/12/babs/3/edit → /edit-bab-pengajar/12/3
///         /materi-pengajar/12/silabus/3/edit    → /edit-bab-pengajar/12/3
///         /edit-bab/12/3                        → /edit-bab-pengajar/12/3
String? _legacyTeacherPath(String path) {
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

/// Menerjemahkan URL lama area siswa & auth (termasuk nama tanpa akhiran
/// peran: /catalog, /challenge/:id, /settings) ke konvensi NAMALAYAR-ROLE.
String? _legacyStudentPath(String path) {
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
