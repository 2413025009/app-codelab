import '../domain/dashboard_repository.dart';

/// Static data mirroring the stitch dashboard. The seeded demo student sees
/// progress; any other account sees the empty (new user) state.
class MockDashboardRepository implements DashboardRepository {
  static const demoEmail = 'farhan@smk.belajar.id';

  @override
  Future<DashboardData> load({
    required String studentEmail,
    void Function(int done, int total, String stage)? onProgress,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));
    final isDemo = studentEmail.toLowerCase() == demoEmail;

    // Dataset mock selaras DB: 49 bab, 4 track
    // Python Dasar (12), HTML & Web Dasar (12), CSS Dasar (13), JavaScript Dasar (12)
    const titles = [
      // Track 1: Python Dasar
      ('pengenalan-variabel', 'Pengenalan & Variabel Python', 'Mengenal struktur penyimpanan nilai pertama', 'Python Dasar'),
      ('tipe-data-operasi', 'Tipe Data & Operasi Hitung', 'Angka, string, boolean, dan operasi hitung', 'Python Dasar'),
      ('percabangan-if-else', 'Percabangan Logika If-Else', 'Evaluasi kondisi boolean & branching', 'Python Dasar'),
      ('operator-python', 'Operator Python', 'Aritmatika, perbandingan, dan logika', 'Python Dasar'),
      ('string-python', 'String & Teks Python', 'Manipulasi teks, slicing, dan method', 'Python Dasar'),
      ('input-pengguna', 'Input Pengguna', 'Menerima input keyboard dan konversi tipe', 'Python Dasar'),
      ('list-python', 'List Python', 'Kumpulan data dinamis, indeks, dan method', 'Python Dasar'),
      ('perulangan-for', 'Perulangan For', 'Iterasi koleksi dan fungsi range', 'Python Dasar'),
      ('perulangan-while', 'Perulangan While', 'Loop kondisi dan penanganan break', 'Python Dasar'),
      ('tuple-dictionary', 'Tuple & Dictionary Python', 'Struktur data immutable dan key-value', 'Python Dasar'),
      ('fungsi-python', 'Fungsi Python', 'Membuat fungsi reusable dengan def dan return', 'Python Dasar'),
      ('proyek-mini-python', 'Proyek Mini Python', 'Integrasi kalkulator nilai siswa', 'Python Dasar'),

      // Track 2: HTML & Web Dasar
      ('struktur-dokumen-web', 'Struktur Dokumen Web Modern', 'HTML5 & struktur dokumen', 'HTML & Web Dasar'),
      ('format-teks-semantik', 'Teks, Paragraf & Format Semantik', 'Paragraf & semantik teks', 'HTML & Web Dasar'),
      ('link-media-gambar', 'Link Hyperlink & Media Gambar', 'Tautan, gambar & aksesibilitas', 'HTML & Web Dasar'),
      ('list-html', 'List: ul, ol dan dl', 'Tiga jenis daftar di HTML', 'HTML & Web Dasar'),
      ('tabel-html', 'Tabel HTML', 'Penyajian data tabular terstruktur', 'HTML & Web Dasar'),
      ('audio-video-html', 'Audio, Video dan iframe', 'Media multimedia dan sematan', 'HTML & Web Dasar'),
      ('semantik-layout', 'Elemen Semantik dan Layout', 'Struktur header, nav, main, footer', 'HTML & Web Dasar'),
      ('formulir-dasar', 'Formulir Dasar', 'Elemen form, input, dan label', 'HTML & Web Dasar'),
      ('formulir-lanjutan', 'Formulir Lanjutan', 'Pilihan select, textarea, dan validasi', 'HTML & Web Dasar'),
      ('atribut-global', 'Atribut Global', 'Penggunaan id, class, dan data-*', 'HTML & Web Dasar'),
      ('meta-seo', 'Meta Tag dan SEO Dasar', 'Pengaturan head dan optimasi mesin pencari', 'HTML & Web Dasar'),
      ('proyek-mini-html', 'Proyek Mini HTML', 'Halaman profil diri responsif', 'HTML & Web Dasar'),

      // Track 3: CSS Dasar
      ('pengenalan-css', 'Pengenalan CSS dan Cara Pasang', 'Konsep styling dan 3 cara pasang CSS', 'CSS Dasar'),
      ('selector-css', 'Selector: Tag, Class dan ID', 'Menargetkan elemen dengan spesifisitas', 'CSS Dasar'),
      ('warna-background', 'Warna dan Background', 'Model warna HEX, RGB, RGBA dan latar belakang', 'CSS Dasar'),
      ('teks-font', 'Teks dan Font', 'Tipografi web, font-family, dan perataan', 'CSS Dasar'),
      ('margin-padding', 'Box Model: Margin dan Padding', 'Anatomi kotak: content, padding, border, margin', 'CSS Dasar'),
      ('border-radius', 'Border dan Border Radius', 'Garis tepi dan sudut membulat modern', 'CSS Dasar'),
      ('ukuran-display', 'Ukuran dan Display Elemen', 'Sifat block, inline, dan inline-block', 'CSS Dasar'),
      ('position-css', 'Position dan Z-Index', 'Posisi relative, absolute, fixed, dan layer tumpukan', 'CSS Dasar'),
      ('flexbox-dasar', 'Flexbox Dasar', 'Tata letak satu dimensi dan flex-direction', 'CSS Dasar'),
      ('flexbox-lanjutan', 'Flexbox Lanjutan: Alignment dan Gap', 'Perataan justify-content, align-items, dan gap', 'CSS Dasar'),
      ('hover-transisi', 'Pseudo-class, Hover dan Transisi', 'Efek interaksi kursor halus', 'CSS Dasar'),
      ('responsive-css', 'Responsive Web: Media Query dan Unit', 'Satuan rem, vw, vh, dan media query', 'CSS Dasar'),
      ('proyek-mini-css', 'Proyek Mini: Kartu Profil Responsif', 'Integrasi kartu profil lengkap', 'CSS Dasar'),

      // Track 4: JavaScript Dasar
      ('pengenalan-javascript', 'Pengenalan JavaScript dan Console', 'Logika interaktif dan console.log', 'JavaScript Dasar'),
      ('variabel-js', 'Variabel: let dan const', 'Penyimpanan data dinamis dan konstan', 'JavaScript Dasar'),
      ('tipe-data-operator-js', 'Tipe Data dan Operator JS', 'Primitif JS dan perbandingan ketat ===', 'JavaScript Dasar'),
      ('string-js', 'String dan Template Literal', 'String interpolation modern dengan backtick', 'JavaScript Dasar'),
      ('percabangan-js', 'Percabangan: if, else dan switch', 'Logika percabangan kondisi', 'JavaScript Dasar'),
      ('perulangan-js', 'Perulangan: for dan while', 'Iterasi berulang for dan while loop', 'JavaScript Dasar'),
      ('array-js', 'Struktur Data Array di JS', 'Koleksi data berurutan, push, dan pop', 'JavaScript Dasar'),
      ('object-js', 'Struktur Data Object di JS', 'Data berpasangan key-value', 'JavaScript Dasar'),
      ('fungsi-js', 'Fungsi dan Arrow Function', 'Fungsi standar dan sintaks arrow function', 'JavaScript Dasar'),
      ('dom-js', 'DOM: Memilih dan Mengubah Elemen', 'Seleksi querySelector dan manipulasi teks', 'JavaScript Dasar'),
      ('event-js', 'Event: click dan addEventListener', 'Merespons interaksi pengguna', 'JavaScript Dasar'),
      ('proyek-mini-js', 'Proyek Mini: To-Do List Interaktif', 'Aplikasi to-do list interaktif lengkap', 'JavaScript Dasar'),
    ];

    final activeIndex = isDemo ? 2 : 0;
    final modules = [
      for (var i = 0; i < titles.length; i++)
        LearningModule(
          id: titles[i].$1,
          order: i + 1,
          title: titles[i].$2,
          description: titles[i].$3,
          topic: titles[i].$4,
          status: i < activeIndex
              ? ModuleStatus.completed
              : i == activeIndex
                  ? ModuleStatus.active
                  : ModuleStatus.locked,
          requirement: i > activeIndex ? 'Selesaikan Bab $i dulu' : null,
        ),
    ];

    return DashboardData(
      // Selaras MockChallengeRepository: 8 tantangan seed, 1 selesai (kabisat).
      completedChallenges: isDemo ? 1 : 0,
      totalChallenges: 8,
      userXp: isDemo ? 480 : 0,
      firstLessonId: titles.first.$1,
      resume: isDemo
          ? const ResumeInfo(
              lessonId: 'percabangan-if-else',
              topic: 'Python Dasar',
              title: 'Percabangan Logika If-Else',
              description: 'Memahami evaluasi kondisi bernilai boolean',
              progress: 0.35,
            )
          : null,
      skills: isDemo
          ? const {'Logika': 85, 'Variabel': 90, 'Perulangan': 70, 'Fungsi': 65}
          : const {'Logika': 0, 'Variabel': 0, 'Perulangan': 0, 'Fungsi': 0},
      pathTitle: 'Python Dasar & Web',
      // P1-11: hitung dari data nyata — 6 bab (tanpa +n artifisial).
      pathSubtitle: '${titles.length} Bab Menuju Sertifikat',
      modules: modules,
    );
  }
}
