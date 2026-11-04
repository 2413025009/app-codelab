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
  String get settingsCurriculum => 'Merdeka Curriculum';

  @override
  String get settingsCurriculumSubtitle =>
      'Synced • Mr. Budi (Supervising Teacher)';

  @override
  String get settingsActive => 'Active';

  @override
  String get settingsHelpCenter => 'Lab Help Center';

  @override
  String get settingsHelpCenterSubtitle => 'AI Compiler FAQ & Teacher Guide';

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
  String get roadmapCatalogTitle => 'Material Catalog';

  @override
  String get roadmapCatalogSubtitle => 'Browse chapters across all materials';

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
  String get materialCatalogTitle => 'Material Catalog';

  @override
  String get materialFilterActive => 'In Progress';

  @override
  String get materialFilterNotStarted => 'Not Started';

  @override
  String get materialStatusRunning => 'Ongoing';

  @override
  String get materialLoadFailed => 'Failed to load the material catalog.';

  @override
  String get materialSearchHint => 'Search materials or their description…';

  @override
  String get materialClearSearch => 'Clear search';

  @override
  String get materialNoMatch => 'No materials match your search or filter.';

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
  String get readerLoadFailed => 'Failed to load the chapter material.';

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
  String get profileStatMaterialsDone => 'Materials Done';

  @override
  String get profileMasteryMapTitle => 'Material Mastery Map';

  @override
  String get profileMaterialsUnavailable =>
      'The material list is not available from the server yet. Try again.';

  @override
  String get profileMaterialProgressTitle => 'Material Progress';

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
  String get myClassesOneActiveNote =>
      'A student can only join one active class. Leave your class first to join another.';

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
  String get settingsLanguageTeacherLocked =>
      'Language selection is temporarily locked for educator accounts.';

  @override
  String get tNavDashboard => 'Dashboard';

  @override
  String get tNavMaterials => 'Materials';

  @override
  String get tNavAnalytics => 'Analytics';
}
