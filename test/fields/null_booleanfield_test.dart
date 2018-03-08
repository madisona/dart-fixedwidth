import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('NullBooleanField tests', () {
    test('returns true when value is Y', () {
      var field = new NullBooleanField()..value = "Y";
      expect(field.value, equals(true));
    });

    test('returns true when value is true', () {
      var field = new NullBooleanField()..value = true;
      expect(field.value, equals(true));
    });

    test('returns false when value is N', () {
      var field = new NullBooleanField()..value = "N";
      expect(field.value, equals(false));
    });

    test('returns false when value is empty space', () {
      var field = new NullBooleanField()..value = " ";
      expect(field.value, equals(null));
    });

    test('returns false when value is empty', () {
      var field = new NullBooleanField()..value = "";
      expect(field.value, equals(null));
    });

    test('returns false when value is false', () {
      var field = new NullBooleanField()..value = false;
      expect(field.value, equals(false));
    });

    test('toString returns Y when true', () {
      var field = new NullBooleanField()..value = true;
      expect(field.toString(), equals("Y"));
    });

    test('returns default when nothing given', () {
      var field = new NullBooleanField(defaultValue: false);
      expect(field.value, equals(false));
    });

    test('returns null when nothing given and no default', () {
      var field = new NullBooleanField();
      expect(field.value, equals(null));
    });

    test('Empty string when null', () {
      var field = new NullBooleanField();
      expect(field.toString(), equals(" "));
    });

    test('throws error when value is not Y/N or null', () {
      var field = new NullBooleanField();
      expect(() {
        field.value = "X";
      }, throwsA(new isInstanceOf<FieldValueException>()));
    });
  });
}
