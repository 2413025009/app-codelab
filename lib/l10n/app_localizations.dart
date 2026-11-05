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

  /// No description provided for @settingsHelpCenter.
  ///
  /// In id, this message translates to:
  /// **'Bantuan Admin'**
  String get settingsHelpCenter;

  /// No description provided for @settingsHelpCenterSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Hubungi admin via WhatsApp +62 831-2500-5309'**
  String get settingsHelpCenterSubtitle;

  /// No description provided for @settingsHelpLaunchFailed.
  ///
  /// In id, this message translates to:
  /// **'Tidak bisa membuka WhatsApp. Coba lagi.'**
  String get settingsHelpLaunchFailed;

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

  /// No description provided for @dashStageConnecting.
  ///
  /// In id, this message translates to:
  /// **'Menyambung ke server…'**
  String get dashStageConnecting;

  /// No description provided for @dashStageProfile.
  ///
  /// In id, this message translates to:
  /// **'Profil siswa terbaca'**
  String get dashStageProfile;

  /// No description provided for @dashStageProgress.
  ///
  /// In id, this message translates to:
  /// **'Kemajuan bab terbaca'**
  String get dashStageProgress;

  /// No description provided for @dashStageSkills.
  ///
  /// In id, this message translates to:
  /// **'Radar skill terbaca'**
  String get dashStageSkills;

  /// No description provided for @dashStageLessons.
  ///
  /// In id, this message translates to:
  /// **'Katalog materi terbaca'**
  String get dashStageLessons;

  /// No description provided for @dashStageChallenges.
  ///
  /// In id, this message translates to:
  /// **'Catatan tantangan terbaca'**
  String get dashStageChallenges;

  /// No description provided for @dashStageComposing.
  ///
  /// In id, this message translates to:
  /// **'Menyusun dashboard…'**
  String get dashStageComposing;

  /// No description provided for @dashGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name}'**
  String dashGreeting(String name);

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

  /// No description provided for @materialSwitchedSnack.
  ///
  /// In id, this message translates to:
  /// **'Menampilkan materi {topic}. Peta belajar diperbarui.'**
  String materialSwitchedSnack(String topic);

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

  /// No description provided for @classCountBadge.
  ///
  /// In id, this message translates to:
  /// **'{count} kelas'**
  String classCountBadge(int count);

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

  /// No description provided for @myClassesJoinAnother.
  ///
  /// In id, this message translates to:
  /// **'Gabung Kelas Lain'**
  String get myClassesJoinAnother;

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

  /// Judul layar memuat saat boot (pemulihan sesi).
  ///
  /// In id, this message translates to:
  /// **'Memulihkan sesimu…'**
  String get bootTitle;

  /// Subjudul layar memuat saat boot.
  ///
  /// In id, this message translates to:
  /// **'Menyiapkan lab kode di perangkat'**
  String get bootSubtitle;

  /// Label tahap boot: memeriksa penyimpanan aman.
  ///
  /// In id, this message translates to:
  /// **'Memeriksa penyimpanan aman'**
  String get bootStageSecureStorage;

  /// Pesan galat saat jawaban server kelas bukan format yang dikenali (bukan teks server).
  ///
  /// In id, this message translates to:
  /// **'Format jawaban kelas tidak dikenali.'**
  String get classResponseUnrecognized;

  /// No description provided for @slideTapToFillSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Tepat Sekali!'**
  String get slideTapToFillSuccessTitle;

  /// No description provided for @slideTapToFillSuccessMsg.
  ///
  /// In id, this message translates to:
  /// **'Sintaks berhasil disusun.'**
  String get slideTapToFillSuccessMsg;

  /// No description provided for @slideTapToFillErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Coba Periksa Lagi!'**
  String get slideTapToFillErrorTitle;

  /// No description provided for @slideTapToFillErrorMsg.
  ///
  /// In id, this message translates to:
  /// **'Perhatikan slot yang kosong.'**
  String get slideTapToFillErrorMsg;

  /// No description provided for @slideTypeCodeSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Luar Biasa!'**
  String get slideTypeCodeSuccessTitle;

  /// No description provided for @slideTypeCodeSuccessMsg.
  ///
  /// In id, this message translates to:
  /// **'Perintah yang kamu ketik tepat.'**
  String get slideTypeCodeSuccessMsg;

  /// No description provided for @slideTypeCodeErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Kurang Tepat!'**
  String get slideTypeCodeErrorTitle;

  /// No description provided for @slideTypeCodeErrorMsg.
  ///
  /// In id, this message translates to:
  /// **'Perhatikan penulisan huruf.'**
  String get slideTypeCodeErrorMsg;

  /// No description provided for @slideOutputPredictSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Mantap Jiwa!'**
  String get slideOutputPredictSuccessTitle;

  /// No description provided for @slideOutputPredictSuccessMsg.
  ///
  /// In id, this message translates to:
  /// **'Prediksi logikamu akurat.'**
  String get slideOutputPredictSuccessMsg;

  /// No description provided for @slideOutputPredictErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Kurang Tepat!'**
  String get slideOutputPredictErrorTitle;

  /// No description provided for @slideOutputPredictErrorMsg.
  ///
  /// In id, this message translates to:
  /// **'Perhatikan alur eksekusi baris demi baris.'**
  String get slideOutputPredictErrorMsg;

  /// No description provided for @slideBugHunterSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Hebat, Bug Ditemukan!'**
  String get slideBugHunterSuccessTitle;

  /// No description provided for @slideBugHunterSuccessMsg.
  ///
  /// In id, this message translates to:
  /// **'Kamu berhasil mendeteksi baris error.'**
  String get slideBugHunterSuccessMsg;

  /// No description provided for @slideBugHunterErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Bukan Baris Itu!'**
  String get slideBugHunterErrorTitle;

  /// No description provided for @slideBugHunterErrorMsg.
  ///
  /// In id, this message translates to:
  /// **'Cari baris yang melanggar aturan sintaks.'**
  String get slideBugHunterErrorMsg;

  /// No description provided for @slideQuizSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Jawaban Sempurna!'**
  String get slideQuizSuccessTitle;

  /// No description provided for @slideQuizSuccessMsg.
  ///
  /// In id, this message translates to:
  /// **'Pemahaman konsepmu sangat solid.'**
  String get slideQuizSuccessMsg;

  /// No description provided for @slideQuizErrorTitle.
  ///
  /// In id, this message translates to:
  /// **'Kurang Tepat!'**
  String get slideQuizErrorTitle;

  /// No description provided for @slideQuizErrorMsg.
  ///
  /// In id, this message translates to:
  /// **'Coba ingat kembali prinsip dasar materi ini.'**
  String get slideQuizErrorMsg;

  /// No description provided for @slideContentUnavailable.
  ///
  /// In id, this message translates to:
  /// **'Materi belum tersedia saat ini.'**
  String get slideContentUnavailable;

  /// No description provided for @tutorHintTabConcept.
  ///
  /// In id, this message translates to:
  /// **'Hint 1: Konsep'**
  String get tutorHintTabConcept;

  /// No description provided for @tutorHintTabLogic.
  ///
  /// In id, this message translates to:
  /// **'Hint 2: Logika'**
  String get tutorHintTabLogic;

  /// No description provided for @tutorHintTabStructure.
  ///
  /// In id, this message translates to:
  /// **'Hint 3: Struktur'**
  String get tutorHintTabStructure;

  /// No description provided for @tutorHintDefaultConcept.
  ///
  /// In id, this message translates to:
  /// **'Latihan Koding'**
  String get tutorHintDefaultConcept;

  /// No description provided for @tutorHintPlaygroundConcept.
  ///
  /// In id, this message translates to:
  /// **'Latihan Mandiri (Playground)'**
  String get tutorHintPlaygroundConcept;

  /// No description provided for @tutorHintChallengeQ1.
  ///
  /// In id, this message translates to:
  /// **'Apa output yang diminta soal ini? Ceritakan dulu dengan bahasamu sendiri sebelum menyentuh kode.'**
  String get tutorHintChallengeQ1;

  /// No description provided for @tutorHintChallengeQ1Step1.
  ///
  /// In id, this message translates to:
  /// **'Sebutkan input yang tersedia dan output yang harus muncul.'**
  String get tutorHintChallengeQ1Step1;

  /// No description provided for @tutorHintChallengeQ1Step2.
  ///
  /// In id, this message translates to:
  /// **'Tandai bagian kode yang sudah kamu pahami dan bagian yang masih ragu.'**
  String get tutorHintChallengeQ1Step2;

  /// No description provided for @tutorHintChallengeQ2.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana urutan langkah programmu dari baris pertama sampai terakhir?'**
  String get tutorHintChallengeQ2;

  /// No description provided for @tutorHintChallengeQ2Step1.
  ///
  /// In id, this message translates to:
  /// **'Tulis urutan langkahnya dalam bahasa sehari-hari, belum dalam kode.'**
  String get tutorHintChallengeQ2Step1;

  /// No description provided for @tutorHintChallengeQ2Step2.
  ///
  /// In id, this message translates to:
  /// **'Periksa apakah setiap langkah benar-benar mengarah ke output yang diminta soal.'**
  String get tutorHintChallengeQ2Step2;

  /// No description provided for @tutorHintChallengeQ3.
  ///
  /// In id, this message translates to:
  /// **'Baris mana yang paling sering memunculkan error saat kamu jalankan?'**
  String get tutorHintChallengeQ3;

  /// No description provided for @tutorHintChallengeQ3Step1.
  ///
  /// In id, this message translates to:
  /// **'Baca pesan error dari baris paling atas: nama error dan nomor barisnya.'**
  String get tutorHintChallengeQ3Step1;

  /// No description provided for @tutorHintChallengeQ3Step2.
  ///
  /// In id, this message translates to:
  /// **'Cocokkan tanda baca di baris itu (kurung, titik dua, tanda kutip, indentasi).'**
  String get tutorHintChallengeQ3Step2;

  /// No description provided for @tutorHintPlaygroundQ1.
  ///
  /// In id, this message translates to:
  /// **'Masalah apa yang paling ingin kamu pecahkan program ini? Tulis tujuannya dalam satu kalimat dulu.'**
  String get tutorHintPlaygroundQ1;

  /// No description provided for @tutorHintPlaygroundQ1Step1.
  ///
  /// In id, this message translates to:
  /// **'Petakan: input apa yang masuk, proses apa yang dilakukan, output apa yang diharapkan.'**
  String get tutorHintPlaygroundQ1Step1;

  /// No description provided for @tutorHintPlaygroundQ1Step2.
  ///
  /// In id, this message translates to:
  /// **'Mulai dari potongan paling kecil yang bisa kamu uji sendiri.'**
  String get tutorHintPlaygroundQ1Step2;

  /// No description provided for @tutorHintPlaygroundQ2.
  ///
  /// In id, this message translates to:
  /// **'Bagaimana urutan langkah programmu dari baris pertama sampai terakhir?'**
  String get tutorHintPlaygroundQ2;

  /// No description provided for @tutorHintPlaygroundQ2Step1.
  ///
  /// In id, this message translates to:
  /// **'Tulis alurnya sebagai pseudo-kode bahasa Indonesia sebelum disalin ke Python.'**
  String get tutorHintPlaygroundQ2Step1;

  /// No description provided for @tutorHintPlaygroundQ2Step2.
  ///
  /// In id, this message translates to:
  /// **'Tandai mana bagian yang berulang (loop) dan mana yang bercabang (if).'**
  String get tutorHintPlaygroundQ2Step2;

  /// No description provided for @tutorHintPlaygroundQ3.
  ///
  /// In id, this message translates to:
  /// **'Bagian mana dari kodemu yang tampak rancu saat dibaca?'**
  String get tutorHintPlaygroundQ3;

  /// No description provided for @tutorHintPlaygroundQ3Step1.
  ///
  /// In id, this message translates to:
  /// **'Cek indentasi dan tanda titik dua pada baris yang berisi logika.'**
  String get tutorHintPlaygroundQ3Step1;

  /// No description provided for @tutorHintPlaygroundQ3Step2.
  ///
  /// In id, this message translates to:
  /// **'Uji potongan kecil di terminal yang sama sebelum digabung kembali.'**
  String get tutorHintPlaygroundQ3Step2;

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

  /// No description provided for @tPickerTitle.
  ///
  /// In id, this message translates to:
  /// **'Analisa Kelas'**
  String get tPickerTitle;

  /// No description provided for @tPickerHeading.
  ///
  /// In id, this message translates to:
  /// **'Pilih Kelas'**
  String get tPickerHeading;

  /// No description provided for @tPickerSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih kelas untuk melihat peringkat materi dan latihan siswa, lalu kelola anggotanya.'**
  String get tPickerSubtitle;

  /// No description provided for @tPickerEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Kelas'**
  String get tPickerEmptyTitle;

  /// No description provided for @tPickerEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Buat kelas pertamamu di Dashboard untuk mulai memantau analisa siswa.'**
  String get tPickerEmptyBody;

  /// No description provided for @tPickerOpenDashboard.
  ///
  /// In id, this message translates to:
  /// **'Buka Dashboard'**
  String get tPickerOpenDashboard;

  /// No description provided for @tPickerSchoolUnset.
  ///
  /// In id, this message translates to:
  /// **'Sekolah belum diatur'**
  String get tPickerSchoolUnset;

  /// No description provided for @tPickerMemberCount.
  ///
  /// In id, this message translates to:
  /// **'{count} siswa'**
  String tPickerMemberCount(int count);

  /// No description provided for @tArchivedTitle.
  ///
  /// In id, this message translates to:
  /// **'Arsip Kelas'**
  String get tArchivedTitle;

  /// No description provided for @tArchivedInfo.
  ///
  /// In id, this message translates to:
  /// **'Kelas arsip tidak bisa diikuti siswa baru. Pulihkan kelas bila ingin mengaktifkannya lagi.'**
  String get tArchivedInfo;

  /// No description provided for @tArchivedLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal Memuat Arsip'**
  String get tArchivedLoadFailed;

  /// No description provided for @tArchivedEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Kelas Diarsipkan'**
  String get tArchivedEmptyTitle;

  /// No description provided for @tArchivedEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Kelas yang kamu arsipkan dari halaman analisa akan muncul di sini.'**
  String get tArchivedEmptyBody;

  /// No description provided for @tArchivedBackDashboard.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Dashboard'**
  String get tArchivedBackDashboard;

  /// No description provided for @tArchivedBadge.
  ///
  /// In id, this message translates to:
  /// **'Diarsipkan'**
  String get tArchivedBadge;

  /// No description provided for @tArchivedSchoolYear.
  ///
  /// In id, this message translates to:
  /// **'{school} • Tahun Ajaran {year}'**
  String tArchivedSchoolYear(String school, String year);

  /// No description provided for @tArchivedClassCode.
  ///
  /// In id, this message translates to:
  /// **'KODE KELAS'**
  String get tArchivedClassCode;

  /// No description provided for @tArchivedInactive.
  ///
  /// In id, this message translates to:
  /// **'Nonaktif'**
  String get tArchivedInactive;

  /// No description provided for @tArchivedRestore.
  ///
  /// In id, this message translates to:
  /// **'Pulihkan Kelas'**
  String get tArchivedRestore;

  /// No description provided for @tDashFilterTitle.
  ///
  /// In id, this message translates to:
  /// **'Filter Daftar Kelas'**
  String get tDashFilterTitle;

  /// No description provided for @tDashFilterSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pencarian dan tahun ajaran disaring dari data kelas yang sudah dimuat.'**
  String get tDashFilterSubtitle;

  /// No description provided for @tDashSearchHint.
  ///
  /// In id, this message translates to:
  /// **'Cari nama atau kode kelas'**
  String get tDashSearchHint;

  /// No description provided for @tDashClearSearch.
  ///
  /// In id, this message translates to:
  /// **'Bersihkan pencarian'**
  String get tDashClearSearch;

  /// No description provided for @tDashYearLabel.
  ///
  /// In id, this message translates to:
  /// **'Tahun Ajaran'**
  String get tDashYearLabel;

  /// No description provided for @tDashApplyFilter.
  ///
  /// In id, this message translates to:
  /// **'Terapkan Filter'**
  String get tDashApplyFilter;

  /// No description provided for @tDashFilterReset.
  ///
  /// In id, this message translates to:
  /// **'Reset'**
  String get tDashFilterReset;

  /// No description provided for @tDashCodeCopied.
  ///
  /// In id, this message translates to:
  /// **'Kode kelas \"{code}\" disalin ke clipboard!'**
  String tDashCodeCopied(String code);

  /// No description provided for @tDashCodeFullscreen.
  ///
  /// In id, this message translates to:
  /// **'KODE KELAS (LAYAR PENUH)'**
  String get tDashCodeFullscreen;

  /// No description provided for @tDashProjectorHint.
  ///
  /// In id, this message translates to:
  /// **'Buka aplikasi CodeLab AI dan masukkan kode kelas:'**
  String get tDashProjectorHint;

  /// No description provided for @tDashProjectorCopy.
  ///
  /// In id, this message translates to:
  /// **'Salin Kode'**
  String get tDashProjectorCopy;

  /// No description provided for @tDashCreateNewClass.
  ///
  /// In id, this message translates to:
  /// **'Buat Kelas Baru'**
  String get tDashCreateNewClass;

  /// No description provided for @tDashCreateSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Wadah identitas kelas untuk memantau kemajuan belajar siswa.'**
  String get tDashCreateSubtitle;

  /// No description provided for @tDashFieldName.
  ///
  /// In id, this message translates to:
  /// **'Nama Kelas *'**
  String get tDashFieldName;

  /// No description provided for @tDashExampleName.
  ///
  /// In id, this message translates to:
  /// **'Contoh: X RPL 1'**
  String get tDashExampleName;

  /// No description provided for @tDashFieldYear.
  ///
  /// In id, this message translates to:
  /// **'Tahun Ajaran *'**
  String get tDashFieldYear;

  /// No description provided for @tDashExampleYear.
  ///
  /// In id, this message translates to:
  /// **'Contoh: {year}'**
  String tDashExampleYear(String year);

  /// No description provided for @tDashCreateClass.
  ///
  /// In id, this message translates to:
  /// **'Buat Kelas'**
  String get tDashCreateClass;

  /// No description provided for @tDashValidationRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama kelas dan tahun ajaran wajib diisi.'**
  String get tDashValidationRequired;

  /// No description provided for @tDashSchoolUnset.
  ///
  /// In id, this message translates to:
  /// **'Sekolah belum terhubung'**
  String get tDashSchoolUnset;

  /// No description provided for @tDashGreeting.
  ///
  /// In id, this message translates to:
  /// **'Halo, {name} 👋'**
  String tDashGreeting(String name);

  /// No description provided for @tDashGreetingFallback.
  ///
  /// In id, this message translates to:
  /// **'Guru'**
  String get tDashGreetingFallback;

  /// No description provided for @tProfileTitle.
  ///
  /// In id, this message translates to:
  /// **'Profil Pengajar'**
  String get tProfileTitle;

  /// No description provided for @tDashBadgeTotal.
  ///
  /// In id, this message translates to:
  /// **'Total'**
  String get tDashBadgeTotal;

  /// No description provided for @tDashClassCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Kelas'**
  String tDashClassCount(int count);

  /// No description provided for @tDashActiveClasses.
  ///
  /// In id, this message translates to:
  /// **'Kelas Aktif'**
  String get tDashActiveClasses;

  /// No description provided for @tDashBadgeRegistered.
  ///
  /// In id, this message translates to:
  /// **'Terdaftar'**
  String get tDashBadgeRegistered;

  /// No description provided for @tDashRegisteredStudents.
  ///
  /// In id, this message translates to:
  /// **'Siswa Terdaftar'**
  String get tDashRegisteredStudents;

  /// No description provided for @tDashClassListTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Kelas Belajar'**
  String get tDashClassListTitle;

  /// No description provided for @tDashClassListSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih kelas untuk memantau kemajuan atau bagikan kode.'**
  String get tDashClassListSubtitle;

  /// No description provided for @tDashFilterTooltip.
  ///
  /// In id, this message translates to:
  /// **'Filter daftar kelas'**
  String get tDashFilterTooltip;

  /// No description provided for @tDashArchive.
  ///
  /// In id, this message translates to:
  /// **'Arsip'**
  String get tDashArchive;

  /// No description provided for @tDashSearchChip.
  ///
  /// In id, this message translates to:
  /// **'Cari: {query}'**
  String tDashSearchChip(String query);

  /// No description provided for @tDashResetFilter.
  ///
  /// In id, this message translates to:
  /// **'Reset filter'**
  String get tDashResetFilter;

  /// No description provided for @tDashEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Buat kelas pertamamu untuk mendapatkan kode kelas dan mulai memantau kemajuan belajar siswa.'**
  String get tDashEmptyBody;

  /// No description provided for @tDashNoMatchTitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Kelas yang Cocok'**
  String get tDashNoMatchTitle;

  /// No description provided for @tDashNoMatchBody.
  ///
  /// In id, this message translates to:
  /// **'Coba kata kunci lain atau tampilkan semua tahun ajaran.'**
  String get tDashNoMatchBody;

  /// No description provided for @tDashShowAll.
  ///
  /// In id, this message translates to:
  /// **'Tampilkan Semua Kelas'**
  String get tDashShowAll;

  /// No description provided for @tDashActiveYear.
  ///
  /// In id, this message translates to:
  /// **'Aktif {year}'**
  String tDashActiveYear(String year);

  /// No description provided for @tDashMetaMembers.
  ///
  /// In id, this message translates to:
  /// **'Anggota'**
  String get tDashMetaMembers;

  /// No description provided for @tDashProjector.
  ///
  /// In id, this message translates to:
  /// **'Proyektor Kode'**
  String get tDashProjector;

  /// No description provided for @tDashMonitor.
  ///
  /// In id, this message translates to:
  /// **'Pantau Kelas'**
  String get tDashMonitor;

  /// No description provided for @tProfileLogoutTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Akun Pengajar?'**
  String get tProfileLogoutTitle;

  /// No description provided for @tProfileLogoutBody.
  ///
  /// In id, this message translates to:
  /// **'Kamu perlu memasukkan email dan kata sandi kembali untuk masuk ke akun pengajar ini.'**
  String get tProfileLogoutBody;

  /// No description provided for @tProfileLogoutConfirm.
  ///
  /// In id, this message translates to:
  /// **'Ya, Keluar'**
  String get tProfileLogoutConfirm;

  /// No description provided for @tProfileNameFallback.
  ///
  /// In id, this message translates to:
  /// **'Pengajar RPL'**
  String get tProfileNameFallback;

  /// No description provided for @tProfileSettingsTooltip.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan Profil'**
  String get tProfileSettingsTooltip;

  /// No description provided for @tProfileRoleChip.
  ///
  /// In id, this message translates to:
  /// **'Instruktur RPL'**
  String get tProfileRoleChip;

  /// No description provided for @tProfileNip.
  ///
  /// In id, this message translates to:
  /// **'NIP: {code}'**
  String tProfileNip(String code);

  /// No description provided for @tProfileAddBio.
  ///
  /// In id, this message translates to:
  /// **'Tambah Bio'**
  String get tProfileAddBio;

  /// No description provided for @tProfileStatClasses.
  ///
  /// In id, this message translates to:
  /// **'Kelas Diajar'**
  String get tProfileStatClasses;

  /// No description provided for @tProfileStatStudents.
  ///
  /// In id, this message translates to:
  /// **'Siswa Dibimbing'**
  String get tProfileStatStudents;

  /// No description provided for @tProfileStatMaterials.
  ///
  /// In id, this message translates to:
  /// **'Materi Ajar'**
  String get tProfileStatMaterials;

  /// No description provided for @tProfileClassesTitle.
  ///
  /// In id, this message translates to:
  /// **'Kelas yang Diajar'**
  String get tProfileClassesTitle;

  /// No description provided for @tProfileNoClasses.
  ///
  /// In id, this message translates to:
  /// **'Belum ada kelas yang dibuat.'**
  String get tProfileNoClasses;

  /// No description provided for @tProfileClassMeta.
  ///
  /// In id, this message translates to:
  /// **'Tahun {year} • {count} Siswa'**
  String tProfileClassMeta(String year, int count);

  /// No description provided for @tProfileNoMaterials.
  ///
  /// In id, this message translates to:
  /// **'Belum ada materi yang dibuat.'**
  String get tProfileNoMaterials;

  /// No description provided for @tProfileMaterialCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Materi'**
  String tProfileMaterialCount(int count);

  /// No description provided for @tProfileMaterialMeta.
  ///
  /// In id, this message translates to:
  /// **'{topic} • {babs} Bab • {xp} XP'**
  String tProfileMaterialMeta(String topic, int babs, int xp);

  /// No description provided for @tProfilePublished.
  ///
  /// In id, this message translates to:
  /// **'Terbit'**
  String get tProfilePublished;

  /// No description provided for @tProfileDraft.
  ///
  /// In id, this message translates to:
  /// **'Draft'**
  String get tProfileDraft;

  /// No description provided for @tProfileOpenSettings.
  ///
  /// In id, this message translates to:
  /// **'Buka Pengaturan Akun'**
  String get tProfileOpenSettings;

  /// No description provided for @tProfileLogout.
  ///
  /// In id, this message translates to:
  /// **'Keluar dari Akun'**
  String get tProfileLogout;

  /// No description provided for @tStudioActionHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih tindakan untuk materi ini'**
  String get tStudioActionHint;

  /// No description provided for @tStudioEditSyllabus.
  ///
  /// In id, this message translates to:
  /// **'Edit Silabus & Bab'**
  String get tStudioEditSyllabus;

  /// No description provided for @tStudioEditInfo.
  ///
  /// In id, this message translates to:
  /// **'Edit Info Materi'**
  String get tStudioEditInfo;

  /// No description provided for @tStudioDuplicate.
  ///
  /// In id, this message translates to:
  /// **'Duplikat sebagai Draft Baru'**
  String get tStudioDuplicate;

  /// No description provided for @tStudioUnpublish.
  ///
  /// In id, this message translates to:
  /// **'Tarik Kembali ke Draft'**
  String get tStudioUnpublish;

  /// No description provided for @tStudioPublish.
  ///
  /// In id, this message translates to:
  /// **'Terbitkan ke Siswa'**
  String get tStudioPublish;

  /// No description provided for @tStudioDeleteForever.
  ///
  /// In id, this message translates to:
  /// **'Hapus Materi Selamanya'**
  String get tStudioDeleteForever;

  /// No description provided for @tStudioDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Materi Ini?'**
  String get tStudioDeleteTitle;

  /// No description provided for @tStudioDeleteBody.
  ///
  /// In id, this message translates to:
  /// **'Materi \"{title}\" akan dihapus dari Studio. Riwayat belajar siswa yang sudah tuntas tetap tersimpan.'**
  String tStudioDeleteBody(String title);

  /// No description provided for @tStudioTitle.
  ///
  /// In id, this message translates to:
  /// **'Studio Materi'**
  String get tStudioTitle;

  /// No description provided for @tStudioSettingsTooltip.
  ///
  /// In id, this message translates to:
  /// **'Pengaturan Pengajar'**
  String get tStudioSettingsTooltip;

  /// No description provided for @tStudioMyMaterials.
  ///
  /// In id, this message translates to:
  /// **'Materi Saya'**
  String get tStudioMyMaterials;

  /// No description provided for @tStudioSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Kelola modul pembelajaran & bab koding'**
  String get tStudioSubtitle;

  /// No description provided for @tStudioAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Materi'**
  String get tStudioAdd;

  /// No description provided for @tStudioBannerTitle.
  ///
  /// In id, this message translates to:
  /// **'Status Pembelajaran Kelas'**
  String get tStudioBannerTitle;

  /// No description provided for @tStudioBanner.
  ///
  /// In id, this message translates to:
  /// **'{published} materi aktif terbit untuk {students} siswa di {school}.'**
  String tStudioBanner(int published, int students, String school);

  /// No description provided for @tStudioYourSchool.
  ///
  /// In id, this message translates to:
  /// **'sekolahmu'**
  String get tStudioYourSchool;

  /// No description provided for @tStudioFilterAll.
  ///
  /// In id, this message translates to:
  /// **'Semua ({count})'**
  String tStudioFilterAll(int count);

  /// No description provided for @tStudioFilterDraft.
  ///
  /// In id, this message translates to:
  /// **'Draft ({count})'**
  String tStudioFilterDraft(int count);

  /// No description provided for @tStudioFilterPublished.
  ///
  /// In id, this message translates to:
  /// **'Terbit ({count})'**
  String tStudioFilterPublished(int count);

  /// No description provided for @tStudioEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Materi'**
  String get tStudioEmptyTitle;

  /// No description provided for @tStudioEmptyDraftTitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Materi Draft'**
  String get tStudioEmptyDraftTitle;

  /// No description provided for @tStudioEmptyPublishedTitle.
  ///
  /// In id, this message translates to:
  /// **'Tidak Ada Materi Terbit'**
  String get tStudioEmptyPublishedTitle;

  /// No description provided for @tStudioEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Mulai bangun kurikulum coding untuk siswamu. Klik tombol Tambah Materi di atas.'**
  String get tStudioEmptyBody;

  /// No description provided for @tStudioEmptyFilterBody.
  ///
  /// In id, this message translates to:
  /// **'Ganti filter atau tambahkan materi baru untuk kategori ini.'**
  String get tStudioEmptyFilterBody;

  /// No description provided for @tStudioCreateNew.
  ///
  /// In id, this message translates to:
  /// **'Buat Materi Baru'**
  String get tStudioCreateNew;

  /// No description provided for @tStudioBabCount.
  ///
  /// In id, this message translates to:
  /// **'{count} bab'**
  String tStudioBabCount(int count);

  /// No description provided for @tStudioNotVisible.
  ///
  /// In id, this message translates to:
  /// **'Belum tampak oleh siswa'**
  String get tStudioNotVisible;

  /// No description provided for @tBabDeleteTitle.
  ///
  /// In id, this message translates to:
  /// **'Hapus Bab Ini?'**
  String get tBabDeleteTitle;

  /// No description provided for @tBabDeleteBody.
  ///
  /// In id, this message translates to:
  /// **'Bab \"{title}\" akan dihapus dari daftar materi. Riwayat belajar siswa yang sudah tercatat tetap tersimpan.'**
  String tBabDeleteBody(String title);

  /// No description provided for @tBabDuplicateTitle.
  ///
  /// In id, this message translates to:
  /// **'Duplikat Bab Ini?'**
  String get tBabDuplicateTitle;

  /// No description provided for @tBabDuplicateBody.
  ///
  /// In id, this message translates to:
  /// **'Salinan \"{title}\" akan muncul sebagai bab nomor berikutnya, lengkap dengan seluruh slide dan XP-nya.'**
  String tBabDuplicateBody(String title);

  /// No description provided for @tBabDuplicate.
  ///
  /// In id, this message translates to:
  /// **'Duplikat'**
  String get tBabDuplicate;

  /// No description provided for @tBabTitle.
  ///
  /// In id, this message translates to:
  /// **'Silabus & Bab'**
  String get tBabTitle;

  /// No description provided for @tBabAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Bab'**
  String get tBabAdd;

  /// No description provided for @tBabTopicFallback.
  ///
  /// In id, this message translates to:
  /// **'Materi Studio'**
  String get tBabTopicFallback;

  /// No description provided for @tBabTitleFallback.
  ///
  /// In id, this message translates to:
  /// **'Daftar Bab'**
  String get tBabTitleFallback;

  /// No description provided for @tBabCurriculumStatus.
  ///
  /// In id, this message translates to:
  /// **'Status Kurikulum Bab'**
  String get tBabCurriculumStatus;

  /// No description provided for @tBabMeta.
  ///
  /// In id, this message translates to:
  /// **'{babs} Bab • {xp} XP'**
  String tBabMeta(int babs, int xp);

  /// No description provided for @tBabPublishedHint.
  ///
  /// In id, this message translates to:
  /// **'Seluruh bab aktif terbaca oleh siswa di kelasmu.'**
  String get tBabPublishedHint;

  /// No description provided for @tBabDraftHint.
  ///
  /// In id, this message translates to:
  /// **'Materi berstatus Draft. Siswa belum dapat melihat bab-bab ini.'**
  String get tBabDraftHint;

  /// No description provided for @tBabListTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Bab Terstruktur'**
  String get tBabListTitle;

  /// No description provided for @tBabFlowOrder.
  ///
  /// In id, this message translates to:
  /// **'Urutan Alur Belajar'**
  String get tBabFlowOrder;

  /// No description provided for @tBabEmptyTitle.
  ///
  /// In id, this message translates to:
  /// **'Belum Ada Bab'**
  String get tBabEmptyTitle;

  /// No description provided for @tBabEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Materi ini belum memiliki bab pembelajaran. Tambahkan bab pertama untuk mulai menyusun slide kuis dan teori.'**
  String get tBabEmptyBody;

  /// No description provided for @tBabAddFirst.
  ///
  /// In id, this message translates to:
  /// **'Tambah Bab Pertama'**
  String get tBabAddFirst;

  /// No description provided for @tBabRowMeta.
  ///
  /// In id, this message translates to:
  /// **'{slides} Slide • {xp} XP'**
  String tBabRowMeta(int slides, int xp);

  /// No description provided for @tBabMoveUp.
  ///
  /// In id, this message translates to:
  /// **'Pindah ke atas'**
  String get tBabMoveUp;

  /// No description provided for @tBabMoveDown.
  ///
  /// In id, this message translates to:
  /// **'Pindah ke bawah'**
  String get tBabMoveDown;

  /// No description provided for @tBabPreviewTooltip.
  ///
  /// In id, this message translates to:
  /// **'Simulator Siswa (Pratinjau)'**
  String get tBabPreviewTooltip;

  /// No description provided for @tBabActionTooltip.
  ///
  /// In id, this message translates to:
  /// **'Aksi bab'**
  String get tBabActionTooltip;

  /// No description provided for @tBabEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit Bab'**
  String get tBabEdit;

  /// No description provided for @tBabDuplicateMenu.
  ///
  /// In id, this message translates to:
  /// **'Duplikat Bab'**
  String get tBabDuplicateMenu;

  /// No description provided for @tBabDeleteMenu.
  ///
  /// In id, this message translates to:
  /// **'Hapus Bab'**
  String get tBabDeleteMenu;

  /// No description provided for @tFormLevelDescBeginner.
  ///
  /// In id, this message translates to:
  /// **'Level dasar: ditujukan bagi siswa yang baru mengenal logika pemrograman.'**
  String get tFormLevelDescBeginner;

  /// No description provided for @tFormLevelDescIntermediate.
  ///
  /// In id, this message translates to:
  /// **'Level menengah: percabangan lanjutan, perulangan, & manipulasi data.'**
  String get tFormLevelDescIntermediate;

  /// No description provided for @tFormLevelDescAdvanced.
  ///
  /// In id, this message translates to:
  /// **'Level mahir: algoritma rekursif kompleks & optimasi pemecahan masalah.'**
  String get tFormLevelDescAdvanced;

  /// No description provided for @tFormNotFound.
  ///
  /// In id, this message translates to:
  /// **'Materi tidak ditemukan. Kembali ke Studio Materi untuk memilih materi lain.'**
  String get tFormNotFound;

  /// No description provided for @tFormTitleRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama materi wajib diisi.'**
  String get tFormTitleRequired;

  /// No description provided for @tFormTitleDuplicate.
  ///
  /// In id, this message translates to:
  /// **'Nama materi sudah dipakai. Gunakan nama lain agar siswa tidak bingung.'**
  String get tFormTitleDuplicate;

  /// No description provided for @tFormUpdated.
  ///
  /// In id, this message translates to:
  /// **'Materi berhasil diperbarui.'**
  String get tFormUpdated;

  /// No description provided for @tFormSavedDraft.
  ///
  /// In id, this message translates to:
  /// **'Materi tersimpan sebagai draft.'**
  String get tFormSavedDraft;

  /// No description provided for @tFormSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Materi belum tersimpan. Periksa koneksi lalu coba lagi.'**
  String get tFormSaveFailed;

  /// No description provided for @tFormUnsavedTitle.
  ///
  /// In id, this message translates to:
  /// **'Perubahan Belum Disimpan'**
  String get tFormUnsavedTitle;

  /// No description provided for @tFormUnsavedBody.
  ///
  /// In id, this message translates to:
  /// **'Ada revisi pada form materi ini. Simpan perubahan sebagai draft terlebih dahulu atau abaikan?'**
  String get tFormUnsavedBody;

  /// No description provided for @tFormSaveExit.
  ///
  /// In id, this message translates to:
  /// **'Simpan Draft & Keluar'**
  String get tFormSaveExit;

  /// No description provided for @tFormDiscard.
  ///
  /// In id, this message translates to:
  /// **'Buang Perubahan'**
  String get tFormDiscard;

  /// No description provided for @tFormKeepEditing.
  ///
  /// In id, this message translates to:
  /// **'Lanjut Mengedit'**
  String get tFormKeepEditing;

  /// No description provided for @tFormEdit.
  ///
  /// In id, this message translates to:
  /// **'Edit Materi'**
  String get tFormEdit;

  /// No description provided for @tFormLoadFailed.
  ///
  /// In id, this message translates to:
  /// **'Materi Tidak Dapat Dimuat'**
  String get tFormLoadFailed;

  /// No description provided for @tFormOpenStudio.
  ///
  /// In id, this message translates to:
  /// **'Buka Studio Materi'**
  String get tFormOpenStudio;

  /// No description provided for @tFormAdd.
  ///
  /// In id, this message translates to:
  /// **'Tambah Materi Baru'**
  String get tFormAdd;

  /// No description provided for @tFormModeEdit.
  ///
  /// In id, this message translates to:
  /// **'Mode Edit'**
  String get tFormModeEdit;

  /// No description provided for @tFormNewBadge.
  ///
  /// In id, this message translates to:
  /// **'Materi Baru'**
  String get tFormNewBadge;

  /// No description provided for @tFormEditHeading.
  ///
  /// In id, this message translates to:
  /// **'Ubah Pengaturan Materi'**
  String get tFormEditHeading;

  /// No description provided for @tFormAddHeading.
  ///
  /// In id, this message translates to:
  /// **'Konfigurasi Materi Baru'**
  String get tFormAddHeading;

  /// No description provided for @tFormSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Konfigurasikan judul, track kurikulum, dan level kesulitan untuk ditampilkan ke siswa.'**
  String get tFormSubtitle;

  /// No description provided for @tFormFieldName.
  ///
  /// In id, this message translates to:
  /// **'Nama Materi *'**
  String get tFormFieldName;

  /// No description provided for @tFormExampleName.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Dasar Algoritma & Python RPL'**
  String get tFormExampleName;

  /// No description provided for @tFormFieldDesc.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi Singkat *'**
  String get tFormFieldDesc;

  /// No description provided for @tFormDescHint.
  ///
  /// In id, this message translates to:
  /// **'Jelaskan capaian materi dalam 2-3 kalimat ringkas...'**
  String get tFormDescHint;

  /// No description provided for @tFormFieldIcon.
  ///
  /// In id, this message translates to:
  /// **'Kode Ikon Materi *'**
  String get tFormFieldIcon;

  /// No description provided for @tFormIconHint.
  ///
  /// In id, this message translates to:
  /// **'Pilih preset ikon atau ketik nama kode ikon (misal: terminal, html, css, javascript, database, psychology, shield, phone_android).'**
  String get tFormIconHint;

  /// No description provided for @tFormExampleIcon.
  ///
  /// In id, this message translates to:
  /// **'Contoh: terminal'**
  String get tFormExampleIcon;

  /// No description provided for @tFormFieldTopic.
  ///
  /// In id, this message translates to:
  /// **'Topik / Track Kurikulum *'**
  String get tFormFieldTopic;

  /// No description provided for @tFormFieldLevel.
  ///
  /// In id, this message translates to:
  /// **'Tingkat Kesulitan *'**
  String get tFormFieldLevel;

  /// No description provided for @tFormDraftNotice.
  ///
  /// In id, this message translates to:
  /// **'Materi baru disimpan sebagai Draft. Materi hanya terlihat oleh siswa setelah kamu menekan tombol \"Terbitkan\".'**
  String get tFormDraftNotice;

  /// No description provided for @tFormSaveDraft.
  ///
  /// In id, this message translates to:
  /// **'Simpan Draft'**
  String get tFormSaveDraft;

  /// No description provided for @tFormContinueBabs.
  ///
  /// In id, this message translates to:
  /// **'Lanjut ke Bab'**
  String get tFormContinueBabs;

  /// No description provided for @tSlideNotFound.
  ///
  /// In id, this message translates to:
  /// **'Slide tidak ditemukan. Buka Bab Builder untuk memilih slide lain.'**
  String get tSlideNotFound;

  /// No description provided for @tSlideTemplateApplied.
  ///
  /// In id, this message translates to:
  /// **'Template awal \"{label}\" dipakai.'**
  String tSlideTemplateApplied(String label);

  /// No description provided for @tSlideBabUnsaved.
  ///
  /// In id, this message translates to:
  /// **'Bab baru belum tersimpan. Tambahkan slide dari Bab Builder agar tersimpan bersama bab.'**
  String get tSlideBabUnsaved;

  /// No description provided for @tSlideSaveNoBab.
  ///
  /// In id, this message translates to:
  /// **'Slide tidak dapat disimpan. Buka Bab Builder untuk memuat ulang bab.'**
  String get tSlideSaveNoBab;

  /// No description provided for @tSlideSaveFailed.
  ///
  /// In id, this message translates to:
  /// **'Slide gagal disimpan. Coba lagi.'**
  String get tSlideSaveFailed;

  /// No description provided for @tSlideSaved.
  ///
  /// In id, this message translates to:
  /// **'Slide tersimpan ke bab.'**
  String get tSlideSaved;

  /// No description provided for @tSlideEditorTitle.
  ///
  /// In id, this message translates to:
  /// **'Editor Slide'**
  String get tSlideEditorTitle;

  /// No description provided for @tSlideLoadFailedTitle.
  ///
  /// In id, this message translates to:
  /// **'Slide Tidak Dapat Dimuat'**
  String get tSlideLoadFailedTitle;

  /// No description provided for @tSlideOpenBabBuilder.
  ///
  /// In id, this message translates to:
  /// **'Buka Bab Builder'**
  String get tSlideOpenBabBuilder;

  /// No description provided for @tSlidePreviewTooltip.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau slide'**
  String get tSlidePreviewTooltip;

  /// No description provided for @tSlideHeader.
  ///
  /// In id, this message translates to:
  /// **'Slide {index} • {label}'**
  String tSlideHeader(int index, String label);

  /// No description provided for @tSlidePreviewAsStudent.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau sebagai Siswa'**
  String get tSlidePreviewAsStudent;

  /// No description provided for @tSlideUseTemplate.
  ///
  /// In id, this message translates to:
  /// **'Pakai Template Awal'**
  String get tSlideUseTemplate;

  /// No description provided for @tSlideSave.
  ///
  /// In id, this message translates to:
  /// **'Simpan Slide'**
  String get tSlideSave;

  /// No description provided for @tSlideTooLong.
  ///
  /// In id, this message translates to:
  /// **'{label} terlalu panjang (maksimal {max} karakter).'**
  String tSlideTooLong(String label, int max);

  /// No description provided for @tSlideRequired.
  ///
  /// In id, this message translates to:
  /// **'{label} wajib diisi.'**
  String tSlideRequired(String label);

  /// No description provided for @tSlideMaxItems.
  ///
  /// In id, this message translates to:
  /// **'{label} maksimal {limit} butir.'**
  String tSlideMaxItems(String label, int limit);

  /// No description provided for @tSlideChoiceEmpty.
  ///
  /// In id, this message translates to:
  /// **'Pilihan {letter} pada {label} masih kosong.'**
  String tSlideChoiceEmpty(String letter, String label);

  /// No description provided for @tSlideChoiceKey.
  ///
  /// In id, this message translates to:
  /// **'Pilih salah satu kunci jawaban A–D pada {label}.'**
  String tSlideChoiceKey(String label);

  /// No description provided for @tSlideSlotEmpty.
  ///
  /// In id, this message translates to:
  /// **'Kunci jawaban slot {n} masih kosong.'**
  String tSlideSlotEmpty(int n);

  /// No description provided for @tSlideTapMarkerMissing.
  ///
  /// In id, this message translates to:
  /// **'Kode soal belum punya penanda [KETIK_DISINI] sebagai tempat siswa mengetik.'**
  String get tSlideTapMarkerMissing;

  /// No description provided for @tSlideBugHintOrFix.
  ///
  /// In id, this message translates to:
  /// **'Isi \"Pesan Indikator\" atau \"Kode Perbaikan Valid\" agar siswa mendapat penjelasan setelah menjawab.'**
  String get tSlideBugHintOrFix;

  /// No description provided for @tSlideConceptRequired.
  ///
  /// In id, this message translates to:
  /// **'Isi minimal satu konsep yang dikuasai.'**
  String get tSlideConceptRequired;

  /// No description provided for @tSlideTemplateNoSlot.
  ///
  /// In id, this message translates to:
  /// **'Template kode belum punya slot. Tandai bagian kosong dengan ___1___, ___2___, dan seterusnya.'**
  String get tSlideTemplateNoSlot;

  /// No description provided for @tSlideDistractorRequired.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan minimal satu pengecoh agar soal bisa dipilih.'**
  String get tSlideDistractorRequired;

  /// No description provided for @tSlideDistractorsSame.
  ///
  /// In id, this message translates to:
  /// **'Semua pengecoh sama dengan kunci jawaban. Tambahkan pilihan lain.'**
  String get tSlideDistractorsSame;

  /// No description provided for @tSlideTargetNotNumber.
  ///
  /// In id, this message translates to:
  /// **'Target nomor baris harus berupa angka.'**
  String get tSlideTargetNotNumber;

  /// No description provided for @tSlideTargetRange.
  ///
  /// In id, this message translates to:
  /// **'Target nomor baris harus antara 1 dan {n} sesuai jumlah baris kode.'**
  String tSlideTargetRange(int n);

  /// No description provided for @tSlideFieldExerciseTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul latihan'**
  String get tSlideFieldExerciseTitle;

  /// No description provided for @tSlideFieldInstruction.
  ///
  /// In id, this message translates to:
  /// **'Instruksi'**
  String get tSlideFieldInstruction;

  /// No description provided for @tSlideFieldQuestionTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul soal'**
  String get tSlideFieldQuestionTitle;

  /// No description provided for @tSlideFieldQuestionCode.
  ///
  /// In id, this message translates to:
  /// **'Kode soal'**
  String get tSlideFieldQuestionCode;

  /// No description provided for @tSlideFieldAnswerKeyword.
  ///
  /// In id, this message translates to:
  /// **'Kata kunci jawaban'**
  String get tSlideFieldAnswerKeyword;

  /// No description provided for @tSlideFieldHint.
  ///
  /// In id, this message translates to:
  /// **'Petunjuk'**
  String get tSlideFieldHint;

  /// No description provided for @tSlideFieldSlideTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul slide'**
  String get tSlideFieldSlideTitle;

  /// No description provided for @tSlideFieldCodeBlock.
  ///
  /// In id, this message translates to:
  /// **'Blok kode'**
  String get tSlideFieldCodeBlock;

  /// No description provided for @tSlideFieldOutputChoices.
  ///
  /// In id, this message translates to:
  /// **'pilihan output'**
  String get tSlideFieldOutputChoices;

  /// No description provided for @tSlideFieldExplanation.
  ///
  /// In id, this message translates to:
  /// **'Penjelasan'**
  String get tSlideFieldExplanation;

  /// No description provided for @tSlideFieldChallengeTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tantangan'**
  String get tSlideFieldChallengeTitle;

  /// No description provided for @tSlideFieldScenario.
  ///
  /// In id, this message translates to:
  /// **'Skenario'**
  String get tSlideFieldScenario;

  /// No description provided for @tSlideFieldProgramCode.
  ///
  /// In id, this message translates to:
  /// **'Kode program'**
  String get tSlideFieldProgramCode;

  /// No description provided for @tSlideFieldErrorType.
  ///
  /// In id, this message translates to:
  /// **'Jenis error'**
  String get tSlideFieldErrorType;

  /// No description provided for @tSlideFieldBugHint.
  ///
  /// In id, this message translates to:
  /// **'Pesan indikator'**
  String get tSlideFieldBugHint;

  /// No description provided for @tSlideFieldFixCode.
  ///
  /// In id, this message translates to:
  /// **'Kode perbaikan'**
  String get tSlideFieldFixCode;

  /// No description provided for @tSlideFieldQuizQuestion.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan kuis'**
  String get tSlideFieldQuizQuestion;

  /// No description provided for @tSlideFieldAnswerChoices.
  ///
  /// In id, this message translates to:
  /// **'pilihan jawaban'**
  String get tSlideFieldAnswerChoices;

  /// No description provided for @tSlideFieldFeedback.
  ///
  /// In id, this message translates to:
  /// **'Umpan balik'**
  String get tSlideFieldFeedback;

  /// No description provided for @tSlideFieldOutroTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul slide penutup'**
  String get tSlideFieldOutroTitle;

  /// No description provided for @tSlideFieldSummary.
  ///
  /// In id, this message translates to:
  /// **'Rangkuman materi'**
  String get tSlideFieldSummary;

  /// No description provided for @tSlideFieldMasteredConcepts.
  ///
  /// In id, this message translates to:
  /// **'Konsep yang dikuasai'**
  String get tSlideFieldMasteredConcepts;

  /// No description provided for @tSlideFieldTheoryTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul materi teori'**
  String get tSlideFieldTheoryTitle;

  /// No description provided for @tSlideFieldTheoryContent.
  ///
  /// In id, this message translates to:
  /// **'Konten penjelasan'**
  String get tSlideFieldTheoryContent;

  /// No description provided for @tSlideFieldSampleCode.
  ///
  /// In id, this message translates to:
  /// **'Cuplikan kode sampel'**
  String get tSlideFieldSampleCode;

  /// No description provided for @tSlideFieldCodeLanguage.
  ///
  /// In id, this message translates to:
  /// **'Bahasa kode'**
  String get tSlideFieldCodeLanguage;

  /// No description provided for @tSlideFieldCodeTemplate.
  ///
  /// In id, this message translates to:
  /// **'Template kode'**
  String get tSlideFieldCodeTemplate;

  /// No description provided for @tSlideFieldAnswerKey.
  ///
  /// In id, this message translates to:
  /// **'Kunci jawaban'**
  String get tSlideFieldAnswerKey;

  /// No description provided for @tSlideFieldSlotAnswer.
  ///
  /// In id, this message translates to:
  /// **'Kunci jawaban slot'**
  String get tSlideFieldSlotAnswer;

  /// No description provided for @tSlideFieldDistractors.
  ///
  /// In id, this message translates to:
  /// **'Pengecoh'**
  String get tSlideFieldDistractors;

  /// No description provided for @tSlideFieldTargetLine.
  ///
  /// In id, this message translates to:
  /// **'Target nomor baris'**
  String get tSlideFieldTargetLine;

  /// No description provided for @tBabNotFound.
  ///
  /// In id, this message translates to:
  /// **'Bab tidak ditemukan. Buka daftar bab untuk memilih bab lain.'**
  String get tBabNotFound;

  /// No description provided for @tBabSlideEmptyHint.
  ///
  /// In id, this message translates to:
  /// **'Belum ada isi. Ketuk Edit Konten untuk mulai.'**
  String get tBabSlideEmptyHint;

  /// No description provided for @tBabMinSlides.
  ///
  /// In id, this message translates to:
  /// **'Bab minimal harus memiliki 1 slide.'**
  String get tBabMinSlides;

  /// No description provided for @tBabTitleRequired.
  ///
  /// In id, this message translates to:
  /// **'Nama bab wajib diisi.'**
  String get tBabTitleRequired;

  /// No description provided for @tBabUpdated.
  ///
  /// In id, this message translates to:
  /// **'Bab berhasil diperbarui.'**
  String get tBabUpdated;

  /// No description provided for @tBabCreated.
  ///
  /// In id, this message translates to:
  /// **'Bab baru berhasil ditambahkan.'**
  String get tBabCreated;

  /// No description provided for @tBabMinSlidesPreview.
  ///
  /// In id, this message translates to:
  /// **'Bab minimal harus memiliki 1 slide untuk disimulasikan.'**
  String get tBabMinSlidesPreview;

  /// No description provided for @tBabPreviewFallback.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Bab'**
  String get tBabPreviewFallback;

  /// No description provided for @tBabEditTitle.
  ///
  /// In id, this message translates to:
  /// **'Edit Bab'**
  String get tBabEditTitle;

  /// No description provided for @tBabLoadFailedTitle.
  ///
  /// In id, this message translates to:
  /// **'Bab Tidak Dapat Dimuat'**
  String get tBabLoadFailedTitle;

  /// No description provided for @tBabOpenList.
  ///
  /// In id, this message translates to:
  /// **'Buka Daftar Bab'**
  String get tBabOpenList;

  /// No description provided for @tBabBuilderTitle.
  ///
  /// In id, this message translates to:
  /// **'Bab Builder'**
  String get tBabBuilderTitle;

  /// No description provided for @tBabFieldName.
  ///
  /// In id, this message translates to:
  /// **'Nama Bab *'**
  String get tBabFieldName;

  /// No description provided for @tBabExampleName.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Pengenalan Tag & Dokumen HTML'**
  String get tBabExampleName;

  /// No description provided for @tBabXpTitle.
  ///
  /// In id, this message translates to:
  /// **'XP Hadiah Bab'**
  String get tBabXpTitle;

  /// No description provided for @tBabXpHint.
  ///
  /// In id, this message translates to:
  /// **'Diberikan saat siswa menuntaskan bab'**
  String get tBabXpHint;

  /// No description provided for @tBabFlowTitle.
  ///
  /// In id, this message translates to:
  /// **'Alur Slide'**
  String get tBabFlowTitle;

  /// No description provided for @tBabSlideCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Unit'**
  String tBabSlideCount(int count);

  /// No description provided for @tBabAddSlide.
  ///
  /// In id, this message translates to:
  /// **'Tambah Slide'**
  String get tBabAddSlide;

  /// No description provided for @tBabDeleteSlide.
  ///
  /// In id, this message translates to:
  /// **'Hapus slide'**
  String get tBabDeleteSlide;

  /// No description provided for @tBabEditSlideContent.
  ///
  /// In id, this message translates to:
  /// **'Edit Konten Slide'**
  String get tBabEditSlideContent;

  /// No description provided for @tBabSaveChanges.
  ///
  /// In id, this message translates to:
  /// **'Simpan Perubahan Bab'**
  String get tBabSaveChanges;

  /// No description provided for @tBabSaveNew.
  ///
  /// In id, this message translates to:
  /// **'Simpan Bab Baru'**
  String get tBabSaveNew;

  /// No description provided for @tBabPickerTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Jenis Slide Baru'**
  String get tBabPickerTitle;

  /// No description provided for @tBabFormatCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Format'**
  String tBabFormatCount(int count);

  /// No description provided for @tBabPickerHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk ikon mata untuk melihat pratinjau simulasi koding, atau pilih langsung untuk menambahkan ke alur bab.'**
  String get tBabPickerHint;

  /// No description provided for @tBabPreviewFormatTooltip.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Format Interaktif'**
  String get tBabPreviewFormatTooltip;

  /// No description provided for @tBabPickerAddTooltip.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan Slide'**
  String get tBabPickerAddTooltip;

  /// No description provided for @tBabBentoTitle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Jenis Slide / Latihan Koding'**
  String get tBabBentoTitle;

  /// No description provided for @tBabBentoHint.
  ///
  /// In id, this message translates to:
  /// **'Ketuk \"Pratinjau\" untuk simulasi koding siswa, atau tekan \"Gunakan\" untuk memasukkan ke alur bab.'**
  String get tBabBentoHint;

  /// No description provided for @tBabPreviewButton.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau'**
  String get tBabPreviewButton;

  /// No description provided for @tBabUseButton.
  ///
  /// In id, this message translates to:
  /// **'Gunakan'**
  String get tBabUseButton;

  /// No description provided for @tBabTypeTheoryName.
  ///
  /// In id, this message translates to:
  /// **'Teori & Konsep'**
  String get tBabTypeTheoryName;

  /// No description provided for @tBabTypeTapName.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi Kode'**
  String get tBabTypeTapName;

  /// No description provided for @tBabTypeTypeName.
  ///
  /// In id, this message translates to:
  /// **'Ketik Kata Kunci'**
  String get tBabTypeTypeName;

  /// No description provided for @tBabTypeOutputName.
  ///
  /// In id, this message translates to:
  /// **'Tebak Output'**
  String get tBabTypeOutputName;

  /// No description provided for @tBabTypeBugName.
  ///
  /// In id, this message translates to:
  /// **'Bug Hunter'**
  String get tBabTypeBugName;

  /// No description provided for @tBabTypeQuizName.
  ///
  /// In id, this message translates to:
  /// **'Kuis Pilihan Ganda'**
  String get tBabTypeQuizName;

  /// No description provided for @tBabTypeOutroName.
  ///
  /// In id, this message translates to:
  /// **'Rangkuman & Klaim XP'**
  String get tBabTypeOutroName;

  /// No description provided for @tBabTypeTheoryBadge.
  ///
  /// In id, this message translates to:
  /// **'Bahan Baca'**
  String get tBabTypeTheoryBadge;

  /// No description provided for @tBabTypeTapBadge.
  ///
  /// In id, this message translates to:
  /// **'Interaktif'**
  String get tBabTypeTapBadge;

  /// No description provided for @tBabTypeTypeBadge.
  ///
  /// In id, this message translates to:
  /// **'Sintaks'**
  String get tBabTypeTypeBadge;

  /// No description provided for @tBabTypeOutputBadge.
  ///
  /// In id, this message translates to:
  /// **'Logika'**
  String get tBabTypeOutputBadge;

  /// No description provided for @tBabTypeBugBadge.
  ///
  /// In id, this message translates to:
  /// **'Debugging'**
  String get tBabTypeBugBadge;

  /// No description provided for @tBabTypeQuizBadge.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi'**
  String get tBabTypeQuizBadge;

  /// No description provided for @tBabTypeOutroBadge.
  ///
  /// In id, this message translates to:
  /// **'Pencapaian'**
  String get tBabTypeOutroBadge;

  /// No description provided for @tBabSheetDescTheory.
  ///
  /// In id, this message translates to:
  /// **'Teks penjelasan konsep materi & contoh kode visual.'**
  String get tBabSheetDescTheory;

  /// No description provided for @tBabSheetDescTap.
  ///
  /// In id, this message translates to:
  /// **'Siswa mengetuk keping blok untuk melengkapi baris kode.'**
  String get tBabSheetDescTap;

  /// No description provided for @tBabSheetDescType.
  ///
  /// In id, this message translates to:
  /// **'Latihan mengetik keyword atau ekspresi sintaksis.'**
  String get tBabSheetDescType;

  /// No description provided for @tBabSheetDescOutput.
  ///
  /// In id, this message translates to:
  /// **'Siswa menganalisis snippet dan memprediksi hasil keluaran terminal.'**
  String get tBabSheetDescOutput;

  /// No description provided for @tBabSheetDescBug.
  ///
  /// In id, this message translates to:
  /// **'Tantangan memperbaiki galat penulisan atau logika koding.'**
  String get tBabSheetDescBug;

  /// No description provided for @tBabSheetDescQuiz.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan evaluasi pemahaman dengan 4 opsi pilihan.'**
  String get tBabSheetDescQuiz;

  /// No description provided for @tBabSheetDescOutro.
  ///
  /// In id, this message translates to:
  /// **'Slide penutup bab dengan ringkasan capaian dan hadiah.'**
  String get tBabSheetDescOutro;

  /// No description provided for @tBabBentoDescTheory.
  ///
  /// In id, this message translates to:
  /// **'Teks bacaan terstruktur, markdown penjelasan, dan contoh kode.'**
  String get tBabBentoDescTheory;

  /// No description provided for @tBabBentoDescTap.
  ///
  /// In id, this message translates to:
  /// **'Fill-in-the-blanks dengan token kepingan kode terpandu.'**
  String get tBabBentoDescTap;

  /// No description provided for @tBabBentoDescType.
  ///
  /// In id, this message translates to:
  /// **'Latihan muscle-memory mengetik keyword sintaksis spesifik.'**
  String get tBabBentoDescType;

  /// No description provided for @tBabBentoDescOutput.
  ///
  /// In id, this message translates to:
  /// **'Menganalisis baris kode dan memprediksi hasil luaran terminal.'**
  String get tBabBentoDescOutput;

  /// No description provided for @tBabBentoDescBug.
  ///
  /// In id, this message translates to:
  /// **'Menemukan baris kode yang rusak dan menentukan perbaikannya.'**
  String get tBabBentoDescBug;

  /// No description provided for @tBabBentoDescQuiz.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan konseptual dengan 4 opsi pilihan dan pembahasan.'**
  String get tBabBentoDescQuiz;

  /// No description provided for @pyErrStringUnclosed.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: string tidak ditutup'**
  String get pyErrStringUnclosed;

  /// No description provided for @pyErrFStringCloseBrace.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: f-string: tanda {brace} tidak ditemukan'**
  String pyErrFStringCloseBrace(String brace);

  /// No description provided for @pyErrFStringEmptyExpr.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: f-string: ekspresi kosong'**
  String get pyErrFStringEmptyExpr;

  /// No description provided for @pyErrFStringStrayBrace.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: f-string: tanda {brace} di luar placeholder'**
  String pyErrFStringStrayBrace(String brace);

  /// No description provided for @pyErrFStringUnclosed.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: f-string tidak ditutup'**
  String get pyErrFStringUnclosed;

  /// No description provided for @pyErrTimeoutSeconds.
  ///
  /// In id, this message translates to:
  /// **'RuntimeError: program dihentikan (melewati batas 5 detik)'**
  String get pyErrTimeoutSeconds;

  /// No description provided for @pyErrStepLimit.
  ///
  /// In id, this message translates to:
  /// **'RuntimeError: program dihentikan — melewati 100.000 langkah (periksa perulangan tanpa ujung)'**
  String get pyErrStepLimit;

  /// No description provided for @pyErrBreakOutsideLoop.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: \"break\" di luar perulangan'**
  String get pyErrBreakOutsideLoop;

  /// No description provided for @pyErrContinueOutsideLoop.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: \"continue\" di luar perulangan'**
  String get pyErrContinueOutsideLoop;

  /// No description provided for @pyErrReturnOutsideFunction.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: \'return\' di luar fungsi'**
  String get pyErrReturnOutsideFunction;

  /// No description provided for @pyErrElifWithoutIf.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: invalid syntax (elif/else tanpa if)'**
  String get pyErrElifWithoutIf;

  /// No description provided for @pyErrInvalidParam.
  ///
  /// In id, this message translates to:
  /// **'SyntaxError: parameter tidak valid -> {param}'**
  String pyErrInvalidParam(String param);

  /// No description provided for @pyErrInputNeedsDialog.
  ///
  /// In id, this message translates to:
  /// **'RuntimeError: input() butuh dialog — jalankan dari halaman Playground'**
  String get pyErrInputNeedsDialog;

  /// No description provided for @pyErrSumNeedsList.
  ///
  /// In id, this message translates to:
  /// **'TypeError: sum() membutuhkan list sebagai argumen pertama'**
  String get pyErrSumNeedsList;

  /// No description provided for @pyErrUnknownOperator.
  ///
  /// In id, this message translates to:
  /// **'TypeError: operator \'{op}\' tidak dikenal'**
  String pyErrUnknownOperator(String op);

  /// No description provided for @tAnalyticsCodeCopied.
  ///
  /// In id, this message translates to:
  /// **'Kode kelas \"{code}\" disalin ke clipboard!'**
  String tAnalyticsCodeCopied(String code);

  /// No description provided for @tAnalyticsRemoveTitle.
  ///
  /// In id, this message translates to:
  /// **'Keluarkan Siswa'**
  String get tAnalyticsRemoveTitle;

  /// No description provided for @tAnalyticsRemoveBody.
  ///
  /// In id, this message translates to:
  /// **'Keluarkan {name} dari {className}?\n\nSiswa tidak akan muncul lagi di daftar dan peringkat kelas. Ia bisa bergabung kembali dengan kode kelas.'**
  String tAnalyticsRemoveBody(String name, String className);

  /// No description provided for @tAnalyticsThisClass.
  ///
  /// In id, this message translates to:
  /// **'kelas ini'**
  String get tAnalyticsThisClass;

  /// No description provided for @tAnalyticsRemoveConfirm.
  ///
  /// In id, this message translates to:
  /// **'Keluarkan'**
  String get tAnalyticsRemoveConfirm;

  /// No description provided for @tAnalyticsClassOptions.
  ///
  /// In id, this message translates to:
  /// **'Opsi Kelas: {name}'**
  String tAnalyticsClassOptions(String name);

  /// No description provided for @tAnalyticsRegenerateCode.
  ///
  /// In id, this message translates to:
  /// **'Acak Ulang Kode Kelas'**
  String get tAnalyticsRegenerateCode;

  /// No description provided for @tAnalyticsRegenerateCodeSub.
  ///
  /// In id, this message translates to:
  /// **'Hasilkan kode kelas baru.'**
  String get tAnalyticsRegenerateCodeSub;

  /// No description provided for @tAnalyticsArchiveClass.
  ///
  /// In id, this message translates to:
  /// **'Arsipkan Kelas'**
  String get tAnalyticsArchiveClass;

  /// No description provided for @tAnalyticsArchiveClassSub.
  ///
  /// In id, this message translates to:
  /// **'Siswa tidak dapat bergabung lagi.'**
  String get tAnalyticsArchiveClassSub;

  /// No description provided for @tAnalyticsHintMaterialSuffix.
  ///
  /// In id, this message translates to:
  /// **' yang sudah menuntaskan \"{title}\"'**
  String tAnalyticsHintMaterialSuffix(String title);

  /// No description provided for @tAnalyticsHintCompleted.
  ///
  /// In id, this message translates to:
  /// **'Materi Tuntas = siswa yang sudah menuntaskan minimal satu materi{suffix}, diurutkan dari materi tuntas terbanyak.'**
  String tAnalyticsHintCompleted(String suffix);

  /// No description provided for @tAnalyticsPracticeRegular.
  ///
  /// In id, this message translates to:
  /// **'latihan biasa (bukan mini proyek)'**
  String get tAnalyticsPracticeRegular;

  /// No description provided for @tAnalyticsPracticeMini.
  ///
  /// In id, this message translates to:
  /// **'mini proyek'**
  String get tAnalyticsPracticeMini;

  /// No description provided for @tAnalyticsPracticeAny.
  ///
  /// In id, this message translates to:
  /// **'latihan apa pun (biasa + mini proyek)'**
  String get tAnalyticsPracticeAny;

  /// No description provided for @tAnalyticsHintPractice.
  ///
  /// In id, this message translates to:
  /// **'Latihan Terbanyak = siswa yang sudah lulus minimal satu {type}{suffix}, diurutkan dari jumlah latihan lulus terbanyak.'**
  String tAnalyticsHintPractice(String type, String suffix);

  /// No description provided for @tAnalyticsNotStartedMaterial.
  ///
  /// In id, this message translates to:
  /// **'belum menuntaskan satu materi pun'**
  String get tAnalyticsNotStartedMaterial;

  /// No description provided for @tAnalyticsNotStartedPractice.
  ///
  /// In id, this message translates to:
  /// **'belum menyelesaikan satu latihan pun'**
  String get tAnalyticsNotStartedPractice;

  /// No description provided for @tAnalyticsNotStartedBoth.
  ///
  /// In id, this message translates to:
  /// **'belum menuntaskan materi dan belum menyelesaikan latihan'**
  String get tAnalyticsNotStartedBoth;

  /// No description provided for @tAnalyticsHintNotStarted.
  ///
  /// In id, this message translates to:
  /// **'Belum Memulai = siswa yang {scope}{suffix}, diurutkan dari siswa yang paling aktif berlatih.'**
  String tAnalyticsHintNotStarted(String scope, String suffix);

  /// No description provided for @tAnalyticsHintAll.
  ///
  /// In id, this message translates to:
  /// **'Semua = seluruh anggota kelas{suffix}, diurutkan dari materi tuntas terbanyak lalu latihan lulus.'**
  String tAnalyticsHintAll(String suffix);

  /// No description provided for @tAnalyticsFilterByMaterial.
  ///
  /// In id, this message translates to:
  /// **'Saring Daftar Siswa per Materi'**
  String get tAnalyticsFilterByMaterial;

  /// No description provided for @tAnalyticsFilterByMaterialHint.
  ///
  /// In id, this message translates to:
  /// **'Angka di tiap tombol = jumlah siswa yang sudah menuntaskan materi itu.'**
  String get tAnalyticsFilterByMaterialHint;

  /// No description provided for @tAnalyticsFilterAllMaterials.
  ///
  /// In id, this message translates to:
  /// **'Semua Materi ({count})'**
  String tAnalyticsFilterAllMaterials(int count);

  /// No description provided for @tAnalyticsFilterMaterialCount.
  ///
  /// In id, this message translates to:
  /// **'{title} ({count})'**
  String tAnalyticsFilterMaterialCount(String title, int count);

  /// No description provided for @tAnalyticsTrackBasisTitle.
  ///
  /// In id, this message translates to:
  /// **'Dasar Nilai Kemajuan Per Track'**
  String get tAnalyticsTrackBasisTitle;

  /// No description provided for @tAnalyticsTrackBasisBody.
  ///
  /// In id, this message translates to:
  /// **'Persentase tiap track = rata-rata progress_percent seluruh siswa kelas pada SEMUA materi resmi (kurikulum bawaan) di track itu.\n\n• Setiap pasangan siswa × materi dihitung satu baris, termasuk materi yang belum pernah dibuka (dianggap 0%).\n• Nilai 100% berarti seluruh siswa kelas sudah menuntaskan seluruh materi di track tersebut.\n• Materi buatan guru tidak dihitung (hanya kurikulum resmi).\n• Angka ini mengukur ketuntasan materi, bukan nilai latihan.'**
  String get tAnalyticsTrackBasisBody;

  /// No description provided for @tAnalyticsGotIt.
  ///
  /// In id, this message translates to:
  /// **'Mengerti'**
  String get tAnalyticsGotIt;

  /// No description provided for @tAnalyticsNoStudents.
  ///
  /// In id, this message translates to:
  /// **'Belum ada siswa.'**
  String get tAnalyticsNoStudents;

  /// No description provided for @tAnalyticsTitle.
  ///
  /// In id, this message translates to:
  /// **'Analisa Kelas'**
  String get tAnalyticsTitle;

  /// No description provided for @tAnalyticsClassOptionsLabel.
  ///
  /// In id, this message translates to:
  /// **'Opsi Kelas'**
  String get tAnalyticsClassOptionsLabel;

  /// No description provided for @tAnalyticsLoading.
  ///
  /// In id, this message translates to:
  /// **'Memuat data analisa kelas...'**
  String get tAnalyticsLoading;

  /// No description provided for @tAnalyticsEmptyBody.
  ///
  /// In id, this message translates to:
  /// **'Buat kelas pertamamu di Dashboard untuk memantau analisa kurikulum dan progres belajar siswa.'**
  String get tAnalyticsEmptyBody;

  /// No description provided for @tAnalyticsLabClass.
  ///
  /// In id, this message translates to:
  /// **'Kelas Laboratorium'**
  String get tAnalyticsLabClass;

  /// No description provided for @tAnalyticsAcademicYear.
  ///
  /// In id, this message translates to:
  /// **'Tahun Ajaran {year}'**
  String tAnalyticsAcademicYear(String year);

  /// No description provided for @tAnalyticsClassCode.
  ///
  /// In id, this message translates to:
  /// **'Kode Kelas'**
  String get tAnalyticsClassCode;

  /// No description provided for @tAnalyticsReadyJoin.
  ///
  /// In id, this message translates to:
  /// **'Siap Join'**
  String get tAnalyticsReadyJoin;

  /// No description provided for @tAnalyticsShareCodeHint.
  ///
  /// In id, this message translates to:
  /// **'Bagikan kode ini agar siswa dapat bergabung ke kelas:'**
  String get tAnalyticsShareCodeHint;

  /// No description provided for @tAnalyticsEnlarge.
  ///
  /// In id, this message translates to:
  /// **'Perbesar ↗'**
  String get tAnalyticsEnlarge;

  /// No description provided for @tAnalyticsTrackTitle.
  ///
  /// In id, this message translates to:
  /// **'Kemajuan Kurikulum Per Track'**
  String get tAnalyticsTrackTitle;

  /// No description provided for @tAnalyticsTrackTooltip.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata progress semua siswa kelas pada semua materi resmi di track ini (materi yang belum dibuka = 0%).'**
  String get tAnalyticsTrackTooltip;

  /// No description provided for @tAnalyticsTrackSubtitle.
  ///
  /// In id, this message translates to:
  /// **'Rata-rata ketuntasan seluruh siswa kelas pada semua materi resmi track tersebut.'**
  String get tAnalyticsTrackSubtitle;

  /// No description provided for @tAnalyticsTrackEmpty.
  ///
  /// In id, this message translates to:
  /// **'Data track akan terisi otomatis setelah siswa mulai belajar.'**
  String get tAnalyticsTrackEmpty;

  /// No description provided for @tAnalyticsHardestTitle.
  ///
  /// In id, this message translates to:
  /// **'Bab Tersulit (Perlu Pendampingan)'**
  String get tAnalyticsHardestTitle;

  /// No description provided for @tAnalyticsHardestEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada tantangan yang terdeteksi sulit pada kelas ini 🎉'**
  String get tAnalyticsHardestEmpty;

  /// No description provided for @tAnalyticsFailCount.
  ///
  /// In id, this message translates to:
  /// **'{count} siswa gagal'**
  String tAnalyticsFailCount(int count);

  /// No description provided for @tAnalyticsRankingTitle.
  ///
  /// In id, this message translates to:
  /// **'Peringkat Siswa Kelas'**
  String get tAnalyticsRankingTitle;

  /// No description provided for @tAnalyticsRankingTop.
  ///
  /// In id, this message translates to:
  /// **'{top} teratas dari {total}'**
  String tAnalyticsRankingTop(int top, int total);

  /// No description provided for @tAnalyticsStudentCount.
  ///
  /// In id, this message translates to:
  /// **'{count} Siswa'**
  String tAnalyticsStudentCount(int count);

  /// No description provided for @tAnalyticsRankingHint.
  ///
  /// In id, this message translates to:
  /// **'Peringkat hanya menampilkan maksimal {max} siswa dengan materi/latihan terbanyak. Semua siswa tetap tampil lengkap di bagian Daftar Siswa.'**
  String tAnalyticsRankingHint(int max);

  /// No description provided for @tAnalyticsRankMaterial.
  ///
  /// In id, this message translates to:
  /// **'Materi'**
  String get tAnalyticsRankMaterial;

  /// No description provided for @tAnalyticsRankMaterialSub.
  ///
  /// In id, this message translates to:
  /// **'Materi tuntas'**
  String get tAnalyticsRankMaterialSub;

  /// No description provided for @tAnalyticsRankPractice.
  ///
  /// In id, this message translates to:
  /// **'Latihan'**
  String get tAnalyticsRankPractice;

  /// No description provided for @tAnalyticsRankPracticeSub.
  ///
  /// In id, this message translates to:
  /// **'Tantangan lulus'**
  String get tAnalyticsRankPracticeSub;

  /// No description provided for @tAnalyticsRosterTitle.
  ///
  /// In id, this message translates to:
  /// **'Daftar Siswa'**
  String get tAnalyticsRosterTitle;

  /// No description provided for @tAnalyticsFilterAllCount.
  ///
  /// In id, this message translates to:
  /// **'Semua ({count})'**
  String tAnalyticsFilterAllCount(int count);

  /// No description provided for @tAnalyticsFilterCompletedCount.
  ///
  /// In id, this message translates to:
  /// **'Materi Tuntas ({count})'**
  String tAnalyticsFilterCompletedCount(int count);

  /// No description provided for @tAnalyticsFilterPractice.
  ///
  /// In id, this message translates to:
  /// **'Latihan Terbanyak'**
  String get tAnalyticsFilterPractice;

  /// No description provided for @tAnalyticsFilterNotStartedCount.
  ///
  /// In id, this message translates to:
  /// **'Belum Memulai ({count})'**
  String tAnalyticsFilterNotStartedCount(int count);

  /// No description provided for @tAnalyticsPracticeAll.
  ///
  /// In id, this message translates to:
  /// **'Semua Latihan'**
  String get tAnalyticsPracticeAll;

  /// No description provided for @tAnalyticsPracticeRegularLabel.
  ///
  /// In id, this message translates to:
  /// **'Latihan Biasa'**
  String get tAnalyticsPracticeRegularLabel;

  /// No description provided for @tAnalyticsNotStartedAll.
  ///
  /// In id, this message translates to:
  /// **'Materi & Latihan'**
  String get tAnalyticsNotStartedAll;

  /// No description provided for @tAnalyticsNotStartedMaterialLabel.
  ///
  /// In id, this message translates to:
  /// **'Belum Kerjakan Materi'**
  String get tAnalyticsNotStartedMaterialLabel;

  /// No description provided for @tAnalyticsNotStartedPracticeLabel.
  ///
  /// In id, this message translates to:
  /// **'Belum Selesaikan Latihan'**
  String get tAnalyticsNotStartedPracticeLabel;

  /// No description provided for @tAnalyticsRosterEmpty.
  ///
  /// In id, this message translates to:
  /// **'Belum ada siswa yang bergabung di kelas ini.'**
  String get tAnalyticsRosterEmpty;

  /// No description provided for @tAnalyticsRosterFilterEmpty.
  ///
  /// In id, this message translates to:
  /// **'Tidak ada siswa pada kategori filter ini.'**
  String get tAnalyticsRosterFilterEmpty;

  /// No description provided for @tAnalyticsRowPracticeDetail.
  ///
  /// In id, this message translates to:
  /// **'{materials} materi tuntas • {regular} latihan biasa • {mini} mini proyek'**
  String tAnalyticsRowPracticeDetail(int materials, int regular, int mini);

  /// No description provided for @tAnalyticsRowDetail.
  ///
  /// In id, this message translates to:
  /// **'{materials} materi tuntas • {practice} latihan lulus'**
  String tAnalyticsRowDetail(int materials, int practice);

  /// No description provided for @tAnalyticsXp.
  ///
  /// In id, this message translates to:
  /// **'{xp} XP'**
  String tAnalyticsXp(int xp);

  /// No description provided for @tAnalyticsRemoveFromClass.
  ///
  /// In id, this message translates to:
  /// **'Keluarkan dari kelas'**
  String get tAnalyticsRemoveFromClass;

  /// No description provided for @tSlideFormHelpTheoryTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil paling atas di layar siswa.\n- Buat ringkas dan spesifik, maksimal 120 karakter.\n- Sebut inti konsepnya, bukan nama bab.'**
  String get tSlideFormHelpTheoryTitle;

  /// No description provided for @tSlideFormHelpTheoryContent.
  ///
  /// In id, this message translates to:
  /// **'Cara menulis isi materi:\n- Pisahkan paragraf dengan satu baris kosong.\n- Baris yang diawali \"- \" atau \"* \" otomatis jadi butir daftar.\n- Selain itu teks ditampilkan apa adanya: **tebal**, # judul, tautan, dan `kode` tidak diformat.\n\nContoh:\nHTML adalah bahasa penanda untuk menyusun halaman web.\n\n- Tag dibuka lalu ditutup.\n- Atribut menempel pada tag pembuka.'**
  String get tSlideFormHelpTheoryContent;

  /// No description provided for @tSlideFormHelpCodeFileSample.
  ///
  /// In id, this message translates to:
  /// **'Hanya menentukan nama berkas pada kartu kode:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py'**
  String get tSlideFormHelpCodeFileSample;

  /// No description provided for @tSlideFormHelpSampleCode.
  ///
  /// In id, this message translates to:
  /// **'Kode contoh yang tampil di kotak kode di bawah penjelasan.\n- Kosongkan bila slide tidak perlu contoh kode.\n- Tulis kode aslinya saja, tanpa penanda blok markdown.\n- Maksimal 8000 karakter.'**
  String get tSlideFormHelpSampleCode;

  /// No description provided for @tSlideFormHelpExerciseTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil di kepala soal, maksimal 120 karakter.\nContoh: \"Lengkapi Tag Penutup HTML\".'**
  String get tSlideFormHelpExerciseTitle;

  /// No description provided for @tSlideFormHelpShortInstruction.
  ///
  /// In id, this message translates to:
  /// **'Satu sampai dua kalimat arahan sebelum siswa mengetuk slot.\n- Jelaskan bagian mana yang harus dilengkapi.\n- Jangan sebut jawabannya di sini.'**
  String get tSlideFormHelpShortInstruction;

  /// No description provided for @tSlideFormHelpCodeTemplate.
  ///
  /// In id, this message translates to:
  /// **'Tempel kode di sini, lalu tandai bagian kosong dengan ___1___, ___2___, dan seterusnya.\n- Penanda dikenali selama memakai minimal dua garis bawah di awal dan akhir, dengan angka opsional di tengah.\n- Urutan slot mengikuti urutan kemunculannya di dalam kode.\n- Satu slot berarti satu jawaban; jangan menaruh dua slot untuk jawaban yang sama.\n\nContoh:\nx = ___1___\nprint(x)'**
  String get tSlideFormHelpCodeTemplate;

  /// No description provided for @tSlideFormHelpSlotAnswers.
  ///
  /// In id, this message translates to:
  /// **'Isi jawaban benar untuk setiap slot sesuai urutan kemunculan.\n- Spasi di awal/akhir diabaikan, tetapi huruf besar-kecil dihitung: tulis \"print\", bukan \"Print\".\n- Tulis persis seperti yang seharusnya ada di dalam kode.\n- Jumlah isian mengikuti jumlah slot yang terdeteksi.'**
  String get tSlideFormHelpSlotAnswers;

  /// No description provided for @tSlideFormHelpDistractors.
  ///
  /// In id, this message translates to:
  /// **'Kata tambahan yang muncul sebagai pilihan, tetapi bukan jawaban benar.\n- Pisahkan dengan koma.\n- Pengecoh yang sama dengan kunci otomatis dibuang.\n- Sisakan minimal satu agar siswa benar-benar harus memilih.'**
  String get tSlideFormHelpDistractors;

  /// No description provided for @tSlideFormHelpCodeFile.
  ///
  /// In id, this message translates to:
  /// **'Menentukan nama berkas pada kartu kode:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py'**
  String get tSlideFormHelpCodeFile;

  /// No description provided for @tSlideFormHelpQuestionTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil di kepala soal, maksimal 120 karakter.\nContoh: \"Deklarasi Variabel Python\".'**
  String get tSlideFormHelpQuestionTitle;

  /// No description provided for @tSlideFormHelpInteractiveInstruction.
  ///
  /// In id, this message translates to:
  /// **'Arahan singkat yang dibaca siswa sebelum mengetik.\n- Sebutkan apa yang harus dicari tanpa memberi jawabannya.\n- Maksimal 300 karakter.'**
  String get tSlideFormHelpInteractiveInstruction;

  /// No description provided for @tSlideFormHelpQuestionCode.
  ///
  /// In id, this message translates to:
  /// **'Tulis potongan kode, lalu ganti bagian yang harus diisi dengan [KETIK_DISINI].\n- Penanda itu berubah menjadi kotak input di layar siswa.\n- Boleh lebih dari satu penanda dalam satu slide.\n- Tanpa penanda, siswa tidak punya tempat mengetik jawaban.'**
  String get tSlideFormHelpQuestionCode;

  /// No description provided for @tSlideFormHelpAnswerKeyword.
  ///
  /// In id, this message translates to:
  /// **'Jawaban yang dianggap benar.\n- Perbandingan mengabaikan spasi awal/akhir dan huruf besar-kecil, jadi \"Print\" sama dengan \"print\".\n- Isi satu kata kunci atau ekspresi pendek saja.'**
  String get tSlideFormHelpAnswerKeyword;

  /// No description provided for @tSlideFormHelpWrongHint.
  ///
  /// In id, this message translates to:
  /// **'Bantuan yang muncul ketika jawaban siswa salah.\n- Beri petunjuk arah, jangan tulis jawabannya langsung.\n- Satu sampai dua kalimat sudah cukup.'**
  String get tSlideFormHelpWrongHint;

  /// No description provided for @tSlideFormHelpSlideTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil di kepala slide, maksimal 120 karakter.\nContoh: \"Tebak Output Operator Modulo\".'**
  String get tSlideFormHelpSlideTitle;

  /// No description provided for @tSlideFormHelpChallengeInstruction.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan singkat di atas blok kode.\nBiasanya cukup: \"Apakah output yang dicetak ke terminal?\".'**
  String get tSlideFormHelpChallengeInstruction;

  /// No description provided for @tSlideFormHelpSourceCode.
  ///
  /// In id, this message translates to:
  /// **'Kode yang dibaca siswa untuk menebak output.\n- Tulis persis seperti program aslinya.\n- Kode hanya ditampilkan, tidak dijalankan, jadi hasilnya harus bisa ditebak dari isi kode.'**
  String get tSlideFormHelpSourceCode;

  /// No description provided for @tSlideFormHelpOutputChoices.
  ///
  /// In id, this message translates to:
  /// **'Isi keempat pilihan (A sampai D).\n- Ketuk lingkaran di kiri untuk menandai kunci jawaban.\n- Satu pilihan harus persis sama dengan output sebenarnya.\n- Jangan biarkan pilihan kosong: pilihan kosong tetap tampil di layar siswa.'**
  String get tSlideFormHelpOutputChoices;

  /// No description provided for @tSlideFormHelpOutputExplanation.
  ///
  /// In id, this message translates to:
  /// **'Muncul setelah siswa menjawab, benar maupun salah.\nJelaskan alasan output itu muncul, misalnya urutan operasi atau tipe data yang terlibat.'**
  String get tSlideFormHelpOutputExplanation;

  /// No description provided for @tSlideFormHelpChallengeTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil di kepala tantangan, maksimal 120 karakter.\nContoh: \"Mencari Kesalahan Loop For\".'**
  String get tSlideFormHelpChallengeTitle;

  /// No description provided for @tSlideFormHelpScenario.
  ///
  /// In id, this message translates to:
  /// **'Konteks singkat masalah yang dihadapi siswa; tampil sebagai instruksi di atas kode.\nCeritakan situasinya, jangan sebut nomor baris yang salah.'**
  String get tSlideFormHelpScenario;

  /// No description provided for @tSlideFormHelpBuggyCode.
  ///
  /// In id, this message translates to:
  /// **'Seluruh kode yang mengandung bug.\n- Nomor baris dihitung dari 1 mengikuti urutan baris di kotak ini, termasuk baris kosong.\n- Sisipkan bug yang benar-benar bisa dijelaskan oleh \"Jenis Error\" dan \"Kode Perbaikan\".'**
  String get tSlideFormHelpBuggyCode;

  /// No description provided for @tSlideFormHelpTargetLine.
  ///
  /// In id, this message translates to:
  /// **'Nomor baris yang benar, dihitung dari 1.\n- Harus berada di antara 1 dan jumlah baris kode di atas.\n- Bila di luar jangkauan, layar siswa mengunci ke baris terdekat sehingga jawaban tidak pernah cocok.'**
  String get tSlideFormHelpTargetLine;

  /// No description provided for @tSlideFormHelpErrorType.
  ///
  /// In id, this message translates to:
  /// **'Label kategori galat yang tampil ke siswa.\nContoh: SyntaxError, IndentationError, NameError.'**
  String get tSlideFormHelpErrorType;

  /// No description provided for @tSlideFormHelpBugHint.
  ///
  /// In id, this message translates to:
  /// **'Teks ini menjadi penjelasan yang muncul setelah siswa menjawab.\n- Jelaskan aturan yang dilanggar di baris tersebut.\n- Bila dikosongkan, \"Kode Perbaikan Valid\" yang dipakai sebagai penjelasan.'**
  String get tSlideFormHelpBugHint;

  /// No description provided for @tSlideFormHelpFixCode.
  ///
  /// In id, this message translates to:
  /// **'Cuplikan perbaikan yang benar untuk baris yang ditandai.\n- Dipakai sebagai contoh solusi sekaligus penjelasan cadangan bila \"Pesan Indikator\" kosong.\n- Tulis hanya bagian yang diperbaiki, bukan seluruh program.'**
  String get tSlideFormHelpFixCode;

  /// No description provided for @tSlideFormHelpQuizTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil di kepala kuis, maksimal 120 karakter.\nContoh: \"Memahami Tipe Data\".'**
  String get tSlideFormHelpQuizTitle;

  /// No description provided for @tSlideFormHelpQuizQuestion.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan dengan satu jawaban benar.\n- Ajukan satu konsep saja, jangan digabung.\n- Maksimal 300 karakter.'**
  String get tSlideFormHelpQuizQuestion;

  /// No description provided for @tSlideFormHelpAnswerChoices.
  ///
  /// In id, this message translates to:
  /// **'Isi keempat pilihan (A sampai D).\n- Ketuk lingkaran di kiri untuk menandai kunci jawaban.\n- Jangan biarkan pilihan kosong karena tetap tampil sebagai opsi kosong di layar siswa.'**
  String get tSlideFormHelpAnswerChoices;

  /// No description provided for @tSlideFormHelpFeedback.
  ///
  /// In id, this message translates to:
  /// **'Muncul setelah siswa menjawab, benar maupun salah.\nJelaskan mengapa kunci jawabannya benar dan, bila perlu, mengapa pengecohnya salah.'**
  String get tSlideFormHelpFeedback;

  /// No description provided for @tSlideFormHelpOutroTitle.
  ///
  /// In id, this message translates to:
  /// **'Judul tampil di kepala slide penutup, maksimal 120 karakter.\nContoh: \"Rangkuman Bab\".'**
  String get tSlideFormHelpOutroTitle;

  /// No description provided for @tSlideFormHelpSummary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan yang dibaca siswa di akhir bab.\n- Sebut kembali konsep utama yang baru dipelajari.\n- Beri penutup yang memotivasi, bukan soal baru.'**
  String get tSlideFormHelpSummary;

  /// No description provided for @tSlideFormHelpMasteredConcepts.
  ///
  /// In id, this message translates to:
  /// **'Daftar konsep yang dianggap dikuasai setelah bab ini.\n- Pisahkan dengan koma, misalnya: Variabel, Perulangan.\n- Setiap konsep tampil sebagai label capaian.\n- Isi minimal satu konsep.'**
  String get tSlideFormHelpMasteredConcepts;

  /// No description provided for @tSlideFormHintTheoryTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Struktur Dasar Dokumen HTML5'**
  String get tSlideFormHintTheoryTitleExample;

  /// No description provided for @tSlideFormHintTheoryContent.
  ///
  /// In id, this message translates to:
  /// **'Tuliskan konsep utama, poin-poin, atau contoh...'**
  String get tSlideFormHintTheoryContent;

  /// No description provided for @tSlideFormHintExerciseTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Lengkapi Tag Penutup HTML'**
  String get tSlideFormHintExerciseTitleExample;

  /// No description provided for @tSlideFormHintShortInstruction.
  ///
  /// In id, this message translates to:
  /// **'Instruksi pengerjaan bagi siswa...'**
  String get tSlideFormHintShortInstruction;

  /// No description provided for @tSlideFormHintQuestionTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Deklarasi Variabel Python'**
  String get tSlideFormHintQuestionTitleExample;

  /// No description provided for @tSlideFormHintInteractiveInstruction.
  ///
  /// In id, this message translates to:
  /// **'Ketikkan kata kunci untuk mendeklarasikan variabel...'**
  String get tSlideFormHintInteractiveInstruction;

  /// No description provided for @tSlideFormHintAnswerKeywordExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: def / const / let'**
  String get tSlideFormHintAnswerKeywordExample;

  /// No description provided for @tSlideFormHintWrongHint.
  ///
  /// In id, this message translates to:
  /// **'Ingat penulisan huruf kecil semua.'**
  String get tSlideFormHintWrongHint;

  /// No description provided for @tSlideFormHintSlideTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Tebak Output Operator Modulo'**
  String get tSlideFormHintSlideTitleExample;

  /// No description provided for @tSlideFormHintChallengeInstruction.
  ///
  /// In id, this message translates to:
  /// **'Apakah output yang dicetak ke terminal?'**
  String get tSlideFormHintChallengeInstruction;

  /// No description provided for @tSlideFormHintOutputExplanation.
  ///
  /// In id, this message translates to:
  /// **'Mengapa output tersebut yang muncul?'**
  String get tSlideFormHintOutputExplanation;

  /// No description provided for @tSlideFormHintChallengeTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Mencari Kesalahan Loop For'**
  String get tSlideFormHintChallengeTitleExample;

  /// No description provided for @tSlideFormHintScenario.
  ///
  /// In id, this message translates to:
  /// **'Deskripsi konteks masalah...'**
  String get tSlideFormHintScenario;

  /// No description provided for @tSlideFormHintTargetLineExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: 2'**
  String get tSlideFormHintTargetLineExample;

  /// No description provided for @tSlideFormHintBugHint.
  ///
  /// In id, this message translates to:
  /// **'Kurang tanda titik dua (:) di akhir pernyataan for'**
  String get tSlideFormHintBugHint;

  /// No description provided for @tSlideFormHintQuizTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Memahami Tipe Data'**
  String get tSlideFormHintQuizTitleExample;

  /// No description provided for @tSlideFormHintQuizQuestion.
  ///
  /// In id, this message translates to:
  /// **'Tuliskan pertanyaan konseptual...'**
  String get tSlideFormHintQuizQuestion;

  /// No description provided for @tSlideFormHintFeedback.
  ///
  /// In id, this message translates to:
  /// **'Mengapa opsi tersebut benar?'**
  String get tSlideFormHintFeedback;

  /// No description provided for @tSlideFormHintOutroTitleExample.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Rangkuman Bab'**
  String get tSlideFormHintOutroTitleExample;

  /// No description provided for @tSlideFormHintSummary.
  ///
  /// In id, this message translates to:
  /// **'Ringkasan capaian siswa setelah menuntaskan bab...'**
  String get tSlideFormHintSummary;

  /// No description provided for @tSlideFormHintMasteredConcepts.
  ///
  /// In id, this message translates to:
  /// **'Variabel, Percabangan, Perulangan'**
  String get tSlideFormHintMasteredConcepts;

  /// No description provided for @tSlideFormSlotAnswerCount.
  ///
  /// In id, this message translates to:
  /// **'Kunci jawaban per slot ({count} slot terdeteksi)'**
  String tSlideFormSlotAnswerCount(int count);

  /// No description provided for @tSlideFormSlot.
  ///
  /// In id, this message translates to:
  /// **'Slot {n}'**
  String tSlideFormSlot(int n);

  /// No description provided for @tSlideFormSlotAnswerHint.
  ///
  /// In id, this message translates to:
  /// **'Jawaban benar untuk slot {n}'**
  String tSlideFormSlotAnswerHint(int n);

  /// No description provided for @tSlideFormNoSlotsHint.
  ///
  /// In id, this message translates to:
  /// **'Tambahkan penanda ___1___, ___2___, dan seterusnya pada template.'**
  String get tSlideFormNoSlotsHint;

  /// No description provided for @tSlideFormXpNote.
  ///
  /// In id, this message translates to:
  /// **'Siswa otomatis mengklaim {xp} XP saat mencapai slide ini.'**
  String tSlideFormXpNote(int xp);

  /// No description provided for @tPreviewInteractiveFormat.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Format Interaktif'**
  String get tPreviewInteractiveFormat;

  /// No description provided for @tPreviewSheetTitle.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Tipe Slide: {title}'**
  String tPreviewSheetTitle(String title);

  /// No description provided for @tPreviewBenefits.
  ///
  /// In id, this message translates to:
  /// **'Manfaat Pedagogis'**
  String get tPreviewBenefits;

  /// No description provided for @tPreviewReward.
  ///
  /// In id, this message translates to:
  /// **'Imbalan Siswa'**
  String get tPreviewReward;

  /// No description provided for @tPreviewModuleType.
  ///
  /// In id, this message translates to:
  /// **'Tipe Modul'**
  String get tPreviewModuleType;

  /// No description provided for @tPreviewUseType.
  ///
  /// In id, this message translates to:
  /// **'Gunakan Tipe Ini'**
  String get tPreviewUseType;

  /// No description provided for @tPreviewSimulation.
  ///
  /// In id, this message translates to:
  /// **'Simulasi Siswa Aktif'**
  String get tPreviewSimulation;

  /// No description provided for @tPreviewPhoneScreen.
  ///
  /// In id, this message translates to:
  /// **'Layar Ponsel'**
  String get tPreviewPhoneScreen;

  /// No description provided for @tPreviewAnswerChoices.
  ///
  /// In id, this message translates to:
  /// **'Pilihan jawaban untuk siswa:'**
  String get tPreviewAnswerChoices;

  /// No description provided for @tPreviewSubtitleTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Simulasi bagaimana siswa berinteraksi dengan latihan ini di ponsel secara langsung.'**
  String get tPreviewSubtitleTapToFill;

  /// No description provided for @tPreviewTechTapToFill.
  ///
  /// In id, this message translates to:
  /// **'HTML • V1.2'**
  String get tPreviewTechTapToFill;

  /// No description provided for @tPreviewPromptTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi tag penutup yang tepat: Baris 4'**
  String get tPreviewPromptTapToFill;

  /// No description provided for @tPreviewFeedbackTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Siswa mendapat umpan balik instan saat memilih kepingan kode.'**
  String get tPreviewFeedbackTapToFill;

  /// No description provided for @tPreviewBenefitTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Melatih penguasaan sintaksis dasar tanpa beban mengetik panjang di papan ketik layar sentuh HP.'**
  String get tPreviewBenefitTapToFill;

  /// No description provided for @tPreviewSubtitleTheory.
  ///
  /// In id, this message translates to:
  /// **'Teks bacaan terstruktur, markdown penjelasan, dan cuplikan kode contoh.'**
  String get tPreviewSubtitleTheory;

  /// No description provided for @tPreviewTechTheory.
  ///
  /// In id, this message translates to:
  /// **'Markdown • Teori'**
  String get tPreviewTechTheory;

  /// No description provided for @tPreviewPromptTheory.
  ///
  /// In id, this message translates to:
  /// **'Materi Pembuka & Pengenalan Logika'**
  String get tPreviewPromptTheory;

  /// No description provided for @tPreviewFeedbackTheory.
  ///
  /// In id, this message translates to:
  /// **'Mendukung format Markdown, syntax highlighter, dan kotak callout tips guru.'**
  String get tPreviewFeedbackTheory;

  /// No description provided for @tPreviewBenefitTheory.
  ///
  /// In id, this message translates to:
  /// **'Membangun landasan pemahaman konseptual yang kuat sebelum siswa masuk ke sesi latihan interaktif.'**
  String get tPreviewBenefitTheory;

  /// No description provided for @tPreviewSubtitleTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Latihan muscle-memory mengetikkan keyword sintaksis spesifik.'**
  String get tPreviewSubtitleTypeCode;

  /// No description provided for @tPreviewTechTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Python • Sintaks'**
  String get tPreviewTechTypeCode;

  /// No description provided for @tPreviewPromptTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Ketikkan kata kunci untuk membuat fungsi di Python:'**
  String get tPreviewPromptTypeCode;

  /// No description provided for @tPreviewFeedbackTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Dilengkapi validasi case-sensitive dan hint otomatis saat siswa keliru.'**
  String get tPreviewFeedbackTypeCode;

  /// No description provided for @tPreviewBenefitTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Membiasakan siswa dengan penulisan sintaksis yang presisi dan melatih ketelitian pengetikan reserved-words.'**
  String get tPreviewBenefitTypeCode;

  /// No description provided for @tPreviewSubtitleOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Siswa menganalisis baris program dan memprediksi hasil running terminal.'**
  String get tPreviewSubtitleOutputPredict;

  /// No description provided for @tPreviewTechOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Console • Logika'**
  String get tPreviewTechOutputPredict;

  /// No description provided for @tPreviewPromptOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Apakah output yang dicetak oleh operasi modulus berikut?'**
  String get tPreviewPromptOutputPredict;

  /// No description provided for @tPreviewFeedbackOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Tampilan opsi bergaya konsol terminal gelap untuk simulasi nyata.'**
  String get tPreviewFeedbackOutputPredict;

  /// No description provided for @tPreviewBenefitOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Melatih kemampuan mental execution algoritma dan tracing variabel tanpa ketergantungan debugger.'**
  String get tPreviewBenefitOutputPredict;

  /// No description provided for @tPreviewTitleBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Bug Hunter (Cari Galat)'**
  String get tPreviewTitleBugHunter;

  /// No description provided for @tPreviewSubtitleBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Tantangan menemukan baris kode yang rusak dan memperbaikinya.'**
  String get tPreviewSubtitleBugHunter;

  /// No description provided for @tPreviewTechBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Python • Debug'**
  String get tPreviewTechBugHunter;

  /// No description provided for @tPreviewPromptBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Temukan baris yang mengandung kesalahan sintaksis:'**
  String get tPreviewPromptBugHunter;

  /// No description provided for @tPreviewFeedbackBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Siswa mengetuk nomor baris yang bermasalah untuk memicu bimbingan AI.'**
  String get tPreviewFeedbackBugHunter;

  /// No description provided for @tPreviewBenefitBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Mengasah intuisi problem-solving dan kemampuan membaca kode orang lain yang merupakan inti skill developer.'**
  String get tPreviewBenefitBugHunter;

  /// No description provided for @tPreviewSubtitleQuiz.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan evaluasi pemahaman dengan 4 opsi pilihan dan pembahasan.'**
  String get tPreviewSubtitleQuiz;

  /// No description provided for @tPreviewTechQuiz.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi • Konsep'**
  String get tPreviewTechQuiz;

  /// No description provided for @tPreviewPromptQuiz.
  ///
  /// In id, this message translates to:
  /// **'Apa fungsi utama dari deklarasi <!DOCTYPE html>?'**
  String get tPreviewPromptQuiz;

  /// No description provided for @tPreviewFeedbackQuiz.
  ///
  /// In id, this message translates to:
  /// **'Dilengkapi pembahasan otomatis yang tampil setelah siswa menjawab.'**
  String get tPreviewFeedbackQuiz;

  /// No description provided for @tPreviewBenefitQuiz.
  ///
  /// In id, this message translates to:
  /// **'Mengukur daya serap materi secara obyektif dan cepat di akhir sesi pembahasan.'**
  String get tPreviewBenefitQuiz;

  /// No description provided for @tPreviewSubtitleOutro.
  ///
  /// In id, this message translates to:
  /// **'Slide penutup bab dengan rekap materi yang dikuasai dan klaim hadiah.'**
  String get tPreviewSubtitleOutro;

  /// No description provided for @tPreviewTechOutro.
  ///
  /// In id, this message translates to:
  /// **'Pencapaian • Penutup'**
  String get tPreviewTechOutro;

  /// No description provided for @tPreviewPromptOutro.
  ///
  /// In id, this message translates to:
  /// **'Selamat! Kamu telah menyelesaikan seluruh latihan di bab ini.'**
  String get tPreviewPromptOutro;

  /// No description provided for @tPreviewFeedbackOutro.
  ///
  /// In id, this message translates to:
  /// **'Otomatis dibuat di akhir alur pembelajaran bab.'**
  String get tPreviewFeedbackOutro;

  /// No description provided for @tPreviewBenefitOutro.
  ///
  /// In id, this message translates to:
  /// **'Memberikan kepuasan pencapaian (gamification) dan merangkum poin-poin penting materi.'**
  String get tPreviewBenefitOutro;

  /// No description provided for @tSettingsAvatarTooBig.
  ///
  /// In id, this message translates to:
  /// **'Ukuran foto maksimal 2 MB.'**
  String get tSettingsAvatarTooBig;

  /// No description provided for @tSettingsFallbackTeacher.
  ///
  /// In id, this message translates to:
  /// **'Guru'**
  String get tSettingsFallbackTeacher;

  /// No description provided for @tSettingsNameDegree.
  ///
  /// In id, this message translates to:
  /// **'{name} & Gelar *'**
  String tSettingsNameDegree(String name);

  /// No description provided for @tSettingsIdentityTitle.
  ///
  /// In id, this message translates to:
  /// **'Identitas Pengajar'**
  String get tSettingsIdentityTitle;

  /// No description provided for @tSettingsBioContact.
  ///
  /// In id, this message translates to:
  /// **'Bio & Kontak'**
  String get tSettingsBioContact;

  /// No description provided for @tSettingsBioHint.
  ///
  /// In id, this message translates to:
  /// **'Tuliskan pengalaman mengajar atau bidang spesialisasi kodingmu...'**
  String get tSettingsBioHint;

  /// No description provided for @tSettingsAddressHint.
  ///
  /// In id, this message translates to:
  /// **'Alamat domisili pengajar'**
  String get tSettingsAddressHint;

  /// No description provided for @tSettingsSecurityTitle.
  ///
  /// In id, this message translates to:
  /// **'Keamanan Akun'**
  String get tSettingsSecurityTitle;

  /// No description provided for @tSettingsChangePassword.
  ///
  /// In id, this message translates to:
  /// **'Ubah Kata Sandi'**
  String get tSettingsChangePassword;

  /// No description provided for @tFieldHelpGotIt.
  ///
  /// In id, this message translates to:
  /// **'Mengerti'**
  String get tFieldHelpGotIt;

  /// No description provided for @tTeacherErrServerFallback.
  ///
  /// In id, this message translates to:
  /// **'Ada kendala pada server.'**
  String get tTeacherErrServerFallback;

  /// No description provided for @tTeacherErrInvalidLesson.
  ///
  /// In id, this message translates to:
  /// **'Format data materi tidak valid.'**
  String get tTeacherErrInvalidLesson;

  /// No description provided for @tTeacherErrInvalidBab.
  ///
  /// In id, this message translates to:
  /// **'Format data bab tidak valid.'**
  String get tTeacherErrInvalidBab;

  /// No description provided for @tTeacherErrInvalidClass.
  ///
  /// In id, this message translates to:
  /// **'Format data kelas tidak valid.'**
  String get tTeacherErrInvalidClass;

  /// No description provided for @tCubitClassCreated.
  ///
  /// In id, this message translates to:
  /// **'Kelas {name} berhasil dibuat.'**
  String tCubitClassCreated(String name);

  /// No description provided for @tCubitClassArchived.
  ///
  /// In id, this message translates to:
  /// **'Kelas dipindahkan ke arsip.'**
  String get tCubitClassArchived;

  /// No description provided for @tCubitClassRestored.
  ///
  /// In id, this message translates to:
  /// **'Kelas berhasil dipulihkan.'**
  String get tCubitClassRestored;

  /// No description provided for @tCubitClassCodeNew.
  ///
  /// In id, this message translates to:
  /// **'Kode kelas baru: {code}'**
  String tCubitClassCodeNew(String code);

  /// No description provided for @tCubitLessonCreated.
  ///
  /// In id, this message translates to:
  /// **'Materi baru berhasil dibuat.'**
  String get tCubitLessonCreated;

  /// No description provided for @tCubitLessonPublished.
  ///
  /// In id, this message translates to:
  /// **'Materi berhasil diterbitkan.'**
  String get tCubitLessonPublished;

  /// No description provided for @tCubitLessonDrafted.
  ///
  /// In id, this message translates to:
  /// **'Materi dikembalikan ke draft.'**
  String get tCubitLessonDrafted;

  /// No description provided for @tCubitLessonDeleted.
  ///
  /// In id, this message translates to:
  /// **'Materi berhasil dihapus.'**
  String get tCubitLessonDeleted;

  /// No description provided for @tCubitLessonDuplicated.
  ///
  /// In id, this message translates to:
  /// **'Materi berhasil diduplikasi.'**
  String get tCubitLessonDuplicated;

  /// No description provided for @tCubitBabDuplicated.
  ///
  /// In id, this message translates to:
  /// **'Bab \"{title}\" berhasil diduplikat.'**
  String tCubitBabDuplicated(String title);

  /// No description provided for @tCubitBabDeleted.
  ///
  /// In id, this message translates to:
  /// **'Bab berhasil dihapus.'**
  String get tCubitBabDeleted;

  /// No description provided for @tCubitBabOrderUpdated.
  ///
  /// In id, this message translates to:
  /// **'Urutan bab diperbarui.'**
  String get tCubitBabOrderUpdated;

  /// No description provided for @tCubitStudentRemoved.
  ///
  /// In id, this message translates to:
  /// **'Siswa dikeluarkan dari kelas.'**
  String get tCubitStudentRemoved;

  /// No description provided for @tCubitStudentRemovedNamed.
  ///
  /// In id, this message translates to:
  /// **'{name} dikeluarkan dari kelas.'**
  String tCubitStudentRemovedNamed(String name);

  /// No description provided for @tCubitConnectionFailed.
  ///
  /// In id, this message translates to:
  /// **'Gagal terhubung ke server. Periksa koneksi lalu coba lagi.'**
  String get tCubitConnectionFailed;

  /// No description provided for @tAdapterEmptyBab.
  ///
  /// In id, this message translates to:
  /// **'Bab ini belum memiliki slide.'**
  String get tAdapterEmptyBab;

  /// No description provided for @tAdapterPreviewTopic.
  ///
  /// In id, this message translates to:
  /// **'Pratinjau Guru'**
  String get tAdapterPreviewTopic;

  /// No description provided for @tAdapterPreviewMode.
  ///
  /// In id, this message translates to:
  /// **'Mode Simulator Pratinjau Guru'**
  String get tAdapterPreviewMode;

  /// No description provided for @tAdapterTypeCodeInstruction.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi kode berikut:'**
  String get tAdapterTypeCodeInstruction;

  /// No description provided for @tAdapterOutputQuestion.
  ///
  /// In id, this message translates to:
  /// **'Apakah output dari kode di atas?'**
  String get tAdapterOutputQuestion;

  /// No description provided for @tAdapterBugInstruction.
  ///
  /// In id, this message translates to:
  /// **'Cari baris yang bermasalah:'**
  String get tAdapterBugInstruction;

  /// No description provided for @tAdapterBugExplanation.
  ///
  /// In id, this message translates to:
  /// **'Periksa sintaks pada baris ini.'**
  String get tAdapterBugExplanation;

  /// No description provided for @tAdapterQuizQuestion.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan kuis:'**
  String get tAdapterQuizQuestion;

  /// No description provided for @tAdapterOutroSummary.
  ///
  /// In id, this message translates to:
  /// **'Selamat! Kamu telah menyelesaikan bab ini.'**
  String get tAdapterOutroSummary;

  /// No description provided for @tAdapterLearningTime.
  ///
  /// In id, this message translates to:
  /// **'3 Menit'**
  String get tAdapterLearningTime;

  /// No description provided for @tAdapterMainConcept.
  ///
  /// In id, this message translates to:
  /// **'Konsep Utama'**
  String get tAdapterMainConcept;

  /// No description provided for @tTemplateLabelTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi Kode (Tap)'**
  String get tTemplateLabelTapToFill;

  /// No description provided for @tTemplateLabelTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Ketik Kata Kunci'**
  String get tTemplateLabelTypeCode;

  /// No description provided for @tTemplateLabelOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Tebak Output Kode'**
  String get tTemplateLabelOutputPredict;

  /// No description provided for @tTemplateLabelBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Bug Hunter'**
  String get tTemplateLabelBugHunter;

  /// No description provided for @tTemplateLabelQuiz.
  ///
  /// In id, this message translates to:
  /// **'Kuis Pilihan Ganda'**
  String get tTemplateLabelQuiz;

  /// No description provided for @tTemplateLabelOutro.
  ///
  /// In id, this message translates to:
  /// **'Rangkuman & Klaim XP'**
  String get tTemplateLabelOutro;

  /// No description provided for @tTemplateLabelTheory.
  ///
  /// In id, this message translates to:
  /// **'Teori & Konsep'**
  String get tTemplateLabelTheory;

  /// No description provided for @tTemplateBadgeInteractive.
  ///
  /// In id, this message translates to:
  /// **'Interaktif'**
  String get tTemplateBadgeInteractive;

  /// No description provided for @tTemplateBadgeSyntax.
  ///
  /// In id, this message translates to:
  /// **'Sintaks'**
  String get tTemplateBadgeSyntax;

  /// No description provided for @tTemplateBadgeLogic.
  ///
  /// In id, this message translates to:
  /// **'Logika'**
  String get tTemplateBadgeLogic;

  /// No description provided for @tTemplateBadgeDebugging.
  ///
  /// In id, this message translates to:
  /// **'Debugging'**
  String get tTemplateBadgeDebugging;

  /// No description provided for @tTemplateBadgeEvaluation.
  ///
  /// In id, this message translates to:
  /// **'Evaluasi'**
  String get tTemplateBadgeEvaluation;

  /// No description provided for @tTemplateBadgeAchievement.
  ///
  /// In id, this message translates to:
  /// **'Pencapaian'**
  String get tTemplateBadgeAchievement;

  /// No description provided for @tTemplateBadgeReading.
  ///
  /// In id, this message translates to:
  /// **'Bahan Baca'**
  String get tTemplateBadgeReading;

  /// No description provided for @tTemplateDescTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Siswa mengetuk keping blok untuk melengkapi baris kode.'**
  String get tTemplateDescTapToFill;

  /// No description provided for @tTemplateDescTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Siswa mengetik kata kunci atau ekspresi sintaksis.'**
  String get tTemplateDescTypeCode;

  /// No description provided for @tTemplateDescOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Siswa memprediksi keluaran terminal dari potongan kode.'**
  String get tTemplateDescOutputPredict;

  /// No description provided for @tTemplateDescBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Siswa menemukan baris yang bermasalah dan perbaikannya.'**
  String get tTemplateDescBugHunter;

  /// No description provided for @tTemplateDescQuiz.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan pilihan ganda dengan satu jawaban benar.'**
  String get tTemplateDescQuiz;

  /// No description provided for @tTemplateDescOutro.
  ///
  /// In id, this message translates to:
  /// **'Slide penutup dengan rangkuman dan hadiah XP.'**
  String get tTemplateDescOutro;

  /// No description provided for @tTemplateDescTheory.
  ///
  /// In id, this message translates to:
  /// **'Teks penjelasan konsep materi dan contoh kode.'**
  String get tTemplateDescTheory;

  /// No description provided for @tTemplateTitleTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Lengkapi Kode'**
  String get tTemplateTitleTapToFill;

  /// No description provided for @tTemplatePromptTapToFill.
  ///
  /// In id, this message translates to:
  /// **'Ketuk balok kode untuk melengkapi baris berikut.'**
  String get tTemplatePromptTapToFill;

  /// No description provided for @tTemplatePromptTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Ketikkan fungsi untuk mencetak teks ke layar:'**
  String get tTemplatePromptTypeCode;

  /// No description provided for @tTemplateHintTypeCode.
  ///
  /// In id, this message translates to:
  /// **'Gunakan huruf kecil semua.'**
  String get tTemplateHintTypeCode;

  /// No description provided for @tTemplateTitleOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Tebak Output'**
  String get tTemplateTitleOutputPredict;

  /// No description provided for @tTemplatePromptOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Apakah output yang dicetak ke terminal?'**
  String get tTemplatePromptOutputPredict;

  /// No description provided for @tTemplateExplanationOutputPredict.
  ///
  /// In id, this message translates to:
  /// **'Operator + menjumlahkan dua bilangan bulat.'**
  String get tTemplateExplanationOutputPredict;

  /// No description provided for @tTemplateTitleBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Temukan Galat (Bug)'**
  String get tTemplateTitleBugHunter;

  /// No description provided for @tTemplateScenarioBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Siswa memeriksa program yang gagal dijalankan.'**
  String get tTemplateScenarioBugHunter;

  /// No description provided for @tTemplateBugHintBugHunter.
  ///
  /// In id, this message translates to:
  /// **'Periksa tanda titik dua di akhir baris for.'**
  String get tTemplateBugHintBugHunter;

  /// No description provided for @tTemplateQuestionQuiz.
  ///
  /// In id, this message translates to:
  /// **'Manakah yang termasuk tipe data angka bulat?'**
  String get tTemplateQuestionQuiz;

  /// No description provided for @tTemplateExplanationQuiz.
  ///
  /// In id, this message translates to:
  /// **'int adalah tipe data bilangan bulat.'**
  String get tTemplateExplanationQuiz;

  /// No description provided for @tTemplateTitleOutro.
  ///
  /// In id, this message translates to:
  /// **'Rangkuman Bab'**
  String get tTemplateTitleOutro;

  /// No description provided for @tTemplateSummaryOutro.
  ///
  /// In id, this message translates to:
  /// **'Hebat! Kamu telah menuntaskan materi pada bab ini.'**
  String get tTemplateSummaryOutro;

  /// No description provided for @tTemplateTitleTheory.
  ///
  /// In id, this message translates to:
  /// **'Penjelasan Materi Baru'**
  String get tTemplateTitleTheory;

  /// No description provided for @tTemplateContentTheory.
  ///
  /// In id, this message translates to:
  /// **'Tuliskan penjelasan materi pembelajaran di sini dengan bahasa yang mudah dipahami siswa.'**
  String get tTemplateContentTheory;
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
