import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class TestRecord extends Record {
  StringField firstName = StringField(10, defaultValue: "John");
  StringField middle = StringField(5);
  StringField lastName = StringField(10);

  TestRecord() : super();
  TestRecord.fromString(super.record) : super.fromString();
}

void main() {
  group('Record class tests', () {
    test('Calling toString on record produces joined string', () {
      var r = TestRecord()
        ..firstName.value = "John"
        ..middle.value = "N"
        ..lastName.value = "Doe";

      expect(r.toString(), equals("John      N    Doe       "));
    });

    test('Length returns the sum of all the field lengths', () {
      var r = TestRecord();

      expect(r.length, equals(25));
    });

    test('From record populates field values with parsed string', () {
      var r = TestRecord.fromString("Aaron     L    Madison   ");

      expect(r.firstName.value, equals("Aaron"));
      expect(r.middle.value, equals("L"));
      expect(r.lastName.value, equals("Madison"));
    });

    test('raises exception when longer than expected', () {
      expect(() {
        TestRecord.fromString("Aaron     L    Madison   EXTRA_CHARACTERS");
      }, throwsA(isA<FieldLengthException>()));
    });

    test('raises exception when shorter than expected', () {
      expect(() {
        TestRecord.fromString("Aaron");
      }, throwsA(isA<FieldLengthException>()));
    });
  });
}
