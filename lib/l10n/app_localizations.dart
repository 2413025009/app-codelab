import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('id'),
  ];

  /// Label tab bawah untuk beranda materi siswa.
  ///
  /// In id, this message translates to:
  /// **'Belajar'**
  String get navLearn;

  /// No description provided for @navChallenges.
  ///
  /// In id, this message translates to:
  /// **'Tantangan'**
  String get navChallenges;

  /// No description provided for @navPlayground.
  ///
  /// In id, this message translates to:
  /// **'Playground'**
  String get navPlayground;

  /// No description provided for @navProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @actionCancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get actionCancel;

  /// No description provided for @actionClose.
  ///
  /// In id, this message translates to:
  /// **'Tutup'**
  String get actionClose;

  /// No description provided for @actionRetry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get actionRetry;

  /// No description provided for @actionDelete.
  ///
  /// In id, this message translates to:
  /// **'Hapus'**
  String get actionDelete;

  /// No description provided for @actionBack.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get actionBack;

  /// No description provided for @actionSend.
  ///
  /// In id, this message translates to:
  /// **'Kirim'**
  String get actionSend;

  /// No description provided for @settingsTitle.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan'**
  String get settingsTitle;

  /// No description provided for @settingsAccountTag.
  ///
  /// In id, this message translates to:
  /// **'PENGATURAN AKUN'**
  String get settingsAccountTag;

  /// No description provided for @settingsRoleTeacher.
  ///
  /// In id, this message translates to:
  /// **'Guru / Pengajar'**
  String get settingsRoleTeacher;

  /// No description provided for @settingsRoleStudent.
  ///
  /// In id, this message translates to:
  /// **'Siswa RPL • Tingkat Pemula'**
  String get settingsRoleStudent;

  /// No description provided for @settingsChangePhoto.
  ///
  /// In id, this message translates to:
  /// **'Ganti Foto'**
  String get settingsChangePhoto;

  /// No description provided for @settingsEditModeHint.
  ///
  /// In id, this message translates to:
  /// **'Mode edit aktif — ubah datamu, lalu tekan \"Simpan Perubahan\".'**
  String get settingsEditModeHint;

  /// No description provided for @settingsFieldFullName.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get settingsFieldFullName;

  /// No description provided for @settingsFieldFullNameAside.
  ///
  /// In id, this message translates to:
  /// **'Maks 40 karakter'**
  String get settingsFieldFullNameAside;

  /// No description provided for @settingsFullNameEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama tidak boleh kosong'**
  String get settingsFullNameEmpty;

  /// No description provided for @settingsFieldNisn.
  ///
  /// In id, this message translates to:
  /// **'NISN / ID Siswa'**
  String get settingsFieldNisn;

  /// No description provided for @settingsBadgeVerifiedDapodik.
  ///
  /// In id, this message translates to:
  /// **'Terverifikasi Dapodik'**
  String get settingsBadgeVerifiedDapodik;

  /// No description provided for @settingsFieldSchool.
  ///
  /// In id, this message translates to:
  /// **'Nama Sekolah / Institusi'**
  String get settingsFieldSchool;

  /// No description provided for @settingsFieldClass.
  ///
  /// In id, this message translates to:
  /// **'Kelas & Jurusan'**
  String get settingsFieldClass;

  /// No description provided for @settingsFieldAddress.
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get settingsFieldAddress;

  /// No description provided for @settingsFieldStaffCode.
  ///
  /// In id, this message translates to:
  /// **'Kode Kepegawaian (NIP/NIK)'**
  String get settingsFieldStaffCode;

  /// No description provided for @settingsFieldAffiliatedSchool.
  ///
  /// In id, this message translates to:
  /// **'Sekolah Terafiliasi'**
  String get settingsFieldAffiliatedSchool;

  /// No description provided for @settingsBadgeVerified.
  ///
  /// In id, this message translates to:
  /// **'Terverifikasi'**
  String get settingsBadgeVerified;

  /// No description provided for @settingsFieldPhone.
  ///
  /// In id, this message translates to:
  /// **'Nomor Handphone / WhatsApp'**
  String get settingsFieldPhone;

  /// No description provided for @settingsPhoneIncomplete.
  ///
  /// In id, this message translates to:
  /// **'Nomor belum lengkap. Contoh: 81234567890'**
  String get settingsPhoneIncomplete;

  /// No description provided for @settingsPhoneHelper.
  ///
  /// In id, this message translates to:
  /// **'Tulis tanpa 0 di depan, contoh: 81234567890'**
  String get settingsPhoneHelper;

  /// No description provided for @settingsFieldTeacherEmail.
  ///
  /// In id, this message translates to:
  /// **'Email Pengajar'**
  String get settingsFieldTeacherEmail;

  /// No description provided for @settingsFieldStudentEmail.
  ///
  /// In id, this message translates to:
  /// **'Email Akun Belajar'**
  String get settingsFieldStudentEmail;

  /// No description provided for @settingsEmailAside.
  ///
  /// In id, this message translates to:
  /// **'Wajib @smk.belajar.id'**
  String get settingsEmailAside;

  /// No description provided for @settingsFieldTeacherBio.
  ///
  /// In id, this message translates to:
  /// **'Bio / Catatan Pengajar'**
  String get settingsFieldTeacherBio;

  /// No description provided for @settingsFieldStudentBio.
  ///
  /// In id, this message translates to:
  /// **'Bio / Catatan Belajar'**
  String get settingsFieldStudentBio;

  /// No description provided for @settingsFieldBioAside.
  ///
  /// In id, this message translates to:
  /// **'Maks 120 karakter'**
  String get settingsFieldBioAside;

  /// No description provided for @settingsSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan'**
  String get settingsSaveChanges;

  /// No description provided for @settingsCancelEdit.
  ///
  /// In id, this message translates to:
  /// **'Batalkan'**
  String get settingsCancelEdit;

  /// No description provided for @settingsEditData.
  ///
  /// In id, this message translates to:
  /// **'Edit Data'**
  String get settingsEditData;

  /// No description provided for @settingsPreferencesHeader.
  ///
  /// In id, this message translates to:
  /// **'PREFERENSI APLIKASI'**
  String get settingsPreferencesHeader;

  /// No description provided for @settingsLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Aplikasi'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Indonesia, English, atau العربية'**
  String get settingsLanguageSubtitle;

  /// No description provided for @settingsDarkMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Gelap'**
  String get settingsDarkMode;

  /// No description provided for @settingsDarkModeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Tema gelap untuk mata yang lebih nyaman'**
  String get settingsDarkModeSubtitle;

  /// No description provided for @settingsSfx.
  ///
  /// In id, this message translates to:
  /// **'Efek Suara Aplikasi'**
  String get settingsSfx;

  /// No description provided for @settingsSfxSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Suara popup, notifikasi, dan kuis'**
  String get settingsSfxSubtitle;

  /// No description provided for @settingsLabSfx.
  ///
  /// In id, this message translates to:
  /// **'Efek Suara Lab'**
  String get settingsLabSfx;

  /// No description provided for @settingsLabSfxSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Audio saat eksekusi kode & terminal'**
  String get settingsLabSfxSubtitle;

  /// No description provided for @settingsAccountLabHeader.
  ///
  /// In id, this message translates to:
  /// **'PENGATURAN AKUN & LAB'**
  String get settingsAccountLabHeader;

  /// No description provided for @settingsCurriculum.
  ///
  /// In id, this message translates to:
  /// **'Kurikulum Merdeka'**
  String get settingsCurriculum;

  /// No description provided for @settingsCurriculumSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Sinkron • Pak Budi (Guru Pembimbing)'**
  String get settingsCurriculumSubtitle;

  /// No description provided for @settingsActive.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get settingsActive;

  /// No description provided for @settingsHelpCenter.
  ///
  /// In id, this message translates to:
  /// **'Pusat Bantuan Lab'**
  String get settingsHelpCenter;

  /// No description provided for @settingsHelpCenterSubtitle.
  ///
  /// In id, this message translates to:
  /// **'FAQ Compiler AI & Panduan Guru'**
  String get settingsHelpCenterSubtitle;

  /// No description provided for @settingsChangePassword.
  ///
  /// In id, this message translates to:
  /// **'Ubah Password'**
  String get settingsChangePassword;

  /// No description provided for @settingsChangePasswordSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi lama & baru dengan checklist keamanan'**
  String get settingsChangePasswordSubtitle;

  /// No description provided for @settingsChangePasswordSheetSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Aturan sandi sama seperti saat kamu mendaftar akun.'**
  String get settingsChangePasswordSheetSubtitle;

  /// No description provided for @settingsLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar Akun (Log Out)'**
  String get settingsLogout;

  /// No description provided for @settingsLogoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Akun?'**
  String get settingsLogoutTitle;

  /// No description provided for @settingsLogoutBody.
  ///
  /// In id, this message translates to:
  /// **'Apakah kamu yakin ingin keluar dari sesi latihan lab saat ini?'**
  String get settingsLogoutBody;

  /// No description provided for @settingsLogoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Ya, Keluar'**
  String get settingsLogoutConfirm;

  /// No description provided for @settingsAvatarDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Foto Profil?'**
  String get settingsAvatarDeleteTitle;

  /// No description provided for @settingsAvatarDeleteBody.
  ///
  /// In id, this message translates to:
  /// **'Foto akan dihapus dari akunmu. Kamu bisa mengunggah foto baru kapan saja.'**
  String get settingsAvatarDeleteBody;

  /// No description provided for @settingsAvatarMaxSize.
  ///
  /// In id, this message translates to:
  /// **'Ukuran foto maksimal 2 MB.'**
  String get settingsAvatarMaxSize;

  /// No description provided for @settingsAvatarUpdated.
  ///
  /// In id, this message translates to:
  /// **'Foto profil berhasil diperbarui.'**
  String get settingsAvatarUpdated;

  /// No description provided for @settingsAvatarDeleted.
  ///
  /// In id, this message translates to:
  /// **'Foto profil dihapus.'**
  String get settingsAvatarDeleted;

  /// No description provided for @settingsAvatarProcessFailed.
  ///
  /// In id, this message translates to:
  /// **'Foto profil gagal diproses. Periksa izin galeri dan koneksi, lalu coba lagi.'**
  String get settingsAvatarProcessFailed;

  /// No description provided for @settingsAvatarDeleteFailed.
  ///
  /// In id, this message translates to:
  /// **'Foto profil gagal dihapus. Periksa koneksi lalu coba lagi.'**
  String get settingsAvatarDeleteFailed;

  /// No description provided for @settingsProfileSaved.
  ///
  /// In id, this message translates to:
  /// **'Perubahan profil berhasil disimpan!'**
  String get settingsProfileSaved;

  /// No description provided for @settingsProfileSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal menyimpan profil. Coba lagi.'**
  String get settingsProfileSaveFailed;

  /// No description provided for @settingsLanguageSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Aplikasi'**
  String get settingsLanguageSheetTitle;

  /// No description provided for @settingsLanguageSheetSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Berlaku untuk seluruh layar CodeLab AI'**
  String get settingsLanguageSheetSubtitle;

  /// No description provided for @languageIndonesian.
  ///
  /// In id, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In id, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In id, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @playgroundReset.
  ///
  /// In id, this message translates to:
  /// **'Reset'**
  String get playgroundReset;

  /// No description provided for @playgroundRun.
  ///
  /// In id, this message translates to:
  /// **'Jalankan'**
  String get playgroundRun;

  /// No description provided for @playgroundRunning.
  ///
  /// In id, this message translates to:
  /// **'Menjalankan…'**
  String get playgroundRunning;

  /// No description provided for @playgroundTerminal.
  ///
  /// In id, this message translates to:
  /// **'Terminal'**
  String get playgroundTerminal;

  /// No description provided for @playgroundClearTerminal.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan terminal'**
  String get playgroundClearTerminal;

  /// No description provided for @playgroundOpenTerminal.
  ///
  /// In id, this message translates to:
  /// **'Buka terminal'**
  String get playgroundOpenTerminal;

  /// No description provided for @playgroundCloseTerminal.
  ///
  /// In id, this message translates to:
  /// **'Tutup terminal'**
  String get playgroundCloseTerminal;

  /// No description provided for @playgroundEmptyDone.
  ///
  /// In id, this message translates to:
  /// **'(Program selesai tanpa output)'**
  String get playgroundEmptyDone;

  /// No description provided for @playgroundEmptyIdle.
  ///
  /// In id, this message translates to:
  /// **'Tekan \'Jalankan\' untuk melihat output'**
  String get playgroundEmptyIdle;

  /// No description provided for @playgroundInputHint.
  ///
  /// In id, this message translates to:
  /// **'ketik jawaban…'**
  String get playgroundInputHint;

  /// No description provided for @playgroundStatusDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai ({ms}ms)'**
  String playgroundStatusDone(Object ms);

  /// No description provided for @playgroundStatusError.
  ///
  /// In id, this message translates to:
  /// **'Error ({ms}ms)'**
  String playgroundStatusError(Object ms);

  /// No description provided for @sandboxTooltip.
  ///
  /// In id, this message translates to:
  /// **'Apa yang belum bisa dilakukan di sandbox?'**
  String get sandboxTooltip;

  /// No description provided for @sandboxSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Batas Python Sandbox'**
  String get sandboxSheetTitle;

  /// No description provided for @sandboxSheetSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pesan guru sebelum kamu mulai'**
  String get sandboxSheetSubtitle;

  /// No description provided for @sandboxIntro.
  ///
  /// In id, this message translates to:
  /// **'Anak-anak, sebelum mulai mencoba, dengarkan pesan gurumu dulu. Python Sandbox ini ruang latihan yang sengaja dibatasi, bukan Python penuh. Supaya kamu tidak bingung ketika ada yang gagal, ini hal yang belum bisa dilakukan di sini:'**
  String get sandboxIntro;

  /// No description provided for @sandboxLimitImportTitle.
  ///
  /// In id, this message translates to:
  /// **'Memanggil modul dengan import'**
  String get sandboxLimitImportTitle;

  /// No description provided for @sandboxLimitImportBody.
  ///
  /// In id, this message translates to:
  /// **'Perintah import belum ada di sandbox ini. Jadi library seperti random, math, datetime, atau paket dari internet belum bisa dipakai.'**
  String get sandboxLimitImportBody;

  /// No description provided for @sandboxLimitFileTitle.
  ///
  /// In id, this message translates to:
  /// **'Membuka file dan menyambung ke luar'**
  String get sandboxLimitFileTitle;

  /// No description provided for @sandboxLimitFileBody.
  ///
  /// In id, this message translates to:
  /// **'Membuka atau menyimpan file, mengakses internet, dan memerintah sistem operasi belum diizinkan. Semua yang kamu tulis berjalan di dalam aplikasi saja.'**
  String get sandboxLimitFileBody;

  /// No description provided for @sandboxLimitGuiTitle.
  ///
  /// In id, this message translates to:
  /// **'Membuat tampilan grafis, gambar, atau suara'**
  String get sandboxLimitGuiTitle;

  /// No description provided for @sandboxLimitGuiBody.
  ///
  /// In id, this message translates to:
  /// **'tkinter, pygame, dan sejenisnya belum tersedia. Di sini kita berlatih logika program, bukan membuat jendela atau permainan yang bergerak sendiri.'**
  String get sandboxLimitGuiBody;

  /// No description provided for @sandboxLimitOopTitle.
  ///
  /// In id, this message translates to:
  /// **'Memakai class, dict, dan try/except'**
  String get sandboxLimitOopTitle;

  /// No description provided for @sandboxLimitOopBody.
  ///
  /// In id, this message translates to:
  /// **'Tiga materi itu belum ada di mesin latihan ini. Untuk sekarang, fokus dulu ke variabel, percabangan, perulangan, list, dan fungsi.'**
  String get sandboxLimitOopBody;

  /// No description provided for @sandboxLimitLimitsTitle.
  ///
  /// In id, this message translates to:
  /// **'Menjalankan program yang terlalu berat'**
  String get sandboxLimitLimitsTitle;

  /// No description provided for @sandboxLimitLimitsBody.
  ///
  /// In id, this message translates to:
  /// **'Program otomatis dihentikan setelah 100.000 langkah atau 5 detik, dan rekursi dibatasi 200 tingkat. Kalau kena batas ini, periksa lagi perulanganmu — biasanya ada yang tidak pernah berhenti.'**
  String get sandboxLimitLimitsBody;

  /// No description provided for @sandboxClosing.
  ///
  /// In id, this message translates to:
  /// **'Kalau ada error padahal kodemu terasa benar, cek dulu apakah yang kamu pakai termasuk daftar di atas. Kalau masih bingung, tanyakan ke gurumu di kelas — kamu tidak perlu menyelesaikannya sendirian.'**
  String get sandboxClosing;

  /// No description provided for @dashTitle.
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get dashTitle;

  /// No description provided for @dashLoadingTitle.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan dashboard'**
  String get dashLoadingTitle;

  /// No description provided for @dashLoadingSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Menarik data belajar dari server'**
  String get dashLoadingSubtitle;

  /// No description provided for @dashNoModules.
  ///
  /// In id, this message translates to:
  /// **'Belum ada modul. Cek lagi sebentar.'**
  String get dashNoModules;

  /// No description provided for @dashQuickTipTitle.
  ///
  /// In id, this message translates to:
  /// **'Trik Cepat Python'**
  String get dashQuickTipTitle;

  /// No description provided for @dashQuickTipSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Gunakan elif untuk evaluasi multi-kondisi'**
  String get dashQuickTipSubtitle;

  /// No description provided for @dashQuickTipBody.
  ///
  /// In id, this message translates to:
  /// **'Gunakan konstruksi elif untuk mengevaluasi beberapa kondisi berurutan secara bersih:\n\nif skor >= 90:\n    hasil = \"A\"\nelif skor >= 75:\n    hasil = \"B\"\nelse:\n    hasil = \"C\"\n\nDengan elif, evaluasi berhenti begitu kondisi pertama terpenuhi tanpa if bertingkat.'**
  String get dashQuickTipBody;

  /// No description provided for @dashQuickTipButton.
  ///
  /// In id, this message translates to:
  /// **'Paham, Lanjutkan Belajar!'**
  String get dashQuickTipButton;

  /// No description provided for @dashErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Ada kendala di sisi kami. Coba lagi sebentar.'**
  String get dashErrorTitle;

  /// No description provided for @dashRetryButton.
  ///
  /// In id, this message translates to:
  /// **'Coba lagi'**
  String get dashRetryButton;

  /// No description provided for @dashChallengesCompleted.
  ///
  /// In id, this message translates to:
  /// **'{count} tantangan selesai'**
  String dashChallengesCompleted(int count);

  /// No description provided for @dashModuleLocked.
  ///
  /// In id, this message translates to:
  /// **'Modul ini masih terkunci.'**
  String get dashModuleLocked;

  /// No description provided for @dashDefaultTopic.
  ///
  /// In id, this message translates to:
  /// **'Python Dasar & Logika'**
  String get dashDefaultTopic;

  /// No description provided for @dashDefaultChapter.
  ///
  /// In id, this message translates to:
  /// **'1. Pengenalan Logika Koding'**
  String get dashDefaultChapter;

  /// No description provided for @dashBabOf.
  ///
  /// In id, this message translates to:
  /// **'Bab {current} dari {total}'**
  String dashBabOf(int current, int total);

  /// No description provided for @dashPercentDone.
  ///
  /// In id, this message translates to:
  /// **'{percent}% Selesai'**
  String dashPercentDone(int percent);

  /// No description provided for @dashCompetencyTitle.
  ///
  /// In id, this message translates to:
  /// **'Kompetensimu'**
  String get dashCompetencyTitle;

  /// No description provided for @dashCompetencyEmpty.
  ///
  /// In id, this message translates to:
  /// **'Selesaikan satu tantangan, nanti kompetensimu muncul di sini.'**
  String get dashCompetencyEmpty;

  /// No description provided for @actionSeeDetail.
  ///
  /// In id, this message translates to:
  /// **'Lihat detail'**
  String get actionSeeDetail;

  /// No description provided for @moduleStatusCompleted.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get moduleStatusCompleted;

  /// No description provided for @moduleStatusActive.
  ///
  /// In id, this message translates to:
  /// **'Sedang dipelajari'**
  String get moduleStatusActive;

  /// No description provided for @moduleStatusAvailable.
  ///
  /// In id, this message translates to:
  /// **'Bisa dikerjakan'**
  String get moduleStatusAvailable;

  /// No description provided for @moduleStatusLocked.
  ///
  /// In id, this message translates to:
  /// **'Terkunci'**
  String get moduleStatusLocked;

  /// No description provided for @roadmapTitle.
  ///
  /// In id, this message translates to:
  /// **'Peta Petualangan Belajar'**
  String get roadmapTitle;

  /// No description provided for @roadmapStopsToCertificate.
  ///
  /// In id, this message translates to:
  /// **'{count} Pos Menuju Sertifikat'**
  String roadmapStopsToCertificate(int count);

  /// No description provided for @roadmapActiveBab.
  ///
  /// In id, this message translates to:
  /// **'Bab {step} Aktif'**
  String roadmapActiveBab(int step);

  /// No description provided for @roadmapCatalogTitle.
  ///
  /// In id, this message translates to:
  /// **'Katalog Materi'**
  String get roadmapCatalogTitle;

  /// No description provided for @roadmapCatalogSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Telusuri bab dari seluruh materi'**
  String get roadmapCatalogSubtitle;

  /// No description provided for @roadmapStartHere.
  ///
  /// In id, this message translates to:
  /// **'Mulai di sini! 🚀'**
  String get roadmapStartHere;

  /// No description provided for @roadmapInProgress.
  ///
  /// In id, this message translates to:
  /// **'Sedang Berjalan'**
  String get roadmapInProgress;

  /// No description provided for @roadmapPracticeCount.
  ///
  /// In id, this message translates to:
  /// **'6 Latihan'**
  String get roadmapPracticeCount;

  /// No description provided for @roadmapBabLine.
  ///
  /// In id, this message translates to:
  /// **'Bab {order} • {label}'**
  String roadmapBabLine(int order, String label);

  /// No description provided for @roadmapQuizNode.
  ///
  /// In id, this message translates to:
  /// **'Uji Pemahaman'**
  String get roadmapQuizNode;

  /// No description provided for @roadmapAvailableNow.
  ///
  /// In id, this message translates to:
  /// **'Bisa langsung dikerjakan'**
  String get roadmapAvailableNow;

  /// No description provided for @roadmapCertificate.
  ///
  /// In id, this message translates to:
  /// **'Sertifikat Modul'**
  String get roadmapCertificate;

  /// No description provided for @roadmapGraduationTarget.
  ///
  /// In id, this message translates to:
  /// **'Target Kelulusan'**
  String get roadmapGraduationTarget;

  /// No description provided for @levelBeginner.
  ///
  /// In id, this message translates to:
  /// **'Pemula'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In id, this message translates to:
  /// **'Menengah'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In id, this message translates to:
  /// **'Mahir'**
  String get levelAdvanced;

  /// No description provided for @filterAll.
  ///
  /// In id, this message translates to:
  /// **'Semua'**
  String get filterAll;

  /// No description provided for @filterTodo.
  ///
  /// In id, this message translates to:
  /// **'Belum Selesai'**
  String get filterTodo;

  /// No description provided for @filterDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai'**
  String get filterDone;

  /// No description provided for @filterMiniProject.
  ///
  /// In id, this message translates to:
  /// **'Mini Proyek'**
  String get filterMiniProject;

  /// No description provided for @actionApply.
  ///
  /// In id, this message translates to:
  /// **'Terapkan'**
  String get actionApply;

  /// No description provided for @appDefaultStudentName.
  ///
  /// In id, this message translates to:
  /// **'Siswa SMK'**
  String get appDefaultStudentName;

  /// No description provided for @challengeFilterTitle.
  ///
  /// In id, this message translates to:
  /// **'Filter Tantangan'**
  String get challengeFilterTitle;

  /// No description provided for @challengeLevelSection.
  ///
  /// In id, this message translates to:
  /// **'Tingkat kesulitan'**
  String get challengeLevelSection;

  /// No description provided for @challengeLockedTitle.
  ///
  /// In id, this message translates to:
  /// **'Tantangan Terkunci'**
  String get challengeLockedTitle;

  /// No description provided for @challengeLockedBody.
  ///
  /// In id, this message translates to:
  /// **'Syarat: Butuh minimal {xp} XP untuk membuka tantangan ini. Saat ini kamu memiliki {userXp} XP.'**
  String challengeLockedBody(int xp, int userXp);

  /// No description provided for @challengeLearningPath.
  ///
  /// In id, this message translates to:
  /// **'Jalur Belajar'**
  String get challengeLearningPath;

  /// No description provided for @challengeCatalogTitle.
  ///
  /// In id, this message translates to:
  /// **'Katalog Tantangan'**
  String get challengeCatalogTitle;

  /// No description provided for @challengeCatalogSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Asah logika algoritma & koding bertahap'**
  String get challengeCatalogSubtitle;

  /// No description provided for @challengeFilter.
  ///
  /// In id, this message translates to:
  /// **'Filter'**
  String get challengeFilter;

  /// No description provided for @challengeFilterActive.
  ///
  /// In id, this message translates to:
  /// **'Filter • 1'**
  String get challengeFilterActive;

  /// No description provided for @challengeFilterCount.
  ///
  /// In id, this message translates to:
  /// **'{label} ({count})'**
  String challengeFilterCount(String label, int count);

  /// No description provided for @challengeSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari topik, fungsi, atau algoritma...'**
  String get challengeSearchHint;

  /// No description provided for @challengeClearSearch.
  ///
  /// In id, this message translates to:
  /// **'Hapus pencarian'**
  String get challengeClearSearch;

  /// No description provided for @challengeSearchTooltip.
  ///
  /// In id, this message translates to:
  /// **'Cari tantangan'**
  String get challengeSearchTooltip;

  /// No description provided for @challengeNoMatch.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada tantangan yang cocok. Coba ubah kata kunci atau filter.'**
  String get challengeNoMatch;

  /// No description provided for @challengeGroupDone.
  ///
  /// In id, this message translates to:
  /// **'{done} / {total} Selesai'**
  String challengeGroupDone(int done, int total);

  /// No description provided for @challengeGroupUnlocked.
  ///
  /// In id, this message translates to:
  /// **'{unlocked} / {total} Dibuka'**
  String challengeGroupUnlocked(int unlocked, int total);

  /// No description provided for @challengeSummaryDone.
  ///
  /// In id, this message translates to:
  /// **'{done} dari {total} Selesai'**
  String challengeSummaryDone(int done, int total);

  /// No description provided for @challengeSummarySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kemahiran Kurikulum Algoritma RPL'**
  String get challengeSummarySubtitle;

  /// No description provided for @challengeXpEarned.
  ///
  /// In id, this message translates to:
  /// **'+{xp} XP Didapat'**
  String challengeXpEarned(int xp);

  /// No description provided for @challengeStatusInProgress.
  ///
  /// In id, this message translates to:
  /// **'Sedang Dicoba'**
  String get challengeStatusInProgress;

  /// No description provided for @challengeMiniProjectHeader.
  ///
  /// In id, this message translates to:
  /// **'MINI-PROYEK TERAPAN'**
  String get challengeMiniProjectHeader;

  /// No description provided for @challengeMiniProjectSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Praktik implementasi logika komprehensif khas SMK RPL'**
  String get challengeMiniProjectSubtitle;

  /// No description provided for @challengeOpen.
  ///
  /// In id, this message translates to:
  /// **'Terbuka'**
  String get challengeOpen;

  /// No description provided for @challengeMinutes.
  ///
  /// In id, this message translates to:
  /// **'{count} Menit'**
  String challengeMinutes(int count);

  /// No description provided for @challengeXpRequired.
  ///
  /// In id, this message translates to:
  /// **'Butuh {xp} XP'**
  String challengeXpRequired(int xp);

  /// No description provided for @challengeXpRequirement.
  ///
  /// In id, this message translates to:
  /// **'Syarat: Butuh {xp} XP'**
  String challengeXpRequirement(int xp);

  /// No description provided for @challengeTestCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Unit Test'**
  String challengeTestCount(int count);

  /// No description provided for @challengeDetailTitle.
  ///
  /// In id, this message translates to:
  /// **'Tantangan Koding'**
  String get challengeDetailTitle;

  /// No description provided for @challengeHistoryTooltip.
  ///
  /// In id, this message translates to:
  /// **'Riwayat submisi'**
  String get challengeHistoryTooltip;

  /// No description provided for @challengeLevelLine.
  ///
  /// In id, this message translates to:
  /// **'Tingkat: {level}'**
  String challengeLevelLine(String level);

  /// No description provided for @challengeXpPlus.
  ///
  /// In id, this message translates to:
  /// **'+{xp} XP'**
  String challengeXpPlus(int xp);

  /// No description provided for @challengeMinutesShort.
  ///
  /// In id, this message translates to:
  /// **'~{count} mnt'**
  String challengeMinutesShort(int count);

  /// No description provided for @challengeTaskInstruction.
  ///
  /// In id, this message translates to:
  /// **'Instruksi Tugas'**
  String get challengeTaskInstruction;

  /// No description provided for @challengeSampleCalls.
  ///
  /// In id, this message translates to:
  /// **'CONTOH PEMANGGILAN'**
  String get challengeSampleCalls;

  /// No description provided for @challengeTabInstruction.
  ///
  /// In id, this message translates to:
  /// **'Instruksi & Uji'**
  String get challengeTabInstruction;

  /// No description provided for @challengeTabSolution.
  ///
  /// In id, this message translates to:
  /// **'Solusi Kodemu'**
  String get challengeTabSolution;

  /// No description provided for @challengeFormatPep8.
  ///
  /// In id, this message translates to:
  /// **'Format PEP8'**
  String get challengeFormatPep8;

  /// No description provided for @challengeFormatDone.
  ///
  /// In id, this message translates to:
  /// **'Format PEP8 berhasil dirapikan'**
  String get challengeFormatDone;

  /// No description provided for @challengeResetCode.
  ///
  /// In id, this message translates to:
  /// **'Reset Kode'**
  String get challengeResetCode;

  /// No description provided for @challengeAiHelpTitle.
  ///
  /// In id, this message translates to:
  /// **'Butuh Bantuan AI?'**
  String get challengeAiHelpTitle;

  /// No description provided for @challengeAiHelpSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Dapatkan petunjuk bertahap tanpa spoiler kode'**
  String get challengeAiHelpSubtitle;

  /// No description provided for @challengeQuotaLabel.
  ///
  /// In id, this message translates to:
  /// **'{used}/{total} Kuota'**
  String challengeQuotaLabel(int used, int total);

  /// No description provided for @challengeAskHint.
  ///
  /// In id, this message translates to:
  /// **'Minta Hint'**
  String get challengeAskHint;

  /// No description provided for @challengeRunFailed.
  ///
  /// In id, this message translates to:
  /// **'Ada kendala saat eksekusi kode. Coba lagi sebentar.'**
  String get challengeRunFailed;

  /// No description provided for @challengeSubmitFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengirim submisi. Coba lagi sebentar.'**
  String get challengeSubmitFailed;

  /// No description provided for @challengeTestResultTitle.
  ///
  /// In id, this message translates to:
  /// **'Hasil Pengujian Otomatis'**
  String get challengeTestResultTitle;

  /// No description provided for @challengeTestResultCompletedTitle.
  ///
  /// In id, this message translates to:
  /// **'Hasil Pengujian Otomatis — Selesai'**
  String get challengeTestResultCompletedTitle;

  /// No description provided for @challengePassedCount.
  ///
  /// In id, this message translates to:
  /// **'{passed}/{total} Lolos'**
  String challengePassedCount(int passed, int total);

  /// No description provided for @challengeExecutionTime.
  ///
  /// In id, this message translates to:
  /// **'Eksekusi: {ms}ms'**
  String challengeExecutionTime(int ms);

  /// No description provided for @challengePassed.
  ///
  /// In id, this message translates to:
  /// **'Lolos'**
  String get challengePassed;

  /// No description provided for @challengeFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal'**
  String get challengeFailed;

  /// No description provided for @challengeCaseDetail.
  ///
  /// In id, this message translates to:
  /// **'Input: {input} • Ekspektasi: {expected} • Output: {output}'**
  String challengeCaseDetail(String input, String expected, String output);

  /// No description provided for @challengeScaffoldingLevels.
  ///
  /// In id, this message translates to:
  /// **'Scaffolding 3 Level'**
  String get challengeScaffoldingLevels;

  /// No description provided for @challengeLogicHintLabel.
  ///
  /// In id, this message translates to:
  /// **'Petunjuk Logika: '**
  String get challengeLogicHintLabel;

  /// No description provided for @challengeAllTestsPassed.
  ///
  /// In id, this message translates to:
  /// **'Mantap! Seluruh uji coba lolos. Tekan tombol Kirim Solusi di bawah untuk klaim XP-mu!'**
  String get challengeAllTestsPassed;

  /// No description provided for @challengeCasesNotPassed.
  ///
  /// In id, this message translates to:
  /// **'{count} kasus belum lolos dari pengujian otomatis. Minta arahan AI Tutor di bawah — petunjuknya memandu kodemu, bukan jawaban jadi.'**
  String challengeCasesNotPassed(int count);

  /// No description provided for @challengeAskAiTutor.
  ///
  /// In id, this message translates to:
  /// **'Tanya AI Tutor'**
  String get challengeAskAiTutor;

  /// No description provided for @challengeCompletedBody.
  ///
  /// In id, this message translates to:
  /// **'Tantangan ini sudah kamu tuntaskan. Detail per-kasus hanya tampil di sesi bersama submisi berjalan; skor terbaik tercatat resmi di server:'**
  String get challengeCompletedBody;

  /// No description provided for @challengeBestScore.
  ///
  /// In id, this message translates to:
  /// **'Skor terbaik: {score}%'**
  String challengeBestScore(int score);

  /// No description provided for @challengeViewHistory.
  ///
  /// In id, this message translates to:
  /// **'Lihat riwayat submisi'**
  String get challengeViewHistory;

  /// No description provided for @challengeTryRun.
  ///
  /// In id, this message translates to:
  /// **'Uji Coba'**
  String get challengeTryRun;

  /// No description provided for @challengeSubmitSolution.
  ///
  /// In id, this message translates to:
  /// **'Kirim Solusi'**
  String get challengeSubmitSolution;

  /// No description provided for @challengeEvaluationTitle.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Proyek'**
  String get challengeEvaluationTitle;

  /// No description provided for @evalSolutionAccepted.
  ///
  /// In id, this message translates to:
  /// **'Solusi Diterima!'**
  String get evalSolutionAccepted;

  /// No description provided for @evalSolutionNotYet.
  ///
  /// In id, this message translates to:
  /// **'Solusi Belum Berhasil'**
  String get evalSolutionNotYet;

  /// No description provided for @evalAllPassedBody.
  ///
  /// In id, this message translates to:
  /// **'Seluruh pengujian publik dan tersembunyi berhasil dilewati tanpa kendala.'**
  String get evalAllPassedBody;

  /// No description provided for @evalSomeFailedBody.
  ///
  /// In id, this message translates to:
  /// **'Jangan patah semangat! {passed} dari {total} pengujian berhasil. Mari kita telaah kesalahan dan perbaiki bersama AI Tutor.'**
  String evalSomeFailedBody(int passed, int total);

  /// No description provided for @evalMetricFinalScore.
  ///
  /// In id, this message translates to:
  /// **'NILAI AKHIR'**
  String get evalMetricFinalScore;

  /// No description provided for @evalBadgePerfect.
  ///
  /// In id, this message translates to:
  /// **'Sempurna'**
  String get evalBadgePerfect;

  /// No description provided for @evalBadgeNeedsImprovement.
  ///
  /// In id, this message translates to:
  /// **'Perlu Perbaikan'**
  String get evalBadgeNeedsImprovement;

  /// No description provided for @evalMetricExecution.
  ///
  /// In id, this message translates to:
  /// **'EKSEKUSI'**
  String get evalMetricExecution;

  /// No description provided for @evalSecondsSuffix.
  ///
  /// In id, this message translates to:
  /// **' dtk'**
  String get evalSecondsSuffix;

  /// No description provided for @evalBadgeFast.
  ///
  /// In id, this message translates to:
  /// **'Cepat'**
  String get evalBadgeFast;

  /// No description provided for @evalTestResultsHeader.
  ///
  /// In id, this message translates to:
  /// **'HASIL PENGUJIAN OTOMATIS'**
  String get evalTestResultsHeader;

  /// No description provided for @evalCompetencyTitle.
  ///
  /// In id, this message translates to:
  /// **'Kompetensi Logika & Algoritma'**
  String get evalCompetencyTitle;

  /// No description provided for @evalPointsPlus.
  ///
  /// In id, this message translates to:
  /// **'+5 Poin'**
  String get evalPointsPlus;

  /// No description provided for @evalCompetencySubtitle.
  ///
  /// In id, this message translates to:
  /// **'Bukti empiris tercatat otomatis pada portofolio SMK-mu.'**
  String get evalCompetencySubtitle;

  /// No description provided for @evalCooldownTitle.
  ///
  /// In id, this message translates to:
  /// **'Cooldown Submisi Compiler'**
  String get evalCooldownTitle;

  /// No description provided for @evalCooldownPrefix.
  ///
  /// In id, this message translates to:
  /// **'Tunggu '**
  String get evalCooldownPrefix;

  /// No description provided for @evalCooldownSuffix.
  ///
  /// In id, this message translates to:
  /// **' detik sebelum dapat mengirim submisi berikutnya untuk stabilitas sandbox container.'**
  String get evalCooldownSuffix;

  /// No description provided for @evalCooldownReady.
  ///
  /// In id, this message translates to:
  /// **'Compiler siap menerima submisi kode baru.'**
  String get evalCooldownReady;

  /// No description provided for @evalNextChallenge.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke Tantangan Berikutnya'**
  String get evalNextChallenge;

  /// No description provided for @evalFixSolution.
  ///
  /// In id, this message translates to:
  /// **'Perbaiki Solusi Koding'**
  String get evalFixSolution;

  /// No description provided for @evalHiddenBadge.
  ///
  /// In id, this message translates to:
  /// **'Hidden'**
  String get evalHiddenBadge;

  /// No description provided for @historyTitle.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Submisi'**
  String get historyTitle;

  /// No description provided for @historyStatusPassed.
  ///
  /// In id, this message translates to:
  /// **'Lulus'**
  String get historyStatusPassed;

  /// No description provided for @historyStatusError.
  ///
  /// In id, this message translates to:
  /// **'Error'**
  String get historyStatusError;

  /// No description provided for @historyBestScore.
  ///
  /// In id, this message translates to:
  /// **'Skor Tertinggi'**
  String get historyBestScore;

  /// No description provided for @historyAttemptsCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Percobaan Dikirim'**
  String historyAttemptsCount(int count);

  /// No description provided for @historySubmissionsHeader.
  ///
  /// In id, this message translates to:
  /// **'Riwayat Pengiriman'**
  String get historySubmissionsHeader;

  /// No description provided for @historySortedByTime.
  ///
  /// In id, this message translates to:
  /// **'Terurut Waktu'**
  String get historySortedByTime;

  /// No description provided for @historyOpenPlayground.
  ///
  /// In id, this message translates to:
  /// **'Buka di Playground'**
  String get historyOpenPlayground;

  /// No description provided for @historyBackToChallenge.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Soal'**
  String get historyBackToChallenge;

  /// No description provided for @historySubmissionNumber.
  ///
  /// In id, this message translates to:
  /// **'Submisi #{number}'**
  String historySubmissionNumber(int number);

  /// No description provided for @historyScoreInline.
  ///
  /// In id, this message translates to:
  /// **'  •  Skor {score}/100'**
  String historyScoreInline(int score);

  /// No description provided for @historyHintsUsed.
  ///
  /// In id, this message translates to:
  /// **'{count} Hint AI digunakan'**
  String historyHintsUsed(int count);

  /// No description provided for @historySubmissionCode.
  ///
  /// In id, this message translates to:
  /// **'Kode Submisi #{number} (Python)'**
  String historySubmissionCode(int number);

  /// No description provided for @historyAiReview.
  ///
  /// In id, this message translates to:
  /// **'Ulasan AI Tutor'**
  String get historyAiReview;

  /// No description provided for @tutorSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Scaffolding & Pendamping Belajar'**
  String get tutorSubtitle;

  /// No description provided for @tutorQuotaToastExhausted.
  ///
  /// In id, this message translates to:
  /// **'Kuota hint hari ini habis. Coba lagi besok.'**
  String get tutorQuotaToastExhausted;

  /// No description provided for @tutorQuotaToastExhaustedDetail.
  ///
  /// In id, this message translates to:
  /// **'Kuota petunjuk hari ini sudah habis. Coba lagi besok untuk berlatih mandiri.'**
  String get tutorQuotaToastExhaustedDetail;

  /// No description provided for @tutorHintFailed.
  ///
  /// In id, this message translates to:
  /// **'Petunjuk gagal disiapkan. Coba lagi sebentar.'**
  String get tutorHintFailed;

  /// No description provided for @tutorHintOffline.
  ///
  /// In id, this message translates to:
  /// **'Server petunjuk sedang tidak dapat dihubungi — menampilkan petunjuk bawaan.'**
  String get tutorHintOffline;

  /// No description provided for @tutorConceptLabel.
  ///
  /// In id, this message translates to:
  /// **'Konsep: {concept}'**
  String tutorConceptLabel(String concept);

  /// No description provided for @tutorLevelLabel.
  ///
  /// In id, this message translates to:
  /// **'Level {unlocked}/{total}'**
  String tutorLevelLabel(int unlocked, int total);

  /// No description provided for @tutorQuotaRemaining.
  ///
  /// In id, this message translates to:
  /// **'Sisa kuota'**
  String get tutorQuotaRemaining;

  /// No description provided for @tutorScaffoldingTitle.
  ///
  /// In id, this message translates to:
  /// **'Scaffolding Bertahap'**
  String get tutorScaffoldingTitle;

  /// No description provided for @tutorSocraticMethod.
  ///
  /// In id, this message translates to:
  /// **'Metode Sokratik'**
  String get tutorSocraticMethod;

  /// No description provided for @tutorPromptQuestion.
  ///
  /// In id, this message translates to:
  /// **'PERTANYAAN PEMANTIK:'**
  String get tutorPromptQuestion;

  /// No description provided for @tutorPreparingHint.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan petunjuk untuk tantangan ini…'**
  String get tutorPreparingHint;

  /// No description provided for @tutorQuotaBlockedBody.
  ///
  /// In id, this message translates to:
  /// **'Kuota hint hari ini sudah habis (5x per hari). Petunjuk spesifik untuk tantangan ini terbuka lagi besok — sementara ini, tuntaskan di kodemu dulu.'**
  String get tutorQuotaBlockedBody;

  /// No description provided for @tutorThinkingFlow.
  ///
  /// In id, this message translates to:
  /// **'REKOMENDASI ALUR BERPIKIR'**
  String get tutorThinkingFlow;

  /// No description provided for @tutorPreparingShort.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan petunjuk…'**
  String get tutorPreparingShort;

  /// No description provided for @tutorUnlockNext.
  ///
  /// In id, this message translates to:
  /// **'Buka Hint Berikutnya ({level})'**
  String tutorUnlockNext(String level);

  /// No description provided for @tutorQuotaExhaustedBody.
  ///
  /// In id, this message translates to:
  /// **'Kuota petunjuk harian sudah habis (maksimal 5x per hari sesuai PRD). Setiap beristirahat akan reset besok — sementara ini, tuntaskan di kodemu dulu.'**
  String get tutorQuotaExhaustedBody;

  /// No description provided for @tutorAllHintsUnlocked.
  ///
  /// In id, this message translates to:
  /// **'Semua hint sudah terbuka. Sekarang coba terapkan di kodemu.'**
  String get tutorAllHintsUnlocked;

  /// No description provided for @tutorLockedSuffix.
  ///
  /// In id, this message translates to:
  /// **', terkunci'**
  String get tutorLockedSuffix;

  /// No description provided for @materialCatalogTitle.
  ///
  /// In id, this message translates to:
  /// **'Katalog Materi'**
  String get materialCatalogTitle;

  /// No description provided for @materialFilterActive.
  ///
  /// In id, this message translates to:
  /// **'Sedang Aktif'**
  String get materialFilterActive;

  /// No description provided for @materialFilterNotStarted.
  ///
  /// In id, this message translates to:
  /// **'Belum Dimulai'**
  String get materialFilterNotStarted;

  /// No description provided for @materialStatusRunning.
  ///
  /// In id, this message translates to:
  /// **'Berjalan'**
  String get materialStatusRunning;

  /// No description provided for @materialLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat katalog materi.'**
  String get materialLoadFailed;

  /// No description provided for @materialSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari materi atau deskripsinya…'**
  String get materialSearchHint;

  /// No description provided for @materialClearSearch.
  ///
  /// In id, this message translates to:
  /// **'Hapus pencarian'**
  String get materialClearSearch;

  /// No description provided for @materialNoMatch.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada materi yang cocok dengan pencarian atau filter.'**
  String get materialNoMatch;

  /// No description provided for @materialChaptersDone.
  ///
  /// In id, this message translates to:
  /// **'{done}/{total} bab tuntas'**
  String materialChaptersDone(int done, int total);

  /// No description provided for @readerPreviewDone.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Siswa Selesai! Semua slide berhasil dievaluasi.'**
  String get readerPreviewDone;

  /// No description provided for @readerXpEarned.
  ///
  /// In id, this message translates to:
  /// **'Selamat! Kamu memperoleh +{xp} XP! 🎉'**
  String readerXpEarned(int xp);

  /// No description provided for @readerXpAlreadyDone.
  ///
  /// In id, this message translates to:
  /// **'Bab sudah pernah dituntaskan — XP tidak dihitung dua kali.'**
  String get readerXpAlreadyDone;

  /// No description provided for @readerExitTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Latihan?'**
  String get readerExitTitle;

  /// No description provided for @readerExitBody.
  ///
  /// In id, this message translates to:
  /// **'Progres slide terakhirmu akan tersimpan secara otomatis.'**
  String get readerExitBody;

  /// No description provided for @readerExitStay.
  ///
  /// In id, this message translates to:
  /// **'Lanjut Belajar'**
  String get readerExitStay;

  /// No description provided for @readerExitConfirm.
  ///
  /// In id, this message translates to:
  /// **'Keluar'**
  String get readerExitConfirm;

  /// No description provided for @readerLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal memuat materi bab.'**
  String get readerLoadFailed;

  /// No description provided for @readerTeacherPreviewBanner.
  ///
  /// In id, this message translates to:
  /// **'MODE PRATINJAU GURU (Data tidak disimpan)'**
  String get readerTeacherPreviewBanner;

  /// No description provided for @readerContinue.
  ///
  /// In id, this message translates to:
  /// **'Paham, Lanjutkan'**
  String get readerContinue;

  /// No description provided for @readerFinishSave.
  ///
  /// In id, this message translates to:
  /// **'Selesai & Simpan Progres'**
  String get readerFinishSave;

  /// No description provided for @readerCheckAnswer.
  ///
  /// In id, this message translates to:
  /// **'Periksa Jawaban'**
  String get readerCheckAnswer;

  /// No description provided for @slideBadgeValidated.
  ///
  /// In id, this message translates to:
  /// **'Langkah Tervalidasi'**
  String get slideBadgeValidated;

  /// No description provided for @slideProgressSaved.
  ///
  /// In id, this message translates to:
  /// **'Progres Tersimpan'**
  String get slideProgressSaved;

  /// No description provided for @slideWhyCorrect.
  ///
  /// In id, this message translates to:
  /// **'Mengapa Jawabanmu Benar?'**
  String get slideWhyCorrect;

  /// No description provided for @slideNextSlide.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke Slide Berikutnya'**
  String get slideNextSlide;

  /// No description provided for @slideSyntaxEvaluation.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi Sintaksis'**
  String get slideSyntaxEvaluation;

  /// No description provided for @slideZeroXpTryAgain.
  ///
  /// In id, this message translates to:
  /// **'0 XP • Semangat Coba Lagi'**
  String get slideZeroXpTryAgain;

  /// No description provided for @slideErrorEncouragement.
  ///
  /// In id, this message translates to:
  /// **'Jangan khawatir, kesalahan kecil adalah bagian alami dari proses belajar koding.'**
  String get slideErrorEncouragement;

  /// No description provided for @slideSkipArrow.
  ///
  /// In id, this message translates to:
  /// **'Lewati Slide →'**
  String get slideSkipArrow;

  /// No description provided for @slideWhereIsMistake.
  ///
  /// In id, this message translates to:
  /// **'Di Mana Letak Kesalahannya?'**
  String get slideWhereIsMistake;

  /// No description provided for @slideBadgeTheory.
  ///
  /// In id, this message translates to:
  /// **'Teori & Konsep'**
  String get slideBadgeTheory;

  /// No description provided for @slideTheoryTip.
  ///
  /// In id, this message translates to:
  /// **'Pahami konsep di atas dengan seksama sebelum melanjutkan ke latihan interaktif.'**
  String get slideTheoryTip;

  /// No description provided for @slideBadgeArrangeSyntax.
  ///
  /// In id, this message translates to:
  /// **'Susun Sintaks'**
  String get slideBadgeArrangeSyntax;

  /// No description provided for @slideTapToFillInstruction.
  ///
  /// In id, this message translates to:
  /// **'Ketuk balok kode di bawah untuk mengisi slot kosong yang sesuai:'**
  String get slideTapToFillInstruction;

  /// No description provided for @slideWordBank.
  ///
  /// In id, this message translates to:
  /// **'Bank Balok Kata:'**
  String get slideWordBank;

  /// No description provided for @slideBadgeTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Ketik Kode'**
  String get slideBadgeTypeCode;

  /// No description provided for @slideHint.
  ///
  /// In id, this message translates to:
  /// **'Petunjuk'**
  String get slideHint;

  /// No description provided for @slideTypeHere.
  ///
  /// In id, this message translates to:
  /// **'ketik di sini...'**
  String get slideTypeHere;

  /// No description provided for @slideBadgeGuessOutput.
  ///
  /// In id, this message translates to:
  /// **'Tebak Output'**
  String get slideBadgeGuessOutput;

  /// No description provided for @slideBadgeBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Bug Hunter'**
  String get slideBadgeBugHunter;

  /// No description provided for @slideBugHunterInstruction.
  ///
  /// In id, this message translates to:
  /// **'Ketuk baris yang menurutmu mengandung galat penulisan di atas.'**
  String get slideBugHunterInstruction;

  /// No description provided for @slideBadgeConceptQuiz.
  ///
  /// In id, this message translates to:
  /// **'Kuis Konsep'**
  String get slideBadgeConceptQuiz;

  /// No description provided for @slideOutroXpReward.
  ///
  /// In id, this message translates to:
  /// **'Hadiah XP'**
  String get slideOutroXpReward;

  /// No description provided for @slideOutroAccuracy.
  ///
  /// In id, this message translates to:
  /// **'Akurasi'**
  String get slideOutroAccuracy;

  /// No description provided for @slideOutroLearningTime.
  ///
  /// In id, this message translates to:
  /// **'Waktu Belajar'**
  String get slideOutroLearningTime;

  /// No description provided for @slideOutroMasteredConcepts.
  ///
  /// In id, this message translates to:
  /// **'Konsep yang Kamu Kuasai'**
  String get slideOutroMasteredConcepts;

  /// No description provided for @profileTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil & Kompetensi'**
  String get profileTitle;

  /// No description provided for @profileSettingsTooltip.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan Profil'**
  String get profileSettingsTooltip;

  /// No description provided for @profileLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat profil…'**
  String get profileLoading;

  /// No description provided for @profileLoadFailedTitle.
  ///
  /// In id, this message translates to:
  /// **'Data profil gagal dimuat'**
  String get profileLoadFailedTitle;

  /// No description provided for @profileLoadFailedBody.
  ///
  /// In id, this message translates to:
  /// **'Pastikan server koding lab menyala, lalu coba lagi.'**
  String get profileLoadFailedBody;

  /// No description provided for @profileNewStudent.
  ///
  /// In id, this message translates to:
  /// **'Siswa Baru'**
  String get profileNewStudent;

  /// No description provided for @profileAddBio.
  ///
  /// In id, this message translates to:
  /// **'+ Tambah Bio'**
  String get profileAddBio;

  /// No description provided for @profileStatChallenges.
  ///
  /// In id, this message translates to:
  /// **'Tantangan'**
  String get profileStatChallenges;

  /// No description provided for @profileStatXpPoints.
  ///
  /// In id, this message translates to:
  /// **'Poin XP'**
  String get profileStatXpPoints;

  /// No description provided for @profileStatMaterialsDone.
  ///
  /// In id, this message translates to:
  /// **'Materi Selesai'**
  String get profileStatMaterialsDone;

  /// No description provided for @profileMasteryMapTitle.
  ///
  /// In id, this message translates to:
  /// **'Peta Penguasaan Materi'**
  String get profileMasteryMapTitle;

  /// No description provided for @profileMaterialsUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Daftar materi belum tersedia dari server. Coba lagi.'**
  String get profileMaterialsUnavailable;

  /// No description provided for @profileMaterialProgressTitle.
  ///
  /// In id, this message translates to:
  /// **'Progres Materi'**
  String get profileMaterialProgressTitle;

  /// No description provided for @profileChaptersInline.
  ///
  /// In id, this message translates to:
  /// **'{done}/{total} bab'**
  String profileChaptersInline(int done, int total);

  /// No description provided for @profileCurriculumUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Kurikulum belum tersedia dari server. Coba lagi.'**
  String get profileCurriculumUnavailable;

  /// No description provided for @profileCertificatesTitle.
  ///
  /// In id, this message translates to:
  /// **'Sertifikat'**
  String get profileCertificatesTitle;

  /// No description provided for @profileTracksDoneBadge.
  ///
  /// In id, this message translates to:
  /// **'{done}/{total} Tuntas'**
  String profileTracksDoneBadge(int done, int total);

  /// No description provided for @profileChallengeCertsTitle.
  ///
  /// In id, this message translates to:
  /// **'Sertifikat Tantangan'**
  String get profileChallengeCertsTitle;

  /// No description provided for @profileNoChallenges.
  ///
  /// In id, this message translates to:
  /// **'Belum ada tantangan di katalog — coba lagi.'**
  String get profileNoChallenges;

  /// No description provided for @profileBabCountInline.
  ///
  /// In id, this message translates to:
  /// **'{done}/{total} Bab'**
  String profileBabCountInline(int done, int total);

  /// No description provided for @profileCertReady.
  ///
  /// In id, this message translates to:
  /// **'Sertifikat siap diunduh'**
  String get profileCertReady;

  /// No description provided for @profileCertLearning.
  ///
  /// In id, this message translates to:
  /// **'Sedang belajar'**
  String get profileCertLearning;

  /// No description provided for @profileDownload.
  ///
  /// In id, this message translates to:
  /// **'Unduh'**
  String get profileDownload;

  /// No description provided for @profileCertChallengeDone.
  ///
  /// In id, this message translates to:
  /// **'Selesai — sertifikat siap'**
  String get profileCertChallengeDone;

  /// No description provided for @profileCertChallengeLocked.
  ///
  /// In id, this message translates to:
  /// **'Terkunci — kurang XP'**
  String get profileCertChallengeLocked;

  /// No description provided for @profileCertChallengeInProgress.
  ///
  /// In id, this message translates to:
  /// **'Sedang dikerjakan'**
  String get profileCertChallengeInProgress;

  /// No description provided for @profileDownloadSoon.
  ///
  /// In id, this message translates to:
  /// **'Fitur unduh sertifikat segera hadir, ya!'**
  String get profileDownloadSoon;

  /// No description provided for @changePassOldLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi Lama'**
  String get changePassOldLabel;

  /// No description provided for @changePassNewLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi Baru'**
  String get changePassNewLabel;

  /// No description provided for @changePassConfirmLabel.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Kata Sandi Baru'**
  String get changePassConfirmLabel;

  /// No description provided for @changePassShowPassword.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan sandi'**
  String get changePassShowPassword;

  /// No description provided for @changePassHidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan sandi'**
  String get changePassHidePassword;

  /// No description provided for @changePassOldRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi kata sandi lama dulu.'**
  String get changePassOldRequired;

  /// No description provided for @changePassSuccess.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi berhasil diubah!'**
  String get changePassSuccess;

  /// No description provided for @changePassFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal mengubah kata sandi. Coba lagi.'**
  String get changePassFailed;

  /// No description provided for @changePassConfirmHint.
  ///
  /// In id, this message translates to:
  /// **'Ketik ulang kata sandi baru untuk konfirmasi.'**
  String get changePassConfirmHint;

  /// No description provided for @changePassConfirmMatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi cocok dengan kata sandi baru.'**
  String get changePassConfirmMatch;

  /// No description provided for @changePassConfirmMismatch.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi belum sama dengan kata sandi baru.'**
  String get changePassConfirmMismatch;

  /// No description provided for @changePassSaving.
  ///
  /// In id, this message translates to:
  /// **'Menyimpan…'**
  String get changePassSaving;

  /// No description provided for @changePassSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan Kata Sandi'**
  String get changePassSave;

  /// No description provided for @joinClassTitle.
  ///
  /// In id, this message translates to:
  /// **'Gabung ke Kelas Gurumu'**
  String get joinClassTitle;

  /// No description provided for @joinClassSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Masukkan 6 karakter kode kelas yang dibagikan gurumu.'**
  String get joinClassSubtitle;

  /// No description provided for @joinClassClearCode.
  ///
  /// In id, this message translates to:
  /// **'Hapus kode'**
  String get joinClassClearCode;

  /// No description provided for @joinClassExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: K7M-8Q2 atau 4NB-9XT'**
  String get joinClassExample;

  /// No description provided for @joinClassNotFound.
  ///
  /// In id, this message translates to:
  /// **'Kode kelas tidak ditemukan.'**
  String get joinClassNotFound;

  /// No description provided for @joinClassSuccess.
  ///
  /// In id, this message translates to:
  /// **'Berhasil bergabung ke {name}!'**
  String joinClassSuccess(String name);

  /// No description provided for @joinClassCtaButton.
  ///
  /// In id, this message translates to:
  /// **'Gabung Kelas Sekarang'**
  String get joinClassCtaButton;

  /// No description provided for @joinClassFoundBadge.
  ///
  /// In id, this message translates to:
  /// **'Kelas Ditemukan'**
  String get joinClassFoundBadge;

  /// No description provided for @joinClassMemberCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Teman Sekelas'**
  String joinClassMemberCount(int count);

  /// No description provided for @classServerUnreachable.
  ///
  /// In id, this message translates to:
  /// **'Server belum terjangkau. Periksa koneksi lab, lalu coba lagi.'**
  String get classServerUnreachable;

  /// No description provided for @classServerUnreachableShort.
  ///
  /// In id, this message translates to:
  /// **'Server belum terjangkau. Coba beberapa saat lagi, ya.'**
  String get classServerUnreachableShort;

  /// No description provided for @classJoinedSnack.
  ///
  /// In id, this message translates to:
  /// **'Berhasil bergabung ke kelas {name}!'**
  String classJoinedSnack(String name);

  /// No description provided for @classLeftSnack.
  ///
  /// In id, this message translates to:
  /// **'Kamu keluar dari kelas {name}.'**
  String classLeftSnack(String name);

  /// No description provided for @classSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Kelas Belajar'**
  String get classSectionTitle;

  /// No description provided for @classSeeAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get classSeeAll;

  /// No description provided for @classLoadFailedFromServer.
  ///
  /// In id, this message translates to:
  /// **'Kelas gagal dimuat dari server'**
  String get classLoadFailedFromServer;

  /// No description provided for @classLoadFailedTitle.
  ///
  /// In id, this message translates to:
  /// **'Kelas gagal dimuat'**
  String get classLoadFailedTitle;

  /// No description provided for @classCheckLabConnection.
  ///
  /// In id, this message translates to:
  /// **'Cek koneksi lab sekolahmu, lalu coba lagi.'**
  String get classCheckLabConnection;

  /// No description provided for @classLoadingInline.
  ///
  /// In id, this message translates to:
  /// **'Memuat kelas…'**
  String get classLoadingInline;

  /// No description provided for @classNotJoinedTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum tergabung ke kelas'**
  String get classNotJoinedTitle;

  /// No description provided for @classJoinHintInline.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kode kelas 6 karakter yang dibagikan gurumu.'**
  String get classJoinHintInline;

  /// No description provided for @classJoinButton.
  ///
  /// In id, this message translates to:
  /// **'Gabung Kelas'**
  String get classJoinButton;

  /// No description provided for @classNotInClassTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum masuk kelas'**
  String get classNotInClassTitle;

  /// No description provided for @classJoinHintShort.
  ///
  /// In id, this message translates to:
  /// **'Gabung pakai kode 6 karakter dari gurumu.'**
  String get classJoinHintShort;

  /// No description provided for @classJoinShort.
  ///
  /// In id, this message translates to:
  /// **'Gabung'**
  String get classJoinShort;

  /// No description provided for @classActiveBadge.
  ///
  /// In id, this message translates to:
  /// **'Aktif'**
  String get classActiveBadge;

  /// No description provided for @classSeeAllTooltip.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua kelas'**
  String get classSeeAllTooltip;

  /// No description provided for @classMemberCountInline.
  ///
  /// In id, this message translates to:
  /// **'{count} teman sekelas'**
  String classMemberCountInline(int count);

  /// No description provided for @myClassesTitle.
  ///
  /// In id, this message translates to:
  /// **'Kelas Saya'**
  String get myClassesTitle;

  /// No description provided for @myClassesActiveCount.
  ///
  /// In id, this message translates to:
  /// **'{count} kelas aktif'**
  String myClassesActiveCount(int count);

  /// No description provided for @myClassesSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Rombel tempat kamu belajar'**
  String get myClassesSubtitle;

  /// No description provided for @myClassesOneActiveNote.
  ///
  /// In id, this message translates to:
  /// **'Satu siswa hanya dapat tergabung dalam satu kelas aktif. Keluar dari kelas bila ingin bergabung ke kelas lain.'**
  String get myClassesOneActiveNote;

  /// No description provided for @myClassesEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum tergabung ke kelas mana pun'**
  String get myClassesEmptyTitle;

  /// No description provided for @myClassesEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Minta kode kelas 6 karakter kepada gurumu, lalu gabung dari sini.'**
  String get myClassesEmptyBody;

  /// No description provided for @classDetailLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Detail kelas gagal dimuat'**
  String get classDetailLoadFailed;

  /// No description provided for @classRegisteredBadge.
  ///
  /// In id, this message translates to:
  /// **'Terdaftar Aktif'**
  String get classRegisteredBadge;

  /// No description provided for @classTeacherRoleBadge.
  ///
  /// In id, this message translates to:
  /// **'Guru'**
  String get classTeacherRoleBadge;

  /// No description provided for @classTeacherAdvisor.
  ///
  /// In id, this message translates to:
  /// **'Guru pembimbing kelas ini'**
  String get classTeacherAdvisor;

  /// No description provided for @classClassmatesTitle.
  ///
  /// In id, this message translates to:
  /// **'Teman Sekelas'**
  String get classClassmatesTitle;

  /// No description provided for @classClassmatesCount.
  ///
  /// In id, this message translates to:
  /// **'({count} Siswa)'**
  String classClassmatesCount(int count);

  /// No description provided for @classNoClassmates.
  ///
  /// In id, this message translates to:
  /// **'Belum ada teman sekelas yang terdaftar.'**
  String get classNoClassmates;

  /// No description provided for @classMonitoringNote.
  ///
  /// In id, this message translates to:
  /// **'Progres koding dan nilai tantanganmu dapat dipantau langsung oleh guru kelas ini di lab komputer.'**
  String get classMonitoringNote;

  /// No description provided for @classXpSafeNote.
  ///
  /// In id, this message translates to:
  /// **'Poin XP dan progres belajarmu tetap aman di akunmu jika kamu keluar kelas.'**
  String get classXpSafeNote;

  /// No description provided for @classCopyInfo.
  ///
  /// In id, this message translates to:
  /// **'Salin Info Kelas'**
  String get classCopyInfo;

  /// No description provided for @classInfoCopied.
  ///
  /// In id, this message translates to:
  /// **'Info Tersalin!'**
  String get classInfoCopied;

  /// No description provided for @classLeaveButton.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Kelas'**
  String get classLeaveButton;

  /// No description provided for @classLeaveConfirmTitle.
  ///
  /// In id, this message translates to:
  /// **'Yakin Ingin Keluar dari Kelas?'**
  String get classLeaveConfirmTitle;

  /// No description provided for @classLeaveConfirmBody.
  ///
  /// In id, this message translates to:
  /// **'Poin XP dan progres belajarmu tetap aman di akunmu, namun gurumu tidak dapat lagi memantau kemajuan belajarmu di lab.'**
  String get classLeaveConfirmBody;

  /// No description provided for @classLeaveConfirmYes.
  ///
  /// In id, this message translates to:
  /// **'Ya, Keluar Kelas'**
  String get classLeaveConfirmYes;

  /// No description provided for @classHideNames.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan'**
  String get classHideNames;

  /// No description provided for @classMoreCount.
  ///
  /// In id, this message translates to:
  /// **'+{rest} lainnya'**
  String classMoreCount(int rest);

  /// No description provided for @classSeeAllNames.
  ///
  /// In id, this message translates to:
  /// **'Lihat semua nama ({count})'**
  String classSeeAllNames(int count);

  /// No description provided for @authPassNotFilled.
  ///
  /// In id, this message translates to:
  /// **'Belum diisi'**
  String get authPassNotFilled;

  /// No description provided for @authPassVeryGood.
  ///
  /// In id, this message translates to:
  /// **'Sangat Bagus!'**
  String get authPassVeryGood;

  /// No description provided for @authPassNeedsWork.
  ///
  /// In id, this message translates to:
  /// **'Perlu ditingkatkan'**
  String get authPassNeedsWork;

  /// No description provided for @authPassSecurityTitle.
  ///
  /// In id, this message translates to:
  /// **'KEAMANAN SANDI'**
  String get authPassSecurityTitle;

  /// No description provided for @authPassMinLength.
  ///
  /// In id, this message translates to:
  /// **'Minimal 8 karakter'**
  String get authPassMinLength;

  /// No description provided for @authPassDigitOrSymbol.
  ///
  /// In id, this message translates to:
  /// **'Ada angka atau simbol'**
  String get authPassDigitOrSymbol;

  /// No description provided for @authCheckMet.
  ///
  /// In id, this message translates to:
  /// **'terpenuhi'**
  String get authCheckMet;

  /// No description provided for @authCheckNotMet.
  ///
  /// In id, this message translates to:
  /// **'belum terpenuhi'**
  String get authCheckNotMet;

  /// No description provided for @authSchoolVerifiedBadge.
  ///
  /// In id, this message translates to:
  /// **'Sekolah Terdaftar Resmi'**
  String get authSchoolVerifiedBadge;

  /// No description provided for @authSchoolCodePrefix.
  ///
  /// In id, this message translates to:
  /// **'Kode: {code}'**
  String authSchoolCodePrefix(String code);

  /// No description provided for @authSchoolReadOnlyNote.
  ///
  /// In id, this message translates to:
  /// **'Data sekolah ini bersifat read-only dan terverifikasi otomatis; tidak dapat diubah oleh instruktur.'**
  String get authSchoolReadOnlyNote;

  /// No description provided for @validNameRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi nama lengkapmu dulu.'**
  String get validNameRequired;

  /// No description provided for @validEmailRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi email kamu dulu.'**
  String get validEmailRequired;

  /// No description provided for @validEmailFormat.
  ///
  /// In id, this message translates to:
  /// **'Format email belum benar. Contoh: nama@smk.belajar.id'**
  String get validEmailFormat;

  /// No description provided for @validSchoolEmailDomain.
  ///
  /// In id, this message translates to:
  /// **'Email harus memakai domain {domain}.'**
  String validSchoolEmailDomain(String domain);

  /// No description provided for @validPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi kata sandi kamu dulu.'**
  String get validPasswordRequired;

  /// No description provided for @validNewPasswordRequired.
  ///
  /// In id, this message translates to:
  /// **'Buat kata sandi dulu.'**
  String get validNewPasswordRequired;

  /// No description provided for @validPasswordPolicy.
  ///
  /// In id, this message translates to:
  /// **'Minimal 8 karakter dan ada angka atau simbol.'**
  String get validPasswordPolicy;

  /// No description provided for @validConfirmRequired.
  ///
  /// In id, this message translates to:
  /// **'Ketik ulang kata sandi untuk konfirmasi.'**
  String get validConfirmRequired;

  /// No description provided for @validPasswordMismatch.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi belum sama dengan isian pertama.'**
  String get validPasswordMismatch;

  /// No description provided for @authErrInvalidCredentials.
  ///
  /// In id, this message translates to:
  /// **'Email atau kata sandi belum cocok. Coba periksa lagi.'**
  String get authErrInvalidCredentials;

  /// No description provided for @authErrEmailTaken.
  ///
  /// In id, this message translates to:
  /// **'Email ini sudah punya akun. Mau masuk saja?'**
  String get authErrEmailTaken;

  /// No description provided for @authErrNetwork.
  ///
  /// In id, this message translates to:
  /// **'Belum tersambung ke internet. Coba lagi sebentar.'**
  String get authErrNetwork;

  /// No description provided for @authErrSchoolCodeNotFound.
  ///
  /// In id, this message translates to:
  /// **'Kode sekolah tidak ditemukan. Silakan hubungi admin sekolahmu.'**
  String get authErrSchoolCodeNotFound;

  /// No description provided for @authErrWrongOldPassword.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi lama belum cocok. Coba periksa lagi.'**
  String get authErrWrongOldPassword;

  /// No description provided for @authErrPasswordPolicy.
  ///
  /// In id, this message translates to:
  /// **'Kata sandi baru belum memenuhi aturan (minimal 8 karakter, ada angka atau simbol).'**
  String get authErrPasswordPolicy;

  /// No description provided for @authErrAvatarUpload.
  ///
  /// In id, this message translates to:
  /// **'Foto profil belum bisa diunggah. Gunakan JPG atau PNG maksimal 2 MB.'**
  String get authErrAvatarUpload;

  /// No description provided for @authErrEmailDomain.
  ///
  /// In id, this message translates to:
  /// **'Email harus memakai domain @smk.belajar.id.'**
  String get authErrEmailDomain;

  /// No description provided for @authErrInvalidInput.
  ///
  /// In id, this message translates to:
  /// **'Ada isian yang belum sesuai. Periksa kembali lalu simpan lagi.'**
  String get authErrInvalidInput;

  /// No description provided for @authErrServer.
  ///
  /// In id, this message translates to:
  /// **'Server sedang bermasalah. Coba lagi beberapa saat lagi.'**
  String get authErrServer;

  /// No description provided for @loginWelcomeTitle.
  ///
  /// In id, this message translates to:
  /// **'Selamat datang kembali'**
  String get loginWelcomeTitle;

  /// No description provided for @loginWelcomeSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan belajar koding dari mana kamu berhenti.'**
  String get loginWelcomeSubtitle;

  /// No description provided for @loginJustRegisteredBanner.
  ///
  /// In id, this message translates to:
  /// **'Akunmu sudah dibuat. Silakan masuk untuk mulai belajar.'**
  String get loginJustRegisteredBanner;

  /// No description provided for @authEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In id, this message translates to:
  /// **'Kata Sandi'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Masukkan kata sandi'**
  String get authPasswordHint;

  /// No description provided for @loginSubmit.
  ///
  /// In id, this message translates to:
  /// **'Masuk Sekarang'**
  String get loginSubmit;

  /// No description provided for @loginNoAccount.
  ///
  /// In id, this message translates to:
  /// **'Belum punya akun?'**
  String get loginNoAccount;

  /// No description provided for @authRegisterLink.
  ///
  /// In id, this message translates to:
  /// **'Daftar'**
  String get authRegisterLink;

  /// No description provided for @authBackTooltip.
  ///
  /// In id, this message translates to:
  /// **'Kembali'**
  String get authBackTooltip;

  /// No description provided for @registerTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Akun'**
  String get registerTitle;

  /// No description provided for @registerTagBanner.
  ///
  /// In id, this message translates to:
  /// **'Platform Belajar Coding RPL'**
  String get registerTagBanner;

  /// No description provided for @registerHeading.
  ///
  /// In id, this message translates to:
  /// **'Yuk, buat akunmu'**
  String get registerHeading;

  /// No description provided for @registerSubheading.
  ///
  /// In id, this message translates to:
  /// **'Untuk siswa SMK/SMA jurusan RPL.'**
  String get registerSubheading;

  /// No description provided for @registerNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get registerNameLabel;

  /// No description provided for @registerNameHintAside.
  ///
  /// In id, this message translates to:
  /// **'Sesuai absen kelas'**
  String get registerNameHintAside;

  /// No description provided for @registerEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email Pelajar / Pribadi'**
  String get registerEmailLabel;

  /// No description provided for @registerEmailHintAside.
  ///
  /// In id, this message translates to:
  /// **'.belajar.id'**
  String get registerEmailHintAside;

  /// No description provided for @authPasswordStrengthHint.
  ///
  /// In id, this message translates to:
  /// **'Kombinasi sandi kuat'**
  String get authPasswordStrengthHint;

  /// No description provided for @registerConfirmLabel.
  ///
  /// In id, this message translates to:
  /// **'Konfirmasi Kata Sandi'**
  String get registerConfirmLabel;

  /// No description provided for @authSameExactlyHintAside.
  ///
  /// In id, this message translates to:
  /// **'Sama persis'**
  String get authSameExactlyHintAside;

  /// No description provided for @authRetypePasswordHint.
  ///
  /// In id, this message translates to:
  /// **'Ketik ulang kata sandimu'**
  String get authRetypePasswordHint;

  /// No description provided for @registerSubmit.
  ///
  /// In id, this message translates to:
  /// **'Buat Akun'**
  String get registerSubmit;

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In id, this message translates to:
  /// **'Sudah punya akun?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authLoginLink.
  ///
  /// In id, this message translates to:
  /// **'Masuk'**
  String get authLoginLink;

  /// No description provided for @registerTeacherLink.
  ///
  /// In id, this message translates to:
  /// **'Anda Guru / Pengajar? Daftar akun pendidik di sini →'**
  String get registerTeacherLink;

  /// No description provided for @registerSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Pendaftaran Berhasil! 🎉'**
  String get registerSuccessTitle;

  /// No description provided for @registerSuccessBody.
  ///
  /// In id, this message translates to:
  /// **'Akunmu sudah dibuat dan siap dipakai.\n\nSilakan masuk (login) menggunakan email dan kata sandi yang baru saja kamu buat.'**
  String get registerSuccessBody;

  /// No description provided for @registerCommunityPrefix.
  ///
  /// In id, this message translates to:
  /// **'Gabung bersama'**
  String get registerCommunityPrefix;

  /// No description provided for @registerCommunitySuffix.
  ///
  /// In id, this message translates to:
  /// **'rekan RPL yang mulai belajar logika algoritma, Git, dan web dev hari ini.'**
  String get registerCommunitySuffix;

  /// No description provided for @teacherRegTitle.
  ///
  /// In id, this message translates to:
  /// **'Registrasi Akun Pendidik'**
  String get teacherRegTitle;

  /// No description provided for @teacherRegTagBanner.
  ///
  /// In id, this message translates to:
  /// **'Kemitraan Instansi'**
  String get teacherRegTagBanner;

  /// No description provided for @teacherRegHeading.
  ///
  /// In id, this message translates to:
  /// **'Pilih Peran Akunmu'**
  String get teacherRegHeading;

  /// No description provided for @teacherRegSubheading.
  ///
  /// In id, this message translates to:
  /// **'Sesuaikan pengalaman belajar atau manajemen lab komputer sekolahmu.'**
  String get teacherRegSubheading;

  /// No description provided for @teacherRegVerifySectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi Sekolah & Lab'**
  String get teacherRegVerifySectionTitle;

  /// No description provided for @teacherRegStatusConnected.
  ///
  /// In id, this message translates to:
  /// **'Terkoneksi'**
  String get teacherRegStatusConnected;

  /// No description provided for @teacherRegStatusWaiting.
  ///
  /// In id, this message translates to:
  /// **'Menunggu kode'**
  String get teacherRegStatusWaiting;

  /// No description provided for @teacherRegSchoolCodeLabel.
  ///
  /// In id, this message translates to:
  /// **'Kode Registrasi Sekolah / Lab'**
  String get teacherRegSchoolCodeLabel;

  /// No description provided for @teacherRegSchoolCodeHintAside.
  ///
  /// In id, this message translates to:
  /// **'Dari dinas/sekolah'**
  String get teacherRegSchoolCodeHintAside;

  /// No description provided for @teacherRegSchoolCodeHint.
  ///
  /// In id, this message translates to:
  /// **'Contoh: SWADHIPA2-NTR'**
  String get teacherRegSchoolCodeHint;

  /// No description provided for @teacherRegSchoolCodeInvalid.
  ///
  /// In id, this message translates to:
  /// **'Ketik kode sekolah resmi hingga kartu hijau muncul.'**
  String get teacherRegSchoolCodeInvalid;

  /// No description provided for @teacherRegVerifyFirst.
  ///
  /// In id, this message translates to:
  /// **'Verifikasi sekolah dulu — ketik kode resmi lalu tunggu kartu hijau muncul.'**
  String get teacherRegVerifyFirst;

  /// No description provided for @teacherRegSchoolCodeNote.
  ///
  /// In id, this message translates to:
  /// **'Guru wajib memasukkan kode sekolah resmi agar terafiliasi dengan laboratorium sekolah.'**
  String get teacherRegSchoolCodeNote;

  /// No description provided for @teacherRegDataSectionTitle.
  ///
  /// In id, this message translates to:
  /// **'Data Pendidik Terdaftar'**
  String get teacherRegDataSectionTitle;

  /// No description provided for @teacherRegDataSectionNote.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi identitas pendidik untuk verifikasi sertifikat lab.'**
  String get teacherRegDataSectionNote;

  /// No description provided for @teacherRegNameLabel.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap & Gelar'**
  String get teacherRegNameLabel;

  /// No description provided for @teacherRegNameHintAside.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Budi Santoso, S.Kom'**
  String get teacherRegNameHintAside;

  /// No description provided for @teacherRegEmailLabel.
  ///
  /// In id, this message translates to:
  /// **'Email Pendidik / Instansi'**
  String get teacherRegEmailLabel;

  /// No description provided for @teacherRegEmailHintAside.
  ///
  /// In id, this message translates to:
  /// **'Email kantor'**
  String get teacherRegEmailHintAside;

  /// No description provided for @teacherRegSubmit.
  ///
  /// In id, this message translates to:
  /// **'Lanjutkan Pendaftaran Akun'**
  String get teacherRegSubmit;

  /// No description provided for @teacherRegSuccessBody.
  ///
  /// In id, this message translates to:
  /// **'Akun pengajarmu sudah dibuat untuk {school}.\n\nSilakan masuk (login) menggunakan email dan kata sandi yang baru saja kamu buat.'**
  String teacherRegSuccessBody(String school);

  /// No description provided for @teacherRegYourSchool.
  ///
  /// In id, this message translates to:
  /// **'sekolahmu'**
  String get teacherRegYourSchool;

  /// No description provided for @roleStudentChip.
  ///
  /// In id, this message translates to:
  /// **'Belajar Mandiri'**
  String get roleStudentChip;

  /// No description provided for @roleStudentTitle.
  ///
  /// In id, this message translates to:
  /// **'Siswa Belajar'**
  String get roleStudentTitle;

  /// No description provided for @roleStudentDesc.
  ///
  /// In id, this message translates to:
  /// **'Akses modul koding praktis & AI tutor 24/7'**
  String get roleStudentDesc;

  /// No description provided for @roleTeacherChip.
  ///
  /// In id, this message translates to:
  /// **'Akses Pendidik'**
  String get roleTeacherChip;

  /// No description provided for @roleTeacherTitle.
  ///
  /// In id, this message translates to:
  /// **'Guru / Instruktur'**
  String get roleTeacherTitle;

  /// No description provided for @roleTeacherDesc.
  ///
  /// In id, this message translates to:
  /// **'Kelola lab kelas, kurikulum & pantau siswa'**
  String get roleTeacherDesc;

  /// No description provided for @actionCopy.
  ///
  /// In id, this message translates to:
  /// **'Salin'**
  String get actionCopy;

  /// No description provided for @codeCopied.
  ///
  /// In id, this message translates to:
  /// **'Kode disalin.'**
  String get codeCopied;

  /// No description provided for @a11yShowPassword.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan kata sandi'**
  String get a11yShowPassword;

  /// No description provided for @a11yHidePassword.
  ///
  /// In id, this message translates to:
  /// **'Sembunyikan kata sandi'**
  String get a11yHidePassword;

  /// No description provided for @a11yOpenProfile.
  ///
  /// In id, this message translates to:
  /// **'Buka profil'**
  String get a11yOpenProfile;

  /// No description provided for @a11yMasteryRadar.
  ///
  /// In id, this message translates to:
  /// **'Radar penguasaan: {detail}'**
  String a11yMasteryRadar(String detail);

  /// No description provided for @loadingTipSubmitQuota.
  ///
  /// In id, this message translates to:
  /// **'Tekan \"{run}\" dulu sebelum \"{submit}\" — biar kuota harianmu aman.'**
  String loadingTipSubmitQuota(String run, String submit);

  /// No description provided for @loadingTipAiHint.
  ///
  /// In id, this message translates to:
  /// **'Bantuan AI hanya memberi petunjuk, bukan kode jadi. Jawabnya tetap kerjamu.'**
  String get loadingTipAiHint;

  /// No description provided for @loadingTipPlayground.
  ///
  /// In id, this message translates to:
  /// **'Playground menjalankan Python langsung di perangkat — tetap aktif walau offline.'**
  String get loadingTipPlayground;

  /// No description provided for @loadingTipHiddenTests.
  ///
  /// In id, this message translates to:
  /// **'Kasus uji rahasia tinggal di server, tidak ikut terkirim ke HP siswa.'**
  String get loadingTipHiddenTests;

  /// No description provided for @loadingVersionFooter.
  ///
  /// In id, this message translates to:
  /// **'Versi 2.1 · Kurikulum Merdeka RPL'**
  String get loadingVersionFooter;

  /// No description provided for @settingsLanguageTeacherLocked.
  ///
  /// In id, this message translates to:
  /// **'Pilihan bahasa dikunci sementara untuk akun pengajar.'**
  String get settingsLanguageTeacherLocked;

  /// No description provided for @tNavDashboard.
  ///
  /// In id, this message translates to:
  /// **'Dashboard'**
  String get tNavDashboard;

  /// No description provided for @tNavMaterials.
  ///
  /// In id, this message translates to:
  /// **'Materi'**
  String get tNavMaterials;

  /// No description provided for @tNavAnalytics.
  ///
  /// In id, this message translates to:
  /// **'Analisa'**
  String get tNavAnalytics;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
