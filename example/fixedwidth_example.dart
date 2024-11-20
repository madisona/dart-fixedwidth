import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class PhoneNumber extends Record {
  IntegerField areaCode = IntegerField(3);
  IntegerField prefix = IntegerField(3);
  IntegerField lineNumber = IntegerField(4);

  PhoneNumber();
  PhoneNumber.fromString(super.record) : super.fromString();
}

/// Person Record demonstrates using most field types.
///
/// The phone_number field is a `RecordField` which is comprised of
/// an entire record.
class PersonRecord extends Record {
  StringField firstName = StringField(20);
  StringField lastName = StringField(20);
  DateTimeField dob = DateTimeField(10, format: DateFormat("yyyy-MM-dd"));
  IntegerField numSiblings = IntegerField(2, defaultValue: 0);
  DecimalField amountDue = DecimalField(8, decimals: 2);
  PhoneNumber phoneNumber = PhoneNumber();

  PersonRecord();
  PersonRecord.fromString(super.record) : super.fromString();
}

main() {
  // You can take a Record, populate it, and turn it to a fixed width string.
  var record = PersonRecord()
    ..firstName.value = "John"
    ..lastName.value = "Doe"
    ..dob.value = DateTime(1980, 4, 16)
    ..numSiblings.value = 2
    ..amountDue.value = 24.75
    ..phoneNumber.areaCode.value = 215
    ..phoneNumber.prefix.value = 222
    ..phoneNumber.lineNumber.value = 3333;
  print("'${record.toString()}'");
  print("Total Record Length: ${record.length}");

  // You can take a fixed width string and turn it into the appropriate
  // dart object
  var record2 = PersonRecord.fromString(
      "Benjamin            Franklin            1706-01-171600003.002151112222");
  print(record2.firstName);
  print(record2.lastName);
  print(record2.dob.value);
  print(record2.numSiblings.value);
  print(record2.amountDue.value);
  print(record2.phoneNumber.areaCode.value);
  print(record2.phoneNumber.prefix.value);
  print(record2.phoneNumber.lineNumber.value);
}
