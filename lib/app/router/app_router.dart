// FILE: lib/app/router/app_router.dart
//
// TUGAS: merakit GoRouter — notifier sesi, aturan redirect lintas peran, dan
// penggabungan rute per area. Definisi rute dipisah ke:
//   - auth_routes.dart    : masuk, daftar siswa, registrasi pendidik
//   - teacher_routes.dart : seluruh layar pengajar
//   - student_routes.dart : seluruh layar siswa
//   - legacy_routes.dart  : penerjemah URL lama → NAMALAYAR-ROLE
//
// WAJIB DIUBAH BILA: menambah area baru (mis. admin) → buat file rute baru
// dan tambahkan di daftar `routes` bawah, jangan menumpuk di file ini.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/cubit/auth_cubit.dart';
import 'app_routes.dart';
import 'auth_routes.dart';
import 'legacy_routes.dart';
import 'student_routes.dart';
import 'teacher_routes.dart';

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
      final legacyPath = legacyTeacherPath(rawPath) ?? legacyStudentPath(rawPath);
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
      ...authRoutes(),
      ...teacherRoutes(),
      ...studentRoutes(),
    ],
  );
}
