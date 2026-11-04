// FILE: lib/l10n/l10n_ext.dart
//
// TUGAS: Ekstensi kecil untuk menerjemahkan nilai enum domain yang tampil di
// antarmuka (label enum tidak boleh menyimpan teks Indonesia karena ikut
// terbawa ke bahasa Inggris/Arab). Konten dari database tetap tidak diubah.
import '../features/auth/domain/auth_repository.dart';
import '../features/challenges/domain/challenge_repository.dart';
import 'app_localizations.dart';

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
