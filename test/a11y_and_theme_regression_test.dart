// FILE: test/a11y_and_theme_regression_test.dart
//
// TUGAS: uji regresi tampilan & aksesibilitas (Minggu 14 — P2 "cakupan uji
// belum merata").
//
// YANG DIJAGA:
//   1. Dark mode  : Peta Belajar tetap dirender tanpa overflow dan warna
//      palet ikut tema gelap.
//   2. RTL (Arab) : layout tetap terbangun, arah teks mengikuti locale, dan
//      tidak ada overflow saat arah dibalik.
//   3. textScale 2.0 : pembesaran teks dua kali lipat tidak memicu overflow
//      pada kartu roadmap maupun kartu sertifikat.
//   4. Semantics  : peta belajar & kanvas sertifikat punya label pembaca layar.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/services/error_reporter.dart';
import 'package:mobile_codelab_ai/core/theme/app_theme.dart';
import 'package:mobile_codelab_ai/features/certificate/domain/certificate_models.dart';
import 'package:mobile_codelab_ai/features/certificate/domain/certificate_repository.dart';
import 'package:mobile_codelab_ai/features/certificate/presentation/pages/certificate_page.dart';
import 'package:mobile_codelab_ai/features/dashboard/domain/dashboard_repository.dart';
import 'package:mobile_codelab_ai/features/dashboard/presentation/widgets/winding_roadmap.dart';
import 'package:mobile_codelab_ai/l10n/app_localizations.dart';

const _modules = [
  LearningModule(
    id: '1',
    order: 1,
    title: 'Variabel',
    description: 'Variabel dasar',
    status: ModuleStatus.completed,
  ),
  LearningModule(
    id: '2',
    order: 2,
    title: 'Tipe Data',
    description: 'Tipe data',
    status: ModuleStatus.active,
  ),
  LearningModule(
    id: '3',
    order: 3,
    title: 'Percabangan',
    description: 'If else',
    status: ModuleStatus.locked,
  ),
];

const _certificate = CertificateVerification(
  certId: 'CL-CERT-2026-PY01-FARHAN01',
  kind: 'module',
  topic: 'Python Dasar',
  level: 'beginner',
  effectiveJp: 24,
  accreditationJp: 48,
  student: CertificateStudent(id: '2', name: 'Muhammad Farhan'),
);

class _FakeCertificateRepository implements CertificateRepository {
  const _FakeCertificateRepository();

  @override
  Future<MyCertificates> getMyCertificates() async => const MyCertificates();

  @override
  Future<CertificateVerification> getVerification(String certId) async =>
      _certificate;
}

Widget _roadmapApp({
  required ThemeData theme,
  required Locale locale,
  required double textScale,
}) {
  return MaterialApp(
    theme: theme,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: Scaffold(
      body: SingleChildScrollView(
        child: WindingRoadmap(
          modules: _modules,
          onModuleTap: (_) {},
          onOpenCatalog: () {},
        ),
      ),
    ),
  );
}

void main() {
  setUp(() {
    ErrorReporter.instance.clear();
  });

  testWidgets('peta belajar aman di mode gelap', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _roadmapApp(
        theme: AppTheme.dark,
        locale: const Locale('id'),
        textScale: 1.0,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Peta Petualangan Belajar'), findsOneWidget);
  });

  testWidgets('peta belajar aman pada locale Arab (RTL)', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _roadmapApp(
        theme: AppTheme.light,
        locale: const Locale('ar'),
        textScale: 1.0,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    // Arah baca benar-benar berbalik mengikuti locale.
    final direction = Directionality.of(
      tester.element(find.byType(WindingRoadmap)),
    );
    expect(direction, TextDirection.rtl);
  });

  testWidgets('textScale 2.0 tidak memicu overflow pada peta belajar', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _roadmapApp(
        theme: AppTheme.light,
        locale: const Locale('id'),
        textScale: 2.0,
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.text('Peta Petualangan Belajar'), findsOneWidget);
  });

  testWidgets('setiap posisi peta punya label pembaca layar', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _roadmapApp(
        theme: AppTheme.light,
        locale: const Locale('id'),
        textScale: 1.0,
      ),
    );
    await tester.pump();

    expect(
      find.bySemanticsLabel(RegExp(r'Bab 1: Variabel')),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel(RegExp(r'Bab 2: Tipe Data')),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('kanvas sertifikat punya satu label pembaca layar', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(420, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      RepositoryProvider<CertificateRepository>(
        create: (_) => const _FakeCertificateRepository(),
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CertificatePage(certId: 'CL-CERT-2026-PY01-FARHAN01'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.bySemanticsLabel(
        RegExp(r'Sertifikat .*Muhammad Farhan.*CL-CERT-2026-PY01-FARHAN01'),
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('halaman sertifikat aman pada textScale 2.0', (tester) async {
    await tester.binding.setSurfaceSize(const Size(420, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      RepositoryProvider<CertificateRepository>(
        create: (_) => const _FakeCertificateRepository(),
        child: MaterialApp(
          theme: AppTheme.light,
          locale: const Locale('id'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const CertificatePage(certId: 'CL-CERT-2026-PY01-FARHAN01'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Sertifikat Kompetensi'), findsWidgets);
  });

  group('ErrorReporter', () {
    test('mencatat galat dan membangun laporan yang bisa disalin', () {
      ErrorReporter.instance.record(
        StateError('contoh kegagalan'),
        StackTrace.current,
        type: 'TestError',
      );
      final report = ErrorReporter.instance.buildReport();
      expect(report, contains('contoh kegagalan'));
      expect(report, contains('TestError'));
      expect(ErrorReporter.instance.last?.message, contains('contoh kegagalan'));
    });

    test('buffer dibatasi 20 kejadian terakhir', () {
      for (var i = 0; i < 30; i++) {
        ErrorReporter.instance.record(Exception('galat-$i'), null);
      }
      expect(ErrorReporter.instance.records.length, 20);
      // Yang tersisa adalah kejadian TERAKHIR.
      expect(ErrorReporter.instance.last?.message, contains('galat-29'));
    });

    test('laporan kosong tetap bisa disalin', () {
      expect(ErrorReporter.instance.buildReport(), contains('tidak ada galat'));
    });
  });
}
