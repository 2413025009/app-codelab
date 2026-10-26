import 'package:equatable/equatable.dart';

// Minggu 9 (owner): bab tidak lagi berantai terkunci — 'available' berarti
// bab terbuka dan bisa langsung dikerjakan (aplikasi punya akun baru pun).
enum ModuleStatus { completed, active, available, locked }

class LearningModule extends Equatable {
  const LearningModule({
    required this.id,
    required this.order,
    required this.title,
    required this.description,
    required this.status,
    this.requirement,
    this.topic = '',
  });

  final String id;
  final int order;
  final String title;
  final String description;
  final ModuleStatus status;

  /// Track/topik bab ini (mis. "Python Dasar"). Dipakai peta petualangan
  /// supaya hanya bab dari track yang sedang aktif yang ditampilkan.
  final String topic;

  /// For locked modules: what must be finished first, e.g. "Selesaikan Modul 3 dulu".
  final String? requirement;

  @override
  List<Object?> get props => [id, order, title, status];
}

class ResumeInfo extends Equatable {
  const ResumeInfo({
    required this.lessonId,
    required this.topic,
    required this.title,
    required this.description,
    required this.progress,
  });

  final String lessonId;
  final String topic;
  final String title;
  final String description;

  /// 0..1
  final double progress;

  @override
  List<Object?> get props => [lessonId, progress];
}

class DashboardData extends Equatable {
  const DashboardData({
    required this.completedChallenges,
    this.totalChallenges = 0,
    this.userXp,
    required this.resume,
    required this.firstLessonId,
    required this.skills,
    required this.pathTitle,
    required this.pathSubtitle,
    required this.modules,
  });

  final int completedChallenges;

  /// Jumlah SELURUH tantangan pada DB (katalog penuh); 0 artinya total
  /// tidak tersedia dari backend sehingga UI tidak boleh menampilkan "x/y".
  final int totalChallenges;

  /// XP terverifikasi backend (dari GET /me yang sudah dikunjungi load());
  /// null ketika dashboard gagal memuat sehingga UI boleh memakai XP
  /// lokal AuthCubit (tidak ada angka palsu).
  final int? userXp;

  /// null for a brand-new student (empty state).
  final ResumeInfo? resume;
  final String firstLessonId;

  /// axis -> 0..100
  final Map<String, double> skills;
  final String pathTitle;
  final String pathSubtitle;
  final List<LearningModule> modules;

  bool get hasSkills => skills.values.any((v) => v > 0);

  @override
  List<Object?> get props => [
    completedChallenges,
    totalChallenges,
    userXp,
    resume,
    skills,
    modules,
  ];
}

/// Contract for dashboard data (GET /me, /me/progress, /me/skills, /lessons).
/// `onProgress` = laporan tahap NYATA: dipanggil tiap kali satu permintaan
/// jaringan benar-benar selesai (dipakai layar memuat, bukan angka palsu).
abstract interface class DashboardRepository {
  Future<DashboardData> load({
    required String studentEmail,
    void Function(int done, int total, String stage)? onProgress,
  });
}
