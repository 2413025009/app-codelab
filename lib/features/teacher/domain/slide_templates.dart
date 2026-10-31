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

  static String label(String type) {
    switch (normalize(type)) {
      case 'TAP_TO_FILL':
        return 'Lengkapi Kode (Tap)';
      case 'TYPE_CODE':
        return 'Ketik Kata Kunci';
      case 'OUTPUT_PREDICT':
        return 'Tebak Output Kode';
      case 'BUG_HUNTER':
        return 'Bug Hunter';
      case 'QUIZ':
        return 'Kuis Pilihan Ganda';
      case 'OUTRO':
        return 'Rangkuman & Klaim XP';
      case 'THEORY':
      default:
        return 'Teori & Konsep';
    }
  }

  static String badge(String type) {
    switch (normalize(type)) {
      case 'TAP_TO_FILL':
        return 'Interaktif';
      case 'TYPE_CODE':
        return 'Sintaks';
      case 'OUTPUT_PREDICT':
        return 'Logika';
      case 'BUG_HUNTER':
        return 'Debugging';
      case 'QUIZ':
        return 'Evaluasi';
      case 'OUTRO':
        return 'Pencapaian';
      case 'THEORY':
      default:
        return 'Bahan Baca';
    }
  }

  static String description(String type) {
    switch (normalize(type)) {
      case 'TAP_TO_FILL':
        return 'Siswa mengetuk keping blok untuk melengkapi baris kode.';
      case 'TYPE_CODE':
        return 'Siswa mengetik kata kunci atau ekspresi sintaksis.';
      case 'OUTPUT_PREDICT':
        return 'Siswa memprediksi keluaran terminal dari potongan kode.';
      case 'BUG_HUNTER':
        return 'Siswa menemukan baris yang bermasalah dan perbaikannya.';
      case 'QUIZ':
        return 'Pertanyaan pilihan ganda dengan satu jawaban benar.';
      case 'OUTRO':
        return 'Slide penutup dengan rangkuman dan hadiah XP.';
      case 'THEORY':
      default:
        return 'Teks penjelasan konsep materi dan contoh kode.';
    }
  }

  /// Membuat map slide baru yang siap diedit.
  ///
  /// [id] opsional; bila kosong dibuat unik dari waktu saat ini.
  static Map<String, dynamic> create(
    String type, {
    String? id,
    int xpReward = 50,
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
          'title': 'Lengkapi Kode',
          'prompt': 'Ketuk balok kode untuk melengkapi baris berikut.',
          'template': 'x = ___1___\nprint(x)',
          'blanks': ['10'],
          'distractors': ['20', 'print'],
          'code_lang': 'Python',
        };
      case 'TYPE_CODE':
        return {
          'id': slideId,
          'type': normalized,
          'title': 'Ketik Kata Kunci',
          'prompt': 'Ketikkan fungsi untuk mencetak teks ke layar:',
          'code': '[KETIK_DISINI] ("Halo")',
          'answer': 'print',
          'hint': 'Gunakan huruf kecil semua.',
        };
      case 'OUTPUT_PREDICT':
        return {
          'id': slideId,
          'type': normalized,
          'title': 'Tebak Output',
          'prompt': 'Apakah output yang dicetak ke terminal?',
          'code': 'a = 5\nb = 3\nprint(a + b)',
          'options': ['8', '53', '5 + 3', 'Error'],
          'answer': 'A',
          'explanation': 'Operator + menjumlahkan dua bilangan bulat.',
        };
      case 'BUG_HUNTER':
        return {
          'id': slideId,
          'type': normalized,
          'title': 'Temukan Galat (Bug)',
          'scenario': 'Siswa memeriksa program yang gagal dijalankan.',
          'buggy_code': 'total = 0\nfor i in range(10)\n    total += i',
          'target_line': '2',
          'bug_hint': 'Periksa tanda titik dua di akhir baris for.',
          'fix': 'for i in range(10):',
          'error_type': 'SyntaxError',
        };
      case 'QUIZ':
        return {
          'id': slideId,
          'type': normalized,
          'title': 'Kuis Pilihan Ganda',
          'question': 'Manakah yang termasuk tipe data angka bulat?',
          'options': ['int', 'string', 'boolean', 'list'],
          'answer': 'A',
          'explanation': 'int adalah tipe data bilangan bulat.',
        };
      case 'OUTRO':
        return {
          'id': slideId,
          'type': normalized,
          'title': 'Rangkuman Bab',
          'summary': 'Hebat! Kamu telah menuntaskan materi pada bab ini.',
          'xp_preview': xpReward,
          'mastered_concepts': ['Konsep Utama'],
        };
      case 'THEORY':
      default:
        return {
          'id': slideId,
          'type': 'THEORY',
          'title': 'Penjelasan Materi Baru',
          'content':
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
