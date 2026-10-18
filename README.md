# CodeLab AI — Mobile Learning Platform (Flutter App)

![Flutter Version](https://img.shields.io/badge/Flutter-3.24%2B-02569B?style=flat&logo=flutter)
![Dart Version](https://img.shields.io/badge/Dart-3.12%2B-0175C2?style=flat&logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Feature--First%20BLoC%2FCubit-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20Web%20(Brave%2FChrome)-success)
![License](https://img.shields.io/badge/License-Proprietary-red.svg)

Aplikasi mobile pembelajaran pemrograman koding interaktif **CodeLab AI**, dirancang khusus untuk memecahkan kendala akses belajar siswa pemula (*K-12 & First-year University*). Aplikasi ini mengintegrasikan **Client-Side Mini Python Runner** (eksekusi koding mandiri pada perangkat lokal tanpa server Docker), **Visualisasi Radar Kompetensi 4 Sumbu**, **Bantuan Asisten Pintar AI Tutor (Scaffolding)**, dan kurikulum silabus sekuensial berjenjang.

---

## 📋 Daftar Isi
1. [Kebutuhan Sistem & Prasyarat](#kebutuhan-sistem--prasyarat)
2. [Fitur Unggulan Aplikasi](#fitur-unggulan-aplikasi)
3. [Panduan Instalasi & Konfigurasi](#panduan-instalasi--konfigurasi)
4. [Cara Menjalankan Aplikasi](#cara-menjalankan-aplikasi)
5. [Arsitektur & Manajemen State](#arsitektur--manajemen-state)
6. [Panduan Debugging & Troubleshooting](#panduan-debugging--troubleshooting)
7. [Struktur Direktori](#struktur-direktori)
8. [Watermark & Hak Cipta](#watermark--hak-cipta)

---

## 1. Kebutuhan Sistem & Prasyarat

Sebelum mengompilasi dan menjalankan aplikasi mobile ini, pastikan workstation Anda telah memenuhi persyaratan berikut:

* **Sistem Operasi:** Windows 10/11 (Command Prompt / CMD Administrator), macOS, atau Linux.
* **Flutter SDK:** Versi `3.24.0` atau yang lebih baru (Dart SDK `^3.12.2`).
  * Periksa kesiapan toolchain Flutter:
    ```cmd
    flutter doctor
    ```
* **Perangkat Target Eksekusi:**
  * **Browser Desktop (Pengujian Responsif Cepat):** Brave Browser (direkomendasikan) atau Google Chrome.
  * **Android:** Android SDK dengan minimal API Level 21 (Android 5.0 Lollipop) atau emulator Android.
* **Aset Font Lokal:**
  * Proyek ini telah mengemas font *Plus Jakarta Sans* (antarmuka) dan *JetBrains Mono* (kode) secara lokal di folder `assets/fonts/` tanpa bergantung pada koneksi internet saat runtime.

---

## 2. Fitur Unggulan Aplikasi

1. **Client-Side Mini Python Runner (`MiniPythonRunner`):**
   * Mesin eksekusi dan interpretasi kode Python mini yang berjalan sepenuhnya di sisi klien (*on-device*).
   * Menghilangkan latensi jaringan, menghemat biaya komputasi server, serta memungkinkan siswa belajar koding secara instan tanpa membutuhkan container Docker di backend.

2. **Mobile Code Editor & Quick-Symbol Toolbar:**
   * Editor kode khusus mobile dengan penomoran baris monospaced, scroll horizontal bebas *word-wrap*, dan bilah tombol cepat untuk simbol esensial koding (`:`, `()`, `""`, `tab`, `_`, `[]`).

3. **Visualisasi Radar Kompetensi 4 Sumbu (`fl_chart`):**
   * Memetakan kekuatan koding siswa secara empiris pada 4 pilar kompetensi: **Logika**, **Variabel**, **Perulangan**, dan **Fungsi**.
   * Skor dihitung otomatis berdasarkan histori kelulusan unit test.

4. **AI Tutor Scaffolding & Dynamic Hinting:**
   * Antarmuka lembar interaktif (*bottom sheet*) yang memberikan petunjuk berpikir bertahap (*scaffolding*) tanpa langsung membocorkan kode jawaban akhir.
   * Dilengkapi sistem proteksi kuota harian untuk mendorong kemandirian berpikir siswa.

5. **Kurikulum Terstruktur & Checkpoint Kuis:**
   * Materi bacaan Markdown interaktif dengan sistem gembok prasyarat (*prerequisite lock*) yang hanya terbuka setelah siswa menyelesaikan modul sebelumnya.

---

## 3. Panduan Instalasi & Konfigurasi

### Langkah 1: Masuk ke Direktori Mobile
Buka jendela **CMD (Command Prompt)** dan masuk ke direktori proyek:
```cmd
cd /d "D:\@UNDERGROUND DEV\@edukasi-coding\mobile-codelab-ai"
```

### Langkah 2: Unduh Dependensi Paket Flutter
Jalankan perintah untuk mengambil seluruh library yang terdaftar di `pubspec.yaml`:
```cmd
flutter pub get
```

### Langkah 3: Verifikasi Integritas Aset Font
Pastikan berkas font lokal telah tersedia di jalur:
* `assets/fonts/PlusJakartaSans.ttf`
* `assets/fonts/JetBrainsMono.ttf`

---

## 4. Cara Menjalankan Aplikasi

### A. Menjalankan di Brave Browser (Rekomendasi Mode Dev)
Untuk menjalankan aplikasi di desktop browser Brave dengan viewport responsif:
```cmd
set "CHROME_EXECUTABLE=C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
flutter run -d chrome
```

### B. Menjalankan di Android Emulator / Perangkat Fisik
1. Hubungkan perangkat Android fisik (aktifkan *USB Debugging*) atau jalankan Android Emulator via Android Studio.
2. Periksa daftar perangkat yang terdeteksi:
   ```cmd
   flutter devices
   ```
3. Jalankan aplikasi pada perangkat yang dipilih:
   ```cmd
   flutter run -d <device-id>
   ```

### C. Menjalankan via Skrip Peluncur (`dev-mobile.bat`)
Skrip peluncur kini ikut dibawakan di dalam repo ini, sehingga cukup dijalankan langsung setelah clone:
```cmd
dev-mobile.bat
```
Skrip mendeteksi Brave otomatis (Program Files / LocalAppData) bila terpasang, lalu menjalankan `flutter run -d chrome`.

*Catatan:* skrip `dev.bat` (peluncur paralel Backend + Mobile multi-tab) tinggal di root folder workspace induk `@edukasi-coding` — bukan bagian repo; hanya tersedia bila folder workspace induknya turut disalin.

### D. Pintasan Interaktif di Terminal Konsol:
* Tekan **`r`** : Melakukan **Hot Reload** (memperbarui perubahan UI dalam milidetik).
* Tekan **`R`** : Melakukan **Hot Restart** (mereset state aplikasi dari awal).
* Tekan **`q`** : Menutup aplikasi dan menghentikan sesi debug.

---

## 5. Arsitektur & Manajemen State

Aplikasi dibangun menggunakan pola **Feature-First Architecture** yang memisahkan kode berdasarkan fitur fungsional bisnis:

* **State Management:** `flutter_bloc` / `Cubit` untuk logika reaktif yang teruji dan bebas dari *boilerplate* berlebih.
* **Routing & Navigasi:** `go_router` dengan konfigurasi sub-routes dan shell navigation (`AppShell`).
* **Networking:** `dio` HTTP client dengan interceptor token JWT otomatis.
* **Storage Aman:** `flutter_secure_storage` untuk menyimpan Access Token dan Refresh Token secara terenkripsi.
* **Desain Sistem & Tokens:**
  * Palet Warna Terpusat: `AppPalette` (Dark / Light responsive tone)
  * Skala Spasi & Radius: `AppSpacing`
  * Tipografi Monospaced & Sans: `AppTypography`

---

## 6. Panduan Debugging & Troubleshooting

### 1. Masalah: Browser Brave Tidak Ditemukan (`Cannot find Chrome executable`)
* **Penyebab:** Variabel `CHROME_EXECUTABLE` belum diarahkan ke path binary instalasi Brave.
* **Solusi:**
  Set variabel path di CMD sebelum menjalankan Flutter:
  ```cmd
  set "CHROME_EXECUTABLE=C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe"
  flutter run -d chrome
  ```

### 2. Masalah: Gagal Terhubung ke Backend API (`DioException [connection error]`)
* **Penyebab:** Perbedaan resolusi alamat loopback antara Web dan Android Emulator.
* **Solusi:**
  * **Pada Web (Brave/Chrome):** Gunakan Base URL `http://localhost:8080/api/v1`.
  * **Pada Android Emulator:** Jangan gunakan `localhost`, melainkan alias host loopback Android:
    `http://10.0.2.2:8080/api/v1`
  * **Pada Perangkat Fisik (WiFi):** Gunakan IP lokal workstation (contoh: `http://192.168.1.15:8080/api/v1`).

### 3. Masalah: Cache Kompilasi Rusak atau Tampilan Glitch
* **Penyebab:** State build cache lokal yang usang setelah perubahan dependensi atau font.
* **Solusi:** Bersihkan cache dan rakit ulang:
  ```cmd
  flutter clean
  flutter pub get
  ```

### 4. Menjalankan Pengujian Unit UI (*Unit Testing*):
Untuk menguji logika validasi formulir, formatting nama, dan parser kode lokal:
```cmd
flutter test
```

---

## 7. Struktur Direktori

```text
mobile-codelab-ai/
├── assets/
│   └── fonts/                      # Font lokal (Plus Jakarta Sans & JetBrains Mono)
├── lib/
│   ├── app/
│   │   ├── router/                 # Konfigurasi GoRouter (AppRouter, AppRoutes)
│   │   └── shell/                  # Bottom Navigation & AppShell wrapper
│   ├── core/
│   │   ├── network/                # ApiClient (Dio, bearer, refresh 401), TokenStore; data tiruan HANYA saat offline sungguhan
│   │   ├── theme/                  # Design tokens: palette, spacing, typography, theme
│   │   ├── utils/                  # Form validators, string & format helpers
│   │   └── widgets/                # UI bersama: AppLoadingScreen (progres nyata), CodeEditor, CodeWindowShell, Radar
│   ├── features/
│   │   ├── ai_tutor/               # Scaffolding AI: sheet 3 level, ApiTutorRepository (kuota 5x/hari dari server), script offline
│   │   ├── auth/                   # Login, Register, AuthCubit, repository API + mock offline, TokenStore restore
│   │   ├── challenges/             # Katalog soal, kunci XP 403, cooldown, evaluation sheet
│   │   ├── dashboard/              # Beranda progres nyata (5 tahap), kartu resume, peta roadmap
│   │   ├── lesson/                 # Modul bacaan 7 tipe slide & kuis interaktif
│   │   ├── playground/             # Editor koding & MiniPythonRunner subset Python on-device (loop, def, f-string, input() dialog)
│   │   └── profile/                # Halaman profil siswa, radar chart, mini-projects
│   └── main.dart                   # Root widget, providers registration, app entry point
├── pubspec.yaml                    # Dependensi paket Flutter dan deklarasi font lokal
└── README.md                       # Dokumentasi resmi proyek mobile
```

---

## 8. Watermark & Hak Cipta

* **Aplikasi:** CodeLab AI — Mobile Learning Platform
* **Pengembang / Author:** `2413025009` (<wanzzhd8@gmail.com>)
* **Konteks Proyek:** Ujian Tengah Semester (UTS) — Platform Edukasi Mobile Learning
* **Repositori GitHub:** [https://github.com/2413025009/app-codelab.git](https://github.com/2413025009/app-codelab.git)

```text
================================================================================
  Copyright (c) 2026 CodeLab AI Development Team. All Rights Reserved.
  Developed by: 2413025009 <wanzzhd8@gmail.com>
================================================================================
```
