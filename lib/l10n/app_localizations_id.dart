// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get navLearn => 'Belajar';

  @override
  String get navChallenges => 'Tantangan';

  @override
  String get navPlayground => 'Playground';

  @override
  String get navProfile => 'Profil';

  @override
  String get actionCancel => 'Batal';

  @override
  String get actionClose => 'Tutup';

  @override
  String get actionRetry => 'Coba Lagi';

  @override
  String get actionDelete => 'Hapus';

  @override
  String get actionBack => 'Kembali';

  @override
  String get actionSend => 'Kirim';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsAccountTag => 'PENGATURAN AKUN';

  @override
  String get settingsRoleTeacher => 'Guru / Pengajar';

  @override
  String get settingsRoleStudent => 'Siswa RPL • Tingkat Pemula';

  @override
  String get settingsChangePhoto => 'Ganti Foto';

  @override
  String get settingsEditModeHint =>
      'Mode edit aktif — ubah datamu, lalu tekan \"Simpan Perubahan\".';

  @override
  String get settingsFieldFullName => 'Nama Lengkap';

  @override
  String get settingsFieldFullNameAside => 'Maks 40 karakter';

  @override
  String get settingsFullNameEmpty => 'Nama tidak boleh kosong';

  @override
  String get settingsFieldNisn => 'NISN / ID Siswa';

  @override
  String get settingsBadgeVerifiedDapodik => 'Terverifikasi Dapodik';

  @override
  String get settingsFieldSchool => 'Nama Sekolah / Institusi';

  @override
  String get settingsFieldClass => 'Kelas & Jurusan';

  @override
  String get settingsFieldAddress => 'Alamat';

  @override
  String get settingsFieldStaffCode => 'Kode Kepegawaian (NIP/NIK)';

  @override
  String get settingsFieldAffiliatedSchool => 'Sekolah Terafiliasi';

  @override
  String get settingsBadgeVerified => 'Terverifikasi';

  @override
  String get settingsFieldPhone => 'Nomor Handphone / WhatsApp';

  @override
  String get settingsPhoneIncomplete =>
      'Nomor belum lengkap. Contoh: 81234567890';

  @override
  String get settingsPhoneHelper =>
      'Tulis tanpa 0 di depan, contoh: 81234567890';

  @override
  String get settingsFieldTeacherEmail => 'Email Pengajar';

  @override
  String get settingsFieldStudentEmail => 'Email Akun Belajar';

  @override
  String get settingsEmailAside => 'Wajib @smk.belajar.id';

  @override
  String get settingsFieldTeacherBio => 'Bio / Catatan Pengajar';

  @override
  String get settingsFieldStudentBio => 'Bio / Catatan Belajar';

  @override
  String get settingsFieldBioAside => 'Maks 120 karakter';

  @override
  String get settingsSaveChanges => 'Simpan Perubahan';

  @override
  String get settingsCancelEdit => 'Batalkan';

  @override
  String get settingsEditData => 'Edit Data';

  @override
  String get settingsPreferencesHeader => 'PREFERENSI APLIKASI';

  @override
  String get settingsLanguage => 'Bahasa Aplikasi';

  @override
  String get settingsLanguageSubtitle => 'Indonesia, English, atau العربية';

  @override
  String get settingsDarkMode => 'Mode Gelap';

  @override
  String get settingsDarkModeSubtitle =>
      'Tema gelap untuk mata yang lebih nyaman';

  @override
  String get settingsThemeMode => 'Tema Tampilan';

  @override
  String get settingsThemeModeSubtitle =>
      'Pilih terang, gelap, atau ikuti pengaturan HP';

  @override
  String get settingsThemeLight => 'Terang';

  @override
  String get settingsThemeDark => 'Gelap';

  @override
  String get settingsThemeSystem => 'Ikuti Sistem';

  @override
  String get settingsNotifications => 'Notifikasi';

  @override
  String get settingsNotificationsSubtitle =>
      'Kabar penting tanpa perlu membuka aplikasi';

  @override
  String get settingsNotifySummaryAllOn => 'Semua jenis aktif';

  @override
  String get settingsNotifySummaryOff => 'Nonaktif';

  @override
  String settingsNotifySummaryPartial(int count) {
    return '$count dari 5 jenis aktif';
  }

  @override
  String get settingsNotificationsMaster => 'Aktifkan Notifikasi';

  @override
  String get settingsNotificationsMasterSubtitle =>
      'Matikan untuk berhenti menerima semua notifikasi';

  @override
  String get settingsNotifyCertificate => 'Sertifikat Terbit';

  @override
  String get settingsNotifyCertificateSubtitle =>
      'Saat modul tuntas atau tantangan lulus';

  @override
  String get settingsNotifyDownload => 'Unduhan Sertifikat';

  @override
  String get settingsNotifyDownloadSubtitle =>
      'Saat e-Sertifikat PDF selesai diunduh';

  @override
  String get settingsNotifyReminder => 'Pengingat Belajar';

  @override
  String get settingsNotifyReminderSubtitle =>
      'Pengingat harian dan kuota AI Tutor kembali penuh';

  @override
  String get settingsNotifyMaterial => 'Modul Baru';

  @override
  String get settingsNotifyMaterialSubtitle =>
      'Saat pengajar menerbitkan modul atau bab baru';

  @override
  String get settingsNotifySession => 'Keamanan Sesi';

  @override
  String get settingsNotifySessionSubtitle =>
      'Saat akun dipakai masuk di perangkat lain';

  @override
  String get settingsNotifyTest => 'Kirim Notifikasi Uji Coba';

  @override
  String get settingsNotifyTestSubtitle =>
      'Pastikan notifikasi tampil di perangkat ini';

  @override
  String get settingsNotifyTestSent => 'Notifikasi uji coba dikirim.';

  @override
  String get settingsNotifyTestFailed =>
      'Notifikasi belum bisa dikirim. Periksa izin notifikasi aplikasi ini.';

  @override
  String get settingsNotifyPermissionDenied =>
      'Izin notifikasi ditolak. Aktifkan lewat pengaturan HP.';

  @override
  String get notifCertificateTitle => 'Sertifikat Kompetensi Terbit';

  @override
  String notifCertificateBody(String topic) {
    return '$topic sudah tuntas. Sertifikatmu siap diunduh.';
  }

  @override
  String get notifChallengeTitle => 'Sertifikat Tantangan Terbit';

  @override
  String notifChallengeBody(String title) {
    return '$title lulus 100/100. Sertifikat tantanganmu siap diunduh.';
  }

  @override
  String get notifDownloadTitle => 'Sertifikat Berhasil Diunduh';

  @override
  String notifDownloadBody(String certId) {
    return 'Berkas PDF $certId tersimpan di perangkat.';
  }

  @override
  String get notifReminderTitle => 'Waktunya Belajar';

  @override
  String get notifReminderBody =>
      'Kuota AI Tutor 5/5 sudah kembali penuh hari ini.';

  @override
  String get notifMaterialTitle => 'Modul Baru dari Pengajarmu';

  @override
  String notifMaterialBody(String title) {
    return '$title baru diterbitkan. Buka katalog untuk melihatnya.';
  }

  @override
  String get notifSessionTitle => 'Sesi Akun Diakhiri';

  @override
  String get notifSessionBody =>
      'Akunmu dipakai masuk di perangkat lain. Masuk kembali untuk melanjutkan.';

  @override
  String get notifTestTitle => 'Notifikasi Uji Coba';

  @override
  String get notifTestBody =>
      'Notifikasi CodeLab AI berfungsi di perangkat ini.';

  @override
  String get notifNewBadge => 'Baru';

  @override
  String get offlineBannerTitle =>
      'Kamu sedang luring. Periksa koneksi internetmu.';

  @override
  String get materialSearchContentTitle => 'Cocok di dalam materi';

  @override
  String get materialSearchContentNoSnippet =>
      'Kata ini muncul di dalam materi.';

  @override
  String get settingsSfx => 'Efek Suara Aplikasi';

  @override
  String get settingsSfxSubtitle => 'Suara popup, notifikasi, dan kuis';

  @override
  String get settingsLabSfx => 'Efek Suara Lab';

  @override
  String get settingsLabSfxSubtitle => 'Audio saat eksekusi kode & terminal';

  @override
  String get settingsAccountLabHeader => 'PENGATURAN AKUN & LAB';

  @override
  String get settingsHelpCenter => 'Bantuan Admin';

  @override
  String get settingsHelpCenterSubtitle =>
      'Hubungi admin via WhatsApp +62 831-2500-5309';

  @override
  String get settingsHelpLaunchFailed =>
      'Tidak bisa membuka WhatsApp. Coba lagi.';

  @override
  String get settingsChangePassword => 'Ubah Password';

  @override
  String get settingsChangePasswordSubtitle =>
      'Kata sandi lama & baru dengan checklist keamanan';

  @override
  String get settingsChangePasswordSheetSubtitle =>
      'Aturan sandi sama seperti saat kamu mendaftar akun.';

  @override
  String get settingsLogout => 'Keluar Akun (Log Out)';

  @override
  String get settingsLogoutTitle => 'Keluar dari Akun?';

  @override
  String get settingsLogoutBody =>
      'Apakah kamu yakin ingin keluar dari sesi latihan lab saat ini?';

  @override
  String get settingsLogoutConfirm => 'Ya, Keluar';

  @override
  String get settingsAvatarDeleteTitle => 'Hapus Foto Profil?';

  @override
  String get settingsAvatarDeleteBody =>
      'Foto akan dihapus dari akunmu. Kamu bisa mengunggah foto baru kapan saja.';

  @override
  String get settingsAvatarMaxSize => 'Ukuran foto maksimal 2 MB.';

  @override
  String get settingsAvatarUpdated => 'Foto profil berhasil diperbarui.';

  @override
  String get settingsAvatarDeleted => 'Foto profil dihapus.';

  @override
  String get settingsAvatarProcessFailed =>
      'Foto profil gagal diproses. Periksa izin galeri dan koneksi, lalu coba lagi.';

  @override
  String get settingsAvatarDeleteFailed =>
      'Foto profil gagal dihapus. Periksa koneksi lalu coba lagi.';

  @override
  String get settingsProfileSaved => 'Perubahan profil berhasil disimpan!';

  @override
  String get settingsProfileSaveFailed => 'Gagal menyimpan profil. Coba lagi.';

  @override
  String get settingsLanguageSheetTitle => 'Bahasa Aplikasi';

  @override
  String get settingsLanguageSheetSubtitle =>
      'Berlaku untuk seluruh layar CodeLab AI';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get playgroundReset => 'Reset';

  @override
  String get playgroundRun => 'Jalankan';

  @override
  String get playgroundRunning => 'Menjalankan…';

  @override
  String get playgroundTerminal => 'Terminal';

  @override
  String get playgroundClearTerminal => 'Bersihkan terminal';

  @override
  String get playgroundOpenTerminal => 'Buka terminal';

  @override
  String get playgroundCloseTerminal => 'Tutup terminal';

  @override
  String get playgroundEmptyDone => '(Program selesai tanpa output)';

  @override
  String get playgroundEmptyIdle => 'Tekan \'Jalankan\' untuk melihat output';

  @override
  String get playgroundInputHint => 'ketik jawaban…';

  @override
  String playgroundStatusDone(Object ms) {
    return 'Selesai (${ms}ms)';
  }

  @override
  String playgroundStatusError(Object ms) {
    return 'Error (${ms}ms)';
  }

  @override
  String get sandboxTooltip => 'Apa yang belum bisa dilakukan di sandbox?';

  @override
  String get sandboxSheetTitle => 'Batas Python Sandbox';

  @override
  String get sandboxSheetSubtitle => 'Pesan guru sebelum kamu mulai';

  @override
  String get sandboxLimitJudgeTitle =>
      'Penilai Playground berbeda dari penilai tantangan';

  @override
  String get sandboxLimitJudgeBody =>
      'Playground berjalan di HP-mu, sedangkan tantangan dinilai server dengan Python penuh. Kode yang berjalan di sini bisa saja berbeda hasilnya saat dikumpulkan. Kalau itu terjadi, percayai hasil di halaman tantangan — itulah nilai resminya.';

  @override
  String get sandboxIntro =>
      'Anak-anak, sebelum mulai mencoba, dengarkan pesan gurumu dulu. Python Sandbox ini ruang latihan yang sengaja dibatasi, bukan Python penuh. Supaya kamu tidak bingung ketika ada yang gagal, ini hal yang belum bisa dilakukan di sini:';

  @override
  String get sandboxLimitImportTitle => 'Memanggil modul dengan import';

  @override
  String get sandboxLimitImportBody =>
      'Perintah import belum ada di sandbox ini. Jadi library seperti random, math, datetime, atau paket dari internet belum bisa dipakai.';

  @override
  String get sandboxLimitFileTitle => 'Membuka file dan menyambung ke luar';

  @override
  String get sandboxLimitFileBody =>
      'Membuka atau menyimpan file, mengakses internet, dan memerintah sistem operasi belum diizinkan. Semua yang kamu tulis berjalan di dalam aplikasi saja.';

  @override
  String get sandboxLimitGuiTitle =>
      'Membuat tampilan grafis, gambar, atau suara';

  @override
  String get sandboxLimitGuiBody =>
      'tkinter, pygame, dan sejenisnya belum tersedia. Di sini kita berlatih logika program, bukan membuat jendela atau permainan yang bergerak sendiri.';

  @override
  String get sandboxLimitOopTitle => 'Memakai class, dict, dan try/except';

  @override
  String get sandboxLimitOopBody =>
      'Tiga modul itu belum ada di mesin latihan ini. Untuk sekarang, fokus dulu ke variabel, percabangan, perulangan, list, dan fungsi.';

  @override
  String get sandboxLimitLimitsTitle =>
      'Menjalankan program yang terlalu berat';

  @override
  String get sandboxLimitLimitsBody =>
      'Program otomatis dihentikan setelah 100.000 langkah atau 5 detik, dan rekursi dibatasi 200 tingkat. Kalau kena batas ini, periksa lagi perulanganmu — biasanya ada yang tidak pernah berhenti.';

  @override
  String get sandboxClosing =>
      'Kalau ada error padahal kodemu terasa benar, cek dulu apakah yang kamu pakai termasuk daftar di atas. Kalau masih bingung, tanyakan ke gurumu di kelas — kamu tidak perlu menyelesaikannya sendirian.';

  @override
  String get dashTitle => 'Dashboard';

  @override
  String get dashLoadingTitle => 'Menyiapkan dashboard';

  @override
  String get dashLoadingSubtitle => 'Menarik data belajar dari server';

  @override
  String get dashStageConnecting => 'Menyambung ke server…';

  @override
  String get dashStageProfile => 'Profil siswa terbaca';

  @override
  String get dashStageProgress => 'Kemajuan bab terbaca';

  @override
  String get dashStageSkills => 'Radar skill terbaca';

  @override
  String get dashStageLessons => 'Katalog modul terbaca';

  @override
  String get dashStageChallenges => 'Catatan tantangan terbaca';

  @override
  String get dashStageComposing => 'Menyusun dashboard…';

  @override
  String dashGreeting(String name) {
    return 'Halo, $name';
  }

  @override
  String get dashNoModules => 'Belum ada modul. Cek lagi sebentar.';

  @override
  String get dashQuickTipTitle => 'Trik Cepat Python';

  @override
  String get dashQuickTipSubtitle =>
      'Gunakan elif untuk evaluasi multi-kondisi';

  @override
  String get dashQuickTipBody =>
      'Gunakan konstruksi elif untuk mengevaluasi beberapa kondisi berurutan secara bersih:\n\nif skor >= 90:\n    hasil = \"A\"\nelif skor >= 75:\n    hasil = \"B\"\nelse:\n    hasil = \"C\"\n\nDengan elif, evaluasi berhenti begitu kondisi pertama terpenuhi tanpa if bertingkat.';

  @override
  String get dashQuickTipButton => 'Paham, Lanjutkan Belajar!';

  @override
  String get dashErrorTitle => 'Ada kendala di sisi kami. Coba lagi sebentar.';

  @override
  String get dashRetryButton => 'Coba lagi';

  @override
  String dashChallengesCompleted(int count) {
    return '$count tantangan selesai';
  }

  @override
  String get dashModuleLocked => 'Modul ini masih terkunci.';

  @override
  String get dashDefaultTopic => 'Python Dasar & Logika';

  @override
  String get dashDefaultChapter => '1. Pengenalan Logika Koding';

  @override
  String dashBabOf(int current, int total) {
    return 'Bab $current dari $total';
  }

  @override
  String dashPercentDone(int percent) {
    return '$percent% Selesai';
  }

  @override
  String get dashCompetencyTitle => 'Kompetensimu';

  @override
  String get dashCompetencyEmpty =>
      'Selesaikan satu tantangan, nanti kompetensimu muncul di sini.';

  @override
  String get actionSeeDetail => 'Lihat detail';

  @override
  String get moduleStatusCompleted => 'Selesai';

  @override
  String get moduleStatusActive => 'Sedang dipelajari';

  @override
  String get moduleStatusAvailable => 'Bisa dikerjakan';

  @override
  String get moduleStatusLocked => 'Terkunci';

  @override
  String get roadmapTitle => 'Peta Petualangan Belajar';

  @override
  String roadmapStopsToCertificate(int count) {
    return '$count Pos Menuju Sertifikat';
  }

  @override
  String roadmapActiveBab(int step) {
    return 'Bab $step Aktif';
  }

  @override
  String get roadmapCatalogTitle => 'Katalog Modul';

  @override
  String get roadmapCatalogSubtitle => 'Telusuri bab dari seluruh modul';

  @override
  String get roadmapStartHere => 'Mulai di sini! 🚀';

  @override
  String get roadmapInProgress => 'Sedang Berjalan';

  @override
  String get roadmapPracticeCount => '6 Latihan';

  @override
  String roadmapBabLine(int order, String label) {
    return 'Bab $order • $label';
  }

  @override
  String get roadmapQuizNode => 'Uji Pemahaman';

  @override
  String get roadmapAvailableNow => 'Bisa langsung dikerjakan';

  @override
  String get roadmapCertificate => 'Sertifikat Modul';

  @override
  String get roadmapGraduationTarget => 'Target Kelulusan';

  @override
  String get levelBeginner => 'Pemula';

  @override
  String get levelIntermediate => 'Menengah';

  @override
  String get levelAdvanced => 'Mahir';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterTodo => 'Belum Selesai';

  @override
  String get filterDone => 'Selesai';

  @override
  String get filterMiniProject => 'Mini Proyek';

  @override
  String get actionApply => 'Terapkan';

  @override
  String get appDefaultStudentName => 'Siswa SMK';

  @override
  String get challengeFilterTitle => 'Filter Tantangan';

  @override
  String get challengeLevelSection => 'Tingkat kesulitan';

  @override
  String get challengeLockedTitle => 'Tantangan Terkunci';

  @override
  String challengeLockedBody(int xp, int userXp) {
    return 'Syarat: Butuh minimal $xp XP untuk membuka tantangan ini. Saat ini kamu memiliki $userXp XP.';
  }

  @override
  String get challengeLearningPath => 'Jalur Belajar';

  @override
  String get challengeCatalogTitle => 'Katalog Tantangan';

  @override
  String get challengeCatalogSubtitle =>
      'Asah logika algoritma & koding bertahap';

  @override
  String get challengeFilter => 'Filter';

  @override
  String get challengeFilterActive => 'Filter • 1';

  @override
  String challengeFilterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get challengeSearchHint => 'Cari topik, fungsi, atau algoritma...';

  @override
  String get challengeClearSearch => 'Hapus pencarian';

  @override
  String get challengeSearchTooltip => 'Cari tantangan';

  @override
  String get challengeNoMatch =>
      'Tidak ada tantangan yang cocok. Coba ubah kata kunci atau filter.';

  @override
  String challengeGroupDone(int done, int total) {
    return '$done / $total Selesai';
  }

  @override
  String challengeGroupUnlocked(int unlocked, int total) {
    return '$unlocked / $total Dibuka';
  }

  @override
  String challengeSummaryDone(int done, int total) {
    return '$done dari $total Selesai';
  }

  @override
  String get challengeSummarySubtitle => 'Kemahiran Kurikulum Algoritma RPL';

  @override
  String challengeXpEarned(int xp) {
    return '+$xp XP Didapat';
  }

  @override
  String get challengeStatusInProgress => 'Sedang Dicoba';

  @override
  String get challengeMiniProjectHeader => 'MINI-PROYEK TERAPAN';

  @override
  String get challengeMiniProjectSubtitle =>
      'Praktik implementasi logika komprehensif khas SMK RPL';

  @override
  String get challengeOpen => 'Terbuka';

  @override
  String challengeMinutes(int count) {
    return '$count Menit';
  }

  @override
  String challengeXpRequired(int xp) {
    return 'Butuh $xp XP';
  }

  @override
  String challengeXpRequirement(int xp) {
    return 'Syarat: Butuh $xp XP';
  }

  @override
  String challengeTestCount(int count) {
    return '$count Unit Test';
  }

  @override
  String get challengeDetailTitle => 'Tantangan Koding';

  @override
  String get challengeHistoryTooltip => 'Riwayat submisi';

  @override
  String challengeLevelLine(String level) {
    return 'Tingkat: $level';
  }

  @override
  String challengeXpPlus(int xp) {
    return '+$xp XP';
  }

  @override
  String challengeMinutesShort(int count) {
    return '~$count mnt';
  }

  @override
  String get challengeTaskInstruction => 'Instruksi Tugas';

  @override
  String get challengeSampleCalls => 'CONTOH PEMANGGILAN';

  @override
  String get challengeTabInstruction => 'Instruksi & Uji';

  @override
  String get challengeTabSolution => 'Solusi Kodemu';

  @override
  String get challengeFormatPep8 => 'Format PEP8';

  @override
  String get challengeFormatDone => 'Format PEP8 berhasil dirapikan';

  @override
  String get challengeResetCode => 'Reset Kode';

  @override
  String get challengeAiHelpTitle => 'Butuh Bantuan AI?';

  @override
  String get challengeAiHelpSubtitle =>
      'Dapatkan petunjuk bertahap tanpa spoiler kode';

  @override
  String challengeQuotaLabel(int used, int total) {
    return '$used/$total Kuota';
  }

  @override
  String get challengeAskHint => 'Minta Hint';

  @override
  String get challengeRunFailed =>
      'Ada kendala saat eksekusi kode. Coba lagi sebentar.';

  @override
  String get challengeSubmitFailed =>
      'Gagal mengirim submisi. Coba lagi sebentar.';

  @override
  String get challengeTestResultTitle => 'Hasil Pengujian Otomatis';

  @override
  String get challengeTestResultCompletedTitle =>
      'Hasil Pengujian Otomatis — Selesai';

  @override
  String challengePassedCount(int passed, int total) {
    return '$passed/$total Lolos';
  }

  @override
  String challengeExecutionTime(int ms) {
    return 'Eksekusi: ${ms}ms';
  }

  @override
  String get challengePassed => 'Lolos';

  @override
  String get challengeFailed => 'Gagal';

  @override
  String challengeCaseDetail(String input, String expected, String output) {
    return 'Input: $input • Ekspektasi: $expected • Output: $output';
  }

  @override
  String get challengeScaffoldingLevels => 'Scaffolding 3 Level';

  @override
  String get challengeLogicHintLabel => 'Petunjuk Logika: ';

  @override
  String get challengeAllTestsPassed =>
      'Mantap! Seluruh uji coba lolos. Tekan tombol Kirim Solusi di bawah untuk klaim XP-mu!';

  @override
  String challengeCasesNotPassed(int count) {
    return '$count kasus belum lolos dari pengujian otomatis. Minta arahan AI Tutor di bawah — petunjuknya memandu kodemu, bukan jawaban jadi.';
  }

  @override
  String get challengeAskAiTutor => 'Tanya AI Tutor';

  @override
  String get challengeCompletedBody =>
      'Tantangan ini sudah kamu tuntaskan. Detail per-kasus hanya tampil di sesi bersama submisi berjalan; skor terbaik tercatat resmi di server:';

  @override
  String challengeBestScore(int score) {
    return 'Skor terbaik: $score%';
  }

  @override
  String get challengeViewHistory => 'Lihat riwayat submisi';

  @override
  String get challengeTryRun => 'Uji Coba';

  @override
  String get challengeSubmitSolution => 'Kirim Solusi';

  @override
  String get challengeEvaluationTitle => 'Evaluasi Proyek';

  @override
  String get evalSolutionAccepted => 'Solusi Diterima!';

  @override
  String get evalSolutionNotYet => 'Solusi Belum Berhasil';

  @override
  String get evalAllPassedBody =>
      'Seluruh pengujian publik dan tersembunyi berhasil dilewati tanpa kendala.';

  @override
  String evalSomeFailedBody(int passed, int total) {
    return 'Jangan patah semangat! $passed dari $total pengujian berhasil. Mari kita telaah kesalahan dan perbaiki bersama AI Tutor.';
  }

  @override
  String get evalMetricFinalScore => 'NILAI AKHIR';

  @override
  String get evalBadgePerfect => 'Sempurna';

  @override
  String get evalBadgeNeedsImprovement => 'Perlu Perbaikan';

  @override
  String get evalMetricExecution => 'EKSEKUSI';

  @override
  String get evalSecondsSuffix => ' dtk';

  @override
  String get evalBadgeFast => 'Cepat';

  @override
  String get evalTestResultsHeader => 'HASIL PENGUJIAN OTOMATIS';

  @override
  String get evalCompetencyTitle => 'Kompetensi Logika & Algoritma';

  @override
  String get evalPointsPlus => '+5 Poin';

  @override
  String get evalCompetencySubtitle =>
      'Bukti empiris tercatat otomatis pada portofolio SMK-mu.';

  @override
  String get evalCooldownTitle => 'Cooldown Submisi Compiler';

  @override
  String get evalCooldownPrefix => 'Tunggu ';

  @override
  String get evalCooldownSuffix =>
      ' detik sebelum dapat mengirim submisi berikutnya untuk stabilitas sandbox container.';

  @override
  String get evalCooldownReady => 'Compiler siap menerima submisi kode baru.';

  @override
  String get evalNextChallenge => 'Lanjut ke Tantangan Berikutnya';

  @override
  String get evalFixSolution => 'Perbaiki Solusi Koding';

  @override
  String get evalHiddenBadge => 'Hidden';

  @override
  String get historyTitle => 'Riwayat Submisi';

  @override
  String get historyStatusPassed => 'Lulus';

  @override
  String get historyStatusError => 'Error';

  @override
  String get historyBestScore => 'Skor Tertinggi';

  @override
  String historyAttemptsCount(int count) {
    return '$count Percobaan Dikirim';
  }

  @override
  String get historySubmissionsHeader => 'Riwayat Pengiriman';

  @override
  String get historySortedByTime => 'Terurut Waktu';

  @override
  String get historyOpenPlayground => 'Buka di Playground';

  @override
  String get historyBackToChallenge => 'Kembali ke Soal';

  @override
  String historySubmissionNumber(int number) {
    return 'Submisi #$number';
  }

  @override
  String historyScoreInline(int score) {
    return '  •  Skor $score/100';
  }

  @override
  String historyHintsUsed(int count) {
    return '$count Hint AI digunakan';
  }

  @override
  String historySubmissionCode(int number) {
    return 'Kode Submisi #$number (Python)';
  }

  @override
  String get historyAiReview => 'Ulasan AI Tutor';

  @override
  String get tutorSubtitle => 'Scaffolding & Pendamping Belajar';

  @override
  String get tutorQuotaToastExhausted =>
      'Kuota hint hari ini habis. Coba lagi besok.';

  @override
  String get tutorQuotaToastExhaustedDetail =>
      'Kuota petunjuk hari ini sudah habis. Coba lagi besok untuk berlatih mandiri.';

  @override
  String get tutorHintFailed => 'Petunjuk gagal disiapkan. Coba lagi sebentar.';

  @override
  String get tutorHintOffline =>
      'Server petunjuk sedang tidak dapat dihubungi — menampilkan petunjuk bawaan.';

  @override
  String tutorConceptLabel(String concept) {
    return 'Konsep: $concept';
  }

  @override
  String tutorLevelLabel(int unlocked, int total) {
    return 'Level $unlocked/$total';
  }

  @override
  String get tutorQuotaRemaining => 'Sisa kuota';

  @override
  String get tutorScaffoldingTitle => 'Scaffolding Bertahap';

  @override
  String get tutorSocraticMethod => 'Metode Sokratik';

  @override
  String get tutorPromptQuestion => 'PERTANYAAN PEMANTIK:';

  @override
  String get tutorPreparingHint => 'Menyiapkan petunjuk untuk tantangan ini…';

  @override
  String get tutorQuotaBlockedBody =>
      'Kuota hint hari ini sudah habis (5x per hari). Petunjuk spesifik untuk tantangan ini terbuka lagi besok — sementara ini, tuntaskan di kodemu dulu.';

  @override
  String get tutorThinkingFlow => 'REKOMENDASI ALUR BERPIKIR';

  @override
  String get tutorPreparingShort => 'Menyiapkan petunjuk…';

  @override
  String tutorUnlockNext(String level) {
    return 'Buka Hint Berikutnya ($level)';
  }

  @override
  String get tutorQuotaExhaustedBody =>
      'Kuota petunjuk harian sudah habis (maksimal 5x per hari sesuai PRD). Setiap beristirahat akan reset besok — sementara ini, tuntaskan di kodemu dulu.';

  @override
  String get tutorAllHintsUnlocked =>
      'Semua hint sudah terbuka. Sekarang coba terapkan di kodemu.';

  @override
  String get tutorLockedSuffix => ', terkunci';

  @override
  String get materialCatalogTitle => 'Katalog Modul';

  @override
  String get materialFilterActive => 'Sedang Aktif';

  @override
  String get materialFilterNotStarted => 'Belum Dimulai';

  @override
  String get materialStatusRunning => 'Berjalan';

  @override
  String get materialLoadFailed => 'Gagal memuat katalog modul.';

  @override
  String get materialSearchHint => 'Cari modul atau deskripsinya…';

  @override
  String get materialClearSearch => 'Hapus pencarian';

  @override
  String get materialNoMatch =>
      'Tidak ada modul yang cocok dengan pencarian atau filter.';

  @override
  String materialSwitchedSnack(String topic) {
    return 'Menampilkan modul $topic. Peta belajar diperbarui.';
  }

  @override
  String materialChaptersDone(int done, int total) {
    return '$done/$total bab tuntas';
  }

  @override
  String get readerPreviewDone =>
      'Pratinjau Siswa Selesai! Semua slide berhasil dievaluasi.';

  @override
  String readerXpEarned(int xp) {
    return 'Selamat! Kamu memperoleh +$xp XP! 🎉';
  }

  @override
  String get readerXpAlreadyDone =>
      'Bab sudah pernah dituntaskan — XP tidak dihitung dua kali.';

  @override
  String get readerExitTitle => 'Keluar dari Latihan?';

  @override
  String get readerExitBody =>
      'Progres slide terakhirmu akan tersimpan secara otomatis.';

  @override
  String get readerExitStay => 'Lanjut Belajar';

  @override
  String get readerExitConfirm => 'Keluar';

  @override
  String get readerLoadFailed => 'Gagal memuat modul bab.';

  @override
  String get readerTeacherPreviewBanner =>
      'MODE PRATINJAU GURU (Data tidak disimpan)';

  @override
  String get readerContinue => 'Paham, Lanjutkan';

  @override
  String get readerFinishSave => 'Selesai & Simpan Progres';

  @override
  String get readerCheckAnswer => 'Periksa Jawaban';

  @override
  String get slideBadgeValidated => 'Langkah Tervalidasi';

  @override
  String get slideProgressSaved => 'Progres Tersimpan';

  @override
  String get slideWhyCorrect => 'Mengapa Jawabanmu Benar?';

  @override
  String get slideNextSlide => 'Lanjut ke Slide Berikutnya';

  @override
  String get slideSyntaxEvaluation => 'Evaluasi Sintaksis';

  @override
  String get slideZeroXpTryAgain => '0 XP • Semangat Coba Lagi';

  @override
  String get slideErrorEncouragement =>
      'Jangan khawatir, kesalahan kecil adalah bagian alami dari proses belajar koding.';

  @override
  String get slideSkipArrow => 'Lewati Slide →';

  @override
  String get slideWhereIsMistake => 'Di Mana Letak Kesalahannya?';

  @override
  String get slideBadgeTheory => 'Teori & Konsep';

  @override
  String get slideTheoryTip =>
      'Pahami konsep di atas dengan seksama sebelum melanjutkan ke latihan interaktif.';

  @override
  String get slideBadgeArrangeSyntax => 'Susun Sintaks';

  @override
  String get slideTapToFillInstruction =>
      'Ketuk balok kode di bawah untuk mengisi slot kosong yang sesuai:';

  @override
  String get slideWordBank => 'Bank Balok Kata:';

  @override
  String get slideBadgeTypeCode => 'Ketik Kode';

  @override
  String get slideHint => 'Petunjuk';

  @override
  String get slideTypeHere => 'ketik di sini...';

  @override
  String get slideBadgeGuessOutput => 'Tebak Output';

  @override
  String get slideBadgeBugHunter => 'Bug Hunter';

  @override
  String get slideBugHunterInstruction =>
      'Ketuk baris yang menurutmu mengandung galat penulisan di atas.';

  @override
  String get slideBadgeConceptQuiz => 'Kuis Konsep';

  @override
  String get slideOutroXpReward => 'Hadiah XP';

  @override
  String get slideOutroAccuracy => 'Akurasi';

  @override
  String get slideOutroLearningTime => 'Waktu Belajar';

  @override
  String get slideOutroMasteredConcepts => 'Konsep yang Kamu Kuasai';

  @override
  String get profileTitle => 'Profil & Kompetensi';

  @override
  String get profileSettingsTooltip => 'Pengaturan Profil';

  @override
  String get profileLoading => 'Memuat profil…';

  @override
  String get profileLoadFailedTitle => 'Data profil gagal dimuat';

  @override
  String get profileLoadFailedBody =>
      'Pastikan server koding lab menyala, lalu coba lagi.';

  @override
  String get profileNewStudent => 'Siswa Baru';

  @override
  String get profileAddBio => '+ Tambah Bio';

  @override
  String get profileStatChallenges => 'Tantangan';

  @override
  String get profileStatXpPoints => 'Poin XP';

  @override
  String get profileStatMaterialsDone => 'Modul Selesai';

  @override
  String get profileMasteryMapTitle => 'Peta Penguasaan Modul';

  @override
  String get profileMaterialsUnavailable =>
      'Daftar modul belum tersedia dari server. Coba lagi.';

  @override
  String get profileMaterialProgressTitle => 'Progres Modul';

  @override
  String profileChaptersInline(int done, int total) {
    return '$done/$total bab';
  }

  @override
  String get profileCurriculumUnavailable =>
      'Kurikulum belum tersedia dari server. Coba lagi.';

  @override
  String get profileCertificatesTitle => 'Sertifikat';

  @override
  String profileTracksDoneBadge(int done, int total) {
    return '$done/$total Tuntas';
  }

  @override
  String get profileChallengeCertsTitle => 'Sertifikat Tantangan';

  @override
  String get profileNoChallenges =>
      'Belum ada tantangan di katalog — coba lagi.';

  @override
  String profileBabCountInline(int done, int total) {
    return '$done/$total Bab';
  }

  @override
  String get profileCertReady => 'Sertifikat siap diunduh';

  @override
  String get profileCertLearning => 'Sedang belajar';

  @override
  String get profileDownload => 'Unduh';

  @override
  String get profileCertChallengeDone => 'Selesai — sertifikat siap';

  @override
  String get profileCertChallengeLocked => 'Terkunci — kurang XP';

  @override
  String get profileCertChallengeInProgress => 'Sedang dikerjakan';

  @override
  String get profileDownloadSoon => 'Fitur unduh sertifikat segera hadir, ya!';

  @override
  String get certScreenTitle => 'Sertifikat Kompetensi';

  @override
  String get certLoading => 'Menyiapkan sertifikat…';

  @override
  String get certLoadFailed =>
      'Sertifikat belum bisa dimuat. Periksa koneksi lalu coba lagi.';

  @override
  String get certOpenPreview => 'Lihat Sertifikat';

  @override
  String get certOpenWeb => 'Buka Halaman Verifikasi';

  @override
  String get certShareAction => 'Bagikan Sertifikat';

  @override
  String get certShareCopied => 'Tautan verifikasi berhasil disalin.';

  @override
  String get certShareFailed => 'Tautan belum bisa disalin. Coba lagi.';

  @override
  String get certNotEligible => 'Selesaikan seluruh bab modul ini dulu, ya.';

  @override
  String get certEligibleNow => 'Sertifikat sudah siap diterbitkan.';

  @override
  String get certIdLabel => 'ID Sertifikat';

  @override
  String get certGivenTo => 'Diberikan kepada';

  @override
  String get certIssuedLabel => 'Diterbitkan';

  @override
  String get certValidUntilLabel => 'Berlaku hingga';

  @override
  String get certPageOne => 'Halaman 1 — Piagam Kelulusan';

  @override
  String get certPageTwo => 'Halaman 2 — Transkrip & Capaian';

  @override
  String get certPdfHint =>
      'Kedua halaman diunduh otomatis sebagai satu berkas PDF.';

  @override
  String certChapterCountInline(int done, int total) {
    return '$done/$total bab tuntas';
  }

  @override
  String get certPreviewTitle => 'Pratinjau e-Sertifikat';

  @override
  String get certChallengeSectionTitle => 'Sertifikat Tantangan Koding';

  @override
  String get certCatalogTitle => 'Katalog Sertifikat';

  @override
  String get certCatalogSubtitle =>
      'Semua sertifikat modul dan tantangan yang sudah kamu selesaikan.';

  @override
  String get certModuleSectionTitle => 'Sertifikat Modul';

  @override
  String get certDownloadPdf => 'Unduh PDF';

  @override
  String get certDownloadFailed =>
      'PDF belum bisa diunduh. Periksa koneksi lalu coba lagi.';

  @override
  String certReadyCount(int count) {
    return '$count sertifikat siap diunduh';
  }

  @override
  String get certEmptyTitle => 'Belum ada sertifikat';

  @override
  String get certEmptyBody =>
      'Selesaikan seluruh bab materi atau lulus tantangan koding untuk menerbitkan sertifikat.';

  @override
  String get certNotEligibleShort => 'Belum layak';

  @override
  String get certOpenCatalog => 'Lihat Semua Sertifikat';

  @override
  String get certProfileSummaryBody =>
      'Modul & tantangan yang telah kamu tuntaskan.';

  @override
  String get certTabFront => 'Piagam';

  @override
  String get certTabBack => 'Transkrip';

  @override
  String certProgressLockedHint(int percent) {
    return '$percent% selesai — sertifikat terbit otomatis setelah semua bab tuntas.';
  }

  @override
  String get changePassOldLabel => 'Kata Sandi Lama';

  @override
  String get changePassNewLabel => 'Kata Sandi Baru';

  @override
  String get changePassConfirmLabel => 'Konfirmasi Kata Sandi Baru';

  @override
  String get changePassShowPassword => 'Tampilkan sandi';

  @override
  String get changePassHidePassword => 'Sembunyikan sandi';

  @override
  String get changePassOldRequired => 'Isi kata sandi lama dulu.';

  @override
  String get changePassSuccess => 'Kata sandi berhasil diubah!';

  @override
  String get changePassFailed => 'Gagal mengubah kata sandi. Coba lagi.';

  @override
  String get changePassConfirmHint =>
      'Ketik ulang kata sandi baru untuk konfirmasi.';

  @override
  String get changePassConfirmMatch =>
      'Konfirmasi cocok dengan kata sandi baru.';

  @override
  String get changePassConfirmMismatch =>
      'Konfirmasi belum sama dengan kata sandi baru.';

  @override
  String get changePassSaving => 'Menyimpan…';

  @override
  String get changePassSave => 'Simpan Kata Sandi';

  @override
  String get joinClassTitle => 'Gabung ke Kelas Gurumu';

  @override
  String get joinClassSubtitle =>
      'Masukkan 6 karakter kode kelas yang dibagikan gurumu.';

  @override
  String get joinClassClearCode => 'Hapus kode';

  @override
  String get joinClassExample => 'Contoh: K7M-8Q2 atau 4NB-9XT';

  @override
  String get joinClassNotFound => 'Kode kelas tidak ditemukan.';

  @override
  String joinClassSuccess(String name) {
    return 'Berhasil bergabung ke $name!';
  }

  @override
  String get joinClassCtaButton => 'Gabung Kelas Sekarang';

  @override
  String get joinClassFoundBadge => 'Kelas Ditemukan';

  @override
  String joinClassMemberCount(int count) {
    return '$count Teman Sekelas';
  }

  @override
  String get classServerUnreachable =>
      'Server belum terjangkau. Periksa koneksi lab, lalu coba lagi.';

  @override
  String get classServerUnreachableShort =>
      'Server belum terjangkau. Coba beberapa saat lagi, ya.';

  @override
  String classJoinedSnack(String name) {
    return 'Berhasil bergabung ke kelas $name!';
  }

  @override
  String classLeftSnack(String name) {
    return 'Kamu keluar dari kelas $name.';
  }

  @override
  String get classSectionTitle => 'Kelas Belajar';

  @override
  String get classSeeAll => 'Lihat Semua';

  @override
  String get classLoadFailedFromServer => 'Kelas gagal dimuat dari server';

  @override
  String get classLoadFailedTitle => 'Kelas gagal dimuat';

  @override
  String get classCheckLabConnection =>
      'Cek koneksi lab sekolahmu, lalu coba lagi.';

  @override
  String get classLoadingInline => 'Memuat kelas…';

  @override
  String get classNotJoinedTitle => 'Belum tergabung ke kelas';

  @override
  String get classJoinHintInline =>
      'Masukkan kode kelas 6 karakter yang dibagikan gurumu.';

  @override
  String get classJoinButton => 'Gabung Kelas';

  @override
  String get classNotInClassTitle => 'Belum masuk kelas';

  @override
  String get classJoinHintShort => 'Gabung pakai kode 6 karakter dari gurumu.';

  @override
  String get classJoinShort => 'Gabung';

  @override
  String get classActiveBadge => 'Aktif';

  @override
  String classCountBadge(int count) {
    return '$count kelas';
  }

  @override
  String get classSeeAllTooltip => 'Lihat semua kelas';

  @override
  String classMemberCountInline(int count) {
    return '$count teman sekelas';
  }

  @override
  String get myClassesTitle => 'Kelas Saya';

  @override
  String myClassesActiveCount(int count) {
    return '$count kelas aktif';
  }

  @override
  String get myClassesSubtitle => 'Rombel tempat kamu belajar';

  @override
  String get myClassesJoinAnother => 'Gabung Kelas Lain';

  @override
  String get myClassesEmptyTitle => 'Belum tergabung ke kelas mana pun';

  @override
  String get myClassesEmptyBody =>
      'Minta kode kelas 6 karakter kepada gurumu, lalu gabung dari sini.';

  @override
  String get classDetailLoadFailed => 'Detail kelas gagal dimuat';

  @override
  String get classRegisteredBadge => 'Terdaftar Aktif';

  @override
  String get classTeacherRoleBadge => 'Guru';

  @override
  String get classTeacherAdvisor => 'Guru pembimbing kelas ini';

  @override
  String get classClassmatesTitle => 'Teman Sekelas';

  @override
  String classClassmatesCount(int count) {
    return '($count Siswa)';
  }

  @override
  String get classNoClassmates => 'Belum ada teman sekelas yang terdaftar.';

  @override
  String get classMonitoringNote =>
      'Progres koding dan nilai tantanganmu dapat dipantau langsung oleh guru kelas ini di lab komputer.';

  @override
  String get classXpSafeNote =>
      'Poin XP dan progres belajarmu tetap aman di akunmu jika kamu keluar kelas.';

  @override
  String get classCopyInfo => 'Salin Info Kelas';

  @override
  String get classInfoCopied => 'Info Tersalin!';

  @override
  String get classLeaveButton => 'Keluar dari Kelas';

  @override
  String get classLeaveConfirmTitle => 'Yakin Ingin Keluar dari Kelas?';

  @override
  String get classLeaveConfirmBody =>
      'Poin XP dan progres belajarmu tetap aman di akunmu, namun gurumu tidak dapat lagi memantau kemajuan belajarmu di lab.';

  @override
  String get classLeaveConfirmYes => 'Ya, Keluar Kelas';

  @override
  String get classHideNames => 'Sembunyikan';

  @override
  String classMoreCount(int rest) {
    return '+$rest lainnya';
  }

  @override
  String classSeeAllNames(int count) {
    return 'Lihat semua nama ($count)';
  }

  @override
  String get authPassNotFilled => 'Belum diisi';

  @override
  String get authPassVeryGood => 'Sangat Bagus!';

  @override
  String get authPassNeedsWork => 'Perlu ditingkatkan';

  @override
  String get authPassSecurityTitle => 'KEAMANAN SANDI';

  @override
  String get authPassMinLength => 'Minimal 8 karakter';

  @override
  String get authPassDigitOrSymbol => 'Ada angka atau simbol';

  @override
  String get authCheckMet => 'terpenuhi';

  @override
  String get authCheckNotMet => 'belum terpenuhi';

  @override
  String get authSchoolVerifiedBadge => 'Sekolah Terdaftar Resmi';

  @override
  String authSchoolCodePrefix(String code) {
    return 'Kode: $code';
  }

  @override
  String get authSchoolReadOnlyNote =>
      'Data sekolah ini bersifat read-only dan terverifikasi otomatis; tidak dapat diubah oleh instruktur.';

  @override
  String get validNameRequired => 'Isi nama lengkapmu dulu.';

  @override
  String get validEmailRequired => 'Isi email kamu dulu.';

  @override
  String get validEmailFormat =>
      'Format email belum benar. Contoh: nama@smk.belajar.id';

  @override
  String validSchoolEmailDomain(String domain) {
    return 'Email harus memakai domain $domain.';
  }

  @override
  String get validPasswordRequired => 'Isi kata sandi kamu dulu.';

  @override
  String get validNewPasswordRequired => 'Buat kata sandi dulu.';

  @override
  String get validPasswordPolicy =>
      'Minimal 8 karakter dan ada angka atau simbol.';

  @override
  String get validConfirmRequired => 'Ketik ulang kata sandi untuk konfirmasi.';

  @override
  String get validPasswordMismatch =>
      'Kata sandi belum sama dengan isian pertama.';

  @override
  String get authErrInvalidCredentials =>
      'Email atau kata sandi belum cocok. Coba periksa lagi.';

  @override
  String get authErrEmailTaken => 'Email ini sudah punya akun. Mau masuk saja?';

  @override
  String get authErrNetwork =>
      'Belum tersambung ke internet. Coba lagi sebentar.';

  @override
  String get authErrSchoolCodeNotFound =>
      'Kode sekolah tidak ditemukan. Silakan hubungi admin sekolahmu.';

  @override
  String get authErrWrongOldPassword =>
      'Kata sandi lama belum cocok. Coba periksa lagi.';

  @override
  String get authErrPasswordPolicy =>
      'Kata sandi baru belum memenuhi aturan (minimal 8 karakter, ada angka atau simbol).';

  @override
  String get authErrAvatarUpload =>
      'Foto profil belum bisa diunggah. Gunakan JPG atau PNG maksimal 2 MB.';

  @override
  String get authErrEmailDomain =>
      'Email harus memakai domain @smk.belajar.id.';

  @override
  String get authErrInvalidInput =>
      'Ada isian yang belum sesuai. Periksa kembali lalu simpan lagi.';

  @override
  String get authErrServer =>
      'Server sedang bermasalah. Coba lagi beberapa saat lagi.';

  @override
  String get loginWelcomeTitle => 'Selamat datang kembali';

  @override
  String get loginWelcomeSubtitle =>
      'Lanjutkan belajar koding dari mana kamu berhenti.';

  @override
  String get loginJustRegisteredBanner =>
      'Akunmu sudah dibuat. Silakan masuk untuk mulai belajar.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Kata Sandi';

  @override
  String get authPasswordHint => 'Masukkan kata sandi';

  @override
  String get loginSubmit => 'Masuk Sekarang';

  @override
  String get loginNoAccount => 'Belum punya akun?';

  @override
  String get authRegisterLink => 'Daftar';

  @override
  String get authBackTooltip => 'Kembali';

  @override
  String get registerTitle => 'Daftar Akun';

  @override
  String get registerTagBanner => 'Platform Belajar Coding RPL';

  @override
  String get registerHeading => 'Yuk, buat akunmu';

  @override
  String get registerSubheading => 'Untuk siswa SMK/SMA jurusan RPL.';

  @override
  String get registerNameLabel => 'Nama Lengkap';

  @override
  String get registerNameHintAside => 'Sesuai absen kelas';

  @override
  String get registerEmailLabel => 'Email Pelajar / Pribadi';

  @override
  String get registerEmailHintAside => '.belajar.id';

  @override
  String get authPasswordStrengthHint => 'Kombinasi sandi kuat';

  @override
  String get registerConfirmLabel => 'Konfirmasi Kata Sandi';

  @override
  String get authSameExactlyHintAside => 'Sama persis';

  @override
  String get authRetypePasswordHint => 'Ketik ulang kata sandimu';

  @override
  String get registerSubmit => 'Buat Akun';

  @override
  String get authAlreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get authLoginLink => 'Masuk';

  @override
  String get registerTeacherLink =>
      'Anda Guru / Pengajar? Daftar akun pendidik di sini →';

  @override
  String get registerSuccessTitle => 'Pendaftaran Berhasil! 🎉';

  @override
  String get registerSuccessBody =>
      'Akunmu sudah dibuat dan siap dipakai.\n\nSilakan masuk (login) menggunakan email dan kata sandi yang baru saja kamu buat.';

  @override
  String get registerCommunityPrefix => 'Gabung bersama';

  @override
  String get registerCommunitySuffix =>
      'rekan RPL yang mulai belajar logika algoritma, Git, dan web dev hari ini.';

  @override
  String get teacherRegTitle => 'Registrasi Akun Pendidik';

  @override
  String get teacherRegTagBanner => 'Kemitraan Instansi';

  @override
  String get teacherRegHeading => 'Pilih Peran Akunmu';

  @override
  String get teacherRegSubheading =>
      'Sesuaikan pengalaman belajar atau manajemen lab komputer sekolahmu.';

  @override
  String get teacherRegVerifySectionTitle => 'Verifikasi Sekolah & Lab';

  @override
  String get teacherRegStatusConnected => 'Terkoneksi';

  @override
  String get teacherRegStatusWaiting => 'Menunggu kode';

  @override
  String get teacherRegSchoolCodeLabel => 'Kode Registrasi Sekolah / Lab';

  @override
  String get teacherRegSchoolCodeHintAside => 'Dari dinas/sekolah';

  @override
  String get teacherRegSchoolCodeHint => 'Contoh: SWADHIPA2-NTR';

  @override
  String get teacherRegSchoolCodeInvalid =>
      'Ketik kode sekolah resmi hingga kartu hijau muncul.';

  @override
  String get teacherRegVerifyFirst =>
      'Verifikasi sekolah dulu — ketik kode resmi lalu tunggu kartu hijau muncul.';

  @override
  String get teacherRegSchoolCodeNote =>
      'Guru wajib memasukkan kode sekolah resmi agar terafiliasi dengan laboratorium sekolah.';

  @override
  String get teacherRegDataSectionTitle => 'Data Pendidik Terdaftar';

  @override
  String get teacherRegDataSectionNote =>
      'Lengkapi identitas pendidik untuk verifikasi sertifikat lab.';

  @override
  String get teacherRegNameLabel => 'Nama Lengkap & Gelar';

  @override
  String get teacherRegNameHintAside => 'Contoh: Budi Santoso, S.Kom';

  @override
  String get teacherRegEmailLabel => 'Email Pendidik / Instansi';

  @override
  String get teacherRegEmailHintAside => 'Email kantor';

  @override
  String get teacherRegSubmit => 'Lanjutkan Pendaftaran Akun';

  @override
  String teacherRegSuccessBody(String school) {
    return 'Akun pengajarmu sudah dibuat untuk $school.\n\nSilakan masuk (login) menggunakan email dan kata sandi yang baru saja kamu buat.';
  }

  @override
  String get teacherRegYourSchool => 'sekolahmu';

  @override
  String get roleStudentChip => 'Belajar Mandiri';

  @override
  String get roleStudentTitle => 'Siswa Belajar';

  @override
  String get roleStudentDesc => 'Akses modul koding praktis & AI tutor 24/7';

  @override
  String get roleTeacherChip => 'Akses Pendidik';

  @override
  String get roleTeacherTitle => 'Guru / Instruktur';

  @override
  String get roleTeacherDesc => 'Kelola lab kelas, kurikulum & pantau siswa';

  @override
  String get actionCopy => 'Salin';

  @override
  String get codeCopied => 'Kode disalin.';

  @override
  String get a11yShowPassword => 'Tampilkan kata sandi';

  @override
  String get a11yHidePassword => 'Sembunyikan kata sandi';

  @override
  String get a11yOpenProfile => 'Buka profil';

  @override
  String a11yMasteryRadar(String detail) {
    return 'Radar penguasaan: $detail';
  }

  @override
  String loadingTipSubmitQuota(String run, String submit) {
    return 'Tekan \"$run\" dulu sebelum \"$submit\" — biar kuota harianmu aman.';
  }

  @override
  String get loadingTipAiHint =>
      'Bantuan AI hanya memberi petunjuk, bukan kode jadi. Jawabnya tetap kerjamu.';

  @override
  String get loadingTipPlayground =>
      'Playground menjalankan Python langsung di perangkat — tetap aktif walau offline.';

  @override
  String get loadingTipHiddenTests =>
      'Kasus uji rahasia tinggal di server, tidak ikut terkirim ke HP siswa.';

  @override
  String get loadingVersionFooter => 'Versi 2.1 · Kurikulum Merdeka RPL';

  @override
  String get bootTitle => 'Memulihkan sesimu…';

  @override
  String get bootSubtitle => 'Menyiapkan lab kode di perangkat';

  @override
  String get bootStageSecureStorage => 'Memeriksa penyimpanan aman';

  @override
  String get classResponseUnrecognized =>
      'Format jawaban kelas tidak dikenali.';

  @override
  String get slideTapToFillSuccessTitle => 'Tepat Sekali!';

  @override
  String get slideTapToFillSuccessMsg => 'Sintaks berhasil disusun.';

  @override
  String get slideTapToFillErrorTitle => 'Coba Periksa Lagi!';

  @override
  String get slideTapToFillErrorMsg => 'Perhatikan slot yang kosong.';

  @override
  String get slideTypeCodeSuccessTitle => 'Luar Biasa!';

  @override
  String get slideTypeCodeSuccessMsg => 'Perintah yang kamu ketik tepat.';

  @override
  String get slideTypeCodeErrorTitle => 'Kurang Tepat!';

  @override
  String get slideTypeCodeErrorMsg => 'Perhatikan penulisan huruf.';

  @override
  String get slideOutputPredictSuccessTitle => 'Mantap Jiwa!';

  @override
  String get slideOutputPredictSuccessMsg => 'Prediksi logikamu akurat.';

  @override
  String get slideOutputPredictErrorTitle => 'Kurang Tepat!';

  @override
  String get slideOutputPredictErrorMsg =>
      'Perhatikan alur eksekusi baris demi baris.';

  @override
  String get slideBugHunterSuccessTitle => 'Hebat, Bug Ditemukan!';

  @override
  String get slideBugHunterSuccessMsg =>
      'Kamu berhasil mendeteksi baris error.';

  @override
  String get slideBugHunterErrorTitle => 'Bukan Baris Itu!';

  @override
  String get slideBugHunterErrorMsg =>
      'Cari baris yang melanggar aturan sintaks.';

  @override
  String get slideQuizSuccessTitle => 'Jawaban Sempurna!';

  @override
  String get slideQuizSuccessMsg => 'Pemahaman konsepmu sangat solid.';

  @override
  String get slideQuizErrorTitle => 'Kurang Tepat!';

  @override
  String get slideQuizErrorMsg => 'Coba ingat kembali prinsip dasar modul ini.';

  @override
  String get slideContentUnavailable => 'Modul belum tersedia saat ini.';

  @override
  String get tutorHintTabConcept => 'Hint 1: Konsep';

  @override
  String get tutorHintTabLogic => 'Hint 2: Logika';

  @override
  String get tutorHintTabStructure => 'Hint 3: Struktur';

  @override
  String get tutorHintDefaultConcept => 'Latihan Koding';

  @override
  String get tutorHintPlaygroundConcept => 'Latihan Mandiri (Playground)';

  @override
  String get tutorHintChallengeQ1 =>
      'Apa output yang diminta soal ini? Ceritakan dulu dengan bahasamu sendiri sebelum menyentuh kode.';

  @override
  String get tutorHintChallengeQ1Step1 =>
      'Sebutkan input yang tersedia dan output yang harus muncul.';

  @override
  String get tutorHintChallengeQ1Step2 =>
      'Tandai bagian kode yang sudah kamu pahami dan bagian yang masih ragu.';

  @override
  String get tutorHintChallengeQ2 =>
      'Bagaimana urutan langkah programmu dari baris pertama sampai terakhir?';

  @override
  String get tutorHintChallengeQ2Step1 =>
      'Tulis urutan langkahnya dalam bahasa sehari-hari, belum dalam kode.';

  @override
  String get tutorHintChallengeQ2Step2 =>
      'Periksa apakah setiap langkah benar-benar mengarah ke output yang diminta soal.';

  @override
  String get tutorHintChallengeQ3 =>
      'Baris mana yang paling sering memunculkan error saat kamu jalankan?';

  @override
  String get tutorHintChallengeQ3Step1 =>
      'Baca pesan error dari baris paling atas: nama error dan nomor barisnya.';

  @override
  String get tutorHintChallengeQ3Step2 =>
      'Cocokkan tanda baca di baris itu (kurung, titik dua, tanda kutip, indentasi).';

  @override
  String get tutorHintPlaygroundQ1 =>
      'Masalah apa yang paling ingin kamu pecahkan program ini? Tulis tujuannya dalam satu kalimat dulu.';

  @override
  String get tutorHintPlaygroundQ1Step1 =>
      'Petakan: input apa yang masuk, proses apa yang dilakukan, output apa yang diharapkan.';

  @override
  String get tutorHintPlaygroundQ1Step2 =>
      'Mulai dari potongan paling kecil yang bisa kamu uji sendiri.';

  @override
  String get tutorHintPlaygroundQ2 =>
      'Bagaimana urutan langkah programmu dari baris pertama sampai terakhir?';

  @override
  String get tutorHintPlaygroundQ2Step1 =>
      'Tulis alurnya sebagai pseudo-kode bahasa Indonesia sebelum disalin ke Python.';

  @override
  String get tutorHintPlaygroundQ2Step2 =>
      'Tandai mana bagian yang berulang (loop) dan mana yang bercabang (if).';

  @override
  String get tutorHintPlaygroundQ3 =>
      'Bagian mana dari kodemu yang tampak rancu saat dibaca?';

  @override
  String get tutorHintPlaygroundQ3Step1 =>
      'Cek indentasi dan tanda titik dua pada baris yang berisi logika.';

  @override
  String get tutorHintPlaygroundQ3Step2 =>
      'Uji potongan kecil di terminal yang sama sebelum digabung kembali.';

  @override
  String get tNavDashboard => 'Dashboard';

  @override
  String get tNavMaterials => 'Modul';

  @override
  String get tNavAnalytics => 'Analisa';

  @override
  String get tPickerTitle => 'Analisa Kelas';

  @override
  String get tPickerHeading => 'Pilih Kelas';

  @override
  String get tPickerSubtitle =>
      'Pilih kelas untuk melihat peringkat modul dan latihan siswa, lalu kelola anggotanya.';

  @override
  String get tPickerEmptyTitle => 'Belum Ada Kelas';

  @override
  String get tPickerEmptyBody =>
      'Buat kelas pertamamu di Dashboard untuk mulai memantau analisa siswa.';

  @override
  String get tPickerOpenDashboard => 'Buka Dashboard';

  @override
  String get tPickerSchoolUnset => 'Sekolah belum diatur';

  @override
  String tPickerMemberCount(int count) {
    return '$count siswa';
  }

  @override
  String get tArchivedTitle => 'Arsip Kelas';

  @override
  String get tArchivedInfo =>
      'Kelas arsip tidak bisa diikuti siswa baru. Pulihkan kelas bila ingin mengaktifkannya lagi.';

  @override
  String get tArchivedLoadFailed => 'Gagal Memuat Arsip';

  @override
  String get tArchivedEmptyTitle => 'Belum Ada Kelas Diarsipkan';

  @override
  String get tArchivedEmptyBody =>
      'Kelas yang kamu arsipkan dari halaman analisa akan muncul di sini.';

  @override
  String get tArchivedBackDashboard => 'Kembali ke Dashboard';

  @override
  String get tArchivedBadge => 'Diarsipkan';

  @override
  String tArchivedSchoolYear(String school, String year) {
    return '$school • Tahun Ajaran $year';
  }

  @override
  String get tArchivedClassCode => 'KODE KELAS';

  @override
  String get tArchivedInactive => 'Nonaktif';

  @override
  String get tArchivedRestore => 'Pulihkan Kelas';

  @override
  String get tDashFilterTitle => 'Filter Daftar Kelas';

  @override
  String get tDashFilterSubtitle =>
      'Pencarian dan tahun ajaran disaring dari data kelas yang sudah dimuat.';

  @override
  String get tDashSearchHint => 'Cari nama atau kode kelas';

  @override
  String get tDashClearSearch => 'Bersihkan pencarian';

  @override
  String get tDashYearLabel => 'Tahun Ajaran';

  @override
  String get tDashApplyFilter => 'Terapkan Filter';

  @override
  String get tDashFilterReset => 'Reset';

  @override
  String tDashCodeCopied(String code) {
    return 'Kode kelas \"$code\" disalin ke clipboard!';
  }

  @override
  String get tDashCodeFullscreen => 'KODE KELAS (LAYAR PENUH)';

  @override
  String get tDashProjectorHint =>
      'Buka aplikasi CodeLab AI dan masukkan kode kelas:';

  @override
  String get tDashProjectorCopy => 'Salin Kode';

  @override
  String get tDashCreateNewClass => 'Buat Kelas Baru';

  @override
  String get tDashCreateSubtitle =>
      'Wadah identitas kelas untuk memantau kemajuan belajar siswa.';

  @override
  String get tDashFieldName => 'Nama Kelas *';

  @override
  String get tDashExampleName => 'Contoh: X RPL 1';

  @override
  String get tDashFieldYear => 'Tahun Ajaran *';

  @override
  String tDashExampleYear(String year) {
    return 'Contoh: $year';
  }

  @override
  String get tDashCreateClass => 'Buat Kelas';

  @override
  String get tDashValidationRequired =>
      'Nama kelas dan tahun ajaran wajib diisi.';

  @override
  String get tDashSchoolUnset => 'Sekolah belum terhubung';

  @override
  String tDashGreeting(String name) {
    return 'Halo, $name 👋';
  }

  @override
  String get tDashGreetingFallback => 'Guru';

  @override
  String get tProfileTitle => 'Profil Pengajar';

  @override
  String get tDashBadgeTotal => 'Total';

  @override
  String tDashClassCount(int count) {
    return '$count Kelas';
  }

  @override
  String get tDashActiveClasses => 'Kelas Aktif';

  @override
  String get tDashBadgeRegistered => 'Terdaftar';

  @override
  String get tDashRegisteredStudents => 'Siswa Terdaftar';

  @override
  String get tDashClassListTitle => 'Daftar Kelas Belajar';

  @override
  String get tDashClassListSubtitle =>
      'Pilih kelas untuk memantau kemajuan atau bagikan kode.';

  @override
  String get tDashFilterTooltip => 'Filter daftar kelas';

  @override
  String get tDashArchive => 'Arsip';

  @override
  String tDashSearchChip(String query) {
    return 'Cari: $query';
  }

  @override
  String get tDashResetFilter => 'Reset filter';

  @override
  String get tDashEmptyBody =>
      'Buat kelas pertamamu untuk mendapatkan kode kelas dan mulai memantau kemajuan belajar siswa.';

  @override
  String get tDashNoMatchTitle => 'Tidak Ada Kelas yang Cocok';

  @override
  String get tDashNoMatchBody =>
      'Coba kata kunci lain atau tampilkan semua tahun ajaran.';

  @override
  String get tDashShowAll => 'Tampilkan Semua Kelas';

  @override
  String tDashActiveYear(String year) {
    return 'Aktif $year';
  }

  @override
  String get tDashMetaMembers => 'Anggota';

  @override
  String get tDashProjector => 'Proyektor Kode';

  @override
  String get tDashMonitor => 'Pantau Kelas';

  @override
  String get tProfileLogoutTitle => 'Keluar dari Akun Pengajar?';

  @override
  String get tProfileLogoutBody =>
      'Kamu perlu memasukkan email dan kata sandi kembali untuk masuk ke akun pengajar ini.';

  @override
  String get tProfileLogoutConfirm => 'Ya, Keluar';

  @override
  String get tProfileNameFallback => 'Pengajar RPL';

  @override
  String get tProfileSettingsTooltip => 'Pengaturan Profil';

  @override
  String get tProfileRoleChip => 'Instruktur RPL';

  @override
  String tProfileNip(String code) {
    return 'NIP: $code';
  }

  @override
  String get tProfileAddBio => 'Tambah Bio';

  @override
  String get tProfileStatClasses => 'Kelas Diajar';

  @override
  String get tProfileStatStudents => 'Siswa Dibimbing';

  @override
  String get tProfileStatMaterials => 'Modul Ajar';

  @override
  String get tProfileClassesTitle => 'Kelas yang Diajar';

  @override
  String get tProfileNoClasses => 'Belum ada kelas yang dibuat.';

  @override
  String tProfileClassMeta(String year, int count) {
    return 'Tahun $year • $count Siswa';
  }

  @override
  String get tProfileNoMaterials => 'Belum ada modul yang dibuat.';

  @override
  String tProfileMaterialCount(int count) {
    return '$count Modul';
  }

  @override
  String tProfileMaterialMeta(String topic, int babs, int xp) {
    return '$topic • $babs Bab • $xp XP';
  }

  @override
  String get tProfilePublished => 'Terbit';

  @override
  String get tProfileDraft => 'Draft';

  @override
  String get tProfileOpenSettings => 'Buka Pengaturan Akun';

  @override
  String get tProfileLogout => 'Keluar dari Akun';

  @override
  String get tStudioActionHint => 'Pilih tindakan untuk modul ini';

  @override
  String get tStudioEditSyllabus => 'Edit Silabus & Bab';

  @override
  String get tStudioEditInfo => 'Edit Info Modul';

  @override
  String get tStudioDuplicate => 'Duplikat sebagai Draft Baru';

  @override
  String get tStudioUnpublish => 'Tarik Kembali ke Draft';

  @override
  String get tStudioPublish => 'Terbitkan ke Siswa';

  @override
  String get tStudioDeleteForever => 'Hapus Modul Selamanya';

  @override
  String get tStudioDeleteTitle => 'Hapus Modul Ini?';

  @override
  String tStudioDeleteBody(String title) {
    return 'Modul \"$title\" akan dihapus dari Studio. Riwayat belajar siswa yang sudah tuntas tetap tersimpan.';
  }

  @override
  String get tStudioTitle => 'Studio Modul';

  @override
  String get tStudioSettingsTooltip => 'Pengaturan Pengajar';

  @override
  String get tStudioMyMaterials => 'Modul Saya';

  @override
  String get tStudioSubtitle => 'Kelola modul pembelajaran & bab koding';

  @override
  String get tStudioAdd => 'Tambah Modul';

  @override
  String get tStudioBannerTitle => 'Status Pembelajaran Kelas';

  @override
  String tStudioBanner(int published, int students, String school) {
    return '$published modul aktif terbit untuk $students siswa di $school.';
  }

  @override
  String get tStudioYourSchool => 'sekolahmu';

  @override
  String tStudioFilterAll(int count) {
    return 'Semua ($count)';
  }

  @override
  String tStudioFilterDraft(int count) {
    return 'Draft ($count)';
  }

  @override
  String tStudioFilterPublished(int count) {
    return 'Terbit ($count)';
  }

  @override
  String get tStudioEmptyTitle => 'Belum Ada Modul';

  @override
  String get tStudioEmptyDraftTitle => 'Tidak Ada Modul Draft';

  @override
  String get tStudioEmptyPublishedTitle => 'Tidak Ada Modul Terbit';

  @override
  String get tStudioEmptyBody =>
      'Mulai bangun kurikulum coding untuk siswamu. Klik tombol Tambah Modul di atas.';

  @override
  String get tStudioEmptyFilterBody =>
      'Ganti filter atau tambahkan modul baru untuk kategori ini.';

  @override
  String get tStudioCreateNew => 'Buat Modul Baru';

  @override
  String tStudioBabCount(int count) {
    return '$count bab';
  }

  @override
  String get tStudioNotVisible => 'Belum tampak oleh siswa';

  @override
  String get tBabDeleteTitle => 'Hapus Bab Ini?';

  @override
  String tBabDeleteBody(String title) {
    return 'Bab \"$title\" akan dihapus dari daftar modul. Riwayat belajar siswa yang sudah tercatat tetap tersimpan.';
  }

  @override
  String get tBabDuplicateTitle => 'Duplikat Bab Ini?';

  @override
  String tBabDuplicateBody(String title) {
    return 'Salinan \"$title\" akan muncul sebagai bab nomor berikutnya, lengkap dengan seluruh slide dan XP-nya.';
  }

  @override
  String get tBabDuplicate => 'Duplikat';

  @override
  String get tBabTitle => 'Silabus & Bab';

  @override
  String get tBabAdd => 'Tambah Bab';

  @override
  String get tBabTopicFallback => 'Modul Studio';

  @override
  String get tBabTitleFallback => 'Daftar Bab';

  @override
  String get tBabCurriculumStatus => 'Status Kurikulum Bab';

  @override
  String tBabMeta(int babs, int xp) {
    return '$babs Bab • $xp XP';
  }

  @override
  String get tBabPublishedHint =>
      'Seluruh bab aktif terbaca oleh siswa di kelasmu.';

  @override
  String get tBabDraftHint =>
      'Modul berstatus Draft. Siswa belum dapat melihat bab-bab ini.';

  @override
  String get tBabListTitle => 'Daftar Bab Terstruktur';

  @override
  String get tBabFlowOrder => 'Urutan Alur Belajar';

  @override
  String get tBabEmptyTitle => 'Belum Ada Bab';

  @override
  String get tBabEmptyBody =>
      'Modul ini belum memiliki bab pembelajaran. Tambahkan bab pertama untuk mulai menyusun slide kuis dan teori.';

  @override
  String get tBabAddFirst => 'Tambah Bab Pertama';

  @override
  String tBabRowMeta(int slides, int xp) {
    return '$slides Slide • $xp XP';
  }

  @override
  String get tBabMoveUp => 'Pindah ke atas';

  @override
  String get tBabMoveDown => 'Pindah ke bawah';

  @override
  String get tBabPreviewTooltip => 'Simulator Siswa (Pratinjau)';

  @override
  String get tBabActionTooltip => 'Aksi bab';

  @override
  String get tBabEdit => 'Edit Bab';

  @override
  String get tBabDuplicateMenu => 'Duplikat Bab';

  @override
  String get tBabDeleteMenu => 'Hapus Bab';

  @override
  String get tFormLevelDescBeginner =>
      'Level dasar: ditujukan bagi siswa yang baru mengenal logika pemrograman.';

  @override
  String get tFormLevelDescIntermediate =>
      'Level menengah: percabangan lanjutan, perulangan, & manipulasi data.';

  @override
  String get tFormLevelDescAdvanced =>
      'Level mahir: algoritma rekursif kompleks & optimasi pemecahan masalah.';

  @override
  String get tFormNotFound =>
      'Modul tidak ditemukan. Kembali ke Studio Modul untuk memilih modul lain.';

  @override
  String get tFormTitleRequired => 'Nama modul wajib diisi.';

  @override
  String get tFormTitleDuplicate =>
      'Nama modul sudah dipakai. Gunakan nama lain agar siswa tidak bingung.';

  @override
  String get tFormUpdated => 'Modul berhasil diperbarui.';

  @override
  String get tFormSavedDraft => 'Modul tersimpan sebagai draft.';

  @override
  String get tFormSaveFailed =>
      'Modul belum tersimpan. Periksa koneksi lalu coba lagi.';

  @override
  String get tFormUnsavedTitle => 'Perubahan Belum Disimpan';

  @override
  String get tFormUnsavedBody =>
      'Ada revisi pada form modul ini. Simpan perubahan sebagai draft terlebih dahulu atau abaikan?';

  @override
  String get tFormSaveExit => 'Simpan Draft & Keluar';

  @override
  String get tFormDiscard => 'Buang Perubahan';

  @override
  String get tFormKeepEditing => 'Lanjut Mengedit';

  @override
  String get tFormEdit => 'Edit Modul';

  @override
  String get tFormLoadFailed => 'Modul Tidak Dapat Dimuat';

  @override
  String get tFormOpenStudio => 'Buka Studio Modul';

  @override
  String get tFormAdd => 'Tambah Modul Baru';

  @override
  String get tFormModeEdit => 'Mode Edit';

  @override
  String get tFormNewBadge => 'Modul Baru';

  @override
  String get tFormEditHeading => 'Ubah Pengaturan Modul';

  @override
  String get tFormAddHeading => 'Konfigurasi Modul Baru';

  @override
  String get tFormSubtitle =>
      'Konfigurasikan judul, track kurikulum, dan level kesulitan untuk ditampilkan ke siswa.';

  @override
  String get tFormFieldName => 'Nama Modul *';

  @override
  String get tFormExampleName => 'Contoh: Dasar Algoritma & Python RPL';

  @override
  String get tFormFieldDesc => 'Deskripsi Singkat *';

  @override
  String get tFormDescHint =>
      'Jelaskan capaian modul dalam 2-3 kalimat ringkas...';

  @override
  String get tFormFieldIcon => 'Kode Ikon Modul *';

  @override
  String get tFormIconHint =>
      'Pilih preset ikon atau ketik nama kode ikon (misal: terminal, html, css, javascript, database, psychology, shield, phone_android).';

  @override
  String get tFormExampleIcon => 'Contoh: terminal';

  @override
  String get tFormFieldTopic => 'Topik / Track Kurikulum *';

  @override
  String get tFormFieldLevel => 'Tingkat Kesulitan *';

  @override
  String get tFormDraftNotice =>
      'Modul baru disimpan sebagai Draft. Modul hanya terlihat oleh siswa setelah kamu menekan tombol \"Terbitkan\".';

  @override
  String get tFormSaveDraft => 'Simpan Draft';

  @override
  String get tFormContinueBabs => 'Lanjut ke Bab';

  @override
  String get tSlideNotFound =>
      'Slide tidak ditemukan. Buka Bab Builder untuk memilih slide lain.';

  @override
  String tSlideTemplateApplied(String label) {
    return 'Template awal \"$label\" dipakai.';
  }

  @override
  String get tSlideBabUnsaved =>
      'Bab baru belum tersimpan. Tambahkan slide dari Bab Builder agar tersimpan bersama bab.';

  @override
  String get tSlideSaveNoBab =>
      'Slide tidak dapat disimpan. Buka Bab Builder untuk memuat ulang bab.';

  @override
  String get tSlideSaveFailed => 'Slide gagal disimpan. Coba lagi.';

  @override
  String get tSlideSaved => 'Slide tersimpan ke bab.';

  @override
  String get tSlideEditorTitle => 'Editor Slide';

  @override
  String get tSlideLoadFailedTitle => 'Slide Tidak Dapat Dimuat';

  @override
  String get tSlideOpenBabBuilder => 'Buka Bab Builder';

  @override
  String get tSlidePreviewTooltip => 'Pratinjau slide';

  @override
  String tSlideHeader(int index, String label) {
    return 'Slide $index • $label';
  }

  @override
  String get tSlidePreviewAsStudent => 'Pratinjau sebagai Siswa';

  @override
  String get tSlideUseTemplate => 'Pakai Template Awal';

  @override
  String get tSlideSave => 'Simpan Slide';

  @override
  String tSlideTooLong(String label, int max) {
    return '$label terlalu panjang (maksimal $max karakter).';
  }

  @override
  String tSlideRequired(String label) {
    return '$label wajib diisi.';
  }

  @override
  String tSlideMaxItems(String label, int limit) {
    return '$label maksimal $limit butir.';
  }

  @override
  String tSlideChoiceEmpty(String letter, String label) {
    return 'Pilihan $letter pada $label masih kosong.';
  }

  @override
  String tSlideChoiceKey(String label) {
    return 'Pilih salah satu kunci jawaban A–D pada $label.';
  }

  @override
  String tSlideSlotEmpty(int n) {
    return 'Kunci jawaban slot $n masih kosong.';
  }

  @override
  String get tSlideTapMarkerMissing =>
      'Kode soal belum punya penanda [KETIK_DISINI] sebagai tempat siswa mengetik.';

  @override
  String get tSlideBugHintOrFix =>
      'Isi \"Pesan Indikator\" atau \"Kode Perbaikan Valid\" agar siswa mendapat penjelasan setelah menjawab.';

  @override
  String get tSlideConceptRequired => 'Isi minimal satu konsep yang dikuasai.';

  @override
  String get tSlideTemplateNoSlot =>
      'Template kode belum punya slot. Tandai bagian kosong dengan ___1___, ___2___, dan seterusnya.';

  @override
  String get tSlideDistractorRequired =>
      'Tambahkan minimal satu pengecoh agar soal bisa dipilih.';

  @override
  String get tSlideDistractorsSame =>
      'Semua pengecoh sama dengan kunci jawaban. Tambahkan pilihan lain.';

  @override
  String get tSlideTargetNotNumber => 'Target nomor baris harus berupa angka.';

  @override
  String tSlideTargetRange(int n) {
    return 'Target nomor baris harus antara 1 dan $n sesuai jumlah baris kode.';
  }

  @override
  String get tSlideFieldExerciseTitle => 'Judul latihan';

  @override
  String get tSlideFieldInstruction => 'Instruksi';

  @override
  String get tSlideFieldQuestionTitle => 'Judul soal';

  @override
  String get tSlideFieldQuestionCode => 'Kode soal';

  @override
  String get tSlideFieldAnswerKeyword => 'Kata kunci jawaban';

  @override
  String get tSlideFieldHint => 'Petunjuk';

  @override
  String get tSlideFieldSlideTitle => 'Judul slide';

  @override
  String get tSlideFieldCodeBlock => 'Blok kode';

  @override
  String get tSlideFieldOutputChoices => 'pilihan output';

  @override
  String get tSlideFieldExplanation => 'Penjelasan';

  @override
  String get tSlideFieldChallengeTitle => 'Judul tantangan';

  @override
  String get tSlideFieldScenario => 'Skenario';

  @override
  String get tSlideFieldProgramCode => 'Kode program';

  @override
  String get tSlideFieldErrorType => 'Jenis error';

  @override
  String get tSlideFieldBugHint => 'Pesan indikator';

  @override
  String get tSlideFieldFixCode => 'Kode perbaikan';

  @override
  String get tSlideFieldQuizQuestion => 'Pertanyaan kuis';

  @override
  String get tSlideFieldAnswerChoices => 'pilihan jawaban';

  @override
  String get tSlideFieldFeedback => 'Umpan balik';

  @override
  String get tSlideFieldOutroTitle => 'Judul slide penutup';

  @override
  String get tSlideFieldSummary => 'Rangkuman modul';

  @override
  String get tSlideFieldMasteredConcepts => 'Konsep yang dikuasai';

  @override
  String get tSlideFieldTheoryTitle => 'Judul modul teori';

  @override
  String get tSlideFieldTheoryContent => 'Konten penjelasan';

  @override
  String get tSlideFieldSampleCode => 'Cuplikan kode sampel';

  @override
  String get tSlideFieldCodeLanguage => 'Bahasa kode';

  @override
  String get tSlideFieldCodeTemplate => 'Template kode';

  @override
  String get tSlideFieldAnswerKey => 'Kunci jawaban';

  @override
  String get tSlideFieldSlotAnswer => 'Kunci jawaban slot';

  @override
  String get tSlideFieldDistractors => 'Pengecoh';

  @override
  String get tSlideFieldTargetLine => 'Target nomor baris';

  @override
  String get tBabNotFound =>
      'Bab tidak ditemukan. Buka daftar bab untuk memilih bab lain.';

  @override
  String get tBabSlideEmptyHint =>
      'Belum ada isi. Ketuk Edit Konten untuk mulai.';

  @override
  String get tBabMinSlides => 'Bab minimal harus memiliki 1 slide.';

  @override
  String get tBabTitleRequired => 'Nama bab wajib diisi.';

  @override
  String get tBabUpdated => 'Bab berhasil diperbarui.';

  @override
  String get tBabCreated => 'Bab baru berhasil ditambahkan.';

  @override
  String get tBabMinSlidesPreview =>
      'Bab minimal harus memiliki 1 slide untuk disimulasikan.';

  @override
  String get tBabPreviewFallback => 'Pratinjau Bab';

  @override
  String get tBabEditTitle => 'Edit Bab';

  @override
  String get tBabLoadFailedTitle => 'Bab Tidak Dapat Dimuat';

  @override
  String get tBabOpenList => 'Buka Daftar Bab';

  @override
  String get tBabBuilderTitle => 'Bab Builder';

  @override
  String get tBabFieldName => 'Nama Bab *';

  @override
  String get tBabExampleName => 'Contoh: Pengenalan Tag & Dokumen HTML';

  @override
  String get tBabXpTitle => 'XP Hadiah Bab';

  @override
  String get tBabXpHint => 'Diberikan saat siswa menuntaskan bab';

  @override
  String get tBabFlowTitle => 'Alur Slide';

  @override
  String tBabSlideCount(int count) {
    return '$count Unit';
  }

  @override
  String get tBabAddSlide => 'Tambah Slide';

  @override
  String get tBabDeleteSlide => 'Hapus slide';

  @override
  String get tBabEditSlideContent => 'Edit Konten Slide';

  @override
  String get tBabSaveChanges => 'Simpan Perubahan Bab';

  @override
  String get tBabSaveNew => 'Simpan Bab Baru';

  @override
  String get tBabPickerTitle => 'Pilih Jenis Slide Baru';

  @override
  String tBabFormatCount(int count) {
    return '$count Format';
  }

  @override
  String get tBabPickerHint =>
      'Ketuk ikon mata untuk melihat pratinjau simulasi koding, atau pilih langsung untuk menambahkan ke alur bab.';

  @override
  String get tBabPreviewFormatTooltip => 'Pratinjau Format Interaktif';

  @override
  String get tBabPickerAddTooltip => 'Tambahkan Slide';

  @override
  String get tBabBentoTitle => 'Pilih Jenis Slide / Latihan Koding';

  @override
  String get tBabBentoHint =>
      'Ketuk \"Pratinjau\" untuk simulasi koding siswa, atau tekan \"Gunakan\" untuk memasukkan ke alur bab.';

  @override
  String get tBabPreviewButton => 'Pratinjau';

  @override
  String get tBabUseButton => 'Gunakan';

  @override
  String get tBabTypeTheoryName => 'Teori & Konsep';

  @override
  String get tBabTypeTapName => 'Lengkapi Kode';

  @override
  String get tBabTypeTypeName => 'Ketik Kata Kunci';

  @override
  String get tBabTypeOutputName => 'Tebak Output';

  @override
  String get tBabTypeBugName => 'Bug Hunter';

  @override
  String get tBabTypeQuizName => 'Kuis Pilihan Ganda';

  @override
  String get tBabTypeOutroName => 'Rangkuman & Klaim XP';

  @override
  String get tBabTypeTheoryBadge => 'Bahan Baca';

  @override
  String get tBabTypeTapBadge => 'Interaktif';

  @override
  String get tBabTypeTypeBadge => 'Sintaks';

  @override
  String get tBabTypeOutputBadge => 'Logika';

  @override
  String get tBabTypeBugBadge => 'Debugging';

  @override
  String get tBabTypeQuizBadge => 'Evaluasi';

  @override
  String get tBabTypeOutroBadge => 'Pencapaian';

  @override
  String get tBabSheetDescTheory =>
      'Teks penjelasan konsep modul & contoh kode visual.';

  @override
  String get tBabSheetDescTap =>
      'Siswa mengetuk keping blok untuk melengkapi baris kode.';

  @override
  String get tBabSheetDescType =>
      'Latihan mengetik keyword atau ekspresi sintaksis.';

  @override
  String get tBabSheetDescOutput =>
      'Siswa menganalisis snippet dan memprediksi hasil keluaran terminal.';

  @override
  String get tBabSheetDescBug =>
      'Tantangan memperbaiki galat penulisan atau logika koding.';

  @override
  String get tBabSheetDescQuiz =>
      'Pertanyaan evaluasi pemahaman dengan 4 opsi pilihan.';

  @override
  String get tBabSheetDescOutro =>
      'Slide penutup bab dengan ringkasan capaian dan hadiah.';

  @override
  String get tBabBentoDescTheory =>
      'Teks bacaan terstruktur, markdown penjelasan, dan contoh kode.';

  @override
  String get tBabBentoDescTap =>
      'Fill-in-the-blanks dengan token kepingan kode terpandu.';

  @override
  String get tBabBentoDescType =>
      'Latihan muscle-memory mengetik keyword sintaksis spesifik.';

  @override
  String get tBabBentoDescOutput =>
      'Menganalisis baris kode dan memprediksi hasil luaran terminal.';

  @override
  String get tBabBentoDescBug =>
      'Menemukan baris kode yang rusak dan menentukan perbaikannya.';

  @override
  String get tBabBentoDescQuiz =>
      'Pertanyaan konseptual dengan 4 opsi pilihan dan pembahasan.';

  @override
  String get pyErrStringUnclosed => 'SyntaxError: string tidak ditutup';

  @override
  String pyErrFStringCloseBrace(String brace) {
    return 'SyntaxError: f-string: tanda $brace tidak ditemukan';
  }

  @override
  String get pyErrFStringEmptyExpr => 'SyntaxError: f-string: ekspresi kosong';

  @override
  String pyErrFStringStrayBrace(String brace) {
    return 'SyntaxError: f-string: tanda $brace di luar placeholder';
  }

  @override
  String get pyErrFStringUnclosed => 'SyntaxError: f-string tidak ditutup';

  @override
  String get pyErrTimeoutSeconds =>
      'RuntimeError: program dihentikan (melewati batas 5 detik)';

  @override
  String get pyErrStepLimit =>
      'RuntimeError: program dihentikan — melewati 100.000 langkah (periksa perulangan tanpa ujung)';

  @override
  String get pyErrBreakOutsideLoop =>
      'SyntaxError: \"break\" di luar perulangan';

  @override
  String get pyErrContinueOutsideLoop =>
      'SyntaxError: \"continue\" di luar perulangan';

  @override
  String get pyErrReturnOutsideFunction =>
      'SyntaxError: \'return\' di luar fungsi';

  @override
  String get pyErrElifWithoutIf =>
      'SyntaxError: invalid syntax (elif/else tanpa if)';

  @override
  String pyErrInvalidParam(String param) {
    return 'SyntaxError: parameter tidak valid -> $param';
  }

  @override
  String get pyErrInputNeedsDialog =>
      'RuntimeError: input() butuh dialog — jalankan dari halaman Playground';

  @override
  String get pyErrSumNeedsList =>
      'TypeError: sum() membutuhkan list sebagai argumen pertama';

  @override
  String pyErrUnknownOperator(String op) {
    return 'TypeError: operator \'$op\' tidak dikenal';
  }

  @override
  String tAnalyticsCodeCopied(String code) {
    return 'Kode kelas \"$code\" disalin ke clipboard!';
  }

  @override
  String get tAnalyticsRemoveTitle => 'Keluarkan Siswa';

  @override
  String tAnalyticsRemoveBody(String name, String className) {
    return 'Keluarkan $name dari $className?\n\nSiswa tidak akan muncul lagi di daftar dan peringkat kelas. Ia bisa bergabung kembali dengan kode kelas.';
  }

  @override
  String get tAnalyticsThisClass => 'kelas ini';

  @override
  String get tAnalyticsRemoveConfirm => 'Keluarkan';

  @override
  String tAnalyticsClassOptions(String name) {
    return 'Opsi Kelas: $name';
  }

  @override
  String get tAnalyticsRegenerateCode => 'Acak Ulang Kode Kelas';

  @override
  String get tAnalyticsRegenerateCodeSub => 'Hasilkan kode kelas baru.';

  @override
  String get tAnalyticsArchiveClass => 'Arsipkan Kelas';

  @override
  String get tAnalyticsArchiveClassSub => 'Siswa tidak dapat bergabung lagi.';

  @override
  String tAnalyticsHintMaterialSuffix(String title) {
    return ' yang sudah menuntaskan \"$title\"';
  }

  @override
  String tAnalyticsHintCompleted(String suffix) {
    return 'Modul Tuntas = siswa yang sudah menuntaskan minimal satu modul$suffix, diurutkan dari modul tuntas terbanyak.';
  }

  @override
  String get tAnalyticsPracticeRegular => 'latihan biasa (bukan mini proyek)';

  @override
  String get tAnalyticsPracticeMini => 'mini proyek';

  @override
  String get tAnalyticsPracticeAny => 'latihan apa pun (biasa + mini proyek)';

  @override
  String tAnalyticsHintPractice(String type, String suffix) {
    return 'Latihan Terbanyak = siswa yang sudah lulus minimal satu $type$suffix, diurutkan dari jumlah latihan lulus terbanyak.';
  }

  @override
  String get tAnalyticsNotStartedMaterial => 'belum menuntaskan satu modul pun';

  @override
  String get tAnalyticsNotStartedPractice =>
      'belum menyelesaikan satu latihan pun';

  @override
  String get tAnalyticsNotStartedBoth =>
      'belum menuntaskan modul dan belum menyelesaikan latihan';

  @override
  String tAnalyticsHintNotStarted(String scope, String suffix) {
    return 'Belum Memulai = siswa yang $scope$suffix, diurutkan dari siswa yang paling aktif berlatih.';
  }

  @override
  String tAnalyticsHintAll(String suffix) {
    return 'Semua = seluruh anggota kelas$suffix, diurutkan dari modul tuntas terbanyak lalu latihan lulus.';
  }

  @override
  String get tAnalyticsFilterByMaterial => 'Saring Daftar Siswa per Modul';

  @override
  String get tAnalyticsFilterByMaterialHint =>
      'Angka di tiap tombol = jumlah siswa yang sudah menuntaskan modul itu.';

  @override
  String tAnalyticsFilterAllMaterials(int count) {
    return 'Semua Modul ($count)';
  }

  @override
  String tAnalyticsFilterMaterialCount(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get tAnalyticsTrackBasisTitle => 'Dasar Nilai Kemajuan Per Track';

  @override
  String get tAnalyticsTrackBasisBody =>
      'Persentase tiap track = rata-rata progress_percent seluruh siswa kelas pada SEMUA modul resmi (kurikulum bawaan) di track itu.\n\n• Setiap pasangan siswa × modul dihitung satu baris, termasuk modul yang belum pernah dibuka (dianggap 0%).\n• Nilai 100% berarti seluruh siswa kelas sudah menuntaskan seluruh modul di track tersebut.\n• Modul buatan guru tidak dihitung (hanya kurikulum resmi).\n• Angka ini mengukur ketuntasan modul, bukan nilai latihan.';

  @override
  String get tAnalyticsGotIt => 'Mengerti';

  @override
  String get tAnalyticsNoStudents => 'Belum ada siswa.';

  @override
  String get tAnalyticsTitle => 'Analisa Kelas';

  @override
  String get tAnalyticsClassOptionsLabel => 'Opsi Kelas';

  @override
  String get tAnalyticsLoading => 'Memuat data analisa kelas...';

  @override
  String get tAnalyticsEmptyBody =>
      'Buat kelas pertamamu di Dashboard untuk memantau analisa kurikulum dan progres belajar siswa.';

  @override
  String get tAnalyticsLabClass => 'Kelas Laboratorium';

  @override
  String tAnalyticsAcademicYear(String year) {
    return 'Tahun Ajaran $year';
  }

  @override
  String get tAnalyticsClassCode => 'Kode Kelas';

  @override
  String get tAnalyticsReadyJoin => 'Siap Join';

  @override
  String get tAnalyticsShareCodeHint =>
      'Bagikan kode ini agar siswa dapat bergabung ke kelas:';

  @override
  String get tAnalyticsEnlarge => 'Perbesar ↗';

  @override
  String get tAnalyticsTrackTitle => 'Kemajuan Kurikulum Per Track';

  @override
  String get tAnalyticsTrackTooltip =>
      'Rata-rata progress semua siswa kelas pada semua modul resmi di track ini (modul yang belum dibuka = 0%).';

  @override
  String get tAnalyticsTrackSubtitle =>
      'Rata-rata ketuntasan seluruh siswa kelas pada semua modul resmi track tersebut.';

  @override
  String get tAnalyticsTrackEmpty =>
      'Data track akan terisi otomatis setelah siswa mulai belajar.';

  @override
  String get tAnalyticsHardestTitle => 'Bab Tersulit (Perlu Pendampingan)';

  @override
  String get tAnalyticsHardestEmpty =>
      'Tidak ada tantangan yang terdeteksi sulit pada kelas ini 🎉';

  @override
  String tAnalyticsFailCount(int count) {
    return '$count siswa gagal';
  }

  @override
  String get tAnalyticsRankingTitle => 'Peringkat Siswa Kelas';

  @override
  String tAnalyticsRankingTop(int top, int total) {
    return '$top teratas dari $total';
  }

  @override
  String tAnalyticsStudentCount(int count) {
    return '$count Siswa';
  }

  @override
  String tAnalyticsRankingHint(int max) {
    return 'Peringkat hanya menampilkan maksimal $max siswa dengan modul/latihan terbanyak. Semua siswa tetap tampil lengkap di bagian Daftar Siswa.';
  }

  @override
  String get tAnalyticsRankMaterial => 'Modul';

  @override
  String get tAnalyticsRankMaterialSub => 'Modul tuntas';

  @override
  String get tAnalyticsRankPractice => 'Latihan';

  @override
  String get tAnalyticsRankPracticeSub => 'Tantangan lulus';

  @override
  String get tAnalyticsRosterTitle => 'Daftar Siswa';

  @override
  String tAnalyticsFilterAllCount(int count) {
    return 'Semua ($count)';
  }

  @override
  String tAnalyticsFilterCompletedCount(int count) {
    return 'Modul Tuntas ($count)';
  }

  @override
  String get tAnalyticsFilterPractice => 'Latihan Terbanyak';

  @override
  String tAnalyticsFilterNotStartedCount(int count) {
    return 'Belum Memulai ($count)';
  }

  @override
  String get tAnalyticsPracticeAll => 'Semua Latihan';

  @override
  String get tAnalyticsPracticeRegularLabel => 'Latihan Biasa';

  @override
  String get tAnalyticsNotStartedAll => 'Modul & Latihan';

  @override
  String get tAnalyticsNotStartedMaterialLabel => 'Belum Kerjakan Modul';

  @override
  String get tAnalyticsNotStartedPracticeLabel => 'Belum Selesaikan Latihan';

  @override
  String get tAnalyticsRosterEmpty =>
      'Belum ada siswa yang bergabung di kelas ini.';

  @override
  String get tAnalyticsRosterFilterEmpty =>
      'Tidak ada siswa pada kategori filter ini.';

  @override
  String tAnalyticsRowPracticeDetail(int materials, int regular, int mini) {
    return '$materials modul tuntas • $regular latihan biasa • $mini mini proyek';
  }

  @override
  String tAnalyticsRowDetail(int materials, int practice) {
    return '$materials modul tuntas • $practice latihan lulus';
  }

  @override
  String tAnalyticsXp(int xp) {
    return '$xp XP';
  }

  @override
  String get tAnalyticsRemoveFromClass => 'Keluarkan dari kelas';

  @override
  String get tSlideFormHelpTheoryTitle =>
      'Judul tampil paling atas di layar siswa.\n- Buat ringkas dan spesifik, maksimal 120 karakter.\n- Sebut inti konsepnya, bukan nama bab.';

  @override
  String get tSlideFormHelpTheoryContent =>
      'Cara menulis isi modul:\n- Pisahkan paragraf dengan satu baris kosong.\n- Baris yang diawali \"- \" atau \"* \" otomatis jadi butir daftar.\n- Selain itu teks ditampilkan apa adanya: **tebal**, # judul, tautan, dan `kode` tidak diformat.\n\nContoh:\nHTML adalah bahasa penanda untuk menyusun halaman web.\n\n- Tag dibuka lalu ditutup.\n- Atribut menempel pada tag pembuka.';

  @override
  String get tSlideFormHelpCodeFileSample =>
      'Hanya menentukan nama berkas pada kartu kode:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py';

  @override
  String get tSlideFormHelpSampleCode =>
      'Kode contoh yang tampil di kotak kode di bawah penjelasan.\n- Kosongkan bila slide tidak perlu contoh kode.\n- Tulis kode aslinya saja, tanpa penanda blok markdown.\n- Maksimal 8000 karakter.';

  @override
  String get tSlideFormHelpExerciseTitle =>
      'Judul tampil di kepala soal, maksimal 120 karakter.\nContoh: \"Lengkapi Tag Penutup HTML\".';

  @override
  String get tSlideFormHelpShortInstruction =>
      'Satu sampai dua kalimat arahan sebelum siswa mengetuk slot.\n- Jelaskan bagian mana yang harus dilengkapi.\n- Jangan sebut jawabannya di sini.';

  @override
  String get tSlideFormHelpCodeTemplate =>
      'Tempel kode di sini, lalu tandai bagian kosong dengan ___1___, ___2___, dan seterusnya.\n- Penanda dikenali selama memakai minimal dua garis bawah di awal dan akhir, dengan angka opsional di tengah.\n- Urutan slot mengikuti urutan kemunculannya di dalam kode.\n- Satu slot berarti satu jawaban; jangan menaruh dua slot untuk jawaban yang sama.\n\nContoh:\nx = ___1___\nprint(x)';

  @override
  String get tSlideFormHelpSlotAnswers =>
      'Isi jawaban benar untuk setiap slot sesuai urutan kemunculan.\n- Spasi di awal/akhir diabaikan, tetapi huruf besar-kecil dihitung: tulis \"print\", bukan \"Print\".\n- Tulis persis seperti yang seharusnya ada di dalam kode.\n- Jumlah isian mengikuti jumlah slot yang terdeteksi.';

  @override
  String get tSlideFormHelpDistractors =>
      'Kata tambahan yang muncul sebagai pilihan, tetapi bukan jawaban benar.\n- Pisahkan dengan koma.\n- Pengecoh yang sama dengan kunci otomatis dibuang.\n- Sisakan minimal satu agar siswa benar-benar harus memilih.';

  @override
  String get tSlideFormHelpCodeFile =>
      'Menentukan nama berkas pada kartu kode:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py';

  @override
  String get tSlideFormHelpQuestionTitle =>
      'Judul tampil di kepala soal, maksimal 120 karakter.\nContoh: \"Deklarasi Variabel Python\".';

  @override
  String get tSlideFormHelpInteractiveInstruction =>
      'Arahan singkat yang dibaca siswa sebelum mengetik.\n- Sebutkan apa yang harus dicari tanpa memberi jawabannya.\n- Maksimal 300 karakter.';

  @override
  String get tSlideFormHelpQuestionCode =>
      'Tulis potongan kode, lalu ganti bagian yang harus diisi dengan [KETIK_DISINI].\n- Penanda itu berubah menjadi kotak input di layar siswa.\n- Boleh lebih dari satu penanda dalam satu slide.\n- Tanpa penanda, siswa tidak punya tempat mengetik jawaban.';

  @override
  String get tSlideFormHelpAnswerKeyword =>
      'Jawaban yang dianggap benar.\n- Perbandingan mengabaikan spasi awal/akhir dan huruf besar-kecil, jadi \"Print\" sama dengan \"print\".\n- Isi satu kata kunci atau ekspresi pendek saja.';

  @override
  String get tSlideFormHelpWrongHint =>
      'Bantuan yang muncul ketika jawaban siswa salah.\n- Beri petunjuk arah, jangan tulis jawabannya langsung.\n- Satu sampai dua kalimat sudah cukup.';

  @override
  String get tSlideFormHelpSlideTitle =>
      'Judul tampil di kepala slide, maksimal 120 karakter.\nContoh: \"Tebak Output Operator Modulo\".';

  @override
  String get tSlideFormHelpChallengeInstruction =>
      'Pertanyaan singkat di atas blok kode.\nBiasanya cukup: \"Apakah output yang dicetak ke terminal?\".';

  @override
  String get tSlideFormHelpSourceCode =>
      'Kode yang dibaca siswa untuk menebak output.\n- Tulis persis seperti program aslinya.\n- Kode hanya ditampilkan, tidak dijalankan, jadi hasilnya harus bisa ditebak dari isi kode.';

  @override
  String get tSlideFormHelpOutputChoices =>
      'Isi keempat pilihan (A sampai D).\n- Ketuk lingkaran di kiri untuk menandai kunci jawaban.\n- Satu pilihan harus persis sama dengan output sebenarnya.\n- Jangan biarkan pilihan kosong: pilihan kosong tetap tampil di layar siswa.';

  @override
  String get tSlideFormHelpOutputExplanation =>
      'Muncul setelah siswa menjawab, benar maupun salah.\nJelaskan alasan output itu muncul, misalnya urutan operasi atau tipe data yang terlibat.';

  @override
  String get tSlideFormHelpChallengeTitle =>
      'Judul tampil di kepala tantangan, maksimal 120 karakter.\nContoh: \"Mencari Kesalahan Loop For\".';

  @override
  String get tSlideFormHelpScenario =>
      'Konteks singkat masalah yang dihadapi siswa; tampil sebagai instruksi di atas kode.\nCeritakan situasinya, jangan sebut nomor baris yang salah.';

  @override
  String get tSlideFormHelpBuggyCode =>
      'Seluruh kode yang mengandung bug.\n- Nomor baris dihitung dari 1 mengikuti urutan baris di kotak ini, termasuk baris kosong.\n- Sisipkan bug yang benar-benar bisa dijelaskan oleh \"Jenis Error\" dan \"Kode Perbaikan\".';

  @override
  String get tSlideFormHelpTargetLine =>
      'Nomor baris yang benar, dihitung dari 1.\n- Harus berada di antara 1 dan jumlah baris kode di atas.\n- Bila di luar jangkauan, layar siswa mengunci ke baris terdekat sehingga jawaban tidak pernah cocok.';

  @override
  String get tSlideFormHelpErrorType =>
      'Label kategori galat yang tampil ke siswa.\nContoh: SyntaxError, IndentationError, NameError.';

  @override
  String get tSlideFormHelpBugHint =>
      'Teks ini menjadi penjelasan yang muncul setelah siswa menjawab.\n- Jelaskan aturan yang dilanggar di baris tersebut.\n- Bila dikosongkan, \"Kode Perbaikan Valid\" yang dipakai sebagai penjelasan.';

  @override
  String get tSlideFormHelpFixCode =>
      'Cuplikan perbaikan yang benar untuk baris yang ditandai.\n- Dipakai sebagai contoh solusi sekaligus penjelasan cadangan bila \"Pesan Indikator\" kosong.\n- Tulis hanya bagian yang diperbaiki, bukan seluruh program.';

  @override
  String get tSlideFormHelpQuizTitle =>
      'Judul tampil di kepala kuis, maksimal 120 karakter.\nContoh: \"Memahami Tipe Data\".';

  @override
  String get tSlideFormHelpQuizQuestion =>
      'Pertanyaan dengan satu jawaban benar.\n- Ajukan satu konsep saja, jangan digabung.\n- Maksimal 300 karakter.';

  @override
  String get tSlideFormHelpAnswerChoices =>
      'Isi keempat pilihan (A sampai D).\n- Ketuk lingkaran di kiri untuk menandai kunci jawaban.\n- Jangan biarkan pilihan kosong karena tetap tampil sebagai opsi kosong di layar siswa.';

  @override
  String get tSlideFormHelpFeedback =>
      'Muncul setelah siswa menjawab, benar maupun salah.\nJelaskan mengapa kunci jawabannya benar dan, bila perlu, mengapa pengecohnya salah.';

  @override
  String get tSlideFormHelpOutroTitle =>
      'Judul tampil di kepala slide penutup, maksimal 120 karakter.\nContoh: \"Rangkuman Bab\".';

  @override
  String get tSlideFormHelpSummary =>
      'Ringkasan yang dibaca siswa di akhir bab.\n- Sebut kembali konsep utama yang baru dipelajari.\n- Beri penutup yang memotivasi, bukan soal baru.';

  @override
  String get tSlideFormHelpMasteredConcepts =>
      'Daftar konsep yang dianggap dikuasai setelah bab ini.\n- Pisahkan dengan koma, misalnya: Variabel, Perulangan.\n- Setiap konsep tampil sebagai label capaian.\n- Isi minimal satu konsep.';

  @override
  String get tSlideFormHintTheoryTitleExample =>
      'Contoh: Struktur Dasar Dokumen HTML5';

  @override
  String get tSlideFormHintTheoryContent =>
      'Tuliskan konsep utama, poin-poin, atau contoh...';

  @override
  String get tSlideFormHintExerciseTitleExample =>
      'Contoh: Lengkapi Tag Penutup HTML';

  @override
  String get tSlideFormHintShortInstruction =>
      'Instruksi pengerjaan bagi siswa...';

  @override
  String get tSlideFormHintQuestionTitleExample =>
      'Contoh: Deklarasi Variabel Python';

  @override
  String get tSlideFormHintInteractiveInstruction =>
      'Ketikkan kata kunci untuk mendeklarasikan variabel...';

  @override
  String get tSlideFormHintAnswerKeywordExample => 'Contoh: def / const / let';

  @override
  String get tSlideFormHintWrongHint => 'Ingat penulisan huruf kecil semua.';

  @override
  String get tSlideFormHintSlideTitleExample =>
      'Contoh: Tebak Output Operator Modulo';

  @override
  String get tSlideFormHintChallengeInstruction =>
      'Apakah output yang dicetak ke terminal?';

  @override
  String get tSlideFormHintOutputExplanation =>
      'Mengapa output tersebut yang muncul?';

  @override
  String get tSlideFormHintChallengeTitleExample =>
      'Contoh: Mencari Kesalahan Loop For';

  @override
  String get tSlideFormHintScenario => 'Deskripsi konteks masalah...';

  @override
  String get tSlideFormHintTargetLineExample => 'Contoh: 2';

  @override
  String get tSlideFormHintBugHint =>
      'Kurang tanda titik dua (:) di akhir pernyataan for';

  @override
  String get tSlideFormHintQuizTitleExample => 'Contoh: Memahami Tipe Data';

  @override
  String get tSlideFormHintQuizQuestion => 'Tuliskan pertanyaan konseptual...';

  @override
  String get tSlideFormHintFeedback => 'Mengapa opsi tersebut benar?';

  @override
  String get tSlideFormHintOutroTitleExample => 'Contoh: Rangkuman Bab';

  @override
  String get tSlideFormHintSummary =>
      'Ringkasan capaian siswa setelah menuntaskan bab...';

  @override
  String get tSlideFormHintMasteredConcepts =>
      'Variabel, Percabangan, Perulangan';

  @override
  String tSlideFormSlotAnswerCount(int count) {
    return 'Kunci jawaban per slot ($count slot terdeteksi)';
  }

  @override
  String tSlideFormSlot(int n) {
    return 'Slot $n';
  }

  @override
  String tSlideFormSlotAnswerHint(int n) {
    return 'Jawaban benar untuk slot $n';
  }

  @override
  String get tSlideFormNoSlotsHint =>
      'Tambahkan penanda ___1___, ___2___, dan seterusnya pada template.';

  @override
  String tSlideFormXpNote(int xp) {
    return 'Siswa otomatis mengklaim $xp XP saat mencapai slide ini.';
  }

  @override
  String get tPreviewInteractiveFormat => 'Pratinjau Format Interaktif';

  @override
  String tPreviewSheetTitle(String title) {
    return 'Pratinjau Tipe Slide: $title';
  }

  @override
  String get tPreviewBenefits => 'Manfaat Pedagogis';

  @override
  String get tPreviewReward => 'Imbalan Siswa';

  @override
  String get tPreviewModuleType => 'Tipe Modul';

  @override
  String get tPreviewUseType => 'Gunakan Tipe Ini';

  @override
  String get tPreviewSimulation => 'Simulasi Siswa Aktif';

  @override
  String get tPreviewPhoneScreen => 'Layar Ponsel';

  @override
  String get tPreviewAnswerChoices => 'Pilihan jawaban untuk siswa:';

  @override
  String get tPreviewSubtitleTapToFill =>
      'Simulasi bagaimana siswa berinteraksi dengan latihan ini di ponsel secara langsung.';

  @override
  String get tPreviewTechTapToFill => 'HTML • V1.2';

  @override
  String get tPreviewPromptTapToFill =>
      'Lengkapi tag penutup yang tepat: Baris 4';

  @override
  String get tPreviewFeedbackTapToFill =>
      'Siswa mendapat umpan balik instan saat memilih kepingan kode.';

  @override
  String get tPreviewBenefitTapToFill =>
      'Melatih penguasaan sintaksis dasar tanpa beban mengetik panjang di papan ketik layar sentuh HP.';

  @override
  String get tPreviewSubtitleTheory =>
      'Teks bacaan terstruktur, markdown penjelasan, dan cuplikan kode contoh.';

  @override
  String get tPreviewTechTheory => 'Markdown • Teori';

  @override
  String get tPreviewPromptTheory => 'Modul Pembuka & Pengenalan Logika';

  @override
  String get tPreviewFeedbackTheory =>
      'Mendukung format Markdown, syntax highlighter, dan kotak callout tips guru.';

  @override
  String get tPreviewBenefitTheory =>
      'Membangun landasan pemahaman konseptual yang kuat sebelum siswa masuk ke sesi latihan interaktif.';

  @override
  String get tPreviewSubtitleTypeCode =>
      'Latihan muscle-memory mengetikkan keyword sintaksis spesifik.';

  @override
  String get tPreviewTechTypeCode => 'Python • Sintaks';

  @override
  String get tPreviewPromptTypeCode =>
      'Ketikkan kata kunci untuk membuat fungsi di Python:';

  @override
  String get tPreviewFeedbackTypeCode =>
      'Dilengkapi validasi case-sensitive dan hint otomatis saat siswa keliru.';

  @override
  String get tPreviewBenefitTypeCode =>
      'Membiasakan siswa dengan penulisan sintaksis yang presisi dan melatih ketelitian pengetikan reserved-words.';

  @override
  String get tPreviewSubtitleOutputPredict =>
      'Siswa menganalisis baris program dan memprediksi hasil running terminal.';

  @override
  String get tPreviewTechOutputPredict => 'Console • Logika';

  @override
  String get tPreviewPromptOutputPredict =>
      'Apakah output yang dicetak oleh operasi modulus berikut?';

  @override
  String get tPreviewFeedbackOutputPredict =>
      'Tampilan opsi bergaya konsol terminal gelap untuk simulasi nyata.';

  @override
  String get tPreviewBenefitOutputPredict =>
      'Melatih kemampuan mental execution algoritma dan tracing variabel tanpa ketergantungan debugger.';

  @override
  String get tPreviewTitleBugHunter => 'Bug Hunter (Cari Galat)';

  @override
  String get tPreviewSubtitleBugHunter =>
      'Tantangan menemukan baris kode yang rusak dan memperbaikinya.';

  @override
  String get tPreviewTechBugHunter => 'Python • Debug';

  @override
  String get tPreviewPromptBugHunter =>
      'Temukan baris yang mengandung kesalahan sintaksis:';

  @override
  String get tPreviewFeedbackBugHunter =>
      'Siswa mengetuk nomor baris yang bermasalah untuk memicu bimbingan AI.';

  @override
  String get tPreviewBenefitBugHunter =>
      'Mengasah intuisi problem-solving dan kemampuan membaca kode orang lain yang merupakan inti skill developer.';

  @override
  String get tPreviewSubtitleQuiz =>
      'Pertanyaan evaluasi pemahaman dengan 4 opsi pilihan dan pembahasan.';

  @override
  String get tPreviewTechQuiz => 'Evaluasi • Konsep';

  @override
  String get tPreviewPromptQuiz =>
      'Apa fungsi utama dari deklarasi <!DOCTYPE html>?';

  @override
  String get tPreviewFeedbackQuiz =>
      'Dilengkapi pembahasan otomatis yang tampil setelah siswa menjawab.';

  @override
  String get tPreviewBenefitQuiz =>
      'Mengukur daya serap modul secara obyektif dan cepat di akhir sesi pembahasan.';

  @override
  String get tPreviewSubtitleOutro =>
      'Slide penutup bab dengan rekap modul yang dikuasai dan klaim hadiah.';

  @override
  String get tPreviewTechOutro => 'Pencapaian • Penutup';

  @override
  String get tPreviewPromptOutro =>
      'Selamat! Kamu telah menyelesaikan seluruh latihan di bab ini.';

  @override
  String get tPreviewFeedbackOutro =>
      'Otomatis dibuat di akhir alur pembelajaran bab.';

  @override
  String get tPreviewBenefitOutro =>
      'Memberikan kepuasan pencapaian (gamification) dan merangkum poin-poin penting modul.';

  @override
  String get tSettingsAvatarTooBig => 'Ukuran foto maksimal 2 MB.';

  @override
  String get tSettingsFallbackTeacher => 'Guru';

  @override
  String tSettingsNameDegree(String name) {
    return '$name & Gelar *';
  }

  @override
  String get tSettingsIdentityTitle => 'Identitas Pengajar';

  @override
  String get tSettingsBioContact => 'Bio & Kontak';

  @override
  String get tSettingsBioHint =>
      'Tuliskan pengalaman mengajar atau bidang spesialisasi kodingmu...';

  @override
  String get tSettingsAddressHint => 'Alamat domisili pengajar';

  @override
  String get tSettingsSecurityTitle => 'Keamanan Akun';

  @override
  String get tSettingsChangePassword => 'Ubah Kata Sandi';

  @override
  String get tFieldHelpGotIt => 'Mengerti';

  @override
  String get tTeacherErrServerFallback => 'Ada kendala pada server.';

  @override
  String get tTeacherErrInvalidLesson => 'Format data modul tidak valid.';

  @override
  String get tTeacherErrInvalidBab => 'Format data bab tidak valid.';

  @override
  String get tTeacherErrInvalidClass => 'Format data kelas tidak valid.';

  @override
  String tCubitClassCreated(String name) {
    return 'Kelas $name berhasil dibuat.';
  }

  @override
  String get tCubitClassArchived => 'Kelas dipindahkan ke arsip.';

  @override
  String get tCubitClassRestored => 'Kelas berhasil dipulihkan.';

  @override
  String tCubitClassCodeNew(String code) {
    return 'Kode kelas baru: $code';
  }

  @override
  String get tCubitLessonCreated => 'Modul baru berhasil dibuat.';

  @override
  String get tCubitLessonPublished => 'Modul berhasil diterbitkan.';

  @override
  String get tCubitLessonDrafted => 'Modul dikembalikan ke draft.';

  @override
  String get tCubitLessonDeleted => 'Modul berhasil dihapus.';

  @override
  String get tCubitLessonDuplicated => 'Modul berhasil diduplikasi.';

  @override
  String tCubitBabDuplicated(String title) {
    return 'Bab \"$title\" berhasil diduplikat.';
  }

  @override
  String get tCubitBabDeleted => 'Bab berhasil dihapus.';

  @override
  String get tCubitBabOrderUpdated => 'Urutan bab diperbarui.';

  @override
  String get tCubitStudentRemoved => 'Siswa dikeluarkan dari kelas.';

  @override
  String tCubitStudentRemovedNamed(String name) {
    return '$name dikeluarkan dari kelas.';
  }

  @override
  String get tCubitConnectionFailed =>
      'Gagal terhubung ke server. Periksa koneksi lalu coba lagi.';

  @override
  String get tAdapterEmptyBab => 'Bab ini belum memiliki slide.';

  @override
  String get tAdapterPreviewTopic => 'Pratinjau Guru';

  @override
  String get tAdapterPreviewMode => 'Mode Simulator Pratinjau Guru';

  @override
  String get tAdapterTypeCodeInstruction => 'Lengkapi kode berikut:';

  @override
  String get tAdapterOutputQuestion => 'Apakah output dari kode di atas?';

  @override
  String get tAdapterBugInstruction => 'Cari baris yang bermasalah:';

  @override
  String get tAdapterBugExplanation => 'Periksa sintaks pada baris ini.';

  @override
  String get tAdapterQuizQuestion => 'Pertanyaan kuis:';

  @override
  String get tAdapterOutroSummary =>
      'Selamat! Kamu telah menyelesaikan bab ini.';

  @override
  String get tAdapterLearningTime => '3 Menit';

  @override
  String get tAdapterMainConcept => 'Konsep Utama';

  @override
  String get tTemplateLabelTapToFill => 'Lengkapi Kode (Tap)';

  @override
  String get tTemplateLabelTypeCode => 'Ketik Kata Kunci';

  @override
  String get tTemplateLabelOutputPredict => 'Tebak Output Kode';

  @override
  String get tTemplateLabelBugHunter => 'Bug Hunter';

  @override
  String get tTemplateLabelQuiz => 'Kuis Pilihan Ganda';

  @override
  String get tTemplateLabelOutro => 'Rangkuman & Klaim XP';

  @override
  String get tTemplateLabelTheory => 'Teori & Konsep';

  @override
  String get tTemplateBadgeInteractive => 'Interaktif';

  @override
  String get tTemplateBadgeSyntax => 'Sintaks';

  @override
  String get tTemplateBadgeLogic => 'Logika';

  @override
  String get tTemplateBadgeDebugging => 'Debugging';

  @override
  String get tTemplateBadgeEvaluation => 'Evaluasi';

  @override
  String get tTemplateBadgeAchievement => 'Pencapaian';

  @override
  String get tTemplateBadgeReading => 'Bahan Baca';

  @override
  String get tTemplateDescTapToFill =>
      'Siswa mengetuk keping blok untuk melengkapi baris kode.';

  @override
  String get tTemplateDescTypeCode =>
      'Siswa mengetik kata kunci atau ekspresi sintaksis.';

  @override
  String get tTemplateDescOutputPredict =>
      'Siswa memprediksi keluaran terminal dari potongan kode.';

  @override
  String get tTemplateDescBugHunter =>
      'Siswa menemukan baris yang bermasalah dan perbaikannya.';

  @override
  String get tTemplateDescQuiz =>
      'Pertanyaan pilihan ganda dengan satu jawaban benar.';

  @override
  String get tTemplateDescOutro =>
      'Slide penutup dengan rangkuman dan hadiah XP.';

  @override
  String get tTemplateDescTheory =>
      'Teks penjelasan konsep modul dan contoh kode.';

  @override
  String get tTemplateTitleTapToFill => 'Lengkapi Kode';

  @override
  String get tTemplatePromptTapToFill =>
      'Ketuk balok kode untuk melengkapi baris berikut.';

  @override
  String get tTemplatePromptTypeCode =>
      'Ketikkan fungsi untuk mencetak teks ke layar:';

  @override
  String get tTemplateHintTypeCode => 'Gunakan huruf kecil semua.';

  @override
  String get tTemplateTitleOutputPredict => 'Tebak Output';

  @override
  String get tTemplatePromptOutputPredict =>
      'Apakah output yang dicetak ke terminal?';

  @override
  String get tTemplateExplanationOutputPredict =>
      'Operator + menjumlahkan dua bilangan bulat.';

  @override
  String get tTemplateTitleBugHunter => 'Temukan Galat (Bug)';

  @override
  String get tTemplateScenarioBugHunter =>
      'Siswa memeriksa program yang gagal dijalankan.';

  @override
  String get tTemplateBugHintBugHunter =>
      'Periksa tanda titik dua di akhir baris for.';

  @override
  String get tTemplateQuestionQuiz =>
      'Manakah yang termasuk tipe data angka bulat?';

  @override
  String get tTemplateExplanationQuiz => 'int adalah tipe data bilangan bulat.';

  @override
  String get tTemplateTitleOutro => 'Rangkuman Bab';

  @override
  String get tTemplateSummaryOutro =>
      'Hebat! Kamu telah menuntaskan modul pada bab ini.';

  @override
  String get tTemplateTitleTheory => 'Penjelasan Modul Baru';

  @override
  String get tTemplateContentTheory =>
      'Tuliskan penjelasan modul pembelajaran di sini dengan bahasa yang mudah dipahami siswa.';
}
