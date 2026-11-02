// FILE: lib/features/ai_tutor/domain/tutor_models.dart
// TUGAS: model domain tutor — kuota hint harian (PRD maks 5x/hari), hasil
// petunjuk, snapshot kuota read-only, dan script offline.
// FUNGSI YANG DIKELOLA: TutorQuota (remaining/total, hasQuota, syncFromServer,
// exhaust, consume), TutorQuotaSnapshot, TutorHintResult, TutorHint,
// TutorScript (3 hint: Konsep/Logika/Struktur).
// WAJIB DIUBAH BILA: limit kuota per plan berubah atau level hint bertambah.
import 'package:flutter/foundation.dart';

/// Daily AI hint quota. Source of truth = server (`ai_quotas` 5x/hari);
/// state lokal hanya untuk tampilan antara dua request server.
class TutorQuota extends ChangeNotifier {
  TutorQuota({this.remaining = 5, this.total = 5});

  final int total;
  int remaining;

  bool get hasQuota => remaining > 0;

  /// Sinkronisasi dari server: sisa = limit - terpakai (P0-6).
  void syncFromServer({required int used, required int limit}) {
    remaining = (limit - used).clamp(0, limit);
    notifyListeners();
  }

  void exhaust() {
    remaining = 0;
    notifyListeners();
  }

  /// Consumes one hint. Returns false when the quota is exhausted.
  bool consume() {
    if (remaining <= 0) return false;
    remaining--;
    notifyListeners();
    return true;
  }
}

/// Isi riil GET /tutor/quota (read-only). Dipakai sebelum hint pertama
/// dibuka supaya pill "x/total" tidak berupa tebakan lokal.
class TutorQuotaSnapshot {
  const TutorQuotaSnapshot({required this.used, required this.limit, required this.left});

  final int used;
  final int limit;
  final int left;
}

/// Satu hasil fetch hint dari backend lengkap dengan status kuota server.
class TutorHintResult {
  const TutorHintResult({
    required this.hint,
    required this.quotaUsed,
    required this.quotaLimit,
    required this.quotaLeft,
    this.concept,
    this.fromCache = false,
  });

  final TutorHint hint;
  final int quotaUsed;
  final int quotaLimit;
  final int quotaLeft;

  /// Konsep yang dideteksi server utk soal aktif (detected_concept).
  /// Dipakai menggantikan konsep statis script agar pill sesuai tantangan.
  final String? concept;

  /// true bila repo mengembalikan hint yang SUDAH dibayar (sesi yang sama,
  /// buka ulang sheet tantangan yang sama). Angka kuota dari salinan cache
  /// tidak boleh menimpa angka resmi server, jadi UI melewati syncFromServer.
  final bool fromCache;
}

class TutorHint {
  const TutorHint({required this.tabLabel, required this.question, required this.steps});

  final String tabLabel;
  final String question;
  final List<String> steps;
}

/// Scaffolded hints for one challenge. Never contains the final solution
/// (SRD §2.4: `contains_solution_code` is always false).
class TutorScript {
  const TutorScript({required this.concept, required this.hints});

  final String concept;
  final List<TutorHint> hints;

  /// Script cadangan (mode offline / demo) yang MENYESUAIKAN soal aktif.
  ///
  /// Dulu semua tantangan jatuh ke script kelulusan KKM (percabangan
  /// bersarang, nilai 75) sehingga tutor seolah selalu membahas soal itu.
  /// Sekarang label konsep memakai judul soal asli dan pertanyaannya hanya
  /// menuntun proses berpikir atas kode siswa sendiri.
  factory TutorScript.forTopic(String? topic) {
    final title = (topic ?? '').trim();
    return TutorScript(
      concept: title.isEmpty ? 'Latihan Koding' : title,
      hints: const [
        TutorHint(
          tabLabel: 'Hint 1: Konsep',
          question:
              'Apa output yang diminta soal ini? Ceritakan dulu dengan bahasamu sendiri sebelum menyentuh kode.',
          steps: [
            'Sebutkan input yang tersedia dan output yang harus muncul.',
            'Tandai bagian kode yang sudah kamu pahami dan bagian yang masih ragu.',
          ],
        ),
        TutorHint(
          tabLabel: 'Hint 2: Logika',
          question:
              'Bagaimana urutan langkah programmu dari baris pertama sampai terakhir?',
          steps: [
            'Tulis urutan langkahnya dalam bahasa sehari-hari, belum dalam kode.',
            'Periksa apakah setiap langkah benar-benar mengarah ke output yang diminta soal.',
          ],
        ),
        TutorHint(
          tabLabel: 'Hint 3: Struktur',
          question:
              'Baris mana yang paling sering memunculkan error saat kamu jalankan?',
          steps: [
            'Baca pesan error dari baris paling atas: nama error dan nomor barisnya.',
            'Cocokkan tanda baca di baris itu (kurung, titik dua, tanda kutip, indentasi).',
          ],
        ),
      ],
    );
  }

  /// Script fallback offline untuk mode Playground (kode bebas di luar soal):
  /// panduan umum berpikir-proses yang TIDAK memuat konteks tantangan lama.
  static const playground = TutorScript(
    concept: 'Latihan Mandiri (Playground)',
    hints: [
      TutorHint(
        tabLabel: 'Hint 1: Konsep',
        question:
            'Masalah apa yang paling ingin kamu pecahkan program ini? Tulis tujuannya dalam satu kalimat dulu.',
        steps: [
          'Petakan: input apa yang masuk, proses apa yang dilakukan, output apa yang diharapkan.',
          'Mulai dari potongan paling kecil yang bisa kamu uji sendiri.',
        ],
      ),
      TutorHint(
        tabLabel: 'Hint 2: Logika',
        question: 'Bagaimana urutan langkah programmu dari baris pertama sampai terakhir?',
        steps: [
          'Tulis alurnya sebagai pseudo-kode bahasa Indonesia sebelum disalin ke Python.',
          'Tandai mana bagian yang berulang (loop) dan mana yang bercabang (if).',
        ],
      ),
      TutorHint(
        tabLabel: 'Hint 3: Struktur',
        question: 'Bagian mana dari kodemu yang tampak rancu saat dibaca?',
        steps: [
          'Cek indentasi dan tanda titik dua pada baris yang berisi logika.',
          'Uji potongan kecil di terminal yang sama sebelum digabung kembali.',
        ],
      ),
    ],
  );
}
