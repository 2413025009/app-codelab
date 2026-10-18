// FILE: lib/features/lesson/domain/lesson_parser.dart
// TUGAS: memecah markdown materi bab menjadi slide domain.
// FUNGSI YANG DIKELOLA: parseSlides — blok dipisah '---' dipetakan ke
// 7 tipe slide (teori, kuis, tap-to-fill, type-code, bug-hunter, dst.);
// materi kosong jatuh ke satu TheorySlide 'Materi belum tersedia'.
// DATA YANG DIKELOLA: LessonSlide beserta tiap variannya.
// WAJIB DIUBAH BILA: kontrak markdown materi berubah (pemisah atau tipe slide baru).
import 'dart:convert';
import 'slide_models.dart';

class LessonParser {
  static List<LessonSlide> parseSlides(String markdown, {required String defaultTitle}) {
    if (markdown.trim().isEmpty) {
      return [
        TheorySlide(
          id: 'slide-1',
          title: defaultTitle,
          content: 'Materi belum tersedia saat ini.',
        ),
      ];
    }

    final rawBlocks = markdown.split(RegExp(r'\n---\n|\r\n---\r\n'));
    final slides = <LessonSlide>[];

    for (var i = 0; i < rawBlocks.length; i++) {
      final raw = rawBlocks[i].trim();
      if (raw.isEmpty) continue;
      final slideId = 'slide-${i + 1}';

      try {
        if (raw.contains('[TIPE: TAP_TO_FILL]')) {
          slides.add(_parseTapToFill(slideId, raw));
        } else if (raw.contains('[TIPE: TYPE_CODE]')) {
          slides.add(_parseTypeCode(slideId, raw));
        } else if (raw.contains('[TIPE: OUTPUT_PREDICT]')) {
          slides.add(_parseOutputPredict(slideId, raw));
        } else if (raw.contains('[TIPE: BUG_HUNTER]')) {
          slides.add(_parseBugHunter(slideId, raw));
        } else if (raw.contains('[TIPE: QUIZ]')) {
          slides.add(_parseQuiz(slideId, raw));
        } else if (raw.contains('[TIPE: OUTRO]')) {
          slides.add(_parseOutro(slideId, raw));
        } else {
          // Default to THEORY
          slides.add(_parseTheory(slideId, raw));
        }
      } catch (e) {
        // Fallback to theory slide gracefully
        slides.add(
          TheorySlide(
            id: slideId,
            title: _extractTitle(raw, fallback: 'Latihan ${i + 1}'),
            content: raw.replaceAll(RegExp(r'\[TIPE: [A-Z_]+\]'), '').trim(),
          ),
        );
      }
    }

    return slides.isEmpty
        ? [TheorySlide(id: 'slide-1', title: defaultTitle, content: markdown)]
        : slides;
  }

  static String _extractTitle(String text, {String fallback = 'Materi'}) {
    final lines = text.split('\n');
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.startsWith('# ')) {
        return trimmed.substring(2).trim();
      }
    }
    return fallback;
  }

  static TheorySlide _parseTheory(String id, String text) {
    final title = _extractTitle(text, fallback: 'Pengantar Teori');
    var rawText = text.replaceAll(RegExp(r'\[TIPE: [A-Z_]+\]'), '').trim();

    String? codeSnippet;
    String? codeFileName;

    final codeMatch = RegExp(r'```([a-zA-Z0-9_]*)\r?\n([\s\S]*?)```').firstMatch(rawText);
    if (codeMatch != null) {
      final codeBody = codeMatch.group(2) ?? '';
      rawText = rawText.replaceRange(codeMatch.start, codeMatch.end, '').trim();

      // Check if first line in code body is a comment filename (e.g. # contoh.py or <!-- index.html -->)
      final lines = codeBody.split('\n');
      if (lines.isNotEmpty && (lines[0].trim().startsWith('#') || lines[0].trim().startsWith('<!--'))) {
        codeFileName = lines[0].replaceAll(RegExp(r'[#<!\->]'), '').trim();
        codeSnippet = lines.sublist(1).join('\n').trim();
      } else {
        codeSnippet = codeBody.trim();
      }
    }

    final cleaned = rawText
        .replaceAll(RegExp(r'^#\s+.*$', multiLine: true), '')
        .trim();

    return TheorySlide(
      id: id,
      title: title,
      content: cleaned,
      codeSnippet: codeSnippet,
      codeFileName: codeFileName,
    );
  }

  static TapToFillSlide _parseTapToFill(String id, String text) {
    final title = _extractTitle(text, fallback: 'Lengkapi Sintaks');
    final block = _extractCustomBlock(text, 'tap_to_fill');

    final codeLines = <String>[];
    var options = <String>[];
    var correct = <String>[];
    var file = 'main.py';
    var successTitle = 'Tepat Sekali!';
    var successMsg = 'Sintaks berhasil disusun.';
    var errorTitle = 'Coba Periksa Lagi!';
    var errorMsg = 'Perhatikan slot yang kosong.';

    for (final line in block.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('file:')) {
        file = trimmed.substring(5).trim();
      } else if (trimmed.startsWith('code:')) {
        codeLines.add(trimmed.substring(5).trim());
      } else if (trimmed.startsWith('options:')) {
        options = _parseJsonOrYamlList(trimmed.substring(8).trim());
      } else if (trimmed.startsWith('correct:')) {
        correct = _parseJsonOrYamlList(trimmed.substring(8).trim());
      } else if (trimmed.startsWith('success_title:')) {
        successTitle = trimmed.substring(14).trim();
      } else if (trimmed.startsWith('success_msg:')) {
        successMsg = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_title:')) {
        errorTitle = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_msg:')) {
        errorMsg = trimmed.substring(10).trim();
      }
    }

    return TapToFillSlide(
      id: id,
      title: title,
      file: file,
      codeLines: codeLines,
      options: options,
      correctAnswers: correct,
      successTitle: successTitle,
      successMsg: successMsg,
      errorTitle: errorTitle,
      errorMsg: errorMsg,
    );
  }

  static TypeCodeSlide _parseTypeCode(String id, String text) {
    final title = _extractTitle(text, fallback: 'Ketik Kode');
    final block = _extractCustomBlock(text, 'type_code');

    var file = 'latihan.py';
    var instruction = 'Ketik sintaks yang sesuai:';
    var codeTemplate = '[input]';
    var expected = '';
    var hint = '';
    var successTitle = 'Luar Biasa!';
    var successMsg = 'Perintah yang kamu ketik tepat.';
    var errorTitle = 'Kurang Tepat!';
    var errorMsg = 'Perhatikan penulisan huruf.';

    for (final line in block.split('\n')) {
      final trimmed = line.trim();
      if (trimmed.startsWith('file:')) {
        file = trimmed.substring(5).trim();
      } else if (trimmed.startsWith('instruction:')) {
        instruction = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('code:')) {
        codeTemplate = trimmed.substring(5).trim();
      } else if (trimmed.startsWith('expected:')) {
        expected = trimmed.substring(9).trim();
      } else if (trimmed.startsWith('hint:')) {
        hint = trimmed.substring(5).trim();
      } else if (trimmed.startsWith('success_title:')) {
        successTitle = trimmed.substring(14).trim();
      } else if (trimmed.startsWith('success_msg:')) {
        successMsg = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_title:')) {
        errorTitle = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_msg:')) {
        errorMsg = trimmed.substring(10).trim();
      }
    }

    return TypeCodeSlide(
      id: id,
      title: title,
      file: file,
      instruction: instruction,
      codeTemplate: codeTemplate,
      expectedAnswer: expected,
      hint: hint,
      successTitle: successTitle,
      successMsg: successMsg,
      errorTitle: errorTitle,
      errorMsg: errorMsg,
    );
  }

  static OutputPredictSlide _parseOutputPredict(String id, String text) {
    final title = _extractTitle(text, fallback: 'Tebak Output');

    // Preceding code block
    String? codeSnippet;
    final codeMatch = RegExp(r'```([a-zA-Z0-9_]*)\r?\n([\s\S]*?)```').firstMatch(text);
    if (codeMatch != null && codeMatch.group(1) != 'output_predict') {
      codeSnippet = codeMatch.group(2)?.trim();
    }

    final block = _extractCustomBlock(text, 'output_predict');
    var question = 'Berapa output konsol dari kode di atas?';
    var options = <String>[];
    var correct = '';
    var successTitle = 'Mantap Jiwa!';
    var successMsg = 'Prediksi logikamu akurat.';
    var errorTitle = 'Kurang Tepat!';
    var errorMsg = 'Perhatikan alur eksekusi baris demi baris.';

    final lines = block.split('\n');
    var readingOptions = false;

    for (final rawLine in lines) {
      final trimmed = rawLine.trim();
      if (trimmed.startsWith('question:')) {
        readingOptions = false;
        question = trimmed.substring(9).trim();
      } else if (trimmed.startsWith('options:')) {
        final rest = trimmed.substring(8).trim();
        if (rest.startsWith('[')) {
          options = _parseJsonOrYamlList(rest);
          readingOptions = false;
        } else {
          readingOptions = true;
        }
      } else if (readingOptions && trimmed.startsWith('-')) {
        var opt = trimmed.substring(1).trim();
        if (opt.startsWith('"') && opt.endsWith('"')) {
          opt = opt.substring(1, opt.length - 1);
        }
        options.add(opt);
      } else if (trimmed.startsWith('correct:')) {
        readingOptions = false;
        var c = trimmed.substring(8).trim();
        if (c.startsWith('"') && c.endsWith('"')) c = c.substring(1, c.length - 1);
        correct = c;
      } else if (trimmed.startsWith('success_title:')) {
        readingOptions = false;
        successTitle = trimmed.substring(14).trim();
      } else if (trimmed.startsWith('success_msg:')) {
        readingOptions = false;
        successMsg = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_title:')) {
        readingOptions = false;
        errorTitle = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_msg:')) {
        readingOptions = false;
        errorMsg = trimmed.substring(10).trim();
      }
    }

    return OutputPredictSlide(
      id: id,
      title: title,
      codeSnippet: codeSnippet,
      question: question,
      options: options,
      correctAnswer: correct,
      successTitle: successTitle,
      successMsg: successMsg,
      errorTitle: errorTitle,
      errorMsg: errorMsg,
    );
  }

  static BugHunterSlide _parseBugHunter(String id, String text) {
    final title = _extractTitle(text, fallback: 'Cari Baris Error');
    final block = _extractCustomBlock(text, 'bug_hunter');

    var instruction = 'Ketuk baris kode yang rusak di bawah ini:';
    final lines = <BugHunterLine>[];
    var correctLine = 1;
    var errorType = 'SyntaxError';
    var explanation = '';
    var successTitle = 'Hebat, Bug Ditemukan!';
    var successMsg = 'Kamu berhasil mendeteksi baris error.';
    var errorTitle = 'Bukan Baris Itu!';
    var errorMsg = 'Cari baris yang melanggar aturan sintaks.';

    var readingLines = false;

    for (final rawLine in block.split('\n')) {
      final trimmed = rawLine.trim();
      if (trimmed.startsWith('instruction:')) {
        readingLines = false;
        instruction = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('lines:')) {
        readingLines = true;
      } else if (readingLines && trimmed.startsWith('- line:')) {
        final rest = trimmed.substring(7).trim();
        final parts = rest.split('|');
        if (parts.length >= 2) {
          final lineNum = int.tryParse(parts[0].trim()) ?? (lines.length + 1);
          final code = parts.sublist(1).join('|').trim();
          lines.add(BugHunterLine(number: lineNum, code: code));
        } else {
          lines.add(BugHunterLine(number: lines.length + 1, code: rest));
        }
      } else if (trimmed.startsWith('correct_line:')) {
        readingLines = false;
        correctLine = int.tryParse(trimmed.substring(13).trim()) ?? 1;
      } else if (trimmed.startsWith('error_type:')) {
        readingLines = false;
        errorType = trimmed.substring(11).trim();
      } else if (trimmed.startsWith('explanation:')) {
        readingLines = false;
        explanation = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('success_title:')) {
        readingLines = false;
        successTitle = trimmed.substring(14).trim();
      } else if (trimmed.startsWith('success_msg:')) {
        readingLines = false;
        successMsg = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_title:')) {
        readingLines = false;
        errorTitle = trimmed.substring(12).trim();
      } else if (trimmed.startsWith('error_msg:')) {
        readingLines = false;
        errorMsg = trimmed.substring(10).trim();
      }
    }

    return BugHunterSlide(
      id: id,
      title: title,
      instruction: instruction,
      lines: lines,
      correctLine: correctLine,
      errorType: errorType,
      explanation: explanation,
      successTitle: successTitle,
      successMsg: successMsg,
      errorTitle: errorTitle,
      errorMsg: errorMsg,
    );
  }

  static QuizSlide _parseQuiz(String id, String text) {
    final title = _extractTitle(text, fallback: 'Kuis Konsep');
    final block = _extractCustomBlock(text, 'quiz');

    var question = 'Pilih jawaban yang paling tepat:';
    var options = <String>[];
    var correct = '';
    var explanation = '';
    var successTitle = 'Jawaban Sempurna!';
    var successMsg = 'Pemahaman konsepmu sangat solid.';
    var errorTitle = 'Kurang Tepat!';
    var errorMsg = 'Coba ingat kembali prinsip dasar materi ini.';

    final lines = block.split('\n');
    var readingOptions = false;

    for (final rawLine in lines) {
      // P2-14: kunci blok dibandingkan case-insensitive agar penulis konten
      // yang memakai gaya CONTOH_LESSON.md tetap ter-parse.
      final trimmed = rawLine.trim();
      final key = trimmed.toLowerCase();
      if (key.startsWith('question:')) {
        readingOptions = false;
        question = trimmed.substring(9).trim();
      } else if (key.startsWith('options:')) {
        final rest = trimmed.substring(8).trim();
        if (rest.startsWith('[')) {
          options = _parseJsonOrYamlList(rest);
          readingOptions = false;
        } else {
          readingOptions = true;
        }
      } else if (readingOptions && trimmed.startsWith('-')) {
        var opt = trimmed.substring(1).trim();
        if (opt.startsWith('"') && opt.endsWith('"') && opt.length >= 2) {
          opt = opt.substring(1, opt.length - 1);
        }
        // P2-14: dukung marker inline `[correct]` di ujung pilihan
        // (kompatibel dua-dua: field `correct:` maupun marker inline).
        final markerMatch = RegExp(r'\[\s*correct\s*\]\s*$', caseSensitive: false).firstMatch(opt);
        if (markerMatch != null) {
          opt = opt.substring(0, markerMatch.start).trim();
          if (correct.isEmpty) correct = opt;
        }
        if (opt.isNotEmpty) options.add(opt);
      } else if (key.startsWith('correct:')) {
        readingOptions = false;
        var c = trimmed.substring(8).trim();
        if (c.startsWith('"') && c.endsWith('"') && c.length >= 2) c = c.substring(1, c.length - 1);
        correct = c;
      } else if (key.startsWith('explanation:')) {
        readingOptions = false;
        explanation = trimmed.substring(12).trim();
      } else if (key.startsWith('success_title:')) {
        readingOptions = false;
        successTitle = trimmed.substring(14).trim();
      } else if (key.startsWith('success_msg:')) {
        readingOptions = false;
        successMsg = trimmed.substring(12).trim();
      } else if (key.startsWith('error_title:')) {
        readingOptions = false;
        errorTitle = trimmed.substring(12).trim();
      } else if (key.startsWith('error_msg:')) {
        readingOptions = false;
        errorMsg = trimmed.substring(10).trim();
      }
    }

    return QuizSlide(
      id: id,
      title: title,
      question: question,
      options: options,
      correctAnswer: correct,
      explanation: explanation,
      successTitle: successTitle,
      successMsg: successMsg,
      errorTitle: errorTitle,
      errorMsg: errorMsg,
    );
  }

  static OutroSlide _parseOutro(String id, String text) {
    final title = _extractTitle(text, fallback: 'Bab Selesai!');
    final summary = text
        .replaceAll(RegExp(r'\[TIPE: [A-Z_]+\]'), '')
        .replaceAll(RegExp(r'^#\s+.*$', multiLine: true), '')
        .replaceAll(RegExp(r'```outro[\s\S]*?```'), '')
        .trim();

    final block = _extractCustomBlock(text, 'outro');
    var accuracy = '100%';
    var xpEarned = 50;
    var learningTime = '5m';
    final masteredConcepts = <String>[];
    String? nextLessonSlug;

    var readingConcepts = false;

    for (final rawLine in block.split('\n')) {
      final trimmed = rawLine.trim();
      if (trimmed.startsWith('accuracy:')) {
        readingConcepts = false;
        accuracy = trimmed.substring(9).trim();
      } else if (trimmed.startsWith('xp_earned:')) {
        readingConcepts = false;
        xpEarned = int.tryParse(trimmed.substring(10).trim()) ?? 50;
      } else if (trimmed.startsWith('learning_time:')) {
        readingConcepts = false;
        learningTime = trimmed.substring(14).trim();
      } else if (trimmed.startsWith('next_lesson_slug:')) {
        readingConcepts = false;
        nextLessonSlug = trimmed.substring(17).trim();
      } else if (trimmed.startsWith('mastered_concepts:')) {
        readingConcepts = true;
      } else if (readingConcepts && trimmed.startsWith('-')) {
        masteredConcepts.add(trimmed.substring(1).trim());
      }
    }

    return OutroSlide(
      id: id,
      title: title,
      summary: summary.isEmpty ? 'Selamat! Kamu telah menyelesaikan bab ini dengan baik.' : summary,
      accuracy: accuracy,
      xpEarned: xpEarned,
      learningTime: learningTime,
      masteredConcepts: masteredConcepts.isEmpty
          ? ['Menguasai alur dasar bab ini', 'Memahami struktur sintaks dan logika program']
          : masteredConcepts,
      nextLessonSlug: nextLessonSlug,
    );
  }

  static String _extractCustomBlock(String text, String blockTag) {
    final regex = RegExp('```$blockTag\\r?\\n([\\s\\S]*?)```');
    final match = regex.firstMatch(text);
    return match?.group(1)?.trim() ?? '';
  }

  static List<String> _parseJsonOrYamlList(String input) {
    final trimmed = input.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is List) {
          return decoded.map((e) => e.toString()).toList();
        }
      } catch (_) {
        // Fallback simple comma split
        final inner = trimmed.substring(1, trimmed.length - 1);
        return inner
            .split(',')
            .map((s) => s.trim().replaceAll(RegExp(r'^"|"$'), ''))
            .where((s) => s.isNotEmpty)
            .toList();
      }
    }
    return [trimmed];
  }
}
