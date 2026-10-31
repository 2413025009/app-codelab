// FILE: lib/features/class/presentation/widgets/class_sheet_shell.dart
//
// TUGAS: kerangka bottom-sheet ala Stitch v3 untuk dua modal kelas siswa:
// handle pil di atas + sudut 28 + latar surface; suara modal terbuka tetap
// lewat SoundService.playModalOpen agar konsisten dengan showAppSheet.
import 'package:flutter/material.dart';

import '../../../../core/services/sound_service.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';

/// Buka sheet modal kelas; [builder] mengisi konten (sudah bisa digulir).
Future<T?> showClassSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
}) {
  SoundService.playModalOpen();
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.palette.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppRadius.sheetTop),
      ),
    ),
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.92,
    ),
    builder: (ctx) => Padding(
      // Keyboard mengetik kode menaikkan konten — tombol aksi tetap terlihat.
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        MediaQuery.of(ctx).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ctx.palette.outline,
              borderRadius: AppRadius.pillBorder,
            ),
          ),
          // Sama seperti _SheetFrame showAppSheet: konten digulirkan di sini
          // agar tombol aksi tidak pernah "bottom overflowed".
          Flexible(child: SingleChildScrollView(child: builder(ctx))),
          SizedBox(height: MediaQuery.of(ctx).padding.bottom + AppSpacing.lg),
        ],
      ),
    ),
  );
}
