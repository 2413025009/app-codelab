import '../../lesson/domain/slide_models.dart';

/// Adapter untuk mengubah `List<Map<String, dynamic>>` slide editor guru
/// menjadi model domain `LessonDetailData` / `LessonSlide` yang siap dieksekusi
/// oleh `LessonReaderPage` (Simulator Pratinjau Siswa).
///
/// Catatan penting: kunci yang ditulis editor guru dan kunci yang dibaca
/// pembaca materi siswa berbeda. Adapter inilah satu-satunya tempat
/// penerjemahannya, supaya pratinjau guru tidak pernah kosong.
abstract final class SlideAdapter {
  static LessonDetailData toLessonDetailData({
    required String id,
    required String title,
    required int xpReward,
    required List<Map<String, dynamic>> rawSlides,
  }) {
    final slides = <LessonSlide>[];
    for (var i = 0; i < rawSlides.length; i++) {
      final s = rawSlides[i];
      final type = (s['type'] as String? ?? 'THEORY').toUpperCase();
      final slideId = s['id'] as String? ?? 'slide_${i + 1}';
      final slideTitle = (s['title'] as String?)?.trim().isNotEmpty == true
          ? s['title'] as String
          : 'Slide ${i + 1}';

      switch (type) {
        case 'THEORY':
          slides.add(
            TheorySlide(
              id: slideId,
              title: slideTitle,
              content: s['content'] as String? ?? '',
              codeSnippet: _firstNonEmpty([
                s['sample_code'],
                s['code'],
                s['code_snippet'],
              ]),
              codeFileName:
                  _firstNonEmpty([s['file_name']]) ??
                  _fileNameForLang(s['code_lang'] as String?),
            ),
          );
          break;

        case 'TAP_TO_FILL':
          final template = (s['template'] as String? ?? '').trim();
          final blanks = _stringList(s['blanks']);
          final distractors = _stringList(s['distractors']);
          final options = <String>[
            ...blanks,
            ...distractors.where((d) => !blanks.contains(d)),
          ];
          slides.add(
            TapToFillSlide(
              id: slideId,
              title: slideTitle,
              instruction: (s['prompt'] as String?)?.trim() ?? '',
              file:
                  (s['file_name'] as String?) ??
                  _fileNameForLang(s['code_lang'] as String?),
              // Editor memakai slot `___1___`; widget siswa memakai `[slot]`.
              codeLines: template
                  .split('\n')
                  .map(
                    (line) =>
                        line.replaceAll(RegExp(r'_{2,}\d*_{2,}'), '[slot]'),
                  )
                  .toList(),
              options: options.isEmpty ? ['print'] : options,
              correctAnswers: blanks.isEmpty ? ['print'] : blanks,
            ),
          );
          break;

        case 'TYPE_CODE':
          slides.add(
            TypeCodeSlide(
              id: slideId,
              title: slideTitle,
              file: s['file_name'] as String? ?? 'script.py',
              instruction:
                  _firstNonEmpty([s['instruction'], s['prompt']]) ??
                  'Lengkapi kode berikut:',
              codeTemplate:
                  (_firstNonEmpty([s['starter_code'], s['code']]) ?? '')
                      .replaceAll('[KETIK_DISINI]', '[input]'),
              expectedAnswer:
                  _firstNonEmpty([
                    s['target_keyword'],
                    s['answer'],
                    s['expected_answer'],
                  ]) ??
                  '',
              hint: _firstNonEmpty([s['hint'], s['explanation']]) ?? '',
            ),
          );
          break;

        case 'OUTPUT_PREDICT':
          final opts = _stringList(
            s['options'],
            fallback: const ['1', '2', '3', 'Error'],
          );
          slides.add(
            OutputPredictSlide(
              id: slideId,
              title: slideTitle,
              codeSnippet: s['code'] as String? ?? '',
              question:
                  _firstNonEmpty([s['question'], s['prompt']]) ??
                  'Apakah output dari kode di atas?',
              options: opts,
              correctAnswer: _resolveAnswer(
                raw: _firstNonEmpty([s['correct_answer'], s['answer']]),
                options: opts,
              ),
            ),
          );
          break;

        case 'BUG_HUNTER':
          final buggyCode = s['buggy_code'] as String? ?? 'x = 10\nprint(x)';
          final rawLines = buggyCode.split('\n');
          final bugLines = <BugHunterLine>[
            for (var j = 0; j < rawLines.length; j++)
              BugHunterLine(number: j + 1, code: rawLines[j]),
          ];
          final rawLine = s['bug_line_index'] ?? s['target_line'] ?? 1;
          final targetLine = rawLine is int
              ? rawLine
              : int.tryParse('$rawLine') ?? 1;
          slides.add(
            BugHunterSlide(
              id: slideId,
              title: slideTitle,
              instruction:
                  _firstNonEmpty([
                    s['scenario'],
                    s['instruction'],
                    s['prompt'],
                  ]) ??
                  'Cari baris yang bermasalah:',
              lines: bugLines,
              correctLine: targetLine.clamp(1, bugLines.length),
              errorType: s['error_type'] as String? ?? 'SyntaxError',
              explanation:
                  _firstNonEmpty([s['bug_hint'], s['explanation'], s['fix']]) ??
                  'Periksa sintaks pada baris ini.',
            ),
          );
          break;

        case 'QUIZ':
          final quizOpts = _stringList(
            s['options'],
            fallback: const ['A', 'B', 'C', 'D'],
          );
          slides.add(
            QuizSlide(
              id: slideId,
              title: slideTitle,
              question: s['question'] as String? ?? 'Pertanyaan kuis:',
              options: quizOpts,
              correctAnswer: _resolveAnswer(
                raw: _firstNonEmpty([s['correct_answer'], s['answer']]),
                options: quizOpts,
              ),
              explanation: s['explanation'] as String? ?? '',
            ),
          );
          break;

        case 'OUTRO':
          final summary = (s['summary'] as String?)?.trim();
          slides.add(
            OutroSlide(
              id: slideId,
              title: slideTitle,
              summary: summary != null && summary.isNotEmpty
                  ? summary
                  : 'Selamat! Kamu telah menyelesaikan bab ini.',
              accuracy: '100%',
              xpEarned: xpReward,
              learningTime: '3 Menit',
              masteredConcepts: _stringList(
                s['mastered_concepts'],
                fallback: const ['Konsep Utama'],
              ),
            ),
          );
          break;

        default:
          slides.add(
            TheorySlide(
              id: slideId,
              title: slideTitle,
              content: s['content'] as String? ?? '',
            ),
          );
      }
    }

    if (slides.isEmpty) {
      slides.add(
        TheorySlide(
          id: 'slide_empty',
          title: title,
          content: 'Bab ini belum memiliki slide.',
        ),
      );
    }

    return LessonDetailData(
      id: id,
      title: title,
      slug: id,
      topic: 'Pratinjau Guru',
      level: 'beginner',
      orderIndex: 1,
      xpReward: xpReward,
      status: 'draft',
      progressPercent: 0.0,
      currentSlideIndex: 1,
      description: 'Mode Simulator Pratinjau Guru',
      slides: slides,
      contentMarkdown: '',
    );
  }

  /// Pratinjau satu slide saja (dipakai editor slide per tipe).
  static LessonDetailData singleSlidePreview({
    required String id,
    required String title,
    required int xpReward,
    required Map<String, dynamic> slide,
  }) {
    return toLessonDetailData(
      id: id,
      title: title,
      xpReward: xpReward,
      rawSlides: [slide],
    );
  }

  static String _fileNameForLang(String? lang) {
    switch ((lang ?? '').toLowerCase().trim()) {
      case 'html':
        return 'index.html';
      case 'css':
        return 'style.css';
      case 'javascript':
      case 'js':
        return 'script.js';
      default:
        return 'script.py';
    }
  }

  static String? _firstNonEmpty(List<Object?> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value;
    }
    return null;
  }

  static List<String> _stringList(
    Object? raw, {
    List<String> fallback = const [],
  }) {
    if (raw is List) {
      final values = raw
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty)
          .toList();
      if (values.isNotEmpty) return values;
    }
    return List<String>.from(fallback);
  }

  /// Editor menyimpan kunci jawaban sebagai huruf opsi ("A", "B", ...).
  /// Widget siswa membandingkan teks opsi, jadi huruf harus diterjemahkan.
  static String _resolveAnswer({
    required String? raw,
    required List<String> options,
  }) {
    final answer = (raw ?? '').trim();
    if (answer.isEmpty) return options.isNotEmpty ? options.first : '';
    if (answer.length == 1) {
      final index = answer.toUpperCase().codeUnitAt(0) - 65;
      if (index >= 0 && index < options.length) return options[index];
    }
    final matched = options.where((o) => o.trim() == answer);
    if (matched.isNotEmpty) return matched.first;
    if (options.contains(answer)) return answer;
    return answer;
  }
}
