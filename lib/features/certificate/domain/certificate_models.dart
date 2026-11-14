// FILE: lib/features/certificate/domain/certificate_models.dart
//
// TUGAS: model data e-Sertifikat Kompetensi (Minggu 12) yang dipakai layar
// profil dan layar pratinjau/cetak `/sertifikat-kompetensi-siswa/:certId`.
//
// SUMBER DATA: GET /api/v1/me/certificates (dua kelompok: modul & tantangan)
// dan GET /api/v1/verify/:certId (payload halaman verifikasi publik).
//
// ATURAN: semua angka & nama berasal dari backend (database) — tidak ada data
// tiruan di lapisan ini. Status kelayakan hanya boleh dibaca dari `eligible`.
import 'package:equatable/equatable.dart';

/// Satu bab silabus pada sertifikat modul (halaman 2).
class CertificateChapter extends Equatable {
  const CertificateChapter({
    required this.number,
    required this.title,
    this.description = '',
    this.minutes = 0,
    this.xpReward = 0,
    this.testDuration = '',
  });

  final int number;
  final String title;
  final String description;
  final int minutes;
  final int xpReward;

  /// Hanya dipakai sertifikat tantangan (mis. "12 ms").
  final String testDuration;

  factory CertificateChapter.fromJson(Map<String, dynamic> json) {
    return CertificateChapter(
      number: json['number'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      minutes: json['minutes'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 0,
      testDuration: json['testDuration'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [number, title];
}

/// Satu butir aturan tantangan (challenges.rules).
class CertificateRule extends Equatable {
  const CertificateRule({required this.text, required this.positive});

  final String text;
  final bool positive;

  factory CertificateRule.fromJson(Map<String, dynamic> json) {
    return CertificateRule(
      text: json['text'] as String? ?? '',
      positive: json['positive'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [text, positive];
}

/// Satu kasus uji pada sertifikat tantangan.
class CertificateTestCase extends Equatable {
  const CertificateTestCase({
    required this.title,
    required this.hidden,
    required this.weight,
    this.inputData = '',
    this.expected = '',
  });

  final String title;
  final bool hidden;
  final int weight;
  final String inputData;
  final String expected;

  factory CertificateTestCase.fromJson(Map<String, dynamic> json) {
    return CertificateTestCase(
      title: json['title'] as String? ?? '',
      hidden: json['hidden'] as bool? ?? false,
      weight: json['weight'] as int? ?? 0,
      inputData: json['inputData'] as String? ?? '',
      expected: json['expected'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [title, hidden];
}

/// Kartu profil penerima (kolom kanan halaman verifikasi).
class CertificateStudent extends Equatable {
  const CertificateStudent({
    this.id = '',
    this.name = '',
    this.email = '',
    this.bio = '',
    this.avatarUrl = '',
    this.xpPoints = 0,
    this.challengesSolved = 0,
    this.challengesTotal = 0,
    this.modulesDone = 0,
    this.modulesTotal = 0,
    this.className = '',
    this.classCode = '',
    this.teacherName = '',
    this.memberCount = 0,
  });

  final String id;
  final String name;
  final String email;
  final String bio;
  final String avatarUrl;
  final int xpPoints;
  final int challengesSolved;
  final int challengesTotal;
  final int modulesDone;
  final int modulesTotal;
  final String className;
  final String classCode;
  final String teacherName;
  final int memberCount;

  factory CertificateStudent.fromJson(Map<String, dynamic> json) {
    return CertificateStudent(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      xpPoints: json['xpPoints'] as int? ?? 0,
      challengesSolved: json['challengesSolved'] as int? ?? 0,
      challengesTotal: json['challengesTotal'] as int? ?? 0,
      modulesDone: json['modulesDone'] as int? ?? 0,
      modulesTotal: json['modulesTotal'] as int? ?? 0,
      className: json['className'] as String? ?? '',
      classCode: json['classCode'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      memberCount: json['memberCount'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, xpPoints];
}

/// Payload lengkap satu sertifikat (GET /verify/{certId}).
class CertificateVerification extends Equatable {
  const CertificateVerification({
    required this.certId,
    required this.kind,
    required this.topic,
    this.description = '',
    this.level = '',
    this.category = '',
    this.topicTag = '',
    this.difficulty = '',
    this.instruction = '',
    this.score = 100,
    this.effectiveJp = 0,
    this.accreditationJp = 0,
    this.xpReward = 0,
    this.estimatedMinutes = 0,
    this.moduleIcon = '',
    this.contentVersion = 0,
    this.verifyUrl = '',
    this.issuedAt,
    this.validUntil,
    this.student = const CertificateStudent(),
    this.chapters = const [],
    this.rules = const [],
    this.testCases = const [],
  });

  final String certId;
  final String kind; // 'module' | 'challenge'
  final String topic;
  final String description;
  final String level;
  final String category;
  final String topicTag;
  final String difficulty;
  final String instruction;
  final int score;
  final int effectiveJp;
  final int accreditationJp;
  final int xpReward;
  final int estimatedMinutes;
  final String moduleIcon;

  /// Minggu 14: versi konten modul saat sertifikat terbit. >0 untuk modul
  /// buatan guru, sehingga piagam lama tetap dapat dipertanggungjawabkan
  /// meski materinya sudah diubah setelahnya.
  final int contentVersion;
  final String verifyUrl;
  final DateTime? issuedAt;
  final DateTime? validUntil;
  final CertificateStudent student;
  final List<CertificateChapter> chapters;
  final List<CertificateRule> rules;
  final List<CertificateTestCase> testCases;

  bool get isChallenge => kind == 'challenge';

  factory CertificateVerification.fromJson(Map<String, dynamic> json) {
    return CertificateVerification(
      certId: json['certId'] as String? ?? '',
      kind: json['kind'] as String? ?? 'module',
      topic: json['topic'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      category: json['category'] as String? ?? '',
      topicTag: json['topicTag'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      instruction: json['instruction'] as String? ?? '',
      score: json['score'] as int? ?? 100,
      effectiveJp: json['effectiveJp'] as int? ?? 0,
      accreditationJp: json['accreditationJp'] as int? ?? 0,
      xpReward: json['xpReward'] as int? ?? 0,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
      moduleIcon: json['moduleIcon'] as String? ?? '',
      contentVersion: json['contentVersion'] as int? ?? 0,
      verifyUrl: json['verifyUrl'] as String? ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? ''),
      validUntil: DateTime.tryParse(json['validUntil'] as String? ?? ''),
      student: CertificateStudent.fromJson(
        (json['student'] as Map<String, dynamic>?) ?? const {},
      ),
      chapters: [
        for (final c in (json['chapters'] as List<dynamic>? ?? const []))
          CertificateChapter.fromJson(c as Map<String, dynamic>),
      ],
      rules: [
        for (final r in (json['rules'] as List<dynamic>? ?? const []))
          CertificateRule.fromJson(r as Map<String, dynamic>),
      ],
      testCases: [
        for (final t in (json['testCases'] as List<dynamic>? ?? const []))
          CertificateTestCase.fromJson(t as Map<String, dynamic>),
      ],
    );
  }

  @override
  List<Object?> get props => [certId, kind, topic];
}

/// Satu modul pada daftar sertifikat siswa (GET /me/certificates).
class ModuleCertificate extends Equatable {
  const ModuleCertificate({
    required this.topic,
    this.description = '',
    this.level = '',
    this.iconCode = '',
    this.teacherName = '',
    this.isTeacherModule = false,
    this.eligible = false,
    this.completedChapters = 0,
    this.totalChapters = 0,
    this.progressPercent = 0,
    this.certId = '',
    this.verifyUrl = '',
    this.issuedAt,
    this.validUntil,
    this.effectiveJp = 0,
    this.accreditationJp = 0,
    this.chapters = const [],
  });

  final String topic;
  final String description;
  final String level;
  final String iconCode;
  final String teacherName;
  final bool isTeacherModule;

  /// Satu-satunya penentu tombol unduh: seluruh bab tuntas 100%.
  final bool eligible;
  final int completedChapters;
  final int totalChapters;
  final double progressPercent;
  final String certId;
  final String verifyUrl;
  final DateTime? issuedAt;
  final DateTime? validUntil;
  final int effectiveJp;
  final int accreditationJp;
  final List<CertificateChapter> chapters;

  int get progressInt => progressPercent.round();

  factory ModuleCertificate.fromJson(Map<String, dynamic> json) {
    return ModuleCertificate(
      topic: json['topic'] as String? ?? '',
      description: json['description'] as String? ?? '',
      level: json['level'] as String? ?? '',
      iconCode: json['iconCode'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      isTeacherModule: json['isTeacherModule'] as bool? ?? false,
      eligible: json['eligible'] as bool? ?? false,
      completedChapters: json['completedChapters'] as int? ?? 0,
      totalChapters: json['totalChapters'] as int? ?? 0,
      progressPercent: (json['progressPercent'] as num?)?.toDouble() ?? 0,
      certId: json['certId'] as String? ?? '',
      verifyUrl: json['verifyUrl'] as String? ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? ''),
      validUntil: DateTime.tryParse(json['validUntil'] as String? ?? ''),
      effectiveJp: json['effectiveJp'] as int? ?? 0,
      accreditationJp: json['accreditationJp'] as int? ?? 0,
      chapters: [
        for (final c in (json['chapters'] as List<dynamic>? ?? const []))
          CertificateChapter.fromJson(c as Map<String, dynamic>),
      ],
    );
  }

  @override
  List<Object?> get props => [topic, eligible, certId];
}

/// Satu tantangan pada daftar sertifikat siswa (GET /me/certificates).
class ChallengeCertificate extends Equatable {
  const ChallengeCertificate({
    required this.title,
    this.category = '',
    this.topicTag = '',
    this.difficulty = '',
    this.xpReward = 0,
    this.estimatedMinutes = 0,
    this.instruction = '',
    this.rules = const [],
    this.eligible = false,
    this.score = 0,
    this.certId = '',
    this.verifyUrl = '',
    this.issuedAt,
    this.validUntil,
  });

  final String title;
  final String category;
  final String topicTag;
  final String difficulty;
  final int xpReward;
  final int estimatedMinutes;
  final String instruction;
  final List<CertificateRule> rules;

  /// Aktif hanya bila tantangan sudah lulus (skor 100).
  final bool eligible;
  final int score;
  final String certId;
  final String verifyUrl;
  final DateTime? issuedAt;
  final DateTime? validUntil;

  factory ChallengeCertificate.fromJson(Map<String, dynamic> json) {
    return ChallengeCertificate(
      title: json['title'] as String? ?? '',
      category: json['category'] as String? ?? '',
      topicTag: json['topicTag'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      xpReward: json['xpReward'] as int? ?? 0,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 0,
      instruction: json['instruction'] as String? ?? '',
      rules: [
        for (final r in (json['rules'] as List<dynamic>? ?? const []))
          CertificateRule.fromJson(r as Map<String, dynamic>),
      ],
      eligible: json['eligible'] as bool? ?? false,
      score: json['score'] as int? ?? 0,
      certId: json['certId'] as String? ?? '',
      verifyUrl: json['verifyUrl'] as String? ?? '',
      issuedAt: DateTime.tryParse(json['issuedAt'] as String? ?? ''),
      validUntil: DateTime.tryParse(json['validUntil'] as String? ?? ''),
    );
  }

  @override
  List<Object?> get props => [title, eligible, certId];
}

/// Dua kelompok sertifikat milik siswa yang login.
class MyCertificates extends Equatable {
  const MyCertificates({
    this.moduleCertificates = const [],
    this.challengeCertificates = const [],
  });

  final List<ModuleCertificate> moduleCertificates;
  final List<ChallengeCertificate> challengeCertificates;

  bool get isEmpty =>
      moduleCertificates.isEmpty && challengeCertificates.isEmpty;

  factory MyCertificates.fromJson(Map<String, dynamic> json) {
    return MyCertificates(
      moduleCertificates: [
        for (final m in (json['moduleCertificates'] as List<dynamic>? ?? const []))
          ModuleCertificate.fromJson(m as Map<String, dynamic>),
      ],
      challengeCertificates: [
        for (final c in (json['challengeCertificates'] as List<dynamic>? ?? const []))
          ChallengeCertificate.fromJson(c as Map<String, dynamic>),
      ],
    );
  }

  @override
  List<Object?> get props => [moduleCertificates, challengeCertificates];
}
