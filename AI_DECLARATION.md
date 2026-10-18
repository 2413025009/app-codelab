# AI Declaration — Deklarasi Transparansi Penggunaan Kecerdasan Buatan (AI)

* **Nama Pengembang:** Devwan Hidayawan
* **NPM:** `2413025009`
* **Program Studi:** Pendidikan Teknologi Informasi — Universitas Lampung
* **Repositori:** `mobile-codelab-ai` (Flutter Application)

---

## 1. Daftar Alat AI yang Digunakan

| Nama Alat / Layanan | Kategori | Peran dalam Pengembangan Proyek |
| :--- | :--- | :--- |
| **Google Stitch (Gemini UI/UX Designer)** | *UI/UX Prototyping & Design System* | Merancang referensi antarmuka pengguna (*high-fidelity mockups* `.png` & prototipe `.html` pada folder `stitch/v2/`), menetapkan palet warna *Academic Blue* (`#2F6FED`) & *Achievement Gold* (`#FFC145`), serta menyusun hierarki permukaan dan tipografi aplikasi. |
| **Google Antigravity (Model Google Gemini & Claude)** | *Agentic IDE Coding Assistant* | Membantu penyusunan kerangka awal widget Flutter, manajemen state menggunakan *BLoC/Cubit*, konversi desain dari Stitch ke kode Dart, penulisan kerangka *unit/widget test*, serta bantuan pelacakan bug (*debugging*). |
| **Google Gemini API** | *Fitur AI Tutor di Aplikasi* | Digunakan sebagai mesin pemberi petunjuk belajar bertahap (*3-Level Socratic Hints*) dan penerjemah pesan error koding ke bahasa Indonesia yang mudah dipahami siswa pada fitur `AiTutorSheet`. |

---

## 2. Pembagian Peran (Dibantu AI vs. Ditulis & Disesuaikan Manual)

| Modul / Direktori | Bagian yang Dibantu AI (*AI-Assisted*) | Bagian yang Ditulis & Disesuaikan Manual (*Manual Engineering*) |
| :--- | :--- | :--- |
| **Desain UI/UX & Tema Dasar**<br>(`stitch/v2/`, `lib/core/theme/`) | • Eksplorasi tampilan layar (`screen.png` & `code.html`) melalui Google Stitch.<br>• Struktur dasar kelas warna dan ukuran teks. | • Penyesuaian kontras warna dan skala spasi pada `app_palette.dart`, `app_spacing.dart`, dan `app_typography.dart`.<br>• Pengemasan aset font lokal (*Plus Jakarta Sans* & *JetBrains Mono*) di `pubspec.yaml` agar tampil konsisten tanpa internet.<br>• Pembuatan *CustomPainter* manual untuk latar titik blueprint (`_DottedGridPainter`) dan jalur kurva melengkung (`_RoadmapPathPainter`). |
| **Kerangka Navigasi & Sesi**<br>(`lib/app/`, `lib/core/network/`) | • Struktur dasar rute `GoRouter` dan penyimpanan sesi lokal `TokenStore`. | • Pengaturan *route guard* otomatis pada `app_router.dart` agar halaman terkunci bila siswa belum login.<br>• Penambahan sinyal global `appShellTabActivated` (`ValueNotifier<int>`) pada `AppShell` agar halaman di dalam `IndexedStack` tetap memperbarui data saat pengguna berpindah tab. |
| **Autentikasi Siswa**<br>(`lib/features/auth/`) | • Tata letak awal halaman `LoginPage`, `RegisterPage`, dan komponen `AuthWidgets`.<br>• Kerangka dasar `AuthCubit`. | • Penulisan aturan validasi input `Validators` (format email regex & syarat kata sandi minimal 8 karakter dengan angka/simbol).<br>• Alur pengalihan otomatis setelah daftar akun menuju halaman login dengan email yang langsung terisi (*prefill*) dan banner notifikasi sukses.<br>• Penambahan *guard* pengecekan nilai XP yang sama pada `AuthCubit.setXp()` agar layar tidak mengalami *rebuild* berulang. |
| **Dashboard & Mesin Materi 7 Tipe Slide**<br>(`lib/features/dashboard/`, `lib/features/lesson/`) | • Kerangka widget untuk 7 tipe slide (*Theory, Tap to Fill, Type Code, Output Predict, Bug Hunter, Quiz, Summary*).<br>• Kerangka kartu `ResumeCard`. | • Perancangan logika parser pada `lesson_parser.dart` untuk memecah isi materi menjadi objek slide interaktif.<br>• Perbaikan layar merah `setState() called during build` pada `tap_to_fill_slide_widget.dart` menggunakan `addPostFrameCallback`.<br>• Penyelarasan tata letak `WindingRoadmap` agar sesuai 1:1 dengan desain Stitch v2. |
| **Tantangan Koding, Playground & AI Tutor**<br>(`lib/features/challenges/`, `lib/features/playground/`, `lib/features/ai_tutor/`) | • Kerangka dasar interpreter `MiniPythonRunner` dan tampilan modal `AiTutorSheet`.<br>• Tata letak awal `ChallengeCatalogPage` dan `ChallengeDetailPage`. | • Penambahan pembatas perulangan (*infinite-loop guard*) pada `mini_python_runner.dart` agar kode `while True` dari siswa tidak membuat aplikasi macet (*freeze*).<br>• Logika penguncian soal tantangan berdasarkan syarat poin XP (`min_xp_required`).<br>• Penghapusan metrik RAM/MB fiktif pada `EvaluationSheet` sehingga hanya menampilkan skor dan waktu eksekusi nyata.<br>• Perbaikan *overflow* 1 piksel pada tinggi panel terminal `playground_page.dart`. |
| **Profil Siswa & Pengaturan**<br>(`lib/features/profile/`) | • Komponen kartu identitas profil, grafik radar `fl_chart`, dan form `SettingsPage`. | • Mengubah `ProfilePage` dari `StatelessWidget` menjadi `StatefulWidget` dengan penyimpanan *cache* lokal dan *auto-retry* 3x agar layar tidak berkedip (*flicker*) atau kosong saat baru dibuka.<br>• Penyesuaian logika agar seluruh *track* materi tetap ditampilkan meskipun progresnya masih 0% (*"Belum dimulai"*). |

---

## 3. Studi Kasus Prompting

### Studi Kasus 1: menyelaraskan Desain Dashboard dengan Stitch v2 & Menyegarkan Data Saat Pindah Tab

#### A. Instruksi (Prompt) Awal
> *"Halaman dashboard dan profil masih belum sesuai dengan desain di folder `stitch/v2`. Tolong sesuaikan tampilannya seperti di Stitch, lalu pastikan waktu kita pindah-pindah tab di bagian bawah (Belajar, Tantangan, Playground, Profil), poin XP dan progres belajarnya langsung ter-update otomatis tanpa harus di-refresh manual."*

#### B. Hasil Awal dari AI
1. AI menyusun ulang tampilan `DashboardPage` menggunakan daftar kartu vertikal sederhana tanpa jalur peta berkelok, dan menggunakan `StatefulShellRoute.indexedStack` untuk 4 tab navigasi bawah.
2. Pada `ProfilePage`, AI membuatnya sebagai `StatelessWidget` yang memuat ulang seluruh data di dalam metode `build()` setiap kali widget dirender, lalu langsung memanggil `context.read<AuthCubit>().setXp(xp)` saat data selesai dimuat.

#### C. Penyesuaian Logika Manual
1. **Membangun Custom Painter untuk Peta Belajar (`winding_roadmap.dart`):**
   Menulis logika penggambaran kanvas manual menggunakan `_DottedGridPainter` (titik-titik berjarak 16px) dan `_RoadmapPathPainter` (kurva *cubic Bézier* putus-putus dan garis biru solid untuk pos yang sudah diselesaikan) agar tampilan peta petualangan belajar sama persis dengan gambar di Stitch v2.
2. **Menambahkan Sinyal Aktivasi Tab (`app_shell.dart`):**
   Karena `IndexedStack` menahan halaman tetap hidup di memori sehingga `initState()` tidak dipanggil lagi saat pengguna berpindah tab, ditambahkan `final ValueNotifier<int> appShellTabActivated = ValueNotifier<int>(-1);` yang memicu penyegaran data di latar belakang setiap kali pengguna mengetuk tab.
3. **Mencegah *Infinite Rebuild Loop* (`auth_cubit.dart` & `profile_page.dart`):**
   Mengubah `ProfilePage` menjadi `StatefulWidget` yang menyimpan data terakhir di variabel state lokal agar layar tidak berkedip, serta menambahkan pengecekan pada `AuthCubit.setXp()`:
   ```dart
   void setXp(int xp) {
     final current = state.user;
     if (current == null || current.xpPoints == xp) return; // Cegah rebuild berulang
     emit(AuthState(
       status: state.status,
       user: current.copyWith(xpPoints: xp),
     ));
   }
   ```

---

### Studi Kasus 2: Pengamanan *Infinite Loop* pada Interpreter `MiniPythonRunner` di Perangkat

#### A. Instruksi (Prompt) Awal
> *"Buatkan fitur Playground Python yang bisa langsung dijalankan di HP siswa tanpa perlu server tambahan, lengkap dengan tombol bantuan simbol koding dan uji coba kode untuk soal tantangan."*

#### B. Hasil Awal dari AI
1. AI membuat kelas `MiniPythonRunner` (`lib/features/playground/data/mini_python_runner.dart`) yang menerjemahkan perintah dasar Python (`print`, variabel, `if/else`, `for`, dan `while`) secara sinkron di dalam *main isolate* Flutter.
2. Pada perulangan `while`, AI menggunakan perulangan `while (evalCondition(cond))` standar tanpa pembatas jumlah putaran.

#### C. Penyesuaian Logika Manual
1. **Menambahkan *Loop Guard* / Pembatas Iterasi (`mini_python_runner.dart`):**
   Ketika siswa menulis kode yang memiliki perulangan tanpa henti (misalnya `while True:` atau lupa menambahkan increment variabel penghitung), kode awal dari AI menyebabkan antarmuka aplikasi langsung membeku (*hang/ANR*). Oleh karena itu, ditambahkan penghitung langkah eksekusi maksimum (*step counter*) secara manual yang menghentikan eksekusi secara aman dan menampilkan pesan penjelasan yang mudah dipahami siswa apabila batas iterasi terlampaui.
2. **Perbaikan Evaluasi Batas Nilai KKM (`challenge_test.dart`):**
   Menyesuaikan logika pengujian kasus batas (*boundary test case*) pada soal tantangan agar membedakan penggunaan operator `>` dan `>=` secara akurat, serta menghapus metrik penggunaan memori (RAM/MB) tiruan pada lembar hasil evaluasi (`EvaluationSheet`) sehingga hanya menampilkan skor kelulusan dan durasi waktu eksekusi nyata.

---

### Studi Kasus 3: Perbaikan Layar Merah Saat Buka Materi & Garis Kuning-Hitam pada Kotak Terminal

#### A. Instruksi (Prompt) Awal
> *"Nak, ini kok waktu dibuka bab materinya di HP layarnya tiba-tiba langsung merah semua ada tulisan error? Terus itu di halaman tempat ngetik koding waktu kotak hitam di bawahnya dikecilin, kenapa di bagian paling bawah muncul garis-garis miring warna kuning hitam kayak rusak tampilannya? Tolong dibenerin biar nggak error lagi waktu dipakai."*

#### B. Hasil Awal dari AI
1. Pada `TapToFillSlideWidget` (`lib/features/lesson/presentation/widgets/slides/tap_to_fill_slide_widget.dart`), AI memanggil fungsi `widget.onAnswered(false)` secara langsung saat widget pertama kali dibangun (`initState`/`build`) untuk memberi tahu halaman induk `LessonReaderPage` bahwa soal belum dijawab. Akibatnya, `LessonReaderPage` memanggil `setState()` ketika Flutter masih sedang menggambar halaman, sehingga memunculkan layar merah (*`setState() or markNeedsBuild() called during build`*).
2. Pada `PlaygroundPage` (`lib/features/playground/presentation/pages/playground_page.dart`), AI mengatur tinggi kotak terminal saat dilipat sebesar `44` piksel dengan garis tepi atas (*border top*) `1` piksel dan isi header di dalamnya setinggi `44` piksel. Ruang yang tersisa hanya `43` piksel sehingga kurang `1` piksel dan memunculkan pita kuning-hitam (*`RenderFlex overflowed by 1.0 pixels on the bottom`*).

#### C. Penyesuaian Logika Manual
1. **Menunda Panggilan Status Slide Setelah Frame Selesai Digambar (`tap_to_fill_slide_widget.dart`):**
   Membungkus pemanggilan `widget.onAnswered` dengan `addPostFrameCallback` agar halaman induk baru memperbarui status tombol setelah proses pembuatan layar selesai:
   ```dart
   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       if (mounted) widget.onAnswered(_isComplete && _isCorrect);
     });
   }
   ```
2. **Menyesuaikan Ukuran Tinggi Terminal & Scroll (`playground_page.dart` & `app_sheet.dart`):**
   Mengubah tinggi kotak terminal saat dilipat dari `44` menjadi `45` piksel agar muat bersama garis border `1` piksel, serta menambahkan pembungkus gulir (`SingleChildScrollView`) pada `app_sheet.dart` dan `slide_feedback_sheet.dart` supaya konten modal tidak pernah meluber di layar HP yang berukuran kecil.
