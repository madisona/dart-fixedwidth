import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('DecimalField tests', () {
    test('raises exception when value longer than allowed', () {
      var field = new ImpliedDecimalField(6);
      field.value = 150156.2;

      expect(field.toString, throwsA(new isInstanceOf<FieldLengthException>()));
    });

    test('raises exception when bad data given', () {
      var field = new ImpliedDecimalField(6);
      expect(() {
        field.value = "0001AB";
      }, throwsA(new isInstanceOf<FieldValueException>()));
    });

    test('toString returns padded length', () {
      var field = new ImpliedDecimalField(5, decimals: 0);
      field.value = 300;
      expect(field.value, 300);
      expect(field.toString(), equals("00300"));
    });

    test('toString returns padded length without decimal point', () {
      var field = new ImpliedDecimalField(7, decimals: 2);
      field.value = 300.25;
      expect(field.toString(), equals("0030025"));
    });

    test('toString returns padded length when lots of fractional digits', () {
      var field = new ImpliedDecimalField(8, decimals: 3);
      field.value = 30500.25325;
      expect(field.toString(), equals("30500253"));
    });

    test('toString returns padded zeros when null', () {
      var field = new ImpliedDecimalField(6);
      expect(field.value, null);
      expect(field.toString(), equals("000000"));
    });

    test('properly converts string formatted', () {
      var field = new ImpliedDecimalField(10, decimals: 2);
      field.value = "725.33";
      expect(field.value, equals(725.33));
      expect(field.toString(), equals("0000072533"));
    });

    test('allows default value', () {
      var field =
          new ImpliedDecimalField(8, defaultValue: 999999.99, decimals: 2);
      expect(field.value, equals(999999.99));
      expect(field.toString(), equals("99999999"));
    });
  });
}
