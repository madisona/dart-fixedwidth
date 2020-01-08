import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('SignedImpliedDecimalField tests', () {
    test('raises exception when value longer than allowed', () {
      var field = SignedImpliedDecimalField(6);
      field.value = 150156.2;

      expect(field.toString, throwsA(isA<FieldLengthException>()));
    });

    test('raises exception when bad data given', () {
      var field = SignedImpliedDecimalField(6);
      expect(() {
        field.value = "0001AB";
      }, throwsA(isA<FieldValueException>()));
    });

    test('toString returns padded length', () {
      var field = SignedImpliedDecimalField(5, decimals: 0);
      field.value = 300;
      expect(field.value, 300);
      expect(field.toString(), equals("0300+"));
    });

    test('toString returns padded length without decimal point', () {
      var field = SignedImpliedDecimalField(7, decimals: 2);
      field.value = 300.25;
      expect(field.toString(), equals("030025+"));
    });

    test('toString returns negative padded length without decimal point', () {
      var field = SignedImpliedDecimalField(7, decimals: 2);
      field.value = -300.25;
      expect(field.toString(), equals("030025-"));
    });

    test('toString returns padded length when lots of fractional digits', () {
      var field = SignedImpliedDecimalField(8, decimals: 3);
      field.value = 3050.25325;
      expect(field.toString(), equals("3050253+"));
    });

    test('toString returns padded zeros when null', () {
      var field = SignedImpliedDecimalField(6);
      expect(field.value, null);
      expect(field.toString(), equals("00000+"));
    });

    test('properly converts string formatted', () {
      var field = SignedImpliedDecimalField(8, decimals: 2);
      field.value = "0012555+";
      expect(field.value, equals(125.55));
      expect(field.toString(), equals("0012555+"));
    });

    test('properly converts negative string formatted', () {
      var field = SignedImpliedDecimalField(8, decimals: 2);
      field.value = "0012555-";
      expect(field.value, equals(-125.55));
      expect(field.toString(), equals("0012555-"));
    });

    test('allows default value', () {
      var field =
          SignedImpliedDecimalField(8, defaultValue: 99999.99, decimals: 2);
      expect(field.value, equals(99999.99));
      expect(field.toString(), equals("9999999+"));
    });
  });
}
