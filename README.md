# fixedwidth

A library for working with fixed width files in dart.

This library helps you easily create a `Record` layout that clearly describes
the desired layout size and output formats. You can go both ways - taking a 
fixed width record and turning it into a dart object, or loading a dart object 
and outputting a fixed width string.


## Usage

To get started - first define your `Record` layout.
Note that class constructors are not inherited and you'll need to
include them in your own `Record` definition to get the `fromRecord` 
behavior.

```dart
import 'package:intl/intl.dart';
import 'package:fixedwidth/fixedwidth.dart';

class PersonRecord extends Record {
  StringField first_name = new StringField(20);
  StringField last_name = new StringField(20);
  DateTimeField dob =
      new DateTimeField(10, format: new DateFormat("yyyy-MM-dd"));
  IntegerField num_siblings = new IntegerField(2, defaultValue: 0);
  DecimalField amount_due = new DecimalField(8, decimals: 2);

  PersonRecord();
  PersonRecord.fromRecord(String record) : super.fromString(record);
}
```

You can take a Record, populate it, and turn it to a fixed width string.

```dart
var record = new PersonRecord()
  ..first_name.value = "John"
  ..last_name.value = "Doe"
  ..dob.value = new DateTime(1980, 4, 16)
  ..num_siblings.value = 2
  ..amount_due.value = 24.75;
print(record.toString());
print("Total Record Length: ${record.length()}");
```


You can also take a fixed width string and turn it into the appropriate
dart object. Calling a field's `value` gives you the dart typed object.

```dart
var record2 = new PersonRecord.fromRecord(
  "Benjamin            Franklin            1706-01-171600003.00");
print(record2.first_name);
print(record2.last_name);
print(record2.dob.value);
print(record2.num_siblings.value);
print(record2.amount_due.value);
}
```

See the [examples][example_link] for additional usage samples.
    
## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/madisona/dart-fixedwidth/issues
[example_link]: https://github.com/madisona/dart-fixedwidth/blob/master/example/fixedwidth_example.dart
