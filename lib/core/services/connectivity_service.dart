// FILE: lib/core/services/connectivity_service.dart
//
// TUGAS: status jaringan perangkat (Minggu 13 — "Mode Luring yang Jujur").
//
// MENGAPA: `connectivity_plus` sudah terpasang di pubspec sejak lama tetapi
// tidak dipakai satu baris pun. Akibatnya, di lab tanpa jaringan seluruh layar
// hanya menampilkan galat tanpa menjelaskan APA yang terjadi. Layanan ini
// memberi tahu antarmuka bahwa perangkat sedang luring, sehingga pesan galat
// bisa jujur ("tidak ada koneksi") alih-alih "server bermasalah".
//
// BATASAN YANG DISENGAJA: layanan ini TIDAK menyimpan cache materi. Menyimpan
// salinan konten di perangkat menuntut kebijakan kedaluwarsa & ruang penyimpanan
// yang belum diputuskan pemilik produk — dicatat sebagai pekerjaan terpisah di
// docs/specs/TODO.md. Yang dikerjakan sekarang: status + pesan yang jujur.
//
// WAJIB DIUBAH BILA: ingin menambah cache luring → buat service terpisah untuk
// penyimpanan konten, jangan mencampurnya dengan deteksi status di sini.
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  ConnectivityService._();

  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<List<ConnectivityResult>>? _sub;

  /// true = perangkat punya jalur jaringan (bukan jaminan server terjangkau).
  /// Nilai awal true agar aplikasi tidak menampilkan "luring" sebelum diperiksa.
  bool _online = true;
  bool get isOnline => _online;
  bool get isOffline => !_online;

  /// Dipanggil sekali saat aplikasi dibuka (main.dart).
  Future<void> init() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _apply(results);
      _sub = _connectivity.onConnectivityChanged.listen(_apply);
    } catch (_) {
      // Platform tanpa dukungan (mis. web lama): anggap selalu daring agar
      // pesan galat tidak salah menyebut "tidak ada koneksi".
      _online = true;
    }
  }

  void _apply(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online == _online) return;
    _online = online;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
