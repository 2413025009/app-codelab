// FILE: lib/features/teacher/domain/teacher_models.dart
//
// Model domain untuk fitur Teacher Studio (Minggu 11-12).
// Materi guru (TeacherLesson), bab (Bab), progres bab (BabProgress),
// analisa kelas (StudentRosterRow, TrackBar, HardestChapter, ClassAnalytics).

/// Satu materi milik guru (baris lessons dengan author_id NOT NULL).
class TeacherLesson {
  const TeacherLesson({
    required this.id,
    required this.title,
    required this.topic,
    required this.level,
    required this.description,
    this.iconCode = 'terminal',
    required this.status,
    required this.babCount,
    required this.totalXp,
    this.updatedAt,
  });

  final String id;
  final String title;
  final String topic;
  final String level;
  final String description;
  final String iconCode;

  /// "draft" | "published"
  final String status;
  final int babCount;
  final int totalXp;
  final String? updatedAt;

  bool get isDraft => status == 'draft';
  bool get isPublished => status == 'published';
}

/// Satu bab dalam materi guru.
class Bab {
  const Bab({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.orderIndex,
    required this.xpReward,
    required this.slides,
    required this.contentMarkdown,
    this.updatedAt,
  });

  final String id;
  final String lessonId;
  final String title;
  final int orderIndex;
  final int xpReward;

  /// Raw JSON array dari backend (list map).
  final List<Map<String, dynamic>> slides;
  final String contentMarkdown;
  final String? updatedAt;
}

/// Satu baris leaderboard siswa di kelas guru.
class StudentRosterRow {
  const StudentRosterRow({
    required this.studentId,
    required this.name,
    required this.avatarUrl,
    required this.xpPoints,
    required this.lastBabTitle,
    required this.completedCount,
    this.practiceCompletedCount = 0,
  });

  final String studentId;
  final String name;
  final String avatarUrl;
  final int xpPoints;
  final String lastBabTitle;

  /// Jumlah materi (lesson) tuntas — dasar peringkat "Materi".
  final int completedCount;

  /// Jumlah latihan (challenge) berbeda yang sudah lulus — dasar peringkat
  /// "Latihan". Dipisah dari materi agar guru bisa melihat dua kemampuan
  /// berbeda tanpa menumpuk section baru di bawah halaman.
  final int practiceCompletedCount;
}

/// Satu bar track di halaman analisa kelas.
class TrackBar {
  const TrackBar({
    required this.track,
    required this.avgPercent,
    required this.completedCount,
  });

  final String track;
  final double avgPercent;
  final int completedCount;
}

/// Kartu bab tersulit di analisa kelas.
class HardestChapter {
  const HardestChapter({
    required this.lessonTitle,
    required this.failCount,
    required this.challengeSlug,
  });

  final String lessonTitle;
  final int failCount;
  final String challengeSlug;
}

/// Hasil lengkap analisa satu kelas.
class ClassAnalytics {
  const ClassAnalytics({
    required this.memberCount,
    required this.trackBars,
    required this.hardestChapters,
  });

  final int memberCount;
  final List<TrackBar> trackBars;
  final List<HardestChapter> hardestChapters;
}
