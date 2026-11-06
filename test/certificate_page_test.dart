// FILE: test/certificate_page_test.dart
//
// TUGAS: pengujian layar "Sertifikat Kompetensi" (Minggu 12).
// Fokus: dokumen 2 halaman tampil dari data backend — halaman 1 memuat nama
// penerima + nomor sertifikat, halaman 2 memuat silabus bab (modul) ATAU
// kriteria & kasus uji (tantangan), tanpa pernah mencampur keduanya.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/theme/app_theme.dart';
import 'package:mobile_codelab_ai/features/certificate/domain/certificate_models.dart';
import 'package:mobile_codelab_ai/features/certificate/domain/certificate_repository.dart';
import 'package:mobile_codelab_ai/features/certificate/presentation/pages/certificate_page.dart';
import 'package:mobile_codelab_ai/l10n/app_localizations.dart';

class _FakeCertificateRepository implements CertificateRepository {
  _FakeCertificateRepository(this._verification);

  final CertificateVerification _verification;

  @override
  Future<MyCertificates> getMyCertificates() async => const MyCertificates();

  @override
  Future<CertificateVerification> getVerification(String certId) async =>
      _verification;
}

const _student = CertificateStudent(
  id: '2',
  name: 'Muhammad Farhan',
  email: 'farhan@smk.belajar.id',
  bio: 'Siswa X RPL 1 SMK Swadhipa 2 Natar',
  xpPoints: 4750,
  challengesSolved: 8,
  challengesTotal: 8,
  modulesDone: 4,
  modulesTotal: 4,
  className: 'X RPL 1 - Pemrograman Web',
  classCode: 'RPL-101',
  teacherName: 'Fauzan, S.Pd.',
  memberCount: 11,
);

final _moduleCert = CertificateVerification(
  certId: 'CL-CERT-2026-PY01-FARHAN01',
  kind: 'module',
  topic: 'Python Dasar',
  description: 'Python Practitioner Essentials (Logika Pemrograman)',
  level: 'beginner',
  effectiveJp: 24,
  accreditationJp: 48,
  verifyUrl:
      'https://api.codelab-ai.web.id/verify/CL-CERT-2026-PY01-FARHAN01',
  issuedAt: DateTime.utc(2026, 11, 5),
  validUntil: DateTime.utc(2029, 11, 5),
  student: _student,
  chapters: const [
    CertificateChapter(
      number: 1,
      title: 'Bab 1: Pengenalan & Variabel Python',
      description: 'Sintaks dasar dan variabel.',
      minutes: 90,
      xpReward: 50,
    ),
    CertificateChapter(
      number: 2,
      title: 'Bab 2: Tipe Data & Operasi Hitung',
      minutes: 60,
      xpReward: 60,
    ),
  ],
);

final _challengeCert = CertificateVerification(
  certId: 'CL-CERT-2026-CH01-FARHAN01',
  kind: 'challenge',
  topic: 'Validasi Tahun Kabisat',
  description: 'Tantangan Koding: Logika Dasar',
  category: 'Percabangan & Logika',
  difficulty: 'beginner',
  instruction: 'Tentukan apakah tahun termasuk kabisat.',
  xpReward: 75,
  estimatedMinutes: 10,
  verifyUrl:
      'https://api.codelab-ai.web.id/verify/CL-CERT-2026-CH01-FARHAN01',
  issuedAt: DateTime.utc(2026, 11, 5),
  validUntil: DateTime.utc(2029, 11, 5),
  student: _student,
  rules: const [
    CertificateRule(text: 'KABISAT bila kelipatan 400', positive: true),
    CertificateRule(text: 'BUKAN KABISAT bila tidak memenuhi', positive: false),
  ],
  testCases: const [
    CertificateTestCase(title: 'Test Case #1 (Public)', hidden: false, weight: 25),
    CertificateTestCase(title: 'Test Case #3 (Hidden)', hidden: true, weight: 25),
  ],
);

Future<void> _pumpPage(
  WidgetTester tester,
  CertificateVerification verification,
) async {
  await tester.binding.setSurfaceSize(const Size(420, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    RepositoryProvider<CertificateRepository>(
      create: (_) => _FakeCertificateRepository(verification),
      child: MaterialApp(
        theme: AppTheme.light,
        locale: const Locale('id'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CertificatePage(certId: verification.certId),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sertifikat modul: nama, nomor, dan daftar bab tampil', (
    tester,
  ) async {
    await _pumpPage(tester, _moduleCert);

    // Judul layar + nomor sertifikat.
    expect(find.text('Sertifikat Kompetensi'), findsOneWidget);
    expect(find.text('CL-CERT-2026-PY01-FARHAN01'), findsWidgets);

    // Halaman 1: nama penerima + label piagam.
    expect(find.text('Muhammad Farhan'), findsOneWidget);
    expect(find.text('Diberikan kepada'), findsOneWidget);
    expect(find.textContaining('Halaman 1'), findsOneWidget);

    // Halaman 2: silabus bab + label transkrip.
    expect(find.textContaining('Halaman 2'), findsWidgets);
    expect(find.text('Bab yang dituntaskan:'), findsOneWidget);
    expect(
      find.textContaining('Bab 1: Pengenalan & Variabel Python'),
      findsWidgets,
    );

    // Aksi dokumen.
    expect(find.text('Buka Halaman Verifikasi'), findsOneWidget);
    expect(find.text('Bagikan Sertifikat'), findsOneWidget);
  });

  testWidgets('sertifikat modul tidak menyebut tantangan atau unit test', (
    tester,
  ) async {
    await _pumpPage(tester, _moduleCert);

    expect(find.textContaining('Test Case'), findsNothing);
    expect(find.textContaining('Hidden'), findsNothing);
    expect(find.textContaining('Kriteria & Kasus Uji'), findsNothing);
    // Evaluasi modul tetap menyebut 7 tipe slide interaktif.
    expect(find.textContaining('7 tipe slide'), findsOneWidget);
  });

  testWidgets('sertifikat tantangan: aturan + hasil uji tampil', (
    tester,
  ) async {
    await _pumpPage(tester, _challengeCert);

    expect(find.text('Validasi Tahun Kabisat'), findsWidgets);
    expect(find.text('CL-CERT-2026-CH01-FARHAN01'), findsWidgets);
    expect(
      find.text('Kriteria & Kasus Uji (Test Cases) yang Diselesaikan:'),
      findsOneWidget,
    );
    expect(find.textContaining('Aturan 1:'), findsWidgets);
    expect(find.textContaining('Test Case #1 (Public)'), findsWidgets);
    expect(find.textContaining('Hidden Test Case'), findsWidgets);
    // Instruksi soal ikut dirangkum di halaman 2.
    expect(find.textContaining('kabisat'), findsWidgets);
  });
}
