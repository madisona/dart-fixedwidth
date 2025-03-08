# Changelog
## 0.5.2
- Bump constraints enable 3.7

## 0.5.1
- Bump constraints enable 3.6

## 0.5.0
- Dart3 compatibility

## 0.4.2
- Fixed more pana violations. No functional changes.

## 0.4.1
- Fixed style violations. No functional changes.

## 0.4.0
- Simplified nested records. Removed `RecordField`. 
  Now you can just place a nested record straight on the parent
  
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

## 0.3.1
- Changed pubspec sdk constraint to allow Dart 2

## 0.3.0
- Added `autoTruncate` feature
  
  This helps in a scenario where you're storing data and you allow
  longer field values than the record you need to create. (i.e. format 
  data for a third party service)  Instead of always trimming your values
  for each field, you can just set `autoTruncate = true` on the record 
  class and each field will be truncated down to the appropriate field 
  record length. 

## 0.2.0
- Added `ImpliedDecimalField`
- Added `SignedImpliedDecimalField`
- Added `RecordField`
- Added `ListField`
- Breaking Change: `Record.length` is now a getter, not a method

## 0.1.0
- Initial version. 
  
  Contains `StringField`, `IntegerField`, `DecimalField`,
  `DateTimeField`, `BooleanField`, and `NullBooleanField` 


## 0.0.1

- placeholder to reserve pub.dartlang.org name
