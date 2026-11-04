import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/utils/validators.dart';
import 'package:mobile_codelab_ai/l10n/app_localizations_id.dart';

void main() {
  final l10n = AppLocalizationsId();

  group('Validators.schoolEmail', () {
    test('menerima email berdomain @smk.belajar.id', () {
      expect(Validators.schoolEmail('guru@smk.belajar.id', l10n), isNull);
      expect(Validators.schoolEmail('GURU@SMK.BELAJAR.ID', l10n), isNull);
      expect(Validators.schoolEmail('  siswa@smk.belajar.id  ', l10n), isNull);
    });

    test('menolak domain selain sekolah', () {
      expect(Validators.schoolEmail('guru@gmail.com', l10n), isNotNull);
      expect(
        Validators.schoolEmail('guru@smk.belajar.id.evil.com', l10n),
        isNotNull,
      );
      expect(Validators.schoolEmail('guru@sekolah.sch.id', l10n), isNotNull);
    });

    test('menolak format email yang rusak', () {
      expect(Validators.schoolEmail('', l10n), isNotNull);
      expect(Validators.schoolEmail('guru', l10n), isNotNull);
      expect(Validators.schoolEmail('@smk.belajar.id', l10n), isNotNull);
    });
  });
}
