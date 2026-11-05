// FILE: lib/features/ai_tutor/domain/tutor_models.dart
// TUGAS: model domain tutor — kuota hint harian (PRD maks 5x/hari), hasil
// petunjuk, snapshot kuota read-only, dan script offline.
// FUNGSI YANG DIKELOLA: TutorQuota (remaining/total, hasQuota, syncFromServer,
// exhaust, consume), TutorQuotaSnapshot, TutorHintResult, TutorHint,
// TutorScript (3 hint: Konsep/Logika/Struktur).
// WAJIB DIUBAH BILA: limit kuota per plan berubah atau level hint bertambah.
import 'package:flutter/foundation.dart';

import '../../../l10n/app_localizations.dart';

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
  });

  final TutorHint hint;
  final int quotaUsed;
  final int quotaLimit;
  final int quotaLeft;

  /// Konsep yang dideteksi server utk soal aktif (detected_concept).
  /// Dipakai menggantikan konsep statis script agar pill sesuai tantangan.
  final String? concept;
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
  ///
  /// Teks hint adalah LABEL UI (bukan konten database): dibangun dari
  /// [l10n] agar mengikuti bahasa aplikasi aktif. Judul soal ([topic])
  /// dipakai apa adanya karena itu data.
  factory TutorScript.forTopic(String? topic, AppLocalizations l10n) {
    final title = (topic ?? '').trim();
    return TutorScript(
      concept: title.isEmpty ? l10n.tutorHintDefaultConcept : title,
      hints: [
        TutorHint(
          tabLabel: l10n.tutorHintTabConcept,
          question: l10n.tutorHintChallengeQ1,
          steps: [
            l10n.tutorHintChallengeQ1Step1,
            l10n.tutorHintChallengeQ1Step2,
          ],
        ),
        TutorHint(
          tabLabel: l10n.tutorHintTabLogic,
          question: l10n.tutorHintChallengeQ2,
          steps: [
            l10n.tutorHintChallengeQ2Step1,
            l10n.tutorHintChallengeQ2Step2,
          ],
        ),
        TutorHint(
          tabLabel: l10n.tutorHintTabStructure,
          question: l10n.tutorHintChallengeQ3,
          steps: [
            l10n.tutorHintChallengeQ3Step1,
            l10n.tutorHintChallengeQ3Step2,
          ],
        ),
      ],
    );
  }

  /// Script fallback offline untuk mode Playground (kode bebas di luar soal):
  /// panduan umum berpikir-proses yang TIDAK memuat konteks tantangan lama.
  ///
  /// Dulu `const`; sekarang factory sadar locale seperti [forTopic] karena
  /// teksnya adalah label UI. Tidak ada pemakai di repo saat perubahan ini
  /// (dicari di lib/ dan test/), jadi perubahan dari const ke factory aman.
  static TutorScript playground(AppLocalizations l10n) {
    return TutorScript(
      concept: l10n.tutorHintPlaygroundConcept,
      hints: [
        TutorHint(
          tabLabel: l10n.tutorHintTabConcept,
          question: l10n.tutorHintPlaygroundQ1,
          steps: [
            l10n.tutorHintPlaygroundQ1Step1,
            l10n.tutorHintPlaygroundQ1Step2,
          ],
        ),
        TutorHint(
          tabLabel: l10n.tutorHintTabLogic,
          question: l10n.tutorHintPlaygroundQ2,
          steps: [
            l10n.tutorHintPlaygroundQ2Step1,
            l10n.tutorHintPlaygroundQ2Step2,
          ],
        ),
        TutorHint(
          tabLabel: l10n.tutorHintTabStructure,
          question: l10n.tutorHintPlaygroundQ3,
          steps: [
            l10n.tutorHintPlaygroundQ3Step1,
            l10n.tutorHintPlaygroundQ3Step2,
          ],
        ),
      ],
    );
  }
}
