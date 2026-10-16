import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_palette.dart';
import '../theme/app_typography.dart';

/// Four-axis competency radar (Logika, Variabel, Perulangan, Fungsi).
/// [scores] map axis label -> 0..100. A text alternative is provided via Semantics.
class CompetencyRadar extends StatelessWidget {
  const CompetencyRadar({super.key, required this.scores, this.size = 240, this.showValueInLabel = false});

  final Map<String, double> scores;
  final double size;
  final bool showValueInLabel;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final labels = scores.keys.toList();
    final semantic = scores.entries.map((e) => '${e.key} ${e.value.round()}').join(', ');

    return Semantics(
      label: 'Radar kompetensi: $semantic',
      child: SizedBox(
        height: size,
        child: RadarChart(
          RadarChartData(
            radarShape: RadarShape.polygon,
            tickCount: 3,
            ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
            tickBorderData: BorderSide(color: p.outline),
            gridBorderData: BorderSide(color: p.outline),
            radarBorderData: BorderSide(color: p.outline),
            radarBackgroundColor: Colors.transparent,
            titlePositionPercentageOffset: 0.18,
            titleTextStyle: AppTypography.caption.copyWith(color: p.textMuted),
            getTitle: (index, angle) {
              final label = labels[index];
              final text = showValueInLabel ? '$label\n${scores[label]!.round()}/100' : label;
              return RadarChartTitle(text: text);
            },
            dataSets: [
              RadarDataSet(
                dataEntries: [for (final v in scores.values) RadarEntry(value: v)],
                borderColor: p.primary,
                borderWidth: 2,
                fillColor: p.primary.withValues(alpha: 0.18),
                entryRadius: 3,
              ),
              // Invisible set that pins the scale to 0..100.
              RadarDataSet(
                dataEntries: [for (final _ in scores.values) const RadarEntry(value: 100)],
                borderColor: Colors.transparent,
                fillColor: Colors.transparent,
                entryRadius: 0,
                borderWidth: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
