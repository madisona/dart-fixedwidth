import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class TestRecord extends Record {
  StringField firstName = new StringField(10, "John");
  StringField middle = new StringField(5);
  StringField lastName = new StringField(10);

  TestRecord() : super();
  TestRecord.fromRecord(String record) : super.fromString(record);
}

void main() {
  group('Record class tests', () {
    test('Calling toString on record produces joined string', () {
      var r = new TestRecord()
        ..firstName.value = "John"
        ..middle.value = "N"
        ..lastName.value = "Doe";

      expect(r.toString(), equals("John      N    Doe       "));
    });

    test('Length returns the sum of all the field lengths', () {
      var r = new TestRecord();

      expect(r.length(), equals(25));
    });

    test('From record populates field values with parsed string', () {
      var r = new TestRecord.fromRecord("Aaron     L    Madison   ");

      expect(r.firstName.value, equals("Aaron"));
      expect(r.middle.value, equals("L"));
      expect(r.lastName.value, equals("Madison"));
    });

    test('toRecord raises exception when longer than expected', () {
      expect(() {
        new TestRecord.fromRecord("Aaron     L    Madison   EXTRA_CHARACTERS");
      }, throwsA(new isInstanceOf<FieldLengthException>()));
    });

    test('toRecord raises exception when shorter than expected', () {
      expect(() {
        new TestRecord.fromRecord("Aaron");
      }, throwsA(new isInstanceOf<FieldLengthException>()));
    });
  });
}
