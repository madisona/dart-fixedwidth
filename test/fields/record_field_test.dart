import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class TestRecord extends Record {
  StringField address = new StringField(30);
  StringField city = new StringField(30);
  StringField state = new StringField(2);
  IntegerField zipCode = new IntegerField(5);

  TestRecord() : super();
  TestRecord.fromRecord(String record) : super.fromString(record);
}

class RecordTwo extends Record {
  StringField first_name = new StringField(10);
  StringField last_name = new StringField(10);
  RecordField address = new RecordField(TestRecord);
  IntegerField age = new IntegerField(3);

  RecordTwo() : super();
  RecordTwo.fromRecord(String record) : super.fromString(record);
}

void main() {
  group('RecordField tests', () {
    test('toString returns padded length', () {
      var record = new TestRecord()
        ..address.value = "123 1st St"
        ..city.value = "Des Moines"
        ..state.value = "IA"
        ..zipCode.value = "50131";

      var field = new RecordField(TestRecord);
      field.value = record;
      expect(
          field.toString(),
          equals(
              "123 1st St                    Des Moines                    IA50131"));
    });

    test('returns appropriate length of the containing record class', () {
      var field = new RecordField(TestRecord);
      expect(field.length, 67);
    });

    test('returns length of the containing record class when instantiated', () {
      var field = new RecordField(TestRecord);
      field.value = new TestRecord();
      expect(field.length, 67);
    });

    test('loads object from fixed width string', () {
      var str =
          "123 1st St                    Des Moines                    IA50131";
      var field = new RecordField(TestRecord);
      field.value = str;
      expect(field.value.address.value, "123 1st St");
      expect(field.value.city.value, "Des Moines");
      expect(field.value.state.value, "IA");
      expect(field.value.zipCode.value, 50131);
    });

    test('Errors when fixed width string is not properly formatted', () {
      var str =
          "123 1st St                    Des Moines                    IA50131EXTRA";
      var field = new RecordField(TestRecord);
      expect(() {
        field.value = str;
      }, throwsA(new isInstanceOf<FieldLengthException>()));
    });

    test('Errors when assigning to wrong record type', () {
      var field = new RecordField(TestRecord);
      expect(() {
        field.value = new RecordTwo();
      }, throwsA(new isInstanceOf<AssertionError>()));
    });

    test('toString returns padded length when value is null', () {
      var field = new RecordField(TestRecord);
      expect(field.value, null);
      expect(
          field.toString(),
          equals(
              "                                                              00000"));
    });

    test('loads object from complex fixed width string', () {
      var str =
          "John      Doe       123 1st St                    Des Moines                    IA50131025";
      var record_two = new RecordTwo.fromRecord(str);
      expect(record_two.first_name.value, "John");
      expect(record_two.last_name.value, "Doe");
      expect(record_two.address.value.address.value, "123 1st St");
      expect(record_two.address.value.city.value, "Des Moines");
      expect(record_two.address.value.state.value, "IA");
      expect(record_two.address.value.zipCode.value, 50131);
      expect(record_two.age.value, 25);
    });
  });
}
