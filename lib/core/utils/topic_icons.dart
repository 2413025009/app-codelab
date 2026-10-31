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

/// Ikon materi dari kolom `lessons.icon_code` di database. Kode yang tidak
/// dikenal (atau kosong) jatuh kembali ke ikon topik supaya kartu materi lama
/// tetap punya ikon wajar.
IconData materialIcon(String iconCode, {String topic = ''}) {
  switch (iconCode.trim().toLowerCase()) {
    case 'code':
      return Icons.code_rounded;
    case 'html':
      return Icons.html_rounded;
    case 'css':
      return Icons.css_rounded;
    case 'javascript':
    case 'js':
      return Icons.javascript_rounded;
    case 'database':
    case 'db':
      return Icons.storage_rounded;
    case 'psychology':
    case 'ai':
      return Icons.psychology_rounded;
    case 'phone_android':
    case 'mobile':
      return Icons.phone_android_rounded;
    case 'shield':
    case 'security':
      return Icons.shield_rounded;
    case 'data_object':
      return Icons.data_object_rounded;
    case 'terminal':
      return Icons.terminal_rounded;
    default:
      return topicIcon(topic);
  }
}
