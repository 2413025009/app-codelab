import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_codelab_ai/core/utils/phone.dart';

void main() {
  group('normalizePhone', () {
    test('menyimpan nomor tanpa awalan 0 atau kode negara 62', () {
      expect(normalizePhone('081234567890'), '81234567890');
      expect(normalizePhone('6281234567890'), '81234567890');
      expect(normalizePhone('+62 812-3456-7890'), '81234567890');
      expect(normalizePhone('812 3456 7890'), '81234567890');
    });

    test('nilai kosong tetap kosong', () {
      expect(normalizePhone(''), '');
      expect(normalizePhone('+62'), '');
    });
  });

  test('formatPhoneDisplay menambahkan +62 dan pengelompokan', () {
    expect(formatPhoneDisplay('081234567890'), '+62 812-3456-7890');
    expect(formatPhoneDisplay('81234567890'), '+62 812-3456-7890');
    expect(formatPhoneDisplay(''), '');
  });
}
