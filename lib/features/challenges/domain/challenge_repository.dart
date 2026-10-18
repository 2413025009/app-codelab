import 'package:equatable/equatable.dart';

enum ChallengeStatus { notStarted, inProgress, completed }

enum ChallengeLevel {
  beginner('Pemula'),
  intermediate('Menengah'),
  advanced('Mahir');

  const ChallengeLevel(this.label);
  final String label;
}

class ChallengeSummary extends Equatable {
  const ChallengeSummary({
    required this.id,
    required this.title,
    required this.level,
    required this.topicTag,
    required this.xp,
    required this.status,
    this.minXpRequired = 0,
    this.isLocked = false,
    this.isMiniProject = false,
    this.estimatedMinutes = 15,
    this.testCount = 3,
    this.subtitle,
  });

  final String id;
  final String title;
  final ChallengeLevel level;
  final String topicTag;
  final int xp;
  final ChallengeStatus status;
  final int minXpRequired;
  final bool isLocked;
  final bool isMiniProject;
  final int estimatedMinutes;
  final int testCount;
  final String? subtitle;

  @override
  List<Object?> get props => [id, status, isLocked, minXpRequired];
}

class ChallengeGroup extends Equatable {
  const ChallengeGroup({
    required this.title,
    required this.challenges,
    this.isMiniProject = false,
  });
  final String title;
  final List<ChallengeSummary> challenges;
  final bool isMiniProject;

  int get completed => challenges.where((c) => c.status == ChallengeStatus.completed).length;
  int get unlockedCount => challenges.where((c) => !c.isLocked).length;

  @override
  List<Object?> get props => [title, challenges];
}

class ChallengeCatalog extends Equatable {
  const ChallengeCatalog({
    required this.total,
    required this.completed,
    required this.xpEarned,
    required this.groups,
    this.userXp = 0,
  });

  final int total;
  final int completed;
  final int xpEarned;
  final int userXp;
  final List<ChallengeGroup> groups;

  double get progress => total == 0 ? 0 : completed / total;

  @override
  List<Object?> get props => [total, completed, groups, userXp];
}

class SampleCase extends Equatable {
  const SampleCase({required this.label, required this.condition, required this.call, required this.result});
  final String label;
  final String condition;
  final String call;
  final String result;
  @override
  List<Object?> get props => [call];
}

class ChallengeDetail extends Equatable {
  const ChallengeDetail({
    required this.id,
    required this.title,
    required this.levelLabel,
    required this.xp,
    required this.minutes,
    required this.position,
    required this.instruction,
    required this.rules,
    required this.samples,
    required this.starterCode,
    this.minXpRequired = 0,
    this.isLocked = false,
    this.category = 'Percabangan & Logika',
    this.testCases = const [],
    // Status bacaan dari server: 'not_started' | 'in_progress' | 'completed'.
    this.status = 'not_started',
  });

  final String id;
  final String title;
  final String levelLabel;
  final int xp;
  final int minutes;
  final String position;
  final String instruction;
  final List<RuleItem> rules;
  final List<SampleCase> samples;
  final String starterCode;
  final int minXpRequired;
  final bool isLocked;
  final String category;
  final List<TestCaseResult> testCases;
  final String status;

  /// Tantangan ini sudah selesai? dipakai halaman detail untuk
  /// menukar section "Contoh Pemanggilan" dengan hasil pengujian otomatis.
  bool get isCompleted => status == 'completed';

  @override
  List<Object?> get props => [id, isLocked];
}

class RuleItem extends Equatable {
  const RuleItem({required this.text, required this.positive});
  final String text;
  final bool positive;
  @override
  List<Object?> get props => [text];
}

class TestCaseResult extends Equatable {
  const TestCaseResult({
    required this.title,
    required this.input,
    required this.expected,
    required this.output,
    required this.passed,
    this.hidden = false,
    this.weight = 25,
  });

  final String title;
  final String input;
  final String expected;
  final String output;
  final bool passed;
  final bool hidden;
  final int weight;

  @override
  List<Object?> get props => [title, passed];
}

class RunReport extends Equatable {
  const RunReport({
    required this.results,
    required this.millis,
    /// Skor resmi dari server (diskon berbobot per test case). Null saat
    /// laporan berasal dari mock - skor dihitung uniform sebagai fallback.
    this.serverScore,
  });
  final List<TestCaseResult> results;
  final int millis;
  final int? serverScore;

  int get passedCount => results.where((r) => r.passed).length;
  bool get allPassed => results.isNotEmpty && passedCount == results.length;
  int get score => serverScore ?? (results.isEmpty ? 0 : (passedCount * 100 / results.length).round());

  @override
  List<Object?> get props => [results, millis, serverScore];
}

enum SubmissionStatus { passed, failed, error }

class Submission extends Equatable {
  const Submission({
    required this.number,
    required this.status,
    required this.score,
    required this.detail,
    required this.whenLabel,
    required this.code,
    this.hintsUsed = 0,
    this.problem,
    this.aiReview,
  });

  final int number;
  final SubmissionStatus status;
  final int score;

  /// e.g. "Waktu: 0.08s" or "SyntaxError: expected ':'".
  final String detail;
  final String whenLabel;
  final String code;
  final int hintsUsed;
  final String? problem;
  final String? aiReview;

  @override
  List<Object?> get props => [number, status];
}

class SubmissionHistory extends Equatable {
  const SubmissionHistory({
    required this.challengeTitle,
    required this.context,
    required this.bestScore,
    required this.submissions,
  });

  final String challengeTitle;
  final String context;
  final int bestScore;
  final List<Submission> submissions;

  @override
  List<Object?> get props => [challengeTitle, submissions];
}

class SubmissionResult extends Equatable {
  const SubmissionResult({
    required this.report,
    required this.submissionId,
    required this.status,
    required this.newXpTotal,
    required this.xpEarned,
  });

  final RunReport report;
  final String submissionId;
  final SubmissionStatus status;
  final int newXpTotal;
  final int xpEarned;

  @override
  List<Object?> get props => [submissionId, status, xpEarned];
}

/// Contract for challenges (GET /challenges/:id, POST /challenges/:id/run|submit).
abstract interface class ChallengeRepository {
  Future<ChallengeCatalog> getCatalog({int? userXp});
  Future<ChallengeDetail> getDetail(String id, {int? userXp});
  Future<RunReport> runTests(String challengeId, String code);
  Future<SubmissionResult> submitCode(String challengeId, String code);
  Future<SubmissionHistory> getHistory(String challengeId);
}
