import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

void main() {
  group('StringField tests', () {
    test('raises exception when value longer than allowed ', () {
      var field = new StringField(3);
      field.value = "This is longer than allowed";

      var expectedMessage =
          "Value '${field.value}' is ${field.value.length} chars. Expecting 3 chars.";
      expect(
          () => field.toString(),
          throwsA(predicate((e) =>
              e is FieldLengthException && e.message == expectedMessage)));
    });

    test('toString returns truncated string', () {
      var field = new StringField(10, defaultValue: null);
      field.autoTruncate = true;
      field.value = "This is way too long for the field";

      expect(field.toString(), equals("This is wa"));
    });

    test('toString returns padded length', () {
      var field = new StringField(10);
      field.value = "John";
      expect(field.toString(), equals("John      "));
    });

    test('toString returns padded length when value is null', () {
      var field = new StringField(10, defaultValue: null);
      expect(field.toString(), equals("          "));
    });

    test('can set default', () {
      var field = new StringField(10, defaultValue: "Peter");
      expect(field.value, equals("Peter"));
      expect(field.toString(), equals("Peter     "));
    });
  });
}
