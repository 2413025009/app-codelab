import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'slide_models.dart';

class LessonPoint extends Equatable {
  const LessonPoint({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;
  @override
  List<Object?> get props => [title];
}

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.prompt,
    required this.codeHint,
    required this.options,
    required this.correctIndex,
  });

  final String prompt;
  final String codeHint;
  final List<String> options;
  final int correctIndex;

  @override
  List<Object?> get props => [prompt, correctIndex];
}

class LessonContent extends Equatable {
  const LessonContent({
    required this.id,
    required this.topic,
    required this.moduleLabel,
    required this.title,
    required this.readMinutes,
    required this.xp,
    required this.step,
    required this.totalSteps,
    required this.intro,
    required this.sectionTitle,
    required this.sectionBody,
    required this.points,
    required this.codeFileName,
    required this.code,
    required this.note,
    required this.quiz,
    required this.practiceChallengeId,
  });

  final String id;
  final String topic;
  final String moduleLabel;
  final String title;
  final int readMinutes;
  final int xp;
  final int step;
  final int totalSteps;
  final String intro;
  final String sectionTitle;
  final String sectionBody;
  final List<LessonPoint> points;
  final String codeFileName;
  final String code;
  final String note;
  final QuizQuestion? quiz;
  final String practiceChallengeId;

  @override
  List<Object?> get props => [id];
}

/// Contract for lesson content (GET /lessons/:id).
abstract interface class LessonRepository {
  Future<LessonDetailData> getLessonDetail(String id);

  /// Minggu 9: mengembalikan jumlah XP yang SAH dibayarkan server untuk
  /// penyelesaian ini — 0 saat bab sudah pernah tuntas (XP tidak dihitung
  /// dua kali; sumber kebenaran = klaim atomik xr di `xp_awarded`).
  Future<int> saveProgress({
    required String id,
    required int currentSlideIndex,
    required double progressPercent,
    required bool completed,
  });
  Future<List<LessonDetailData>> listAllLessons();
}
