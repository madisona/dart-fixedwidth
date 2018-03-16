import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

void main() {
  group('DateTimeField tests', () {
    test('raises exception when value doesnt match format', () {
      var field = new DateTimeField(8, format: new DateFormat("yyyyMMdd"));

      expect(() {
        field.value = "201801AB";
      }, throwsA(new isInstanceOf<FieldValueException>()));
    });

    test('toString sends date to formatted string', () {
      var field = new DateTimeField(19);
      field.value = new DateTime(2018, 1, 1, 12, 42, 38);
      expect(field.toString(), "2018-01-01 12:42:38");
    });

    test('can set custom format', () {
      var field = new DateTimeField(8, format: new DateFormat("yyyyMMdd"));
      field.value = new DateTime(2018, 1, 1, 12, 42, 38);
      expect(field.toString(), "20180101");
    });

    test('can parse custom format', () {
      var field = new DateTimeField(8, format: new DateFormat("yyyyMMdd"));
      field.value = "20180401";
      var dt = field.value;
      expect(dt.year, 2018);
      expect(dt.month, 4);
      expect(dt.day, 1);
      expect(field.toString(), "20180401");
    });

    test('can handle old dates', () {
      var field = new DateTimeField(19);
      field.value = new DateTime(1842, 3, 6, 12, 42, 38);
      expect(field.toString(), "1842-03-06 12:42:38");
    });

    test('properly converts string formatted', () {
      var field = new DateTimeField(19);
      field.value = "2018-03-06 12:42:38";
      var dt = field.value;
      expect(dt.year, 2018);
      expect(dt.month, 3);
      expect(dt.day, 6);
      expect(dt.hour, 12);
      expect(dt.minute, 42);
      expect(dt.second, 38);
    });

    test('uses default date when none given', () {
      var dt = new DateTime.now();
      var field = new DateTimeField(19, defaultValue: dt);
      expect(field.value, dt);
    });

    test('toString returns empty string when no date', () {
      var field = new DateTimeField(10);
      expect(field.toString(), "          ");
    });

    test('toString returns empty string when empty value', () {
      var field = new DateTimeField(10);
      field.value = "";
      expect(field.toString(), "          ");
    });

    test('value is null when empty string', () {
      var field = new DateTimeField(10);
      field.value = "";
      expect(field.value, null);
    });

    test('value is null when padded empty string', () {
      var field = new DateTimeField(10);
      field.value = "          ";
      expect(field.value, null);
    });

    test('value is null when empty not given', () {
      var field = new DateTimeField(10);
      expect(field.value, null);
    });

    test('toString output must match field length specified', () {
      var dateFormat = new DateFormat("yyyyMMdd");
      var field = new DateTimeField(19, format: dateFormat);
      field.value = new DateTime.now();

      var expectedMessage =
          "Value '${dateFormat.format(field.value)}' is 8 chars. Expecting 19 chars.";
      expect(
          () => field.toString(),
          throwsA(predicate((e) =>
              e is FieldLengthException && e.message == expectedMessage)));
    });
  });
}
