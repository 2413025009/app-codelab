// FILE: lib/features/teacher/presentation/widgets/slide_field_help.dart
//
// TUGAS: Satu sumber panduan pengisian field di editor slide.
//
// Catatan penting: seluruh teks panduan di bawah ini SENGAJA ditulis statis di
// dalam kode aplikasi, tidak disimpan di database. Selain lebih murah (tidak
// ikut terkirim di setiap payload slide), teks panduan juga jadi tidak bisa
// diubah/diisi lewat API oleh pihak lain.

import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Membuka lembar panduan singkat untuk satu field editor.
///
/// Baris pada [body] yang diawali `- ` akan dirender sebagai butir daftar,
/// baris lain dirender sebagai paragraf biasa. Baris kosong memisahkan blok.
Future<void> showSlideHelp(
  BuildContext context, {
  required String title,
  required String body,
}) {
  final p = context.palette;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: p.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => SlideHelpSheet(title: title, body: body),
  );
}

/// Isi lembar panduan. Dipisah dari [showSlideHelp] agar bisa dipakai ulang
/// (misalnya untuk pratinjau di dalam halaman lain).
class SlideHelpSheet extends StatelessWidget {
  const SlideHelpSheet({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.8;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.md,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: p.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.help_outline_rounded,
                      size: 18,
                      color: p.primary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        title,
                        style: AppTypography.titleM.copyWith(color: p.text),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Flexible(
                child: SingleChildScrollView(child: _HelpBody(body: body)),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  child: const Text('Mengerti'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Merender teks panduan: butir `- ` jadi daftar, sisanya paragraf.
class _HelpBody extends StatelessWidget {
  const _HelpBody({required this.body});

  final String body;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final widgets = <Widget>[];

    for (final rawLine in body.split('\n')) {
      final line = rawLine.trimRight();
      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: AppSpacing.sm));
        continue;
      }

      if (line.trimLeft().startsWith('- ')) {
        final text = line.trimLeft().substring(2).trim();
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, right: 8),
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: p.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    text,
                    style: AppTypography.bodySm.copyWith(
                      color: p.text,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        continue;
      }

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            line.trim(),
            style: AppTypography.bodySm.copyWith(color: p.text, height: 1.5),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

/// Label field dengan tombol "?" kecil di sebelah kanan teks label.
///
/// Kalau [help] kosong, widget ini hanya menampilkan label seperti biasa
/// sehingga field yang belum punya panduan tidak menampilkan tombol kosong.
class SlideFieldLabel extends StatelessWidget {
  const SlideFieldLabel({
    super.key,
    required this.label,
    this.help,
    this.helpTitle,
  });

  final String label;
  final String? help;

  /// Judul lembar panduan; bila kosong memakai [label].
  final String? helpTitle;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final hasHelp = help != null && help!.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTypography.labelSm.copyWith(
              color: p.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (hasHelp) ...[
          const SizedBox(width: 6),
          Tooltip(
            message: 'Panduan pengisian',
            child: InkWell(
              onTap: () => showSlideHelp(
                context,
                title: helpTitle ?? label,
                body: help!,
              ),
              customBorder: const CircleBorder(),
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: p.primaryContainer,
                  shape: BoxShape.circle,
                  border: Border.all(color: p.primary.withAlpha(90)),
                ),
                child: Text(
                  '?',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.1,
                    fontWeight: FontWeight.bold,
                    color: p.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
