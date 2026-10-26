// FILE: lib/core/widgets/app_refresh.dart
// TUGAS (Minggu 9, owner): pull-untuk-muat-ulang yang KONSISTEN di SELURUH
// halaman aplikasi. Lingkaran muat mengikuti tarikan — perilaku bawaan
// RefreshIndicator Material: busur lingkaran bertumbuh & melengkung selagi
// jarak tarikan makin jauh, lalu memutar saat data benar-benar dimuat.
// WAJIB DIUBAH BILA: kebijakan animasi refresh berubah (mis. pusaran kustom).
import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

/// Bungkus scrollable utama sebuah halaman agar bisa ditarik untuk memuat
/// ulang data dari server. Semua halaman memakai ini supaya gaya & warna
/// indikatornya seragam.
///
/// Catatan: setiap ListView/SingleChildScrollView di dalamnya perlu
/// `physics: AlwaysScrollableScrollPhysics()` agar tarikan tetap jalan
/// meski isi halaman lebih pendek dari layar.
class AppRefresh extends StatelessWidget {
  const AppRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.edgeOffset = 0,
  });

  final RefreshCallback onRefresh;

  /// Body halaman (biasanya ListView / SingleChildScrollView).
  final Widget child;

  /// Jarak offset tepi atas (mis. setinggi SliverAppBar) — default 0.
  final double edgeOffset;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: p.primary,
      backgroundColor: p.surface,
      displacement: 36,
      edgeOffset: edgeOffset,
      strokeWidth: 2.6,
      child: child,
    );
  }
}
