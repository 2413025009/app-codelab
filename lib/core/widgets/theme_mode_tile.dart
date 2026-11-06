// FILE: lib/core/widgets/theme_mode_tile.dart
//
// TUGAS: baris pengaturan "Tema Tampilan" dengan TIGA pilihan
// (Terang / Gelap / Ikuti Sistem) untuk siswa maupun pengajar.
//
// MENGAPA DIPISAH: sebelumnya Pengaturan hanya punya saklar Terang/Gelap,
// padahal `AppPreferences` sudah menyimpan `ThemeMode.system`. Siswa yang
// ingin aplikasi mengikuti tema HP tidak punya jalan memilihnya. Widget ini
// dipakai bersama oleh `settings_page.dart` (siswa) dan
// `teacher_settings_page.dart` (pengajar) agar perilakunya identik.
//
// WAJIB DIUBAH BILA: menambah pilihan tema baru → tambahkan `ThemeMode` di
// daftar opsi + labelnya di `app_id.arb`/`app_en.arb`/`app_ar.arb`.
import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../services/app_preferences.dart';
import '../theme/app_palette.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Baris pengaturan tema dengan tiga pilihan: Terang, Gelap, Ikuti Sistem.
///
/// Menampilkan pilihan yang sedang aktif (bukan sekadar terang/gelap yang
/// kebetulan sedang tampil), lalu menyimpannya lewat [AppPreferences].
class ThemeModeTile extends StatelessWidget {
  const ThemeModeTile({super.key, this.showDivider = true});

  /// Garis pemisah di bawah baris; dimatikan bila baris ini yang terakhir
  /// dalam satu kartu pengaturan.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final l10n = AppLocalizations.of(context);
    final current = AppPreferences.instance.themeMode;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(Icons.brightness_6_outlined, color: p.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsThemeMode,
                      style: AppTypography.label.copyWith(
                        color: p.text,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.settingsThemeModeSubtitle,
                      style: AppTypography.caption.copyWith(color: p.textMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              Expanded(
                child: _ThemeOption(
                  icon: Icons.light_mode_outlined,
                  label: l10n.settingsThemeLight,
                  selected: current == ThemeMode.light,
                  onTap: () => _select(context, ThemeMode.light),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ThemeOption(
                  icon: Icons.dark_mode_outlined,
                  label: l10n.settingsThemeDark,
                  selected: current == ThemeMode.dark,
                  onTap: () => _select(context, ThemeMode.dark),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ThemeOption(
                  icon: Icons.brightness_auto_outlined,
                  label: l10n.settingsThemeSystem,
                  selected: current == ThemeMode.system,
                  onTap: () => _select(context, ThemeMode.system),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, color: p.outline.withValues(alpha: 0.5)),
      ],
    );
  }

  Future<void> _select(BuildContext context, ThemeMode mode) async {
    await AppPreferences.instance.setThemeMode(mode);
  }
}

/// Satu tombol pilihan tema di dalam baris.
class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: selected ? p.primaryContainer : p.surfaceAlt,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.sm + 2,
              horizontal: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected
                    ? p.primary
                    : p.outline.withValues(alpha: 0.6),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? p.primary : p.textMuted,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: selected ? p.primary : p.text,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
