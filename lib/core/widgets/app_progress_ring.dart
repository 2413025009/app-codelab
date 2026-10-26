import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

/// Minggu 9: ring persen melingkar yang dinamis — busur mengikuti [value].
/// 50% = setengah lingkaran, bukan sekadar angka. Dipakai kartu
/// "Progres Track Belajar" di halaman profil.
class AppProgressRing extends StatelessWidget {
  const AppProgressRing({
    super.key,
    required this.value,
    required this.label,
    this.size = 44,
    this.thickness = 4,
  });

  /// Progres 0..1 (dipotong aman).
  final double value;

  /// Teks di tengah ring, biasanya "50%".
  final String label;

  /// Diameter ring (px).
  final double size;

  /// Tebal garis busur (px).
  final double thickness;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final clamped = value.clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          value: clamped,
          trackColor: p.surfaceAlt,
          progressColor: p.primary,
          thickness: thickness,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: p.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.value,
    required this.trackColor,
    required this.progressColor,
    required this.thickness,
  });

  final double value;
  final Color trackColor;
  final Color progressColor;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - thickness) / 2;

    // Lingkaran latar penuh sebagai track.
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..color = trackColor;
    canvas.drawCircle(center, radius, track);

    // Busur progres mulai dari posisi pukul 12 (-90°), menyapu sesuai persen.
    if (value > 0) {
      final progress = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = thickness
        ..color = progressColor;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * value,
        false,
        progress,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.progressColor != progressColor ||
      oldDelegate.thickness != thickness;
}
