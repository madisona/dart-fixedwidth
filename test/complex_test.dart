//
// Tests complex example of nesting records a few levels deep.

import 'package:test/test.dart';
import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class Phone extends Record {
  IntegerField areaCode = IntegerField(3);
  IntegerField prefix = IntegerField(3);
  IntegerField lineNumber = IntegerField(4);

  Phone() : super();
  Phone.fromString(super.record) : super.fromString();
}

class Person extends Record {
  StringField firstName = StringField(10);
  StringField middle = StringField(5);
  StringField lastName = StringField(10);
  ListField phoneNumbers = ListField(Phone, occurs: 3);

  Person() : super();
  Person.fromString(super.record) : super.fromString();
}

class Address extends Record {
  StringField address = StringField(60);
  StringField city = StringField(30);
  StringField state = StringField(2);
  IntegerField zipCode = IntegerField(5);

  Address() : super();
  Address.fromString(super.record) : super.fromString();
}

class Contact extends Record {
  Person person = Person();
  Address address = Address();
  Person emergencyContact = Person();
  DateTimeField lastActivity =
      DateTimeField(10, format: DateFormat("yyyy-MM-dd"));
  BooleanField isActive = BooleanField(defaultValue: true);
  DecimalField amountDue = DecimalField(8, decimals: 2);

  Contact() : super();
  Contact.fromString(super.record) : super.fromString();
}

void main() {
  var fixedWidthString =
      "John      L    Doe       515555444400000000000000000000123 1st St                                                  West Des Moines               IA50266Jane      N    Doe       5152222222515555444400000000002018-03-12Y00075.25";

  test('Calling toString on record produces joined string', () {
    var phone = Phone()
      ..areaCode.value = 515
      ..prefix.value = 555
      ..lineNumber.value = 4444;

    var phone2 = Phone()
      ..areaCode.value = 515
      ..prefix.value = 222
      ..lineNumber.value = 2222;

    var contact = Contact()
      ..person.firstName.value = "John"
      ..person.lastName.value = "Doe"
      ..person.middle.value = "L"
      ..person.phoneNumbers.value = [phone, Phone(), Phone()]
      ..emergencyContact.firstName.value = "Jane"
      ..emergencyContact.lastName.value = "Doe"
      ..emergencyContact.middle.value = "N"
      ..emergencyContact.phoneNumbers.value = [phone2, phone, Phone()]
      ..address.address.value = "123 1st St"
      ..address.city.value = "West Des Moines"
      ..address.state.value = "IA"
      ..address.zipCode.value = 50266
      ..lastActivity.value = DateTime(2018, 3, 12)
      ..amountDue.value = 75.25
      ..isActive.value = true;

    expect(contact.toString(), equals(fixedWidthString));
  });

  test('turns fixedWidthString into appropriate Record objects', () {
    var contact2 = Contact.fromString(fixedWidthString);

    expect(contact2.person.firstName.value, "John");
    expect(contact2.person.middle.value, "L");
    expect(contact2.person.lastName.value, "Doe");
    expect(contact2.person.phoneNumbers.value[0].areaCode.value, 515);
    expect(contact2.person.phoneNumbers.value[0].prefix.value, 555);
    expect(contact2.person.phoneNumbers.value[0].lineNumber.value, 4444);

    expect(contact2.person.phoneNumbers.value[1].areaCode.value, 0);
    expect(contact2.person.phoneNumbers.value[1].prefix.value, 0);
    expect(contact2.person.phoneNumbers.value[1].lineNumber.value, 0);

    expect(contact2.person.phoneNumbers.value[2].areaCode.value, 0);
    expect(contact2.person.phoneNumbers.value[2].prefix.value, 0);
    expect(contact2.person.phoneNumbers.value[2].lineNumber.value, 0);

    expect(contact2.address.address.value, "123 1st St");
    expect(contact2.address.city.value, "West Des Moines");
    expect(contact2.address.state.value, "IA");
    expect(contact2.address.zipCode.value, 50266);

    expect(contact2.emergencyContact.firstName.value, "Jane");
    expect(contact2.emergencyContact.middle.value, "N");
    expect(contact2.emergencyContact.lastName.value, "Doe");

    expect(contact2.emergencyContact.phoneNumbers.value[0].areaCode.value, 515);
    expect(contact2.emergencyContact.phoneNumbers.value[0].prefix.value, 222);
    expect(
        contact2.emergencyContact.phoneNumbers.value[0].lineNumber.value, 2222);

    expect(contact2.emergencyContact.phoneNumbers.value[1].areaCode.value, 515);
    expect(contact2.emergencyContact.phoneNumbers.value[1].prefix.value, 555);
    expect(
        contact2.emergencyContact.phoneNumbers.value[1].lineNumber.value, 4444);

    expect(contact2.emergencyContact.phoneNumbers.value[2].areaCode.value, 0);
    expect(contact2.emergencyContact.phoneNumbers.value[2].prefix.value, 0);
    expect(contact2.emergencyContact.phoneNumbers.value[2].lineNumber.value, 0);

    expect(contact2.lastActivity.value, DateTime(2018, 3, 12));
    expect(contact2.isActive.value, true);
    expect(contact2.amountDue.value, 75.25);
  });
}
