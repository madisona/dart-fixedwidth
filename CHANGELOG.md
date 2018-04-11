# Changelog

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
