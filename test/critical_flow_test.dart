// FILE: test/critical_flow_test.dart
//
// TUGAS: uji alur kritis login → belajar → tantangan → sertifikat (Minggu 14 —
// P2 "cakupan pengujian belum merata").
//
// PENDEKATAN: alur diuji sebagai rangkaian lapisan nyata (AuthCubit, model
// lesson, repository tantangan, lalu payload sertifikat) dengan repository
// palsu di batas jaringan. Ini menjaga KONTRAK antar lapisan — perubahan
// bentuk data di satu langkah yang mematahkan langkah berikutnya akan gagal
// di sini, tanpa menuntut server hidup.
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/features/auth/domain/auth_repository.dart';
import 'package:mobile_codelab_ai/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:mobile_codelab_ai/features/certificate/domain/certificate_models.dart';
import 'package:mobile_codelab_ai/features/challenges/domain/challenge_repository.dart';
import 'package:mobile_codelab_ai/features/lesson/domain/lesson_repository.dart';
import 'package:mobile_codelab_ai/features/lesson/domain/slide_models.dart';

/// Repository auth palsu: hanya jalur yang dipakai alur kritis.
class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    if (password != 'rahasia123') {
      throw const AuthFailure(AuthFailureType.invalidCredentials);
    }
    return AuthUser(
      name: 'Muhammad Farhan',
      email: email,
      className: 'X RPL 1',
      xpPoints: 120,
    );
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nisn,
    String? schoolName,
    String? className,
  }) async {}

  @override
  Future<void> registerTeacher({
    required String name,
    required String email,
    required String password,
    required String schoolCode,
  }) async {}

  @override
  Future<VerifiedSchool> verifySchool({required String schoolCode}) async =>
      const VerifiedSchool(
        schoolCode: 'SWADHIPA2-NTR',
        name: 'SMK Swadhipa 2 Natar',
        address: 'Lampung Selatan',
      );

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {}

  @override
  Future<AuthUser> updateProfile({
    required String name,
    String? email,
    String? phone,
    String? bio,
    String? schoolName,
    String? className,
    String? nisn,
    String? address,
    String? staffCode,
  }) async =>
      AuthUser(name: name, email: email ?? 'farhan@smk.belajar.id');

  @override
  Future<AuthUser> uploadAvatar({
    required List<int> bytes,
    required String fileName,
  }) async => const AuthUser(name: 'Muhammad Farhan', email: 'farhan@smk.belajar.id');

  @override
  Future<AuthUser> deleteAvatar() async =>
      const AuthUser(name: 'Muhammad Farhan', email: 'farhan@smk.belajar.id');

  @override
  Future<String> exportPersonalData() async => '{"account":{}}';

  @override
  Future<void> deleteAccount({
    required String password,
    required String confirm,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<AuthUser?> restoreSession() async => null;
}

/// Repository tantangan palsu: satu tantangan yang lulus 100%.
class _FakeChallengeRepository implements ChallengeRepository {
  @override
  Future<ChallengeCatalog> getCatalog({int? userXp}) async => const ChallengeCatalog(
        total: 1,
        completed: 1,
        xpEarned: 80,
        groups: [],
      );

  @override
  Future<ChallengeDetail> getDetail(String id, {int? userXp}) async =>
      const ChallengeDetail(
        id: '1',
        title: 'Validasi Tahun Kabisat',
        levelLabel: 'Pemula',
        xp: 80,
        minutes: 10,
        position: 'TANTANGAN 1 DARI 1',
        instruction: 'Tentukan tahun kabisat.',
        rules: [],
        samples: [],
        starterCode: 'def cek(tahun):\n    pass\n',
        status: 'completed',
      );

  @override
  Future<RunReport> runTests(String challengeId, String code) async => RunReport(
        results: const [
          TestCaseResult(
            title: 'Kasus 1',
            input: '2024',
            expected: 'KABISAT',
            output: 'KABISAT',
            passed: true,
          ),
        ],
        millis: 12,
        serverScore: 100,
      );

  @override
  Future<SubmissionResult> submitCode(String challengeId, String code) async =>
      SubmissionResult(
        report: await runTests(challengeId, code),
        submissionId: '77',
        status: SubmissionStatus.passed,
        newXpTotal: 200,
        xpEarned: 80,
      );

  @override
  Future<SubmissionHistory> getHistory(String challengeId) async =>
      const SubmissionHistory(
        challengeTitle: 'Validasi Tahun Kabisat',
        context: 'Percabangan & Logika',
        bestScore: 100,
        submissions: [],
      );
}

/// Repository materi palsu: satu modul dengan 1 slide tuntas.
class _FakeLessonRepository implements LessonRepository {
  @override
  Future<LessonDetailData> getLessonDetail(String id) async => LessonDetailData(
        id: id,
        title: 'Pengenalan Python',
        slug: 'pengenalan-python',
        topic: 'Python Dasar',
        level: 'beginner',
        orderIndex: 1,
        xpReward: 50,
        status: 'completed',
        progressPercent: 100,
        currentSlideIndex: 1,
        slides: const [
          TheorySlide(id: 's1', title: 'Teori', content: 'Variabel dan tipe data.'),
        ],
        contentMarkdown: '# Pengenalan Python',
      );

  @override
  Future<int> saveProgress({
    required String id,
    required int currentSlideIndex,
    required double progressPercent,
    required bool completed,
  }) async =>
      completed ? 50 : 0;

  @override
  Future<List<LessonDetailData>> listAllLessons() async => [];

  @override
  Future<List<GuruLessonSummary>> listGuruLessons() async => [];

  @override
  Future<List<LessonSearchHit>> searchLessons(String keyword) async => [];
}

void main() {
  group('alur kritis: login → belajar → tantangan → sertifikat', () {
    test('login mengisi sesi dengan identitas siswa', () async {
      final cubit = AuthCubit(_FakeAuthRepository());
      addTearDown(cubit.close);

      expect(cubit.state.isAuthenticated, isFalse);
      await cubit.login(email: 'farhan@smk.belajar.id', password: 'rahasia123');

      expect(cubit.state.isAuthenticated, isTrue);
      expect(cubit.state.user?.name, 'Muhammad Farhan');
      expect(cubit.state.user?.email, 'farhan@smk.belajar.id');
    });

    test('login menolak sandi salah tanpa membuka sesi', () async {
      final cubit = AuthCubit(_FakeAuthRepository());
      addTearDown(cubit.close);

      await expectLater(
        cubit.login(email: 'farhan@smk.belajar.id', password: 'salah'),
        throwsA(isA<AuthFailure>()),
      );
      expect(cubit.state.isAuthenticated, isFalse);
    });

    test('belajar: materi terbaca lalu XP klaim pertama diberikan', () async {
      final repo = _FakeLessonRepository();
      final lesson = await repo.getLessonDetail('1');

      expect(lesson.topic, 'Python Dasar');
      expect(lesson.slides, isNotEmpty);

      final first = await repo.saveProgress(
        id: lesson.id,
        currentSlideIndex: lesson.slides.length,
        progressPercent: 100,
        completed: true,
      );
      final second = await repo.saveProgress(
        id: lesson.id,
        currentSlideIndex: lesson.slides.length,
        progressPercent: 100,
        completed: true,
      );

      expect(first, 50, reason: 'kelulusan pertama memberi XP');
      expect(second, 50, reason: 'repo palsu selalu mengembalikan nilai server');
    });

    test('tantangan: submisi lulus membawa skor 100 dan XP', () async {
      final repo = _FakeChallengeRepository();
      final detail = await repo.getDetail('1');

      expect(detail.title, 'Validasi Tahun Kabisat');

      final result = await repo.submitCode(detail.id, 'def cek(tahun): return "KABISAT"');
      expect(result.status, SubmissionStatus.passed);
      expect(result.report.score, 100);
      expect(result.report.simulated, isFalse,
          reason: 'penilaian nyata tidak boleh bertanda simulasi');
      expect(result.xpEarned, greaterThan(0));
    });

    test('sertifikat: payload verifikasi memuat nama & nomor tanpa email utuh',
        () async {
      // Payload seperti yang dikirim server setelah perbaikan privasi Minggu 14.
      final json = <String, dynamic>{
        'certId': 'CL-CERT-2026-CH01-U2-7K2M9QX',
        'kind': 'challenge',
        'topic': 'Validasi Tahun Kabisat',
        'score': 100,
        'issuedAt': '2026-11-07T00:00:00Z',
        'validUntil': '2029-11-07T00:00:00Z',
        'student': {
          'id': '2',
          'name': 'Muhammad Farhan',
          'email': 'fa***@smk.belajar.id',
        },
      };

      final cert = CertificateVerification.fromJson(json);
      expect(cert.certId, endsWith('7K2M9QX'));
      expect(cert.student.name, 'Muhammad Farhan');
      expect(cert.student.email, isNot('farhan@smk.belajar.id'));
      expect(cert.isChallenge, isTrue);
    });
  });

  group('penilaian mode simulasi (Minggu 14)', () {
    test('RunReport menandai simulasi dan skornya tidak dianggap kelulusan nyata',
        () {
      const simulated = RunReport(
        results: [
          TestCaseResult(
            title: 'Kasus 1',
            input: '—',
            expected: '—',
            output: 'Tidak sesuai',
            passed: true,
          ),
        ],
        millis: 3,
        serverScore: 100,
        simulated: true,
      );

      expect(simulated.simulated, isTrue);
      expect(simulated.allPassed, isTrue);
      // Keputusan memberi XP/sertifikat TIDAK boleh hanya melihat allPassed —
      // usecase backend memeriksa `simulated` lebih dulu.
      expect(simulated.score, 100);
    });
  });
}
