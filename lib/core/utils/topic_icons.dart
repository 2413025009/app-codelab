// FILE: lib/core/utils/topic_icons.dart
// TUGAS: memetakan nama track/topik materi ke ikon yang sesuai.
// WAJIB DIUBAH BILA: ada track materi baru yang butuh ikon sendiri.
import 'package:flutter/material.dart';

/// Ikon track materi berdasarkan nama topik (case-insensitive).
IconData topicIcon(String topic) {
  final t = topic.toLowerCase();
  if (t.contains('javascript')) return Icons.javascript_rounded;
  if (t.contains('css')) return Icons.palette_rounded;
  if (t.contains('html') || t.contains('web')) return Icons.language_rounded;
  return Icons.terminal_rounded;
}
