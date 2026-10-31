import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/utils/validators.dart';

void main() {
  group('Validators.schoolEmail', () {
    test('menerima email berdomain @smk.belajar.id', () {
      expect(Validators.schoolEmail('guru@smk.belajar.id'), isNull);
      expect(Validators.schoolEmail('GURU@SMK.BELAJAR.ID'), isNull);
      expect(Validators.schoolEmail('  siswa@smk.belajar.id  '), isNull);
    });

    test('menolak domain selain sekolah', () {
      expect(Validators.schoolEmail('guru@gmail.com'), isNotNull);
      expect(Validators.schoolEmail('guru@smk.belajar.id.evil.com'), isNotNull);
      expect(Validators.schoolEmail('guru@sekolah.sch.id'), isNotNull);
    });

    test('menolak format email yang rusak', () {
      expect(Validators.schoolEmail(''), isNotNull);
      expect(Validators.schoolEmail('guru'), isNotNull);
      expect(Validators.schoolEmail('@smk.belajar.id'), isNotNull);
    });
  });
}
