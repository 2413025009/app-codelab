# Dokumentasi Fitur Role Pengajar (Teacher Studio & Class Management)
Dokumentasi lengkap seluruh fitur per halaman untuk role pengajar pada aplikasi CodeLab AI.

---

## 1. Dashboard & Beranda Pengajar (`/dashboard-pengajar`)
- **Ringkasan Metrik Pengajaran:** Menampilkan 3 kartu ringkasan instan:
  - Total Kelas Aktif (jumlah rombel binaan).
  - Total Siswa Terdaftar (akumulasi seluruh anggota dari kelas aktif).
  - Total Materi Ajar (modul buatan guru yang aktif di studio).
- **Header Identitas Instruktur:** Salam personal dengan nama pengajar aktif beserta nama sekolah yang terhubung lewat kode institusi.
- **Pencarian & Filter Kelas:** 
  - Input pencarian real-time berdasarkan nama atau kode kelas.
  - Filter pilihan Tahun Ajaran melalui modal bottom sheet.
- **Kartu Manajemen Kelas (Rombel):**
  - Menampilkan badge Tahun Ajaran, jumlah siswa anggota, dan nama kelas.
  - **Kotak Kode Kelas Eksklusif:** Menampilkan kode unik kelas dengan tombol **Salin** langsung ke clipboard dan tombol **Proyektor Kode (Layar Penuh)** untuk ditampilkan di proyektor lab komputer.
  - Tombol aksi **Pantau Kelas** menuju halaman Analisa Kelas.
- **Aksi Cepat Pembuatan Kelas:** Tombol `Buat Kelas` (Floating Action Button) untuk membuka form penerbitan rombel baru (nama kelas & tahun ajaran).
- **Akses Arsip Kelas:** Tautan cepat menuju daftar kelas yang diarsipkan.

---

## 2. Studio Materi & Kurikulum Koding (`/materi-pengajar`)
- **Status Pembelajaran Kelas:** Banner indikator jumlah materi aktif terbit bagi total siswa di sekolah.
- **Filter Tab Segmented (Semua | Draft | Terbit):** Menyaring daftar modul sesuai status publikasi.
- **Kartu Modul Pembelajaran:** Menampilkan ikon topik, level kesulitan (Pemula, Menengah, Mahir), jumlah bab, total XP, dan status (Terbit / Draft).
- **Aksi Kelola Materi (Modal Bottom Sheet):**
  - **Edit Silabus & Bab:** Membuka editor struktur bab.
  - **Edit Info Materi:** Mengubah judul, deskripsi, ikon, track, dan level.
  - **Duplikat sebagai Draft Baru:** Menyalin materi lengkap dengan bab dan slide-nya menjadi draft baru.
  - **Terbit / Tarik ke Draft:** Mengubah visibilitas materi agar dapat diakses atau disembunyikan dari siswa.
  - **Hapus Materi Selamanya:** Menghapus modul dari studio (riwayat belajar siswa tuntas tetap aman di server).
- **Pencegahan Nama Duplikat:** Validasi lokal dan server menolak nama materi yang sudah dipakai guru yang sama agar siswa tidak bingung.

---

## 3. Bab Builder & Editor Silabus (`/materi-pengajar/:lessonId/silabus`)
- **Daftar Bab Terstruktur:** Menampilkan urutan bab aktif beserta jumlah slide dan total XP reward.
- **Tombol Urutan (Pindah ke Atas / Bawah):** Mengatur alur belajar bab secara fleksibel.
- **Simulator Siswa (Pratinjau):** Menjalankan `LessonReaderPage` dalam mode pratinjau guru untuk menguji materi sebelum diterbitkan.
- **CRUD Bab:** Tambah bab baru (dengan 3 slide bawaan: Theory, Quiz, Outro), edit judul & XP reward, atau hapus bab dengan dialog konfirmasi.

---

## 4. Editor Slide Interaktif Per Tipe (`.../slide/:type/:index`)
- Mendukung **7 Format Pembelajaran & Latihan Koding**:
  1. `THEORY` (Teori & Konsep): Teks penjelasan markdown dan contoh visual.
  2. `TAP_TO_FILL` (Lengkapi Kode): Fill-in-the-blanks dengan kepingan token kode terpandu.
  3. `TYPE_CODE` (Ketik Kata Kunci): Latihan muscle-memory mengetik keyword sintaksis.
  4. `OUTPUT_PREDICT` (Tebak Output): Menganalisis snippet dan memprediksi hasil luaran terminal.
  5. `BUG_HUNTER` (Cari Galat): Tantangan memperbaiki baris kode yang rusak.
  6. `QUIZ` (Kuis Pilihan Ganda): Pertanyaan konseptual dengan 4 opsi pilihan dan pembahasan.
  7. `OUTRO` (Rangkuman & Klaim XP): Slide penutup bab dengan rekap capaian dan hadiah XP.
- **Pratinjau Live:** Tombol uji coba slide langsung di dalam editor.

---

## 5. Analisa Kelas & Papan Peringkat (`/analisa-kelas-pengajar/:classId`)
- **Proyektor Kode QR / Layar Penuh:** Mode tampilan raksasa kode kelas untuk lab komputer.
- **Kemajuan Kurikulum Per Track:** Grafik bar persentase ketuntasan rata-rata kelas pada track Python, HTML, CSS, dan JavaScript.
  - **Dasar Angka:** Persentase = rata-rata `progress_percent` seluruh anggota kelas pada **semua materi kurikulum resmi** di track tersebut. Siswa × materi yang belum pernah dibuka tetap dihitung sebagai 0%, sehingga 100% berarti seluruh siswa sudah menuntaskan seluruh materi track itu.
  - Hanya kurikulum resmi yang dihitung; materi buatan guru tidak masuk perhitungan.
  - Angka ini mengukur **ketuntasan materi**, bukan nilai latihan.
  - Keterangan lengkap tersedia lewat ikon info (tooltip + dialog) di samping judul, plus satu baris takarir di bawah judul.
- **Bab Tersulit (Diagnostik Gagal):** Deteksi otomatis tantangan koding dengan jumlah siswa gagal terbanyak sebagai bahan evaluasi guru.
- **Papan Peringkat Siswa Kelas (Dual Panel):**
  - Menampilkan panel bersampingan untuk **Materi** (materi tuntas terbanyak) dan **Latihan** (tantangan lulus terbanyak).
  - Dibatasi maksimal **10 siswa teratas** dengan nilai > 0.
  - Dilengkapi label penjelasan agar transparan bagi guru.
- **Daftar Siswa & Filter Roster:**
  - Menampilkan seluruh anggota kelas (tidak dibatasi 10 besar).
  - **Filter Utama:** *Semua*, *Materi Tuntas*, *Latihan Terbanyak*, dan *Belum Memulai* — masing-masing menampilkan jumlah siswa yang cocok.
  - **Sub-filter *Latihan Terbanyak*:** *Semua Latihan*, *Latihan Biasa* (bukan mini proyek), dan *Mini Proyek*. Pengurutan mengikuti jenis yang dipilih, dan tiap kartu siswa menampilkan rincian "X latihan biasa • Y mini proyek".
  - **Sub-filter *Belum Memulai*:** *Materi & Latihan* (belum menuntaskan materi **dan** belum menyelesaikan latihan), *Belum Kerjakan Materi* (0 materi tuntas), dan *Belum Selesaikan Latihan* (0 latihan lulus).
  - **Filter per Materi:** Satu tombol untuk setiap materi kurikulum resmi, berderet horizontal di bawah filter, diawali *Semua Materi*. Angka di tiap tombol = jumlah siswa yang sudah menuntaskan materi tersebut. Filter materi berlaku untuk **semua** kategori di atas dan dapat dilepas dengan menekan tombol yang sama atau *Reset*.
  - **Teks Penjelasan Dinamis:** Kalimat di bawah filter selalu menjelaskan secara spesifik kategori dan materi yang sedang aktif, bukan penjelasan umum.
  - **Aksi Kelola Anggota:** Mengeluarkan siswa dari kelas (`Keluarkan dari kelas`) dengan konfirmasi dialog agar siswa tidak muncul lagi di roster kecuali bergabung ulang dengan kode kelas.

---

## 6. Profil Pengajar (`/profile-pengajar`)
- **Kartu Identitas Instruktur:** Foto avatar, nama lengkap & gelar, nama sekolah, NIP/NUPTK, dan bio singkat.
- **Statistik Cepat:** Jumlah Kelas Diajar, Siswa Dibimbing, dan Materi Ajar.
- **Daftar Kelas yang Diajar:** Card visual elegan yang merinci rombel aktif beserta tahun ajaran dan jumlah siswa.
- **Daftar Materi Ajar:** Card ringkasan modul buatan guru dengan status terbit/draft, jumlah bab, dan total XP.
- **Tombol Aksi Profil:** Menuju Pengaturan Profil atau **Keluar dari Akun Pengajar** (logout aman dengan konfirmasi).

---

## 7. Pengaturan & Preferensi Pengajar (`/pengaturan-pengajar`)
- **Manajemen Foto Profil:** Unggah foto baru (otomatis dikompres ke format **WebP lossy quality 82**, sisi terpanjang maksimal 512 px di backend) atau hapus foto profil.
- **Form Edit Data Pribadi (Inline Toggle):**
  - Tombol `Edit Data` mengubah kolom menjadi dapat diedit (Nama, NIP, Bio, Alamat, Nomor WhatsApp/Telepon, Email `@smk.belajar.id`).
  - Tombol berubah menjadi `Simpan Perubahan` dan `Batalkan`. Identitas default terkunci (readonly) untuk keamanan.
- **Keamanan Akun:** Menu modal untuk mengubah kata sandi akun pengajar.
- **Preferensi Aplikasi (Lokal):**
  - Pilihan Bahasa Aplikasi (Indonesia / English).
  - Toggle Mode Gelap (Dark Mode).
  - Toggle Notifikasi Pengumpulan Tugas.
  - Toggle Efek Suara Aplikasi & Efek Suara Lab.
- **Informasi Versi & Hak Cipta:** Menampilkan nomor build aplikasi dan copyright resmi.
- *Catatan:* Tombol Keluar Akun sengaja dipisah dan hanya berada di halaman Profil Pengajar, bukan di halaman Pengaturan.
