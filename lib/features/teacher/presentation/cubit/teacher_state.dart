// FILE: lib/features/teacher/presentation/cubit/teacher_state.dart
//
// State terpusat untuk fitur instruktur/guru: dashboard kelas,
// studio materi (CRUD), bab builder, dan analitik performa.

import 'package:equatable/equatable.dart';
import 'package:mobile_codelab_ai/features/class/domain/class_repository.dart';
import 'package:mobile_codelab_ai/features/teacher/domain/teacher_models.dart';

class TeacherState extends Equatable {
  const TeacherState({
    this.classes = const [],
    this.archivedClasses = const [],
    this.materials = const [],
    this.materialFilter = 'all',
    this.babs = const [],
    this.roster = const [],
    this.analytics,
    this.isLoading = false,
    this.errorMessage,
    this.actionSuccessMessage,
  });

  final List<ClassInfo> classes;
  final List<ClassInfo> archivedClasses;
  final List<TeacherLesson> materials;

  /// 'all' | 'draft' | 'published'
  final String materialFilter;
  final List<Bab> babs;
  final List<StudentRosterRow> roster;
  final ClassAnalytics? analytics;
  final bool isLoading;
  final String? errorMessage;
  final String? actionSuccessMessage;

  List<TeacherLesson> get filteredMaterials {
    if (materialFilter == 'draft') {
      return materials.where((m) => m.isDraft).toList();
    }
    if (materialFilter == 'published') {
      return materials.where((m) => m.isPublished).toList();
    }
    return materials;
  }

  int get draftCount => materials.where((m) => m.isDraft).length;
  int get publishedCount => materials.where((m) => m.isPublished).length;
  int get totalStudentCount => classes.fold(0, (sum, c) => sum + c.memberCount);

  TeacherState copyWith({
    List<ClassInfo>? classes,
    List<ClassInfo>? archivedClasses,
    List<TeacherLesson>? materials,
    String? materialFilter,
    List<Bab>? babs,
    List<StudentRosterRow>? roster,
    ClassAnalytics? analytics,
    bool? isLoading,
    String? errorMessage,
    String? actionSuccessMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return TeacherState(
      classes: classes ?? this.classes,
      archivedClasses: archivedClasses ?? this.archivedClasses,
      materials: materials ?? this.materials,
      materialFilter: materialFilter ?? this.materialFilter,
      babs: babs ?? this.babs,
      roster: roster ?? this.roster,
      analytics: analytics ?? this.analytics,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      actionSuccessMessage: clearSuccess
          ? null
          : (actionSuccessMessage ?? this.actionSuccessMessage),
    );
  }

  @override
  List<Object?> get props => [
    classes,
    archivedClasses,
    materials,
    materialFilter,
    babs,
    roster,
    analytics,
    isLoading,
    errorMessage,
    actionSuccessMessage,
  ];
}
