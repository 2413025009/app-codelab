import '../domain/challenge_repository.dart';

/// Static data mirroring the stitch challenge screens.
/// The test runner evaluates logic boundaries:
/// the starter code uses `>` (a boundary bug), so the first run fails case 3 and the
/// student must switch to `>=` — which unlocks 100% score and awards XP.
class MockChallengeRepository implements ChallengeRepository {
  static const _latency = Duration(milliseconds: 600);
  static const kkmChallengeId = 'penentuan-kelulusan-nilai-rpl';

  static const starterCode = 'def cek_kelulusan(nilai):\n'
      '    if nilai > 75:\n'
      '        return "LULUS"\n'
      '    else:\n'
      '        return "REMIDIAL"\n';

  @override
  Future<ChallengeCatalog> getCatalog({int? userXp}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final xp = userXp ?? 115; // default simulated demo XP

    // P1-10: dataset mock mensinkron seed DB (8 tantangan, 1 selesai,
    // XP dari tantangan yang tamat saja) — bukan lagi 30 soal fiktif.
    return ChallengeCatalog(
      total: 8,
      completed: 1,
      xpEarned: 25,
      userXp: xp,
      groups: [
        ChallengeGroup(
          title: 'Percabangan & Logika',
          challenges: [
            ChallengeSummary(
              id: 'validasi-tahun-kabisat',
              title: 'Validasi Tahun Kabisat',
              level: ChallengeLevel.beginner,
              topicTag: 'Logika',
              xp: 25,
              status: ChallengeStatus.completed,
              minXpRequired: 0,
              isLocked: false,
              estimatedMinutes: 10,
              testCount: 4,
            ),
            ChallengeSummary(
              id: kkmChallengeId,
              title: 'Penentuan Kelulusan Nilai RPL',
              level: ChallengeLevel.beginner,
              topicTag: 'Logika',
              xp: 40,
              status: ChallengeStatus.inProgress,
              minXpRequired: 0,
              isLocked: false,
              estimatedMinutes: 10,
              testCount: 3,
            ),
            ChallengeSummary(
              id: 'sistem-diskon-bertingkat',
              title: 'Sistem Diskon Bertingkat',
              level: ChallengeLevel.intermediate,
              topicTag: 'Aritmatika',
              xp: 50,
              status: ChallengeStatus.notStarted,
              minXpRequired: 40,
              isLocked: xp < 40,
              estimatedMinutes: 15,
              testCount: 3,
            ),
          ],
        ),
        ChallengeGroup(
          title: 'Perulangan & Loop',
          challenges: [
            ChallengeSummary(
              id: 'cetak-pola-bintang-piramida',
              title: 'Cetak Pola Bintang Piramida',
              level: ChallengeLevel.beginner,
              topicTag: 'For Loop',
              xp: 30,
              status: ChallengeStatus.notStarted,
              minXpRequired: 20,
              isLocked: xp < 20,
              estimatedMinutes: 15,
              testCount: 3,
            ),
            ChallengeSummary(
              id: 'validasi-pin-atm',
              title: 'Validasi PIN ATM Maksimal 3x',
              level: ChallengeLevel.intermediate,
              topicTag: 'While Loop',
              xp: 45,
              status: ChallengeStatus.notStarted,
              minXpRequired: 50,
              isLocked: xp < 50,
              estimatedMinutes: 20,
              testCount: 3,
            ),
          ],
        ),
        ChallengeGroup(
          title: 'Mini-Proyek Terapan',
          isMiniProject: true,
          challenges: [
            ChallengeSummary(
              id: 'sistem-kasir-kantin-sekolah',
              title: 'Sistem Kasir Kantin Sekolah',
              level: ChallengeLevel.intermediate,
              topicTag: 'Real-World',
              xp: 150,
              status: ChallengeStatus.notStarted,
              minXpRequired: 80,
              isLocked: xp < 80,
              isMiniProject: true,
              estimatedMinutes: 45,
              testCount: 4,
              subtitle: 'Hitung total belanja, diskon khusus siswa, cetak struk konsol',
            ),
            ChallengeSummary(
              id: 'kalkulator-tarif-parkir-otomatis',
              title: 'Kalkulator Tarif Parkir Otomatis',
              level: ChallengeLevel.beginner,
              topicTag: 'Real-World',
              xp: 100,
              status: ChallengeStatus.notStarted,
              minXpRequired: 60,
              isLocked: xp < 60,
              isMiniProject: true,
              estimatedMinutes: 30,
              testCount: 4,
              subtitle: 'Kalkulasi progresif motor & mobil dengan batas tarif harian',
            ),
            ChallengeSummary(
              id: 'aplikasi-manajemen-nilai-siswa',
              title: 'Aplikasi Manajemen Nilai Siswa',
              level: ChallengeLevel.intermediate,
              topicTag: 'Real-World',
              xp: 200,
              status: ChallengeStatus.notStarted,
              minXpRequired: 150,
              isLocked: xp < 150,
              isMiniProject: true,
              estimatedMinutes: 60,
              testCount: 4,
              subtitle: 'Predikat raport, rata-rata bobot teori & praktik, ranking kelas',
            ),
          ],
        ),
      ],
    );
  }

  @override
  Future<ChallengeDetail> getDetail(String id, {int? userXp}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final xp = userXp ?? 115;

    if (id == kkmChallengeId) {
      return const ChallengeDetail(
        id: kkmChallengeId,
        title: 'Penentuan Kelulusan Nilai RPL',
        levelLabel: 'Pemula',
        xp: 40,
        minutes: 10,
        position: 'TANTANGAN 2 DARI 3',
        instruction: 'Buatlah fungsi cek_kelulusan(nilai) yang mengevaluasi angka input siswa dan mengembalikan string: "LULUS" bila nilai siswa minimal 75 (nilai >= 75), dan "REMIDIAL" bila nilai siswa berada di bawah 75 (nilai < 75).',
        rules: [
          RuleItem(text: '"LULUS" bila nilai siswa minimal 75 (nilai >= 75).', positive: true),
          RuleItem(text: '"REMIDIAL" bila nilai siswa berada di bawah 75 (nilai < 75).', positive: false),
        ],
        samples: [
          SampleCase(label: 'Kasus Sampel 01', condition: 'Kondisi Lolos', call: 'cek_kelulusan(80)', result: '"LULUS"'),
          SampleCase(label: 'Kasus Sampel 02', condition: 'Kondisi Remedial', call: 'cek_kelulusan(60)', result: '"REMIDIAL"'),
        ],
        starterCode: starterCode,
        minXpRequired: 0,
        isLocked: false,
        category: 'Percabangan & Logika',
        testCases: [
          TestCaseResult(title: 'Kasus Uji 1 (Publik)', input: 'nilai = 80', expected: '"LULUS"', output: '"LULUS"', passed: true, weight: 30),
          TestCaseResult(title: 'Kasus Uji 2 (Publik)', input: 'nilai = 60', expected: '"REMIDIAL"', output: '"REMIDIAL"', passed: true, weight: 30),
          TestCaseResult(title: 'Kasus Uji 3 (Uji Batas KKM)', input: 'nilai = 75', expected: '"LULUS"', output: '"LULUS"', passed: true, hidden: true, weight: 40),
        ],
        // Demo: tantangan KKM sudah selesai di akun seed → tampil hasil
        // pengujian otomatis, bukan contoh pemanggilan, sesuai desain stitch.
        status: 'completed',
      );
    }

    if (id == 'validasi-tahun-kabisat') {
      return const ChallengeDetail(
        id: 'validasi-tahun-kabisat',
        title: 'Validasi Tahun Kabisat',
        levelLabel: 'Pemula',
        xp: 25,
        minutes: 10,
        position: 'TANTANGAN 1 DARI 3',
        instruction: 'Buatlah fungsi cek_kabisat(tahun) yang menentukan apakah suatu tahun adalah tahun kabisat (habis dibagi 400 atau habis dibagi 4 tetapi tidak habis dibagi 100). Kembalikan string "KABISAT" jika ya, dan "BUKAN KABISAT" jika bukan.',
        rules: [
          RuleItem(text: '"KABISAT" bila tahun habis dibagi 400 atau habis dibagi 4 dan bukan abad.', positive: true),
          RuleItem(text: '"BUKAN KABISAT" bila tidak memenuhi syarat.', positive: false),
        ],
        samples: [
          SampleCase(label: 'Kasus 01', condition: 'Kabisat 2024', call: 'cek_kabisat(2024)', result: '"KABISAT"'),
          SampleCase(label: 'Kasus 02', condition: 'Tahun Biasa 2023', call: 'cek_kabisat(2023)', result: '"BUKAN KABISAT"'),
        ],
        starterCode: 'def cek_kabisat(tahun):\n    if (tahun % 400 == 0) or (tahun % 4 == 0 and tahun % 100 != 0):\n        return "KABISAT"\n    return "BUKAN KABISAT"\n',
        minXpRequired: 0,
        isLocked: false,
        category: 'Percabangan & Logika',
      );
    }

    if (id == 'sistem-kasir-kantin-sekolah') {
      return ChallengeDetail(
        id: 'sistem-kasir-kantin-sekolah',
        title: 'Sistem Kasir Kantin Sekolah',
        levelLabel: 'Menengah',
        xp: 150,
        minutes: 45,
        position: 'MINI-PROYEK TERAPAN',
        instruction: 'Buat fungsi transaksi_kantin(total_kotor, is_siswa). Siswa mendapat diskon 15%. Jika total akhir > 50.000, dapat potongan tambahan Rp 5.000.',
        rules: const [
          RuleItem(text: 'Diskon 15% khusus jika is_siswa = True.', positive: true),
          RuleItem(text: 'Potongan Rp 5.000 jika total belanja melebihi Rp 50.000.', positive: true),
        ],
        samples: const [
          SampleCase(label: 'Kasus 01', condition: 'Siswa Belanja Besar', call: 'transaksi_kantin(70000, True)', result: '54500'),
        ],
        starterCode: 'def transaksi_kantin(total_kotor, is_siswa):\n    total = total_kotor\n    if is_siswa:\n        total = int(total * 0.85)\n    if total > 50000:\n        total -= 5000\n    return total\n',
        minXpRequired: 80,
        isLocked: xp < 80,
        category: 'Mini-Proyek Terapan',
      );
    }

    final catalog = await getCatalog(userXp: xp);
    final summary = catalog.groups.expand((g) => g.challenges).firstWhere(
          (c) => c.id == id,
          orElse: () => const ChallengeSummary(
            id: 'unknown',
            title: 'Tantangan',
            level: ChallengeLevel.beginner,
            topicTag: '',
            xp: 20,
            status: ChallengeStatus.notStarted,
          ),
        );

    return ChallengeDetail(
      id: id,
      title: summary.title,
      levelLabel: summary.level.label,
      xp: summary.xp,
      minutes: summary.estimatedMinutes,
      position: summary.isMiniProject ? 'MINI-PROYEK TERAPAN' : 'TANTANGAN',
      instruction: 'Instruksi lengkap untuk "${summary.title}" siap dikerjakan. Tulis fungsi Python sesuai spesifikasi.',
      rules: const [],
      samples: const [],
      starterCode: '# Tulis solusimu di sini\n',
      minXpRequired: summary.minXpRequired,
      isLocked: summary.isLocked,
      category: summary.isMiniProject ? 'Mini-Proyek Terapan' : 'Percabangan & Logika',
    );
  }

  @override
  Future<RunReport> runTests(String challengeId, String code) async {
    await Future<void>.delayed(_latency);
    final normalized = code.replaceAll(' ', '');
    final handlesBoundary = normalized.contains('>=75') || (normalized.contains('<75') && !normalized.contains('<=75'));
    final hasReturns = code.contains('LULUS') && code.contains('REMIDIAL');

    final case1 = hasReturns;
    final case2 = hasReturns;
    final case3 = hasReturns && handlesBoundary;

    return RunReport(
      millis: 48,
      results: [
        TestCaseResult(
          title: 'Kasus Uji 1 (Publik)',
          input: 'nilai = 80',
          expected: '"LULUS"',
          output: case1 ? '"LULUS"' : 'None',
          passed: case1,
          weight: 30,
        ),
        TestCaseResult(
          title: 'Kasus Uji 2 (Publik)',
          input: 'nilai = 60',
          expected: '"REMIDIAL"',
          output: case2 ? '"REMIDIAL"' : 'None',
          passed: case2,
          weight: 30,
        ),
        TestCaseResult(
          title: 'Kasus Uji 3 (Uji Batas KKM)',
          input: 'nilai = 75',
          expected: '"LULUS"',
          output: case3 ? '"LULUS"' : (hasReturns ? '"REMIDIAL"' : 'None'),
          passed: case3,
          hidden: true,
          weight: 40,
        ),
      ],
    );
  }

  @override
  Future<SubmissionResult> submitCode(String challengeId, String code) async {
    final report = await runTests(challengeId, code);
    final status = report.allPassed
        ? SubmissionStatus.passed
        : (report.results.isEmpty ? SubmissionStatus.error : SubmissionStatus.failed);

    return SubmissionResult(
      report: report,
      submissionId: 'mock-sub-${DateTime.now().millisecondsSinceEpoch}',
      status: status,
      newXpTotal: report.allPassed ? 155 : 115,
      xpEarned: report.allPassed ? 40 : 0,
    );
  }

  @override
  Future<SubmissionHistory> getHistory(String challengeId) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const SubmissionHistory(
      challengeTitle: 'Percabangan If-Else',
      context: 'Python Dasar • Modul 3',
      bestScore: 100,
      submissions: [
        Submission(
          number: 3,
          status: SubmissionStatus.passed,
          score: 100,
          detail: 'Waktu: 0.08s • Hari ini, 14:20',
          whenLabel: 'Terbaru',
          hintsUsed: 2,
          code: 'def cek_kelulusan(nilai):\n'
              '    if nilai >= 75:\n'
              '        return "LULUS"\n'
              '    else:\n'
              '        return "REMIDIAL"',
          aiReview: 'Logika penanganan operator ≥ sudah tepat pada batas KKM 75. Kode bersih, terstruktur rapi, dan hemat memori.',
        ),
        Submission(
          number: 2,
          status: SubmissionStatus.failed,
          score: 65,
          detail: 'Waktu: 0.12s • Kemarin, 16:45',
          whenLabel: '',
          problem: 'Gagal di Kasus Batas Nilai KKM 75',
          code: 'def cek_kelulusan(nilai):\n'
              '    if nilai > 75:\n'
              '        return "LULUS"\n'
              '    else:\n'
              '        return "REMIDIAL"',
        ),
        Submission(
          number: 1,
          status: SubmissionStatus.error,
          score: 0,
          detail: "SyntaxError: expected ':' · 2 hari lalu",
          whenLabel: '',
          code: 'def cek_kelulusan(nilai)\n'
              '    if nilai > 75\n'
              '        return "LULUS"',
        ),
      ],
    );
  }
}
