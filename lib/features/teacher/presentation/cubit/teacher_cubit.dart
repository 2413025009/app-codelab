// FILE: lib/features/teacher/presentation/cubit/teacher_cubit.dart
//
// TUGAS: otak fitur pengajar — dashboard kelas, studio materi, bab builder,
// dan analitik performa. Semua data berasal dari TeacherRepository (REST),
// tanpa mock. Cubit menyimpan salinan state agar layar bisa memperbarui
// daftar tanpa memuat ulang seluruh halaman.
//
// WAJIB DIUBAH BILA: kontrak TeacherRepository berubah (tambah aksi baru)
// atau layar pengajar butuh state tambahan — tambahkan field di
// teacher_state.dart lalu salurkan lewat copyWith.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../class/domain/class_exceptions.dart';
import '../../../class/domain/class_repository.dart';
import '../../domain/teacher_exceptions.dart';
import '../../domain/teacher_models.dart';
import '../../domain/teacher_repository.dart';
import 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit(this._repository) : super(const TeacherState());

  final TeacherRepository _repository;

  /// Nomor permintaan analitik terakhir — mencegah respons lama menimpa
  /// kelas yang baru dipilih saat guru berpindah kelas dengan cepat.
  int _analyticsRequest = 0;

  // ── Dashboard kelas ──────────────────────────────────────────────────────

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final classes = await _repository.listClasses();
      emit(
        state.copyWith(
          classes: classes,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<void> loadArchivedClasses() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final archived = await _repository.listArchivedClasses();
      emit(
        state.copyWith(
          archivedClasses: archived,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<ClassInfo?> createClass({
    required String name,
    required String academicYear,
    String scheduleNote = '',
  }) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final room = await _repository.createClass(
        name: name,
        academicYear: academicYear,
        scheduleNote: scheduleNote,
      );
      emit(
        state.copyWith(
          classes: [...state.classes, room],
          isLoading: false,
          actionSuccessMessage: 'Kelas ${room.name} berhasil dibuat.',
          clearError: true,
        ),
      );
      return room;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  Future<void> archiveClass(String classId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.archiveClass(classId);
      final target = state.classes.where((room) => room.id == classId).firstOrNull;
      emit(
        state.copyWith(
          classes: state.classes.where((room) => room.id != classId).toList(),
          archivedClasses: target == null
              ? state.archivedClasses
              : [
                  ...state.archivedClasses,
                  _copyClass(target, status: 'archived'),
                ],
          isLoading: false,
          actionSuccessMessage: 'Kelas dipindahkan ke arsip.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<void> restoreClass(String classId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.restoreClass(classId);
      final target = state.archivedClasses
          .where((room) => room.id == classId)
          .firstOrNull;
      emit(
        state.copyWith(
          archivedClasses: state.archivedClasses
              .where((room) => room.id != classId)
              .toList(),
          classes: target == null
              ? state.classes
              : [...state.classes, _copyClass(target, status: 'active')],
          isLoading: false,
          actionSuccessMessage: 'Kelas berhasil dipulihkan.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<String?> regenerateClassCode(String classId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final code = await _repository.regenerateCode(classId);
      emit(
        state.copyWith(
          classes: [
            for (final room in state.classes)
              room.id == classId ? _copyClass(room, classCode: code) : room,
          ],
          archivedClasses: [
            for (final room in state.archivedClasses)
              room.id == classId ? _copyClass(room, classCode: code) : room,
          ],
          isLoading: false,
          actionSuccessMessage: 'Kode kelas baru: $code',
          clearError: true,
        ),
      );
      return code;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  // ── Studio materi ────────────────────────────────────────────────────────

  /// Muat daftar materi. [filter] = 'all' | 'draft' | 'published'; bila
  /// kosong, filter yang sedang aktif dipakai.
  Future<void> loadMaterials({String? filter}) async {
    final target = _normalizeFilter(filter ?? state.materialFilter);
    emit(
      state.copyWith(
        isLoading: true,
        materialFilter: target,
        clearError: true,
      ),
    );
    try {
      final materials = await _repository.listMaterials(
        status: target == 'all' ? null : target,
      );
      emit(
        state.copyWith(
          materials: materials,
          materialFilter: target,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  /// Ganti tab filter di layar studio. Daftar yang sudah dimuat disaring
  /// langsung oleh [TeacherState.filteredMaterials] — tanpa jaringan.
  void setMaterialFilter(String filter) {
    final target = _normalizeFilter(filter);
    if (state.materialFilter == target) return;
    emit(state.copyWith(materialFilter: target, clearSuccess: true));
  }

  /// Cari satu materi; pakai salinan di state lebih dulu agar layar yang
  /// dibuka lewat URL langsung tidak menunggu jaringan bila data sudah ada.
  Future<TeacherLesson?> findMaterial(String lessonId) async {
    final cached = state.materials
        .where((material) => material.id == lessonId)
        .firstOrNull;
    if (cached != null) return cached;

    try {
      final materials = await _repository.listMaterials();
      emit(state.copyWith(materials: materials, clearError: true));
      return materials.where((material) => material.id == lessonId).firstOrNull;
    } catch (error) {
      emit(state.copyWith(errorMessage: _messageOf(error)));
      return null;
    }
  }

  Future<TeacherLesson?> createMaterial({
    required String title,
    required String topic,
    required String level,
    required String description,
    String iconCode = 'terminal',
  }) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final material = await _repository.createMaterial(
        title: title,
        topic: topic,
        level: level,
        description: description,
        iconCode: iconCode,
      );
      emit(
        state.copyWith(
          materials: [...state.materials, material],
          isLoading: false,
          actionSuccessMessage: 'Materi baru berhasil dibuat.',
          clearError: true,
        ),
      );
      return material;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  Future<TeacherLesson?> updateMaterial(
    String lessonId, {
    required String title,
    required String topic,
    required String level,
    required String description,
    String? iconCode,
  }) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final material = await _repository.updateMaterial(
        lessonId,
        title: title,
        topic: topic,
        level: level,
        description: description,
        iconCode: iconCode,
      );
      emit(
        state.copyWith(
          materials: _replaceMaterial(material),
          isLoading: false,
          actionSuccessMessage: 'Materi berhasil diperbarui.',
          clearError: true,
        ),
      );
      return material;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  Future<void> publishMaterial(String lessonId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.publishMaterial(lessonId);
      final updated = _changeMaterialStatus(lessonId, 'published');
      emit(
        state.copyWith(
          materials: updated == null
              ? state.materials
              : _replaceMaterial(updated),
          isLoading: false,
          actionSuccessMessage: 'Materi berhasil diterbitkan.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<void> unpublishMaterial(String lessonId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.unpublishMaterial(lessonId);
      final updated = _changeMaterialStatus(lessonId, 'draft');
      emit(
        state.copyWith(
          materials: updated == null
              ? state.materials
              : _replaceMaterial(updated),
          isLoading: false,
          actionSuccessMessage: 'Materi dikembalikan ke draft.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<void> deleteMaterial(String lessonId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.deleteMaterial(lessonId);
      emit(
        state.copyWith(
          materials: state.materials
              .where((material) => material.id != lessonId)
              .toList(),
          isLoading: false,
          actionSuccessMessage: 'Materi berhasil dihapus.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<TeacherLesson?> duplicateMaterial(String lessonId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final duplicate = await _repository.duplicateMaterial(lessonId);
      emit(
        state.copyWith(
          materials: [...state.materials, duplicate],
          isLoading: false,
          actionSuccessMessage: 'Materi berhasil diduplikasi.',
          clearError: true,
        ),
      );
      return duplicate;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  // ── Bab builder ──────────────────────────────────────────────────────────

  Future<void> loadBabs(String lessonId) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final babs = await _repository.listBabs(lessonId);
      emit(
        state.copyWith(
          babs: babs,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<Bab?> createBab(
    String lessonId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  }) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final bab = await _repository.createBab(
        lessonId,
        title: title,
        xpReward: xpReward,
        slides: slides,
      );
      emit(
        state.copyWith(
          babs: [...state.babs, bab],
          isLoading: false,
          actionSuccessMessage: 'Bab baru berhasil ditambahkan.',
          clearError: true,
        ),
      );
      return bab;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  Future<Bab?> updateBab(
    String babId,
    String lessonId, {
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> slides,
  }) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      final bab = await _repository.updateBab(
        babId,
        title: title,
        xpReward: xpReward,
        slides: slides,
      );
      final exists = state.babs.any((item) => item.id == babId);
      emit(
        state.copyWith(
          babs: exists
              ? [
                  for (final item in state.babs)
                    item.id == babId ? bab : item,
                ]
              : [...state.babs, bab],
          isLoading: false,
          actionSuccessMessage: 'Bab berhasil diperbarui.',
          clearError: true,
        ),
      );
      return bab;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
      return null;
    }
  }

  Future<void> deleteBab(String babId, String lessonId) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.deleteBab(babId);
      emit(
        state.copyWith(
          babs: state.babs.where((item) => item.id != babId).toList(),
          isLoading: false,
          actionSuccessMessage: 'Bab berhasil dihapus.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  Future<void> moveBab(
    String babId,
    String lessonId,
    String direction,
  ) async {
    emit(
      state.copyWith(isLoading: true, clearError: true, clearSuccess: true),
    );
    try {
      await _repository.moveBab(babId, direction);
      final babs = await _repository.listBabs(lessonId);
      emit(
        state.copyWith(
          babs: babs,
          isLoading: false,
          actionSuccessMessage: 'Urutan bab diperbarui.',
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  // ── Analitik kelas ───────────────────────────────────────────────────────

  Future<void> loadClassAnalytics(String classId) async {
    final request = ++_analyticsRequest;

    // Kosongkan analitik lama supaya layar menampilkan animasi memuat saat
    // guru berpindah kelas, bukan data kelas sebelumnya.
    emit(
      TeacherState(
        classes: state.classes,
        archivedClasses: state.archivedClasses,
        materials: state.materials,
        materialFilter: state.materialFilter,
        babs: state.babs,
        roster: const [],
        analytics: null,
        isLoading: true,
      ),
    );

    try {
      final roster = await _repository.classRoster(classId);
      final analytics = await _repository.classAnalytics(classId);
      if (isClosed || request != _analyticsRequest) return;
      emit(
        state.copyWith(
          roster: roster,
          analytics: analytics,
          isLoading: false,
          clearError: true,
        ),
      );
    } catch (error) {
      if (isClosed || request != _analyticsRequest) return;
      emit(state.copyWith(isLoading: false, errorMessage: _messageOf(error)));
    }
  }

  // ── Utilitas ─────────────────────────────────────────────────────────────

  void clearMessages() {
    if (state.errorMessage == null && state.actionSuccessMessage == null) {
      return;
    }
    emit(state.copyWith(clearError: true, clearSuccess: true));
  }

  String _normalizeFilter(String filter) {
    final value = filter.trim().toLowerCase();
    if (value == 'draft' || value == 'published') return value;
    return 'all';
  }

  String _messageOf(Object error) {
    if (error is ApiTeacherException) return error.message;
    if (error is ApiClassException) return error.message;
    return 'Gagal terhubung ke server. Periksa koneksi lalu coba lagi.';
  }

  ClassInfo _copyClass(
    ClassInfo room, {
    String? status,
    String? classCode,
  }) {
    return ClassInfo(
      id: room.id,
      name: room.name,
      classCode: classCode ?? room.classCode,
      status: status ?? room.status,
      schoolName: room.schoolName,
      teacherName: room.teacherName,
      memberCount: room.memberCount,
      academicYear: room.academicYear,
      scheduleNote: room.scheduleNote,
    );
  }

  TeacherLesson? _changeMaterialStatus(String lessonId, String status) {
    final material = state.materials
        .where((item) => item.id == lessonId)
        .firstOrNull;
    if (material == null) return null;
    return TeacherLesson(
      id: material.id,
      title: material.title,
      topic: material.topic,
      level: material.level,
      description: material.description,
      iconCode: material.iconCode,
      status: status,
      babCount: material.babCount,
      totalXp: material.totalXp,
      updatedAt: material.updatedAt,
    );
  }

  List<TeacherLesson> _replaceMaterial(TeacherLesson updated) {
    if (!state.materials.any((item) => item.id == updated.id)) {
      return [...state.materials, updated];
    }
    return [
      for (final item in state.materials)
        item.id == updated.id ? updated : item,
    ];
  }
}
