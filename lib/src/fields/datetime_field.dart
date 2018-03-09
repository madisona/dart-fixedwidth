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
    _format = format != null ? format : new DateFormat("yyyy-MM-dd HH:mm:ss");
  }

  /// Tries to parse the datetime input if necessary.
  /// See the `DateTime.parse` documentation for accepted formats.
  void set value(dynamic val) {
    if (val is String) {
      try {
        rawVal = val.trim() != "" ? DateTime.parse(val) : null;
      } catch (FormatException) {
        throw new FieldValueException("'$val' is not valid input");
      }
    } else {
      rawVal = val;
    }
  }

  String toString() {
    if (value == null || (value is String && value.trim() == "")) {
      return " " * length;
    }
    var val = _format.format(value);
    assert(val.length == length);
    return val;
  }
}
