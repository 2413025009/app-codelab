import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/theme/app_theme.dart';
import 'package:mobile_codelab_ai/features/dashboard/domain/dashboard_repository.dart';
import 'package:mobile_codelab_ai/features/dashboard/presentation/widgets/dashboard_widgets.dart';
import 'package:mobile_codelab_ai/features/dashboard/presentation/widgets/winding_roadmap.dart';

void main() {
  group('Dashboard Stitch v2 Widgets Tests', () {
    testWidgets('ResumeCard renders topic, bab tracker, and progress percent', (tester) async {
      const resume = ResumeInfo(
        lessonId: 'percabangan-if-else',
        topic: 'Python Dasar & Logika',
        title: '1. Pengenalan Logika Koding',
        description: 'Memahami evaluasi kondisi',
        progress: 0.35,
      );

      var pressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: ResumeCard(
              resume: resume,
              currentChapter: 3,
              totalChapters: 7,
              onPressed: () => pressed = true,
            ),
          ),
        ),
      );

      expect(find.text('PYTHON DASAR & LOGIKA'), findsOneWidget);
      expect(find.text('Bab 3 dari 7'), findsOneWidget);
      expect(find.text('1. Pengenalan Logika Koding'), findsOneWidget);
      expect(find.text('35% Selesai'), findsOneWidget);

      await tester.tap(find.byType(ResumeCard));
      expect(pressed, true);
    });

    testWidgets('WindingRoadmap renders 7 positions, active banner, and goal node', (tester) async {
      const modules = [
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
          status: ModuleStatus.completed,
        ),
        LearningModule(
          id: '3',
          order: 3,
          title: 'If-Else Logika',
          description: 'Branching logika',
          status: ModuleStatus.active,
        ),
        LearningModule(
          id: '4',
          order: 4,
          title: 'Review Kuis',
          description: 'Uji pemahaman',
          status: ModuleStatus.locked,
        ),
        LearningModule(
          id: '5',
          order: 5,
          title: 'While Loop',
          description: 'Perulangan while',
          status: ModuleStatus.locked,
        ),
        LearningModule(
          id: '6',
          order: 6,
          title: 'For Loop',
          description: 'Perulangan for',
          status: ModuleStatus.locked,
        ),
      ];

      LearningModule? tappedModule;
      var catalogOpened = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light,
          home: Scaffold(
            body: SingleChildScrollView(
              child: WindingRoadmap(
                modules: modules,
                onModuleTap: (m) => tappedModule = m,
                onOpenCatalog: () => catalogOpened = true,
              ),
            ),
          ),
        ),
      );

      await tester.pump();

      // Header verification
      expect(find.text('Peta Petualangan Belajar'), findsOneWidget);
      expect(find.text('7 Pos Menuju Sertifikat'), findsOneWidget);
      expect(find.text('Bab 3 Aktif'), findsOneWidget);

      // Node verification
      expect(find.text('1. Variabel'), findsOneWidget);
      expect(find.text('2. Tipe Data'), findsOneWidget);
      expect(find.text('3. If-Else Logika'), findsOneWidget);
      expect(find.text('Sedang Berjalan'), findsOneWidget);
      expect(find.text('Mulai di sini! 🚀'), findsOneWidget);
      expect(find.text('+50 XP'), findsNWidgets(2)); // Variabel & Tipe Data

      // Certificate goal node
      expect(find.text('Sertifikat Modul'), findsOneWidget);
      expect(find.text('Target Kelulusan'), findsOneWidget);

      // Test catalog button
      await tester.ensureVisible(find.text('Katalog Materi'));
      await tester.tap(find.text('Katalog Materi'));
      expect(catalogOpened, true);

      // Test active module tap
      await tester.ensureVisible(find.text('3. If-Else Logika'));
      await tester.tap(find.text('3. If-Else Logika'));
      expect(tappedModule?.id, '3');
    });
  });
}
