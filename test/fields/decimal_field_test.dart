import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('DecimalField tests', () {
    test('raises exception when value longer than allowed', () {
      var field = new DecimalField(6);
      field.value = 150156.2;

      expect(field.toString, throwsA(new isInstanceOf<FieldLengthException>()));
    });

    test('raises exception when bad data given', () {
      var field = new DecimalField(6);
      expect(() {
        field.value = "0001AB";
      }, throwsA(new isInstanceOf<FieldValueException>()));
    });

    test('toString returns padded length', () {
      var field = new DecimalField(6);
      field.value = "125";
      expect(field.toString(), equals("125.00"));
    });

    test('toString returns padded zeros when null', () {
      var field = new DecimalField(6);
      expect(field.toString(), equals("000.00"));
    });

    test('toString returns padded zeros when null', () {
      var field = new DecimalField(6);
      expect(field.value, equals(null));
      expect(field.toString(), equals("000.00"));
    });

    test('properly converts string formatted', () {
      var field = new DecimalField(10, decimals: 2);
      field.value = "725.33";
      expect(field.value, equals(725.33));
      expect(field.toString(), equals("0000725.33"));
    });

    test('allows default value', () {
      var field = new DecimalField(8, defaultValue: 99999.99, decimals: 2);
      expect(field.value, equals(99999.99));
      expect(field.toString(), equals("99999.99"));
    });
  });
}
