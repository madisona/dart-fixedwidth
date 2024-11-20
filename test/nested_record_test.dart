import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class TestRecord extends Record {
  StringField address = StringField(30);
  StringField city = StringField(30);
  StringField state = StringField(2);
  IntegerField zipCode = IntegerField(5);

  TestRecord() : super();
  TestRecord.fromString(super.record) : super.fromString();
}

class RecordTwo extends Record {
  StringField firstName = StringField(10);
  StringField lastName = StringField(10);
  TestRecord address = TestRecord();
  IntegerField age = IntegerField(3);

  RecordTwo() : super();
  RecordTwo.fromString(super.record) : super.fromString();
}

void main() {
  group('NestedRecord tests', () {
    test('toString returns padded length', () {
      var record = RecordTwo()
        ..firstName.value = "John"
        ..lastName.value = "Doe"
        ..age.value = 45
        ..address.address.value = "123 1st St"
        ..address.city.value = "Des Moines"
        ..address.state.value = "IA"
        ..address.zipCode.value = "50131";

      expect(
          record.address.toString(),
          equals(
              "123 1st St                    Des Moines                    IA50131"));
      expect(
          record.toString(),
          equals(
              "John      Doe       123 1st St                    Des Moines                    IA50131045"));
    });

    test('returns appropriate length of the containing record class', () {
      var record = RecordTwo();
      expect(record.address.length, 67);
      expect(record.length, 90);
    });

    test('loads object from complex fixed width string', () {
      var str =
          "John      Doe       123 1st St                    Des Moines                    IA50131025";
      var recordTwo = RecordTwo.fromString(str);
      expect(recordTwo.firstName.value, "John");
      expect(recordTwo.lastName.value, "Doe");
      expect(recordTwo.address.address.value, "123 1st St");
      expect(recordTwo.address.city.value, "Des Moines");
      expect(recordTwo.address.state.value, "IA");
      expect(recordTwo.address.zipCode.value, 50131);
      expect(recordTwo.age.value, 25);
    });

    test('Errors when fixed width string is not properly formatted', () {
      var str =
          "123 1st St                    Des Moines                    IA50131EXTRA";

      expect(() {
        RecordTwo.fromString(str);
      }, throwsA(isA<FieldLengthException>()));
    });

    test('toString returns padded length when value is null', () {
      var recordTwo = RecordTwo();
      expect(
          recordTwo.toString(),
          equals(
              "                                                                                  00000000"));
    });
  });
}
