// FILE: test/certificate_models_test.dart
//
// TUGAS: pengujian model e-Sertifikat Kompetensi (Minggu 12).
// Fokus: status kelayakan hanya dibaca dari backend, nomor sertifikat tidak
// pernah dikarang di sisi aplikasi, dan payload halaman verifikasi terbaca
// lengkap untuk modul maupun tantangan.
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/features/certificate/domain/certificate_models.dart';

Map<String, dynamic> moduleJson({
  bool eligible = true,
  String certId = 'CL-CERT-2026-PY01-FARHAN01',
  int done = 12,
  int total = 12,
}) {
  return {
    'topic': 'Python Dasar',
    'description': 'Python Practitioner Essentials',
    'level': 'beginner',
    'iconCode': 'data_object',
    'isTeacherModule': false,
    'eligible': eligible,
    'completedChapters': done,
    'totalChapters': total,
    'progressPercent': total == 0 ? 0 : done * 100 / total,
    'certId': certId,
    'verifyUrl': certId.isEmpty
        ? ''
        : 'https://api.codelab-ai.web.id/verify/$certId',
    'issuedAt': '2026-11-05T09:00:00Z',
    'validUntil': '2029-11-05T09:00:00Z',
    'effectiveJp': 24,
    'accreditationJp': 48,
    'chapters': [
      {
        'number': 1,
        'title': 'Bab 1: Pengenalan & Variabel Python',
        'description': 'Sintaks dasar.',
        'minutes': 90,
        'xpReward': 50,
      },
    ],
  };
}

Map<String, dynamic> challengeJson({bool eligible = true}) {
  return {
    'title': 'Validasi Tahun Kabisat',
    'category': 'Percabangan & Logika',
    'topicTag': 'If-Else',
    'difficulty': 'beginner',
    'xpReward': 75,
    'estimatedMinutes': 10,
    'instruction': 'Tentukan tahun kabisat.',
    'rules': [
      {'text': 'KABISAT bila kelipatan 400', 'positive': true},
    ],
    'eligible': eligible,
    'score': eligible ? 100 : 40,
    'certId': eligible ? 'CL-CERT-2026-CH01-FARHAN01' : '',
    'verifyUrl': eligible
        ? 'https://api.codelab-ai.web.id/verify/CL-CERT-2026-CH01-FARHAN01'
        : '',
  };
}

void main() {
  group('ModuleCertificate', () {
    test('membaca modul yang layak beserta nomor sertifikat', () {
      final m = ModuleCertificate.fromJson(moduleJson());
      expect(m.topic, 'Python Dasar');
      expect(m.eligible, isTrue);
      expect(m.certId, 'CL-CERT-2026-PY01-FARHAN01');
      expect(m.completedChapters, 12);
      expect(m.totalChapters, 12);
      expect(m.progressInt, 100);
      expect(m.chapters, hasLength(1));
      expect(m.chapters.first.minutes, 90);
      expect(m.issuedAt, isNotNull);
      expect(m.validUntil, isNotNull);
    });

    test('modul belum tuntas: eligible=false dan tanpa nomor sertifikat', () {
      final m = ModuleCertificate.fromJson(
        moduleJson(eligible: false, certId: '', done: 3, total: 12),
      );
      expect(m.eligible, isFalse);
      expect(m.certId, isEmpty);
      expect(m.progressInt, 25);
    });

    test('progres 0 tidak menghasilkan pembagian nol', () {
      final m = ModuleCertificate.fromJson(
        moduleJson(eligible: false, certId: '', done: 0, total: 0),
      );
      expect(m.progressPercent, 0);
      expect(m.progressInt, 0);
      expect(m.eligible, isFalse);
    });
  });

  group('ChallengeCertificate', () {
    test('tantangan lulus membawa nomor + tautan verifikasi', () {
      final c = ChallengeCertificate.fromJson(challengeJson());
      expect(c.title, 'Validasi Tahun Kabisat');
      expect(c.eligible, isTrue);
      expect(c.score, 100);
      expect(c.certId, 'CL-CERT-2026-CH01-FARHAN01');
      expect(c.verifyUrl, contains('/verify/CL-CERT-2026-CH01-FARHAN01'));
      expect(c.rules.single.positive, isTrue);
    });

    test('tantangan belum lulus tidak boleh punya nomor', () {
      final c = ChallengeCertificate.fromJson(challengeJson(eligible: false));
      expect(c.eligible, isFalse);
      expect(c.certId, isEmpty);
      expect(c.score, 40);
    });
  });

  group('MyCertificates', () {
    test('memisahkan dua kelompok sertifikat', () {
      final certs = MyCertificates.fromJson({
        'moduleCertificates': [moduleJson()],
        'challengeCertificates': [challengeJson()],
      });
      expect(certs.moduleCertificates, hasLength(1));
      expect(certs.challengeCertificates, hasLength(1));
      expect(certs.isEmpty, isFalse);
    });

    test('payload kosong aman (bukan null)', () {
      final certs = MyCertificates.fromJson(const {});
      expect(certs.moduleCertificates, isEmpty);
      expect(certs.challengeCertificates, isEmpty);
      expect(certs.isEmpty, isTrue);
    });
  });

  group('CertificateVerification', () {
    test('modul: bab + JP terbaca, bukan tantangan', () {
      final v = CertificateVerification.fromJson({
        'certId': 'CL-CERT-2026-PY01-FARHAN01',
        'kind': 'module',
        'topic': 'Python Dasar',
        'description': 'Python Practitioner Essentials',
        'level': 'beginner',
        'score': 100,
        'effectiveJp': 24,
        'accreditationJp': 48,
        'moduleIcon': 'data_object',
        'verifyUrl':
            'https://api.codelab-ai.web.id/verify/CL-CERT-2026-PY01-FARHAN01',
        'issuedAt': '2026-11-05T09:00:00Z',
        'validUntil': '2029-11-05T09:00:00Z',
        'student': {
          'id': '2',
          'name': 'Muhammad Farhan',
          'email': 'farhan@smk.belajar.id',
          'xpPoints': 4750,
          'challengesSolved': 8,
          'challengesTotal': 8,
          'modulesDone': 4,
          'modulesTotal': 4,
          'className': 'X RPL 1 - Pemrograman Web',
          'classCode': 'RPL-101',
          'teacherName': 'Fauzan, S.Pd.',
          'memberCount': 11,
        },
        'chapters': [
          {'number': 1, 'title': 'Bab 1: Pengenalan', 'minutes': 90},
          {'number': 2, 'title': 'Bab 2: Tipe Data', 'minutes': 90},
        ],
        'rules': <dynamic>[],
        'testCases': <dynamic>[],
      });
      expect(v.isChallenge, isFalse);
      expect(v.student.name, 'Muhammad Farhan');
      expect(v.student.classCode, 'RPL-101');
      expect(v.chapters, hasLength(2));
      expect(v.rules, isEmpty);
      expect(v.testCases, isEmpty);
    });

    test('tantangan: instruksi + aturan + test case terbaca', () {
      final v = CertificateVerification.fromJson({
        'certId': 'CL-CERT-2026-CH08-FARHAN01',
        'kind': 'challenge',
        'topic': 'Aplikasi Manajemen Nilai Siswa',
        'category': 'Mini-Proyek Terapan',
        'difficulty': 'advanced',
        'instruction': 'Rekapitulasi nilai ujian.',
        'score': 100,
        'xpReward': 200,
        'estimatedMinutes': 35,
        'issuedAt': '2026-11-05T09:00:00Z',
        'validUntil': '2029-11-05T09:00:00Z',
        'student': {'id': '2', 'name': 'Muhammad Farhan'},
        'rules': [
          {'text': 'Parsing pasangan nama & nilai', 'positive': true},
          {'text': 'Format rata-rata 2 desimal', 'positive': true},
        ],
        'testCases': [
          {
            'title': 'Test Case #1 (Public)',
            'hidden': false,
            'weight': 50,
            'inputData': 'Budi 80',
          },
          {
            'title': 'Test Case #3 (Hidden)',
            'hidden': true,
            'weight': 50,
            'inputData': 'Siti 90',
          },
        ],
      });
      expect(v.isChallenge, isTrue);
      expect(v.rules, hasLength(2));
      expect(v.testCases, hasLength(2));
      expect(v.testCases.last.hidden, isTrue);
      expect(v.xpReward, 200);
    });
  });
}
