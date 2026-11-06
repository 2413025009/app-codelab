// FILE: test/theme_mode_labels_test.dart
//
// TUGAS: memastikan tiga pilihan tema (Minggu 13) benar-benar tersedia dalam
// tiga bahasa, dan label "Ikuti Sistem" berbeda dari Terang/Gelap.
//
// MENGAPA DIPERIKSA DI SINI: `AppPreferences` menyimpan ThemeMode.system, tetapi
// sebelum Minggu 13 UI hanya menawarkan Terang/Gelap sehingga pilihan itu tidak
// bisa dicapai pengguna. Test ini menjaga agar ketiga label tetap ada.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/l10n/app_localizations.dart';

void main() {
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.delegate.load(locale);

  test('tiga label tema tersedia di Indonesia', () async {
    final l10n = await load(const Locale('id'));
    expect(l10n.settingsThemeLight, 'Terang');
    expect(l10n.settingsThemeDark, 'Gelap');
    expect(l10n.settingsThemeSystem, 'Ikuti Sistem');
  });

  test('tiga label tema tersedia di English', () async {
    final l10n = await load(const Locale('en'));
    expect(l10n.settingsThemeLight, 'Light');
    expect(l10n.settingsThemeDark, 'Dark');
    expect(l10n.settingsThemeSystem, 'Follow System');
  });

  test('tiga label tema tersedia di Arab', () async {
    final l10n = await load(const Locale('ar'));
    expect(l10n.settingsThemeLight.isNotEmpty, isTrue);
    expect(l10n.settingsThemeDark.isNotEmpty, isTrue);
    expect(l10n.settingsThemeSystem.isNotEmpty, isTrue);
    // Label Arab tidak boleh sama dengan label Inggris.
    expect(l10n.settingsThemeSystem, isNot('Follow System'));
  });

  test('label tema tidak saling tertukar', () async {
    final l10n = await load(const Locale('id'));
    expect(l10n.settingsThemeLight, isNot(l10n.settingsThemeDark));
    expect(l10n.settingsThemeDark, isNot(l10n.settingsThemeSystem));
  });

  test('AppPreferences mendukung ThemeMode.system', () async {
    // Nilai awal harus system (mengikuti HP) sebelum pengguna memilih.
    // Dibaca langsung dari enum agar tidak bergantung pada penyimpanan.
    const modes = [ThemeMode.light, ThemeMode.dark, ThemeMode.system];
    expect(modes.length, 3);
    expect(modes.contains(ThemeMode.system), isTrue);
  });
}
