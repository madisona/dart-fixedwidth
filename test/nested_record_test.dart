import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class TestRecord extends Record {
  StringField address = StringField(30);
  StringField city = StringField(30);
  StringField state = StringField(2);
  IntegerField zipCode = IntegerField(5);

  TestRecord() : super();
  TestRecord.fromString(String record) : super.fromString(record);
}

class RecordTwo extends Record {
  StringField first_name = StringField(10);
  StringField last_name = StringField(10);
  TestRecord address = TestRecord();
  IntegerField age = IntegerField(3);

  RecordTwo() : super();
  RecordTwo.fromString(String record) : super.fromString(record);
}

void main() {
  group('NestedRecord tests', () {
    test('toString returns padded length', () {
      var record = RecordTwo()
        ..first_name.value = "John"
        ..last_name.value = "Doe"
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
      var record_two = RecordTwo.fromString(str);
      expect(record_two.first_name.value, "John");
      expect(record_two.last_name.value, "Doe");
      expect(record_two.address.address.value, "123 1st St");
      expect(record_two.address.city.value, "Des Moines");
      expect(record_two.address.state.value, "IA");
      expect(record_two.address.zipCode.value, 50131);
      expect(record_two.age.value, 25);
    });

    test('Errors when fixed width string is not properly formatted', () {
      var str =
          "123 1st St                    Des Moines                    IA50131EXTRA";

      expect(() {
        RecordTwo.fromString(str);
      }, throwsA(isA<FieldLengthException>()));
    });

    test('toString returns padded length when value is null', () {
      var record_two = RecordTwo();
      expect(
          record_two.toString(),
          equals(
              "                                                                                  00000000"));
    });
  });
}
