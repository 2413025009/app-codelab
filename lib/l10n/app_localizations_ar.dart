// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navLearn => 'التعلّم';

  @override
  String get navChallenges => 'التحديات';

  @override
  String get navPlayground => 'ساحة التجربة';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionClose => 'إغلاق';

  @override
  String get actionRetry => 'المحاولة مجددًا';

  @override
  String get actionDelete => 'حذف';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionSend => 'إرسال';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsAccountTag => 'إعدادات الحساب';

  @override
  String get settingsRoleTeacher => 'معلّم / مدرّس';

  @override
  String get settingsRoleStudent => 'طالب RPL • مستوى مبتدئ';

  @override
  String get settingsChangePhoto => 'تغيير الصورة';

  @override
  String get settingsEditModeHint =>
      'وضع التعديل مفعّل — عدّل بياناتك ثم اضغط «حفظ التغييرات».';

  @override
  String get settingsFieldFullName => 'الاسم الكامل';

  @override
  String get settingsFieldFullNameAside => '40 حرفًا كحد أقصى';

  @override
  String get settingsFullNameEmpty => 'لا يمكن أن يكون الاسم فارغًا';

  @override
  String get settingsFieldNisn => 'NISN / رقم الطالب';

  @override
  String get settingsBadgeVerifiedDapodik => 'موثّق من Dapodik';

  @override
  String get settingsFieldSchool => 'اسم المدرسة / المؤسسة';

  @override
  String get settingsFieldClass => 'الصف والتخصص';

  @override
  String get settingsFieldAddress => 'العنوان';

  @override
  String get settingsFieldStaffCode => 'الرقم الوظيفي (NIP/NIK)';

  @override
  String get settingsFieldAffiliatedSchool => 'المدرسة التابعة';

  @override
  String get settingsBadgeVerified => 'موثّق';

  @override
  String get settingsFieldPhone => 'رقم الهاتف / واتساب';

  @override
  String get settingsPhoneIncomplete => 'الرقم غير مكتمل. مثال: 81234567890';

  @override
  String get settingsPhoneHelper =>
      'اكتبه دون الصفر في البداية، مثال: 81234567890';

  @override
  String get settingsFieldTeacherEmail => 'البريد الإلكتروني للمعلّم';

  @override
  String get settingsFieldStudentEmail => 'بريد الحساب الدراسي';

  @override
  String get settingsEmailAside => 'يجب أن ينتهي بـ @smk.belajar.id';

  @override
  String get settingsFieldTeacherBio => 'نبذة / ملاحظات المعلّم';

  @override
  String get settingsFieldStudentBio => 'نبذة / ملاحظات الدراسة';

  @override
  String get settingsFieldBioAside => '120 حرفًا كحد أقصى';

  @override
  String get settingsSaveChanges => 'حفظ التغييرات';

  @override
  String get settingsCancelEdit => 'إلغاء التعديل';

  @override
  String get settingsEditData => 'تعديل البيانات';

  @override
  String get settingsPreferencesHeader => 'تفضيلات التطبيق';

  @override
  String get settingsLanguage => 'لغة التطبيق';

  @override
  String get settingsLanguageSubtitle => 'الإندونيسية أو English أو العربية';

  @override
  String get settingsDarkMode => 'الوضع الداكن';

  @override
  String get settingsDarkModeSubtitle => 'سمة داكنة مريحة للعين';

  @override
  String get settingsThemeMode => 'سمة المظهر';

  @override
  String get settingsThemeModeSubtitle =>
      'اختر فاتحًا أو داكنًا أو اتبع إعداد الهاتف';

  @override
  String get settingsThemeLight => 'فاتح';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsThemeSystem => 'اتبع النظام';

  @override
  String get settingsNotifications => 'الإشعارات';

  @override
  String get settingsNotificationsSubtitle => 'تحديثات مهمة دون فتح التطبيق';

  @override
  String get settingsNotifySummaryAllOn => 'جميع الأنواع مفعّلة';

  @override
  String get settingsNotifySummaryOff => 'معطّلة';

  @override
  String settingsNotifySummaryPartial(int count) {
    return '$count من 5 أنواع مفعّلة';
  }

  @override
  String get settingsNotificationsMaster => 'تفعيل الإشعارات';

  @override
  String get settingsNotificationsMasterSubtitle =>
      'أوقفه لإيقاف جميع الإشعارات';

  @override
  String get settingsNotifyCertificate => 'إصدار الشهادة';

  @override
  String get settingsNotifyCertificateSubtitle =>
      'عند إتمام مودول أو النجاح في تحدٍ';

  @override
  String get settingsNotifyDownload => 'تنزيل الشهادة';

  @override
  String get settingsNotifyDownloadSubtitle => 'عند اكتمال تنزيل الشهادة PDF';

  @override
  String get settingsNotifyReminder => 'تذكير الدراسة';

  @override
  String get settingsNotifyReminderSubtitle =>
      'تذكير يومي وعودة حصة AI Tutor كاملة';

  @override
  String get settingsNotifyMaterial => 'مودولات جديدة';

  @override
  String get settingsNotifyMaterialSubtitle =>
      'عند نشر المعلم مودول أو فصلًا جديدًا';

  @override
  String get settingsNotifySession => 'أمان الجلسة';

  @override
  String get settingsNotifySessionSubtitle => 'عند تسجيل الدخول من جهاز آخر';

  @override
  String get settingsNotifyTest => 'إرسال إشعار تجريبي';

  @override
  String get settingsNotifyTestSubtitle =>
      'تأكد من ظهور الإشعارات على هذا الجهاز';

  @override
  String get settingsNotifyTestSent => 'تم إرسال الإشعار التجريبي.';

  @override
  String get settingsNotifyTestFailed =>
      'تعذّر إرسال الإشعار. تحقّق من إذن الإشعارات لهذا التطبيق.';

  @override
  String get settingsNotifyPermissionDenied =>
      'تم رفض إذن الإشعارات. فعّله من إعدادات الهاتف.';

  @override
  String get notifCertificateTitle => 'صدرت شهادة الكفاءة';

  @override
  String notifCertificateBody(String topic) {
    return 'اكتمل $topic. شهادتك جاهزة للتنزيل.';
  }

  @override
  String get notifChallengeTitle => 'صدرت شهادة التحدي';

  @override
  String notifChallengeBody(String title) {
    return '$title نجح بدرجة 100/100. شهادة التحدي جاهزة للتنزيل.';
  }

  @override
  String get notifDownloadTitle => 'تم تنزيل الشهادة';

  @override
  String notifDownloadBody(String certId) {
    return 'تم حفظ الملف $certId على هذا الجهاز.';
  }

  @override
  String get notifReminderTitle => 'حان وقت الدراسة';

  @override
  String get notifReminderBody => 'عادت حصة AI Tutor إلى 5/5 اليوم.';

  @override
  String get notifMaterialTitle => 'مودول جديد من معلمك';

  @override
  String notifMaterialBody(String title) {
    return 'تم نشر $title. افتح الكتالوج لرؤيته.';
  }

  @override
  String get notifSessionTitle => 'انتهت الجلسة';

  @override
  String get notifSessionBody =>
      'تم تسجيل الدخول إلى حسابك من جهاز آخر. سجّل الدخول مجددًا للمتابعة.';

  @override
  String get notifTestTitle => 'إشعار تجريبي';

  @override
  String get notifTestBody => 'إشعارات CodeLab AI تعمل على هذا الجهاز.';

  @override
  String get notifNewBadge => 'جديد';

  @override
  String get offlineBannerTitle => 'أنت غير متصل. تحقّق من اتصال الإنترنت.';

  @override
  String get materialSearchContentTitle => 'نتائج داخل المادة';

  @override
  String get materialSearchContentNoSnippet => 'تظهر هذه الكلمة داخل المادة.';

  @override
  String get settingsSfx => 'مؤثرات صوتية للتطبيق';

  @override
  String get settingsSfxSubtitle => 'أصوات النوافذ والإشعارات والاختبارات';

  @override
  String get settingsLabSfx => 'مؤثرات صوتية للمختبر';

  @override
  String get settingsLabSfxSubtitle => 'الصوت أثناء تنفيذ الكود والطرفية';

  @override
  String get settingsAccountLabHeader => 'إعدادات الحساب والمختبر';

  @override
  String get settingsHelpCenter => 'مساعدة المشرف';

  @override
  String get settingsHelpCenterSubtitle =>
      'تواصل مع المشرف عبر واتساب +62 831-2500-5309';

  @override
  String get settingsHelpLaunchFailed => 'تعذر فتح واتساب. حاول مرة أخرى.';

  @override
  String get settingsChangePassword => 'تغيير كلمة المرور';

  @override
  String get settingsChangePasswordSubtitle =>
      'كلمة المرور القديمة والجديدة مع قائمة تحقق أمنية';

  @override
  String get settingsChangePasswordSheetSubtitle =>
      'قواعد كلمة المرور كما كانت عند إنشاء الحساب.';

  @override
  String get settingsLogout => 'تسجيل الخروج';

  @override
  String get settingsLogoutTitle => 'تسجيل الخروج من الحساب؟';

  @override
  String get settingsLogoutBody =>
      'هل أنت متأكد من إنهاء جلسة التدريب الحالية؟';

  @override
  String get settingsLogoutConfirm => 'نعم، خروج';

  @override
  String get settingsAvatarDeleteTitle => 'حذف صورة الملف الشخصي؟';

  @override
  String get settingsAvatarDeleteBody =>
      'ستُحذف الصورة من حسابك. يمكنك رفع صورة جديدة في أي وقت.';

  @override
  String get settingsAvatarMaxSize => 'أقصى حجم للصورة 2 ميغابايت.';

  @override
  String get settingsAvatarUpdated => 'تم تحديث صورة الملف الشخصي.';

  @override
  String get settingsAvatarDeleted => 'تم حذف صورة الملف الشخصي.';

  @override
  String get settingsAvatarProcessFailed =>
      'تعذّرت معالجة الصورة. تحقّق من إذن المعرض والاتصال ثم حاول مجددًا.';

  @override
  String get settingsAvatarDeleteFailed =>
      'تعذّر حذف الصورة. تحقّق من الاتصال ثم حاول مجددًا.';

  @override
  String get settingsProfileSaved => 'تم حفظ تغييرات الملف الشخصي!';

  @override
  String get settingsProfileSaveFailed =>
      'تعذّر حفظ الملف الشخصي. حاول مجددًا.';

  @override
  String get settingsLanguageSheetTitle => 'لغة التطبيق';

  @override
  String get settingsLanguageSheetSubtitle =>
      'تُطبَّق على جميع شاشات CodeLab AI';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get playgroundReset => 'إعادة تعيين';

  @override
  String get playgroundRun => 'تشغيل';

  @override
  String get playgroundRunning => 'جارٍ التشغيل…';

  @override
  String get playgroundTerminal => 'الطرفية';

  @override
  String get playgroundClearTerminal => 'مسح الطرفية';

  @override
  String get playgroundOpenTerminal => 'فتح الطرفية';

  @override
  String get playgroundCloseTerminal => 'إغلاق الطرفية';

  @override
  String get playgroundEmptyDone => '(انتهى البرنامج دون مخرجات)';

  @override
  String get playgroundEmptyIdle => 'اضغط «تشغيل» لعرض المخرجات';

  @override
  String get playgroundInputHint => 'اكتب إجابتك…';

  @override
  String playgroundStatusDone(Object ms) {
    return 'انتهى (${ms}ms)';
  }

  @override
  String playgroundStatusError(Object ms) {
    return 'خطأ (${ms}ms)';
  }

  @override
  String get sandboxTooltip => 'ما الذي لا يمكن فعله في ساحة التجربة؟';

  @override
  String get sandboxSheetTitle => 'حدود ساحة بايثون';

  @override
  String get sandboxSheetSubtitle => 'رسالة المعلّم قبل أن تبدأ';

  @override
  String get sandboxLimitJudgeTitle => 'مقيّم الساحة يختلف عن مقيّم التحديات';

  @override
  String get sandboxLimitJudgeBody =>
      'تعمل الساحة على هاتفك، بينما تُقيَّم التحديات على الخادم ببايثون كاملة. قد يختلف سلوك الكود هنا عند التسليم. إذا حدث ذلك، اعتمد النتيجة في صفحة التحدي — فهي الدرجة الرسمية.';

  @override
  String get sandboxIntro =>
      'يا أبنائي، قبل أن تبدأوا التجربة، استمعوا إلى رسالة معلّمكم. ساحة بايثون هذه مساحة تدريب محدودة عمدًا، وليست بايثون كاملة. ولكي لا تحتاروا عند فشل شيء، إليكم ما لا يمكن فعله هنا بعد:';

  @override
  String get sandboxLimitImportTitle => 'استدعاء الوحدات عبر import';

  @override
  String get sandboxLimitImportBody =>
      'أمر import غير موجود في هذه الساحة. لذلك لا يمكن استخدام مكتبات مثل random وmath وdatetime أو أي حزمة من الإنترنت بعد.';

  @override
  String get sandboxLimitFileTitle => 'فتح الملفات والاتصال بالخارج';

  @override
  String get sandboxLimitFileBody =>
      'فتح الملفات أو حفظها، والوصول إلى الإنترنت، وإعطاء أوامر لنظام التشغيل غير مسموح بعد. كل ما تكتبه يعمل داخل التطبيق فقط.';

  @override
  String get sandboxLimitGuiTitle => 'إنشاء واجهات رسومية أو صور أو أصوات';

  @override
  String get sandboxLimitGuiBody =>
      'tkinter وpygame وما شابههما غير متوفرة بعد. هنا نتدرب على منطق البرنامج، لا على إنشاء نوافذ أو ألعاب تتحرك وحدها.';

  @override
  String get sandboxLimitOopTitle => 'استخدام class وdict وtry/except';

  @override
  String get sandboxLimitOopBody =>
      'هذه الموضوعات الثلاثة غير موجودة في محرك التدريب بعد. ركّزوا الآن على المتغيرات والتفريعات والتكرار والقوائم والدوال.';

  @override
  String get sandboxLimitLimitsTitle => 'تشغيل برامج ثقيلة جدًا';

  @override
  String get sandboxLimitLimitsBody =>
      'يتوقف البرنامج تلقائيًا بعد 100,000 خطوة أو 5 ثوانٍ، والاستدعاء الذاتي محدود بـ200 مستوى. إن وصلتم إلى هذا الحد، راجعوا حلقاتكم — غالبًا هناك حلقة لا تتوقف.';

  @override
  String get sandboxClosing =>
      'إن ظهر خطأ رغم أن الكود يبدو صحيحًا، تحقّقوا أولًا هل تستخدمون شيئًا من القائمة أعلاه. وإن بقيتم حائرين فاسألوا معلّمكم في الصف — لستم مضطرين لحلّها وحدكم.';

  @override
  String get dashTitle => 'لوحة التحكم';

  @override
  String get dashLoadingTitle => 'جارٍ تجهيز لوحة التحكم';

  @override
  String get dashLoadingSubtitle => 'سحب بيانات التعلّم من الخادم';

  @override
  String get dashStageConnecting => 'جارٍ الاتصال بالخادم…';

  @override
  String get dashStageProfile => 'تم تحميل ملف الطالب';

  @override
  String get dashStageProgress => 'تم تحميل تقدم الفصول';

  @override
  String get dashStageSkills => 'تم تحميل رادار المهارات';

  @override
  String get dashStageLessons => 'تم تحميل كتالوج المواد';

  @override
  String get dashStageChallenges => 'تم تحميل سجلات التحديات';

  @override
  String get dashStageComposing => 'جارٍ تجهيز لوحة التحكم…';

  @override
  String dashGreeting(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get dashNoModules => 'لا توجد وحدات بعد. تحقّق لاحقًا.';

  @override
  String get dashQuickTipTitle => 'نصيحة بايثون سريعة';

  @override
  String get dashQuickTipSubtitle => 'استخدم elif لتقييم شروط متعددة';

  @override
  String get dashQuickTipBody =>
      'استخدم تركيب elif لتقييم عدة شروط بشكل متتابع ونظيف:\n\nif score >= 90:\n    result = \"A\"\nelif score >= 75:\n    result = \"B\"\nelse:\n    result = \"C\"\n\nمع elif، يتوقف التقييم بمجرد تحقق الشرط الأول دون الحاجة لشروط if متداخلة.';

  @override
  String get dashQuickTipButton => 'فهمت، تابع التعلّم!';

  @override
  String get dashErrorTitle => 'حدث خطأ من جانبنا. حاول مجددًا بعد قليل.';

  @override
  String get dashRetryButton => 'حاول مجددًا';

  @override
  String dashChallengesCompleted(int count) {
    return 'تم إكمال $count تحديًا';
  }

  @override
  String get dashModuleLocked => 'هذه الوحدة لا تزال مقفلة.';

  @override
  String get dashDefaultTopic => 'أساسيات بايثون والمنطق';

  @override
  String get dashDefaultChapter => '1. مقدمة في منطق البرمجة';

  @override
  String dashBabOf(int current, int total) {
    return 'الفصل $current من $total';
  }

  @override
  String dashPercentDone(int percent) {
    return '$percent% مكتمل';
  }

  @override
  String get dashCompetencyTitle => 'كفاءتك';

  @override
  String get dashCompetencyEmpty => 'أكمل تحديًا واحدًا، وستظهر كفاءتك هنا.';

  @override
  String get actionSeeDetail => 'عرض التفاصيل';

  @override
  String get moduleStatusCompleted => 'مكتمل';

  @override
  String get moduleStatusActive => 'قيد التعلّم';

  @override
  String get moduleStatusAvailable => 'جاهز للبدء';

  @override
  String get moduleStatusLocked => 'مقفل';

  @override
  String get roadmapTitle => 'خريطة رحلة التعلّم';

  @override
  String roadmapStopsToCertificate(int count) {
    return '$count محطة نحو الشهادة';
  }

  @override
  String roadmapActiveBab(int step) {
    return 'الفصل $step نشط';
  }

  @override
  String get roadmapCatalogTitle => 'فهرس المواد';

  @override
  String get roadmapCatalogSubtitle => 'تصفّح الفصول من جميع المواد';

  @override
  String get roadmapStartHere => 'ابدأ من هنا! 🚀';

  @override
  String get roadmapInProgress => 'جارٍ الآن';

  @override
  String get roadmapPracticeCount => '6 تدريبات';

  @override
  String roadmapBabLine(int order, String label) {
    return 'الفصل $order • $label';
  }

  @override
  String get roadmapQuizNode => 'اختبر فهمك';

  @override
  String get roadmapAvailableNow => 'جاهز للبدء الآن';

  @override
  String get roadmapCertificate => 'شهادة الوحدة';

  @override
  String get roadmapGraduationTarget => 'هدف التخرّج';

  @override
  String get levelBeginner => 'مبتدئ';

  @override
  String get levelIntermediate => 'متوسط';

  @override
  String get levelAdvanced => 'متقدّم';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterTodo => 'لم يُنجز';

  @override
  String get filterDone => 'مكتمل';

  @override
  String get filterMiniProject => 'مشروع مصغّر';

  @override
  String get actionApply => 'تطبيق';

  @override
  String get appDefaultStudentName => 'طالب';

  @override
  String get challengeFilterTitle => 'تصفية التحديات';

  @override
  String get challengeLevelSection => 'مستوى الصعوبة';

  @override
  String get challengeLockedTitle => 'تحدي مقفل';

  @override
  String challengeLockedBody(int xp, int userXp) {
    return 'الشرط: تحتاج إلى $xp XP على الأقل لفتح هذا التحدي. لديك حاليًا $userXp XP.';
  }

  @override
  String get challengeLearningPath => 'مسار التعلّم';

  @override
  String get challengeCatalogTitle => 'فهرس التحديات';

  @override
  String get challengeCatalogSubtitle =>
      'اصقل منطق الخوارزميات والبرمجة تدريجيًا';

  @override
  String get challengeFilter => 'تصفية';

  @override
  String get challengeFilterActive => 'تصفية • 1';

  @override
  String challengeFilterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get challengeSearchHint => 'ابحث عن موضوع أو دالة أو خوارزمية...';

  @override
  String get challengeClearSearch => 'مسح البحث';

  @override
  String get challengeSearchTooltip => 'ابحث عن التحديات';

  @override
  String get challengeNoMatch =>
      'لا توجد تحديات مطابقة. جرّب تغيير الكلمة المفتاحية أو التصفية.';

  @override
  String challengeGroupDone(int done, int total) {
    return '$done / $total مكتمل';
  }

  @override
  String challengeGroupUnlocked(int unlocked, int total) {
    return '$unlocked / $total مفتوح';
  }

  @override
  String challengeSummaryDone(int done, int total) {
    return '$done من $total مكتمل';
  }

  @override
  String get challengeSummarySubtitle => 'إتقان منهج الخوارزميات RPL';

  @override
  String challengeXpEarned(int xp) {
    return '+$xp XP مكتسبة';
  }

  @override
  String get challengeStatusInProgress => 'قيد المحاولة';

  @override
  String get challengeMiniProjectHeader => 'مشروع مصغّر تطبيقي';

  @override
  String get challengeMiniProjectSubtitle =>
      'تدريب شامل على تطبيق المنطق كما في مدارس RPL المهنية';

  @override
  String get challengeOpen => 'مفتوح';

  @override
  String challengeMinutes(int count) {
    return '$count دقيقة';
  }

  @override
  String challengeXpRequired(int xp) {
    return 'تحتاج $xp XP';
  }

  @override
  String challengeXpRequirement(int xp) {
    return 'الشرط: تحتاج $xp XP';
  }

  @override
  String challengeTestCount(int count) {
    return '$count اختبار وحدة';
  }

  @override
  String get challengeDetailTitle => 'تحدي البرمجة';

  @override
  String get challengeHistoryTooltip => 'سجل التسليمات';

  @override
  String challengeLevelLine(String level) {
    return 'المستوى: $level';
  }

  @override
  String challengeXpPlus(int xp) {
    return '+$xp XP';
  }

  @override
  String challengeMinutesShort(int count) {
    return '~$count د';
  }

  @override
  String get challengeTaskInstruction => 'تعليمات المهمة';

  @override
  String get challengeSampleCalls => 'أمثلة على الاستدعاء';

  @override
  String get challengeTabInstruction => 'التعليمات والاختبارات';

  @override
  String get challengeTabSolution => 'حلّك البرمجي';

  @override
  String get challengeFormatPep8 => 'تنسيق PEP8';

  @override
  String get challengeFormatDone => 'تم تطبيق تنسيق PEP8 بنجاح';

  @override
  String get challengeResetCode => 'إعادة ضبط الكود';

  @override
  String get challengeAiHelpTitle => 'هل تحتاج مساعدة الذكاء الاصطناعي؟';

  @override
  String get challengeAiHelpSubtitle =>
      'احصل على تلميحات تدريجية دون كشف الكود';

  @override
  String challengeQuotaLabel(int used, int total) {
    return '$used/$total حصة';
  }

  @override
  String get challengeAskHint => 'اطلب تلميحًا';

  @override
  String get challengeRunFailed =>
      'حدث خلل أثناء تنفيذ الكود. حاول مرة أخرى بعد قليل.';

  @override
  String get challengeSubmitFailed => 'فشل إرسال الحل. حاول مرة أخرى بعد قليل.';

  @override
  String get challengeTestResultTitle => 'نتائج الاختبار التلقائي';

  @override
  String get challengeTestResultCompletedTitle =>
      'نتائج الاختبار التلقائي — مكتمل';

  @override
  String challengePassedCount(int passed, int total) {
    return '$passed/$total ناجح';
  }

  @override
  String challengeExecutionTime(int ms) {
    return 'زمن التنفيذ: ${ms}ms';
  }

  @override
  String get challengePassed => 'ناجح';

  @override
  String get challengeFailed => 'فاشل';

  @override
  String challengeCaseDetail(String input, String expected, String output) {
    return 'المدخل: $input • المتوقع: $expected • المخرج: $output';
  }

  @override
  String get challengeScaffoldingLevels => 'تدرّج بثلاثة مستويات';

  @override
  String get challengeLogicHintLabel => 'تلميح المنطق: ';

  @override
  String get challengeAllTestsPassed =>
      'رائع! نجحت جميع الاختبارات. اضغط زر إرسال الحل بالأسفل لكسب نقاط XP!';

  @override
  String challengeCasesNotPassed(int count) {
    return '$count حالة لم تنجح في الاختبار التلقائي. اطلب توجيه المدرّس الذكي بالأسفل — تلميحاته ترشد كودك لا تعطيك الحل جاهزًا.';
  }

  @override
  String get challengeAskAiTutor => 'اسأل المدرّس الذكي';

  @override
  String get challengeCompletedBody =>
      'لقد أكملت هذا التحدي. تفاصيل الحالات تظهر فقط أثناء جلسة التسليم الجارية؛ أما أفضل نتيجة فمسجّلة رسميًا في الخادم:';

  @override
  String challengeBestScore(int score) {
    return 'أفضل نتيجة: $score%';
  }

  @override
  String get challengeViewHistory => 'عرض سجل التسليمات';

  @override
  String get challengeTryRun => 'تجربة التشغيل';

  @override
  String get challengeSubmitSolution => 'إرسال الحل';

  @override
  String get challengeEvaluationTitle => 'تقييم المشروع';

  @override
  String get evalSolutionAccepted => 'تم قبول الحل!';

  @override
  String get evalSolutionNotYet => 'الحل لم ينجح بعد';

  @override
  String get evalAllPassedBody =>
      'نجحت جميع الاختبارات العلنية والخفية دون أي عوائق.';

  @override
  String evalSomeFailedBody(int passed, int total) {
    return 'لا تفقد الأمل! نجحت $passed من $total اختبارات. لنتفحص الأخطاء ونصلحها مع المدرّس الذكي.';
  }

  @override
  String get evalMetricFinalScore => 'النتيجة النهائية';

  @override
  String get evalBadgePerfect => 'ممتاز';

  @override
  String get evalBadgeNeedsImprovement => 'يحتاج تحسينًا';

  @override
  String get evalMetricExecution => 'التنفيذ';

  @override
  String get evalSecondsSuffix => ' ث';

  @override
  String get evalBadgeFast => 'سريع';

  @override
  String get evalTestResultsHeader => 'نتائج الاختبار التلقائي';

  @override
  String get evalCompetencyTitle => 'كفاءة المنطق والخوارزميات';

  @override
  String get evalPointsPlus => '+5 نقاط';

  @override
  String get evalCompetencySubtitle =>
      'يُسجَّل الدليل العملي تلقائيًا في ملفك المهني.';

  @override
  String get evalCooldownTitle => 'فترة انتظار إرسال الحل';

  @override
  String get evalCooldownPrefix => 'انتظر ';

  @override
  String get evalCooldownSuffix =>
      ' ثانية قبل إمكانية إرسال حل جديد للحفاظ على استقرار حاوية الاختبار.';

  @override
  String get evalCooldownReady => 'المترجم جاهز لاستقبال حل برمجي جديد.';

  @override
  String get evalNextChallenge => 'متابعة إلى التحدي التالي';

  @override
  String get evalFixSolution => 'أصلح حلك البرمجي';

  @override
  String get evalHiddenBadge => 'مخفي';

  @override
  String get historyTitle => 'سجل التسليمات';

  @override
  String get historyStatusPassed => 'ناجح';

  @override
  String get historyStatusError => 'خطأ';

  @override
  String get historyBestScore => 'أعلى نتيجة';

  @override
  String historyAttemptsCount(int count) {
    return '$count محاولات مُرسلة';
  }

  @override
  String get historySubmissionsHeader => 'سجل الإرسال';

  @override
  String get historySortedByTime => 'مرتّب زمنيًا';

  @override
  String get historyOpenPlayground => 'افتح في ساحة التدريب';

  @override
  String get historyBackToChallenge => 'العودة إلى التحدي';

  @override
  String historySubmissionNumber(int number) {
    return 'التسليم #$number';
  }

  @override
  String historyScoreInline(int score) {
    return '  •  النتيجة $score/100';
  }

  @override
  String historyHintsUsed(int count) {
    return '$count تلميحات ذكاء اصطناعي مستخدمة';
  }

  @override
  String historySubmissionCode(int number) {
    return 'كود التسليم #$number (Python)';
  }

  @override
  String get historyAiReview => 'مراجعة المدرّس الذكي';

  @override
  String get tutorSubtitle => 'التدرّج ورفيق التعلّم';

  @override
  String get tutorQuotaToastExhausted =>
      'انتهت حصة التلميحات اليوم. حاول مرة أخرى غدًا.';

  @override
  String get tutorQuotaToastExhaustedDetail =>
      'انتهت حصة التلميحات اليوم. حاول غدًا للتدرب بشكل مستقل.';

  @override
  String get tutorHintFailed => 'تعذّر تجهيز التلميح. حاول مرة أخرى بعد قليل.';

  @override
  String get tutorHintOffline =>
      'خادم التلميحات غير متاح حاليًا — سيُعرض التلميح المدمج.';

  @override
  String tutorConceptLabel(String concept) {
    return 'المفهوم: $concept';
  }

  @override
  String tutorLevelLabel(int unlocked, int total) {
    return 'المستوى $unlocked/$total';
  }

  @override
  String get tutorQuotaRemaining => 'الحصة المتبقية';

  @override
  String get tutorScaffoldingTitle => 'تدرّج خطوة بخطوة';

  @override
  String get tutorSocraticMethod => 'الطريقة السقراطية';

  @override
  String get tutorPromptQuestion => 'سؤال موجّه:';

  @override
  String get tutorPreparingHint => 'جارٍ تجهيز تلميح لهذا التحدي…';

  @override
  String get tutorQuotaBlockedBody =>
      'انتهت حصة التلميحات اليوم (5 مرات يوميًا). تلميحات هذا التحدي تتاح مجددًا غدًا — حتى ذلك الحين، أكمل التفكير في كودك أولًا.';

  @override
  String get tutorThinkingFlow => 'مسار التفكير المقترح';

  @override
  String get tutorPreparingShort => 'جارٍ تجهيز التلميح…';

  @override
  String tutorUnlockNext(String level) {
    return 'افتح التلميح التالي ($level)';
  }

  @override
  String get tutorQuotaExhaustedBody =>
      'انتهت حصة التلميحات اليومية (بحد أقصى 5 مرات يوميًا حسب متطلبات المشروع). ستتجدد غدًا — حتى ذلك الحين، أكمل التفكير في كودك أولًا.';

  @override
  String get tutorAllHintsUnlocked =>
      'تم فتح جميع التلميحات. جرّب الآن تطبيقها في كودك.';

  @override
  String get tutorLockedSuffix => '، مقفل';

  @override
  String get materialCatalogTitle => 'فهرس المواد';

  @override
  String get materialFilterActive => 'قيد التقدم';

  @override
  String get materialFilterNotStarted => 'لم يبدأ';

  @override
  String get materialStatusRunning => 'جارٍ';

  @override
  String get materialLoadFailed => 'تعذّر تحميل فهرس المواد.';

  @override
  String get materialSearchHint => 'ابحث عن المواد أو وصفها…';

  @override
  String get materialClearSearch => 'مسح البحث';

  @override
  String get materialNoMatch => 'لا توجد مواد مطابقة لبحثك أو تصفيتك.';

  @override
  String materialSwitchedSnack(String topic) {
    return 'عرض الدرس $topic. تم تحديث خريطة التعلم.';
  }

  @override
  String materialChaptersDone(int done, int total) {
    return '$done/$total فصلًا مكتملًا';
  }

  @override
  String get readerPreviewDone =>
      'اكتملت معاينة الطالب! تم تقييم جميع الشرائح بنجاح.';

  @override
  String readerXpEarned(int xp) {
    return 'أحسنت! حصلت على +$xp XP! 🎉';
  }

  @override
  String get readerXpAlreadyDone =>
      'تم إكمال هذا الفصل سابقًا — لن تُحتسب نقاط XP مرتين.';

  @override
  String get readerExitTitle => 'الخروج من التدريب؟';

  @override
  String get readerExitBody => 'سيُحفظ تقدّمك في الشريحة الأخيرة تلقائيًا.';

  @override
  String get readerExitStay => 'متابعة التعلّم';

  @override
  String get readerExitConfirm => 'خروج';

  @override
  String get readerLoadFailed => 'تعذّر تحميل مادة الفصل.';

  @override
  String get readerTeacherPreviewBanner =>
      'وضع معاينة المعلّم (لا تُحفظ البيانات)';

  @override
  String get readerContinue => 'فهمت، تابع';

  @override
  String get readerFinishSave => 'إنهاء وحفظ التقدّم';

  @override
  String get readerCheckAnswer => 'تحقق من الإجابة';

  @override
  String get slideBadgeValidated => 'خطوة مُتحقَّق منها';

  @override
  String get slideProgressSaved => 'تم حفظ التقدّم';

  @override
  String get slideWhyCorrect => 'لماذا إجابتك صحيحة؟';

  @override
  String get slideNextSlide => 'الانتقال إلى الشريحة التالية';

  @override
  String get slideSyntaxEvaluation => 'تقييم الصياغة';

  @override
  String get slideZeroXpTryAgain => '0 XP • واصل المحاولة!';

  @override
  String get slideErrorEncouragement =>
      'لا تقلق، الأخطاء الصغيرة جزء طبيعي من تعلّم البرمجة.';

  @override
  String get slideSkipArrow => 'تخطَّ الشريحة →';

  @override
  String get slideWhereIsMistake => 'أين يكمن الخطأ؟';

  @override
  String get slideBadgeTheory => 'نظري ومفاهيم';

  @override
  String get slideTheoryTip =>
      'افهم المفهوم أعلاه بعناية قبل الانتقال إلى التدريب التفاعلي.';

  @override
  String get slideBadgeArrangeSyntax => 'رتّب الصياغة';

  @override
  String get slideTapToFillInstruction =>
      'اضغط على كتل الكود أدناه لملء الفراغات المناسبة:';

  @override
  String get slideWordBank => 'بنك الكتل البرمجية:';

  @override
  String get slideBadgeTypeCode => 'اكتب الكود';

  @override
  String get slideHint => 'تلميح';

  @override
  String get slideTypeHere => 'اكتب هنا...';

  @override
  String get slideBadgeGuessOutput => 'توقّع المخرجات';

  @override
  String get slideBadgeBugHunter => 'صيّاد الأخطاء';

  @override
  String get slideBugHunterInstruction =>
      'اضغط على السطر الذي ترى أنه يحتوي على خطأ برمجي أعلاه.';

  @override
  String get slideBadgeConceptQuiz => 'اختبار المفاهيم';

  @override
  String get slideOutroXpReward => 'مكافأة XP';

  @override
  String get slideOutroAccuracy => 'الدقة';

  @override
  String get slideOutroLearningTime => 'وقت التعلّم';

  @override
  String get slideOutroMasteredConcepts => 'المفاهيم التي أتقنتها';

  @override
  String get profileTitle => 'الملف الشخصي والكفاءات';

  @override
  String get profileSettingsTooltip => 'إعدادات الملف الشخصي';

  @override
  String get profileLoading => 'جارٍ تحميل الملف الشخصي…';

  @override
  String get profileLoadFailedTitle => 'تعذّر تحميل بيانات الملف الشخصي';

  @override
  String get profileLoadFailedBody =>
      'تأكد من تشغيل خادم مختبر البرمجة ثم حاول مجددًا.';

  @override
  String get profileNewStudent => 'طالب جديد';

  @override
  String get profileAddBio => '+ أضف نبذة';

  @override
  String get profileStatChallenges => 'التحديات';

  @override
  String get profileStatXpPoints => 'نقاط XP';

  @override
  String get profileStatMaterialsDone => 'المواد المكتملة';

  @override
  String get profileMasteryMapTitle => 'خريطة إتقان المواد';

  @override
  String get profileMaterialsUnavailable =>
      'قائمة المواد غير متاحة من الخادم بعد. حاول مجددًا.';

  @override
  String get profileMaterialProgressTitle => 'تقدّم المواد';

  @override
  String profileChaptersInline(int done, int total) {
    return '$done/$total فصلًا';
  }

  @override
  String get profileCurriculumUnavailable =>
      'المنهج غير متاح من الخادم بعد. حاول مجددًا.';

  @override
  String get profileCertificatesTitle => 'الشهادات';

  @override
  String profileTracksDoneBadge(int done, int total) {
    return '$done/$total مكتمل';
  }

  @override
  String get profileChallengeCertsTitle => 'شهادات التحديات';

  @override
  String get profileNoChallenges =>
      'لا توجد تحديات في الفهرس بعد — حاول مجددًا.';

  @override
  String profileBabCountInline(int done, int total) {
    return '$done/$total فصل';
  }

  @override
  String get profileCertReady => 'الشهادة جاهزة للتنزيل';

  @override
  String get profileCertLearning => 'قيد التعلّم';

  @override
  String get profileDownload => 'تنزيل';

  @override
  String get profileCertChallengeDone => 'مكتمل — الشهادة جاهزة';

  @override
  String get profileCertChallengeLocked => 'مقفل — نقاط XP غير كافية';

  @override
  String get profileCertChallengeInProgress => 'قيد التنفيذ';

  @override
  String get profileDownloadSoon => 'ميزة تنزيل الشهادات قادمة قريبًا!';

  @override
  String get certScreenTitle => 'شهادة الكفاءة';

  @override
  String get certLoading => 'جارٍ تجهيز شهادتك…';

  @override
  String get certLoadFailed =>
      'تعذّر تحميل الشهادة. تحقّق من الاتصال ثم حاول مجددًا.';

  @override
  String get certOpenPreview => 'عرض الشهادة';

  @override
  String get certOpenWeb => 'فتح صفحة التحقق';

  @override
  String get certShareAction => 'مشاركة الشهادة';

  @override
  String get certShareCopied => 'تم نسخ رابط التحقق بنجاح.';

  @override
  String get certShareFailed => 'تعذّر نسخ الرابط. حاول مجددًا.';

  @override
  String get certNotEligible => 'أكمل جميع فصول هذا المودول أولًا.';

  @override
  String get certEligibleNow => 'شهادتك جاهزة للإصدار.';

  @override
  String get certIdLabel => 'معرّف الشهادة';

  @override
  String get certGivenTo => 'مُنحت إلى';

  @override
  String get certIssuedLabel => 'تاريخ الإصدار';

  @override
  String get certValidUntilLabel => 'صالح حتى';

  @override
  String get certPageOne => 'الصفحة 1 — شهادة إتمام';

  @override
  String get certPageTwo => 'الصفحة 2 — كشف الدرجات والإنجازات';

  @override
  String get certPdfHint => 'تُنزَّل الصفحتان تلقائيًا في ملف PDF واحد.';

  @override
  String certChapterCountInline(int done, int total) {
    return '$done/$total فصول مكتملة';
  }

  @override
  String get certPreviewTitle => 'معاينة الشهادة الإلكترونية';

  @override
  String get certChallengeSectionTitle => 'شهادات تحديات البرمجة';

  @override
  String get certCatalogTitle => 'فهرس الشهادات';

  @override
  String get certCatalogSubtitle =>
      'كل شهادات المودولات والتحديات التي أكملتها.';

  @override
  String get certModuleSectionTitle => 'شهادات المودولات';

  @override
  String get certDownloadPdf => 'تنزيل PDF';

  @override
  String get certDownloadFailed =>
      'تعذّر تنزيل ملف PDF. تحقّق من الاتصال ثم حاول مجددًا.';

  @override
  String certReadyCount(int count) {
    return '$count شهادة جاهزة للتنزيل';
  }

  @override
  String get certEmptyTitle => 'لا توجد شهادات بعد';

  @override
  String get certEmptyBody =>
      'أكمل جميع فصول مودول أو اجتز تحدي برمجة لإصدار شهادة.';

  @override
  String get certNotEligibleShort => 'غير مؤهل';

  @override
  String get certOpenCatalog => 'عرض جميع الشهادات';

  @override
  String get certProfileSummaryBody => 'المودولات والتحديات التي أكملتها.';

  @override
  String get certTabFront => 'الشهادة';

  @override
  String get certTabBack => 'كشف الدرجات';

  @override
  String certProgressLockedHint(int percent) {
    return '$percent% مكتمل — تُصدر الشهادة تلقائيًا بعد إتمام جميع الفصول.';
  }

  @override
  String get changePassOldLabel => 'كلمة المرور القديمة';

  @override
  String get changePassNewLabel => 'كلمة المرور الجديدة';

  @override
  String get changePassConfirmLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePassShowPassword => 'إظهار كلمة المرور';

  @override
  String get changePassHidePassword => 'إخفاء كلمة المرور';

  @override
  String get changePassOldRequired => 'أدخل كلمة المرور القديمة أولًا.';

  @override
  String get changePassSuccess => 'تم تغيير كلمة المرور بنجاح!';

  @override
  String get changePassFailed => 'تعذّر تغيير كلمة المرور. حاول مجددًا.';

  @override
  String get changePassConfirmHint => 'أعد كتابة كلمة المرور الجديدة للتأكيد.';

  @override
  String get changePassConfirmMatch => 'التأكيد مطابق لكلمة المرور الجديدة.';

  @override
  String get changePassConfirmMismatch =>
      'التأكيد لا يطابق كلمة المرور الجديدة بعد.';

  @override
  String get changePassSaving => 'جارٍ الحفظ…';

  @override
  String get changePassSave => 'حفظ كلمة المرور';

  @override
  String get joinClassTitle => 'الانضمام إلى صف معلمك';

  @override
  String get joinClassSubtitle =>
      'أدخل رمز الصف المكوّن من 6 أحرف الذي شاركه معلمك.';

  @override
  String get joinClassClearCode => 'مسح الرمز';

  @override
  String get joinClassExample => 'مثال: K7M-8Q2 أو 4NB-9XT';

  @override
  String get joinClassNotFound => 'رمز الصف غير موجود.';

  @override
  String joinClassSuccess(String name) {
    return 'تم الانضمام إلى $name بنجاح!';
  }

  @override
  String get joinClassCtaButton => 'انضم إلى الصف الآن';

  @override
  String get joinClassFoundBadge => 'تم العثور على الصف';

  @override
  String joinClassMemberCount(int count) {
    return '$count زميلًا';
  }

  @override
  String get classServerUnreachable =>
      'تعذّر الوصول إلى الخادم. تحقق من اتصال المختبر ثم حاول مرة أخرى.';

  @override
  String get classServerUnreachableShort =>
      'تعذّر الوصول إلى الخادم. حاول مرة أخرى بعد قليل.';

  @override
  String classJoinedSnack(String name) {
    return 'تم الانضمام إلى صف $name بنجاح!';
  }

  @override
  String classLeftSnack(String name) {
    return 'لقد غادرت صف $name.';
  }

  @override
  String get classSectionTitle => 'صفوف التعلّم';

  @override
  String get classSeeAll => 'عرض الكل';

  @override
  String get classLoadFailedFromServer => 'فشل تحميل الصفوف من الخادم';

  @override
  String get classLoadFailedTitle => 'فشل تحميل الصفوف';

  @override
  String get classCheckLabConnection =>
      'تحقق من اتصال مختبر مدرستك ثم حاول مرة أخرى.';

  @override
  String get classLoadingInline => 'جارٍ تحميل الصفوف…';

  @override
  String get classNotJoinedTitle => 'لم تنضم إلى صف بعد';

  @override
  String get classJoinHintInline =>
      'أدخل رمز الصف المكوّن من 6 أحرف الذي شاركه معلمك.';

  @override
  String get classJoinButton => 'الانضمام إلى صف';

  @override
  String get classNotInClassTitle => 'لم تنضم إلى صف بعد';

  @override
  String get classJoinHintShort =>
      'انضم باستخدام الرمز المكوّن من 6 أحرف من معلمك.';

  @override
  String get classJoinShort => 'انضم';

  @override
  String get classActiveBadge => 'نشط';

  @override
  String classCountBadge(int count) {
    return '$count صفوف';
  }

  @override
  String get classSeeAllTooltip => 'عرض كل الصفوف';

  @override
  String classMemberCountInline(int count) {
    return '$count زميلًا في الصف';
  }

  @override
  String get myClassesTitle => 'صفوفي';

  @override
  String myClassesActiveCount(int count) {
    return '$count صفوف نشطة';
  }

  @override
  String get myClassesSubtitle => 'الصفوف التي تتعلّم فيها';

  @override
  String get myClassesJoinAnother => 'الانضمام إلى صف آخر';

  @override
  String get myClassesEmptyTitle => 'لست منضمًا إلى أي صف بعد';

  @override
  String get myClassesEmptyBody =>
      'اطلب من معلمك رمز الصف المكوّن من 6 أحرف، ثم انضم من هنا.';

  @override
  String get classDetailLoadFailed => 'فشل تحميل تفاصيل الصف';

  @override
  String get classRegisteredBadge => 'مسجّل بنشاط';

  @override
  String get classTeacherRoleBadge => 'معلم';

  @override
  String get classTeacherAdvisor => 'معلم الصف المشرف';

  @override
  String get classClassmatesTitle => 'زملاء الصف';

  @override
  String classClassmatesCount(int count) {
    return '($count طالبًا)';
  }

  @override
  String get classNoClassmates => 'لا يوجد زملاء مسجّلون بعد.';

  @override
  String get classMonitoringNote =>
      'يمكن لمعلم هذا الصف متابعة تقدمك في البرمجة ودرجات التحديات مباشرةً في مختبر الحاسوب.';

  @override
  String get classXpSafeNote =>
      'تبقى نقاط الخبرة وتقدمك التعليمي آمنة في حسابك حتى إذا غادرت الصف.';

  @override
  String get classCopyInfo => 'نسخ معلومات الصف';

  @override
  String get classInfoCopied => 'تم نسخ المعلومات!';

  @override
  String get classLeaveButton => 'مغادرة الصف';

  @override
  String get classLeaveConfirmTitle => 'هل تريد مغادرة الصف؟';

  @override
  String get classLeaveConfirmBody =>
      'تبقى نقاط الخبرة وتقدمك التعليمي آمنة في حسابك، لكن معلمك لن يتمكن بعد الآن من متابعة تقدمك في المختبر.';

  @override
  String get classLeaveConfirmYes => 'نعم، غادر الصف';

  @override
  String get classHideNames => 'إخفاء';

  @override
  String classMoreCount(int rest) {
    return '+$rest آخرين';
  }

  @override
  String classSeeAllNames(int count) {
    return 'عرض جميع الأسماء ($count)';
  }

  @override
  String get authPassNotFilled => 'لم يُدخل بعد';

  @override
  String get authPassVeryGood => 'ممتاز جدًا!';

  @override
  String get authPassNeedsWork => 'بحاجة إلى تحسين';

  @override
  String get authPassSecurityTitle => 'أمان كلمة المرور';

  @override
  String get authPassMinLength => '8 أحرف على الأقل';

  @override
  String get authPassDigitOrSymbol => 'يحتوي على رقم أو رمز';

  @override
  String get authCheckMet => 'متحقق';

  @override
  String get authCheckNotMet => 'غير متحقق';

  @override
  String get authSchoolVerifiedBadge => 'مدرسة مسجّلة رسميًا';

  @override
  String authSchoolCodePrefix(String code) {
    return 'الرمز: $code';
  }

  @override
  String get authSchoolReadOnlyNote =>
      'بيانات هذه المدرسة للقراءة فقط وموثّقة تلقائيًا؛ لا يمكن للمدرب تغييرها.';

  @override
  String get validNameRequired => 'اكتب اسمك الكامل أولًا.';

  @override
  String get validEmailRequired => 'اكتب بريدك الإلكتروني أولًا.';

  @override
  String get validEmailFormat =>
      'صيغة البريد الإلكتروني غير صحيحة بعد. مثال: nama@smk.belajar.id';

  @override
  String validSchoolEmailDomain(String domain) {
    return 'يجب أن يستخدم البريد الإلكتروني نطاق $domain.';
  }

  @override
  String get validPasswordRequired => 'اكتب كلمة المرور أولًا.';

  @override
  String get validNewPasswordRequired => 'أنشئ كلمة مرور أولًا.';

  @override
  String get validPasswordPolicy => '8 أحرف على الأقل مع وجود رقم أو رمز.';

  @override
  String get validConfirmRequired => 'أعد كتابة كلمة المرور للتأكيد.';

  @override
  String get validPasswordMismatch => 'كلمتا المرور غير متطابقتين بعد.';

  @override
  String get authErrInvalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير متطابقين بعد. تحقق من ذلك وحاول مرة أخرى.';

  @override
  String get authErrEmailTaken =>
      'هذا البريد الإلكتروني لديه حساب بالفعل. هل تريد تسجيل الدخول؟';

  @override
  String get authErrNetwork =>
      'لا يوجد اتصال بالإنترنت بعد. حاول مرة أخرى بعد قليل.';

  @override
  String get authErrSchoolCodeNotFound =>
      'رمز المدرسة غير موجود. يرجى التواصل مع مسؤول مدرستك.';

  @override
  String get authErrWrongOldPassword =>
      'كلمة المرور القديمة غير متطابقة بعد. تحقق منها وحاول مرة أخرى.';

  @override
  String get authErrPasswordPolicy =>
      'كلمة المرور الجديدة لا تستوفي الشروط بعد (8 أحرف على الأقل مع رقم أو رمز).';

  @override
  String get authErrAvatarUpload =>
      'لم يتم رفع الصورة الشخصية. استخدم JPG أو PNG بحجم أقصى 2 ميجابايت.';

  @override
  String get authErrEmailDomain =>
      'يجب أن يستخدم البريد الإلكتروني نطاق @smk.belajar.id.';

  @override
  String get authErrInvalidInput =>
      'هناك حقل غير صحيح. تحقق منه ثم احفظ مرة أخرى.';

  @override
  String get authErrServer => 'الخادم يواجه مشكلة. حاول مرة أخرى بعد قليل.';

  @override
  String get loginWelcomeTitle => 'مرحبًا بعودتك';

  @override
  String get loginWelcomeSubtitle => 'تابع تعلّم البرمجة من حيث توقفت.';

  @override
  String get loginJustRegisteredBanner =>
      'تم إنشاء حسابك. سجّل الدخول لبدء التعلّم.';

  @override
  String get authEmailLabel => 'البريد الإلكتروني';

  @override
  String get authPasswordLabel => 'كلمة المرور';

  @override
  String get authPasswordHint => 'أدخل كلمة المرور';

  @override
  String get loginSubmit => 'سجّل الدخول الآن';

  @override
  String get loginNoAccount => 'ليس لديك حساب؟';

  @override
  String get authRegisterLink => 'إنشاء حساب';

  @override
  String get authBackTooltip => 'رجوع';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerTagBanner => 'منصة تعلّم البرمجة RPL';

  @override
  String get registerHeading => 'لننشئ حسابك';

  @override
  String get registerSubheading => 'لطلاب SMK/SMA تخصص RPL.';

  @override
  String get registerNameLabel => 'الاسم الكامل';

  @override
  String get registerNameHintAside => 'كما في قائمة حضور الصف';

  @override
  String get registerEmailLabel => 'البريد الدراسي / الشخصي';

  @override
  String get registerEmailHintAside => '.belajar.id';

  @override
  String get authPasswordStrengthHint => 'مزيج كلمة مرور قوي';

  @override
  String get registerConfirmLabel => 'تأكيد كلمة المرور';

  @override
  String get authSameExactlyHintAside => 'مطابقة تمامًا';

  @override
  String get authRetypePasswordHint => 'أعد كتابة كلمة المرور';

  @override
  String get registerSubmit => 'إنشاء الحساب';

  @override
  String get authAlreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get authLoginLink => 'تسجيل الدخول';

  @override
  String get registerTeacherLink =>
      'هل أنت معلم / مدرب؟ سجّل حساب معلم من هنا ←';

  @override
  String get registerSuccessTitle => 'تم التسجيل بنجاح! 🎉';

  @override
  String get registerSuccessBody =>
      'تم إنشاء حسابك وأصبح جاهزًا للاستخدام.\n\nسجّل الدخول باستخدام البريد الإلكتروني وكلمة المرور اللذين أنشأتهما للتو.';

  @override
  String get registerCommunityPrefix => 'انضم إلى';

  @override
  String get registerCommunitySuffix =>
      'من أقران RPL الذين بدأوا تعلّم منطق الخوارزميات وGit وتطوير الويب اليوم.';

  @override
  String get teacherRegTitle => 'تسجيل حساب معلم';

  @override
  String get teacherRegTagBanner => 'شراكة المؤسسات';

  @override
  String get teacherRegHeading => 'اختر دور حسابك';

  @override
  String get teacherRegSubheading =>
      'خصّص تجربة التعلّم أو إدارة مختبر الحاسوب في مدرستك.';

  @override
  String get teacherRegVerifySectionTitle => 'توثيق المدرسة والمختبر';

  @override
  String get teacherRegStatusConnected => 'متصل';

  @override
  String get teacherRegStatusWaiting => 'بانتظار الرمز';

  @override
  String get teacherRegSchoolCodeLabel => 'رمز تسجيل المدرسة / المختبر';

  @override
  String get teacherRegSchoolCodeHintAside => 'من الإدارة/المدرسة';

  @override
  String get teacherRegSchoolCodeHint => 'مثال: SWADHIPA2-NTR';

  @override
  String get teacherRegSchoolCodeInvalid =>
      'أدخل رمز المدرسة الرسمي حتى تظهر البطاقة الخضراء.';

  @override
  String get teacherRegVerifyFirst =>
      'وثّق مدرستك أولًا — أدخل الرمز الرسمي وانتظر ظهور البطاقة الخضراء.';

  @override
  String get teacherRegSchoolCodeNote =>
      'على المعلم إدخال رمز المدرسة الرسمي للارتباط بمختبر المدرسة.';

  @override
  String get teacherRegDataSectionTitle => 'بيانات المعلم المسجّل';

  @override
  String get teacherRegDataSectionNote =>
      'أكمل هوية المعلم للتحقق من شهادة المختبر.';

  @override
  String get teacherRegNameLabel => 'الاسم الكامل واللقب';

  @override
  String get teacherRegNameHintAside => 'مثال: Budi Santoso, S.Kom';

  @override
  String get teacherRegEmailLabel => 'بريد المعلم / المؤسسة';

  @override
  String get teacherRegEmailHintAside => 'بريد العمل';

  @override
  String get teacherRegSubmit => 'متابعة تسجيل الحساب';

  @override
  String teacherRegSuccessBody(String school) {
    return 'تم إنشاء حساب المعلم الخاص بك لمدرسة $school.\n\nسجّل الدخول باستخدام البريد الإلكتروني وكلمة المرور اللذين أنشأتهما للتو.';
  }

  @override
  String get teacherRegYourSchool => 'مدرستك';

  @override
  String get roleStudentChip => 'تعلّم ذاتي';

  @override
  String get roleStudentTitle => 'طالب';

  @override
  String get roleStudentDesc =>
      'الوصول إلى وحدات برمجة عملية ومعلم ذكاء اصطناعي على مدار الساعة';

  @override
  String get roleTeacherChip => 'وصول المعلمين';

  @override
  String get roleTeacherTitle => 'معلم / مدرب';

  @override
  String get roleTeacherDesc => 'إدارة مختبرات الصف والمناهج ومتابعة الطلاب';

  @override
  String get actionCopy => 'نسخ';

  @override
  String get codeCopied => 'تم نسخ الكود.';

  @override
  String get a11yShowPassword => 'إظهار كلمة المرور';

  @override
  String get a11yHidePassword => 'إخفاء كلمة المرور';

  @override
  String get a11yOpenProfile => 'فتح الملف الشخصي';

  @override
  String a11yMasteryRadar(String detail) {
    return 'رادار الإتقان: $detail';
  }

  @override
  String loadingTipSubmitQuota(String run, String submit) {
    return 'اضغط \"$run\" أولًا قبل \"$submit\" — للحفاظ على حصتك اليومية.';
  }

  @override
  String get loadingTipAiHint =>
      'مساعدة الذكاء الاصطناعي تقدم تلميحات فقط، لا كودًا جاهزًا. الإجابة تبقى من عملك.';

  @override
  String get loadingTipPlayground =>
      'يشغّل Playground لغة Python على جهازك مباشرة — يظل يعمل حتى دون اتصال.';

  @override
  String get loadingTipHiddenTests =>
      'تبقى حالات الاختبار السرية على الخادم ولا تُرسل إلى هواتف الطلاب.';

  @override
  String get loadingVersionFooter => 'الإصدار 2.1 · منهج ميرديكا RPL';

  @override
  String get bootTitle => 'جارٍ استعادة جلستك…';

  @override
  String get bootSubtitle => 'جارٍ تجهيز مختبر البرمجة على جهازك';

  @override
  String get bootStageSecureStorage => 'جارٍ التحقق من التخزين الآمن';

  @override
  String get classResponseUnrecognized => 'تنسيق استجابة الفصل غير معروف.';

  @override
  String get slideTapToFillSuccessTitle => 'صحيح تمامًا!';

  @override
  String get slideTapToFillSuccessMsg => 'لقد رتبت الصياغة بشكل صحيح.';

  @override
  String get slideTapToFillErrorTitle => 'تحقق مجددًا!';

  @override
  String get slideTapToFillErrorMsg => 'انتبه إلى الفراغات.';

  @override
  String get slideTypeCodeSuccessTitle => 'مذهل!';

  @override
  String get slideTypeCodeSuccessMsg => 'الأمر الذي كتبته صحيح.';

  @override
  String get slideTypeCodeErrorTitle => 'ليس تمامًا!';

  @override
  String get slideTypeCodeErrorMsg => 'انتبه إلى الحروف.';

  @override
  String get slideOutputPredictSuccessTitle => 'إصابة موفقة!';

  @override
  String get slideOutputPredictSuccessMsg => 'توقعك المنطقي دقيق.';

  @override
  String get slideOutputPredictErrorTitle => 'ليس تمامًا!';

  @override
  String get slideOutputPredictErrorMsg => 'تتبع سير التنفيذ سطرًا سطرًا.';

  @override
  String get slideBugHunterSuccessTitle => 'رائع، تم العثور على الخطأ!';

  @override
  String get slideBugHunterSuccessMsg => 'لقد اكتشفت السطر المعطل.';

  @override
  String get slideBugHunterErrorTitle => 'ليس هذا السطر!';

  @override
  String get slideBugHunterErrorMsg =>
      'ابحث عن السطر الذي يخالف قواعد الصياغة.';

  @override
  String get slideQuizSuccessTitle => 'إجابة مثالية!';

  @override
  String get slideQuizSuccessMsg => 'فهمك للمفهوم راسخ.';

  @override
  String get slideQuizErrorTitle => 'ليس تمامًا!';

  @override
  String get slideQuizErrorMsg => 'حاول تذكر المبدأ الأساسي لهذه المادة.';

  @override
  String get slideContentUnavailable => 'المادة غير متوفرة حاليًا.';

  @override
  String get tutorHintTabConcept => 'تلميح 1: المفهوم';

  @override
  String get tutorHintTabLogic => 'تلميح 2: المنطق';

  @override
  String get tutorHintTabStructure => 'تلميح 3: البنية';

  @override
  String get tutorHintDefaultConcept => 'تدريب البرمجة';

  @override
  String get tutorHintPlaygroundConcept => 'تدريب مستقل (Playground)';

  @override
  String get tutorHintChallengeQ1 =>
      'ما المخرجات المطلوبة في هذه المسألة؟ صفها بكلماتك الخاصة قبل لمس الكود.';

  @override
  String get tutorHintChallengeQ1Step1 =>
      'اذكر المدخلات المتاحة والمخرجات التي يجب أن تظهر.';

  @override
  String get tutorHintChallengeQ1Step2 =>
      'حدد أجزاء الكود التي فهمتها والأجزاء التي ما زلت مترددًا بشأنها.';

  @override
  String get tutorHintChallengeQ2 =>
      'ما ترتيب خطوات برنامجك من السطر الأول إلى الأخير؟';

  @override
  String get tutorHintChallengeQ2Step1 =>
      'اكتب الخطوات بلغة يومية أولًا، وليس بالكود بعد.';

  @override
  String get tutorHintChallengeQ2Step2 =>
      'تحقق مما إذا كانت كل خطوة تؤدي فعلًا إلى المخرجات المطلوبة في المسألة.';

  @override
  String get tutorHintChallengeQ3 => 'أي سطر يسبب الخطأ غالبًا عند التشغيل؟';

  @override
  String get tutorHintChallengeQ3Step1 =>
      'اقرأ رسالة الخطأ من السطر العلوي: اسم الخطأ ورقمه.';

  @override
  String get tutorHintChallengeQ3Step2 =>
      'طابق علامات الترقيم في ذلك السطر (الأقواس، والنقطتان، وعلامات الاقتباس، والمسافة البادئة).';

  @override
  String get tutorHintPlaygroundQ1 =>
      'ما المشكلة التي تريد أن يحلها هذا البرنامج أكثر؟ اكتب هدفها في جملة واحدة أولًا.';

  @override
  String get tutorHintPlaygroundQ1Step1 =>
      'خطط لذلك: ما المدخلات، وما العملية، وما المخرجات المتوقعة.';

  @override
  String get tutorHintPlaygroundQ1Step2 =>
      'ابدأ بأصغر جزء يمكنك اختباره بنفسك.';

  @override
  String get tutorHintPlaygroundQ2 =>
      'ما ترتيب خطوات برنامجك من السطر الأول إلى الأخير؟';

  @override
  String get tutorHintPlaygroundQ2Step1 =>
      'اكتب التدفق كشبه كود بلغتك الخاصة قبل نسخه إلى بايثون.';

  @override
  String get tutorHintPlaygroundQ2Step2 =>
      'حدد الأجزاء المتكررة (loop) والأجزاء المتفرعة (if).';

  @override
  String get tutorHintPlaygroundQ3 => 'أي جزء من كودك يبدو مربكًا عند القراءة؟';

  @override
  String get tutorHintPlaygroundQ3Step1 =>
      'تحقق من المسافة البادئة والنقطتين في سطور المنطق.';

  @override
  String get tutorHintPlaygroundQ3Step2 =>
      'اختبر الجزء الصغير في نفس الطرفية قبل دمجه مجددًا.';

  @override
  String get tNavDashboard => 'لوحة التحكم';

  @override
  String get tNavMaterials => 'المواد';

  @override
  String get tNavAnalytics => 'التحليلات';

  @override
  String get tPickerTitle => 'تحليل الفصول';

  @override
  String get tPickerHeading => 'اختر فصلًا';

  @override
  String get tPickerSubtitle =>
      'اختر فصلًا لعرض ترتيب المواد والتمارين للطلاب، ثم إدارة أعضائه.';

  @override
  String get tPickerEmptyTitle => 'لا توجد فصول بعد';

  @override
  String get tPickerEmptyBody =>
      'أنشئ فصلك الأول من لوحة التحكم لبدء مراقبة تحليلات الطلاب.';

  @override
  String get tPickerOpenDashboard => 'فتح لوحة التحكم';

  @override
  String get tPickerSchoolUnset => 'المدرسة غير محددة';

  @override
  String tPickerMemberCount(int count) {
    return '$count طالبًا';
  }

  @override
  String get tArchivedTitle => 'الفصول المؤرشفة';

  @override
  String get tArchivedInfo =>
      'لا يمكن للطلاب الجدد الانضمام إلى الفصول المؤرشفة. استعد فصلًا إذا أردت تفعيله مجددًا.';

  @override
  String get tArchivedLoadFailed => 'تعذر تحميل الأرشيف';

  @override
  String get tArchivedEmptyTitle => 'لا توجد فصول مؤرشفة بعد';

  @override
  String get tArchivedEmptyBody =>
      'الفصول التي تؤرشفها من صفحة التحليلات ستظهر هنا.';

  @override
  String get tArchivedBackDashboard => 'العودة إلى لوحة التحكم';

  @override
  String get tArchivedBadge => 'مؤرشف';

  @override
  String tArchivedSchoolYear(String school, String year) {
    return '$school • العام الدراسي $year';
  }

  @override
  String get tArchivedClassCode => 'رمز الفصل';

  @override
  String get tArchivedInactive => 'غير نشط';

  @override
  String get tArchivedRestore => 'استعادة الفصل';

  @override
  String get tDashFilterTitle => 'تصفية قائمة الفصول';

  @override
  String get tDashFilterSubtitle =>
      'يتم تصفية البحث والعام الدراسي من بيانات الفصول المحملة.';

  @override
  String get tDashSearchHint => 'ابحث عن اسم الفصل أو رمزه';

  @override
  String get tDashClearSearch => 'مسح البحث';

  @override
  String get tDashYearLabel => 'العام الدراسي';

  @override
  String get tDashApplyFilter => 'تطبيق التصفية';

  @override
  String get tDashFilterReset => 'إعادة تعيين';

  @override
  String tDashCodeCopied(String code) {
    return 'تم نسخ رمز الفصل \"$code\" إلى الحافظة!';
  }

  @override
  String get tDashCodeFullscreen => 'رمز الفصل (ملء الشاشة)';

  @override
  String get tDashProjectorHint => 'افتح تطبيق CodeLab AI وأدخل رمز الفصل:';

  @override
  String get tDashProjectorCopy => 'نسخ الرمز';

  @override
  String get tDashCreateNewClass => 'إنشاء فصل جديد';

  @override
  String get tDashCreateSubtitle =>
      'حاوية هوية الفصل لمراقبة تقدم تعلم الطلاب.';

  @override
  String get tDashFieldName => 'اسم الفصل *';

  @override
  String get tDashExampleName => 'مثال: X RPL 1';

  @override
  String get tDashFieldYear => 'العام الدراسي *';

  @override
  String tDashExampleYear(String year) {
    return 'مثال: $year';
  }

  @override
  String get tDashCreateClass => 'إنشاء فصل';

  @override
  String get tDashValidationRequired => 'اسم الفصل والعام الدراسي مطلوبان.';

  @override
  String get tDashSchoolUnset => 'المدرسة غير مرتبطة';

  @override
  String tDashGreeting(String name) {
    return 'مرحبًا، $name 👋';
  }

  @override
  String get tDashGreetingFallback => 'معلم';

  @override
  String get tProfileTitle => 'ملف المعلم';

  @override
  String get tDashBadgeTotal => 'المجموع';

  @override
  String tDashClassCount(int count) {
    return '$count فصلًا';
  }

  @override
  String get tDashActiveClasses => 'فصول نشطة';

  @override
  String get tDashBadgeRegistered => 'مسجل';

  @override
  String get tDashRegisteredStudents => 'طلاب مسجلون';

  @override
  String get tDashClassListTitle => 'قائمة الفصول';

  @override
  String get tDashClassListSubtitle =>
      'اختر فصلًا لمراقبة التقدم أو مشاركة الرمز.';

  @override
  String get tDashFilterTooltip => 'تصفية قائمة الفصول';

  @override
  String get tDashArchive => 'الأرشيف';

  @override
  String tDashSearchChip(String query) {
    return 'بحث: $query';
  }

  @override
  String get tDashResetFilter => 'إعادة تعيين التصفية';

  @override
  String get tDashEmptyBody =>
      'أنشئ فصلك الأول للحصول على رمز الفصل وبدء مراقبة تقدم تعلم الطلاب.';

  @override
  String get tDashNoMatchTitle => 'لا توجد فصول مطابقة';

  @override
  String get tDashNoMatchBody =>
      'جرّب كلمة مفتاحية أخرى أو اعرض جميع الأعوام الدراسية.';

  @override
  String get tDashShowAll => 'عرض جميع الفصول';

  @override
  String tDashActiveYear(String year) {
    return 'نشط $year';
  }

  @override
  String get tDashMetaMembers => 'الأعضاء';

  @override
  String get tDashProjector => 'عارض الرمز';

  @override
  String get tDashMonitor => 'مراقبة الفصل';

  @override
  String get tProfileLogoutTitle => 'تسجيل الخروج من حساب المعلم؟';

  @override
  String get tProfileLogoutBody =>
      'ستحتاج إلى إدخال بريدك الإلكتروني وكلمة المرور مجددًا لتسجيل الدخول إلى حساب المعلم هذا.';

  @override
  String get tProfileLogoutConfirm => 'نعم، تسجيل الخروج';

  @override
  String get tProfileNameFallback => 'معلم RPL';

  @override
  String get tProfileSettingsTooltip => 'إعدادات الملف';

  @override
  String get tProfileRoleChip => 'مدرب RPL';

  @override
  String tProfileNip(String code) {
    return 'NIP: $code';
  }

  @override
  String get tProfileAddBio => 'إضافة سيرة';

  @override
  String get tProfileStatClasses => 'فصول تُدرَّس';

  @override
  String get tProfileStatStudents => 'طلاب يُوجَّهون';

  @override
  String get tProfileStatMaterials => 'مواد تعليمية';

  @override
  String get tProfileClassesTitle => 'الفصول التي تُدرَّس';

  @override
  String get tProfileNoClasses => 'لم يتم إنشاء أي فصل بعد.';

  @override
  String tProfileClassMeta(String year, int count) {
    return 'العام $year • $count طالبًا';
  }

  @override
  String get tProfileNoMaterials => 'لم يتم إنشاء أي مادة بعد.';

  @override
  String tProfileMaterialCount(int count) {
    return '$count مادةً';
  }

  @override
  String tProfileMaterialMeta(String topic, int babs, int xp) {
    return '$topic • $babs فصلًا • $xp XP';
  }

  @override
  String get tProfilePublished => 'منشور';

  @override
  String get tProfileDraft => 'مسودة';

  @override
  String get tProfileOpenSettings => 'فتح إعدادات الحساب';

  @override
  String get tProfileLogout => 'تسجيل الخروج';

  @override
  String get tStudioActionHint => 'اختر إجراءً لهذه المادة';

  @override
  String get tStudioEditSyllabus => 'تحرير المنهج والفصول';

  @override
  String get tStudioEditInfo => 'تحرير معلومات المادة';

  @override
  String get tStudioDuplicate => 'نسخ كمسودة جديدة';

  @override
  String get tStudioUnpublish => 'إعادة إلى المسودة';

  @override
  String get tStudioPublish => 'النشر للطلاب';

  @override
  String get tStudioDeleteForever => 'حذف المادة نهائيًا';

  @override
  String get tStudioDeleteTitle => 'حذف هذه المادة؟';

  @override
  String tStudioDeleteBody(String title) {
    return 'سيتم حذف المادة \"$title\" من الاستوديو. يبقى سجل تعلم الطلاب المكتمل محفوظًا.';
  }

  @override
  String get tStudioTitle => 'استوديو المواد';

  @override
  String get tStudioSettingsTooltip => 'إعدادات المعلم';

  @override
  String get tStudioMyMaterials => 'موادي';

  @override
  String get tStudioSubtitle => 'إدارة وحدات التعلم وفصول البرمجة';

  @override
  String get tStudioAdd => 'إضافة مادة';

  @override
  String get tStudioBannerTitle => 'حالة تعلم الفصل';

  @override
  String tStudioBanner(int published, int students, String school) {
    return '$published مادة نشطة منشورة لـ $students طالبًا في $school.';
  }

  @override
  String get tStudioYourSchool => 'مدرستك';

  @override
  String tStudioFilterAll(int count) {
    return 'الكل ($count)';
  }

  @override
  String tStudioFilterDraft(int count) {
    return 'مسودة ($count)';
  }

  @override
  String tStudioFilterPublished(int count) {
    return 'منشور ($count)';
  }

  @override
  String get tStudioEmptyTitle => 'لا توجد مواد بعد';

  @override
  String get tStudioEmptyDraftTitle => 'لا توجد مواد مسودة';

  @override
  String get tStudioEmptyPublishedTitle => 'لا توجد مواد منشورة';

  @override
  String get tStudioEmptyBody =>
      'ابدأ ببناء منهج برمجة لطلابك. اضغط زر إضافة مادة أعلاه.';

  @override
  String get tStudioEmptyFilterBody =>
      'غيّر التصفية أو أضف مادة جديدة لهذه الفئة.';

  @override
  String get tStudioCreateNew => 'إنشاء مادة جديدة';

  @override
  String tStudioBabCount(int count) {
    return '$count فصلًا';
  }

  @override
  String get tStudioNotVisible => 'غير ظاهرة للطلاب بعد';

  @override
  String get tBabDeleteTitle => 'حذف هذا الفصل؟';

  @override
  String tBabDeleteBody(String title) {
    return 'سيتم حذف الفصل \"$title\" من قائمة المواد. يبقى سجل تعلم الطلاب المسجل محفوظًا.';
  }

  @override
  String get tBabDuplicateTitle => 'نسخ هذا الفصل؟';

  @override
  String tBabDuplicateBody(String title) {
    return 'ستظهر نسخة من \"$title\" كرقم الفصل التالي، كاملة مع جميع شرائحها ونقاط XP الخاصة بها.';
  }

  @override
  String get tBabDuplicate => 'نسخ';

  @override
  String get tBabTitle => 'المنهج والفصول';

  @override
  String get tBabAdd => 'إضافة فصل';

  @override
  String get tBabTopicFallback => 'استوديو المواد';

  @override
  String get tBabTitleFallback => 'قائمة الفصول';

  @override
  String get tBabCurriculumStatus => 'حالة منهج الفصول';

  @override
  String tBabMeta(int babs, int xp) {
    return '$babs فصلًا • $xp XP';
  }

  @override
  String get tBabPublishedHint =>
      'جميع الفصول النشطة مقروءة من الطلاب في فصلك.';

  @override
  String get tBabDraftHint =>
      'المادة في حالة مسودة. لا يمكن للطلاب رؤية هذه الفصول بعد.';

  @override
  String get tBabListTitle => 'قائمة فصول منظمة';

  @override
  String get tBabFlowOrder => 'ترتيب مسار التعلم';

  @override
  String get tBabEmptyTitle => 'لا توجد فصول بعد';

  @override
  String get tBabEmptyBody =>
      'هذه المادة ليس لها فصول تعلم بعد. أضف الفصل الأول لبدء ترتيب شرائح الاختبار والنظرية.';

  @override
  String get tBabAddFirst => 'إضافة الفصل الأول';

  @override
  String tBabRowMeta(int slides, int xp) {
    return '$slides شريحةً • $xp XP';
  }

  @override
  String get tBabMoveUp => 'نقل لأعلى';

  @override
  String get tBabMoveDown => 'نقل لأسفل';

  @override
  String get tBabPreviewTooltip => 'محاكي الطالب (معاينة)';

  @override
  String get tBabActionTooltip => 'إجراءات الفصل';

  @override
  String get tBabEdit => 'تحرير الفصل';

  @override
  String get tBabDuplicateMenu => 'نسخ الفصل';

  @override
  String get tBabDeleteMenu => 'حذف الفصل';

  @override
  String get tFormLevelDescBeginner =>
      'مستوى أساسي: للطلاب الذين يتعرفون للتو على منطق البرمجة.';

  @override
  String get tFormLevelDescIntermediate =>
      'مستوى متوسط: تفرعات متقدمة، وتكرار، ومعالجة بيانات.';

  @override
  String get tFormLevelDescAdvanced =>
      'مستوى متقدم: خوارزميات تكرارية معقدة وتحسين حل المشكلات.';

  @override
  String get tFormNotFound =>
      'المادة غير موجودة. عد إلى استوديو المواد لاختيار مادة أخرى.';

  @override
  String get tFormTitleRequired => 'اسم المادة مطلوب.';

  @override
  String get tFormTitleDuplicate =>
      'اسم المادة مستخدم بالفعل. استخدم اسمًا آخر حتى لا يرتبك الطلاب.';

  @override
  String get tFormUpdated => 'تم تحديث المادة بنجاح.';

  @override
  String get tFormSavedDraft => 'تم حفظ المادة كمسودة.';

  @override
  String get tFormSaveFailed =>
      'لم يتم حفظ المادة بعد. تحقق من الاتصال وحاول مجددًا.';

  @override
  String get tFormUnsavedTitle => 'تغييرات غير محفوظة';

  @override
  String get tFormUnsavedBody =>
      'نموذج المادة هذا به مراجعات. احفظ التغييرات كمسودة أولًا، أم تتجاهلها؟';

  @override
  String get tFormSaveExit => 'حفظ المسودة والخروج';

  @override
  String get tFormDiscard => 'تجاهل التغييرات';

  @override
  String get tFormKeepEditing => 'متابعة التحرير';

  @override
  String get tFormEdit => 'تحرير المادة';

  @override
  String get tFormLoadFailed => 'تعذر تحميل المادة';

  @override
  String get tFormOpenStudio => 'فتح استوديو المواد';

  @override
  String get tFormAdd => 'إضافة مادة جديدة';

  @override
  String get tFormModeEdit => 'وضع التحرير';

  @override
  String get tFormNewBadge => 'مادة جديدة';

  @override
  String get tFormEditHeading => 'تغيير إعدادات المادة';

  @override
  String get tFormAddHeading => 'تكوين مادة جديدة';

  @override
  String get tFormSubtitle =>
      'كوّن العنوان، ومسار المنهج، ومستوى الصعوبة لعرضها على الطلاب.';

  @override
  String get tFormFieldName => 'اسم المادة *';

  @override
  String get tFormExampleName => 'مثال: أساسيات الخوارزميات وبايثون RPL';

  @override
  String get tFormFieldDesc => 'وصف مختصر *';

  @override
  String get tFormDescHint => 'اشرح مخرجات المادة في 2-3 جمل موجزة...';

  @override
  String get tFormFieldIcon => 'رمز أيقونة المادة *';

  @override
  String get tFormIconHint =>
      'اختر إعدادًا مسبقًا للأيقونة أو اكتب اسم رمز الأيقونة (مثل: terminal, html, css, javascript, database, psychology, shield, phone_android).';

  @override
  String get tFormExampleIcon => 'مثال: terminal';

  @override
  String get tFormFieldTopic => 'الموضوع / مسار المنهج *';

  @override
  String get tFormFieldLevel => 'مستوى الصعوبة *';

  @override
  String get tFormDraftNotice =>
      'تُحفظ المواد الجديدة كمسودة. لا تظهر المادة للطلاب إلا بعد ضغط زر \"نشر\".';

  @override
  String get tFormSaveDraft => 'حفظ المسودة';

  @override
  String get tFormContinueBabs => 'متابعة إلى الفصول';

  @override
  String get tSlideNotFound =>
      'الشريحة غير موجودة. افتح منشئ الفصول لاختيار شريحة أخرى.';

  @override
  String tSlideTemplateApplied(String label) {
    return 'تم تطبيق القالب الأولي \"$label\".';
  }

  @override
  String get tSlideBabUnsaved =>
      'الفصل الجديد غير محفوظ بعد. أضف شرائح من منشئ الفصول لتحفظ مع الفصل.';

  @override
  String get tSlideSaveNoBab =>
      'تعذر حفظ الشريحة. افتح منشئ الفصول لإعادة تحميل الفصل.';

  @override
  String get tSlideSaveFailed => 'فشل حفظ الشريحة. حاول مجددًا.';

  @override
  String get tSlideSaved => 'تم حفظ الشريحة في الفصل.';

  @override
  String get tSlideEditorTitle => 'محرر الشرائح';

  @override
  String get tSlideLoadFailedTitle => 'تعذر تحميل الشريحة';

  @override
  String get tSlideOpenBabBuilder => 'فتح منشئ الفصول';

  @override
  String get tSlidePreviewTooltip => 'معاينة الشريحة';

  @override
  String tSlideHeader(int index, String label) {
    return 'شريحة $index • $label';
  }

  @override
  String get tSlidePreviewAsStudent => 'معاينة كطالب';

  @override
  String get tSlideUseTemplate => 'استخدام القالب الأولي';

  @override
  String get tSlideSave => 'حفظ الشريحة';

  @override
  String tSlideTooLong(String label, int max) {
    return '$label طويل جدًا (الحد الأقصى $max حرفًا).';
  }

  @override
  String tSlideRequired(String label) {
    return '$label مطلوب.';
  }

  @override
  String tSlideMaxItems(String label, int limit) {
    return '$label يسمح بحد أقصى $limit عنصر.';
  }

  @override
  String tSlideChoiceEmpty(String letter, String label) {
    return 'الخيار $letter في $label ما زال فارغًا.';
  }

  @override
  String tSlideChoiceKey(String label) {
    return 'اختر مفتاح إجابة واحد A–D في $label.';
  }

  @override
  String tSlideSlotEmpty(int n) {
    return 'مفتاح إجابة الفراغ $n ما زال فارغًا.';
  }

  @override
  String get tSlideTapMarkerMissing =>
      'رمز السؤال ليس به علامة [KETIK_DISINI] كمكان لكتابة الطلاب.';

  @override
  String get tSlideBugHintOrFix =>
      'املأ \"رسالة المؤشر\" أو \"رمز الإصلاح الصالح\" ليحصل الطلاب على شرح بعد الإجابة.';

  @override
  String get tSlideConceptRequired => 'املأ مفهومًا متقنًا واحدًا على الأقل.';

  @override
  String get tSlideTemplateNoSlot =>
      'قالب الكود ليس به فراغ بعد. حدد الأجزاء الفارغة بـ ___1___، ___2___، وهكذا.';

  @override
  String get tSlideDistractorRequired =>
      'أضف مشتتًا واحدًا على الأقل حتى يمكن الإجابة على السؤال.';

  @override
  String get tSlideDistractorsSame =>
      'جميع المشتتات تطابق مفتاح الإجابة. أضف خيارًا آخر.';

  @override
  String get tSlideTargetNotNumber => 'يجب أن يكون رقم السطر المستهدف رقمًا.';

  @override
  String tSlideTargetRange(int n) {
    return 'يجب أن يكون رقم السطر المستهدف بين 1 و $n مطابقًا لعدد سطور الكود.';
  }

  @override
  String get tSlideFieldExerciseTitle => 'عنوان التمرين';

  @override
  String get tSlideFieldInstruction => 'تعليمات';

  @override
  String get tSlideFieldQuestionTitle => 'عنوان السؤال';

  @override
  String get tSlideFieldQuestionCode => 'رمز السؤال';

  @override
  String get tSlideFieldAnswerKeyword => 'الكلمة المفتاحية للإجابة';

  @override
  String get tSlideFieldHint => 'تلميح';

  @override
  String get tSlideFieldSlideTitle => 'عنوان الشريحة';

  @override
  String get tSlideFieldCodeBlock => 'كتلة الكود';

  @override
  String get tSlideFieldOutputChoices => 'خيارات المخرجات';

  @override
  String get tSlideFieldExplanation => 'شرح';

  @override
  String get tSlideFieldChallengeTitle => 'عنوان التحدي';

  @override
  String get tSlideFieldScenario => 'سيناريو';

  @override
  String get tSlideFieldProgramCode => 'رمز البرنامج';

  @override
  String get tSlideFieldErrorType => 'نوع الخطأ';

  @override
  String get tSlideFieldBugHint => 'رسالة المؤشر';

  @override
  String get tSlideFieldFixCode => 'رمز الإصلاح';

  @override
  String get tSlideFieldQuizQuestion => 'سؤال الاختبار';

  @override
  String get tSlideFieldAnswerChoices => 'خيارات الإجابة';

  @override
  String get tSlideFieldFeedback => 'ملاحظات';

  @override
  String get tSlideFieldOutroTitle => 'عنوان شريحة الختام';

  @override
  String get tSlideFieldSummary => 'ملخص المادة';

  @override
  String get tSlideFieldMasteredConcepts => 'مفاهيم متقنة';

  @override
  String get tSlideFieldTheoryTitle => 'عنوان المادة النظرية';

  @override
  String get tSlideFieldTheoryContent => 'محتوى الشرح';

  @override
  String get tSlideFieldSampleCode => 'مقتطف كود نموذجي';

  @override
  String get tSlideFieldCodeLanguage => 'لغة الكود';

  @override
  String get tSlideFieldCodeTemplate => 'قالب الكود';

  @override
  String get tSlideFieldAnswerKey => 'مفتاح الإجابة';

  @override
  String get tSlideFieldSlotAnswer => 'مفتاح إجابة الفراغ';

  @override
  String get tSlideFieldDistractors => 'مشتتات';

  @override
  String get tSlideFieldTargetLine => 'رقم السطر المستهدف';

  @override
  String get tBabNotFound =>
      'الفصل غير موجود. افتح قائمة الفصول لاختيار فصل آخر.';

  @override
  String get tBabSlideEmptyHint =>
      'لا يوجد محتوى بعد. اضغط تحرير محتوى الشريحة للبدء.';

  @override
  String get tBabMinSlides => 'يجب أن يحتوي الفصل على شريحة واحدة على الأقل.';

  @override
  String get tBabTitleRequired => 'اسم الفصل مطلوب.';

  @override
  String get tBabUpdated => 'تم تحديث الفصل بنجاح.';

  @override
  String get tBabCreated => 'تمت إضافة فصل جديد بنجاح.';

  @override
  String get tBabMinSlidesPreview =>
      'يحتاج الفصل إلى شريحة واحدة على الأقل للمحاكاة.';

  @override
  String get tBabPreviewFallback => 'معاينة الفصل';

  @override
  String get tBabEditTitle => 'تحرير الفصل';

  @override
  String get tBabLoadFailedTitle => 'تعذر تحميل الفصل';

  @override
  String get tBabOpenList => 'فتح قائمة الفصول';

  @override
  String get tBabBuilderTitle => 'منشئ الفصول';

  @override
  String get tBabFieldName => 'اسم الفصل *';

  @override
  String get tBabExampleName => 'مثال: مقدمة إلى وسوم HTML والمستندات';

  @override
  String get tBabXpTitle => 'نقاط XP لمكافأة الفصل';

  @override
  String get tBabXpHint => 'تُمنح عند إتمام الطالب للفصل';

  @override
  String get tBabFlowTitle => 'تدفق الشرائح';

  @override
  String tBabSlideCount(int count) {
    return '$count وحدة';
  }

  @override
  String get tBabAddSlide => 'إضافة شريحة';

  @override
  String get tBabDeleteSlide => 'حذف الشريحة';

  @override
  String get tBabEditSlideContent => 'تحرير محتوى الشريحة';

  @override
  String get tBabSaveChanges => 'حفظ تغييرات الفصل';

  @override
  String get tBabSaveNew => 'حفظ فصل جديد';

  @override
  String get tBabPickerTitle => 'اختيار نوع شريحة جديد';

  @override
  String tBabFormatCount(int count) {
    return '$count تنسيقات';
  }

  @override
  String get tBabPickerHint =>
      'اضغط أيقونة العين لرؤية معاينة محاكاة برمجة، أو اختر مباشرة للإضافة إلى تدفق الفصل.';

  @override
  String get tBabPreviewFormatTooltip => 'معاينة التنسيق التفاعلي';

  @override
  String get tBabPickerAddTooltip => 'إضافة شريحة';

  @override
  String get tBabBentoTitle => 'اختيار نوع الشريحة / تمرين البرمجة';

  @override
  String get tBabBentoHint =>
      'اضغط \"معاينة\" لمحاكاة برمجة الطالب، أو اضغط \"استخدام\" للإدراج في تدفق الفصل.';

  @override
  String get tBabPreviewButton => 'معاينة';

  @override
  String get tBabUseButton => 'استخدام';

  @override
  String get tBabTypeTheoryName => 'النظرية والمفاهيم';

  @override
  String get tBabTypeTapName => 'إكمال الكود';

  @override
  String get tBabTypeTypeName => 'كتابة الكلمات المفتاحية';

  @override
  String get tBabTypeOutputName => 'تخمين المخرجات';

  @override
  String get tBabTypeBugName => 'صائد الأخطاء';

  @override
  String get tBabTypeQuizName => 'اختبار اختيار من متعدد';

  @override
  String get tBabTypeOutroName => 'ملخص والمطالبة بـ XP';

  @override
  String get tBabTypeTheoryBadge => 'مادة قراءة';

  @override
  String get tBabTypeTapBadge => 'تفاعلي';

  @override
  String get tBabTypeTypeBadge => 'صياغة';

  @override
  String get tBabTypeOutputBadge => 'منطق';

  @override
  String get tBabTypeBugBadge => 'تصحيح الأخطاء';

  @override
  String get tBabTypeQuizBadge => 'تقييم';

  @override
  String get tBabTypeOutroBadge => 'إنجاز';

  @override
  String get tBabSheetDescTheory => 'نص شرح المفاهيم وأمثلة كود مرئية.';

  @override
  String get tBabSheetDescTap => 'ينقر الطلاب على قطع الكتل لإكمال سطر كود.';

  @override
  String get tBabSheetDescType =>
      'تدريب كتابة الكلمات المفتاحية أو تعبيرات الصياغة.';

  @override
  String get tBabSheetDescOutput =>
      'يحلل الطلاب مقتطفًا ويتوقعون مخرجات الطرفية.';

  @override
  String get tBabSheetDescBug => 'تحدي إصلاح أخطاء الكتابة أو منطق البرمجة.';

  @override
  String get tBabSheetDescQuiz => 'أسئلة تقييم الفهم مع 4 خيارات.';

  @override
  String get tBabSheetDescOutro =>
      'شريحة ختام الفصل مع ملخص الإنجاز والمكافآت.';

  @override
  String get tBabBentoDescTheory =>
      'نص قراءة منظم، وشرح بصيغة markdown، وأمثلة كود.';

  @override
  String get tBabBentoDescTap => 'ملء الفراغات برموز قطع كود موجهة.';

  @override
  String get tBabBentoDescType =>
      'تدريب ذاكرة عضلية لكتابة كلمات مفتاحية نحوية محددة.';

  @override
  String get tBabBentoDescOutput => 'تحليل سطور الكود وتوقع مخرجات الطرفية.';

  @override
  String get tBabBentoDescBug => 'إيجاد سطر الكود المعطل وتحديد إصلاحه.';

  @override
  String get tBabBentoDescQuiz => 'أسئلة مفاهيمية مع 4 خيارات ونقاش.';

  @override
  String get pyErrStringUnclosed => 'SyntaxError: السلسلة النصية غير مغلقة';

  @override
  String pyErrFStringCloseBrace(String brace) {
    return 'SyntaxError: f-string: علامة $brace غير موجودة';
  }

  @override
  String get pyErrFStringEmptyExpr => 'SyntaxError: f-string: تعبير فارغ';

  @override
  String pyErrFStringStrayBrace(String brace) {
    return 'SyntaxError: f-string: علامة $brace خارج العنصر النائب';
  }

  @override
  String get pyErrFStringUnclosed => 'SyntaxError: f-string غير مغلقة';

  @override
  String get pyErrTimeoutSeconds =>
      'RuntimeError: توقف البرنامج (تجاوز حد 5 ثوانٍ)';

  @override
  String get pyErrStepLimit =>
      'RuntimeError: توقف البرنامج — تجاوز 100,000 خطوة (تحقق من وجود حلقة لا نهائية)';

  @override
  String get pyErrBreakOutsideLoop => 'SyntaxError: \"break\" خارج الحلقة';

  @override
  String get pyErrContinueOutsideLoop =>
      'SyntaxError: \"continue\" خارج الحلقة';

  @override
  String get pyErrReturnOutsideFunction =>
      'SyntaxError: \'return\' خارج الدالة';

  @override
  String get pyErrElifWithoutIf =>
      'SyntaxError: invalid syntax (elif/else بدون if)';

  @override
  String pyErrInvalidParam(String param) {
    return 'SyntaxError: معامل غير صالح -> $param';
  }

  @override
  String get pyErrInputNeedsDialog =>
      'RuntimeError: input() تحتاج إلى مربع حوار — شغّل من صفحة Playground';

  @override
  String get pyErrSumNeedsList => 'TypeError: sum() تتطلب قائمة كوسيط أول';

  @override
  String pyErrUnknownOperator(String op) {
    return 'TypeError: العامل \'$op\' غير معروف';
  }

  @override
  String tAnalyticsCodeCopied(String code) {
    return 'تم نسخ رمز الفصل \"$code\" إلى الحافظة!';
  }

  @override
  String get tAnalyticsRemoveTitle => 'إزالة الطالب';

  @override
  String tAnalyticsRemoveBody(String name, String className) {
    return 'إزالة $name من $className؟\n\nلن يظهر الطالب بعد الآن في قائمة الفصل وترتيبه. يمكنه الانضمام مجددًا باستخدام رمز الفصل.';
  }

  @override
  String get tAnalyticsThisClass => 'هذا الفصل';

  @override
  String get tAnalyticsRemoveConfirm => 'إزالة';

  @override
  String tAnalyticsClassOptions(String name) {
    return 'خيارات الفصل: $name';
  }

  @override
  String get tAnalyticsRegenerateCode => 'إعادة إنشاء رمز الفصل';

  @override
  String get tAnalyticsRegenerateCodeSub => 'إنشاء رمز فصل جديد.';

  @override
  String get tAnalyticsArchiveClass => 'أرشفة الفصل';

  @override
  String get tAnalyticsArchiveClassSub =>
      'لن يتمكن الطلاب من الانضمام بعد الآن.';

  @override
  String tAnalyticsHintMaterialSuffix(String title) {
    return ' الذي أكمل \"$title\"';
  }

  @override
  String tAnalyticsHintCompleted(String suffix) {
    return 'المواد المكتملة = الطلاب الذين أكملوا مادة واحدة على الأقل$suffix، مرتبين حسب أكثر المواد المكتملة.';
  }

  @override
  String get tAnalyticsPracticeRegular => 'تدريب عادي (وليس مشروعًا مصغرًا)';

  @override
  String get tAnalyticsPracticeMini => 'مشروع مصغر';

  @override
  String get tAnalyticsPracticeAny => 'أي تدريب (عادي + مشروع مصغر)';

  @override
  String tAnalyticsHintPractice(String type, String suffix) {
    return 'أكثر التدريبات = الطلاب الذين اجتازوا $type واحدًا على الأقل$suffix، مرتبين حسب أكثر التدريبات المجتازة.';
  }

  @override
  String get tAnalyticsNotStartedMaterial => 'لم يكملوا أي مادة';

  @override
  String get tAnalyticsNotStartedPractice => 'لم ينهوا أي تدريب';

  @override
  String get tAnalyticsNotStartedBoth => 'لم يكملوا المواد ولم ينهوا التدريبات';

  @override
  String tAnalyticsHintNotStarted(String scope, String suffix) {
    return 'لم يبدأوا = الطلاب الذين $scope$suffix، مرتبين حسب الأكثر نشاطًا في التدريب.';
  }

  @override
  String tAnalyticsHintAll(String suffix) {
    return 'الكل = جميع أعضاء الفصل$suffix، مرتبين حسب أكثر المواد المكتملة ثم التدريبات المجتازة.';
  }

  @override
  String get tAnalyticsFilterByMaterial => 'تصفية قائمة الطلاب حسب المادة';

  @override
  String get tAnalyticsFilterByMaterialHint =>
      'الرقم على كل زر = الطلاب الذين أكملوا تلك المادة.';

  @override
  String tAnalyticsFilterAllMaterials(int count) {
    return 'كل المواد ($count)';
  }

  @override
  String tAnalyticsFilterMaterialCount(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get tAnalyticsTrackBasisTitle => 'أساس درجة تقدم المسار';

  @override
  String get tAnalyticsTrackBasisBody =>
      'النسبة المئوية لكل مسار = متوسط progress_percent لجميع طلاب الفصل عبر جميع المواد الرسمية (المنهج المدمج) في ذلك المسار.\n\n• كل زوج طالب × مادة يُحسب صفًا واحدًا، بما في ذلك المواد التي لم تُفتح أبدًا (تُحسب 0%).\n• 100% تعني أن جميع طلاب الفصل أكملوا كل المواد في ذلك المسار.\n• المواد التي ينشئها المعلم لا تُحسب (المنهج الرسمي فقط).\n• هذا الرقم يقيس إكمال المواد، وليس درجات التدريب.';

  @override
  String get tAnalyticsGotIt => 'فهمت';

  @override
  String get tAnalyticsNoStudents => 'لا يوجد طلاب بعد.';

  @override
  String get tAnalyticsTitle => 'تحليلات الفصل';

  @override
  String get tAnalyticsClassOptionsLabel => 'خيارات الفصل';

  @override
  String get tAnalyticsLoading => 'جارٍ تحميل بيانات تحليلات الفصل...';

  @override
  String get tAnalyticsEmptyBody =>
      'أنشئ فصلك الأول في لوحة التحكم لمراقبة تحليلات المنهج وتقدم تعلم الطلاب.';

  @override
  String get tAnalyticsLabClass => 'فصل المختبر';

  @override
  String tAnalyticsAcademicYear(String year) {
    return 'العام الدراسي $year';
  }

  @override
  String get tAnalyticsClassCode => 'رمز الفصل';

  @override
  String get tAnalyticsReadyJoin => 'جاهز للانضمام';

  @override
  String get tAnalyticsShareCodeHint =>
      'شارك هذا الرمز ليتمكن الطلاب من الانضمام إلى الفصل:';

  @override
  String get tAnalyticsEnlarge => 'تكبير ↗';

  @override
  String get tAnalyticsTrackTitle => 'تقدم المنهج لكل مسار';

  @override
  String get tAnalyticsTrackTooltip =>
      'متوسط تقدم جميع طلاب الفصل عبر جميع المواد الرسمية في هذا المسار (المواد غير المفتوحة = 0%).';

  @override
  String get tAnalyticsTrackSubtitle =>
      'متوسط إكمال جميع طلاب الفصل عبر جميع المواد الرسمية في ذلك المسار.';

  @override
  String get tAnalyticsTrackEmpty =>
      'ستُملأ بيانات المسار تلقائيًا بمجرد أن يبدأ الطلاب التعلم.';

  @override
  String get tAnalyticsHardestTitle => 'أصعب الفصول (تحتاج إلى إرشاد)';

  @override
  String get tAnalyticsHardestEmpty =>
      'لم يتم اكتشاف تحديات صعبة في هذا الفصل 🎉';

  @override
  String tAnalyticsFailCount(int count) {
    return '$count طالبًا أخفقوا';
  }

  @override
  String get tAnalyticsRankingTitle => 'ترتيب طلاب الفصل';

  @override
  String tAnalyticsRankingTop(int top, int total) {
    return 'أفضل $top من $total';
  }

  @override
  String tAnalyticsStudentCount(int count) {
    return '$count طالبًا';
  }

  @override
  String tAnalyticsRankingHint(int max) {
    return 'يعرض الترتيب $max طالبًا كحد أقصى بأكثر المواد/التدريبات. ويظل جميع الطلاب ظاهرين بالكامل في قسم قائمة الطلاب.';
  }

  @override
  String get tAnalyticsRankMaterial => 'المواد';

  @override
  String get tAnalyticsRankMaterialSub => 'المواد المكتملة';

  @override
  String get tAnalyticsRankPractice => 'التدريب';

  @override
  String get tAnalyticsRankPracticeSub => 'التحديات المجتازة';

  @override
  String get tAnalyticsRosterTitle => 'قائمة الطلاب';

  @override
  String tAnalyticsFilterAllCount(int count) {
    return 'الكل ($count)';
  }

  @override
  String tAnalyticsFilterCompletedCount(int count) {
    return 'المواد المكتملة ($count)';
  }

  @override
  String get tAnalyticsFilterPractice => 'أكثر التدريبات';

  @override
  String tAnalyticsFilterNotStartedCount(int count) {
    return 'لم يبدأوا ($count)';
  }

  @override
  String get tAnalyticsPracticeAll => 'كل التدريبات';

  @override
  String get tAnalyticsPracticeRegularLabel => 'تدريب عادي';

  @override
  String get tAnalyticsNotStartedAll => 'المواد والتدريبات';

  @override
  String get tAnalyticsNotStartedMaterialLabel => 'لم تُنجز المواد';

  @override
  String get tAnalyticsNotStartedPracticeLabel => 'لم تُنهَ التدريبات';

  @override
  String get tAnalyticsRosterEmpty => 'لم ينضم أي طالب إلى هذا الفصل بعد.';

  @override
  String get tAnalyticsRosterFilterEmpty => 'لا يوجد طلاب في فئة التصفية هذه.';

  @override
  String tAnalyticsRowPracticeDetail(int materials, int regular, int mini) {
    return '$materials مادة مكتملة • $regular تدريب عادي • $mini مشروع مصغر';
  }

  @override
  String tAnalyticsRowDetail(int materials, int practice) {
    return '$materials مادة مكتملة • $practice تدريب مجتاز';
  }

  @override
  String tAnalyticsXp(int xp) {
    return '$xp XP';
  }

  @override
  String get tAnalyticsRemoveFromClass => 'إزالة من الفصل';

  @override
  String get tSlideFormHelpTheoryTitle =>
      'يظهر العنوان في أعلى شاشة الطالب.\n- اجعله موجزًا ومحددًا، بحد أقصى 120 حرفًا.\n- اذكر المفهوم الأساسي، وليس اسم الفصل.';

  @override
  String get tSlideFormHelpTheoryContent =>
      'كيفية كتابة محتوى المادة:\n- افصل الفقرات بسطر فارغ واحد.\n- الأسطر التي تبدأ بـ \"- \" أو \"* \" تصبح عناصر قائمة تلقائيًا.\n- عدا ذلك يُعرض النص كما هو: **عريض**، # عناوين، روابط، و`كود` لا تُنسق.\n\nمثال:\nHTML لغة ترميز لبناء صفحات الويب.\n\n- تُفتح الوسوم ثم تُغلق.\n- تتصل السمات بوسم الفتح.';

  @override
  String get tSlideFormHelpCodeFileSample =>
      'يحدد فقط اسم الملف على بطاقة الكود:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py';

  @override
  String get tSlideFormHelpSampleCode =>
      'كود نموذجي يظهر في مربع الكود أسفل الشرح.\n- اتركه فارغًا إذا لم تكن الشريحة بحاجة إلى كود نموذجي.\n- اكتب الكود الخام فقط، دون علامات كتل ماركداون.\n- بحد أقصى 8000 حرف.';

  @override
  String get tSlideFormHelpExerciseTitle =>
      'يظهر العنوان في رأس التمرين، بحد أقصى 120 حرفًا.\nمثال: \"أكمل وسم إغلاق HTML\".';

  @override
  String get tSlideFormHelpShortInstruction =>
      'جملة أو جملتان إرشاديتان قبل أن ينقر الطالب على خانة.\n- اشرح أي جزء يجب إكماله.\n- لا تذكر الإجابة هنا.';

  @override
  String get tSlideFormHelpCodeTemplate =>
      'الصق الكود هنا، ثم حدد الفراغات بـ ___1___، ___2___، وهكذا.\n- تُعرف العلامات طالما تستخدم شرطتين سفليتين على الأقل في البداية والنهاية، مع رقم اختياري في المنتصف.\n- ترتيب الخانات يتبع ترتيب ظهورها في الكود.\n- الخانة الواحدة تعني إجابة واحدة؛ لا تضع خانتين لنفس الإجابة.\n\nمثال:\nx = ___1___\nprint(x)';

  @override
  String get tSlideFormHelpSlotAnswers =>
      'املأ الإجابة الصحيحة لكل خانة حسب ترتيب الظهور.\n- تُتجاهل المسافات في البداية/النهاية، لكن حالة الأحرف مهمة: اكتب \"print\" وليس \"Print\".\n- اكتب بالضبط ما يجب أن يظهر في الكود.\n- عدد الإدخالات يتبع عدد الخانات المكتشفة.';

  @override
  String get tSlideFormHelpDistractors =>
      'كلمات إضافية تظهر كخيارات، لكنها ليست الإجابة الصحيحة.\n- افصل بينها بفواصل.\n- المشتتات المطابقة للمفتاح تُحذف تلقائيًا.\n- أبقِ واحدًا على الأقل حتى يضطر الطلاب فعلًا للاختيار.';

  @override
  String get tSlideFormHelpCodeFile =>
      'يحدد اسم الملف على بطاقة الكود:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py';

  @override
  String get tSlideFormHelpQuestionTitle =>
      'يظهر العنوان في رأس التمرين، بحد أقصى 120 حرفًا.\nمثال: \"إعلان متغير بايثون\".';

  @override
  String get tSlideFormHelpInteractiveInstruction =>
      'إرشادات موجزة يقرأها الطلاب قبل الكتابة.\n- اذكر ما يجب البحث عنه دون إعطاء الإجابة.\n- بحد أقصى 300 حرف.';

  @override
  String get tSlideFormHelpQuestionCode =>
      'اكتب مقتطف كود، ثم استبدل الجزء المراد ملؤه بـ [KETIK_DISINI].\n- تتحول تلك العلامة إلى مربع إدخال على شاشة الطالب.\n- يُسمح بأكثر من علامة واحدة في الشريحة الواحدة.\n- بدون علامة، لا يوجد لدى الطلاب مكان لكتابة إجابة.';

  @override
  String get tSlideFormHelpAnswerKeyword =>
      'الإجابة المعتبرة صحيحة.\n- المقارنة تتجاهل المسافات في البداية/النهاية وحالة الأحرف، لذا \"Print\" تساوي \"print\".\n- أدخل كلمة مفتاحية واحدة أو تعبيرًا قصيرًا فقط.';

  @override
  String get tSlideFormHelpWrongHint =>
      'مساعدة تظهر عندما تكون إجابة الطالب خاطئة.\n- قدم تلميحات توجيهية، ولا تكتب الإجابة مباشرة.\n- جملة أو جملتان تكفيان.';

  @override
  String get tSlideFormHelpSlideTitle =>
      'يظهر العنوان في رأس الشريحة، بحد أقصى 120 حرفًا.\nمثال: \"خمّن ناتج عامل باقي القسمة\".';

  @override
  String get tSlideFormHelpChallengeInstruction =>
      'سؤال قصير فوق كتلة الكود.\nعادة يكفي: \"ما الناتج المطبوع في الطرفية؟\".';

  @override
  String get tSlideFormHelpSourceCode =>
      'كود يقرأه الطلاب لتخمين الناتج.\n- اكتبه بالضبط مثل البرنامج الأصلي.\n- الكود يُعرض فقط ولا يُنفذ، لذا يجب أن يكون الناتج قابلًا للتخمين من محتوى الكود.';

  @override
  String get tSlideFormHelpOutputChoices =>
      'املأ الخيارات الأربعة (من A إلى D).\n- انقر الدائرة على اليسار لتحديد مفتاح الإجابة.\n- يجب أن يطابق أحد الخيارات الناتج الفعلي تمامًا.\n- لا تترك خيارات فارغة: الخيارات الفارغة تظل ظاهرة على شاشة الطالب.';

  @override
  String get tSlideFormHelpOutputExplanation =>
      'يظهر بعد أن يجيب الطلاب، سواء صح أم خطأ.\nاشرح سبب ظهور ذلك الناتج، مثل ترتيب العمليات أو أنواع البيانات المعنية.';

  @override
  String get tSlideFormHelpChallengeTitle =>
      'يظهر العنوان في رأس التحدي، بحد أقصى 120 حرفًا.\nمثال: \"العثور على خطأ حلقة For\".';

  @override
  String get tSlideFormHelpScenario =>
      'سياق موجز للمشكلة التي يواجهها الطلاب؛ يظهر كتعليمات فوق الكود.\nصِف الموقف، ولا تذكر رقم السطر الخاطئ.';

  @override
  String get tSlideFormHelpBuggyCode =>
      'الكود الكامل الذي يحتوي على الخطأ.\n- تُحسب أرقام الأسطر من 1 حسب ترتيب الأسطر في هذا المربع، بما في ذلك الأسطر الفارغة.\n- أدخل خطأ يمكن شرحه فعلًا بـ \"نوع الخطأ\" و\"كود الإصلاح\".';

  @override
  String get tSlideFormHelpTargetLine =>
      'رقم السطر الصحيح، محسوبًا من 1.\n- يجب أن يكون بين 1 وعدد أسطر الكود أعلاه.\n- إذا كان خارج النطاق، تقفل شاشة الطالب على أقرب سطر فلا تتطابق الإجابات أبدًا.';

  @override
  String get tSlideFormHelpErrorType =>
      'تسمية فئة الخطأ المعروضة للطلاب.\nمثال: SyntaxError, IndentationError, NameError.';

  @override
  String get tSlideFormHelpBugHint =>
      'يصبح هذا النص الشرح الذي يظهر بعد أن يجيب الطلاب.\n- اشرح القاعدة المنتهكة في ذلك السطر.\n- إذا تُرك فارغًا، يُستخدم \"كود الإصلاح الصالح\" كشرح.';

  @override
  String get tSlideFormHelpFixCode =>
      'مقتطف الإصلاح الصحيح للسطر المحدد.\n- يُستخدم كمثال حل وشرح احتياطي عندما تكون \"رسالة المؤشر\" فارغة.\n- اكتب الجزء المُصلح فقط، وليس البرنامج كله.';

  @override
  String get tSlideFormHelpQuizTitle =>
      'يظهر العنوان في رأس الاختبار، بحد أقصى 120 حرفًا.\nمثال: \"فهم أنواع البيانات\".';

  @override
  String get tSlideFormHelpQuizQuestion =>
      'سؤال بإجابة صحيحة واحدة.\n- اسأل عن مفهوم واحد فقط، ولا تدمج.\n- بحد أقصى 300 حرف.';

  @override
  String get tSlideFormHelpAnswerChoices =>
      'املأ الخيارات الأربعة (من A إلى D).\n- انقر الدائرة على اليسار لتحديد مفتاح الإجابة.\n- لا تترك خيارات فارغة لأنها تظل ظاهرة كخيارات فارغة على شاشة الطالب.';

  @override
  String get tSlideFormHelpFeedback =>
      'يظهر بعد أن يجيب الطلاب، سواء صح أم خطأ.\nاشرح لماذا مفتاح الإجابة صحيح، وعند الحاجة لماذا المشتتات خاطئة.';

  @override
  String get tSlideFormHelpOutroTitle =>
      'يظهر العنوان في رأس شريحة الختام، بحد أقصى 120 حرفًا.\nمثال: \"ملخص الفصل\".';

  @override
  String get tSlideFormHelpSummary =>
      'ملخص يقرأه الطلاب في نهاية الفصل.\n- أعد ذكر المفاهيم الرئيسية التي تعلموها للتو.\n- قدم خاتمة محفزة، وليس سؤالًا جديدًا.';

  @override
  String get tSlideFormHelpMasteredConcepts =>
      'قائمة المفاهيم المعتبرة متقنة بعد هذا الفصل.\n- افصل بينها بفواصل، مثل: المتغيرات، التكرار.\n- يظهر كل مفهوم كتسمية إنجاز.\n- أدخل مفهومًا واحدًا على الأقل.';

  @override
  String get tSlideFormHintTheoryTitleExample =>
      'مثال: البنية الأساسية لمستند HTML5';

  @override
  String get tSlideFormHintTheoryContent =>
      'اكتب المفاهيم الرئيسية أو النقاط أو الأمثلة...';

  @override
  String get tSlideFormHintExerciseTitleExample => 'مثال: أكمل وسم إغلاق HTML';

  @override
  String get tSlideFormHintShortInstruction => 'تعليمات العمل للطلاب...';

  @override
  String get tSlideFormHintQuestionTitleExample => 'مثال: إعلان متغير بايثون';

  @override
  String get tSlideFormHintInteractiveInstruction =>
      'اكتب الكلمة المفتاحية لإعلان متغير...';

  @override
  String get tSlideFormHintAnswerKeywordExample => 'مثال: def / const / let';

  @override
  String get tSlideFormHintWrongHint => 'تذكر الكتابة بأحرف صغيرة كلها.';

  @override
  String get tSlideFormHintSlideTitleExample =>
      'مثال: خمّن ناتج عامل باقي القسمة';

  @override
  String get tSlideFormHintChallengeInstruction =>
      'ما الناتج المطبوع في الطرفية؟';

  @override
  String get tSlideFormHintOutputExplanation => 'لماذا يظهر ذلك الناتج؟';

  @override
  String get tSlideFormHintChallengeTitleExample =>
      'مثال: العثور على خطأ حلقة For';

  @override
  String get tSlideFormHintScenario => 'صِف سياق المشكلة...';

  @override
  String get tSlideFormHintTargetLineExample => 'مثال: 2';

  @override
  String get tSlideFormHintBugHint => 'نقص النقطتين (:) في نهاية جملة for';

  @override
  String get tSlideFormHintQuizTitleExample => 'مثال: فهم أنواع البيانات';

  @override
  String get tSlideFormHintQuizQuestion => 'اكتب سؤالًا مفاهيميًا...';

  @override
  String get tSlideFormHintFeedback => 'لماذا ذلك الخيار صحيح؟';

  @override
  String get tSlideFormHintOutroTitleExample => 'مثال: ملخص الفصل';

  @override
  String get tSlideFormHintSummary => 'ملخص إنجازات الطلاب بعد إكمال الفصل...';

  @override
  String get tSlideFormHintMasteredConcepts => 'المتغيرات، التفرع، التكرار';

  @override
  String tSlideFormSlotAnswerCount(int count) {
    return 'مفتاح الإجابة لكل خانة (تم اكتشاف $count خانة)';
  }

  @override
  String tSlideFormSlot(int n) {
    return 'خانة $n';
  }

  @override
  String tSlideFormSlotAnswerHint(int n) {
    return 'الإجابة الصحيحة للخانة $n';
  }

  @override
  String get tSlideFormNoSlotsHint =>
      'أضف علامات ___1___، ___2___، وهكذا إلى القالب.';

  @override
  String tSlideFormXpNote(int xp) {
    return 'يطالب الطلاب تلقائيًا بـ $xp XP عند الوصول إلى هذه الشريحة.';
  }

  @override
  String get tPreviewInteractiveFormat => 'معاينة التنسيق التفاعلي';

  @override
  String tPreviewSheetTitle(String title) {
    return 'معاينة نوع الشريحة: $title';
  }

  @override
  String get tPreviewBenefits => 'الفوائد التربوية';

  @override
  String get tPreviewReward => 'مكافأة الطالب';

  @override
  String get tPreviewModuleType => 'نوع الوحدة';

  @override
  String get tPreviewUseType => 'استخدم هذا النوع';

  @override
  String get tPreviewSimulation => 'محاكاة الطالب النشط';

  @override
  String get tPreviewPhoneScreen => 'شاشة الهاتف';

  @override
  String get tPreviewAnswerChoices => 'خيارات الإجابة للطلاب:';

  @override
  String get tPreviewSubtitleTapToFill =>
      'محاكاة لكيفية تفاعل الطلاب مع هذا التمرين مباشرة على هواتفهم.';

  @override
  String get tPreviewTechTapToFill => 'HTML • V1.2';

  @override
  String get tPreviewPromptTapToFill => 'أكمل وسم الإغلاق الصحيح: السطر 4';

  @override
  String get tPreviewFeedbackTapToFill =>
      'يحصل الطلاب على تغذية راجعة فورية عند اختيار مقاطع الكود.';

  @override
  String get tPreviewBenefitTapToFill =>
      'يدرّب على إتقان الصياغة الأساسية دون عبء الكتابة الطويلة على لوحة مفاتيح شاشة الهاتف.';

  @override
  String get tPreviewSubtitleTheory =>
      'نص قراءة منظم، وماركداون تفسيري، ومقاطع كود نموذجية.';

  @override
  String get tPreviewTechTheory => 'Markdown • النظرية';

  @override
  String get tPreviewPromptTheory => 'المادة الافتتاحية ومقدمة المنطق';

  @override
  String get tPreviewFeedbackTheory =>
      'يدعم تنسيق ماركداون، وتمييز الصياغة، ومربعات تنبيه نصائح المعلم.';

  @override
  String get tPreviewBenefitTheory =>
      'يبني أساسًا قويًا للفهم المفاهيمي قبل دخول الطلاب إلى جلسات التدريب التفاعلية.';

  @override
  String get tPreviewSubtitleTypeCode =>
      'تدريب الذاكرة العضلية على كتابة الكلمات المفتاحية النحوية المحددة.';

  @override
  String get tPreviewTechTypeCode => 'Python • الصياغة';

  @override
  String get tPreviewPromptTypeCode =>
      'اكتب الكلمة المفتاحية لإنشاء دالة في بايثون:';

  @override
  String get tPreviewFeedbackTypeCode =>
      'مزود بالتحقق الحساس لحالة الأحرف وتلميحات تلقائية عند خطأ الطلاب.';

  @override
  String get tPreviewBenefitTypeCode =>
      'يعوّد الطلاب على كتابة الصياغة بدقة ويدرّب على الدقة في كتابة الكلمات المحجوزة.';

  @override
  String get tPreviewSubtitleOutputPredict =>
      'يحلّل الطلاب أسطر البرنامج ويتوقعون ناتج تشغيل الطرفية.';

  @override
  String get tPreviewTechOutputPredict => 'Console • المنطق';

  @override
  String get tPreviewPromptOutputPredict =>
      'ما الناتج المطبوع من عملية باقي القسمة التالية؟';

  @override
  String get tPreviewFeedbackOutputPredict =>
      'خيارات بأسلوب طرفية داكنة لمحاكاة واقعية.';

  @override
  String get tPreviewBenefitOutputPredict =>
      'يدرّب على تنفيذ الخوارزميات ذهنيًا وتتبع المتغيرات دون الاعتماد على المصحّح.';

  @override
  String get tPreviewTitleBugHunter => 'صائد الأخطاء (اعثر على الخطأ)';

  @override
  String get tPreviewSubtitleBugHunter =>
      'تحدٍّ للعثور على سطر الكود المعطّل وإصلاحه.';

  @override
  String get tPreviewTechBugHunter => 'Python • تصحيح الأخطاء';

  @override
  String get tPreviewPromptBugHunter =>
      'اعثر على السطر الذي يحتوي على خطأ نحوي:';

  @override
  String get tPreviewFeedbackBugHunter =>
      'ينقر الطلاب على رقم السطر المشكل لتفعيل إرشاد الذكاء الاصطناعي.';

  @override
  String get tPreviewBenefitBugHunter =>
      'يصقل حدس حل المشكلات والقدرة على قراءة كود الآخرين، وهي المهارة الأساسية للمطوّر.';

  @override
  String get tPreviewSubtitleQuiz =>
      'أسئلة تقييم الفهم بأربعة خيارات مع الشرح.';

  @override
  String get tPreviewTechQuiz => 'التقييم • المفاهيم';

  @override
  String get tPreviewPromptQuiz =>
      'ما الوظيفة الرئيسية لإعلان <!DOCTYPE html>؟';

  @override
  String get tPreviewFeedbackQuiz => 'مزود بشرح تلقائي يظهر بعد إجابة الطلاب.';

  @override
  String get tPreviewBenefitQuiz =>
      'يقيس استيعاب المادة بموضوعية وسرعة في نهاية جلسة الشرح.';

  @override
  String get tPreviewSubtitleOutro =>
      'شريحة ختام الفصل مع ملخص المواد المتقنة والمطالبة بالمكافآت.';

  @override
  String get tPreviewTechOutro => 'الإنجاز • الختام';

  @override
  String get tPreviewPromptOutro => 'تهانينا! لقد أكملت جميع تمارين هذا الفصل.';

  @override
  String get tPreviewFeedbackOutro =>
      'يُنشأ تلقائيًا في نهاية مسار تعلّم الفصل.';

  @override
  String get tPreviewBenefitOutro =>
      'يمنح رضا الإنجاز (التلعيب) ويلخّص النقاط الأساسية للمادة.';

  @override
  String get tSettingsAvatarTooBig => 'يجب ألا يتجاوز حجم الصورة 2 ميجابايت.';

  @override
  String get tSettingsFallbackTeacher => 'معلم';

  @override
  String tSettingsNameDegree(String name) {
    return '$name والدرجة *';
  }

  @override
  String get tSettingsIdentityTitle => 'هوية المعلم';

  @override
  String get tSettingsBioContact => 'السيرة والتواصل';

  @override
  String get tSettingsBioHint => 'اكتب خبرتك التدريسية أو تخصصك في البرمجة...';

  @override
  String get tSettingsAddressHint => 'عنوان سكن المعلم';

  @override
  String get tSettingsSecurityTitle => 'أمان الحساب';

  @override
  String get tSettingsChangePassword => 'تغيير كلمة المرور';

  @override
  String get tFieldHelpGotIt => 'فهمت';

  @override
  String get tTeacherErrServerFallback => 'حدثت مشكلة في الخادم.';

  @override
  String get tTeacherErrInvalidLesson => 'تنسيق بيانات المادة غير صالح.';

  @override
  String get tTeacherErrInvalidBab => 'تنسيق بيانات الفصل غير صالح.';

  @override
  String get tTeacherErrInvalidClass => 'تنسيق بيانات الفصل الدراسي غير صالح.';

  @override
  String tCubitClassCreated(String name) {
    return 'تم إنشاء الفصل $name بنجاح.';
  }

  @override
  String get tCubitClassArchived => 'تم نقل الفصل إلى الأرشيف.';

  @override
  String get tCubitClassRestored => 'تمت استعادة الفصل بنجاح.';

  @override
  String tCubitClassCodeNew(String code) {
    return 'رمز الفصل الجديد: $code';
  }

  @override
  String get tCubitLessonCreated => 'تم إنشاء المادة الجديدة بنجاح.';

  @override
  String get tCubitLessonPublished => 'تم نشر المادة بنجاح.';

  @override
  String get tCubitLessonDrafted => 'تمت إعادة المادة إلى المسودة.';

  @override
  String get tCubitLessonDeleted => 'تم حذف المادة بنجاح.';

  @override
  String get tCubitLessonDuplicated => 'تم تكرار المادة بنجاح.';

  @override
  String tCubitBabDuplicated(String title) {
    return 'تم تكرار الفصل \"$title\" بنجاح.';
  }

  @override
  String get tCubitBabDeleted => 'تم حذف الفصل بنجاح.';

  @override
  String get tCubitBabOrderUpdated => 'تم تحديث ترتيب الفصول.';

  @override
  String get tCubitStudentRemoved => 'تم إخراج الطالب من الفصل.';

  @override
  String tCubitStudentRemovedNamed(String name) {
    return 'تم إخراج $name من الفصل.';
  }

  @override
  String get tCubitConnectionFailed =>
      'فشل الاتصال بالخادم. تحقق من اتصالك ثم حاول مجددًا.';

  @override
  String get tAdapterEmptyBab => 'لا يوجد شرائح في هذا الفصل بعد.';

  @override
  String get tAdapterPreviewTopic => 'معاينة المعلم';

  @override
  String get tAdapterPreviewMode => 'وضع محاكي معاينة المعلم';

  @override
  String get tAdapterTypeCodeInstruction => 'أكمل الكود التالي:';

  @override
  String get tAdapterOutputQuestion => 'ما ناتج الكود أعلاه؟';

  @override
  String get tAdapterBugInstruction => 'ابحث عن السطر الذي به مشكلة:';

  @override
  String get tAdapterBugExplanation => 'تحقق من بنية هذا السطر.';

  @override
  String get tAdapterQuizQuestion => 'سؤال الاختبار:';

  @override
  String get tAdapterOutroSummary => 'تهانينا! لقد أكملت هذا الفصل.';

  @override
  String get tAdapterLearningTime => '3 دقائق';

  @override
  String get tAdapterMainConcept => 'المفهوم الرئيسي';

  @override
  String get tTemplateLabelTapToFill => 'أكمل الكود (نقر)';

  @override
  String get tTemplateLabelTypeCode => 'اكتب الكلمات المفتاحية';

  @override
  String get tTemplateLabelOutputPredict => 'خمّن ناتج الكود';

  @override
  String get tTemplateLabelBugHunter => 'صائد الأخطاء';

  @override
  String get tTemplateLabelQuiz => 'اختبار الاختيار من متعدد';

  @override
  String get tTemplateLabelOutro => 'الملخص والمطالبة بنقاط الخبرة';

  @override
  String get tTemplateLabelTheory => 'النظرية والمفاهيم';

  @override
  String get tTemplateBadgeInteractive => 'تفاعلي';

  @override
  String get tTemplateBadgeSyntax => 'بنية';

  @override
  String get tTemplateBadgeLogic => 'منطق';

  @override
  String get tTemplateBadgeDebugging => 'تصحيح الأخطاء';

  @override
  String get tTemplateBadgeEvaluation => 'تقييم';

  @override
  String get tTemplateBadgeAchievement => 'إنجاز';

  @override
  String get tTemplateBadgeReading => 'مادة قراءة';

  @override
  String get tTemplateDescTapToFill =>
      'ينقر الطلاب على قطع الكتل لإكمال سطور الكود.';

  @override
  String get tTemplateDescTypeCode =>
      'يكتب الطلاب الكلمات المفتاحية أو تعبيرات البنية.';

  @override
  String get tTemplateDescOutputPredict =>
      'يتوقع الطلاب مخرجات الطرفية من مقتطف كود.';

  @override
  String get tTemplateDescBugHunter =>
      'يجد الطلاب السطر الذي به مشكلة وإصلاحه.';

  @override
  String get tTemplateDescQuiz => 'أسئلة اختيار من متعدد بإجابة صحيحة واحدة.';

  @override
  String get tTemplateDescOutro => 'شريحة ختامية مع ملخص ومكافآت نقاط الخبرة.';

  @override
  String get tTemplateDescTheory => 'نص شرح مفاهيم المادة وأمثلة الكود.';

  @override
  String get tTemplateTitleTapToFill => 'أكمل الكود';

  @override
  String get tTemplatePromptTapToFill =>
      'انقر على كتل الكود لإكمال السطور التالية.';

  @override
  String get tTemplatePromptTypeCode => 'اكتب الدالة لطباعة النص على الشاشة:';

  @override
  String get tTemplateHintTypeCode => 'استخدم أحرفًا صغيرة فقط.';

  @override
  String get tTemplateTitleOutputPredict => 'خمّن الناتج';

  @override
  String get tTemplatePromptOutputPredict => 'ما الناتج المطبوع على الطرفية؟';

  @override
  String get tTemplateExplanationOutputPredict =>
      'المعامل + يجمع عددين صحيحين.';

  @override
  String get tTemplateTitleBugHunter => 'اعثر على الخطأ';

  @override
  String get tTemplateScenarioBugHunter => 'يفحص الطلاب برنامجًا فشل تشغيله.';

  @override
  String get tTemplateBugHintBugHunter =>
      'تحقق من النقطتين الرأسيتين في نهاية سطر for.';

  @override
  String get tTemplateQuestionQuiz => 'أيٌّ منها نوع بيانات عدد صحيح؟';

  @override
  String get tTemplateExplanationQuiz => 'int نوع بيانات عدد صحيح.';

  @override
  String get tTemplateTitleOutro => 'ملخص الفصل';

  @override
  String get tTemplateSummaryOutro => 'رائع! لقد أكملت مادة هذا الفصل.';

  @override
  String get tTemplateTitleTheory => 'شرح مادة جديدة';

  @override
  String get tTemplateContentTheory =>
      'اكتب شرح المادة التعليمية هنا بلغة يفهمها الطلاب بسهولة.';
}
