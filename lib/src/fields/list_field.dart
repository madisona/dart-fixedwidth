import '../exceptions.dart';
import '../record.dart';
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
///     IntegerField area_code = IntegerField(3);
///     IntegerField prefix = IntegerField(3);
///     IntegerField line_number = IntegerField(4);
///
///     PhoneNumber();
///     PhoneNumber.fromString(String record) : super.fromString(record);
///   }
///
///   class Contact extends Record {
///     StringField name = StringField(100);
///     ListField phone_number = ListField(() => PhoneNumber(), occurs: 3);
///     StringField email = StringField(100);
///
///     Contact();
///     Contact.fromString(String record) : super.fromString(record);
///   }
///
class ListField<T extends Record> extends FixedWidthField {
  final T Function() recordFactory;
  final int occurs;
  int? _singleRecordLength;

  ListField(this.recordFactory, {this.occurs = 1}) : super(0);

  @override
  List<T> populateFromString(String val) {
    if (val.length != length) {
      throw FieldLengthException(
          'Value is ${val.length} characters, but must be $length');
    }

    var records = <T>[];
    var recordLength = singleRecordLength;
    for (var i = 0; i < occurs; i++) {
      var record = recordFactory();
      record.populateFromString(val.substring(0, recordLength));
      records.add(record);
      val = val.substring(recordLength, val.length);
    }
    return records;
  }

  @override
  List<T>? populateFromObj(val) {
    if (val == null) return null;
    if (val.length != occurs) {
      throw FieldLengthException(
          'Must set the same number of records as `occurs` ($occurs)');
    }
    val.forEach((dynamic v) {
      assert(v is T);
    });
    return val is List<T> ? val : List<T>.from(val);
  }

  @override
  String toRecord(val) {
    return val == null
        ? recordFactory().toString() * occurs
        : val.map((v) => v.toString()).join('');
  }

  @override
  int get length => singleRecordLength * occurs;

  int get singleRecordLength => _singleRecordLength ??= recordFactory().length;
}
