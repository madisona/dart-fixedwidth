//
// Tests complex example of nesting records a few levels deep.

import 'package:test/test.dart';
import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class Phone extends Record {
  IntegerField area_code = IntegerField(3);
  IntegerField prefix = IntegerField(3);
  IntegerField line_number = IntegerField(4);

  Phone() : super();
  Phone.fromString(String record) : super.fromString(record);
}

class Person extends Record {
  StringField firstName = StringField(10);
  StringField middle = StringField(5);
  StringField lastName = StringField(10);
  ListField phone_numbers = ListField(Phone, occurs: 3);

  Person() : super();
  Person.fromString(String record) : super.fromString(record);
}

class Address extends Record {
  StringField address = StringField(60);
  StringField city = StringField(30);
  StringField state = StringField(2);
  IntegerField zipCode = IntegerField(5);

  Address() : super();
  Address.fromString(String record) : super.fromString(record);
}

class Contact extends Record {
  Person person = Person();
  Address address = Address();
  Person emergency_contact = Person();
  DateTimeField last_activity =
      DateTimeField(10, format: DateFormat("yyyy-MM-dd"));
  BooleanField is_active = BooleanField(defaultValue: true);
  DecimalField amount_due = DecimalField(8, decimals: 2);

  Contact() : super();
  Contact.fromString(String record) : super.fromString(record);
}

void main() {
  var fixedWidthString =
      "John      L    Doe       515555444400000000000000000000123 1st St                                                  West Des Moines               IA50266Jane      N    Doe       5152222222515555444400000000002018-03-12Y00075.25";

  test('Calling toString on record produces joined string', () {
    var phone = Phone()
      ..area_code.value = 515
      ..prefix.value = 555
      ..line_number.value = 4444;

    var phone2 = Phone()
      ..area_code.value = 515
      ..prefix.value = 222
      ..line_number.value = 2222;

    var contact = Contact()
      ..person.firstName.value = "John"
      ..person.lastName.value = "Doe"
      ..person.middle.value = "L"
      ..person.phone_numbers.value = [phone, Phone(), Phone()]
      ..emergency_contact.firstName.value = "Jane"
      ..emergency_contact.lastName.value = "Doe"
      ..emergency_contact.middle.value = "N"
      ..emergency_contact.phone_numbers.value = [phone2, phone, Phone()]
      ..address.address.value = "123 1st St"
      ..address.city.value = "West Des Moines"
      ..address.state.value = "IA"
      ..address.zipCode.value = 50266
      ..last_activity.value = DateTime(2018, 3, 12)
      ..amount_due.value = 75.25
      ..is_active.value = true;

    expect(contact.toString(), equals(fixedWidthString));
  });

  test('turns fixedWidthString into appropriate Record objects', () {
    var contact2 = Contact.fromString(fixedWidthString);

    expect(contact2.person.firstName.value, "John");
    expect(contact2.person.middle.value, "L");
    expect(contact2.person.lastName.value, "Doe");
    expect(contact2.person.phone_numbers.value[0].area_code.value, 515);
    expect(contact2.person.phone_numbers.value[0].prefix.value, 555);
    expect(contact2.person.phone_numbers.value[0].line_number.value, 4444);

    expect(contact2.person.phone_numbers.value[1].area_code.value, 0);
    expect(contact2.person.phone_numbers.value[1].prefix.value, 0);
    expect(contact2.person.phone_numbers.value[1].line_number.value, 0);

    expect(contact2.person.phone_numbers.value[2].area_code.value, 0);
    expect(contact2.person.phone_numbers.value[2].prefix.value, 0);
    expect(contact2.person.phone_numbers.value[2].line_number.value, 0);

    expect(contact2.address.address.value, "123 1st St");
    expect(contact2.address.city.value, "West Des Moines");
    expect(contact2.address.state.value, "IA");
    expect(contact2.address.zipCode.value, 50266);

    expect(contact2.emergency_contact.firstName.value, "Jane");
    expect(contact2.emergency_contact.middle.value, "N");
    expect(contact2.emergency_contact.lastName.value, "Doe");

    expect(
        contact2.emergency_contact.phone_numbers.value[0].area_code.value, 515);
    expect(contact2.emergency_contact.phone_numbers.value[0].prefix.value, 222);
    expect(contact2.emergency_contact.phone_numbers.value[0].line_number.value,
        2222);

    expect(
        contact2.emergency_contact.phone_numbers.value[1].area_code.value, 515);
    expect(contact2.emergency_contact.phone_numbers.value[1].prefix.value, 555);
    expect(contact2.emergency_contact.phone_numbers.value[1].line_number.value,
        4444);

    expect(
        contact2.emergency_contact.phone_numbers.value[2].area_code.value, 0);
    expect(contact2.emergency_contact.phone_numbers.value[2].prefix.value, 0);
    expect(
        contact2.emergency_contact.phone_numbers.value[2].line_number.value, 0);

    expect(contact2.last_activity.value, DateTime(2018, 3, 12));
    expect(contact2.is_active.value, true);
    expect(contact2.amount_due.value, 75.25);
  });
}
