# fixedwidth
[![Build Status](https://travis-ci.org/madisona/dart-fixedwidth.svg?branch=master)](https://travis-ci.org/madisona/dart-fixedwidth)

A library for working with fixed width files in dart.

This library helps you easily create a `Record` layout that clearly describes
the desired layout size and output formats. You can go both ways - taking a 
fixed width record and turning it into a dart object, or loading a dart object 
and outputting a fixed width string.


## Usage

To get started - first define your `Record` layout.
Note that class constructors are not inherited and you'll need to
include them in your own `Record` definition to get the `fromString` 
behavior.

```dart
import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class PersonRecord extends Record {
  StringField first_name = StringField(20);
  StringField last_name = StringField(20);
  DateTimeField dob =
      DateTimeField(10, format: DateFormat("yyyy-MM-dd"));
  IntegerField num_siblings = IntegerField(2, defaultValue: 0);
  DecimalField amount_due = DecimalField(8, decimals: 2);

  PersonRecord();
  PersonRecord.fromString(String record) : super.fromString(record);
}
```

You can take a Record, populate it, and turn it to a fixed width string.

```dart
var record = PersonRecord()
  ..first_name.value = "John"
  ..last_name.value = "Doe"
  ..dob.value = DateTime(1980, 4, 16)
  ..num_siblings.value = 2
  ..amount_due.value = 24.75;
print(record.toString());
print("Total Record Length: ${record.length()}");
```


You can also take a fixed width string and turn it into the appropriate
dart object. Calling a field's `value` gives you the dart typed object.

```dart
var record2 = PersonRecord.fromString(
  "Benjamin            Franklin            1706-01-171600003.00");
print(record2.first_name);
print(record2.last_name);
print(record2.dob.value);
print(record2.num_siblings.value);
print(record2.amount_due.value);
```

## Field Types:

##### StringField
This is the most common field. Just a string, padded to the right.

```dart
StringField name = StringField(15);
```

String Representation: right padded to the given `length` i.e.: "Peter&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" 

Dart Value: the raw string assigned ie. "Peter"

##### DateTimeField
`DateTimeField` is for dates or timestamps. You can set desired output 
format on the field to control the string output. 

Uses the `intl` library for date formatting.

```dart
DateTimeField completedDate = DateTimeField(10, format: DateFormat("yyyy-MM-dd"));
```

String Representation: Formatted date as defined by `format`. i.e. `2018-03-16`

Dart Value: `DateTime` - `2018-03-16 14:53:02.030`


##### IntegerField

```dart
IntegerField amount = IntegerField(5);
```

String Representation: zero padded integer: `00300`

Dart Value: `int` - `300`


##### DecimalField
A `num` type that outputs the desired length w/ decimals.
Value will be rounded if necessary to shorten decimal precision.

```dart
DecimalField amount = DecimalField(8, decimals: 2);
```

String Representation: zero padded decimal: `00300.50`

Dart Value: `num` - `300.50`

##### ImpliedDecimalField
With COBOL programs it used to be common to have `implied decimals`
which means a decimal is implied at a certain spot, but not present.

```dart
ImpliedDecimalField amount = ImpliedDecimalField(7, decimals: 2);
```

String Representation: zero padded decimal: `0030075`

Dart Value: `num` - `300.75`


##### SignedImpliedDecimalField
Same thing as Implied Decimal Field, but has a trailing sign that indicates
whether the value is positive or negative.

If you'd like a signed integer field, just set decimals to `0`

```dart
SignedImpliedDecimalField amount = SignedImpliedDecimalField(8, decimals: 2);
```

String Representation: : `0030075-`

Dart Value: `num` - `-300.75`


##### BooleanField

```dart
BooleanField isActive = BooleanField();
```

String Representation: `'Y'` or `'N'`

Dart Value: `bool`

##### NullBooleanField
Like a `BooleanField`, but can also be `null`. This is
sometimes used when a value is unset or unknown.

```dart
NullBooleanField likesPizza = NullBooleanField();
```

String Representation: `'Y'`, `'N'`, or `' '`

Dart Value: `bool`


##### ListField

`ListField` is like a nested record, but it is a list of records.
Very similar to COBOL `occurs` functionality.

 
```dart
class ItemRecord extends Record {
    StringField sku = StringField(10);
    IntegerField qty = IntegerField(2);
    DecimalField amount = StringField(9, decimals: 2);

    ItemRecord();
    ItemRecord.fromString(String record) : super.fromString(record);
}

class Transaction extends Record {
    ListField orderItems = ListField(record: ItemRecord, occurs: 25);
    
    Transaction();
    Transaction.fromString(String record) : super.fromString(record);
}
```  

String Representation: the entire padded string of the list of declared `record`s

Dart Value: List of `Record` instances

### Other Features

##### `defaultValue`
each field type accepts a `defaultValue` parameter. A field's value is initially
set to the default value when it is instantiated.

```dart
StringField name = StringField(10, defaultValue: "Peter");
print("'${name.value}'");
print("'${name.toString()}'");
```
prints 
```dart
'Peter'
'Peter     '
```

##### `autoTruncate`
set `autoTruncate = true` If you want to automatically truncate the string 
value to fit the necessary fixed width length (instead of throwing an exception), 

This is useful when you store data in fields longer than what the fixed width
file layout requirement is. 

```dart
class MyRecord extends Record {
    bool autoTruncate = true;
    
    StringField description = StringField(10);
}

var record = MyRecord()
  ..description.value = "Pigeons are super cool";
print("'${record.description.value}'");
print("'${record.toString()}'");
```
prints 
```dart
'Pigeons are super cool'
'Pigeons ar'
```

##### Nested Records
You can nest an entire record among other record fields.

Useful when parts of a record (like an address) are repeated in multiple places 
 and it is less work to define the "sub-record" only once.
 
```dart
class AddressRecord extends Record {
    StringField address = StringField(60);
    StringField city = StringField(30);
    StringField state = StringField(2);
    StringField postalCode = StringField(12);

    AddressRecord();
    AddressRecord.fromString(String record) : super.fromString(record);
}

class Transaction extends Record {
    AddressRecord billingAddress = AddressRecord();
    AddressRecord shippingAddress = AddressRecord();
    
    Transaction();
    Transaction.fromString(String record) : super.fromString(record);
}

var txn = Transaction()
  ..billingAddress.address.value = "PO Box 255"
  ..billingAddress.city.value = "Des Moines"
  ..billingAddress.state.value = "IA"
  ..billingAddress.state.value = "50306"
  ..shippingAddress.address.value = "123 1st St"
  ..shippingAddress.city.value = "West Des Moines"
  ..shippingAddress.state.value = "IA"
  ..shippingAddress.state.value = "50266";
```


See the [examples][example_link] for additional usage samples.
    
## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/madisona/dart-fixedwidth/issues
[example_link]: https://github.com/madisona/dart-fixedwidth/blob/master/example/fixedwidth_example.dart
