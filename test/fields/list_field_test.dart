import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class SimpleRecord extends Record {
  StringField textField = StringField(5);
  IntegerField intField = IntegerField(5);

  SimpleRecord() : super();
  SimpleRecord.fromString(String record) : super.fromString(record);
}

class RecordTwo extends Record {
  StringField first_name = StringField(10);
  StringField last_name = StringField(10);
  SimpleRecord address = SimpleRecord();
  IntegerField age = IntegerField(3);

  RecordTwo() : super();
  RecordTwo.fromString(String record) : super.fromString(record);
}

void main() {
  group('ListField tests', () {
    test('value is records when starting with records', () {
      var field = ListField(SimpleRecord, occurs: 2);
      var record1 = SimpleRecord()
        ..textField.value = "one"
        ..intField.value = 130;
      var record2 = SimpleRecord()
        ..textField.value = "two"
        ..intField.value = 10;
      field.value = [record1, record2];
      expect(field.value, equals([record1, record2]));
      expect(field.toString(), equals("one  00130two  00010"));
    });

    test('value is record list when starting with string', () {
      var field = ListField(SimpleRecord, occurs: 2);
      field.value = "ABCDE11111VWXYZ00999";
      var records = field.value;
      expect(records.length, 2);
      expect(records[0].textField.value, "ABCDE");
      expect(records[0].intField.value, 11111);

      expect(records[1].textField.value, "VWXYZ");
      expect(records[1].intField.value, 999);
      expect(field.toString(), "ABCDE11111VWXYZ00999");
    });

    test('throws error when record length doesnt match occurs', () {
      var field = ListField(SimpleRecord, occurs: 2);
      var record1 = SimpleRecord();
      expect(() {
        field.value = [record1];
      }, throwsA(isA<FieldLengthException>()));
    });

    test('throws error if the records are not all the apporriate class', () {
      var field = ListField(SimpleRecord, occurs: 2);
      var record1 = SimpleRecord();
      var record2 = RecordTwo();
      expect(() {
        field.value = [record1, record2];
      }, throwsA(isA<AssertionError>()));
    });

    test('length returns total length of all expected records', () {
      var field = ListField(SimpleRecord, occurs: 4);
      expect(field.length, 40);
    });

    test('singleRecordLength returns length of a single record', () {
      var field = ListField(SimpleRecord, occurs: 4);
      expect(field.singleRecordLength, 10);
    });

    test('Errors when fixed width string is not properly formatted', () {
      var str = "ABCDE11111VWXYZ00999EXTRA";
      var field = ListField(SimpleRecord, occurs: 2);
      expect(() {
        field.value = str;
      }, throwsA(isA<FieldLengthException>()));
    });

    test('toString returns padded length when value is null', () {
      var field = ListField(SimpleRecord, occurs: 2);
      expect(field.value, null);
      expect(field.toString(), equals("     00000     00000"));
    });
  });
}
