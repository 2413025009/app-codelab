// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navLearn => 'Learn';

  @override
  String get navChallenges => 'Challenges';

  @override
  String get navPlayground => 'Playground';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionClose => 'Close';

  @override
  String get actionRetry => 'Try Again';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSend => 'Send';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAccountTag => 'ACCOUNT SETTINGS';

  @override
  String get settingsRoleTeacher => 'Teacher / Instructor';

  @override
  String get settingsRoleStudent => 'RPL Student • Beginner Level';

  @override
  String get settingsChangePhoto => 'Change Photo';

  @override
  String get settingsEditModeHint =>
      'Edit mode is on — update your data, then tap \"Save Changes\".';

  @override
  String get settingsFieldFullName => 'Full Name';

  @override
  String get settingsFieldFullNameAside => 'Max 40 characters';

  @override
  String get settingsFullNameEmpty => 'Name cannot be empty';

  @override
  String get settingsFieldNisn => 'NISN / Student ID';

  @override
  String get settingsBadgeVerifiedDapodik => 'Verified by Dapodik';

  @override
  String get settingsFieldSchool => 'School / Institution Name';

  @override
  String get settingsFieldClass => 'Class & Major';

  @override
  String get settingsFieldAddress => 'Address';

  @override
  String get settingsFieldStaffCode => 'Staff ID (NIP/NIK)';

  @override
  String get settingsFieldAffiliatedSchool => 'Affiliated School';

  @override
  String get settingsBadgeVerified => 'Verified';

  @override
  String get settingsFieldPhone => 'Phone / WhatsApp Number';

  @override
  String get settingsPhoneIncomplete =>
      'The number is incomplete. Example: 81234567890';

  @override
  String get settingsPhoneHelper =>
      'Write it without the leading 0, e.g. 81234567890';

  @override
  String get settingsFieldTeacherEmail => 'Teacher Email';

  @override
  String get settingsFieldStudentEmail => 'Student Account Email';

  @override
  String get settingsEmailAside => 'Must end with @smk.belajar.id';

  @override
  String get settingsFieldTeacherBio => 'Bio / Teacher Notes';

  @override
  String get settingsFieldStudentBio => 'Bio / Study Notes';

  @override
  String get settingsFieldBioAside => 'Max 120 characters';

  @override
  String get settingsSaveChanges => 'Save Changes';

  @override
  String get settingsCancelEdit => 'Discard Changes';

  @override
  String get settingsEditData => 'Edit Data';

  @override
  String get settingsPreferencesHeader => 'APP PREFERENCES';

  @override
  String get settingsLanguage => 'App Language';

  @override
  String get settingsLanguageSubtitle => 'Indonesian, English, or العربية';

  @override
  String get settingsDarkMode => 'Dark Mode';

  @override
  String get settingsDarkModeSubtitle =>
      'A darker theme that is easier on the eyes';

  @override
  String get settingsThemeMode => 'Appearance Theme';

  @override
  String get settingsThemeModeSubtitle =>
      'Choose light, dark, or follow your phone setting';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'Follow System';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Important updates without opening the app';

  @override
  String get settingsNotifySummaryAllOn => 'All types enabled';

  @override
  String get settingsNotifySummaryOff => 'Disabled';

  @override
  String settingsNotifySummaryPartial(int count) {
    return '$count of 5 types enabled';
  }

  @override
  String get settingsNotificationsMaster => 'Enable Notifications';

  @override
  String get settingsNotificationsMasterSubtitle =>
      'Turn off to stop receiving all notifications';

  @override
  String get settingsNotifyCertificate => 'Certificate Issued';

  @override
  String get settingsNotifyCertificateSubtitle =>
      'When a module is completed or a challenge is passed';

  @override
  String get settingsNotifyDownload => 'Certificate Download';

  @override
  String get settingsNotifyDownloadSubtitle =>
      'When the e-Certificate PDF finishes downloading';

  @override
  String get settingsNotifyReminder => 'Study Reminder';

  @override
  String get settingsNotifyReminderSubtitle =>
      'Daily reminder and AI Tutor quota reset';

  @override
  String get settingsNotifyMaterial => 'New Modules';

  @override
  String get settingsNotifyMaterialSubtitle =>
      'When a teacher publishes a new module or chapter';

  @override
  String get settingsNotifySession => 'Session Security';

  @override
  String get settingsNotifySessionSubtitle =>
      'When the account signs in on another device';

  @override
  String get settingsNotifyTest => 'Send Test Notification';

  @override
  String get settingsNotifyTestSubtitle =>
      'Make sure notifications appear on this device';

  @override
  String get settingsNotifyTestSent => 'Test notification sent.';

  @override
  String get settingsNotifyTestFailed =>
      'The notification could not be sent. Check this app\'s notification permission.';

  @override
  String get settingsNotifyPermissionDenied =>
      'Notification permission denied. Enable it in your phone settings.';

  @override
  String get notifCertificateTitle => 'Certificate of Competency Issued';

  @override
  String notifCertificateBody(String topic) {
    return '$topic is complete. Your certificate is ready to download.';
  }

  @override
  String get notifChallengeTitle => 'Challenge Certificate Issued';

  @override
  String notifChallengeBody(String title) {
    return '$title passed 100/100. Your challenge certificate is ready.';
  }

  @override
  String get notifDownloadTitle => 'Certificate Downloaded';

  @override
  String notifDownloadBody(String certId) {
    return 'The PDF $certId was saved to this device.';
  }

  @override
  String get notifReminderTitle => 'Time to Study';

  @override
  String get notifReminderBody => 'Your AI Tutor quota is back to 5/5 today.';

  @override
  String get notifMaterialTitle => 'New Module from Your Teacher';

  @override
  String notifMaterialBody(String title) {
    return '$title was just published. Open the catalog to see it.';
  }

  @override
  String get notifSessionTitle => 'Session Ended';

  @override
  String get notifSessionBody =>
      'Your account signed in on another device. Sign in again to continue.';

  @override
  String get notifTestTitle => 'Test Notification';

  @override
  String get notifTestBody => 'CodeLab AI notifications work on this device.';

  @override
  String get notifNewBadge => 'New';

  @override
  String get offlineBannerTitle =>
      'You are offline. Check your internet connection.';

  @override
  String get materialSearchContentTitle => 'Matched inside the lesson';

  @override
  String get materialSearchContentNoSnippet =>
      'This word appears inside the lesson.';

  @override
  String get settingsSfx => 'App Sound Effects';

  @override
  String get settingsSfxSubtitle => 'Popup, notification, and quiz sounds';

  @override
  String get settingsLabSfx => 'Lab Sound Effects';

  @override
  String get settingsLabSfxSubtitle =>
      'Audio while running code and the terminal';

  @override
  String get settingsAccountLabHeader => 'ACCOUNT & LAB SETTINGS';

  @override
  String get settingsHelpCenter => 'Admin Help';

  @override
  String get settingsHelpCenterSubtitle =>
      'Contact the admin via WhatsApp +62 831-2500-5309';

  @override
  String get settingsHelpLaunchFailed =>
      'Could not open WhatsApp. Please try again.';

  @override
  String get settingsChangePassword => 'Change Password';

  @override
  String get settingsChangePasswordSubtitle =>
      'Old and new password with a security checklist';

  @override
  String get settingsChangePasswordSheetSubtitle =>
      'The password rules are the same as when you signed up.';

  @override
  String get settingsLogout => 'Log Out';

  @override
  String get settingsLogoutTitle => 'Log Out of Your Account?';

  @override
  String get settingsLogoutBody =>
      'Are you sure you want to end this lab practice session?';

  @override
  String get settingsLogoutConfirm => 'Yes, Log Out';

  @override
  String get settingsAvatarDeleteTitle => 'Delete Profile Photo?';

  @override
  String get settingsAvatarDeleteBody =>
      'The photo will be removed from your account. You can upload a new one anytime.';

  @override
  String get settingsAvatarMaxSize => 'The photo must be 2 MB or smaller.';

  @override
  String get settingsAvatarUpdated => 'Profile photo updated.';

  @override
  String get settingsAvatarDeleted => 'Profile photo deleted.';

  @override
  String get settingsAvatarProcessFailed =>
      'Could not process the photo. Check the gallery permission and your connection, then try again.';

  @override
  String get settingsAvatarDeleteFailed =>
      'Could not delete the photo. Check your connection and try again.';

  @override
  String get settingsProfileSaved => 'Profile changes saved!';

  @override
  String get settingsProfileSaveFailed =>
      'Could not save your profile. Try again.';

  @override
  String get settingsLanguageSheetTitle => 'App Language';

  @override
  String get settingsLanguageSheetSubtitle =>
      'Applies to every CodeLab AI screen';

  @override
  String get languageIndonesian => 'Bahasa Indonesia';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get playgroundReset => 'Reset';

  @override
  String get playgroundRun => 'Run';

  @override
  String get playgroundRunning => 'Running…';

  @override
  String get playgroundTerminal => 'Terminal';

  @override
  String get playgroundClearTerminal => 'Clear terminal';

  @override
  String get playgroundOpenTerminal => 'Open terminal';

  @override
  String get playgroundCloseTerminal => 'Close terminal';

  @override
  String get playgroundEmptyDone => '(Program finished with no output)';

  @override
  String get playgroundEmptyIdle => 'Tap \'Run\' to see the output';

  @override
  String get playgroundInputHint => 'type your answer…';

  @override
  String playgroundStatusDone(Object ms) {
    return 'Done (${ms}ms)';
  }

  @override
  String playgroundStatusError(Object ms) {
    return 'Error (${ms}ms)';
  }

  @override
  String get sandboxTooltip => 'What can\'t you do in this sandbox?';

  @override
  String get sandboxSheetTitle => 'Python Sandbox Limits';

  @override
  String get sandboxSheetSubtitle =>
      'A note from your teacher before you start';

  @override
  String get sandboxLimitJudgeTitle =>
      'Playground runs a different judge than challenges';

  @override
  String get sandboxLimitJudgeBody =>
      'The Playground runs on your phone, while challenges are judged by the server with full Python. Code that works here may behave differently when submitted. If that happens, trust the result on the challenge page — that is the official score.';

  @override
  String get sandboxIntro =>
      'Before you start experimenting, listen to your teacher for a moment. This Python Sandbox is a deliberately limited practice space, not full Python. So you are not confused when something fails, here is what you cannot do here yet:';

  @override
  String get sandboxLimitImportTitle => 'Calling modules with import';

  @override
  String get sandboxLimitImportBody =>
      'The import command is not available in this sandbox. Libraries such as random, math, datetime, or packages from the internet cannot be used yet.';

  @override
  String get sandboxLimitFileTitle => 'Opening files and reaching outside';

  @override
  String get sandboxLimitFileBody =>
      'Opening or saving files, accessing the internet, and giving commands to the operating system are not allowed yet. Everything you write runs inside the app only.';

  @override
  String get sandboxLimitGuiTitle => 'Building graphics, images, or sound';

  @override
  String get sandboxLimitGuiBody =>
      'tkinter, pygame, and similar tools are not available. Here we practise program logic, not building windows or games that move on their own.';

  @override
  String get sandboxLimitOopTitle => 'Using class, dict, and try/except';

  @override
  String get sandboxLimitOopBody =>
      'Those three topics are not in this practice engine yet. For now, focus on variables, branching, loops, lists, and functions.';

  @override
  String get sandboxLimitLimitsTitle => 'Running programs that are too heavy';

  @override
  String get sandboxLimitLimitsBody =>
      'A program stops automatically after 100,000 steps or 5 seconds, and recursion is limited to 200 levels. If you hit this limit, check your loop again — usually one never stops.';

  @override
  String get sandboxClosing =>
      'If you get an error even though your code looks right, check first whether you are using something on the list above. If you are still stuck, ask your teacher in class — you do not have to solve it alone.';

  @override
  String get dashTitle => 'Dashboard';

  @override
  String get dashLoadingTitle => 'Preparing dashboard';

  @override
  String get dashLoadingSubtitle => 'Fetching learning data from server';

  @override
  String get dashStageConnecting => 'Connecting to server…';

  @override
  String get dashStageProfile => 'Student profile loaded';

  @override
  String get dashStageProgress => 'Chapter progress loaded';

  @override
  String get dashStageSkills => 'Skill radar loaded';

  @override
  String get dashStageLessons => 'Lesson catalog loaded';

  @override
  String get dashStageChallenges => 'Challenge records loaded';

  @override
  String get dashStageComposing => 'Assembling dashboard…';

  @override
  String dashGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get dashNoModules => 'No modules yet. Check back soon.';

  @override
  String get dashQuickTipTitle => 'Python Quick Tip';

  @override
  String get dashQuickTipSubtitle => 'Use elif for multi-condition evaluation';

  @override
  String get dashQuickTipBody =>
      'Use the elif construct to evaluate multiple conditions sequentially in a clean way:\n\nif score >= 90:\n    result = \"A\"\nelif score >= 75:\n    result = \"B\"\nelse:\n    result = \"C\"\n\nWith elif, evaluation stops as soon as the first condition is met without nested ifs.';

  @override
  String get dashQuickTipButton => 'Got it, Continue Learning!';

  @override
  String get dashErrorTitle =>
      'Something went wrong on our end. Please try again in a moment.';

  @override
  String get dashRetryButton => 'Try again';

  @override
  String dashChallengesCompleted(int count) {
    return '$count challenges completed';
  }

  @override
  String get dashModuleLocked => 'This module is still locked.';

  @override
  String get dashDefaultTopic => 'Python Basics & Logic';

  @override
  String get dashDefaultChapter => '1. Introduction to Coding Logic';

  @override
  String dashBabOf(int current, int total) {
    return 'Chapter $current of $total';
  }

  @override
  String dashPercentDone(int percent) {
    return '$percent% Complete';
  }

  @override
  String get dashCompetencyTitle => 'Your Competency';

  @override
  String get dashCompetencyEmpty =>
      'Finish one challenge, and your competency will appear here.';

  @override
  String get actionSeeDetail => 'See details';

  @override
  String get moduleStatusCompleted => 'Completed';

  @override
  String get moduleStatusActive => 'In progress';

  @override
  String get moduleStatusAvailable => 'Ready to start';

  @override
  String get moduleStatusLocked => 'Locked';

  @override
  String get roadmapTitle => 'Learning Adventure Map';

  @override
  String roadmapStopsToCertificate(int count) {
    return '$count Stops to Certificate';
  }

  @override
  String roadmapActiveBab(int step) {
    return 'Chapter $step Active';
  }

  @override
  String get roadmapCatalogTitle => 'Lesson Catalog';

  @override
  String get roadmapCatalogSubtitle => 'Browse chapters across all lessons';

  @override
  String get roadmapStartHere => 'Start here! 🚀';

  @override
  String get roadmapInProgress => 'In progress';

  @override
  String get roadmapPracticeCount => '6 Exercises';

  @override
  String roadmapBabLine(int order, String label) {
    return 'Chapter $order • $label';
  }

  @override
  String get roadmapQuizNode => 'Check your understanding';

  @override
  String get roadmapAvailableNow => 'Ready to open now';

  @override
  String get roadmapCertificate => 'Module Certificate';

  @override
  String get roadmapGraduationTarget => 'Graduation target';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get filterAll => 'All';

  @override
  String get filterTodo => 'Not Started';

  @override
  String get filterDone => 'Completed';

  @override
  String get filterMiniProject => 'Mini Project';

  @override
  String get actionApply => 'Apply';

  @override
  String get appDefaultStudentName => 'Student';

  @override
  String get challengeFilterTitle => 'Challenge Filter';

  @override
  String get challengeLevelSection => 'Difficulty level';

  @override
  String get challengeLockedTitle => 'Challenge Locked';

  @override
  String challengeLockedBody(int xp, int userXp) {
    return 'Requirement: you need at least $xp XP to unlock this challenge. You currently have $userXp XP.';
  }

  @override
  String get challengeLearningPath => 'Learning Path';

  @override
  String get challengeCatalogTitle => 'Challenge Catalog';

  @override
  String get challengeCatalogSubtitle =>
      'Sharpen your algorithm logic and coding step by step';

  @override
  String get challengeFilter => 'Filter';

  @override
  String get challengeFilterActive => 'Filter • 1';

  @override
  String challengeFilterCount(String label, int count) {
    return '$label ($count)';
  }

  @override
  String get challengeSearchHint =>
      'Search topics, functions, or algorithms...';

  @override
  String get challengeClearSearch => 'Clear search';

  @override
  String get challengeSearchTooltip => 'Search challenges';

  @override
  String get challengeNoMatch =>
      'No matching challenges. Try changing the keyword or filter.';

  @override
  String challengeGroupDone(int done, int total) {
    return '$done / $total Completed';
  }

  @override
  String challengeGroupUnlocked(int unlocked, int total) {
    return '$unlocked / $total Unlocked';
  }

  @override
  String challengeSummaryDone(int done, int total) {
    return '$done of $total Completed';
  }

  @override
  String get challengeSummarySubtitle => 'RPL Algorithm Curriculum Proficiency';

  @override
  String challengeXpEarned(int xp) {
    return '+$xp XP Earned';
  }

  @override
  String get challengeStatusInProgress => 'In progress';

  @override
  String get challengeMiniProjectHeader => 'APPLIED MINI PROJECT';

  @override
  String get challengeMiniProjectSubtitle =>
      'Comprehensive logic implementation practice typical of RPL vocational schools';

  @override
  String get challengeOpen => 'Open';

  @override
  String challengeMinutes(int count) {
    return '$count Minutes';
  }

  @override
  String challengeXpRequired(int xp) {
    return 'Need $xp XP';
  }

  @override
  String challengeXpRequirement(int xp) {
    return 'Requirement: Need $xp XP';
  }

  @override
  String challengeTestCount(int count) {
    return '$count Unit Tests';
  }

  @override
  String get challengeDetailTitle => 'Coding Challenge';

  @override
  String get challengeHistoryTooltip => 'Submission history';

  @override
  String challengeLevelLine(String level) {
    return 'Level: $level';
  }

  @override
  String challengeXpPlus(int xp) {
    return '+$xp XP';
  }

  @override
  String challengeMinutesShort(int count) {
    return '~$count min';
  }

  @override
  String get challengeTaskInstruction => 'Task Instructions';

  @override
  String get challengeSampleCalls => 'SAMPLE CALLS';

  @override
  String get challengeTabInstruction => 'Instructions & Tests';

  @override
  String get challengeTabSolution => 'Your Solution';

  @override
  String get challengeFormatPep8 => 'PEP8 Format';

  @override
  String get challengeFormatDone => 'PEP8 formatting applied';

  @override
  String get challengeResetCode => 'Reset Code';

  @override
  String get challengeAiHelpTitle => 'Need AI Help?';

  @override
  String get challengeAiHelpSubtitle =>
      'Get step-by-step hints without code spoilers';

  @override
  String challengeQuotaLabel(int used, int total) {
    return '$used/$total Quota';
  }

  @override
  String get challengeAskHint => 'Ask for Hint';

  @override
  String get challengeRunFailed =>
      'Something went wrong while running your code. Please try again shortly.';

  @override
  String get challengeSubmitFailed =>
      'Failed to submit. Please try again shortly.';

  @override
  String get challengeTestResultTitle => 'Automatic Test Results';

  @override
  String get challengeTestResultCompletedTitle =>
      'Automatic Test Results — Completed';

  @override
  String challengePassedCount(int passed, int total) {
    return '$passed/$total Passed';
  }

  @override
  String challengeExecutionTime(int ms) {
    return 'Execution: ${ms}ms';
  }

  @override
  String get challengePassed => 'Passed';

  @override
  String get challengeFailed => 'Failed';

  @override
  String challengeCaseDetail(String input, String expected, String output) {
    return 'Input: $input • Expected: $expected • Output: $output';
  }

  @override
  String get challengeScaffoldingLevels => '3-Level Scaffolding';

  @override
  String get challengeLogicHintLabel => 'Logic Hint: ';

  @override
  String get challengeAllTestsPassed =>
      'Great! All tests passed. Press the Submit Solution button below to claim your XP!';

  @override
  String challengeCasesNotPassed(int count) {
    return '$count cases have not passed the automatic tests. Ask the AI Tutor below for guidance — its hints guide your code, not a ready-made answer.';
  }

  @override
  String get challengeAskAiTutor => 'Ask AI Tutor';

  @override
  String get challengeCompletedBody =>
      'You have completed this challenge. Per-case details only appear during a live submission session; your best score is officially recorded on the server:';

  @override
  String challengeBestScore(int score) {
    return 'Best score: $score%';
  }

  @override
  String get challengeViewHistory => 'View submission history';

  @override
  String get challengeTryRun => 'Try Out';

  @override
  String get challengeSubmitSolution => 'Submit Solution';

  @override
  String get challengeEvaluationTitle => 'Project Evaluation';

  @override
  String get evalSolutionAccepted => 'Solution Accepted!';

  @override
  String get evalSolutionNotYet => 'Solution Not Successful Yet';

  @override
  String get evalAllPassedBody =>
      'All public and hidden tests passed without any issues.';

  @override
  String evalSomeFailedBody(int passed, int total) {
    return 'Don\'t be discouraged! $passed of $total tests passed. Let\'s review the mistakes and fix them together with the AI Tutor.';
  }

  @override
  String get evalMetricFinalScore => 'FINAL SCORE';

  @override
  String get evalBadgePerfect => 'Perfect';

  @override
  String get evalBadgeNeedsImprovement => 'Needs Improvement';

  @override
  String get evalMetricExecution => 'EXECUTION';

  @override
  String get evalSecondsSuffix => ' s';

  @override
  String get evalBadgeFast => 'Fast';

  @override
  String get evalTestResultsHeader => 'AUTOMATIC TEST RESULTS';

  @override
  String get evalCompetencyTitle => 'Logic & Algorithm Competency';

  @override
  String get evalPointsPlus => '+5 Points';

  @override
  String get evalCompetencySubtitle =>
      'Empirical evidence is automatically recorded in your vocational portfolio.';

  @override
  String get evalCooldownTitle => 'Compiler Submission Cooldown';

  @override
  String get evalCooldownPrefix => 'Wait ';

  @override
  String get evalCooldownSuffix =>
      ' seconds before submitting again to keep the sandbox container stable.';

  @override
  String get evalCooldownReady =>
      'The compiler is ready for a new code submission.';

  @override
  String get evalNextChallenge => 'Continue to Next Challenge';

  @override
  String get evalFixSolution => 'Fix Your Code Solution';

  @override
  String get evalHiddenBadge => 'Hidden';

  @override
  String get historyTitle => 'Submission History';

  @override
  String get historyStatusPassed => 'Passed';

  @override
  String get historyStatusError => 'Error';

  @override
  String get historyBestScore => 'Highest Score';

  @override
  String historyAttemptsCount(int count) {
    return '$count Attempts Submitted';
  }

  @override
  String get historySubmissionsHeader => 'Submission History';

  @override
  String get historySortedByTime => 'Sorted by Time';

  @override
  String get historyOpenPlayground => 'Open in Playground';

  @override
  String get historyBackToChallenge => 'Back to Challenge';

  @override
  String historySubmissionNumber(int number) {
    return 'Submission #$number';
  }

  @override
  String historyScoreInline(int score) {
    return '  •  Score $score/100';
  }

  @override
  String historyHintsUsed(int count) {
    return '$count AI hints used';
  }

  @override
  String historySubmissionCode(int number) {
    return 'Submission Code #$number (Python)';
  }

  @override
  String get historyAiReview => 'AI Tutor Review';

  @override
  String get tutorSubtitle => 'Scaffolding & Learning Companion';

  @override
  String get tutorQuotaToastExhausted =>
      'Today\'s hint quota is used up. Try again tomorrow.';

  @override
  String get tutorQuotaToastExhaustedDetail =>
      'Today\'s hint quota is used up. Try again tomorrow to practice on your own.';

  @override
  String get tutorHintFailed =>
      'The hint could not be prepared. Please try again shortly.';

  @override
  String get tutorHintOffline =>
      'The hint server is unreachable — showing the built-in hint.';

  @override
  String tutorConceptLabel(String concept) {
    return 'Concept: $concept';
  }

  @override
  String tutorLevelLabel(int unlocked, int total) {
    return 'Level $unlocked/$total';
  }

  @override
  String get tutorQuotaRemaining => 'Remaining quota';

  @override
  String get tutorScaffoldingTitle => 'Step-by-Step Scaffolding';

  @override
  String get tutorSocraticMethod => 'Socratic Method';

  @override
  String get tutorPromptQuestion => 'GUIDING QUESTION:';

  @override
  String get tutorPreparingHint => 'Preparing a hint for this challenge…';

  @override
  String get tutorQuotaBlockedBody =>
      'Today\'s hint quota is used up (5x per day). Hints specific to this challenge reopen tomorrow — for now, work through it in your code first.';

  @override
  String get tutorThinkingFlow => 'RECOMMENDED THINKING FLOW';

  @override
  String get tutorPreparingShort => 'Preparing hint…';

  @override
  String tutorUnlockNext(String level) {
    return 'Unlock Next Hint ($level)';
  }

  @override
  String get tutorQuotaExhaustedBody =>
      'The daily hint quota is used up (max 5x per day per the PRD). It resets tomorrow — for now, work through it in your code first.';

  @override
  String get tutorAllHintsUnlocked =>
      'All hints are unlocked. Now try applying them in your code.';

  @override
  String get tutorLockedSuffix => ', locked';

  @override
  String get materialCatalogTitle => 'Lesson Catalog';

  @override
  String get materialFilterActive => 'In Progress';

  @override
  String get materialFilterNotStarted => 'Not Started';

  @override
  String get materialStatusRunning => 'Ongoing';

  @override
  String get materialLoadFailed => 'Failed to load the lesson catalog.';

  @override
  String get materialSearchHint => 'Search lessons or their description…';

  @override
  String get materialClearSearch => 'Clear search';

  @override
  String get materialNoMatch => 'No lessons match your search or filter.';

  @override
  String materialSwitchedSnack(String topic) {
    return 'Showing lesson $topic. Learning map updated.';
  }

  @override
  String materialChaptersDone(int done, int total) {
    return '$done/$total chapters completed';
  }

  @override
  String get readerPreviewDone =>
      'Student Preview Complete! All slides were evaluated successfully.';

  @override
  String readerXpEarned(int xp) {
    return 'Congratulations! You earned +$xp XP! 🎉';
  }

  @override
  String get readerXpAlreadyDone =>
      'This chapter was already completed — XP is not counted twice.';

  @override
  String get readerExitTitle => 'Exit Practice?';

  @override
  String get readerExitBody =>
      'Your latest slide progress will be saved automatically.';

  @override
  String get readerExitStay => 'Keep Learning';

  @override
  String get readerExitConfirm => 'Exit';

  @override
  String get readerLoadFailed => 'Failed to load the chapter lesson.';

  @override
  String get readerTeacherPreviewBanner =>
      'TEACHER PREVIEW MODE (Data is not saved)';

  @override
  String get readerContinue => 'Got it, Continue';

  @override
  String get readerFinishSave => 'Finish & Save Progress';

  @override
  String get readerCheckAnswer => 'Check Answer';

  @override
  String get slideBadgeValidated => 'Step Validated';

  @override
  String get slideProgressSaved => 'Progress Saved';

  @override
  String get slideWhyCorrect => 'Why Is Your Answer Correct?';

  @override
  String get slideNextSlide => 'Continue to Next Slide';

  @override
  String get slideSyntaxEvaluation => 'Syntax Evaluation';

  @override
  String get slideZeroXpTryAgain => '0 XP • Keep Trying!';

  @override
  String get slideErrorEncouragement =>
      'Don\'t worry, small mistakes are a natural part of learning to code.';

  @override
  String get slideSkipArrow => 'Skip Slide →';

  @override
  String get slideWhereIsMistake => 'Where Is the Mistake?';

  @override
  String get slideBadgeTheory => 'Theory & Concept';

  @override
  String get slideTheoryTip =>
      'Understand the concept above carefully before moving on to the interactive practice.';

  @override
  String get slideBadgeArrangeSyntax => 'Arrange Syntax';

  @override
  String get slideTapToFillInstruction =>
      'Tap the code blocks below to fill the matching empty slots:';

  @override
  String get slideWordBank => 'Code Block Bank:';

  @override
  String get slideBadgeTypeCode => 'Type Code';

  @override
  String get slideHint => 'Hint';

  @override
  String get slideTypeHere => 'type here...';

  @override
  String get slideBadgeGuessOutput => 'Guess the Output';

  @override
  String get slideBadgeBugHunter => 'Bug Hunter';

  @override
  String get slideBugHunterInstruction =>
      'Tap the line you think contains the coding error above.';

  @override
  String get slideBadgeConceptQuiz => 'Concept Quiz';

  @override
  String get slideOutroXpReward => 'XP Reward';

  @override
  String get slideOutroAccuracy => 'Accuracy';

  @override
  String get slideOutroLearningTime => 'Learning Time';

  @override
  String get slideOutroMasteredConcepts => 'Concepts You Mastered';

  @override
  String get profileTitle => 'Profile & Competency';

  @override
  String get profileSettingsTooltip => 'Profile Settings';

  @override
  String get profileLoading => 'Loading profile…';

  @override
  String get profileLoadFailedTitle => 'Failed to load profile data';

  @override
  String get profileLoadFailedBody =>
      'Make sure the coding lab server is running, then try again.';

  @override
  String get profileNewStudent => 'New Student';

  @override
  String get profileAddBio => '+ Add Bio';

  @override
  String get profileStatChallenges => 'Challenges';

  @override
  String get profileStatXpPoints => 'XP Points';

  @override
  String get profileStatMaterialsDone => 'Lessons Done';

  @override
  String get profileMasteryMapTitle => 'Lesson Mastery Map';

  @override
  String get profileMaterialsUnavailable =>
      'The lesson list is not available from the server yet. Try again.';

  @override
  String get profileMaterialProgressTitle => 'Lesson Progress';

  @override
  String profileChaptersInline(int done, int total) {
    return '$done/$total chapters';
  }

  @override
  String get profileCurriculumUnavailable =>
      'The curriculum is not available from the server yet. Try again.';

  @override
  String get profileCertificatesTitle => 'Certificates';

  @override
  String profileTracksDoneBadge(int done, int total) {
    return '$done/$total Completed';
  }

  @override
  String get profileChallengeCertsTitle => 'Challenge Certificates';

  @override
  String get profileNoChallenges =>
      'No challenges in the catalog yet — try again.';

  @override
  String profileBabCountInline(int done, int total) {
    return '$done/$total Chapters';
  }

  @override
  String get profileCertReady => 'Certificate ready to download';

  @override
  String get profileCertLearning => 'In progress';

  @override
  String get profileDownload => 'Download';

  @override
  String get profileCertChallengeDone => 'Completed — certificate ready';

  @override
  String get profileCertChallengeLocked => 'Locked — not enough XP';

  @override
  String get profileCertChallengeInProgress => 'In progress';

  @override
  String get profileDownloadSoon =>
      'The certificate download feature is coming soon!';

  @override
  String get certScreenTitle => 'Certificate of Competency';

  @override
  String get certLoading => 'Preparing your certificate…';

  @override
  String get certLoadFailed =>
      'The certificate could not be loaded. Check your connection and try again.';

  @override
  String get certOpenPreview => 'View Certificate';

  @override
  String get certOpenWeb => 'Open Verification Page';

  @override
  String get certShareAction => 'Share Certificate';

  @override
  String get certShareCopied => 'Verification link copied to clipboard.';

  @override
  String get certShareFailed =>
      'The link could not be copied. Please try again.';

  @override
  String get certNotEligible => 'Finish every chapter of this module first.';

  @override
  String get certEligibleNow => 'Your certificate is ready to be issued.';

  @override
  String get certIdLabel => 'Certificate ID';

  @override
  String get certGivenTo => 'Awarded to';

  @override
  String get certIssuedLabel => 'Issued';

  @override
  String get certValidUntilLabel => 'Valid until';

  @override
  String get certPageOne => 'Page 1 — Certificate of Completion';

  @override
  String get certPageTwo => 'Page 2 — Transcript & Achievements';

  @override
  String get certPdfHint =>
      'Both pages download automatically as a single PDF file.';

  @override
  String certChapterCountInline(int done, int total) {
    return '$done/$total chapters done';
  }

  @override
  String get certPreviewTitle => 'e-Certificate Preview';

  @override
  String get certChallengeSectionTitle => 'Coding Challenge Certificates';

  @override
  String get certCatalogTitle => 'Certificate Catalog';

  @override
  String get certCatalogSubtitle =>
      'Every module and challenge certificate you have completed.';

  @override
  String get certModuleSectionTitle => 'Module Certificates';

  @override
  String get certDownloadPdf => 'Download PDF';

  @override
  String get certDownloadFailed =>
      'The PDF could not be downloaded. Check your connection and try again.';

  @override
  String certReadyCount(int count) {
    return '$count certificates ready to download';
  }

  @override
  String get certEmptyTitle => 'No certificates yet';

  @override
  String get certEmptyBody =>
      'Complete every chapter of a module or pass a coding challenge to earn a certificate.';

  @override
  String get certNotEligibleShort => 'Not eligible';

  @override
  String get certOpenCatalog => 'View All Certificates';

  @override
  String get certProfileSummaryBody =>
      'Modules and challenges you have completed.';

  @override
  String get certTabFront => 'Certificate';

  @override
  String get certTabBack => 'Transcript';

  @override
  String certProgressLockedHint(int percent) {
    return '$percent% complete — the certificate is issued automatically once every chapter is done.';
  }

  @override
  String get changePassOldLabel => 'Old Password';

  @override
  String get changePassNewLabel => 'New Password';

  @override
  String get changePassConfirmLabel => 'Confirm New Password';

  @override
  String get changePassShowPassword => 'Show password';

  @override
  String get changePassHidePassword => 'Hide password';

  @override
  String get changePassOldRequired => 'Enter your old password first.';

  @override
  String get changePassSuccess => 'Password changed successfully!';

  @override
  String get changePassFailed => 'Failed to change the password. Try again.';

  @override
  String get changePassConfirmHint => 'Retype the new password to confirm.';

  @override
  String get changePassConfirmMatch => 'Confirmation matches the new password.';

  @override
  String get changePassConfirmMismatch =>
      'Confirmation does not match the new password yet.';

  @override
  String get changePassSaving => 'Saving…';

  @override
  String get changePassSave => 'Save Password';

  @override
  String get joinClassTitle => 'Join Your Teacher\'s Class';

  @override
  String get joinClassSubtitle =>
      'Enter the 6-character class code shared by your teacher.';

  @override
  String get joinClassClearCode => 'Clear code';

  @override
  String get joinClassExample => 'Example: K7M-8Q2 or 4NB-9XT';

  @override
  String get joinClassNotFound => 'Class code not found.';

  @override
  String joinClassSuccess(String name) {
    return 'Joined $name successfully!';
  }

  @override
  String get joinClassCtaButton => 'Join Class Now';

  @override
  String get joinClassFoundBadge => 'Class Found';

  @override
  String joinClassMemberCount(int count) {
    return '$count Classmates';
  }

  @override
  String get classServerUnreachable =>
      'Server is unreachable. Check your lab connection, then try again.';

  @override
  String get classServerUnreachableShort =>
      'Server is unreachable. Please try again in a moment.';

  @override
  String classJoinedSnack(String name) {
    return 'Joined class $name successfully!';
  }

  @override
  String classLeftSnack(String name) {
    return 'You left $name.';
  }

  @override
  String get classSectionTitle => 'Learning Classes';

  @override
  String get classSeeAll => 'See All';

  @override
  String get classLoadFailedFromServer =>
      'Failed to load classes from the server';

  @override
  String get classLoadFailedTitle => 'Failed to load classes';

  @override
  String get classCheckLabConnection =>
      'Check your school lab connection, then try again.';

  @override
  String get classLoadingInline => 'Loading classes…';

  @override
  String get classNotJoinedTitle => 'Not in a class yet';

  @override
  String get classJoinHintInline =>
      'Enter the 6-character class code shared by your teacher.';

  @override
  String get classJoinButton => 'Join Class';

  @override
  String get classNotInClassTitle => 'Not in a class yet';

  @override
  String get classJoinHintShort =>
      'Join using the 6-character code from your teacher.';

  @override
  String get classJoinShort => 'Join';

  @override
  String get classActiveBadge => 'Active';

  @override
  String classCountBadge(int count) {
    return '$count classes';
  }

  @override
  String get classSeeAllTooltip => 'See all classes';

  @override
  String classMemberCountInline(int count) {
    return '$count classmates';
  }

  @override
  String get myClassesTitle => 'My Classes';

  @override
  String myClassesActiveCount(int count) {
    return '$count active classes';
  }

  @override
  String get myClassesSubtitle => 'Classes where you learn';

  @override
  String get myClassesJoinAnother => 'Join Another Class';

  @override
  String get myClassesEmptyTitle => 'Not in any class yet';

  @override
  String get myClassesEmptyBody =>
      'Ask your teacher for the 6-character class code, then join from here.';

  @override
  String get classDetailLoadFailed => 'Failed to load class details';

  @override
  String get classRegisteredBadge => 'Actively Enrolled';

  @override
  String get classTeacherRoleBadge => 'Teacher';

  @override
  String get classTeacherAdvisor => 'Homeroom teacher of this class';

  @override
  String get classClassmatesTitle => 'Classmates';

  @override
  String classClassmatesCount(int count) {
    return '($count Students)';
  }

  @override
  String get classNoClassmates => 'No classmates registered yet.';

  @override
  String get classMonitoringNote =>
      'Your coding progress and challenge scores can be monitored directly by this class teacher in the computer lab.';

  @override
  String get classXpSafeNote =>
      'Your XP and learning progress stay safe on your account even if you leave the class.';

  @override
  String get classCopyInfo => 'Copy Class Info';

  @override
  String get classInfoCopied => 'Info Copied!';

  @override
  String get classLeaveButton => 'Leave Class';

  @override
  String get classLeaveConfirmTitle => 'Leave the Class?';

  @override
  String get classLeaveConfirmBody =>
      'Your XP and learning progress stay safe on your account, but your teacher will no longer be able to monitor your progress in the lab.';

  @override
  String get classLeaveConfirmYes => 'Yes, Leave Class';

  @override
  String get classHideNames => 'Hide';

  @override
  String classMoreCount(int rest) {
    return '+$rest more';
  }

  @override
  String classSeeAllNames(int count) {
    return 'See all names ($count)';
  }

  @override
  String get authPassNotFilled => 'Not filled yet';

  @override
  String get authPassVeryGood => 'Very Good!';

  @override
  String get authPassNeedsWork => 'Needs improvement';

  @override
  String get authPassSecurityTitle => 'PASSWORD SECURITY';

  @override
  String get authPassMinLength => 'At least 8 characters';

  @override
  String get authPassDigitOrSymbol => 'Has a number or symbol';

  @override
  String get authCheckMet => 'met';

  @override
  String get authCheckNotMet => 'not met';

  @override
  String get authSchoolVerifiedBadge => 'Officially Registered School';

  @override
  String authSchoolCodePrefix(String code) {
    return 'Code: $code';
  }

  @override
  String get authSchoolReadOnlyNote =>
      'This school data is read-only and automatically verified; it cannot be changed by the instructor.';

  @override
  String get validNameRequired => 'Fill in your full name first.';

  @override
  String get validEmailRequired => 'Fill in your email first.';

  @override
  String get validEmailFormat =>
      'The email format isn\'t right yet. Example: nama@smk.belajar.id';

  @override
  String validSchoolEmailDomain(String domain) {
    return 'Email must use the $domain domain.';
  }

  @override
  String get validPasswordRequired => 'Fill in your password first.';

  @override
  String get validNewPasswordRequired => 'Create a password first.';

  @override
  String get validPasswordPolicy =>
      'At least 8 characters, with a number or symbol.';

  @override
  String get validConfirmRequired => 'Retype your password to confirm.';

  @override
  String get validPasswordMismatch => 'The passwords don\'t match yet.';

  @override
  String get authErrInvalidCredentials =>
      'Email or password doesn\'t match yet. Try checking again.';

  @override
  String get authErrEmailTaken =>
      'This email already has an account. Want to sign in instead?';

  @override
  String get authErrNetwork =>
      'You\'re not connected to the internet yet. Try again in a moment.';

  @override
  String get authErrSchoolCodeNotFound =>
      'School code not found. Please contact your school admin.';

  @override
  String get authErrWrongOldPassword =>
      'The old password doesn\'t match yet. Try checking again.';

  @override
  String get authErrPasswordPolicy =>
      'The new password doesn\'t meet the rules yet (at least 8 characters, with a number or symbol).';

  @override
  String get authErrAvatarUpload =>
      'Profile photo couldn\'t be uploaded. Use JPG or PNG up to 2 MB.';

  @override
  String get authErrEmailDomain => 'Email must use the @smk.belajar.id domain.';

  @override
  String get authErrInvalidInput =>
      'Something isn\'t filled in right. Check again, then save.';

  @override
  String get authErrServer =>
      'The server is having trouble. Try again in a little while.';

  @override
  String get loginWelcomeTitle => 'Welcome back';

  @override
  String get loginWelcomeSubtitle =>
      'Continue learning to code from where you left off.';

  @override
  String get loginJustRegisteredBanner =>
      'Your account is ready. Please log in to start learning.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get loginSubmit => 'Log In Now';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get authRegisterLink => 'Register';

  @override
  String get authBackTooltip => 'Back';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerTagBanner => 'RPL Coding Learning Platform';

  @override
  String get registerHeading => 'Let\'s create your account';

  @override
  String get registerSubheading => 'For SMK/SMA students majoring in RPL.';

  @override
  String get registerNameLabel => 'Full Name';

  @override
  String get registerNameHintAside => 'As in your class attendance list';

  @override
  String get registerEmailLabel => 'Student / Personal Email';

  @override
  String get registerEmailHintAside => '.belajar.id';

  @override
  String get authPasswordStrengthHint => 'Strong password combination';

  @override
  String get registerConfirmLabel => 'Confirm Password';

  @override
  String get authSameExactlyHintAside => 'Exactly the same';

  @override
  String get authRetypePasswordHint => 'Retype your password';

  @override
  String get registerSubmit => 'Create Account';

  @override
  String get authAlreadyHaveAccount => 'Already have an account?';

  @override
  String get authLoginLink => 'Log In';

  @override
  String get registerTeacherLink =>
      'Are you a teacher / instructor? Register an educator account here →';

  @override
  String get registerSuccessTitle => 'Registration Successful! 🎉';

  @override
  String get registerSuccessBody =>
      'Your account has been created and is ready to use.\n\nPlease log in using the email and password you just created.';

  @override
  String get registerCommunityPrefix => 'Join';

  @override
  String get registerCommunitySuffix =>
      'RPL peers starting to learn algorithm logic, Git, and web dev today.';

  @override
  String get teacherRegTitle => 'Educator Account Registration';

  @override
  String get teacherRegTagBanner => 'Institution Partnership';

  @override
  String get teacherRegHeading => 'Choose Your Account Role';

  @override
  String get teacherRegSubheading =>
      'Tailor your learning experience or your school computer lab management.';

  @override
  String get teacherRegVerifySectionTitle => 'School & Lab Verification';

  @override
  String get teacherRegStatusConnected => 'Connected';

  @override
  String get teacherRegStatusWaiting => 'Waiting for code';

  @override
  String get teacherRegSchoolCodeLabel => 'School / Lab Registration Code';

  @override
  String get teacherRegSchoolCodeHintAside =>
      'From the education office/school';

  @override
  String get teacherRegSchoolCodeHint => 'Example: SWADHIPA2-NTR';

  @override
  String get teacherRegSchoolCodeInvalid =>
      'Enter the official school code until the green card appears.';

  @override
  String get teacherRegVerifyFirst =>
      'Verify your school first — enter the official code and wait for the green card.';

  @override
  String get teacherRegSchoolCodeNote =>
      'Teachers must enter the official school code to be affiliated with the school laboratory.';

  @override
  String get teacherRegDataSectionTitle => 'Registered Educator Details';

  @override
  String get teacherRegDataSectionNote =>
      'Complete the educator identity to verify the lab certificate.';

  @override
  String get teacherRegNameLabel => 'Full Name & Title';

  @override
  String get teacherRegNameHintAside => 'Example: Budi Santoso, S.Kom';

  @override
  String get teacherRegEmailLabel => 'Educator / Institution Email';

  @override
  String get teacherRegEmailHintAside => 'Office email';

  @override
  String get teacherRegSubmit => 'Continue Account Registration';

  @override
  String teacherRegSuccessBody(String school) {
    return 'Your educator account has been created for $school.\n\nPlease log in using the email and password you just created.';
  }

  @override
  String get teacherRegYourSchool => 'your school';

  @override
  String get roleStudentChip => 'Self-Paced Learning';

  @override
  String get roleStudentTitle => 'Student';

  @override
  String get roleStudentDesc =>
      'Access practical coding modules & 24/7 AI tutor';

  @override
  String get roleTeacherChip => 'Educator Access';

  @override
  String get roleTeacherTitle => 'Teacher / Instructor';

  @override
  String get roleTeacherDesc =>
      'Manage class labs, curriculum & monitor students';

  @override
  String get actionCopy => 'Copy';

  @override
  String get codeCopied => 'Code copied.';

  @override
  String get a11yShowPassword => 'Show password';

  @override
  String get a11yHidePassword => 'Hide password';

  @override
  String get a11yOpenProfile => 'Open profile';

  @override
  String a11yMasteryRadar(String detail) {
    return 'Mastery radar: $detail';
  }

  @override
  String loadingTipSubmitQuota(String run, String submit) {
    return 'Press \"$run\" first before \"$submit\" — keep your daily quota safe.';
  }

  @override
  String get loadingTipAiHint =>
      'AI help only gives hints, not finished code. The answer stays your own work.';

  @override
  String get loadingTipPlayground =>
      'Playground runs Python right on your device — still works offline.';

  @override
  String get loadingTipHiddenTests =>
      'Secret test cases stay on the server and are not sent to students\' phones.';

  @override
  String get loadingVersionFooter => 'Version 2.1 · Merdeka Curriculum RPL';

  @override
  String get bootTitle => 'Restoring your session…';

  @override
  String get bootSubtitle => 'Setting up the code lab on your device';

  @override
  String get bootStageSecureStorage => 'Checking secure storage';

  @override
  String get classResponseUnrecognized =>
      'Class response format not recognized.';

  @override
  String get slideTapToFillSuccessTitle => 'Exactly Right!';

  @override
  String get slideTapToFillSuccessMsg => 'You arranged the syntax correctly.';

  @override
  String get slideTapToFillErrorTitle => 'Check Again!';

  @override
  String get slideTapToFillErrorMsg => 'Watch the empty slots.';

  @override
  String get slideTypeCodeSuccessTitle => 'Amazing!';

  @override
  String get slideTypeCodeSuccessMsg => 'The command you typed is correct.';

  @override
  String get slideTypeCodeErrorTitle => 'Not Quite!';

  @override
  String get slideTypeCodeErrorMsg => 'Pay attention to the letters.';

  @override
  String get slideOutputPredictSuccessTitle => 'Spot On!';

  @override
  String get slideOutputPredictSuccessMsg =>
      'Your logic prediction is accurate.';

  @override
  String get slideOutputPredictErrorTitle => 'Not Quite!';

  @override
  String get slideOutputPredictErrorMsg =>
      'Follow the execution flow line by line.';

  @override
  String get slideBugHunterSuccessTitle => 'Great, Bug Found!';

  @override
  String get slideBugHunterSuccessMsg => 'You spotted the faulty line.';

  @override
  String get slideBugHunterErrorTitle => 'Not That Line!';

  @override
  String get slideBugHunterErrorMsg =>
      'Find the line breaking the syntax rules.';

  @override
  String get slideQuizSuccessTitle => 'Perfect Answer!';

  @override
  String get slideQuizSuccessMsg => 'Your grasp of the concept is solid.';

  @override
  String get slideQuizErrorTitle => 'Not Quite!';

  @override
  String get slideQuizErrorMsg =>
      'Try recalling the core principle of this lesson.';

  @override
  String get slideContentUnavailable => 'Lesson is not available right now.';

  @override
  String get tutorHintTabConcept => 'Hint 1: Concept';

  @override
  String get tutorHintTabLogic => 'Hint 2: Logic';

  @override
  String get tutorHintTabStructure => 'Hint 3: Structure';

  @override
  String get tutorHintDefaultConcept => 'Coding Practice';

  @override
  String get tutorHintPlaygroundConcept => 'Independent Practice (Playground)';

  @override
  String get tutorHintChallengeQ1 =>
      'What output does this problem ask for? Describe it in your own words before touching the code.';

  @override
  String get tutorHintChallengeQ1Step1 =>
      'List the available inputs and the output that must appear.';

  @override
  String get tutorHintChallengeQ1Step2 =>
      'Mark the parts of the code you already understand and the parts you are still unsure about.';

  @override
  String get tutorHintChallengeQ2 =>
      'What is the order of your program steps, from the first line to the last?';

  @override
  String get tutorHintChallengeQ2Step1 =>
      'Write the steps in everyday language first, not in code yet.';

  @override
  String get tutorHintChallengeQ2Step2 =>
      'Check whether each step really leads to the output the problem asks for.';

  @override
  String get tutorHintChallengeQ3 =>
      'Which line most often produces an error when you run it?';

  @override
  String get tutorHintChallengeQ3Step1 =>
      'Read the error message from the top line: the error name and its line number.';

  @override
  String get tutorHintChallengeQ3Step2 =>
      'Match the punctuation on that line (parentheses, colons, quotes, indentation).';

  @override
  String get tutorHintPlaygroundQ1 =>
      'What problem do you most want this program to solve? Write its goal in one sentence first.';

  @override
  String get tutorHintPlaygroundQ1Step1 =>
      'Map it out: what input goes in, what process runs, and what output is expected.';

  @override
  String get tutorHintPlaygroundQ1Step2 =>
      'Start from the smallest piece you can test yourself.';

  @override
  String get tutorHintPlaygroundQ2 =>
      'What is the order of your program steps, from the first line to the last?';

  @override
  String get tutorHintPlaygroundQ2Step1 =>
      'Write the flow as pseudocode in your own language before copying it to Python.';

  @override
  String get tutorHintPlaygroundQ2Step2 =>
      'Mark which parts repeat (loop) and which branch (if).';

  @override
  String get tutorHintPlaygroundQ3 =>
      'Which part of your code looks confusing when read?';

  @override
  String get tutorHintPlaygroundQ3Step1 =>
      'Check the indentation and colons on the lines containing logic.';

  @override
  String get tutorHintPlaygroundQ3Step2 =>
      'Test the small piece in the same terminal before merging it back.';

  @override
  String get tNavDashboard => 'Dashboard';

  @override
  String get tNavMaterials => 'Lesson';

  @override
  String get tNavAnalytics => 'Analytics';

  @override
  String get tPickerTitle => 'Class Analytics';

  @override
  String get tPickerHeading => 'Choose Class';

  @override
  String get tPickerSubtitle =>
      'Choose a class to see lesson and exercise rankings for students, then manage its members.';

  @override
  String get tPickerEmptyTitle => 'No Classes Yet';

  @override
  String get tPickerEmptyBody =>
      'Create your first class from the Dashboard to start monitoring student analytics.';

  @override
  String get tPickerOpenDashboard => 'Open Dashboard';

  @override
  String get tPickerSchoolUnset => 'School not set';

  @override
  String tPickerMemberCount(int count) {
    return '$count students';
  }

  @override
  String get tArchivedTitle => 'Archived Classes';

  @override
  String get tArchivedInfo =>
      'Archived classes cannot accept new students. Restore a class if you want to activate it again.';

  @override
  String get tArchivedLoadFailed => 'Failed to Load Archive';

  @override
  String get tArchivedEmptyTitle => 'No Archived Classes Yet';

  @override
  String get tArchivedEmptyBody =>
      'Classes you archive from the analytics page will appear here.';

  @override
  String get tArchivedBackDashboard => 'Back to Dashboard';

  @override
  String get tArchivedBadge => 'Archived';

  @override
  String tArchivedSchoolYear(String school, String year) {
    return '$school • School Year $year';
  }

  @override
  String get tArchivedClassCode => 'CLASS CODE';

  @override
  String get tArchivedInactive => 'Inactive';

  @override
  String get tArchivedRestore => 'Restore Class';

  @override
  String get tDashFilterTitle => 'Filter Class List';

  @override
  String get tDashFilterSubtitle =>
      'Search and school year are filtered from the loaded class data.';

  @override
  String get tDashSearchHint => 'Search class name or code';

  @override
  String get tDashClearSearch => 'Clear search';

  @override
  String get tDashYearLabel => 'School Year';

  @override
  String get tDashApplyFilter => 'Apply Filter';

  @override
  String get tDashFilterReset => 'Reset';

  @override
  String tDashCodeCopied(String code) {
    return 'Class code \"$code\" copied to clipboard!';
  }

  @override
  String get tDashCodeFullscreen => 'CLASS CODE (FULL SCREEN)';

  @override
  String get tDashProjectorHint =>
      'Open the CodeLab AI app and enter the class code:';

  @override
  String get tDashProjectorCopy => 'Copy Code';

  @override
  String get tDashCreateNewClass => 'Create New Class';

  @override
  String get tDashCreateSubtitle =>
      'A class identity container for monitoring student learning progress.';

  @override
  String get tDashFieldName => 'Class Name *';

  @override
  String get tDashExampleName => 'Example: X RPL 1';

  @override
  String get tDashFieldYear => 'School Year *';

  @override
  String tDashExampleYear(String year) {
    return 'Example: $year';
  }

  @override
  String get tDashCreateClass => 'Create Class';

  @override
  String get tDashValidationRequired =>
      'Class name and school year are required.';

  @override
  String get tDashSchoolUnset => 'School not connected';

  @override
  String tDashGreeting(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String get tDashGreetingFallback => 'Teacher';

  @override
  String get tProfileTitle => 'Teacher Profile';

  @override
  String get tDashBadgeTotal => 'Total';

  @override
  String tDashClassCount(int count) {
    return '$count Classes';
  }

  @override
  String get tDashActiveClasses => 'Active Classes';

  @override
  String get tDashBadgeRegistered => 'Registered';

  @override
  String get tDashRegisteredStudents => 'Registered Students';

  @override
  String get tDashClassListTitle => 'Class List';

  @override
  String get tDashClassListSubtitle =>
      'Choose a class to monitor progress or share the code.';

  @override
  String get tDashFilterTooltip => 'Filter class list';

  @override
  String get tDashArchive => 'Archive';

  @override
  String tDashSearchChip(String query) {
    return 'Search: $query';
  }

  @override
  String get tDashResetFilter => 'Reset filter';

  @override
  String get tDashEmptyBody =>
      'Create your first class to get a class code and start monitoring student learning progress.';

  @override
  String get tDashNoMatchTitle => 'No Matching Classes';

  @override
  String get tDashNoMatchBody =>
      'Try another keyword or show all school years.';

  @override
  String get tDashShowAll => 'Show All Classes';

  @override
  String tDashActiveYear(String year) {
    return 'Active $year';
  }

  @override
  String get tDashMetaMembers => 'Members';

  @override
  String get tDashProjector => 'Code Projector';

  @override
  String get tDashMonitor => 'Monitor Class';

  @override
  String get tProfileLogoutTitle => 'Log Out of Teacher Account?';

  @override
  String get tProfileLogoutBody =>
      'You will need to enter your email and password again to sign in to this teacher account.';

  @override
  String get tProfileLogoutConfirm => 'Yes, Log Out';

  @override
  String get tProfileNameFallback => 'RPL Teacher';

  @override
  String get tProfileSettingsTooltip => 'Profile Settings';

  @override
  String get tProfileRoleChip => 'RPL Instructor';

  @override
  String tProfileNip(String code) {
    return 'NIP: $code';
  }

  @override
  String get tProfileAddBio => 'Add Bio';

  @override
  String get tProfileStatClasses => 'Classes Taught';

  @override
  String get tProfileStatStudents => 'Students Mentored';

  @override
  String get tProfileStatMaterials => 'Teaching Lessons';

  @override
  String get tProfileClassesTitle => 'Classes Taught';

  @override
  String get tProfileNoClasses => 'No classes created yet.';

  @override
  String tProfileClassMeta(String year, int count) {
    return 'Year $year • $count students';
  }

  @override
  String get tProfileNoMaterials => 'No lessons created yet.';

  @override
  String tProfileMaterialCount(int count) {
    return '$count Lessons';
  }

  @override
  String tProfileMaterialMeta(String topic, int babs, int xp) {
    return '$topic • $babs Chapters • $xp XP';
  }

  @override
  String get tProfilePublished => 'Published';

  @override
  String get tProfileDraft => 'Draft';

  @override
  String get tProfileOpenSettings => 'Open Account Settings';

  @override
  String get tProfileLogout => 'Log Out';

  @override
  String get tStudioActionHint => 'Choose an action for this lesson';

  @override
  String get tStudioEditSyllabus => 'Edit Syllabus & Chapters';

  @override
  String get tStudioEditInfo => 'Edit Lesson Info';

  @override
  String get tStudioDuplicate => 'Duplicate as New Draft';

  @override
  String get tStudioUnpublish => 'Move Back to Draft';

  @override
  String get tStudioPublish => 'Publish to Students';

  @override
  String get tStudioDeleteForever => 'Delete Lesson Permanently';

  @override
  String get tStudioDeleteTitle => 'Delete This Lesson?';

  @override
  String tStudioDeleteBody(String title) {
    return 'Lesson \"$title\" will be deleted from the Studio. Completed student learning history stays saved.';
  }

  @override
  String get tStudioTitle => 'Lesson Studio';

  @override
  String get tStudioSettingsTooltip => 'Teacher Settings';

  @override
  String get tStudioMyMaterials => 'My Lessons';

  @override
  String get tStudioSubtitle => 'Manage learning modules & coding chapters';

  @override
  String get tStudioAdd => 'Add Lesson';

  @override
  String get tStudioBannerTitle => 'Class Learning Status';

  @override
  String tStudioBanner(int published, int students, String school) {
    return '$published active lessons published for $students students at $school.';
  }

  @override
  String get tStudioYourSchool => 'your school';

  @override
  String tStudioFilterAll(int count) {
    return 'All ($count)';
  }

  @override
  String tStudioFilterDraft(int count) {
    return 'Draft ($count)';
  }

  @override
  String tStudioFilterPublished(int count) {
    return 'Published ($count)';
  }

  @override
  String get tStudioEmptyTitle => 'No Lessons Yet';

  @override
  String get tStudioEmptyDraftTitle => 'No Draft Lessons';

  @override
  String get tStudioEmptyPublishedTitle => 'No Published Lessons';

  @override
  String get tStudioEmptyBody =>
      'Start building a coding curriculum for your students. Tap the Add Lesson button above.';

  @override
  String get tStudioEmptyFilterBody =>
      'Change the filter or add a new lesson for this category.';

  @override
  String get tStudioCreateNew => 'Create New Lesson';

  @override
  String tStudioBabCount(int count) {
    return '$count chapters';
  }

  @override
  String get tStudioNotVisible => 'Not visible to students yet';

  @override
  String get tBabDeleteTitle => 'Delete This Chapter?';

  @override
  String tBabDeleteBody(String title) {
    return 'Chapter \"$title\" will be deleted from the lesson list. Recorded student learning history stays saved.';
  }

  @override
  String get tBabDuplicateTitle => 'Duplicate This Chapter?';

  @override
  String tBabDuplicateBody(String title) {
    return 'A copy of \"$title\" will appear as the next chapter number, complete with all its slides and XP.';
  }

  @override
  String get tBabDuplicate => 'Duplicate';

  @override
  String get tBabTitle => 'Syllabus & Chapters';

  @override
  String get tBabAdd => 'Add Chapter';

  @override
  String get tBabTopicFallback => 'Lesson Studio';

  @override
  String get tBabTitleFallback => 'Chapter List';

  @override
  String get tBabCurriculumStatus => 'Chapter Curriculum Status';

  @override
  String tBabMeta(int babs, int xp) {
    return '$babs Chapters • $xp XP';
  }

  @override
  String get tBabPublishedHint =>
      'All active chapters are readable by students in your class.';

  @override
  String get tBabDraftHint =>
      'Lesson is in Draft status. Students cannot see these chapters yet.';

  @override
  String get tBabListTitle => 'Structured Chapter List';

  @override
  String get tBabFlowOrder => 'Learning Flow Order';

  @override
  String get tBabEmptyTitle => 'No Chapters Yet';

  @override
  String get tBabEmptyBody =>
      'This lesson has no learning chapters yet. Add the first chapter to start arranging quiz and theory slides.';

  @override
  String get tBabAddFirst => 'Add First Chapter';

  @override
  String tBabRowMeta(int slides, int xp) {
    return '$slides Slides • $xp XP';
  }

  @override
  String get tBabMoveUp => 'Move up';

  @override
  String get tBabMoveDown => 'Move down';

  @override
  String get tBabPreviewTooltip => 'Student Simulator (Preview)';

  @override
  String get tBabActionTooltip => 'Chapter actions';

  @override
  String get tBabEdit => 'Edit Chapter';

  @override
  String get tBabDuplicateMenu => 'Duplicate Chapter';

  @override
  String get tBabDeleteMenu => 'Delete Chapter';

  @override
  String get tFormLevelDescBeginner =>
      'Basic level: for students just getting to know programming logic.';

  @override
  String get tFormLevelDescIntermediate =>
      'Intermediate level: advanced branching, loops, & data manipulation.';

  @override
  String get tFormLevelDescAdvanced =>
      'Advanced level: complex recursive algorithms & problem-solving optimization.';

  @override
  String get tFormNotFound =>
      'Lesson not found. Return to the Lesson Studio to choose another lesson.';

  @override
  String get tFormTitleRequired => 'Lesson name is required.';

  @override
  String get tFormTitleDuplicate =>
      'Lesson name is already used. Use another name so students are not confused.';

  @override
  String get tFormUpdated => 'Lesson updated successfully.';

  @override
  String get tFormSavedDraft => 'Lesson saved as draft.';

  @override
  String get tFormSaveFailed =>
      'Lesson not saved yet. Check the connection and try again.';

  @override
  String get tFormUnsavedTitle => 'Unsaved Changes';

  @override
  String get tFormUnsavedBody =>
      'This lesson form has revisions. Save the changes as a draft first, or discard them?';

  @override
  String get tFormSaveExit => 'Save Draft & Exit';

  @override
  String get tFormDiscard => 'Discard Changes';

  @override
  String get tFormKeepEditing => 'Keep Editing';

  @override
  String get tFormEdit => 'Edit Lesson';

  @override
  String get tFormLoadFailed => 'Lesson Could Not Be Loaded';

  @override
  String get tFormOpenStudio => 'Open Lesson Studio';

  @override
  String get tFormAdd => 'Add New Lesson';

  @override
  String get tFormModeEdit => 'Edit Mode';

  @override
  String get tFormNewBadge => 'New Lesson';

  @override
  String get tFormEditHeading => 'Change Lesson Settings';

  @override
  String get tFormAddHeading => 'Configure New Lesson';

  @override
  String get tFormSubtitle =>
      'Configure the title, curriculum track, and difficulty level to show to students.';

  @override
  String get tFormFieldName => 'Lesson Name *';

  @override
  String get tFormExampleName => 'Example: Algorithm Basics & RPL Python';

  @override
  String get tFormFieldDesc => 'Short Description *';

  @override
  String get tFormDescHint =>
      'Explain the lesson outcomes in 2-3 concise sentences...';

  @override
  String get tFormFieldIcon => 'Lesson Icon Code *';

  @override
  String get tFormIconHint =>
      'Pick an icon preset or type an icon code name (e.g.: terminal, html, css, javascript, database, psychology, shield, phone_android).';

  @override
  String get tFormExampleIcon => 'Example: terminal';

  @override
  String get tFormFieldTopic => 'Topic / Curriculum Track *';

  @override
  String get tFormFieldLevel => 'Difficulty Level *';

  @override
  String get tFormDraftNotice =>
      'New lessons are saved as Draft. A lesson is only visible to students after you press the \"Publish\" button.';

  @override
  String get tFormSaveDraft => 'Save Draft';

  @override
  String get tFormContinueBabs => 'Continue to Chapters';

  @override
  String get tSlideNotFound =>
      'Slide not found. Open the Chapter Builder to choose another slide.';

  @override
  String tSlideTemplateApplied(String label) {
    return 'Starter template \"$label\" applied.';
  }

  @override
  String get tSlideBabUnsaved =>
      'New chapter not saved yet. Add slides from the Chapter Builder so they save together with the chapter.';

  @override
  String get tSlideSaveNoBab =>
      'Slide cannot be saved. Open the Chapter Builder to reload the chapter.';

  @override
  String get tSlideSaveFailed => 'Slide failed to save. Try again.';

  @override
  String get tSlideSaved => 'Slide saved to chapter.';

  @override
  String get tSlideEditorTitle => 'Slide Editor';

  @override
  String get tSlideLoadFailedTitle => 'Slide Could Not Be Loaded';

  @override
  String get tSlideOpenBabBuilder => 'Open Chapter Builder';

  @override
  String get tSlidePreviewTooltip => 'Preview slide';

  @override
  String tSlideHeader(int index, String label) {
    return 'Slide $index • $label';
  }

  @override
  String get tSlidePreviewAsStudent => 'Preview as Student';

  @override
  String get tSlideUseTemplate => 'Use Starter Template';

  @override
  String get tSlideSave => 'Save Slide';

  @override
  String tSlideTooLong(String label, int max) {
    return '$label is too long (maximum $max characters).';
  }

  @override
  String tSlideRequired(String label) {
    return '$label is required.';
  }

  @override
  String tSlideMaxItems(String label, int limit) {
    return '$label allows at most $limit items.';
  }

  @override
  String tSlideChoiceEmpty(String letter, String label) {
    return 'Choice $letter in $label is still empty.';
  }

  @override
  String tSlideChoiceKey(String label) {
    return 'Pick one answer key A–D in $label.';
  }

  @override
  String tSlideSlotEmpty(int n) {
    return 'Slot answer key $n is still empty.';
  }

  @override
  String get tSlideTapMarkerMissing =>
      'Question code has no [KETIK_DISINI] marker as the place for students to type.';

  @override
  String get tSlideBugHintOrFix =>
      'Fill in \"Indicator Message\" or \"Valid Fix Code\" so students get an explanation after answering.';

  @override
  String get tSlideConceptRequired => 'Fill in at least one mastered concept.';

  @override
  String get tSlideTemplateNoSlot =>
      'Code template has no slot yet. Mark empty parts with ___1___, ___2___, and so on.';

  @override
  String get tSlideDistractorRequired =>
      'Add at least one distractor so the question can be answered.';

  @override
  String get tSlideDistractorsSame =>
      'All distractors match the answer key. Add another choice.';

  @override
  String get tSlideTargetNotNumber => 'Target line number must be a number.';

  @override
  String tSlideTargetRange(int n) {
    return 'Target line number must be between 1 and $n matching the number of code lines.';
  }

  @override
  String get tSlideFieldExerciseTitle => 'Exercise title';

  @override
  String get tSlideFieldInstruction => 'Instruction';

  @override
  String get tSlideFieldQuestionTitle => 'Question title';

  @override
  String get tSlideFieldQuestionCode => 'Question code';

  @override
  String get tSlideFieldAnswerKeyword => 'Answer keyword';

  @override
  String get tSlideFieldHint => 'Hint';

  @override
  String get tSlideFieldSlideTitle => 'Slide title';

  @override
  String get tSlideFieldCodeBlock => 'Code block';

  @override
  String get tSlideFieldOutputChoices => 'output choices';

  @override
  String get tSlideFieldExplanation => 'Explanation';

  @override
  String get tSlideFieldChallengeTitle => 'Challenge title';

  @override
  String get tSlideFieldScenario => 'Scenario';

  @override
  String get tSlideFieldProgramCode => 'Program code';

  @override
  String get tSlideFieldErrorType => 'Error type';

  @override
  String get tSlideFieldBugHint => 'Indicator message';

  @override
  String get tSlideFieldFixCode => 'Fix code';

  @override
  String get tSlideFieldQuizQuestion => 'Quiz question';

  @override
  String get tSlideFieldAnswerChoices => 'answer choices';

  @override
  String get tSlideFieldFeedback => 'Feedback';

  @override
  String get tSlideFieldOutroTitle => 'Closing slide title';

  @override
  String get tSlideFieldSummary => 'Lesson summary';

  @override
  String get tSlideFieldMasteredConcepts => 'Mastered concepts';

  @override
  String get tSlideFieldTheoryTitle => 'Theory lesson title';

  @override
  String get tSlideFieldTheoryContent => 'Explanation content';

  @override
  String get tSlideFieldSampleCode => 'Sample code snippet';

  @override
  String get tSlideFieldCodeLanguage => 'Code language';

  @override
  String get tSlideFieldCodeTemplate => 'Code template';

  @override
  String get tSlideFieldAnswerKey => 'Answer key';

  @override
  String get tSlideFieldSlotAnswer => 'Slot answer key';

  @override
  String get tSlideFieldDistractors => 'Distractors';

  @override
  String get tSlideFieldTargetLine => 'Target line number';

  @override
  String get tBabNotFound =>
      'Chapter not found. Open the chapter list to choose another chapter.';

  @override
  String get tBabSlideEmptyHint =>
      'No content yet. Tap Edit Slide Content to start.';

  @override
  String get tBabMinSlides => 'A chapter must have at least 1 slide.';

  @override
  String get tBabTitleRequired => 'Chapter name is required.';

  @override
  String get tBabUpdated => 'Chapter updated successfully.';

  @override
  String get tBabCreated => 'New chapter added successfully.';

  @override
  String get tBabMinSlidesPreview =>
      'A chapter needs at least 1 slide to simulate.';

  @override
  String get tBabPreviewFallback => 'Chapter Preview';

  @override
  String get tBabEditTitle => 'Edit Chapter';

  @override
  String get tBabLoadFailedTitle => 'Chapter Could Not Be Loaded';

  @override
  String get tBabOpenList => 'Open Chapter List';

  @override
  String get tBabBuilderTitle => 'Chapter Builder';

  @override
  String get tBabFieldName => 'Chapter Name *';

  @override
  String get tBabExampleName =>
      'Example: Introduction to HTML Tags & Documents';

  @override
  String get tBabXpTitle => 'Chapter Reward XP';

  @override
  String get tBabXpHint => 'Given when a student completes the chapter';

  @override
  String get tBabFlowTitle => 'Slide Flow';

  @override
  String tBabSlideCount(int count) {
    return '$count Units';
  }

  @override
  String get tBabAddSlide => 'Add Slide';

  @override
  String get tBabDeleteSlide => 'Delete slide';

  @override
  String get tBabEditSlideContent => 'Edit Slide Content';

  @override
  String get tBabSaveChanges => 'Save Chapter Changes';

  @override
  String get tBabSaveNew => 'Save New Chapter';

  @override
  String get tBabPickerTitle => 'Choose New Slide Type';

  @override
  String tBabFormatCount(int count) {
    return '$count Formats';
  }

  @override
  String get tBabPickerHint =>
      'Tap the eye icon to see a coding simulation preview, or pick directly to add to the chapter flow.';

  @override
  String get tBabPreviewFormatTooltip => 'Interactive Format Preview';

  @override
  String get tBabPickerAddTooltip => 'Add Slide';

  @override
  String get tBabBentoTitle => 'Choose Slide Type / Coding Exercise';

  @override
  String get tBabBentoHint =>
      'Tap \"Preview\" for a student coding simulation, or press \"Use\" to insert into the chapter flow.';

  @override
  String get tBabPreviewButton => 'Preview';

  @override
  String get tBabUseButton => 'Use';

  @override
  String get tBabTypeTheoryName => 'Theory & Concepts';

  @override
  String get tBabTypeTapName => 'Complete Code';

  @override
  String get tBabTypeTypeName => 'Type Keywords';

  @override
  String get tBabTypeOutputName => 'Guess Output';

  @override
  String get tBabTypeBugName => 'Bug Hunter';

  @override
  String get tBabTypeQuizName => 'Multiple Choice Quiz';

  @override
  String get tBabTypeOutroName => 'Summary & XP Claim';

  @override
  String get tBabTypeTheoryBadge => 'Reading Lesson';

  @override
  String get tBabTypeTapBadge => 'Interactive';

  @override
  String get tBabTypeTypeBadge => 'Syntax';

  @override
  String get tBabTypeOutputBadge => 'Logic';

  @override
  String get tBabTypeBugBadge => 'Debugging';

  @override
  String get tBabTypeQuizBadge => 'Evaluation';

  @override
  String get tBabTypeOutroBadge => 'Achievement';

  @override
  String get tBabSheetDescTheory =>
      'Concept explanation text & visual code examples.';

  @override
  String get tBabSheetDescTap =>
      'Students tap block pieces to complete a code line.';

  @override
  String get tBabSheetDescType =>
      'Practice typing keywords or syntax expressions.';

  @override
  String get tBabSheetDescOutput =>
      'Students analyze a snippet and predict the terminal output.';

  @override
  String get tBabSheetDescBug =>
      'Challenge to fix writing or coding logic errors.';

  @override
  String get tBabSheetDescQuiz =>
      'Comprehension evaluation questions with 4 choices.';

  @override
  String get tBabSheetDescOutro =>
      'Chapter closing slide with achievement summary and rewards.';

  @override
  String get tBabBentoDescTheory =>
      'Structured reading text, explanation markdown, and code examples.';

  @override
  String get tBabBentoDescTap =>
      'Fill-in-the-blanks with guided code-piece tokens.';

  @override
  String get tBabBentoDescType =>
      'Muscle-memory practice typing specific syntax keywords.';

  @override
  String get tBabBentoDescOutput =>
      'Analyze code lines and predict the terminal output.';

  @override
  String get tBabBentoDescBug =>
      'Find the broken code line and determine its fix.';

  @override
  String get tBabBentoDescQuiz =>
      'Conceptual questions with 4 choices and discussion.';

  @override
  String get pyErrStringUnclosed => 'SyntaxError: string not closed';

  @override
  String pyErrFStringCloseBrace(String brace) {
    return 'SyntaxError: f-string: $brace not found';
  }

  @override
  String get pyErrFStringEmptyExpr => 'SyntaxError: f-string: empty expression';

  @override
  String pyErrFStringStrayBrace(String brace) {
    return 'SyntaxError: f-string: $brace outside a placeholder';
  }

  @override
  String get pyErrFStringUnclosed => 'SyntaxError: f-string not closed';

  @override
  String get pyErrTimeoutSeconds =>
      'RuntimeError: program stopped (exceeded the 5-second limit)';

  @override
  String get pyErrStepLimit =>
      'RuntimeError: program stopped — exceeded 100,000 steps (check for an endless loop)';

  @override
  String get pyErrBreakOutsideLoop => 'SyntaxError: \"break\" outside a loop';

  @override
  String get pyErrContinueOutsideLoop =>
      'SyntaxError: \"continue\" outside a loop';

  @override
  String get pyErrReturnOutsideFunction =>
      'SyntaxError: \'return\' outside a function';

  @override
  String get pyErrElifWithoutIf =>
      'SyntaxError: invalid syntax (elif/else without if)';

  @override
  String pyErrInvalidParam(String param) {
    return 'SyntaxError: invalid parameter -> $param';
  }

  @override
  String get pyErrInputNeedsDialog =>
      'RuntimeError: input() needs a dialog — run from the Playground page';

  @override
  String get pyErrSumNeedsList =>
      'TypeError: sum() requires a list as its first argument';

  @override
  String pyErrUnknownOperator(String op) {
    return 'TypeError: operator \'$op\' not recognized';
  }

  @override
  String tAnalyticsCodeCopied(String code) {
    return 'Class code \"$code\" copied to clipboard!';
  }

  @override
  String get tAnalyticsRemoveTitle => 'Remove Student';

  @override
  String tAnalyticsRemoveBody(String name, String className) {
    return 'Remove $name from $className?\n\nThe student will no longer appear in the class list and rankings. They can rejoin with the class code.';
  }

  @override
  String get tAnalyticsThisClass => 'this class';

  @override
  String get tAnalyticsRemoveConfirm => 'Remove';

  @override
  String tAnalyticsClassOptions(String name) {
    return 'Class Options: $name';
  }

  @override
  String get tAnalyticsRegenerateCode => 'Regenerate Class Code';

  @override
  String get tAnalyticsRegenerateCodeSub => 'Generate a new class code.';

  @override
  String get tAnalyticsArchiveClass => 'Archive Class';

  @override
  String get tAnalyticsArchiveClassSub => 'Students can no longer join.';

  @override
  String tAnalyticsHintMaterialSuffix(String title) {
    return ' who completed \"$title\"';
  }

  @override
  String tAnalyticsHintCompleted(String suffix) {
    return 'Completed Lessons = students who completed at least one lesson$suffix, sorted by most completed lessons.';
  }

  @override
  String get tAnalyticsPracticeRegular =>
      'regular practice (not mini projects)';

  @override
  String get tAnalyticsPracticeMini => 'mini project';

  @override
  String get tAnalyticsPracticeAny => 'any practice (regular + mini project)';

  @override
  String tAnalyticsHintPractice(String type, String suffix) {
    return 'Most Practice = students who passed at least one $type$suffix, sorted by most passed practices.';
  }

  @override
  String get tAnalyticsNotStartedMaterial => 'have not completed any lesson';

  @override
  String get tAnalyticsNotStartedPractice => 'have not finished any practice';

  @override
  String get tAnalyticsNotStartedBoth =>
      'have not completed lessons and have not finished practices';

  @override
  String tAnalyticsHintNotStarted(String scope, String suffix) {
    return 'Not Started = students who $scope$suffix, sorted by most active in practice.';
  }

  @override
  String tAnalyticsHintAll(String suffix) {
    return 'All = all class members$suffix, sorted by most completed lessons then passed practices.';
  }

  @override
  String get tAnalyticsFilterByMaterial => 'Filter Student List by Lesson';

  @override
  String get tAnalyticsFilterByMaterialHint =>
      'The number on each button = students who completed that lesson.';

  @override
  String tAnalyticsFilterAllMaterials(int count) {
    return 'All Lessons ($count)';
  }

  @override
  String tAnalyticsFilterMaterialCount(String title, int count) {
    return '$title ($count)';
  }

  @override
  String get tAnalyticsTrackBasisTitle => 'Track Progress Score Basis';

  @override
  String get tAnalyticsTrackBasisBody =>
      'Each track percentage = the average progress_percent of all class students across ALL official lessons (built-in curriculum) in that track.\n\n• Each student × lesson pair counts as one row, including lessons never opened (counted as 0%).\n• 100% means all class students completed all lessons in that track.\n• Teacher-made lessons are not counted (official curriculum only).\n• This number measures lesson completion, not practice scores.';

  @override
  String get tAnalyticsGotIt => 'Got it';

  @override
  String get tAnalyticsNoStudents => 'No students yet.';

  @override
  String get tAnalyticsTitle => 'Class Analytics';

  @override
  String get tAnalyticsClassOptionsLabel => 'Class Options';

  @override
  String get tAnalyticsLoading => 'Loading class analytics data...';

  @override
  String get tAnalyticsEmptyBody =>
      'Create your first class in the Dashboard to monitor curriculum analytics and student learning progress.';

  @override
  String get tAnalyticsLabClass => 'Laboratory Class';

  @override
  String tAnalyticsAcademicYear(String year) {
    return 'Academic Year $year';
  }

  @override
  String get tAnalyticsClassCode => 'Class Code';

  @override
  String get tAnalyticsReadyJoin => 'Ready to Join';

  @override
  String get tAnalyticsShareCodeHint =>
      'Share this code so students can join the class:';

  @override
  String get tAnalyticsEnlarge => 'Enlarge ↗';

  @override
  String get tAnalyticsTrackTitle => 'Curriculum Progress per Track';

  @override
  String get tAnalyticsTrackTooltip =>
      'Average progress of all class students across all official lessons in this track (unopened lessons = 0%).';

  @override
  String get tAnalyticsTrackSubtitle =>
      'Average completion of all class students across all official lessons in that track.';

  @override
  String get tAnalyticsTrackEmpty =>
      'Track data will fill in automatically once students start learning.';

  @override
  String get tAnalyticsHardestTitle => 'Hardest Chapters (Need Guidance)';

  @override
  String get tAnalyticsHardestEmpty =>
      'No challenges detected as difficult in this class 🎉';

  @override
  String tAnalyticsFailCount(int count) {
    return '$count students failed';
  }

  @override
  String get tAnalyticsRankingTitle => 'Class Student Rankings';

  @override
  String tAnalyticsRankingTop(int top, int total) {
    return 'Top $top of $total';
  }

  @override
  String tAnalyticsStudentCount(int count) {
    return '$count Students';
  }

  @override
  String tAnalyticsRankingHint(int max) {
    return 'Rankings show at most $max students with the most lessons/practices. All students still appear in full in the Student List section.';
  }

  @override
  String get tAnalyticsRankMaterial => 'Lessons';

  @override
  String get tAnalyticsRankMaterialSub => 'Completed lessons';

  @override
  String get tAnalyticsRankPractice => 'Practice';

  @override
  String get tAnalyticsRankPracticeSub => 'Passed challenges';

  @override
  String get tAnalyticsRosterTitle => 'Student List';

  @override
  String tAnalyticsFilterAllCount(int count) {
    return 'All ($count)';
  }

  @override
  String tAnalyticsFilterCompletedCount(int count) {
    return 'Completed Lessons ($count)';
  }

  @override
  String get tAnalyticsFilterPractice => 'Most Practice';

  @override
  String tAnalyticsFilterNotStartedCount(int count) {
    return 'Not Started ($count)';
  }

  @override
  String get tAnalyticsPracticeAll => 'All Practices';

  @override
  String get tAnalyticsPracticeRegularLabel => 'Regular Practice';

  @override
  String get tAnalyticsNotStartedAll => 'Lessons & Practices';

  @override
  String get tAnalyticsNotStartedMaterialLabel => 'Lessons Not Done';

  @override
  String get tAnalyticsNotStartedPracticeLabel => 'Practices Not Finished';

  @override
  String get tAnalyticsRosterEmpty => 'No students have joined this class yet.';

  @override
  String get tAnalyticsRosterFilterEmpty =>
      'No students in this filter category.';

  @override
  String tAnalyticsRowPracticeDetail(int materials, int regular, int mini) {
    return '$materials lessons completed • $regular regular practices • $mini mini projects';
  }

  @override
  String tAnalyticsRowDetail(int materials, int practice) {
    return '$materials lessons completed • $practice practices passed';
  }

  @override
  String tAnalyticsXp(int xp) {
    return '$xp XP';
  }

  @override
  String get tAnalyticsRemoveFromClass => 'Remove from class';

  @override
  String get tSlideFormHelpTheoryTitle =>
      'The title appears at the very top of the student screen.\n- Keep it concise and specific, max 120 characters.\n- Name the core concept, not the chapter name.';

  @override
  String get tSlideFormHelpTheoryContent =>
      'How to write lesson content:\n- Separate paragraphs with one blank line.\n- Lines starting with \"- \" or \"* \" automatically become list items.\n- Otherwise text is shown as-is: **bold**, # headings, links, and `code` are not formatted.\n\nExample:\nHTML is a markup language for building web pages.\n\n- Tags are opened then closed.\n- Attributes attach to the opening tag.';

  @override
  String get tSlideFormHelpCodeFileSample =>
      'Only determines the file name on the code card:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py';

  @override
  String get tSlideFormHelpSampleCode =>
      'Sample code shown in the code box below the explanation.\n- Leave empty if the slide needs no code sample.\n- Write the raw code only, without markdown block markers.\n- Max 8000 characters.';

  @override
  String get tSlideFormHelpExerciseTitle =>
      'The title appears in the exercise header, max 120 characters.\nExample: \"Complete the HTML Closing Tag\".';

  @override
  String get tSlideFormHelpShortInstruction =>
      'One or two sentences of guidance before the student taps a slot.\n- Explain which part must be completed.\n- Do not mention the answer here.';

  @override
  String get tSlideFormHelpCodeTemplate =>
      'Paste code here, then mark blanks with ___1___, ___2___, and so on.\n- Markers are recognized as long as they use at least two underscores at the start and end, with an optional number in the middle.\n- Slot order follows their order of appearance in the code.\n- One slot means one answer; do not place two slots for the same answer.\n\nExample:\nx = ___1___\nprint(x)';

  @override
  String get tSlideFormHelpSlotAnswers =>
      'Fill in the correct answer for each slot in order of appearance.\n- Leading/trailing spaces are ignored, but letter case matters: write \"print\", not \"Print\".\n- Write exactly what should appear in the code.\n- The number of entries follows the number of detected slots.';

  @override
  String get tSlideFormHelpDistractors =>
      'Extra words that appear as choices, but are not the correct answer.\n- Separate with commas.\n- Distractors identical to the key are discarded automatically.\n- Keep at least one so students really have to choose.';

  @override
  String get tSlideFormHelpCodeFile =>
      'Determines the file name on the code card:\n- HTML → index.html\n- CSS → style.css\n- JavaScript → script.js\n- Python → script.py';

  @override
  String get tSlideFormHelpQuestionTitle =>
      'The title appears in the exercise header, max 120 characters.\nExample: \"Python Variable Declaration\".';

  @override
  String get tSlideFormHelpInteractiveInstruction =>
      'Brief guidance students read before typing.\n- Say what to look for without giving the answer.\n- Max 300 characters.';

  @override
  String get tSlideFormHelpQuestionCode =>
      'Write a code snippet, then replace the part to fill in with [KETIK_DISINI].\n- That marker becomes an input box on the student screen.\n- More than one marker per slide is allowed.\n- Without a marker, students have nowhere to type an answer.';

  @override
  String get tSlideFormHelpAnswerKeyword =>
      'The answer considered correct.\n- Comparison ignores leading/trailing spaces and letter case, so \"Print\" equals \"print\".\n- Enter a single keyword or short expression only.';

  @override
  String get tSlideFormHelpWrongHint =>
      'Help shown when a student answer is wrong.\n- Give directional hints, do not write the answer directly.\n- One or two sentences are enough.';

  @override
  String get tSlideFormHelpSlideTitle =>
      'The title appears in the slide header, max 120 characters.\nExample: \"Guess the Modulo Operator Output\".';

  @override
  String get tSlideFormHelpChallengeInstruction =>
      'A short question above the code block.\nUsually enough: \"What output is printed to the terminal?\".';

  @override
  String get tSlideFormHelpSourceCode =>
      'Code students read to guess the output.\n- Write it exactly like the original program.\n- Code is only displayed, not run, so the result must be guessable from the code content.';

  @override
  String get tSlideFormHelpOutputChoices =>
      'Fill in all four choices (A to D).\n- Tap the circle on the left to mark the answer key.\n- One choice must exactly match the actual output.\n- Do not leave choices empty: empty choices still appear on the student screen.';

  @override
  String get tSlideFormHelpOutputExplanation =>
      'Appears after students answer, right or wrong.\nExplain why that output appears, e.g. operation order or the data types involved.';

  @override
  String get tSlideFormHelpChallengeTitle =>
      'The title appears in the challenge header, max 120 characters.\nExample: \"Finding the For Loop Bug\".';

  @override
  String get tSlideFormHelpScenario =>
      'Brief context of the problem students face; shown as instructions above the code.\nDescribe the situation, do not mention the wrong line number.';

  @override
  String get tSlideFormHelpBuggyCode =>
      'The full code containing the bug.\n- Line numbers count from 1 following the line order in this box, including blank lines.\n- Insert a bug that can genuinely be explained by \"Error Type\" and \"Fix Code\".';

  @override
  String get tSlideFormHelpTargetLine =>
      'The correct line number, counted from 1.\n- Must be between 1 and the number of code lines above.\n- If out of range, the student screen locks to the nearest line so answers never match.';

  @override
  String get tSlideFormHelpErrorType =>
      'Error category label shown to students.\nExample: SyntaxError, IndentationError, NameError.';

  @override
  String get tSlideFormHelpBugHint =>
      'This text becomes the explanation shown after students answer.\n- Explain the rule violated on that line.\n- If left empty, \"Valid Fix Code\" is used as the explanation.';

  @override
  String get tSlideFormHelpFixCode =>
      'The correct fix snippet for the marked line.\n- Used as a solution example and backup explanation when \"Indicator Message\" is empty.\n- Write only the fixed part, not the whole program.';

  @override
  String get tSlideFormHelpQuizTitle =>
      'The title appears in the quiz header, max 120 characters.\nExample: \"Understanding Data Types\".';

  @override
  String get tSlideFormHelpQuizQuestion =>
      'A question with one correct answer.\n- Ask about a single concept only, do not combine.\n- Max 300 characters.';

  @override
  String get tSlideFormHelpAnswerChoices =>
      'Fill in all four choices (A to D).\n- Tap the circle on the left to mark the answer key.\n- Do not leave choices empty, as they still appear as empty options on the student screen.';

  @override
  String get tSlideFormHelpFeedback =>
      'Appears after students answer, right or wrong.\nExplain why the answer key is correct and, if needed, why the distractors are wrong.';

  @override
  String get tSlideFormHelpOutroTitle =>
      'The title appears in the closing slide header, max 120 characters.\nExample: \"Chapter Summary\".';

  @override
  String get tSlideFormHelpSummary =>
      'A summary students read at the end of the chapter.\n- Revisit the main concepts just learned.\n- Give a motivating close, not a new question.';

  @override
  String get tSlideFormHelpMasteredConcepts =>
      'List of concepts considered mastered after this chapter.\n- Separate with commas, e.g.: Variables, Loops.\n- Each concept appears as an achievement label.\n- Enter at least one concept.';

  @override
  String get tSlideFormHintTheoryTitleExample =>
      'Example: Basic HTML5 Document Structure';

  @override
  String get tSlideFormHintTheoryContent =>
      'Write the main concepts, bullet points, or examples...';

  @override
  String get tSlideFormHintExerciseTitleExample =>
      'Example: Complete the HTML Closing Tag';

  @override
  String get tSlideFormHintShortInstruction =>
      'Work instructions for students...';

  @override
  String get tSlideFormHintQuestionTitleExample =>
      'Example: Python Variable Declaration';

  @override
  String get tSlideFormHintInteractiveInstruction =>
      'Type the keyword to declare a variable...';

  @override
  String get tSlideFormHintAnswerKeywordExample => 'Example: def / const / let';

  @override
  String get tSlideFormHintWrongHint => 'Remember, all lowercase writing.';

  @override
  String get tSlideFormHintSlideTitleExample =>
      'Example: Guess the Modulo Operator Output';

  @override
  String get tSlideFormHintChallengeInstruction =>
      'What output is printed to the terminal?';

  @override
  String get tSlideFormHintOutputExplanation => 'Why does that output appear?';

  @override
  String get tSlideFormHintChallengeTitleExample =>
      'Example: Finding the For Loop Bug';

  @override
  String get tSlideFormHintScenario => 'Describe the problem context...';

  @override
  String get tSlideFormHintTargetLineExample => 'Example: 2';

  @override
  String get tSlideFormHintBugHint =>
      'Missing colon (:) at the end of the for statement';

  @override
  String get tSlideFormHintQuizTitleExample =>
      'Example: Understanding Data Types';

  @override
  String get tSlideFormHintQuizQuestion => 'Write a conceptual question...';

  @override
  String get tSlideFormHintFeedback => 'Why is that option correct?';

  @override
  String get tSlideFormHintOutroTitleExample => 'Example: Chapter Summary';

  @override
  String get tSlideFormHintSummary =>
      'Summary of student achievements after completing the chapter...';

  @override
  String get tSlideFormHintMasteredConcepts => 'Variables, Branching, Loops';

  @override
  String tSlideFormSlotAnswerCount(int count) {
    return 'Answer key per slot ($count slots detected)';
  }

  @override
  String tSlideFormSlot(int n) {
    return 'Slot $n';
  }

  @override
  String tSlideFormSlotAnswerHint(int n) {
    return 'Correct answer for slot $n';
  }

  @override
  String get tSlideFormNoSlotsHint =>
      'Add markers ___1___, ___2___, and so on to the template.';

  @override
  String tSlideFormXpNote(int xp) {
    return 'Students automatically claim $xp XP when reaching this slide.';
  }

  @override
  String get tPreviewInteractiveFormat => 'Interactive Format Preview';

  @override
  String tPreviewSheetTitle(String title) {
    return 'Slide Type Preview: $title';
  }

  @override
  String get tPreviewBenefits => 'Pedagogical Benefits';

  @override
  String get tPreviewReward => 'Student Reward';

  @override
  String get tPreviewModuleType => 'Module Type';

  @override
  String get tPreviewUseType => 'Use This Type';

  @override
  String get tPreviewSimulation => 'Active Student Simulation';

  @override
  String get tPreviewPhoneScreen => 'Phone Screen';

  @override
  String get tPreviewAnswerChoices => 'Answer choices for students:';

  @override
  String get tPreviewSubtitleTapToFill =>
      'A simulation of how students interact with this exercise live on their phone.';

  @override
  String get tPreviewTechTapToFill => 'HTML • V1.2';

  @override
  String get tPreviewPromptTapToFill =>
      'Complete the correct closing tag: Line 4';

  @override
  String get tPreviewFeedbackTapToFill =>
      'Students get instant feedback when choosing code pieces.';

  @override
  String get tPreviewBenefitTapToFill =>
      'Trains basic syntax mastery without the burden of long typing on a phone touchscreen keyboard.';

  @override
  String get tPreviewSubtitleTheory =>
      'Structured reading text, explanatory markdown, and sample code snippets.';

  @override
  String get tPreviewTechTheory => 'Markdown • Theory';

  @override
  String get tPreviewPromptTheory => 'Opening Lesson & Logic Introduction';

  @override
  String get tPreviewFeedbackTheory =>
      'Supports Markdown format, syntax highlighter, and teacher tip callout boxes.';

  @override
  String get tPreviewBenefitTheory =>
      'Builds a strong conceptual understanding foundation before students enter interactive practice sessions.';

  @override
  String get tPreviewSubtitleTypeCode =>
      'Muscle-memory practice for typing specific syntax keywords.';

  @override
  String get tPreviewTechTypeCode => 'Python • Syntax';

  @override
  String get tPreviewPromptTypeCode =>
      'Type the keyword to create a function in Python:';

  @override
  String get tPreviewFeedbackTypeCode =>
      'Equipped with case-sensitive validation and automatic hints when students err.';

  @override
  String get tPreviewBenefitTypeCode =>
      'Accustoms students to precise syntax writing and trains careful typing of reserved words.';

  @override
  String get tPreviewSubtitleOutputPredict =>
      'Students analyze program lines and predict the terminal run output.';

  @override
  String get tPreviewTechOutputPredict => 'Console • Logic';

  @override
  String get tPreviewPromptOutputPredict =>
      'What output is printed by the following modulus operation?';

  @override
  String get tPreviewFeedbackOutputPredict =>
      'Dark terminal console-styled options for a realistic simulation.';

  @override
  String get tPreviewBenefitOutputPredict =>
      'Trains mental algorithm execution and variable tracing without debugger dependence.';

  @override
  String get tPreviewTitleBugHunter => 'Bug Hunter (Find Errors)';

  @override
  String get tPreviewSubtitleBugHunter =>
      'A challenge to find the broken line of code and fix it.';

  @override
  String get tPreviewTechBugHunter => 'Python • Debug';

  @override
  String get tPreviewPromptBugHunter =>
      'Find the line containing the syntax error:';

  @override
  String get tPreviewFeedbackBugHunter =>
      'Students tap the problematic line number to trigger AI guidance.';

  @override
  String get tPreviewBenefitBugHunter =>
      'Sharpens problem-solving intuition and the ability to read other people\'s code, the core skill of a developer.';

  @override
  String get tPreviewSubtitleQuiz =>
      'Comprehension evaluation questions with 4 options and discussion.';

  @override
  String get tPreviewTechQuiz => 'Evaluation • Concepts';

  @override
  String get tPreviewPromptQuiz =>
      'What is the main function of the <!DOCTYPE html> declaration?';

  @override
  String get tPreviewFeedbackQuiz =>
      'Equipped with automatic discussion shown after students answer.';

  @override
  String get tPreviewBenefitQuiz =>
      'Measures lesson absorption objectively and quickly at the end of the discussion session.';

  @override
  String get tPreviewSubtitleOutro =>
      'Chapter closing slide with a recap of mastered lesson and reward claims.';

  @override
  String get tPreviewTechOutro => 'Achievement • Closing';

  @override
  String get tPreviewPromptOutro =>
      'Congratulations! You have completed all exercises in this chapter.';

  @override
  String get tPreviewFeedbackOutro =>
      'Automatically created at the end of the chapter learning flow.';

  @override
  String get tPreviewBenefitOutro =>
      'Provides achievement satisfaction (gamification) and summarizes key lesson points.';

  @override
  String get tSettingsAvatarTooBig => 'Photo size must be at most 2 MB.';

  @override
  String get tSettingsFallbackTeacher => 'Teacher';

  @override
  String tSettingsNameDegree(String name) {
    return '$name & Degree *';
  }

  @override
  String get tSettingsIdentityTitle => 'Teacher Identity';

  @override
  String get tSettingsBioContact => 'Bio & Contact';

  @override
  String get tSettingsBioHint =>
      'Write your teaching experience or coding specialization...';

  @override
  String get tSettingsAddressHint => 'Teacher residential address';

  @override
  String get tSettingsSecurityTitle => 'Account Security';

  @override
  String get tSettingsChangePassword => 'Change Password';

  @override
  String get tFieldHelpGotIt => 'Got it';

  @override
  String get tTeacherErrServerFallback =>
      'There was a problem with the server.';

  @override
  String get tTeacherErrInvalidLesson => 'Invalid lesson data format.';

  @override
  String get tTeacherErrInvalidBab => 'Invalid chapter data format.';

  @override
  String get tTeacherErrInvalidClass => 'Invalid class data format.';

  @override
  String tCubitClassCreated(String name) {
    return 'Class $name created successfully.';
  }

  @override
  String get tCubitClassArchived => 'Class moved to archive.';

  @override
  String get tCubitClassRestored => 'Class restored successfully.';

  @override
  String tCubitClassCodeNew(String code) {
    return 'New class code: $code';
  }

  @override
  String get tCubitLessonCreated => 'New lesson created successfully.';

  @override
  String get tCubitLessonPublished => 'Lesson published successfully.';

  @override
  String get tCubitLessonDrafted => 'Lesson returned to draft.';

  @override
  String get tCubitLessonDeleted => 'Lesson deleted successfully.';

  @override
  String get tCubitLessonDuplicated => 'Lesson duplicated successfully.';

  @override
  String tCubitBabDuplicated(String title) {
    return 'Chapter \"$title\" duplicated successfully.';
  }

  @override
  String get tCubitBabDeleted => 'Chapter deleted successfully.';

  @override
  String get tCubitBabOrderUpdated => 'Chapter order updated.';

  @override
  String get tCubitStudentRemoved => 'Student removed from class.';

  @override
  String tCubitStudentRemovedNamed(String name) {
    return '$name removed from class.';
  }

  @override
  String get tCubitConnectionFailed =>
      'Failed to connect to the server. Check your connection and try again.';

  @override
  String get tAdapterEmptyBab => 'This chapter has no slides yet.';

  @override
  String get tAdapterPreviewTopic => 'Teacher Preview';

  @override
  String get tAdapterPreviewMode => 'Teacher Preview Simulator Mode';

  @override
  String get tAdapterTypeCodeInstruction => 'Complete the following code:';

  @override
  String get tAdapterOutputQuestion => 'What is the output of the code above?';

  @override
  String get tAdapterBugInstruction => 'Find the problematic line:';

  @override
  String get tAdapterBugExplanation => 'Check the syntax on this line.';

  @override
  String get tAdapterQuizQuestion => 'Quiz question:';

  @override
  String get tAdapterOutroSummary =>
      'Congratulations! You have completed this chapter.';

  @override
  String get tAdapterLearningTime => '3 Minutes';

  @override
  String get tAdapterMainConcept => 'Main Concept';

  @override
  String get tTemplateLabelTapToFill => 'Complete Code (Tap)';

  @override
  String get tTemplateLabelTypeCode => 'Type Keywords';

  @override
  String get tTemplateLabelOutputPredict => 'Guess Code Output';

  @override
  String get tTemplateLabelBugHunter => 'Bug Hunter';

  @override
  String get tTemplateLabelQuiz => 'Multiple Choice Quiz';

  @override
  String get tTemplateLabelOutro => 'Summary & Claim XP';

  @override
  String get tTemplateLabelTheory => 'Theory & Concepts';

  @override
  String get tTemplateBadgeInteractive => 'Interactive';

  @override
  String get tTemplateBadgeSyntax => 'Syntax';

  @override
  String get tTemplateBadgeLogic => 'Logic';

  @override
  String get tTemplateBadgeDebugging => 'Debugging';

  @override
  String get tTemplateBadgeEvaluation => 'Evaluation';

  @override
  String get tTemplateBadgeAchievement => 'Achievement';

  @override
  String get tTemplateBadgeReading => 'Reading Lesson';

  @override
  String get tTemplateDescTapToFill =>
      'Students tap block pieces to complete lines of code.';

  @override
  String get tTemplateDescTypeCode =>
      'Students type keywords or syntax expressions.';

  @override
  String get tTemplateDescOutputPredict =>
      'Students predict terminal output from a code snippet.';

  @override
  String get tTemplateDescBugHunter =>
      'Students find the problematic line and its fix.';

  @override
  String get tTemplateDescQuiz =>
      'Multiple choice questions with one correct answer.';

  @override
  String get tTemplateDescOutro => 'Closing slide with summary and XP rewards.';

  @override
  String get tTemplateDescTheory =>
      'Explanatory text of lesson concepts and code examples.';

  @override
  String get tTemplateTitleTapToFill => 'Complete the Code';

  @override
  String get tTemplatePromptTapToFill =>
      'Tap the code blocks to complete the following lines.';

  @override
  String get tTemplatePromptTypeCode =>
      'Type the function to print text to the screen:';

  @override
  String get tTemplateHintTypeCode => 'Use all lowercase letters.';

  @override
  String get tTemplateTitleOutputPredict => 'Guess the Output';

  @override
  String get tTemplatePromptOutputPredict =>
      'What output is printed to the terminal?';

  @override
  String get tTemplateExplanationOutputPredict =>
      'The + operator adds two integers.';

  @override
  String get tTemplateTitleBugHunter => 'Find the Bug';

  @override
  String get tTemplateScenarioBugHunter =>
      'Students examine a program that fails to run.';

  @override
  String get tTemplateBugHintBugHunter =>
      'Check the colon at the end of the for line.';

  @override
  String get tTemplateQuestionQuiz => 'Which one is an integer data type?';

  @override
  String get tTemplateExplanationQuiz => 'int is an integer data type.';

  @override
  String get tTemplateTitleOutro => 'Chapter Summary';

  @override
  String get tTemplateSummaryOutro =>
      'Great! You have completed the lesson in this chapter.';

  @override
  String get tTemplateTitleTheory => 'New Lesson Explanation';

  @override
  String get tTemplateContentTheory =>
      'Write the learning lesson explanation here in language students can easily understand.';
}
