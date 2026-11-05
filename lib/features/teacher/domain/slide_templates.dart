import '../../../../l10n/app_localizations.dart';

/// Template awal untuk setiap tipe slide.
///
/// Dipakai oleh Bab Builder saat guru menambah slide baru dan oleh layar
/// editor slide ketika guru menekan "Pakai Template Awal". Dengan begitu
/// tujuh tipe soal selalu punya bentuk data yang lengkap, bukan map kosong.
abstract final class SlideTemplates {
  static const List<String> supportedTypes = [
    'THEORY',
    'TAP_TO_FILL',
    'TYPE_CODE',
    'OUTPUT_PREDICT',
    'BUG_HUNTER',
    'QUIZ',
    'OUTRO',
  ];

  static String normalize(Object? raw) {
    final type = (raw ?? '').toString().trim().toUpperCase();
    return supportedTypes.contains(type) ? type : 'THEORY';
  }

  static String label(String type, {AppLocalizations? l10n}) {
    switch (normalize(type)) {
      case 'TAP_TO_FILL':
        return l10n?.tTemplateLabelTapToFill ?? 'Lengkapi Kode (Tap)';
      case 'TYPE_CODE':
        return l10n?.tTemplateLabelTypeCode ?? 'Ketik Kata Kunci';
      case 'OUTPUT_PREDICT':
        return l10n?.tTemplateLabelOutputPredict ?? 'Tebak Output Kode';
      case 'BUG_HUNTER':
        return l10n?.tTemplateLabelBugHunter ?? 'Bug Hunter';
      case 'QUIZ':
        return l10n?.tTemplateLabelQuiz ?? 'Kuis Pilihan Ganda';
      case 'OUTRO':
        return l10n?.tTemplateLabelOutro ?? 'Rangkuman & Klaim XP';
      case 'THEORY':
      default:
        return l10n?.tTemplateLabelTheory ?? 'Teori & Konsep';
    }
  }

  static String badge(String type, {AppLocalizations? l10n}) {
    switch (normalize(type)) {
      case 'TAP_TO_FILL':
        return l10n?.tTemplateBadgeInteractive ?? 'Interaktif';
      case 'TYPE_CODE':
        return l10n?.tTemplateBadgeSyntax ?? 'Sintaks';
      case 'OUTPUT_PREDICT':
        return l10n?.tTemplateBadgeLogic ?? 'Logika';
      case 'BUG_HUNTER':
        return l10n?.tTemplateBadgeDebugging ?? 'Debugging';
      case 'QUIZ':
        return l10n?.tTemplateBadgeEvaluation ?? 'Evaluasi';
      case 'OUTRO':
        return l10n?.tTemplateBadgeAchievement ?? 'Pencapaian';
      case 'THEORY':
      default:
        return l10n?.tTemplateBadgeReading ?? 'Bahan Baca';
    }
  }

  static String description(String type, {AppLocalizations? l10n}) {
    switch (normalize(type)) {
      case 'TAP_TO_FILL':
        return l10n?.tTemplateDescTapToFill ?? 'Siswa mengetuk keping blok untuk melengkapi baris kode.';
      case 'TYPE_CODE':
        return l10n?.tTemplateDescTypeCode ?? 'Siswa mengetik kata kunci atau ekspresi sintaksis.';
      case 'OUTPUT_PREDICT':
        return l10n?.tTemplateDescOutputPredict ?? 'Siswa memprediksi keluaran terminal dari potongan kode.';
      case 'BUG_HUNTER':
        return l10n?.tTemplateDescBugHunter ?? 'Siswa menemukan baris yang bermasalah dan perbaikannya.';
      case 'QUIZ':
        return l10n?.tTemplateDescQuiz ?? 'Pertanyaan pilihan ganda dengan satu jawaban benar.';
      case 'OUTRO':
        return l10n?.tTemplateDescOutro ?? 'Slide penutup dengan rangkuman dan hadiah XP.';
      case 'THEORY':
      default:
        return l10n?.tTemplateDescTheory ?? 'Teks penjelasan konsep materi dan contoh kode.';
    }
  }

  /// Membuat map slide baru yang siap diedit.
  ///
  /// [id] opsional; bila kosong dibuat unik dari waktu saat ini.
  static Map<String, dynamic> create(
    String type, {
    String? id,
    int xpReward = 50,
    AppLocalizations? l10n,
  }) {
    final normalized = normalize(type);
    final slideId =
        id ??
        'slide_${DateTime.now().microsecondsSinceEpoch}_${normalized.toLowerCase()}';

    switch (normalized) {
      case 'TAP_TO_FILL':
        return {
          'id': slideId,
          'type': normalized,
          'title': l10n?.tTemplateTitleTapToFill ?? 'Lengkapi Kode',
          'prompt': l10n?.tTemplatePromptTapToFill ?? 'Ketuk balok kode untuk melengkapi baris berikut.',
          'template': 'x = ___1___\nprint(x)',
          'blanks': ['10'],
          'distractors': ['20', 'print'],
          'code_lang': 'Python',
        };
      case 'TYPE_CODE':
        return {
          'id': slideId,
          'type': normalized,
          'title': l10n?.tTemplateLabelTypeCode ?? 'Ketik Kata Kunci',
          'prompt': l10n?.tTemplatePromptTypeCode ?? 'Ketikkan fungsi untuk mencetak teks ke layar:',
          'code': '[KETIK_DISINI] ("Halo")',
          'answer': 'print',
          'hint': l10n?.tTemplateHintTypeCode ?? 'Gunakan huruf kecil semua.',
        };
      case 'OUTPUT_PREDICT':
        return {
          'id': slideId,
          'type': normalized,
          'title': l10n?.tTemplateTitleOutputPredict ?? 'Tebak Output',
          'prompt': l10n?.tTemplatePromptOutputPredict ?? 'Apakah output yang dicetak ke terminal?',
          'code': 'a = 5\nb = 3\nprint(a + b)',
          'options': ['8', '53', '5 + 3', 'Error'],
          'answer': 'A',
          'explanation': l10n?.tTemplateExplanationOutputPredict ?? 'Operator + menjumlahkan dua bilangan bulat.',
        };
      case 'BUG_HUNTER':
        return {
          'id': slideId,
          'type': normalized,
          'title': l10n?.tTemplateTitleBugHunter ?? 'Temukan Galat (Bug)',
          'scenario': l10n?.tTemplateScenarioBugHunter ?? 'Siswa memeriksa program yang gagal dijalankan.',
          'buggy_code': 'total = 0\nfor i in range(10)\n    total += i',
          'target_line': '2',
          'bug_hint': l10n?.tTemplateBugHintBugHunter ?? 'Periksa tanda titik dua di akhir baris for.',
          'fix': 'for i in range(10):',
          'error_type': 'SyntaxError',
        };
      case 'QUIZ':
        return {
          'id': slideId,
          'type': normalized,
          'title': l10n?.tTemplateLabelQuiz ?? 'Kuis Pilihan Ganda',
          'question': l10n?.tTemplateQuestionQuiz ?? 'Manakah yang termasuk tipe data angka bulat?',
          'options': ['int', 'string', 'boolean', 'list'],
          'answer': 'A',
          'explanation': l10n?.tTemplateExplanationQuiz ?? 'int adalah tipe data bilangan bulat.',
        };
      case 'OUTRO':
        return {
          'id': slideId,
          'type': normalized,
          'title': l10n?.tTemplateTitleOutro ?? 'Rangkuman Bab',
          'summary': l10n?.tTemplateSummaryOutro ?? 'Hebat! Kamu telah menuntaskan materi pada bab ini.',
          'xp_preview': xpReward,
          'mastered_concepts': [l10n?.tAdapterMainConcept ?? 'Konsep Utama'],
        };
      case 'THEORY':
      default:
        return {
          'id': slideId,
          'type': 'THEORY',
          'title': l10n?.tTemplateTitleTheory ?? 'Penjelasan Materi Baru',
          'content':
              l10n?.tTemplateContentTheory ??
              'Tuliskan penjelasan materi pembelajaran di sini dengan bahasa yang mudah dipahami siswa.',
          'sample_code': '',
          'code_lang': 'Python',
        };
    }
  }

  /// Salinan aman (list tidak ikut terbagi antar-slide).
  static Map<String, dynamic> copy(Map<String, dynamic> source) {
    return {
      for (final entry in source.entries)
        entry.key: entry.value is List
            ? List<dynamic>.from(entry.value as List)
            : entry.value,
    };
  }
}
