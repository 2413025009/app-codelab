import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/features/class/domain/class_repository.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_repository.dart';
import 'package:mobile_codelab_ai/features/teacher/presentation/cubit/teacher_cubit.dart';

class FakeTeacherRepository implements TeacherRepository {
  final List<ClassInfo> classes = [];
  final List<ClassInfo> archivedClasses = [];
  final List<TeacherLesson> materials = [];
  final Map<String, List<Bab>> babs = {};
  final List<String> removedStudents = [];

  @override
  Future<List<ClassInfo>> listClasses() async => List.unmodifiable(classes);

  @override
  Future<List<ClassInfo>> listArchivedClasses() async =>
      List.unmodifiable(archivedClasses);

  @override
  Future<ClassInfo> createClass({
    required String name,
    required String academicYear,
    String scheduleNote = '',
  }) async {
    final c = ClassInfo(
      id: '${classes.length + 1}',
      name: name,
      classCode: 'ABC123',
      status: 'active',
      schoolName: 'SMK Swadhipa 2 Natar',
      teacherName: 'Pak Guru',
      memberCount: 0,
      academicYear: academicYear,
      scheduleNote: scheduleNote,
    );
    classes.add(c);
    return c;
  }

  @override
  Future<ClassInfo> updateClass(
    String classId, {
    required String name,
    required String academicYear,
    required String scheduleNote,
  }) async {
    final idx = classes.indexWhere((c) => c.id == classId);
    if (idx < 0) throw Exception('Class not found');
    final old = classes[idx];
    final updated = ClassInfo(
      id: old.id,
      name: name,
      classCode: old.classCode,
      status: old.status,
      schoolName: old.schoolName,
      teacherName: old.teacherName,
      memberCount: old.memberCount,
      academicYear: academicYear,
      scheduleNote: scheduleNote,
    );
    classes[idx] = updated;
    return updated;
  }

  @override
  Future<String> regenerateCode(String classId) async => 'XYZ999';

  @override
  Future<void> archiveClass(String classId) async {
    final idx = classes.indexWhere((c) => c.id == classId);
    if (idx < 0) return;
    final old = classes.removeAt(idx);
    archivedClasses.add(
      ClassInfo(
        id: old.id,
        name: old.name,
        classCode: old.classCode,
        status: 'archived',
        schoolName: old.schoolName,
        teacherName: old.teacherName,
        memberCount: old.memberCount,
        academicYear: old.academicYear,
        scheduleNote: old.scheduleNote,
      ),
    );
  }

  @override
  Future<void> restoreClass(String classId) async {
    final idx = archivedClasses.indexWhere((c) => c.id == classId);
    if (idx < 0) return;
    final old = archivedClasses.removeAt(idx);
    classes.add(
      ClassInfo(
        id: old.id,
        name: old.name,
        classCode: old.classCode,
        status: 'active',
        schoolName: old.schoolName,
        teacherName: old.teacherName,
        memberCount: old.memberCount,
        academicYear: old.academicYear,
        scheduleNote: old.scheduleNote,
      ),
    );
  }

  @override
  Future<List<TeacherLesson>> listMaterials({String? status}) async {
    if (status == null || status == 'all' || status == 'semua') {
      return List.unmodifiable(materials);
    }
    return materials.where((m) => m.status == status).toList();
  }

  @override
  Future<TeacherLesson> createMaterial({
    required String title,
    required String topic,
    required String level,
    required String description,
    String iconCode = 'terminal',
  }) async {
    final m = TeacherLesson(
      id: '${materials.length + 1}',
      title: title,
      topic: topic,
      level: level,
      description: description,
      iconCode: iconCode,
      status: 'draft',
      babCount: 0,
      totalXp: 0,
    );
    materials.add(m);
    return m;
  }

  @override
  Future<TeacherLesson> updateMaterial(
    String lessonId, {
    required String title,
    required String topic,
    required String level,
    required String description,
    String? iconCode,
  }) async {
    final idx = materials.indexWhere((m) => m.id == lessonId);
    if (idx < 0) throw Exception('Material not found');
    final old = materials[idx];
    final updated = TeacherLesson(
      id: old.id,
      title: title,
      topic: topic,
      level: level,
      description: description,
      iconCode: iconCode ?? old.iconCode,
      status: old.status,
      babCount: old.babCount,
      totalXp: old.totalXp,
      updatedAt: DateTime.now().toIso8601String(),
    );
    materials[idx] = updated;
    return updated;
  }

  @override
  Future<void> publishMaterial(String lessonId) async {
    final idx = materials.indexWhere((m) => m.id == lessonId);
    if (idx >= 0) {
      final old = materials[idx];
      materials[idx] = TeacherLesson(
        id: old.id,
        title: old.title,
        topic: old.topic,
        level: old.level,
        description: old.description,
        status: 'published',
        babCount: old.babCount,
        totalXp: old.totalXp,
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  @override
  Future<void> unpublishMaterial(String lessonId) async {
    final idx = materials.indexWhere((m) => m.id == lessonId);
    if (idx >= 0) {
      final old = materials[idx];
      materials[idx] = TeacherLesson(
        id: old.id,
        title: old.title,
        topic: old.topic,
        level: old.level,
        description: old.description,
        status: 'draft',
        babCount: old.babCount,
        totalXp: old.totalXp,
        updatedAt: DateTime.now().toIso8601String(),
      );
    }
  }

  @override
  Future<void> deleteMaterial(String lessonId) async {
    materials.removeWhere((m) => m.id == lessonId);
  }

  @override
  Future<TeacherLesson> duplicateMaterial(String lessonId) async {
    final orig = materials.firstWhere((m) => m.id == lessonId);
    final dup = TeacherLesson(
      id: '${materials.length + 1}',
      title: '${orig.title} (Salinan)',
      topic: orig.topic,
      level: orig.level,
      description: orig.description,
      status: 'draft',
      babCount: orig.babCount,
      totalXp: orig.totalXp,
    );
    materials.add(dup);
    return dup;
  }

  @override
  Future<List<Bab>> listBabs(String lessonId) async {
    return List.unmodifiable(babs[lessonId] ?? const []);
  }

  @override
  Future<Bab> createBab(
    String lessonId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  }) async {
    final list = babs.putIfAbsent(lessonId, () => []);
    final b = Bab(
      id: '${list.length + 1}',
      lessonId: lessonId,
      title: title,
      orderIndex: list.length + 1,
      xpReward: xpReward,
      slides: slides,
      contentMarkdown: '# $title',
    );
    list.add(b);
    return b;
  }

  @override
  Future<Bab> updateBab(
    String babId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  }) async {
    for (final list in babs.values) {
      final idx = list.indexWhere((b) => b.id == babId);
      if (idx >= 0) {
        final old = list[idx];
        final updated = Bab(
          id: old.id,
          lessonId: old.lessonId,
          title: title,
          orderIndex: old.orderIndex,
          xpReward: xpReward,
          slides: slides,
          contentMarkdown: old.contentMarkdown,
          updatedAt: DateTime.now().toIso8601String(),
        );
        list[idx] = updated;
        return updated;
      }
    }
    throw Exception('Bab not found');
  }

  @override
  Future<void> deleteBab(String babId) async {
    for (final list in babs.values) {
      list.removeWhere((b) => b.id == babId);
    }
  }

  @override
  Future<void> moveBab(String babId, String direction) async {}

  @override
  Future<void> removeStudentFromClass(String classId, String studentId) async {
    removedStudents.add('$classId:$studentId');
  }

  @override
  Future<List<StudentRosterRow>> classRoster(String classId) async {
    return [
      const StudentRosterRow(
        studentId: '2',
        name: 'Budi Pratama',
        avatarUrl: '',
        xpPoints: 120,
        lastBabTitle: 'Variabel',
        completedCount: 2,
        practiceCompletedCount: 3,
      ),
    ];
  }

  @override
  Future<ClassAnalytics> classAnalytics(String classId) async {
    return const ClassAnalytics(
      memberCount: 24,
      trackBars: [
        TrackBar(track: 'Python Dasar', avgPercent: 78.5, completedCount: 20),
      ],
      hardestChapters: [
        HardestChapter(
          lessonTitle: 'Percabangan Majemuk',
          failCount: 8,
          challengeSlug: 'nested-if',
        ),
      ],
    );
  }
}

void main() {
  group('TeacherCubit Tests', () {
    late FakeTeacherRepository repo;
    late TeacherCubit cubit;

    setUp(() {
      repo = FakeTeacherRepository();
      cubit = TeacherCubit(repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has empty data and isLoading = false', () {
      expect(cubit.state.classes, isEmpty);
      expect(cubit.state.materials, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    test('loadDashboard populates classes and calculates totals', () async {
      await repo.createClass(
        name: 'X RPL 1',
        academicYear: '2025/2026',
        scheduleNote: 'Lab 1',
      );

      await cubit.loadDashboard();

      expect(cubit.state.classes.length, 1);
      expect(cubit.state.classes.first.name, 'X RPL 1');
      expect(cubit.state.isLoading, isFalse);
    });

    test(
      'archive and restore move class between active and archived lists',
      () async {
        final created = await repo.createClass(
          name: 'X RPL 2',
          academicYear: '2026/2027',
        );
        await cubit.loadDashboard();
        expect(cubit.state.classes.length, 1);
        expect(cubit.state.archivedClasses, isEmpty);

        await cubit.archiveClass(created.id);
        expect(cubit.state.classes, isEmpty);
        expect(cubit.state.archivedClasses.length, 1);
        expect(cubit.state.archivedClasses.first.status, 'archived');

        await cubit.restoreClass(created.id);
        expect(cubit.state.archivedClasses, isEmpty);
        expect(cubit.state.classes.length, 1);
        expect(cubit.state.classes.first.status, 'active');
      },
    );

    test('createMaterial and loadMaterials with filter', () async {
      final created = await cubit.createMaterial(
        title: 'Pemrograman Web Dasar',
        topic: 'HTML',
        level: 'beginner',
        description: 'Pengenalan tag HTML5',
      );

      expect(created, isNotNull);
      expect(created!.status, 'draft');
      expect(cubit.state.materials.length, 1);

      // Publish material
      await cubit.publishMaterial(created.id);
      expect(cubit.state.materials.first.status, 'published');

      // Filter published
      await cubit.loadMaterials(filter: 'published');
      expect(cubit.state.materials.length, 1);

      // Filter draft (none)
      await cubit.loadMaterials(filter: 'draft');
      expect(cubit.state.materials, isEmpty);
    });

    test('duplicateMaterial clones existing lesson as draft', () async {
      final original = await cubit.createMaterial(
        title: 'CSS Grid',
        topic: 'CSS',
        level: 'intermediate',
        description: 'Layout modern CSS',
      );
      expect(original, isNotNull);

      await cubit.duplicateMaterial(original!.id);

      expect(cubit.state.materials.length, 2);
      expect(cubit.state.materials.last.title, 'CSS Grid (Salinan)');
      expect(cubit.state.materials.last.status, 'draft');
    });

    test('Bab CRUD operations update cubit babs state', () async {
      final mat = await cubit.createMaterial(
        title: 'Python Dasar',
        topic: 'Python Dasar',
        level: 'beginner',
        description: 'Dasar logika Python',
      );

      await cubit.createBab(
        mat!.id,
        title: 'Bab 1: Variabel & Tipe Data',
        xpReward: 50,
        slides: [
          {'type': 'THEORY', 'title': 'Pengenalan', 'content': 'Teks materi'},
          {'type': 'OUTRO', 'summary': 'Selesai', 'xp_preview': 50},
        ],
      );

      expect(cubit.state.babs.length, 1);
      expect(cubit.state.babs.first.title, 'Bab 1: Variabel & Tipe Data');

      final babId = cubit.state.babs.first.id;
      await cubit.updateBab(
        babId,
        mat.id,
        title: 'Bab 1: Variabel & Tipe Data (Revisi)',
        xpReward: 60,
        slides: [
          {'type': 'THEORY', 'title': 'Pengenalan', 'content': 'Teks baru'},
        ],
      );

      expect(
        cubit.state.babs.first.title,
        'Bab 1: Variabel & Tipe Data (Revisi)',
      );
      expect(cubit.state.babs.first.xpReward, 60);

      await cubit.deleteBab(babId, mat.id);
      expect(cubit.state.babs, isEmpty);
    });

    test('loadClassAnalytics loads roster and track metrics', () async {
      await cubit.loadClassAnalytics('1');

      expect(cubit.state.roster.length, 1);
      expect(cubit.state.roster.first.name, 'Budi Pratama');
      expect(cubit.state.roster.first.completedCount, 2);
      expect(cubit.state.roster.first.practiceCompletedCount, 3);
      expect(cubit.state.analytics, isNotNull);
      expect(cubit.state.analytics!.memberCount, 24);
      expect(cubit.state.analytics!.trackBars.first.track, 'Python Dasar');
    });

    test('removeStudentFromClass drops roster row and member count', () async {
      await cubit.loadClassAnalytics('1');
      expect(cubit.state.roster.length, 1);
      expect(cubit.state.analytics!.memberCount, 24);

      await cubit.removeStudentFromClass('1', '2');

      expect(repo.removedStudents, contains('1:2'));
      expect(cubit.state.roster, isEmpty);
      expect(cubit.state.analytics!.memberCount, 23);
      expect(cubit.state.actionSuccessMessage, contains('Budi Pratama'));
      expect(cubit.state.isLoading, isFalse);
    });
  });
}
