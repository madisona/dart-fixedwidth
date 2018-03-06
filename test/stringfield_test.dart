import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('StringField tests', () {
    test('raises exception when value longer than allowed ', () {
      var field = new StringField(3);
      field.value = "This is longer than allowed";

      expect(field.toString, throwsA(new isInstanceOf<FieldLengthException>()));

    });

    test('toString returns padded length', () {
      var field = new StringField(10);
      field.value = "John";
      expect(field.toString(), equals("John      "));

    });

    test('toString returns padded length when value is null', () {
      var field = new StringField(10, null);
      expect(field.toString(), equals("          "));
    });
  });
}
