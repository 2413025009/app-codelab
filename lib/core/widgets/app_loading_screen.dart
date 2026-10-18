// FILE: lib/core/widgets/app_loading_screen.dart
//
// TUGAS: layar memuat untuk proses yang diukur JUJUR — persentase di bar
// berasal dari jumlah tahap kerja yang BENAR-BENAR selesai (mis. 5 permintaan
// jaringan dashboard, 1 langkah pemulihan sesi saat boot), bukan animasi
// palsu yang berjalan sendiri.
//
// FUNGSI YANG DIKELOLA:
//   - AppLoadingScreen() : (1) emblem + judul; (2) pill tahap yang berdenyut,
//     teksnya `stageLabel` dari pemanggil; (3) bar & angka persen =
//     `completedSteps / totalSteps`; (4) tips belajar yang bergilir
//     (klik tak diperlukan); (5) kaki identitas "Versi 2.1 · Kurikulum
//     Merdeka RPL". `compact` dipakai di dalam halaman (tanpa emblem besar).
//
// WAJIB DIUBAH BILA: urutan tahap di layar lain berubah (sematkan angka
// tahap baru di pemanggil), atau identitas versi aplikasi naik.
import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

class AppLoadingScreen extends StatefulWidget {
  const AppLoadingScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.totalSteps,
    this.completedSteps = 0,
    this.stageLabel = '',
    this.showTips = true,
    this.compact = false,
    this.tips = const [
      'Tekan tombol "Uji Coba" dulu sebelum "Kumpulkan" — biar kuota harianmu aman.',
      'Bantuan AI hanya memberi petunjuk, bukan kode jadi. Jawabnya tetap kerjamu.',
      'Playground menjalankan Python langsung di perangkat — tetap aktif walau offline.',
      'Kasus uji rahasia tinggal di server, tidak ikut terkirim ke HP siswa.',
    ],
  });

  final String title;
  final String subtitle;
  final int totalSteps;
  final int completedSteps;
  final String stageLabel;
  final bool showTips;
  final bool compact;
  final List<String> tips;

  @override
  State<AppLoadingScreen> createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends State<AppLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  static const _tipInterval = Duration(seconds: 6);
  int _tipIndex = 0;
  Timer? _tipTimer;

  @override
  void initState() {
    super.initState();
    if (widget.tips.length > 1) {
      _tipTimer = Timer.periodic(_tipInterval, (_) {
        if (!mounted) return;
        setState(() => _tipIndex = (_tipIndex + 1) % widget.tips.length);
      });
    }
  }

  @override
  void dispose() {
    _tipTimer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  double get _progress {
    if (widget.totalSteps <= 0) return 0;
    return (widget.completedSteps / widget.totalSteps).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final titleStyle = AppTypography.titleL.copyWith(
      fontWeight: FontWeight.w800,
      color: p.text,
    );

    if (widget.compact) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _ProgressBody(
            pulse: _pulse,
            progress: _progress,
            stageLabel: widget.stageLabel,
            tips: widget.showTips ? widget.tips : const [],
            tipIndex: _tipIndex,
            title: widget.title,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: p.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: p.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.terminal_rounded, size: 36, color: p.primary),
              ),
              const SizedBox(height: AppSpacingDefaults.gapLg),
              Text(
                'CODELAB AI',
                style: AppTypography.label.copyWith(
                  letterSpacing: 4,
                  fontWeight: FontWeight.w800,
                  color: p.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(widget.title, style: titleStyle, textAlign: TextAlign.center),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: AppTypography.bodyM.copyWith(color: p.textMuted),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacingDefaults.gapXl),
              _ProgressBody(
                pulse: _pulse,
                progress: _progress,
                stageLabel: widget.stageLabel,
                tips: widget.showTips ? widget.tips : const [],
                tipIndex: _tipIndex,
                title: widget.title,
              ),
              const SizedBox(height: AppSpacingDefaults.gapXl),
              Text(
                'Versi 2.1 · Kurikulum Merdeka RPL',
                style: AppTypography.caption.copyWith(color: p.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bar persen + pill tahap + tips (dipakai boot & mode compact).
class _ProgressBody extends StatelessWidget {
  const _ProgressBody({
    required this.pulse,
    required this.progress,
    required this.stageLabel,
    required this.tips,
    required this.tipIndex,
    required this.title,
  });

  final AnimationController pulse;
  final double progress;
  final String stageLabel;
  final List<String> tips;
  final int tipIndex;
  final String title;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final percent = (progress * 100).round();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress <= 0 ? null : progress,
                  minHeight: 8,
                  backgroundColor: p.surfaceAlt,
                  valueColor: AlwaysStoppedAnimation<Color>(p.primary),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 38,
              child: Text(
                '$percent%',
                style: AppTypography.label.copyWith(
                  color: p.text,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        if (stageLabel.isNotEmpty) ...[
          const SizedBox(height: 12),
          Center(
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.65, end: 1).animate(
                CurvedAnimation(parent: pulse, curve: Curves.easeInOut),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: p.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  stageLabel,
                  style: AppTypography.caption.copyWith(
                    color: p.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
        if (tips.isNotEmpty) ...[
          const SizedBox(height: 18),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Row(
              key: ValueKey<int>(tipIndex),
              children: [
                Icon(Icons.tips_and_updates_rounded, size: 15, color: p.accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tips[tipIndex.clamp(0, tips.length - 1)],
                    style: AppTypography.caption.copyWith(color: p.textMuted),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

/// Jarak yang dipakai internal widget (tidak mengganggu AppSpacing publik).
abstract final class AppSpacingDefaults {
  static const double gapLg = 16;
  static const double gapXl = 24;
}
