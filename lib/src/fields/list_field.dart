import 'dart:mirrors';
import '../exceptions.dart';
import 'fixedwidth_field.dart';

/// ListField can be used similar to a COBOL OCCURS. A particular record
/// can repeat multiple times.
///
/// Its length is the length of all the records it contains. (length * occurs)
///
/// Calling `.value` will return a list of `record_class`
///
/// You can set the `value` with either a properly formatted string or
/// an instantiated list of `Record` classes.
///
/// Example:
///   // Phone Number is used within the contact record
///
///   class PhoneNumber extends Record {
///     IntegerField area_code = new IntegerField(3);
///     IntegerField prefix = new IntegerField(3);
///     IntegerField line_number = new IntegerField(4);
///
///     PhoneNumber();
///     PhoneNumber.fromString(String record) : super.fromString(record);
///   }
///
///   class Contact extends Record {
///     StringField name = new StringField(100);
///     ListField phone_number = new ListField(PhoneNumber, occurs: 3);
///     StringField email = new StringField(100);
///
///     Contact();
///     Contact.fromString(String record) : super.fromString(record);
///   }
///
class ListField extends FixedWidthField {
  ClassMirror cls_mirror;
  int occurs;

  ListField(record_class, {int this.occurs: 1}) : super(null) {
    cls_mirror = reflectClass(record_class);
  }

  @override
  List populateFromString(String val) {
    if (val.length != length) {
      throw new FieldLengthException(
          "Value is ${val.length} characters, but must be $length}");
    }

    var records = [];
    var recordLength = singleRecordLength;
    for (var i = 0; i < occurs; i++) {
      records.add(_getEmptyRecord(
          'fromString', [val.substring(0, singleRecordLength)]));
      val = val.substring(recordLength, val.length);
    }
    return records;
  }

  @override
  List populateFromObj(val) {
    if (val.length != occurs) {
      throw new FieldLengthException(
          "Must set the same number of records as `occurs` ($occurs)");
    }
    val.forEach((var v) {
      assert(v.runtimeType == cls_mirror.reflectedType);
    });
    return val;
  }

  @override
  String toRecord(val) {
    return rawVal == null
        ? _getEmptyRecord().toString() * occurs
        : rawVal.map((v) => v.toString()).join("");
  }

  int get length => singleRecordLength * occurs;

  int get singleRecordLength => _getEmptyRecord().length;

  dynamic _getEmptyRecord([String symbolName = '', List args]) => cls_mirror
      .newInstance(new Symbol(symbolName), args == null ? [] : args)
      .reflectee;
}
