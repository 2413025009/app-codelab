// FILE: lib/l10n/l10n_ext.dart
//
// TUGAS: Ekstensi kecil untuk menerjemahkan nilai enum domain yang tampil di
// antarmuka (label enum tidak boleh menyimpan teks Indonesia karena ikut
// terbawa ke bahasa Inggris/Arab). Konten dari database tetap tidak diubah.
import '../features/auth/domain/auth_repository.dart';
import '../features/challenges/domain/challenge_repository.dart';
import '../features/class/domain/class_exceptions.dart';
import '../features/dashboard/domain/dashboard_repository.dart';
import '../features/teacher/domain/teacher_exceptions.dart';
import 'app_localizations.dart';

/// Label tahap pemuatan dashboard dalam bahasa aktif (pola yang sama seperti
/// `ChallengeLevelL10n`: enum domain tetap bebas locale, pemetaan di sini).
extension DashboardStageL10n on DashboardStage {
  String labelL10n(AppLocalizations l10n) => switch (this) {
    DashboardStage.connecting => l10n.dashStageConnecting,
    DashboardStage.profile => l10n.dashStageProfile,
    DashboardStage.progress => l10n.dashStageProgress,
    DashboardStage.skills => l10n.dashStageSkills,
    DashboardStage.lessons => l10n.dashStageLessons,
    DashboardStage.challenges => l10n.dashStageChallenges,
    DashboardStage.composing => l10n.dashStageComposing,
  };
}

extension ChallengeLevelL10n on ChallengeLevel {
  String labelL10n(AppLocalizations l10n) => switch (this) {
    ChallengeLevel.beginner => l10n.levelBeginner,
    ChallengeLevel.intermediate => l10n.levelIntermediate,
    ChallengeLevel.advanced => l10n.levelAdvanced,
  };
}

/// Ubah label tingkat lama berbahasa Indonesia (mis. `ChallengeDetail.levelLabel`
/// berisi 'Pemula'/'Menengah'/'Mahir' dari backend) menjadi label bahasa aktif.
/// Label yang tidak dikenali dibiarkan apa adanya agar tidak menebak-nebak.
String localizeLevelLabel(AppLocalizations l10n, String label) {
  for (final level in ChallengeLevel.values) {
    if (level.label == label) return level.labelL10n(l10n);
  }
  return label;
}

/// Pesan galat autentikasi dalam bahasa aktif (DESIGN.md §4: tanpa menyalahkan,
/// selalu ada langkah berikutnya). `detail` dari server dipakai apa adanya —
/// teks dari server tidak diterjemahkan.
extension AuthFailureL10n on AuthFailure {
  String messageL10n(AppLocalizations l10n) => detail ?? switch (type) {
    AuthFailureType.invalidCredentials => l10n.authErrInvalidCredentials,
    AuthFailureType.emailTaken => l10n.authErrEmailTaken,
    AuthFailureType.network => l10n.authErrNetwork,
    AuthFailureType.schoolCodeNotFound => l10n.authErrSchoolCodeNotFound,
    AuthFailureType.wrongOldPassword => l10n.authErrWrongOldPassword,
    AuthFailureType.passwordPolicy => l10n.authErrPasswordPolicy,
    AuthFailureType.avatarUpload => l10n.authErrAvatarUpload,
    AuthFailureType.emailDomain => l10n.authErrEmailDomain,
    AuthFailureType.invalidInput => l10n.authErrInvalidInput,
    AuthFailureType.server => l10n.authErrServer,
  };
}

/// Pesan galat kelas dalam bahasa aktif. Hanya kode sisi klien
/// `UNRECOGNIZED_CLASS_RESPONSE` yang dipetakan ke l10n; pesan lain dipakai
/// apa adanya karena itu teks kontrak server (bukan teks UI buatan aplikasi).
extension ApiClassExceptionL10n on ApiClassException {
  String messageL10n(AppLocalizations l10n) =>
      code == 'UNRECOGNIZED_CLASS_RESPONSE'
          ? l10n.classResponseUnrecognized
          : message;
}

/// Teks galat guru di listener halaman dari kode stabil
/// ([TeacherState.errorCode]). Kode tak dikenal → [fallback] apa adanya,
/// sehingga pesan server selalu lewat tanpa diterjemahkan.
String teacherErrorText(AppLocalizations l10n, String? code, String fallback) {
  switch (code) {
    case 'CLIENT_SERVER_ERROR':
      return l10n.tTeacherErrServerFallback;
    case 'CLIENT_INVALID_LESSON_DATA':
      return l10n.tTeacherErrInvalidLesson;
    case 'CLIENT_INVALID_BAB_DATA':
      return l10n.tTeacherErrInvalidBab;
    case 'CLIENT_INVALID_CLASS_DATA':
      return l10n.tTeacherErrInvalidClass;
    case 'CLIENT_CONNECTION_FAILED':
      return l10n.tCubitConnectionFailed;
    case 'UNRECOGNIZED_CLASS_RESPONSE':
      return l10n.classResponseUnrecognized;
    default:
      return fallback;
  }
}

/// Teks sukses aksi guru di listener halaman dari kode stabil
/// ([TeacherState.actionSuccessCode], [TeacherState.actionSuccessArg]).
/// Kode tak dikenal atau argumen hilang → [fallback] apa adanya.
String teacherSuccessText(
  AppLocalizations l10n,
  String? code,
  String? arg,
  String fallback,
) {
  switch (code) {
    case 'CLASS_CREATED':
      return arg == null ? fallback : l10n.tCubitClassCreated(arg);
    case 'CLASS_ARCHIVED':
      return l10n.tCubitClassArchived;
    case 'CLASS_RESTORED':
      return l10n.tCubitClassRestored;
    case 'CLASS_CODE_REGENERATED':
      return arg == null ? fallback : l10n.tCubitClassCodeNew(arg);
    case 'LESSON_CREATED':
      return l10n.tCubitLessonCreated;
    case 'LESSON_UPDATED':
      return l10n.tFormUpdated;
    case 'LESSON_PUBLISHED':
      return l10n.tCubitLessonPublished;
    case 'LESSON_DRAFTED':
      return l10n.tCubitLessonDrafted;
    case 'LESSON_DELETED':
      return l10n.tCubitLessonDeleted;
    case 'LESSON_DUPLICATED':
      return l10n.tCubitLessonDuplicated;
    case 'BAB_CREATED':
      return l10n.tBabCreated;
    case 'BAB_DUPLICATED':
      return arg == null ? fallback : l10n.tCubitBabDuplicated(arg);
    case 'BAB_UPDATED':
      return l10n.tBabUpdated;
    case 'BAB_DELETED':
      return l10n.tCubitBabDeleted;
    case 'BAB_ORDER_UPDATED':
      return l10n.tCubitBabOrderUpdated;
    case 'STUDENT_REMOVED':
      return l10n.tCubitStudentRemoved;
    case 'STUDENT_REMOVED_NAMED':
      return arg == null ? fallback : l10n.tCubitStudentRemovedNamed(arg);
    default:
      return fallback;
  }
}

extension ApiTeacherExceptionL10n on ApiTeacherException {
  String messageL10n(AppLocalizations l10n) =>
      code == 'CLIENT_SERVER_ERROR'
          ? l10n.tTeacherErrServerFallback
          : code == 'CLIENT_INVALID_LESSON_DATA'
              ? l10n.tTeacherErrInvalidLesson
              : code == 'CLIENT_INVALID_BAB_DATA'
                  ? l10n.tTeacherErrInvalidBab
                  : code == 'CLIENT_INVALID_CLASS_DATA'
                      ? l10n.tTeacherErrInvalidClass
                      : message;
}
