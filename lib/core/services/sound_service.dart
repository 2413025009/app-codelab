// FILE: lib/core/services/sound_service.dart
// TUGAS: Pengelola audio & efek suara (SFX) di seluruh aplikasi CodeLab AI.
// PENGATURAN: Disimpan secara lokal di HP (FlutterSecureStorage) agar nol latensi,
// hemat bandwidth, dan dapat berjalan secara offline.
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SoundService {
  SoundService._();

  static const _storage = FlutterSecureStorage();
  static const _keySfx = 'codelab_sfx_enabled';
  static const _keyLabSfx = 'codelab_lab_sfx_enabled';

  static bool _sfxEnabled = true;
  static bool _labSfxEnabled = true;

  // Reusable player instances untuk efisiensi resource di Web & Mobile
  static final AudioPlayer _uiPlayer = AudioPlayer();
  static final AudioPlayer _labPlayer = AudioPlayer();

  static bool get sfxEnabled => _sfxEnabled;
  static bool get labSfxEnabled => _labSfxEnabled;

  /// Inisialisasi awal saat aplikasi dibuka: membaca preferensi dari HP lokal.
  static Future<void> init() async {
    try {
      final sfxVal = await _storage.read(key: _keySfx);
      if (sfxVal != null) {
        _sfxEnabled = sfxVal == 'true';
      }

      final labVal = await _storage.read(key: _keyLabSfx);
      if (labVal != null) {
        _labSfxEnabled = labVal == 'true';
      }
    } catch (e) {
      debugPrint('SoundService.init error: $e');
    }
  }

  /// Mengubah status Efek Suara Umum & menyimpannya di HP lokal.
  static Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
    try {
      await _storage.write(key: _keySfx, value: enabled.toString());
    } catch (e) {
      debugPrint('SoundService.setSfxEnabled error: $e');
    }
  }

  /// Mengubah status Efek Suara Lab & menyimpannya di HP lokal.
  static Future<void> setLabSfxEnabled(bool enabled) async {
    _labSfxEnabled = enabled;
    try {
      await _storage.write(key: _keyLabSfx, value: enabled.toString());
    } catch (e) {
      debugPrint('SoundService.setLabSfxEnabled error: $e');
    }
  }

  /// Pemutar audio internal menggunakan instance player yang stabil dan reusable.
  static Future<void> _playSound(String fileName, {bool isLabSound = false}) async {
    if (!_sfxEnabled) return;
    if (isLabSound && !_labSfxEnabled) return;

    try {
      final player = isLabSound ? _labPlayer : _uiPlayer;
      await player.stop();
      await player.play(AssetSource('sounds/$fileName'));
    } catch (e) {
      debugPrint('SoundService._playSound($fileName) error: $e');
    }
  }

  // --- Kategori Modal, Popup & Notifikasi ---
  static void playModalOpen() => _playSound('modal_open.mp3');
  static void playToastBubble() => _playSound('toast_bubble.mp3');
  static void playAlertWarning() => _playSound('alert_warning.mp3');
  static void playDialogInfo() => _playSound('dialog_info.mp3');

  // --- Kategori Efek Suara Lab / Playground ---
  static void playLabTerminalPrint() => _playSound('lab_terminal_print.mp3', isLabSound: true);
  static void playLabSyntaxError() => _playSound('lab_syntax_error.mp3', isLabSound: true);

  // --- Kategori Belajar, Kuis & Tantangan ---
  static void playQuizCorrect() => _playSound('quiz_correct.mp3');
  static void playQuizWrong() => _playSound('quiz_wrong.mp3');
  static void playChallengeSuccess() => _playSound('challenge_success.mp3');
  static void playChallengeFail() => _playSound('challenge_fail.mp3');
  static void playChapterClear() => _playSound('chapter_clear.mp3');
  static void playAiHintUnlock() => _playSound('ai_hint_unlock.mp3');

  // --- Kategori Profil ---
  static void playProfileSaved() => _playSound('profile_saved.mp3');

  // --- Kategori Navigasi Umum ---
  /// Nada klik lembut (aset dialog_info.mp3) untuk pemilihan peran akun
  /// & aksi sekunder Minggu 9 (TODO.md §5: SoundService.playButtonClick).
  static void playButtonClick() => _playSound('dialog_info.mp3');
}
