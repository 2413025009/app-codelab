import '../domain/lesson_repository.dart';
import '../domain/slide_models.dart';

class MockLessonRepository implements LessonRepository {
  const MockLessonRepository();

  @override
  Future<LessonDetailData> getLessonDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final all = await listAllLessons();
    for (final l in all) {
      if (l.id == id || l.slug == id) {
        return l;
      }
    }
    // Return first lesson as fallback
    return all.first;
  }

  @override
  Future<void> saveProgress({
    required String id,
    required int currentSlideIndex,
    required double progressPercent,
    required bool completed,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }

  @override
  Future<List<LessonDetailData>> listAllLessons() async {
    return _mockLessons;
  }

  static final List<LessonDetailData> _mockLessons = [
    // Track 1 - Bab 1
    LessonDetailData(
      id: '11111111-1111-1111-1111-111111111101',
      title: 'Pengenalan & Variabel Python',
      slug: 'pengenalan-variabel',
      topic: 'Python Dasar',
      level: 'beginner',
      orderIndex: 1,
      xpReward: 50,
      status: 'completed',
      progressPercent: 100.0,
      currentSlideIndex: 7,
      slides: [
        const TheorySlide(
          id: 's1',
          title: 'Mengenal Variabel di Python',
          content: 'Menyimpan nilai ke dalam variabel itu ibarat memasukkan barang ke dalam kotak berlabel.\n\nNama variabel adalah label pada kotak, sedangkan isi di dalamnya adalah nilai data yang kamu simpan.',
          codeFileName: 'contoh_variabel.py',
          codeSnippet: 'nama_siswa = "Farhan"\numur = 16\nprint("Halo, ", nama_siswa)',
        ),
        const TapToFillSlide(
          id: 's2',
          title: 'Lengkapi Variabel Berikut!',
          file: 'main.py',
          codeLines: ['nama_siswa = [slot]', 'print([slot])'],
          options: ['"Farhan"', 'nama_siswa', 'umur', '16'],
          correctAnswers: ['"Farhan"', 'nama_siswa'],
          successTitle: 'Tepat Sekali!',
          successMsg: 'Kamu berhasil memasangkan nilai string "Farhan" ke dalam nama_siswa.',
        ),
        const TypeCodeSlide(
          id: 's3',
          title: 'Ketik Perintahnya!',
          file: 'latihan_print.py',
          instruction: 'Ketik nama fungsi untuk mencetak teks ke layar!',
          codeTemplate: '[input](pesan)',
          expectedAnswer: 'print',
          hint: 'Perintah berawalan huruf p untuk mencetak.',
        ),
        const OutputPredictSlide(
          id: 's4',
          title: 'Tebak Output Terminal',
          codeSnippet: 'skor_awal = 50\nbonus = 25\ntotal_skor = skor_awal + bonus\nprint(total_skor)',
          question: 'Berapa nilai angka yang akan dicetak pada layar konsol?',
          options: ['50', '75', '5025', 'Error'],
          correctAnswer: '75',
        ),
        const BugHunterSlide(
          id: 's5',
          title: 'Cari Baris Error!',
          instruction: 'Ketuk baris kode yang rusak di bawah ini!',
          lines: [
            BugHunterLine(number: 1, code: 'nama_game = "Cyberpunk"'),
            BugHunterLine(number: 2, code: 'tahun_rilis = 2026'),
            BugHunterLine(number: 3, code: 'quote = \'\'Game terbaik di dunia"'),
          ],
          correctLine: 3,
          errorType: 'SyntaxError',
          explanation: 'Baris 3 mencampur petik tunggal dan petik ganda.',
        ),
        const QuizSlide(
          id: 's6',
          title: 'Kuis Pemahaman Konsep',
          question: 'Manakah penamaan variabel yang valid di Python?',
          options: ['2_nama_siswa = "Budi"', 'nama-siswa = "Budi"', 'nama_siswa = "Budi"', 'class = "Budi"'],
          correctAnswer: 'nama_siswa = "Budi"',
          explanation: 'Variabel tidak boleh diawali angka dan tidak boleh menggunakan strip.',
        ),
        const OutroSlide(
          id: 's7',
          title: 'Selamat, Bab 1 Tuntas!',
          summary: 'Luar biasa! Kamu telah menguasai konsep dasar wadah variabel dan sintaks penamaan Python.',
          accuracy: '100%',
          xpEarned: 50,
          learningTime: '5m',
          masteredConcepts: [
            'Memahami konsep wadah variabel dan penyimpanan data di memori',
            'Menguasai perintah print() untuk menampilkan variabel',
            'Memahami aturan penamaan valid berbasis snake_case',
          ],
          nextLessonSlug: 'tipe-data-operasi',
        ),
      ],
      contentMarkdown: '',
    ),
    // Track 1 - Bab 2
    LessonDetailData(
      id: '11111111-1111-1111-1111-111111111102',
      title: 'Tipe Data & Operasi Hitung',
      slug: 'tipe-data-operasi',
      topic: 'Python Dasar',
      level: 'beginner',
      orderIndex: 2,
      xpReward: 60,
      status: 'completed',
      progressPercent: 100.0,
      currentSlideIndex: 6,
      slides: [
        const TheorySlide(
          id: 's1',
          title: 'Mengenal Tipe Data Python',
          content: 'Python mengenali beberapa tipe data mendasar: String (str), Integer (int), Float (float), dan Boolean (bool).',
          codeFileName: 'tipe_data.py',
          codeSnippet: 'teks = "SMK Bisa"\njumlah = 42\nharga = 99.5\naktif = True',
        ),
        const TapToFillSlide(
          id: 's2',
          title: 'Lengkapi Operasi Penjumlahan',
          file: 'hitung.py',
          codeLines: ['a = 10', 'b = 20', 'hasil = a [slot] b'],
          options: ['+', '-', '*', '/'],
          correctAnswers: ['+'],
        ),
        const TypeCodeSlide(
          id: 's3',
          title: 'Konversi String ke Integer',
          file: 'casting.py',
          instruction: 'Ketik fungsi untuk mengubah string menjadi angka bulat:',
          codeTemplate: 'angka = [input]("125")',
          expectedAnswer: 'int',
        ),
        const OutputPredictSlide(
          id: 's4',
          title: 'Tebak Tipe Data Boolean',
          codeSnippet: 'x = 15\ny = 20\nprint(x < y)',
          question: 'Apa output dari ekspresi print(x < y)?',
          options: ['True', 'False', '15', 'Error'],
          correctAnswer: 'True',
        ),
        const QuizSlide(
          id: 's5',
          title: 'Kuis Operator Modulo',
          question: 'Simbol manakah yang digunakan untuk mencari sisa bagi di Python?',
          options: ['//', '%', '**', '/'],
          correctAnswer: '%',
          explanation: 'Operator % adalah modulo untuk mencari sisa bagi matematika.',
        ),
        const OutroSlide(
          id: 's6',
          title: 'Selamat, Bab 2 Selesai!',
          summary: 'Hebat! Kamu telah memahami 4 tipe data utama dan operasi matematika.',
          accuracy: '100%',
          xpEarned: 60,
          learningTime: '6m',
          masteredConcepts: [
            'Memahami int, float, str, dan bool',
            'Melakukan operasi hitung aritmatika',
            'Memahami operator sisa bagi modulo (%)',
          ],
          nextLessonSlug: 'percabangan-if-else',
        ),
      ],
      contentMarkdown: '',
    ),
    // Track 1 - Bab 3
    LessonDetailData(
      id: '11111111-1111-1111-1111-111111111103',
      title: 'Percabangan Logika If-Else',
      slug: 'percabangan-if-else',
      topic: 'Python Dasar',
      level: 'beginner',
      orderIndex: 3,
      xpReward: 70,
      status: 'active',
      progressPercent: 35.0,
      currentSlideIndex: 3,
      slides: [
        const TheorySlide(
          id: 's1',
          title: 'Logika Keputusan If-Else',
          content: 'Dalam pemrograman, komputer perlu mengambil keputusan berdasarkan syarat tertentu, mirip seperti memilih membawa payung saat mendung.',
          codeFileName: 'kondisi.py',
          codeSnippet: 'nilai = 85\nif nilai >= 75:\n    print("Kompeten")\nelse:\n    print("Belum kompeten")',
        ),
        const TapToFillSlide(
          id: 's2',
          title: 'Lengkapi Sintaks Percabangan',
          file: 'evaluasi.py',
          codeLines: ['[slot] umur >= 17:', '    print("Boleh ikut")', '[slot]:', '    print("Belum cukup umur")'],
          options: ['if', 'else', 'elif', 'while'],
          correctAnswers: ['if', 'else'],
        ),
        const TypeCodeSlide(
          id: 's3',
          title: 'Ketik Operator Perbandingan',
          file: 'cek_sama.py',
          instruction: 'Ketik operator untuk mengecek apakah dua nilai bernilai sama persis:',
          codeTemplate: 'if status [input] "lulus":',
          expectedAnswer: '==',
        ),
        const OutputPredictSlide(
          id: 's4',
          title: 'Tebak Cabang Kondisi',
          codeSnippet: 'suhu = 38\nif suhu > 37:\n    print("Demam")\nelse:\n    print("Normal")',
          question: 'Apa kata yang akan dicetak oleh konsol?',
          options: ['Demam', 'Normal', 'True', '38'],
          correctAnswer: 'Demam',
        ),
        const BugHunterSlide(
          id: 's5',
          title: 'Cari Titik Dua ( : ) yang Hilang!',
          instruction: 'Ketuk baris yang melanggar sintaks percabangan Python:',
          lines: [
            BugHunterLine(number: 1, code: 'skor = 90'),
            BugHunterLine(number: 2, code: 'if skor > 75'),
            BugHunterLine(number: 3, code: '    print("Bagus")'),
          ],
          correctLine: 2,
          errorType: 'SyntaxError',
          explanation: 'Setiap pernyataan if wajib diakhiri tanda titik dua (:).',
        ),
        const QuizSlide(
          id: 's6',
          title: 'Kuis Multi-Kondisi Elif',
          question: 'Kata kunci apakah yang dipakai di Python jika ingin memeriksa cabang alternatif kedua?',
          options: ['else if', 'elif', 'elseif', 'or if'],
          correctAnswer: 'elif',
          explanation: 'Python menggunakan kata kunci elif untuk mengevaluasi multi-kondisi.',
        ),
        const OutroSlide(
          id: 's7',
          title: 'Selamat, Bab Percabangan Selesai!',
          summary: 'Dahsyat! Kamu telah menguasai logika percabangan if, elif, dan else.',
          accuracy: '100%',
          xpEarned: 70,
          learningTime: '7m',
          masteredConcepts: [
            'Memahami ekspresi kondisi if dan else',
            'Menggunakan operator pembanding ==, !=, >, <',
            'Memahami pentingnya indentasi dan titik dua (:)',
          ],
        ),
      ],
      contentMarkdown: '',
    ),
    // Track 2 - Bab 1
    LessonDetailData(
      id: '22222222-2222-2222-2222-222222222201',
      title: 'Struktur Dasar Dokumen HTML',
      slug: 'struktur-dasar-html',
      topic: 'HTML & Web Dasar',
      level: 'beginner',
      orderIndex: 4,
      xpReward: 50,
      status: 'locked',
      progressPercent: 0.0,
      currentSlideIndex: 1,
      requiredLessonTitle: 'Percabangan Logika If-Else',
      slides: [
        const TheorySlide(
          id: 's1',
          title: 'Kerangka Utama Web',
          content: 'HTML (HyperText Markup Language) adalah bahasa standar untuk menyusun kerangka struktur halaman web modern.',
          codeFileName: 'index.html',
          codeSnippet: '<!DOCTYPE html>\n<html>\n  <head>\n    <title>Web Saya</title>\n  </head>\n  <body>\n    <h1>Halo Dunia</h1>\n  </body>\n</html>',
        ),
        const TapToFillSlide(
          id: 's2',
          title: 'Susun Tag Penutup HTML',
          file: 'halaman.html',
          codeLines: ['<h1>Judul Web</h1>', '[slot]Paragraf pembuka.[slot]'],
          options: ['<p>', '</p>', '<div>', '</span>'],
          correctAnswers: ['<p>', '</p>'],
        ),
        const TypeCodeSlide(
          id: 's3',
          title: 'Ketik Tag Judul Utama',
          file: 'header.html',
          instruction: 'Ketik nama tag untuk judul paling besar di HTML (level 1):',
          codeTemplate: '<[input]>Selamat Datang</[input]>',
          expectedAnswer: 'h1',
        ),
        const QuizSlide(
          id: 's4',
          title: 'Kuis Bagian Konten Visual',
          question: 'Bagian elemen manakah yang menampilkan seluruh konten visual di jendela browser?',
          options: ['<head>', '<body>', '<title>', '<meta>'],
          correctAnswer: '<body>',
          explanation: 'Elemen <body> memuat semua konten yang dilihat pengunjung web.',
        ),
        const OutroSlide(
          id: 's5',
          title: 'Selamat, Pengenalan HTML Selesai!',
          summary: 'Bagus! Kamu telah memahami kerangka tag HTML dan struktur dokumen web.',
          accuracy: '100%',
          xpEarned: 50,
          learningTime: '5m',
          masteredConcepts: [
            'Memahami fungsi DOCTYPE dan elemen root <html>',
            'Membedakan peranan elemen <head> dan <body>',
            'Menggunakan tag heading dan paragraf standar',
          ],
        ),
      ],
      contentMarkdown: '',
    ),
    // Track 2 - Bab 2
    LessonDetailData(
      id: '22222222-2222-2222-2222-222222222202',
      title: 'Teks, Tautan & Gambar Web',
      slug: 'teks-tautan-gambar',
      topic: 'HTML & Web Dasar',
      level: 'beginner',
      orderIndex: 5,
      xpReward: 60,
      status: 'locked',
      progressPercent: 0.0,
      currentSlideIndex: 1,
      requiredLessonTitle: 'Struktur Dasar Dokumen HTML',
      slides: [
        const TheorySlide(
          id: 's1',
          title: 'Menyematkan Media & Tautan',
          content: 'Halaman web menjadi hidup dengan adanya gambar (tag <img>) dan tautan antar halaman (tag <a>).',
          codeFileName: 'media.html',
          codeSnippet: '<a href="https://codelab.id">Buka CodeLab</a>\n<img src="logo.png" alt="Logo Sekolah">',
        ),
        const TapToFillSlide(
          id: 's2',
          title: 'Lengkapi Atribut Tautan',
          file: 'navigasi.html',
          codeLines: ['<a [slot]="tentang.html">Tentang Kami</a>'],
          options: ['href', 'src', 'alt', 'link'],
          correctAnswers: ['href'],
        ),
        const TypeCodeSlide(
          id: 's3',
          title: 'Ketik Atribut Gambar',
          file: 'gambar.html',
          instruction: 'Ketik nama atribut untuk sumber URL gambar:',
          codeTemplate: '<img [input]="foto.jpg" alt="Foto Siswa">',
          expectedAnswer: 'src',
        ),
        const QuizSlide(
          id: 's4',
          title: 'Kuis Atribut Aksesibilitas',
          question: 'Atribut apakah yang wajib disematkan pada tag img untuk deskripsi pembaca layar (screen reader)?',
          options: ['alt', 'title', 'desc', 'caption'],
          correctAnswer: 'alt',
          explanation: 'Atribut alt menyediakan teks alternatif untuk aksesibilitas dan SEO.',
        ),
        const OutroSlide(
          id: 's5',
          title: 'Bab Teks & Gambar Tuntas!',
          summary: 'Hebat! Kamu sudah bisa membuat tautan hiperteks dan menyisipkan aset visual.',
          accuracy: '100%',
          xpEarned: 60,
          learningTime: '5m',
          masteredConcepts: [
            'Membuat tautan internal dan eksternal dengan tag <a>',
            'Menampilkan gambar menggunakan atribut src dan alt',
          ],
        ),
      ],
      contentMarkdown: '',
    ),
    // Track 2 - Bab 3
    LessonDetailData(
      id: '22222222-2222-2222-2222-222222222203',
      title: 'Formulir & Masukan Pengguna Web',
      slug: 'formulir-input-web',
      topic: 'HTML & Web Dasar',
      level: 'beginner',
      orderIndex: 6,
      xpReward: 70,
      status: 'locked',
      progressPercent: 0.0,
      currentSlideIndex: 1,
      requiredLessonTitle: 'Teks, Tautan & Gambar Web',
      slides: [
        const TheorySlide(
          id: 's1',
          title: 'Interaksi dengan Formulir',
          content: 'Formulir HTML memungkinkan pengguna memasukkan data seperti formulir login, registrasi siswa, atau survei.',
          codeFileName: 'form.html',
          codeSnippet: '<form action="/kirim" method="POST">\n  <label>Nama Siswa:</label>\n  <input type="text" name="nama">\n  <button type="submit">Kirim</button>\n</form>',
        ),
        const TapToFillSlide(
          id: 's2',
          title: 'Lengkapi Tipe Input Password',
          file: 'login.html',
          codeLines: ['<input type="[slot]" name="kata_sandi">'],
          options: ['password', 'text', 'hidden', 'secure'],
          correctAnswers: ['password'],
        ),
        const TypeCodeSlide(
          id: 's3',
          title: 'Ketik Tag Tombol',
          file: 'tombol.html',
          instruction: 'Ketik tag untuk membuat tombol aksi formulir:',
          codeTemplate: '<[input] type="submit">Kirim Data</[input]>',
          expectedAnswer: 'button',
        ),
        const QuizSlide(
          id: 's4',
          title: 'Kuis Masukan Angka',
          question: 'Nilai atribut type apakah yang membuat input hanya menerima masukan digit numerik di ponsel?',
          options: ['number', 'digit', 'int', 'calc'],
          correctAnswer: 'number',
          explanation: 'type="number" memunculkan papan ketik numerik di peramban ponsel.',
        ),
        const OutroSlide(
          id: 's5',
          title: 'Selamat, Track Web Dasar Selesai!',
          summary: 'Luar biasa! Kamu telah menguasai formulir input web interaktif.',
          accuracy: '100%',
          xpEarned: 70,
          learningTime: '6m',
          masteredConcepts: [
            'Membuat elemen <form> dengan atribut method dan action',
            'Memahami variasi jenis elemen <input> (text, password, number)',
            'Membuat tombol submit interaktif',
          ],
        ),
      ],
      contentMarkdown: '',
    ),
  ];
}
