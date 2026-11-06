// FILE: lib/features/certificate/presentation/certificate_doc_labels.dart
//
// TUGAS: teks TETAP pada dokumen e-Sertifikat 2 halaman (piagam + transkrip)
// dalam bahasa aplikasi aktif. Isi materi (nama modul, judul bab, instruksi
// tantangan) tetap memakai teks asli database — tidak diterjemahkan.
//
// MENGAPA DIPISAH: dokumen cetak memuat kalimat panjang (kalimat kelulusan,
// ringkasan silabus) yang tidak dipakai di layar lain, sehingga tidak perlu
// memenuhi file ARB antarmuka. Bahasa yang dipakai tetap mengikuti
// Localizations.localeOf(context), sama seperti teks ARB lainnya.
//
// WAJIB DIUBAH BILA: ada bahasa baru di aplikasi → tambahkan cabang bahasa di
// sini (fallback ke Indonesia) dan pastikan halaman web /verify mendukung
// parameter ?lang= yang sama.
import 'package:flutter/widgets.dart';

class CertificateDocLabels {
  const CertificateDocLabels({
    required this.ribbonModule,
    required this.ribbonChallenge,
    required this.kindModule,
    required this.kindChallenge,
    required this.completionModule,
    required this.completionChallenge,
    required this.accreditation,
    required this.rewardAndDuration,
    required this.level,
    required this.predicate,
    required this.predicateValue,
    required this.accreditationValue,
    required this.verifyHeading,
    required this.validUntil,
    required this.instructorRole,
    required this.platformTagline,
    required this.chaptersCompleted,
    required this.criteriaHeading,
    required this.evalModule,
    required this.evalChallenge,
    required this.totalEffective,
    required this.durationAndScore,
    required this.pageOf,
    required this.moduleAttachment,
    required this.challengeAttachment,
    required this.rulePrefix,
    required this.publicTestCase,
    required this.hiddenTestCase,
    required this.curriculumTag,
    required this.instructorFooter,
    required this.syllabusUnavailable,
    required this.languageCode,
  });

  final String ribbonModule;
  final String ribbonChallenge;
  final String kindModule;
  final String kindChallenge;
  final String completionModule;
  final String completionChallenge;
  final String accreditation;
  final String rewardAndDuration;
  final String level;
  final String predicate;
  final String predicateValue;
  final String accreditationValue;
  final String verifyHeading;
  final String validUntil;
  final String instructorRole;
  final String platformTagline;
  final String chaptersCompleted;
  final String criteriaHeading;
  final String evalModule;
  final String evalChallenge;
  final String totalEffective;
  final String durationAndScore;
  final String pageOf;
  final String moduleAttachment;
  final String challengeAttachment;
  final String rulePrefix;
  final String publicTestCase;
  final String hiddenTestCase;
  final String curriculumTag;
  final String instructorFooter;
  final String syllabusUnavailable;

  /// Kode bahasa untuk parameter `?lang=` halaman verifikasi web.
  final String languageCode;

  static CertificateDocLabels of(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode.toLowerCase();
    switch (code) {
      case 'en':
        return _en;
      case 'ar':
        return _ar;
      default:
        return _id;
    }
  }

  static const _id = CertificateDocLabels(
    ribbonModule: 'SERTIFIKAT\nKOMPETENSI\nMODUL',
    ribbonChallenge: 'SERTIFIKAT\nKOMPETENSI\nTANTANGAN',
    kindModule: 'SERTIFIKAT MODUL',
    kindChallenge: 'SERTIFIKAT TANTANGAN KODING',
    completionModule:
        'Atas kelulusannya pada modul pembelajaran interaktif',
    completionChallenge:
        'Atas keberhasilannya menyelesaikan tantangan pemrograman & proyek mini',
    accreditation: 'Akreditasi:',
    rewardAndDuration: 'Poin & Durasi:',
    level: 'Tingkat:',
    predicate: 'Predikat:',
    predicateValue: 'Sangat Memuaskan (100/100)',
    accreditationValue: 'Akreditasi Kompetensi RPL',
    verifyHeading: 'Verifikasi Sertifikat',
    validUntil: 'Berlaku hingga',
    instructorRole: 'Instruktur CodeLab AI',
    platformTagline: 'AI-Assisted Mobile Programming Learning Platform',
    chaptersCompleted: 'Bab yang dituntaskan:',
    criteriaHeading: 'Kriteria & Kasus Uji (Test Cases) yang Diselesaikan:',
    evalModule: 'Evaluasi pembelajaran modul:',
    evalChallenge: 'Metode verifikasi solusi koding:',
    totalEffective: 'Total Efektif:',
    durationAndScore: 'Durasi & Skor:',
    pageOf: 'Halaman 2 dari 2',
    moduleAttachment: '• Lampiran Silabus & Capaian Kompetensi Modul',
    challengeAttachment: '• Lampiran Kriteria & Hasil Uji Otomatis Tantangan',
    rulePrefix: 'Aturan',
    publicTestCase: 'Public',
    hiddenTestCase: 'Hidden',
    curriculumTag: 'Silabus Terstandarisasi',
    instructorFooter: 'CodeLab AI • Instruktur: Devwan Hidayawan',
    syllabusUnavailable: 'Silabus bab belum tersedia.',
    languageCode: 'id',
  );

  static const _en = CertificateDocLabels(
    ribbonModule: 'CERTIFICATE\nOF COMPETENCY\nMODULE',
    ribbonChallenge: 'CERTIFICATE\nOF COMPETENCY\nCHALLENGE',
    kindModule: 'MODULE CERTIFICATE',
    kindChallenge: 'CODING CHALLENGE CERTIFICATE',
    completionModule:
        'For the successful completion of the interactive learning module',
    completionChallenge:
        'For successfully solving the programming challenge & mini project',
    accreditation: 'Accreditation:',
    rewardAndDuration: 'Points & Duration:',
    level: 'Level:',
    predicate: 'Predicate:',
    predicateValue: 'With Distinction (100/100)',
    accreditationValue: 'RPL Competency Accredited',
    verifyHeading: 'Certificate Verification',
    validUntil: 'Valid until',
    instructorRole: 'CodeLab AI Instructor',
    platformTagline: 'AI-Assisted Mobile Programming Learning Platform',
    chaptersCompleted: 'Chapters completed:',
    criteriaHeading: 'Validation Rules & Automated Test Cases Passed:',
    evalModule: 'Module learning evaluation:',
    evalChallenge: 'Solution validation method:',
    totalEffective: 'Effective Hours:',
    durationAndScore: 'Duration & Score:',
    pageOf: 'Page 2 of 2',
    moduleAttachment: '• Module Syllabus & Competency Attachment',
    challengeAttachment: '• Challenge Criteria & Automated Test Attachment',
    rulePrefix: 'Rule',
    publicTestCase: 'Public',
    hiddenTestCase: 'Hidden',
    curriculumTag: 'Standard Syllabus',
    instructorFooter: 'CodeLab AI • Instructor: Devwan Hidayawan',
    syllabusUnavailable: 'The chapter syllabus is not available yet.',
    languageCode: 'en',
  );

  static const _ar = CertificateDocLabels(
    ribbonModule: 'شهادة\nكفاءة\nالمودول',
    ribbonChallenge: 'شهادة\nكفاءة\nالتحدي',
    kindModule: 'شهادة مودول',
    kindChallenge: 'شهادة تحدي البرمجة',
    completionModule: 'لإتمامه المودول التعليمي التفاعلي بنجاح',
    completionChallenge: 'لنجاحه في حل تحدي البرمجة والمشروع المصغّر',
    accreditation: 'الاعتماد:',
    rewardAndDuration: 'النقاط والمدة:',
    level: 'المستوى:',
    predicate: 'التقدير:',
    predicateValue: 'ممتاز (100/100)',
    accreditationValue: 'معتمد في كفاءة RPL',
    verifyHeading: 'التحقق من الشهادة',
    validUntil: 'صالح حتى',
    instructorRole: 'مدرب CodeLab AI',
    platformTagline: 'AI-Assisted Mobile Programming Learning Platform',
    chaptersCompleted: 'الفصول المكتملة:',
    criteriaHeading: 'المعايير وحالات الاختبار المنجزة:',
    evalModule: 'تقييم تعلّم المودول:',
    evalChallenge: 'طريقة التحقق من الحل البرمجي:',
    totalEffective: 'الإجمالي الفعلي:',
    durationAndScore: 'المدة والدرجة:',
    pageOf: 'الصفحة 2 من 2',
    moduleAttachment: '• ملحق منهج المودول والكفاءات',
    challengeAttachment: '• ملحق معايير التحدي ونتائج الاختبار الآلي',
    rulePrefix: 'القاعدة',
    publicTestCase: 'عام',
    hiddenTestCase: 'مخفي',
    curriculumTag: 'منهج معياري',
    instructorFooter: 'CodeLab AI • المدرب: Devwan Hidayawan',
    syllabusUnavailable: 'منهج الفصول غير متوفر بعد.',
    languageCode: 'ar',
  );
}
