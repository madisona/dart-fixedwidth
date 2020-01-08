import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class PhoneNumber extends Record {
  IntegerField area_code = IntegerField(3);
  IntegerField prefix = IntegerField(3);
  IntegerField line_number = IntegerField(4);

  PhoneNumber();
  PhoneNumber.fromString(String record) : super.fromString(record);
}

/// Person Record demonstrates using most field types.
///
/// The phone_number field is a `RecordField` which is comprised of
/// an entire record.
class PersonRecord extends Record {
  StringField first_name = StringField(20);
  StringField last_name = StringField(20);
  DateTimeField dob = DateTimeField(10, format: DateFormat("yyyy-MM-dd"));
  IntegerField num_siblings = IntegerField(2, defaultValue: 0);
  DecimalField amount_due = DecimalField(8, decimals: 2);
  PhoneNumber phone_number = PhoneNumber();

  PersonRecord();
  PersonRecord.fromString(String record) : super.fromString(record);
}

main() {
  // You can take a Record, populate it, and turn it to a fixed width string.
  var record = PersonRecord()
    ..first_name.value = "John"
    ..last_name.value = "Doe"
    ..dob.value = DateTime(1980, 4, 16)
    ..num_siblings.value = 2
    ..amount_due.value = 24.75
    ..phone_number.area_code.value = 215
    ..phone_number.prefix.value = 222
    ..phone_number.line_number.value = 3333;
  print("'${record.toString()}'");
  print("Total Record Length: ${record.length}");

  // You can take a fixed width string and turn it into the appropriate
  // dart object
  var record2 = PersonRecord.fromString(
      "Benjamin            Franklin            1706-01-171600003.002151112222");
  print(record2.first_name);
  print(record2.last_name);
  print(record2.dob.value);
  print(record2.num_siblings.value);
  print(record2.amount_due.value);
  print(record2.phone_number.area_code.value);
  print(record2.phone_number.prefix.value);
  print(record2.phone_number.line_number.value);
}
