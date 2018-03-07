import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanField tests', () {
    test('returns true when value is Y', () {
      var field = new BooleanField()..value = "Y";
      expect(field.value, equals(true));
    });

    test('returns true when value is true', () {
      var field = new BooleanField()..value = true;
      expect(field.value, equals(true));
    });

    test('returns false when value is F', () {
      var field = new BooleanField()..value = "F";
      expect(field.value, equals(false));
    });

    test('returns false when value is empty space', () {
      var field = new BooleanField()..value = " ";
      expect(field.value, equals(false));
    });

    test('returns false when value is empty', () {
      var field = new BooleanField()..value = "";
      expect(field.value, equals(false));
    });

    test('returns false when value is false', () {
      var field = new BooleanField()..value = false;
      expect(field.value, equals(false));
    });

    test('toString returns Y when true', () {
      var field = new BooleanField()..value = true;
      expect(field.toString(), equals("Y"));
    });

    test('returns default when nothing given', () {
      var field = new BooleanField(defaultValue: false);
      expect(field.value, equals(false));
    });

    test('returns null when nothing given and no default', () {
      var field = new BooleanField();
      expect(field.value, equals(null));
    });

    test('toString throws error when value is null', () {
      var field = new BooleanField();
      expect(field.toString, throwsA(new isInstanceOf<FieldValueException>()));
    });

    test('throws error when value is not Y/N', () {
      var field = new BooleanField();
      expect(() {
        field.value = "X";
      }, throwsA(new isInstanceOf<FieldValueException>()));
    });
  });
}
