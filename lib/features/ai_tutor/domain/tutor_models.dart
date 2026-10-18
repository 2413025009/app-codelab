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
  });

  final TutorHint hint;
  final int quotaUsed;
  final int quotaLimit;
  final int quotaLeft;
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

  static const kkm = TutorScript(
    concept: 'Percabangan Bersarang',
    hints: [
      TutorHint(
        tabLabel: 'Hint 1: Konsep',
        question:
            'Apa yang terjadi pada variabel status kelulusan jika nilai input siswa tepat bernilai 75? Apakah kondisi pertama mengevaluasi nilai tersebut sebagai True?',
        steps: [
          'Periksa kembali operator relasional yang kamu gunakan (apakah > atau ≥).',
          'Ingat kembali aturan KKM sekolah: siswa dengan nilai pas 75 termasuk dalam kategori Tuntas.',
        ],
      ),
      TutorHint(
        tabLabel: 'Hint 2: Logika',
        question: 'Jika 75 harus lulus, kondisi seperti apa yang bernilai True saat nilai sama dengan batas?',
        steps: [
          'Tuliskan tiga nilai uji di kertas: 74, 75, dan 76. Mana yang harus LULUS?',
          'Bandingkan dengan hasil kodemu untuk setiap nilai tersebut.',
        ],
      ),
      TutorHint(
        tabLabel: 'Hint 3: Struktur',
        question: 'Operator mana yang memeriksa "lebih besar atau sama dengan" dalam Python?',
        steps: [
          'Cari simbol yang menggabungkan > dan = tanpa spasi.',
          'Terapkan pada baris if, lalu jalankan Uji Coba lagi.',
        ],
      ),
    ],
  );

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
