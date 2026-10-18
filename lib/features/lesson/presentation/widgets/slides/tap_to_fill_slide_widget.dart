import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/widgets/app_card.dart';
import '../../../../../core/widgets/app_tag.dart';
import '../../../../../core/widgets/code_window_shell.dart';
import '../../../domain/slide_models.dart';

class TapToFillSlideWidget extends StatefulWidget {
  const TapToFillSlideWidget({
    super.key,
    required this.slide,
    required this.onAnswerChanged,
  });

  final TapToFillSlide slide;
  final ValueChanged<bool> onAnswerChanged;

  @override
  TapToFillSlideWidgetState createState() => TapToFillSlideWidgetState();
}

class TapToFillSlideWidgetState extends State<TapToFillSlideWidget> {
  late List<String?> _filledSlots;
  late List<String> _availableOptions;

  int get totalSlots => widget.slide.correctAnswers.length;

  @override
  void initState() {
    super.initState();
    _reset();
  }

  @override
  void didUpdateWidget(covariant TapToFillSlideWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slide != widget.slide) {
      _reset();
    }
  }

  void _reset() {
    _filledSlots = List<String?>.filled(totalSlots, null);
    _availableOptions = List<String>.from(widget.slide.options);
    // Tunda kabar "belum terjawab" sampai frame selesai: _reset() dijalankan
    // dari initState/didUpdateWidget (di tengah fase build), dan callback
    // langsung memicu setState() pada LessonReaderPage (ancestor) - Flutter
    // menolaknya ("setState() called during build") sehingga seluruh layar
    // jadi merah penuh saat materi dibuka. Post-frame = aman.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onAnswerChanged(false);
    });
  }

  void resetAnswer() {
    setState(() {
      _reset();
    });
  }

  bool checkAnswer() {
    for (var i = 0; i < totalSlots; i++) {
      if (i >= widget.slide.correctAnswers.length) break;
      final expected = widget.slide.correctAnswers[i].trim();
      final actual = _filledSlots[i]?.trim();
      if (actual != expected) {
        return false;
      }
    }
    return true;
  }

  void _tapOption(String option) {
    final firstEmpty = _filledSlots.indexOf(null);
    if (firstEmpty == -1) return;

    setState(() {
      _filledSlots[firstEmpty] = option;
      _availableOptions.remove(option);
      widget.onAnswerChanged(!_filledSlots.contains(null));
    });
  }

  void _removeSlot(int index) {
    final val = _filledSlots[index];
    if (val == null) return;

    setState(() {
      _filledSlots[index] = null;
      _availableOptions.add(val);
      widget.onAnswerChanged(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    var slotCounter = 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.md, AppSpacing.screen, AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppTag(
                'Susun Sintaks',
                background: p.primaryContainer,
                foreground: p.primary,
                icon: Icons.dashboard_customize_rounded,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            widget.slide.title,
            style: AppTypography.titleL.copyWith(color: p.text, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ketuk balok kode di bawah untuk mengisi slot kosong yang sesuai:',
            style: AppTypography.bodyM.copyWith(color: p.textMuted),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Code Box — editor terang ala Stitch v2 (§2.2)
          CodeWindowShell(
            fileName: widget.slide.file,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.slide.codeLines.map((line) {
                  final parts = line.split('[slot]');
                  final widgets = <Widget>[];

                  for (var i = 0; i < parts.length; i++) {
                    if (parts[i].isNotEmpty) {
                      widgets.add(
                        Text(
                          parts[i],
                          style: TextStyle(
                            fontFamily: 'JetBrains Mono',
                            color: p.text,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      );
                    }
                    if (i < parts.length - 1) {
                      final currentSlotIdx = slotCounter++;
                      final slotVal = currentSlotIdx < _filledSlots.length ? _filledSlots[currentSlotIdx] : null;

                      widgets.add(
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: slotVal != null ? () => _removeSlot(currentSlotIdx) : null,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: slotVal != null ? p.primaryContainer : p.surfaceAlt,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: slotVal != null
                                      ? p.primary
                                      : p.outline,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    slotVal ?? ' ... ',
                                    style: TextStyle(
                                      fontFamily: 'JetBrains Mono',
                                      fontWeight: FontWeight.bold,
                                      color: slotVal != null ? p.primary : p.textMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (slotVal != null) ...[
                                    const SizedBox(width: 4),
                                    Icon(Icons.close_rounded, color: p.primary, size: 14),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: widgets,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Bank Balok Kata:',
            style: AppTypography.label.copyWith(color: p.textMuted, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Word Bank
          AppCard(
            color: p.surfaceAlt,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableOptions.map((opt) {
                return ActionChip(
                  label: Text(
                    opt,
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontWeight: FontWeight.w600,
                      color: p.primary,
                      fontSize: 14,
                    ),
                  ),
                  backgroundColor: p.surface,
                  side: BorderSide(color: p.outline),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 1,
                  onPressed: () => _tapOption(opt),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
