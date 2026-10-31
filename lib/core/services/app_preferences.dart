// FILE: lib/core/services/app_preferences.dart
//
// TUGAS: preferensi tampilan aplikasi yang berlaku untuk siswa maupun pengajar
// (mode gelap/terang dan bahasa antarmuka). Disimpan di perangkat agar pilihan
// tidak hilang saat aplikasi ditutup.
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPreferences extends ChangeNotifier {
  AppPreferences._();

  static final AppPreferences instance = AppPreferences._();

  static const _storage = FlutterSecureStorage();
  static const _keyThemeMode = 'codelab_theme_mode';
  static const _keyLocale = 'codelab_app_locale';

  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('id');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  String get themeLabel => switch (_themeMode) {
    ThemeMode.light => 'Terang',
    ThemeMode.dark => 'Gelap',
    ThemeMode.system => 'Ikuti Sistem',
  };

  String get languageLabel =>
      _locale.languageCode == 'en' ? 'English' : 'Indonesia';

  /// Dipanggil sekali saat aplikasi dibuka (main.dart).
  Future<void> init() async {
    try {
      final theme = await _storage.read(key: _keyThemeMode);
      _themeMode = switch (theme) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      final locale = await _storage.read(key: _keyLocale);
      _locale = Locale(locale == 'en' ? 'en' : 'id');
      notifyListeners();
    } catch (_) {
      // Penyimpanan lokal tidak tersedia: tetap pakai default aman.
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    try {
      await _storage.write(
        key: _keyThemeMode,
        value: switch (mode) {
          ThemeMode.light => 'light',
          ThemeMode.dark => 'dark',
          ThemeMode.system => 'system',
        },
      );
    } catch (_) {
      // Gagal menyimpan tidak boleh membatalkan perubahan yang sudah tampil.
    }
  }

  Future<void> setLocale(Locale locale) async {
    final code = locale.languageCode == 'en' ? 'en' : 'id';
    if (_locale.languageCode == code) return;
    _locale = Locale(code);
    notifyListeners();
    try {
      await _storage.write(key: _keyLocale, value: code);
    } catch (_) {
      // idem: perubahan tetap berlaku untuk sesi ini.
    }
  }
}
