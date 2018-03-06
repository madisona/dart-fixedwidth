import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class PersonRecord extends Record {

  @override
  Map<String, FixedWidthField> fields = {
    'firstName': new StringField(10, "John"),
    'middle': new StringField(5, "N"),
    'lastName': new StringField(10, "Doe"),
  };

  PersonRecord() : super();
  PersonRecord.fromRecord(String record) : super.fromRecord(record);
}

void main() {
  group('Record class tests', () {
    setUp(() {});

    test('Field come out in order', () {
      var r = new PersonRecord();

      expect(r.fields.keys.toList(),
          orderedEquals(["firstName", "middle", "lastName"]));
    });

    test('Calling toString on record produces joined string', () {
      var r = new PersonRecord();

      expect(r.toString(), equals("John      N    Doe       "));
    });

    test('Length returns the sum of all the field lengths', () {
      var r = new PersonRecord();

      expect(r.length(), equals(25));
    });

    test('From record populates field values with parsed string', () {
      var r = new PersonRecord.fromRecord("Aaron     L    Madison   ");

      expect(r.fields['firstName'].value, equals("Aaron"));
      expect(r.fields['middle'].value, equals("L"));
      expect(r.fields['lastName'].value, equals("Madison"));
    });

    test('toRecord raises exception when longer than expected', () {
      expect(() {
        new PersonRecord.fromRecord(
            "Aaron     L    Madison   EXTRA_CHARACTERS");
      }, throwsA(new isInstanceOf<FieldLengthException>()));
    });

    test('toRecord raises exception when shorter than expected', () {
      expect(() {
        new PersonRecord.fromRecord("Aaron");
      }, throwsA(new isInstanceOf<FieldLengthException>()));
    });
  });
}
