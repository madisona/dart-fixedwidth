import 'package:intl/intl.dart';
import 'fixedwidth_field.dart' show FixedWidthField;
import '../exceptions.dart';

/// DateTimeField is for... Dates or DateTime!
///
/// Be careful to make sure the formatter used will output a result
/// length that matches the field length specified.
///
class DateTimeField extends FixedWidthField {
  DateFormat _format;

  DateTimeField(int length, {DateTime defaultValue, DateFormat format})
      : super(length, defaultValue: defaultValue) {
    _format = format != null ? format : DateFormat("yyyy-MM-dd HH:mm:ss");
  }

  /// Tries to parse the datetime input if necessary.
  /// See the `DateTime.parse` documentation for accepted formats.
  @override
  DateTime populateFromString(val) {
    try {
      return val.trim() != "" ? DateTime.parse(val) : null;
    } catch (FormatException) {
      throw FieldValueException("'$val' is not valid input");
    }
  }

  @override
  String toRecord(val) {
    if (value == null || (value is String && value.trim() == "")) {
      return " " * length;
    }
    var val = _format.format(value);
    return val;
  }
}
