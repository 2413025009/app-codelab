// FILE: lib/main.dart
//
// TUGAS: saklar nyala aplikasi — titik mulai eksekusi Flutter.
//
// FUNGSI YANG DIKELOLA:
//   - main() : (1) siapkan binding + kunci orientasi potret,
//     (2) pulihkan token sesi lama (TokenStore.restore) sehingga siswa
//     tidak perlu login ulang, (3) runApp(CodelabApp).
//   - CodelabApp : (1) bangun repositori yang MENGHIT API (SRD §2.3):
//     auth, lesson, dashboard, challenge, AI tutor — keputusan Week 9:
//     data 100% dari database/REST, seluruh repository mock DIHAPUS,
//     (2) daftarkan semua lewat
//     MultiRepositoryProvider (satu sumber data untuk seluruh layar),
//     (3) AuthCubit me-mount ulang sesi lama (restoreSession), (4)
//     GoRouter menjaga rute: belum masuk → /login.
//
// WAJIB DIUBAH BILA: repositori baru (mis. tabel projects untuk
// mini-proyek) → buat folder data/ + domain/-nya, lalu daftarkan di
// blok MultiRepositoryProvider di bawah.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;

import 'app/router/app_router.dart';
import 'core/network/token_store.dart';
import 'core/services/app_preferences.dart';
import 'core/services/sound_service.dart';
import 'core/services/teacher_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_loading_screen.dart';
import 'features/ai_tutor/data/api_tutor_repository.dart';
import 'features/ai_tutor/domain/tutor_models.dart';
import 'features/ai_tutor/domain/tutor_repository.dart';
import 'features/auth/data/api_auth_repository.dart';
import 'features/auth/domain/auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/challenges/data/api_challenge_repository.dart';
import 'features/challenges/domain/challenge_repository.dart';
import 'features/class/data/api_class_repository.dart';
import 'features/class/domain/class_repository.dart';
import 'features/dashboard/data/api_dashboard_repository.dart';
import 'features/dashboard/domain/dashboard_repository.dart';
import 'features/lesson/data/api_lesson_repository.dart';
import 'features/lesson/domain/lesson_repository.dart';
import 'features/teacher/data/api_teacher_repository.dart';
import 'features/teacher/domain/teacher_repository.dart';
import 'features/teacher/presentation/cubit/teacher_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await TokenStore.restore(); // Session token terselamatkan antar restart.
  await SoundService.init(); // Muat pengaturan efek suara lokal dari HP.
  await TeacherPreferences.init(); // Preferensi lokal khusus pengajar.
  await AppPreferences.instance.init(); // Mode gelap + bahasa aplikasi.
  runApp(const CodelabApp());
}

class CodelabApp extends StatefulWidget {
  const CodelabApp({super.key});

  @override
  State<CodelabApp> createState() => _CodelabAppState();
}

class _CodelabAppState extends State<CodelabApp> {
  /// Keputusan Week 9 (owner): aplikasi 100% REST/database — tanpa mock.
  late final AuthRepository _authRepo = ApiAuthRepository();
  late final AuthCubit _authCubit = AuthCubit(_authRepo);
  late final TutorQuota _tutorQuota = TutorQuota();
  late final TutorRepository _tutorRepo = ApiTutorRepository();
  late final GoRouter _router = appRouter(_authCubit);

  /// Boot gate: true setelah pemulihan sesi (TokenStore) selesai dicoba —
  /// layar memuat menutup paket rute sampai saat itu (bukan jeda palsu).
  bool _bootReady = false;

  @override
  void initState() {
    super.initState();
    // Pulihkan sesi tersimpan (bearer dari secure storage) + tutup boot gate.
    _restoreBoot();
  }

  Future<void> _restoreBoot() async {
    try {
      await _authCubit.restoreSession();
    } finally {
      if (mounted) {
        setState(() => _bootReady = true);
      }
    }
  }

  @override
  void dispose() {
    _authCubit.close();
    _tutorQuota.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(value: _authRepo),
        RepositoryProvider<DashboardRepository>(
          create: (_) => ApiDashboardRepository(),
        ),
        RepositoryProvider<LessonRepository>(
          create: (_) => ApiLessonRepository(),
        ),
        RepositoryProvider<ChallengeRepository>(
          create: (_) => ApiChallengeRepository(),
        ),
        // Kelas siswa (minggu 10): gabung/pratinjau/keluar rombel.
        RepositoryProvider<ClassRepository>(
          create: (_) => ApiClassRepository(),
        ),
        // Instruktur / Guru (minggu 11-12): studio materi, bab, analisa.
        RepositoryProvider<TeacherRepository>(
          create: (_) => ApiTeacherRepository(),
        ),
        RepositoryProvider<TutorRepository>.value(value: _tutorRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: _authCubit),
          BlocProvider<TeacherCubit>(
            create: (ctx) => TeacherCubit(ctx.read<TeacherRepository>()),
          ),
        ],
        child: ChangeNotifierProvider<TutorQuota>.value(
          value: _tutorQuota,
          child: ListenableBuilder(
            listenable: AppPreferences.instance,
            builder: (context, _) => MaterialApp.router(
              title: 'CodeLab AI',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              // Pilihan pengguna dari Pengaturan (Terang/Gelap/Ikuti Sistem).
              themeMode: AppPreferences.instance.themeMode,
              locale: AppPreferences.instance.locale,
              supportedLocales: const [Locale('id'), Locale('en')],
              localizationsDelegates:
                  GlobalMaterialLocalizations.delegates,
              routerConfig: _router,
              // Boot gate: layar memuat nyata selagi TokenStore dibaca.
              builder: (context, child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: !_bootReady || child == null
                    ? const AppLoadingScreen(
                        key: ValueKey<String>('codelab-boot'),
                        title: 'Memulihkan sesimu…',
                        subtitle: 'Menyiapkan lab kode di perangkat',
                        totalSteps: 1,
                        completedSteps: 0,
                        stageLabel: 'Memeriksa penyimpanan aman',
                      )
                    : KeyedSubtree(
                        key: const ValueKey<String>('codelab-app'),
                        child: child,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
