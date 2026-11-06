// FILE: lib/app/router/auth_routes.dart
//
// TUGAS: rute area autentikasi (masuk, daftar siswa, registrasi pendidik).
// Dipisah dari app_router.dart agar redirect global tetap ringkas dan rute
// tiap area mudah ditelusuri.
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/teacher_register_page.dart';
import 'app_routes.dart';

/// Rute publik yang boleh dibuka tanpa sesi login.
List<RouteBase> authRoutes() {
  return [
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
  ];
}
