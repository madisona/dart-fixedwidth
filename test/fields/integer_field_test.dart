import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

class IntRecordSample extends Record {
  IntegerField account = IntegerField(3);
  IntegerField txn_amount = IntegerField(5);

  IntRecordSample() : super();
  IntRecordSample.fromString(String record) : super.fromString(record);
}

void main() {
  group('IntegerField tests', () {
    test('raises exception when value longer than allowed ', () {
      var field = IntegerField(3);
      field.value = 150156;

      expect(field.toString, throwsA(isA<FieldLengthException>()));
    });

    test('toString returns padded length', () {
      var field = IntegerField(10);
      field.value = "100";
      expect(field.toString(), equals("0000000100"));
    });

    test('toString returns padded length when value is null', () {
      var field = IntegerField(10, defaultValue: null);
      expect(field.toString(), equals("0000000000"));
    });

    test('calling value returns null when null', () {
      var field = IntegerField(10, defaultValue: null);
      expect(field.value, equals(null));
    });

    test('fromString coerces value to int', () {
      var record = IntRecordSample.fromString("01500950");

      expect(record.account.value, equals(15));
      expect(record.txn_amount.value, equals(950));
    });

    test('raises exception when bad input', () {
      expect(() {
        IntRecordSample.fromString("015A0950");
      }, throwsA(isA<FieldValueException>()));
    });
  });
}
