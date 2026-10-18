import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/features/lesson/domain/lesson_parser.dart';
import 'package:mobile_codelab_ai/features/lesson/domain/slide_models.dart';

void main() {
  group('LessonParser Tests', () {
    test('parses 7 distinct slide types accurately from markdown', () {
      const sampleMarkdown = '''
[TIPE: THEORY]
# 1. Mengenal Variabel
Variabel adalah wadah penyimpan data.
```python
# contoh.py
nama = "Farhan"
```

---

[TIPE: TAP_TO_FILL]
# 2. Susun Variabel
```tap_to_fill
file: main.py
code: nama = [slot]
options: ["Farhan", "Budi"]
correct: ["Farhan"]
success_title: Bagus!
success_msg: Sukses.
```

---

[TIPE: TYPE_CODE]
# 3. Ketik Perintah
```type_code
file: print.py
instruction: Ketik print
code: [input]("Halo")
expected: print
hint: Awalan p
```

---

[TIPE: OUTPUT_PREDICT]
# 4. Tebak Output
```python
x = 10 + 5
print(x)
```
```output_predict
question: Apa output?
options:
  - "15"
  - "10"
correct: "15"
```

---

[TIPE: BUG_HUNTER]
# 5. Cari Baris Rusak
```bug_hunter
instruction: Ketuk baris error
lines:
  - line: 1 | a = 1
  - line: 2 | b = "teks
correct_line: 2
error_type: SyntaxError
```

---

[TIPE: QUIZ]
# 6. Kuis
```quiz
question: Apa itu Python?
options:
  - Bahasa Pemrograman
  - Ular
correct: Bahasa Pemrograman
```

---

[TIPE: OUTRO]
# 7. Selesai
Selamat telah menyelesaikan bab ini!
```outro
accuracy: 100%
xp_earned: 50
learning_time: 5m
mastered_concepts:
  - Variabel
  - Tipe Data
```
''';

      final slides = LessonParser.parseSlides(sampleMarkdown, defaultTitle: 'Bab 1');
      expect(slides.length, 7);

      expect(slides[0], isA<TheorySlide>());
      expect((slides[0] as TheorySlide).title, '1. Mengenal Variabel');
      expect((slides[0] as TheorySlide).codeFileName, 'contoh.py');

      expect(slides[1], isA<TapToFillSlide>());
      expect((slides[1] as TapToFillSlide).correctAnswers, ['Farhan']);

      expect(slides[2], isA<TypeCodeSlide>());
      expect((slides[2] as TypeCodeSlide).expectedAnswer, 'print');

      expect(slides[3], isA<OutputPredictSlide>());
      expect((slides[3] as OutputPredictSlide).correctAnswer, '15');

      expect(slides[4], isA<BugHunterSlide>());
      expect((slides[4] as BugHunterSlide).correctLine, 2);

      expect(slides[5], isA<QuizSlide>());
      expect((slides[5] as QuizSlide).correctAnswer, 'Bahasa Pemrograman');

      expect(slides[6], isA<OutroSlide>());
      expect((slides[6] as OutroSlide).xpEarned, 50);
      expect((slides[6] as OutroSlide).masteredConcepts.length, 2);
    });

    test('handles empty and malformed markdown gracefully without crash', () {
      final emptySlides = LessonParser.parseSlides('', defaultTitle: 'Fallback');
      expect(emptySlides.length, 1);
      expect(emptySlides[0], isA<TheorySlide>());

      final malformedSlides = LessonParser.parseSlides('Ini teks biasa tanpa tipe slide', defaultTitle: 'Fallback');
      expect(malformedSlides.length, 1);
      expect(malformedSlides[0], isA<TheorySlide>());
    });

    // P2-14: dua-dua gaya penulisan quiz didukung — field `correct:` ala seed
    // DB maupun marker inline `[correct]` ala docs/CONTOH_LESSON.md, dengan
    // tolerant huruf besar/kecil pada nama kunci.
    test('parses inline [correct] marker and tolerant casing in quiz block', () {
      const styleA = '''
[TIPE: QUIZ]
# Kuis Gaya A
```quiz
Question: Apa itu Python?
Options:
  - Bahasa Pemrograman [correct]
  - Ular
Explanation: Python ialah bahasa pemrograman.
```
''';

      final slidesA = LessonParser.parseSlides(styleA, defaultTitle: 'Bab A');
      final quizA = slidesA.whereType<QuizSlide>().first;
      expect(quizA.options, ['Bahasa Pemrograman', 'Ular']);
      expect(quizA.correctAnswer, 'Bahasa Pemrograman');
      expect(quizA.explanation, 'Python ialah bahasa pemrograman.');
      // Marker tidak boleh sampai tampil di teks UI.
      expect(quizA.options.first.contains('[correct]'), isFalse);

      const styleB = '''
[TIPE: QUIZ]
# Kuis Gaya B
```quiz
question: Apa itu Python?
options: ["Bahasa Pemrograman", "Ular"]
correct: Bahasa Pemrograman
```
''';

      final slidesB = LessonParser.parseSlides(styleB, defaultTitle: 'Bab B');
      final quizB = slidesB.whereType<QuizSlide>().first;
      expect(quizB.correctAnswer, 'Bahasa Pemrograman');
    });
  });
}
