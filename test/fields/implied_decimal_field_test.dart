import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('ImpliedDecimalField tests', () {
    test('raises exception when value longer than allowed', () {
      var field = ImpliedDecimalField(6);
      field.value = 150156.2;

      expect(field.toString, throwsA(isA<FieldLengthException>()));
    });

    test('raises exception when bad data given', () {
      var field = ImpliedDecimalField(6);
      expect(() {
        field.value = "0001AB";
      }, throwsA(isA<FieldValueException>()));
    });

    test('toString returns padded length', () {
      var field = ImpliedDecimalField(5, decimals: 0);
      field.value = 300;
      expect(field.value, 300);
      expect(field.toString(), equals("00300"));
    });

    test('toString returns padded length without decimal point', () {
      var field = ImpliedDecimalField(7, decimals: 2);
      field.value = 300.25;
      expect(field.toString(), equals("0030025"));
    });

    test('toString returns padded length when lots of fractional digits', () {
      var field = ImpliedDecimalField(8, decimals: 3);
      field.value = 30500.25325;
      expect(field.toString(), equals("30500253"));
    });

    test('toString returns padded zeros when null', () {
      var field = ImpliedDecimalField(6);
      expect(field.value, null);
      expect(field.toString(), equals("000000"));
    });

    test('properly converts from string formatted', () {
      var field = ImpliedDecimalField(10, decimals: 2);
      field.value = "072533";
      expect(field.value, equals(725.33));
      expect(field.toString(), equals("0000072533"));
    });

    test('properly converts from string formatted when no decimals', () {
      var field = ImpliedDecimalField(10, decimals: 0);
      field.value = "0000072533";
      expect(field.value, equals(72533));
      expect(field.toString(), equals("0000072533"));
    });

    test('allows default value', () {
      var field = ImpliedDecimalField(8, defaultValue: 999999.99, decimals: 2);
      expect(field.value, equals(999999.99));
      expect(field.toString(), equals("99999999"));
    });
  });
}
