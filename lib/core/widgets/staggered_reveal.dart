// FILE: lib/core/widgets/staggered_reveal.dart
//
// TUGAS: animasi masuk yang halus untuk konten yang muncul setelah data
// selesai dimuat (fade + geser naik sedikit). Dipakai dashboard agar kartu
// tidak "melompat" muncul serentak.
//
// AKSESIBILITAS: bila pengguna mengaktifkan "kurangi animasi" di sistem
// (MediaQuery.disableAnimations), konten langsung tampil tanpa gerak.
import 'dart:async';

import 'package:flutter/material.dart';

class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 420),
    this.offset = const Offset(0, 0.05),
  });

  final Widget child;

  /// Jeda sebelum animasi mulai — dipakai untuk efek bertahap antar kartu.
  final Duration delay;
  final Duration duration;

  /// Posisi awal relatif terhadap ukuran anak (fraksi tinggi).
  final Offset offset;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  late final Animation<Offset> _slide = Tween<Offset>(
    begin: widget.offset,
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  bool _scheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduled) return;
    _scheduled = true;

    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion) {
      _controller.value = 1;
      return;
    }
    unawaited(
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
