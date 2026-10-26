import 'package:equatable/equatable.dart';

enum SlideType {
  theory,
  tapToFill,
  typeCode,
  outputPredict,
  bugHunter,
  quiz,
  outro,
}

abstract class LessonSlide extends Equatable {
  const LessonSlide({
    required this.id,
    required this.type,
    required this.title,
  });

  final String id;
  final SlideType type;
  final String title;

  @override
  List<Object?> get props => [id, type, title];
}

class TheorySlide extends LessonSlide {
  const TheorySlide({
    required super.id,
    required super.title,
    required this.content,
    this.codeSnippet,
    this.codeFileName,
  }) : super(type: SlideType.theory);

  final String content;
  final String? codeSnippet;
  final String? codeFileName;

  @override
  List<Object?> get props => [
    id,
    type,
    title,
    content,
    codeSnippet,
    codeFileName,
  ];
}

class TapToFillSlide extends LessonSlide {
  const TapToFillSlide({
    required super.id,
    required super.title,
    required this.file,
    required this.codeLines,
    required this.options,
    required this.correctAnswers,
    this.successTitle = 'Tepat Sekali!',
    this.successMsg = 'Kamu berhasil menyusun potongan sintaks.',
    this.errorTitle = 'Coba Periksa Lagi!',
    this.errorMsg = 'Periksa urutan blok yang kamu masukkan.',
  }) : super(type: SlideType.tapToFill);

  final String file;
  final List<String> codeLines;
  final List<String> options;
  final List<String> correctAnswers;
  final String successTitle;
  final String successMsg;
  final String errorTitle;
  final String errorMsg;

  @override
  List<Object?> get props => [id, file, codeLines, options, correctAnswers];
}

class TypeCodeSlide extends LessonSlide {
  const TypeCodeSlide({
    required super.id,
    required super.title,
    required this.file,
    required this.instruction,
    required this.codeTemplate,
    required this.expectedAnswer,
    this.hint = '',
    this.successTitle = 'Luar Biasa!',
    this.successMsg = 'Perintah yang kamu ketik tepat sesuai sintaks.',
    this.errorTitle = 'Kurang Tepat!',
    this.errorMsg = 'Perhatikan penulisan huruf besar dan kecil.',
  }) : super(type: SlideType.typeCode);

  final String file;
  final String instruction;
  final String codeTemplate;
  final String expectedAnswer;
  final String hint;
  final String successTitle;
  final String successMsg;
  final String errorTitle;
  final String errorMsg;

  @override
  List<Object?> get props => [id, file, codeTemplate, expectedAnswer];
}

class OutputPredictSlide extends LessonSlide {
  const OutputPredictSlide({
    required super.id,
    required super.title,
    this.codeSnippet,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.successTitle = 'Mantap Jiwa!',
    this.successMsg = 'Prediksi logikamu akurat.',
    this.errorTitle = 'Kurang Tepat!',
    this.errorMsg = 'Perhatikan alur eksekusi baris demi baris.',
  }) : super(type: SlideType.outputPredict);

  final String? codeSnippet;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String successTitle;
  final String successMsg;
  final String errorTitle;
  final String errorMsg;

  @override
  List<Object?> get props => [
    id,
    codeSnippet,
    question,
    options,
    correctAnswer,
  ];
}

class BugHunterLine extends Equatable {
  const BugHunterLine({required this.number, required this.code});

  final int number;
  final String code;

  @override
  List<Object?> get props => [number, code];
}

class BugHunterSlide extends LessonSlide {
  const BugHunterSlide({
    required super.id,
    required super.title,
    required this.instruction,
    required this.lines,
    required this.correctLine,
    required this.errorType,
    required this.explanation,
    this.successTitle = 'Hebat, Bug Ditemukan!',
    this.successMsg = 'Kamu berhasil mendeteksi baris kode yang rusak.',
    this.errorTitle = 'Bukan Baris Itu!',
    this.errorMsg = 'Cari baris yang melanggar aturan sintaks atau logika.',
  }) : super(type: SlideType.bugHunter);

  final String instruction;
  final List<BugHunterLine> lines;
  final int correctLine;
  final String errorType;
  final String explanation;
  final String successTitle;
  final String successMsg;
  final String errorTitle;
  final String errorMsg;

  @override
  List<Object?> get props => [id, lines, correctLine, errorType];
}

class QuizSlide extends LessonSlide {
  const QuizSlide({
    required super.id,
    required super.title,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    this.successTitle = 'Jawaban Sempurna!',
    this.successMsg = 'Pemahaman konsepmu sangat solid.',
    this.errorTitle = 'Kurang Tepat!',
    this.errorMsg = 'Coba ingat kembali prinsip dasar materi ini.',
  }) : super(type: SlideType.quiz);

  final String question;
  final List<String> options;
  final String correctAnswer;
  final String explanation;
  final String successTitle;
  final String successMsg;
  final String errorTitle;
  final String errorMsg;

  @override
  List<Object?> get props => [id, question, options, correctAnswer];
}

class OutroSlide extends LessonSlide {
  const OutroSlide({
    required super.id,
    required super.title,
    required this.summary,
    required this.accuracy,
    required this.xpEarned,
    required this.learningTime,
    required this.masteredConcepts,
    this.nextLessonSlug,
  }) : super(type: SlideType.outro);

  final String summary;
  final String accuracy;
  final int xpEarned;
  final String learningTime;
  final List<String> masteredConcepts;
  final String? nextLessonSlug;

  @override
  List<Object?> get props => [
    id,
    summary,
    accuracy,
    xpEarned,
    masteredConcepts,
  ];
}

class LessonDetailData extends Equatable {
  const LessonDetailData({
    required this.id,
    required this.title,
    required this.slug,
    required this.topic,
    required this.level,
    required this.orderIndex,
    required this.xpReward,
    required this.status,
    required this.progressPercent,
    required this.currentSlideIndex,
    this.description = '',
    this.requiredLessonTitle,
    required this.slides,
    required this.contentMarkdown,
  });

  final String id;
  final String title;
  final String slug;
  final String topic;
  final String level;
  final int orderIndex;
  final int xpReward;
  final String status;
  final double progressPercent;
  final int currentSlideIndex;
  // Minggu 9 (owner): deskripsi singkat materi muncul di katalog & kartu
  // progres profil siswa (di bawah nama lesson/topik).
  final String description;
  final String? requiredLessonTitle;
  final List<LessonSlide> slides;
  final String contentMarkdown;

  @override
  List<Object?> get props => [id, title, slug, topic, orderIndex, slides];
}
