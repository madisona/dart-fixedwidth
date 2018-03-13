//
// Tests complex example of nesting records a few levels deep.

import 'package:test/test.dart';
import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class Phone extends Record {
  IntegerField area_code = new IntegerField(3);
  IntegerField prefix = new IntegerField(3);
  IntegerField line_number = new IntegerField(4);

  Phone() : super();
  Phone.fromRecord(String record) : super.fromString(record);
}

class Person extends Record {
  StringField firstName = new StringField(10);
  StringField middle = new StringField(5);
  StringField lastName = new StringField(10);
  ListField phone_numbers = new ListField(Phone, occurs: 3);

  Person() : super();
  Person.fromRecord(String record) : super.fromString(record);
}

class Address extends Record {
  StringField address = new StringField(60);
  StringField city = new StringField(30);
  StringField state = new StringField(2);
  IntegerField zipCode = new IntegerField(5);

  Address() : super();
  Address.fromRecord(String record) : super.fromString(record);
}

class Contact extends Record {
  RecordField person = new RecordField(Person);
  RecordField address = new RecordField(Address);
  RecordField emergency_contact = new RecordField(Person);
  DateTimeField last_activity =
      new DateTimeField(10, format: new DateFormat("yyyy-MM-dd"));
  BooleanField is_active = new BooleanField(defaultValue: true);
  DecimalField amount_due = new DecimalField(8, decimals: 2);

  Contact() : super();
  Contact.fromRecord(String record) : super.fromString(record);
}

void main() {
  var fixedWidthString =
      "John      L    Doe       515555444400000000000000000000123 1st St                                                  West Des Moines               IA50266Jane      N    Doe       5152222222515555444400000000002018-03-12Y00075.25";

  test('Calling toString on record produces joined string', () {
    var phone = new Phone()
      ..area_code.value = 515
      ..prefix.value = 555
      ..line_number.value = 4444;

    var phone2 = new Phone()
      ..area_code.value = 515
      ..prefix.value = 222
      ..line_number.value = 2222;

    var person = new Person()
      ..firstName.value = "John"
      ..lastName.value = "Doe"
      ..middle.value = "L"
      ..phone_numbers.value = [phone, new Phone(), new Phone()];

    var emergencyPerson = new Person()
      ..firstName.value = "Jane"
      ..lastName.value = "Doe"
      ..middle.value = "N"
      ..phone_numbers.value = [phone2, phone, new Phone()];

    var address = new Address()
      ..address.value = "123 1st St"
      ..city.value = "West Des Moines"
      ..state.value = "IA"
      ..zipCode.value = 50266;

    var contact = new Contact()
      ..person.value = person
      ..emergency_contact.value = emergencyPerson
      ..address.value = address
      ..last_activity.value = new DateTime(2018, 3, 12)
      ..amount_due.value = 75.25
      ..is_active.value = true;


    expect(contact.toString(), equals(fixedWidthString));
  });

  test('turns fixedWidthString into appropriate Record objects', () {
    var contact2 = new Contact.fromRecord(fixedWidthString);

    expect(contact2.person.value.firstName.value, "John");
    expect(contact2.person.value.middle.value, "L");
    expect(contact2.person.value.lastName.value, "Doe");
    expect(contact2.person.value.phone_numbers.value[0].area_code.value, 515);
    expect(contact2.person.value.phone_numbers.value[0].prefix.value, 555);
    expect(
        contact2.person.value.phone_numbers.value[0].line_number.value, 4444);

    expect(contact2.person.value.phone_numbers.value[1].area_code.value, 0);
    expect(contact2.person.value.phone_numbers.value[1].prefix.value, 0);
    expect(contact2.person.value.phone_numbers.value[1].line_number.value, 0);

    expect(contact2.person.value.phone_numbers.value[2].area_code.value, 0);
    expect(contact2.person.value.phone_numbers.value[2].prefix.value, 0);
    expect(contact2.person.value.phone_numbers.value[2].line_number.value, 0);

    expect(contact2.address.value.address.value, "123 1st St");
    expect(contact2.address.value.city.value, "West Des Moines");
    expect(contact2.address.value.state.value, "IA");
    expect(contact2.address.value.zipCode.value, 50266);

    expect(contact2.emergency_contact.value.firstName.value, "Jane");
    expect(contact2.emergency_contact.value.middle.value, "N");
    expect(contact2.emergency_contact.value.lastName.value, "Doe");

    expect(
        contact2.emergency_contact.value.phone_numbers.value[0].area_code.value,
        515);
    expect(contact2.emergency_contact.value.phone_numbers.value[0].prefix.value,
        222);
    expect(
        contact2
            .emergency_contact.value.phone_numbers.value[0].line_number.value,
        2222);

    expect(
        contact2.emergency_contact.value.phone_numbers.value[1].area_code.value,
        515);
    expect(contact2.emergency_contact.value.phone_numbers.value[1].prefix.value,
        555);
    expect(
        contact2
            .emergency_contact.value.phone_numbers.value[1].line_number.value,
        4444);

    expect(
        contact2.emergency_contact.value.phone_numbers.value[2].area_code.value,
        0);
    expect(contact2.emergency_contact.value.phone_numbers.value[2].prefix.value,
        0);
    expect(
        contact2
            .emergency_contact.value.phone_numbers.value[2].line_number.value,
        0);

    expect(contact2.last_activity.value, new DateTime(2018, 3, 12));
    expect(contact2.is_active.value, true);
    expect(contact2.amount_due.value, 75.25);
  });
}
