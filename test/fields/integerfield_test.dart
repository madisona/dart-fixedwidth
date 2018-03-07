import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class IntRecordSample extends Record {
  IntegerField account = new IntegerField(3);
  IntegerField txn_amount = new IntegerField(5);

  IntRecordSample() : super();
  IntRecordSample.fromRecord(String record) : super.fromString(record);
}

void main() {
  group('IntegerField tests', () {
    test('raises exception when value longer than allowed ', () {
      var field = new IntegerField(3);
      field.value = 150156;

      expect(field.toString, throwsA(new isInstanceOf<FieldLengthException>()));
    });

    test('toString returns padded length', () {
      var field = new IntegerField(10);
      field.value = "100";
      expect(field.toString(), equals("0000000100"));
    });

    test('toString returns padded length when value is null', () {
      var field = new IntegerField(10, null);
      expect(field.toString(), equals("0000000000"));
    });

    test('calling value returns null when null', () {
      var field = new IntegerField(10, null);
      expect(field.value, equals(null));
    });

    test('fromRecord coerces value to int', () {
      var record = new IntRecordSample.fromRecord("01500950");

      expect(record.account.value, equals(15));
      expect(record.txn_amount.value, equals(950));
    });

    test('raises exception when bad input', () {
      expect(() {
        new IntRecordSample.fromRecord("015A0950");
      }, throwsA(new isInstanceOf<FieldValueException>()));
    });
  });
}

//def test_to_python_returns_none_when_value_is_empty_string(self):
//field = fields.IntegerField(length=5)
//self.assertEqual(None, field.to_python("     "))
//
//def test_to_python_raises_value_error_when_value_given_has_characters(self):
//field = fields.IntegerField(length=5)
//with self.assertRaises(ValueError):
//self.assertEqual(None, field.to_python("0001A"))
