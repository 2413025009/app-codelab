// FILE: lib/core/widgets/app_breakdown_screen.dart
//
// TUGAS: layar "Terjadi Kendala" (Minggu 14 — laporan galat).
//
// Ditampilkan oleh ErrorWidget.builder saat sebuah widget gagal dibangun,
// agar siswa melihat penjelasan manusiawi + tombol salin laporan, bukan
// kotak merah bergaris debug.
//
// Desain sengaja minimal dan mandiri: layar ini tidak boleh bergantung pada
// provider, tema, atau localizations yang mungkin justru penyebab galat.
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/error_reporter.dart';

class AppBreakdownScreen extends StatelessWidget {
  const AppBreakdownScreen({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    // Palet tetap (bukan context.palette) — layar ini harus tetap tampil
    // walau Theme/Provider di atasnya sedang bermasalah.
    const bg = Color(0xFFFDFBF7);
    const fg = Color(0xFF1F2430);
    const muted = Color(0xFF5B6475);
    const danger = Color(0xFFB42318);
    const primary = Color(0xFF2F6FED);

    return Material(
      color: bg,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shield_outlined, size: 56, color: danger),
                  const SizedBox(height: 16),
                  const Text(
                    'Terjadi Kendala',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: fg,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Aplikasi berhenti di tengah jalan. Salin laporan di bawah '
                    'dan kirimkan ke pengajar agar cepat diperbaiki.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.5, color: muted),
                  ),
                  if (kDebugMode && message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: muted),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                    ),
                    onPressed: () async {
                      final text = ErrorReporter.instance.buildReport();
                      await Clipboard.setData(ClipboardData(text: text));
                      if (!context.mounted) return;
                      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                        const SnackBar(
                          content: Text('Laporan galat disalin ke papan klip.'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Salin Laporan'),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Setelah laporan disalin, tutup lalu buka kembali aplikasi. '
                    'Jika kendala berulang, kirim laporan itu ke pengajar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, height: 1.5, color: muted),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
