import 'package:flutter/material.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// Modal Bottom Sheet untuk mempratinjau jenis slide latihan sebelum ditambahkan ke bab.
/// Berdasarkan acuan desain Stitch: `modal_pratinjau_tipe_slide_lengkapi_kode`.
class SlideTypePreviewSheet extends StatelessWidget {
  final String type;
  final VoidCallback onUseType;

  const SlideTypePreviewSheet({
    super.key,
    required this.type,
    required this.onUseType,
  });

  /// Helper untuk membuka modal secara mudah
  static Future<void> show(
    BuildContext context, {
    required String type,
    required VoidCallback onUseType,
  }) {
    final p = context.palette;
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: p.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => SlideTypePreviewSheet(type: type, onUseType: onUseType),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final info = _resolveTypeInfo(type);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.screen,
          right: AppSpacing.screen,
          top: AppSpacing.md,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: p.outline,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Badges row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: p.primaryContainer.withAlpha(45),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_red_eye_rounded,
                          size: 14,
                          color: p.primary,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Pratinjau Format Interaktif',
                          style: AppTypography.labelSm.copyWith(
                            color: p.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: p.surfaceAlt,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: p.outline),
                    ),
                    child: Text(
                      info.techTag,
                      style: AppTypography.codeSm.copyWith(
                        color: p.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              // Title & Subtitle
              Text(
                'Pratinjau Tipe Slide: ${info.title}',
                style: AppTypography.titleM.copyWith(
                  color: p.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                info.subtitle,
                style: AppTypography.bodySm.copyWith(color: p.textMuted),
              ),
              const SizedBox(height: AppSpacing.md),

              // Interactive Preview Sandbox Card
              _buildSandboxCard(context, info, p),
              const SizedBox(height: AppSpacing.md),

              // Pedagogical Benefits Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: p.surface,
                  borderRadius: AppRadius.cardBorder,
                  border: Border.all(color: p.outline),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: p.accent.withAlpha(35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lightbulb_rounded,
                        color: p.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manfaat Pedagogis',
                            style: AppTypography.labelL.copyWith(
                              color: p.text,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            info.pedagogicalBenefit,
                            style: AppTypography.bodySm.copyWith(
                              color: p.textMuted,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Meta row: XP recommendation + Module Type
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: p.surfaceAlt,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: p.outline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: p.accent.withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.bolt_rounded,
                              size: 16,
                              color: p.accent,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Imbalan Siswa',
                                  style: AppTypography.labelSm.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                Text(
                                  info.xpRecommendation,
                                  style: AppTypography.codeSm.copyWith(
                                    color: p.text,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: p.surfaceAlt,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: p.outline),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: p.primaryContainer.withAlpha(40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.view_in_ar_rounded,
                              size: 16,
                              color: p.primary,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tipe Modul',
                                  style: AppTypography.labelSm.copyWith(
                                    color: p.textMuted,
                                  ),
                                ),
                                Text(
                                  info.moduleCode,
                                  style: AppTypography.codeSm.copyWith(
                                    color: p.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: p.outline),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Tutup',
                        style: AppTypography.labelL.copyWith(color: p.text),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Gunakan Tipe Ini',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        onUseType();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSandboxCard(
    BuildContext context,
    _SlidePreviewData info,
    AppPalette p,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: AppRadius.cardBorder,
        border: Border.all(color: p.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sandbox Top Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: p.surfaceAlt,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: p.outline)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: p.primaryContainer.withAlpha(35),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    info.fileName,
                    style: AppTypography.codeSm.copyWith(
                      color: p.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Simulasi Siswa Aktif',
                  style: AppTypography.labelSm.copyWith(color: p.textMuted),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: p.success.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: p.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Layar Ponsel',
                        style: AppTypography.labelSm.copyWith(
                          color: p.success,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sandbox Content Body
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instruction prompt
                Text(
                  info.instructionPrompt,
                  style: AppTypography.bodySm.copyWith(
                    color: p.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Code or content sandbox container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161B27),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    info.codeSnippet,
                    style: const TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 12.5,
                      color: Color(0xFFDAE2FF),
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Choice chips or interactive simulation
                if (info.sampleChips.isNotEmpty) ...[
                  Text(
                    'Pilihan jawaban untuk siswa:',
                    style: AppTypography.labelSm.copyWith(color: p.textMuted),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: info.sampleChips.map((chip) {
                      final isSelected = chip == info.selectedChip;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? p.primary : p.surfaceAlt,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? p.primary : p.outline,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSelected) ...[
                              const Icon(
                                Icons.check_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              chip,
                              style: AppTypography.codeSm.copyWith(
                                color: isSelected ? Colors.white : p.text,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Instant feedback indicator
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: p.primaryContainer.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16,
                        color: p.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          info.feedbackNote,
                          style: AppTypography.bodySm.copyWith(
                            color: p.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _SlidePreviewData _resolveTypeInfo(String type) {
    switch (type.toUpperCase()) {
      case 'TAP_TO_FILL':
        return _SlidePreviewData(
          title: 'Lengkapi Kode',
          subtitle:
              'Simulasi bagaimana siswa berinteraksi dengan latihan ini di ponsel secara langsung.',
          techTag: 'HTML • V1.2',
          fileName: 'index.html',
          instructionPrompt: 'Lengkapi tag penutup yang tepat: Baris 4',
          codeSnippet:
              '1  <!DOCTYPE html>\n2  <html>\n3    <h1>Halo Dunia!</h1>\n4    <p>Belajar kode seru</ [ p ] >\n5  </html>',
          sampleChips: ['print', 'p', 'console.log'],
          selectedChip: 'p',
          feedbackNote:
              'Siswa mendapat umpan balik instan saat memilih kepingan kode.',
          pedagogicalBenefit:
              'Melatih penguasaan sintaksis dasar tanpa beban mengetik panjang di papan ketik layar sentuh HP.',
          xpRecommendation: '+15 XP disarankan',
          moduleCode: 'FILL_BLANK',
        );

      case 'THEORY':
        return _SlidePreviewData(
          title: 'Teori & Konsep',
          subtitle:
              'Teks bacaan terstruktur, markdown penjelasan, dan cuplikan kode contoh.',
          techTag: 'Markdown • Teori',
          fileName: 'konsep_dasar.md',
          instructionPrompt: 'Materi Pembuka & Pengenalan Logika',
          codeSnippet:
              '# Struktur Dasar HTML5\n\nDokumen HTML selalu diawali dengan deklarasi `<!DOCTYPE html>` agar browser merender dengan standar modern.',
          sampleChips: [],
          selectedChip: '',
          feedbackNote:
              'Mendukung format Markdown, syntax highlighter, dan kotak callout tips guru.',
          pedagogicalBenefit:
              'Membangun landasan pemahaman konseptual yang kuat sebelum siswa masuk ke sesi latihan interaktif.',
          xpRecommendation: '+10 XP disarankan',
          moduleCode: 'THEORY_READ',
        );

      case 'TYPE_CODE':
        return _SlidePreviewData(
          title: 'Ketik Kata Kunci',
          subtitle:
              'Latihan muscle-memory mengetikkan keyword sintaksis spesifik.',
          techTag: 'Python • Sintaks',
          fileName: 'main.py',
          instructionPrompt:
              'Ketikkan kata kunci untuk membuat fungsi di Python:',
          codeSnippet:
              '1  # Inisialisasi fungsi\n2  [ def ] hitung_luas(p, l):\n3      return p * l',
          sampleChips: ['def', 'function', 'fn'],
          selectedChip: 'def',
          feedbackNote:
              'Dilengkapi validasi case-sensitive dan hint otomatis saat siswa keliru.',
          pedagogicalBenefit:
              'Membiasakan siswa dengan penulisan sintaksis yang presisi dan melatih ketelitian pengetikan reserved-words.',
          xpRecommendation: '+15 XP disarankan',
          moduleCode: 'TYPE_KEYWORD',
        );

      case 'OUTPUT_PREDICT':
        return _SlidePreviewData(
          title: 'Tebak Output Kode',
          subtitle:
              'Siswa menganalisis baris program dan memprediksi hasil running terminal.',
          techTag: 'Console • Logika',
          fileName: 'script.py',
          instructionPrompt:
              'Apakah output yang dicetak oleh operasi modulus berikut?',
          codeSnippet:
              '1  x = 17\n2  y = 5\n3  hasil = x % y\n4  print("Sisa bagi:", hasil)',
          sampleChips: [
            '\$ Sisa bagi: 2',
            '\$ Sisa bagi: 3.4',
            '\$ Error: float',
          ],
          selectedChip: '\$ Sisa bagi: 2',
          feedbackNote:
              'Tampilan opsi bergaya konsol terminal gelap untuk simulasi nyata.',
          pedagogicalBenefit:
              'Melatih kemampuan mental execution algoritma dan tracing variabel tanpa ketergantungan debugger.',
          xpRecommendation: '+20 XP disarankan',
          moduleCode: 'PREDICT_OUTPUT',
        );

      case 'BUG_HUNTER':
        return _SlidePreviewData(
          title: 'Bug Hunter (Cari Galat)',
          subtitle:
              'Tantangan menemukan baris kode yang rusak dan memperbaikinya.',
          techTag: 'Python • Debug',
          fileName: 'loop_detector.py',
          instructionPrompt:
              'Temukan baris yang mengandung kesalahan sintaksis:',
          codeSnippet:
              '1  # Loop angka genap\n2  total = 0\n3  angka = [2, 4, 6]\n4  for i in angka     [🔴 Target Bug: Kurang titik dua (:)]\n5      total += i',
          sampleChips: ['Baris 2', 'Baris 4', 'Baris 5'],
          selectedChip: 'Baris 4',
          feedbackNote:
              'Siswa mengetuk nomor baris yang bermasalah untuk memicu bimbingan AI.',
          pedagogicalBenefit:
              'Mengasah intuisi problem-solving dan kemampuan membaca kode orang lain yang merupakan inti skill developer.',
          xpRecommendation: '+25 XP disarankan',
          moduleCode: 'BUG_HUNTER',
        );

      case 'QUIZ':
        return _SlidePreviewData(
          title: 'Kuis Pilihan Ganda',
          subtitle:
              'Pertanyaan evaluasi pemahaman dengan 4 opsi pilihan dan pembahasan.',
          techTag: 'Evaluasi • Konsep',
          fileName: 'kuis_evaluasi.json',
          instructionPrompt: 'Apa fungsi utama dari deklarasi <!DOCTYPE html>?',
          codeSnippet:
              'A. [ ✓ Kunci ] Memberitahu browser standar dokumen\nB. Mengatur warna background default halaman\nC. Menyambungkan dokumen dengan server backend\nD. Mempercepat rendering gambar responsif',
          sampleChips: ['Opsi A', 'Opsi B', 'Opsi C', 'Opsi D'],
          selectedChip: 'Opsi A',
          feedbackNote:
              'Dilengkapi pembahasan otomatis yang tampil setelah siswa menjawab.',
          pedagogicalBenefit:
              'Mengukur daya serap materi secara obyektif dan cepat di akhir sesi pembahasan.',
          xpRecommendation: '+10 XP disarankan',
          moduleCode: 'MULTIPLE_CHOICE',
        );

      case 'OUTRO':
      default:
        return _SlidePreviewData(
          title: 'Rangkuman & Klaim XP',
          subtitle:
              'Slide penutup bab dengan rekap materi yang dikuasai dan klaim hadiah.',
          techTag: 'Pencapaian • Penutup',
          fileName: 'rekap_bab.summary',
          instructionPrompt:
              'Selamat! Kamu telah menyelesaikan seluruh latihan di bab ini.',
          codeSnippet:
              '🏆 Status: 100% Tuntas\n⚡ Total XP Didapat: +50 XP\n✨ Level Up: Pemula -> Menengah',
          sampleChips: [],
          selectedChip: '',
          feedbackNote: 'Otomatis dibuat di akhir alur pembelajaran bab.',
          pedagogicalBenefit:
              'Memberikan kepuasan pencapaian (gamification) dan merangkum poin-poin penting materi.',
          xpRecommendation: '+50 XP (Total)',
          moduleCode: 'CHAPTER_OUTRO',
        );
    }
  }
}

class _SlidePreviewData {
  final String title;
  final String subtitle;
  final String techTag;
  final String fileName;
  final String instructionPrompt;
  final String codeSnippet;
  final List<String> sampleChips;
  final String selectedChip;
  final String feedbackNote;
  final String pedagogicalBenefit;
  final String xpRecommendation;
  final String moduleCode;

  _SlidePreviewData({
    required this.title,
    required this.subtitle,
    required this.techTag,
    required this.fileName,
    required this.instructionPrompt,
    required this.codeSnippet,
    required this.sampleChips,
    required this.selectedChip,
    required this.feedbackNote,
    required this.pedagogicalBenefit,
    required this.xpRecommendation,
    required this.moduleCode,
  });
}
