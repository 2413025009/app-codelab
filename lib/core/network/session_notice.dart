// FILE: lib/core/network/session_notice.dart
//
// TUGAS: menyampaikan kabar "sesi berakhir" dari lapisan jaringan ke antarmuka
// (Minggu 13 — sesi tunggal).
//
// ALASAN DIPISAH: `ApiClient` tidak mengenal `BuildContext` maupun navigasi.
// Saat server menolak token dengan kode `SESSION_REVOKED` (akun dipakai masuk
// di perangkat lain, logout, atau kata sandi berubah), lapisan jaringan hanya
// menitipkan pesan di sini; `AuthCubit` mendengarnya, mengeluarkan pengguna, dan
// `LoginPage` menampilkan pesan tersebut sekali.
//
// WAJIB DIUBAH BILA: pesan sesi berakhir perlu ditampilkan di tempat lain
// (mis. dialog global) — tetap lewat notifier ini, jangan menambah jalur baru.
import 'package:flutter/foundation.dart';

abstract final class SessionNotice {
  /// Pesan terakhir dari server. `null` = tidak ada kabar baru.
  static final ValueNotifier<String?> message = ValueNotifier<String?>(null);

  /// Dipanggil lapisan jaringan ketika server menolak karena sesi dicabut.
  static void raise(String text) {
    if (text.trim().isEmpty) return;
    message.value = text;
  }

  /// Dipakai layar masuk setelah pesan ditampilkan, agar tidak berulang.
  static void clear() {
    message.value = null;
  }
}
