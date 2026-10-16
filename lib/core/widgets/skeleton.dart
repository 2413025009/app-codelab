import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';

/// Skeleton block used while content loads (DESIGN.md §5.3).
/// Respects Reduce Motion by rendering a static block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({super.key, this.width, required this.height, this.radius = 12});

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(radius)),
    );
    if (MediaQuery.of(context).disableAnimations) return box;
    return Shimmer.fromColors(
      baseColor: p.surfaceAlt,
      highlightColor: p.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: p.surfaceAlt, borderRadius: BorderRadius.circular(radius)),
      ),
    );
  }
}

/// Skeleton shaped like the dashboard while loading.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 180, height: 28),
          SizedBox(height: 8),
          SkeletonBox(width: 120, height: 16),
          SizedBox(height: 24),
          SkeletonBox(height: 190, radius: AppRadius.card),
          SizedBox(height: 24),
          SkeletonBox(height: 280, radius: AppRadius.card),
          SizedBox(height: 24),
          SkeletonBox(height: 72, radius: AppRadius.card),
          SizedBox(height: 12),
          SkeletonBox(height: 72, radius: AppRadius.card),
        ],
      ),
    );
  }
}
