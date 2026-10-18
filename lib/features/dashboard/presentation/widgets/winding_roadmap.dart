import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/dashboard_repository.dart';

class WindingRoadmap extends StatefulWidget {
  const WindingRoadmap({
    super.key,
    required this.modules,
    required this.onModuleTap,
    required this.onOpenCatalog,
  });

  final List<LearningModule> modules;
  final ValueChanged<LearningModule> onModuleTap;
  final VoidCallback onOpenCatalog;

  @override
  State<WindingRoadmap> createState() => _WindingRoadmapState();
}

class _WindingRoadmapState extends State<WindingRoadmap> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final modules = widget.modules;

    // Find active module count/order
    final activeModule = modules.firstWhere(
      (m) => m.status == ModuleStatus.active,
      orElse: () => modules.isNotEmpty
          ? modules.first
          : const LearningModule(
              id: '',
              order: 1,
              title: '',
              description: '',
              status: ModuleStatus.locked,
            ),
    );

    final totalPositions = modules.length + 1; // Modules + Certificate

    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: p.outline.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header (Stitch v2)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: p.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.route_rounded, color: p.primary, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Peta Petualangan Belajar',
                      style: AppTypography.titleM.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalPositions Pos Menuju Sertifikat',
                      style: AppTypography.caption.copyWith(
                        color: p.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (activeModule.title.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.accent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFF7C5800),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Bab ${activeModule.order} Aktif',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7C5800),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // 2. Blueprint Dotted Canvas with S-Curve Path & Alternating Nodes
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Layer 0: Radial dotted grid background
                Positioned.fill(
                  child: CustomPaint(
                    painter: _DottedGridPainter(dotColor: p.outline.withValues(alpha: 0.6)),
                  ),
                ),

                // Layer 1: Custom painted S-Curve connector lines
                Positioned.fill(
                  child: CustomPaint(
                    painter: _RoadmapPathPainter(
                      nodeCount: totalPositions,
                      lineColor: p.primaryContainer,
                      activeColor: p.primary,
                      activeStep: activeModule.order,
                    ),
                  ),
                ),

                // Layer 2: Interactive nodes
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: 4),
                  child: Column(
                    children: [
                      for (var i = 0; i < modules.length; i++) ...[
                        _buildNode(context, modules[i], i.isEven),
                        const SizedBox(height: 26),
                      ],

                      // Final Goal: Certificate Node (Center)
                      _buildCertificateGoal(context),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 3. Catalog Link Button
          InkWell(
            onTap: widget.onOpenCatalog,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: p.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Icons.collections_bookmark_rounded, color: p.primary, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Katalog Materi & Track',
                          style: AppTypography.label.copyWith(
                            color: p.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'Pilih trek lain atau telusuri materi lengkap',
                          style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: p.primary, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNode(BuildContext context, LearningModule module, bool isEven) {
    final isCompleted = module.status == ModuleStatus.completed;
    final isActive = module.status == ModuleStatus.active;
    final isQuiz = module.order == 4 || module.title.toLowerCase().contains('kuis');

    if (isActive) {
      return _buildActiveNode(context, module);
    }

    if (isCompleted) {
      return _buildCompletedNode(context, module, isEven);
    }

    if (isQuiz) {
      return _buildQuizNode(context, module, isEven);
    }

    return _buildLockedNode(context, module, isEven);
  }

  Widget _buildCompletedNode(BuildContext context, LearningModule module, bool isEven) {
    final p = context.palette;
    final pill = InkWell(
      onTap: () => widget.onModuleTap(module),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: p.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: p.outline.withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isEven ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: p.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: p.primary.withValues(alpha: 0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: isEven ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${module.order}. ${module.title}',
                  style: AppTypography.bodyM.copyWith(
                    fontWeight: FontWeight.w600,
                    color: p.text,
                    fontSize: 13,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, color: p.accent, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '+50 XP',
                      style: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.bold,
                        color: p.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );

    return Align(
      alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(left: isEven ? 16 : 0, right: isEven ? 0 : 16),
        child: pill,
      ),
    );
  }

  Widget _buildActiveNode(BuildContext context, LearningModule module) {
    final p = context.palette;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final pulseValue = _pulseController.value;
        final bounceOffset = math.sin(pulseValue * math.pi) * 4;

        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Floating Bouncing Tooltip Badge
                Positioned(
                  top: -24 + bounceOffset,
                  left: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: p.text,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Mulai di sini! 🚀',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Little pointer arrow
                      Transform.rotate(
                        angle: math.pi / 4,
                        child: Container(
                          width: 6,
                          height: 6,
                          color: p.text,
                        ),
                      ),
                    ],
                  ),
                ),

                // Active Card
                InkWell(
                  onTap: () => widget.onModuleTap(module),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: p.primary.withValues(alpha: 0.35)),
                      boxShadow: [
                        BoxShadow(
                          color: p.primary.withValues(alpha: 0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pulsing play button
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 58 + (pulseValue * 8),
                              height: 58 + (pulseValue * 8),
                              decoration: BoxDecoration(
                                color: p.primary.withValues(alpha: 0.15 * (1 - pulseValue * 0.5)),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: p.surface,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: p.primary.withValues(alpha: 0.25),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.play_circle_fill_rounded, color: p.primary, size: 36),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: p.primary,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Sedang Berjalan',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${module.order}. ${module.title}',
                              style: AppTypography.bodyL.copyWith(
                                fontWeight: FontWeight.bold,
                                color: p.text,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Bab ${module.order} • ${module.description.contains('Slide') ? module.description : '6 Latihan'}',
                              style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizNode(BuildContext context, LearningModule module, bool isEven) {
    final p = context.palette;
    final pill = InkWell(
      onTap: () => widget.onModuleTap(module),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: p.surface.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: p.outline.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: isEven ? TextDirection.ltr : TextDirection.rtl,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFFFDEA8), // secondary-fixed
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.bolt_rounded, color: Color(0xFF7C5800), size: 24),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: isEven ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${module.order}. ${module.title}',
                  style: AppTypography.bodyM.copyWith(
                    fontWeight: FontWeight.w600,
                    color: p.text,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Uji Pemahaman',
                  style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );

    return Align(
      alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(left: isEven ? 16 : 0, right: isEven ? 0 : 16),
        child: pill,
      ),
    );
  }

  Widget _buildLockedNode(BuildContext context, LearningModule module, bool isEven) {
    final p = context.palette;
    final pill = Opacity(
      opacity: 0.72,
      child: InkWell(
        onTap: () => widget.onModuleTap(module),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: p.surface.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: p.outline.withValues(alpha: 0.6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isEven ? TextDirection.ltr : TextDirection.rtl,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: p.surfaceAlt,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(Icons.lock_rounded, color: p.textMuted, size: 20),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: isEven ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${module.order}. ${module.title}',
                    style: AppTypography.bodyM.copyWith(
                      fontWeight: FontWeight.w600,
                      color: p.text,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    'Terkunci',
                    style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );

    return Align(
      alignment: isEven ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(left: isEven ? 16 : 0, right: isEven ? 0 : 16),
        child: pill,
      ),
    );
  }

  Widget _buildCertificateGoal(BuildContext context) {
    final p = context.palette;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFE4E8F8), // surface-container-high
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: p.outline.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFDEE2F3), // surface-container-highest
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.emoji_events_rounded, color: Color(0xFF7C5800), size: 28),
            ),
            const SizedBox(height: 6),
            Text(
              'Sertifikat Modul',
              style: AppTypography.label.copyWith(
                fontWeight: FontWeight.bold,
                color: p.text,
                fontSize: 14,
              ),
            ),
            Text(
              'Target Kelulusan',
              style: AppTypography.caption.copyWith(color: p.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dotted grid painter mimicking CSS:
/// `background-image: radial-gradient(#E4E1D9 1.2px, transparent 1.2px); background-size: 16px 16px;`
class _DottedGridPainter extends CustomPainter {
  const _DottedGridPainter({required this.dotColor});
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const spacing = 16.0;
    const dotRadius = 1.0;

    for (double x = spacing / 2; x < size.width; x += spacing) {
      for (double y = spacing / 2; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedGridPainter oldDelegate) {
    return oldDelegate.dotColor != dotColor;
  }
}

/// Path painter drawing an authentic S-curve line through the nodes.
class _RoadmapPathPainter extends CustomPainter {
  const _RoadmapPathPainter({
    required this.nodeCount,
    required this.lineColor,
    required this.activeColor,
    required this.activeStep,
  });

  final int nodeCount;
  final Color lineColor;
  final Color activeColor;
  final int activeStep;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodeCount <= 1) return;

    final stepHeight = size.height / (nodeCount - 0.5);

    final leftX = size.width * 0.22;
    final rightX = size.width * 0.78;
    final centerX = size.width * 0.5;

    // Full dashed background path (#E4EDFF)
    final bgPath = Path();
    bgPath.moveTo(leftX, 36);

    for (var i = 0; i < nodeCount - 1; i++) {
      final fromX = i.isEven ? leftX : rightX;
      final toX = (i == nodeCount - 2) ? centerX : ((i + 1).isEven ? leftX : rightX);
      final fromY = 36 + i * stepHeight;
      final toY = 36 + (i + 1) * stepHeight;

      final controlX = (fromX + toX) / 2;
      bgPath.cubicTo(controlX, fromY + stepHeight * 0.35, controlX, toY - stepHeight * 0.35, toX, toY);
    }

    final paintBg = Paint()
      ..color = lineColor
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    _drawDashedPath(canvas, bgPath, paintBg, dashWidth: 4, dashSpace: 8);

    // Active foreground solid path (#2F6FED) up to activeStep
    final activeStepsToDraw = math.min(activeStep - 1, nodeCount - 1);
    if (activeStepsToDraw > 0) {
      final activePath = Path();
      activePath.moveTo(leftX, 36);

      for (var i = 0; i < activeStepsToDraw; i++) {
        final fromX = i.isEven ? leftX : rightX;
        final toX = (i == nodeCount - 2) ? centerX : ((i + 1).isEven ? leftX : rightX);
        final fromY = 36 + i * stepHeight;
        final toY = 36 + (i + 1) * stepHeight;

        final controlX = (fromX + toX) / 2;
        activePath.cubicTo(controlX, fromY + stepHeight * 0.35, controlX, toY - stepHeight * 0.35, toX, toY);
      }

      final paintActive = Paint()
        ..color = activeColor
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(activePath, paintActive);
    }
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dashWidth,
    required double dashSpace,
  }) {
    for (final metric in path.computeMetrics()) {
      double start = 0.0;
      while (start < metric.length) {
        final end = math.min(start + dashWidth, metric.length);
        final extractPath = metric.extractPath(start, end);
        canvas.drawPath(extractPath, paint);
        start += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RoadmapPathPainter oldDelegate) {
    return oldDelegate.nodeCount != nodeCount ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.activeStep != activeStep;
  }
}
