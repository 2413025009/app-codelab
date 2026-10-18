import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/features/challenges/data/mock_challenge_repository.dart';
import 'package:mobile_codelab_ai/features/challenges/domain/challenge_repository.dart';

void main() {
  group('Challenge XP Locking & Catalog Tests', () {
    late MockChallengeRepository repo;

    setUp(() {
      repo = MockChallengeRepository();
    });

    test('catalog correctly locks challenges exceeding student XP', () async {
      // User with 50 XP
      final catalog50 = await repo.getCatalog(userXp: 50);

      final miniProjects = catalog50.groups.firstWhere((g) => g.isMiniProject).challenges;
      final lockedProject = miniProjects.firstWhere((c) => c.id == 'aplikasi-manajemen-nilai-siswa');
      final unlockedProject = miniProjects.firstWhere((c) => c.id == 'sistem-kasir-kantin-sekolah');

      expect(lockedProject.minXpRequired, 150);
      expect(lockedProject.isLocked, true); // 50 < 150 -> locked!
      expect(unlockedProject.minXpRequired, 80);
      expect(unlockedProject.isLocked, true); // 50 < 80 -> locked!

      // User with 180 XP (earned from previous lessons & challenges)
      final catalog180 = await repo.getCatalog(userXp: 180);
      final miniProjects180 = catalog180.groups.firstWhere((g) => g.isMiniProject).challenges;
      final nowUnlocked = miniProjects180.firstWhere((c) => c.id == 'aplikasi-manajemen-nilai-siswa');

      expect(nowUnlocked.isLocked, false); // 180 >= 150 -> unlocked!
    });

    test('runTests fails boundary case with starter code and passes with >= operator', () async {
      // 1. Starter code (> 75)
      const starterCode = 'def cek_kelulusan(nilai):\n'
          '    if nilai > 75:\n'
          '        return "LULUS"\n'
          '    else:\n'
          '        return "REMIDIAL"\n';

      final report1 = await repo.runTests(MockChallengeRepository.kkmChallengeId, starterCode);
      expect(report1.allPassed, false);
      expect(report1.passedCount, 2);
      expect(report1.results[2].passed, false); // boundary case fails!

      // 2. Fixed code (>= 75)
      const fixedCode = 'def cek_kelulusan(nilai):\n'
          '    if nilai >= 75:\n'
          '        return "LULUS"\n'
          '    else:\n'
          '        return "REMIDIAL"\n';

      final report2 = await repo.runTests(MockChallengeRepository.kkmChallengeId, fixedCode);
      expect(report2.allPassed, true);
      expect(report2.passedCount, 3);
      expect(report2.score, 100);
      expect(report2.results[2].passed, true); // boundary case passes!
    });

    test('submitCode awards XP points when all tests are passed', () async {
      const fixedCode = 'def cek_kelulusan(nilai):\n'
          '    if nilai >= 75:\n'
          '        return "LULUS"\n'
          '    else:\n'
          '        return "REMIDIAL"\n';

      final result = await repo.submitCode(MockChallengeRepository.kkmChallengeId, fixedCode);
      expect(result.status, SubmissionStatus.passed);
      expect(result.xpEarned, 40);
      expect(result.report.allPassed, true);
    });
  });
}
