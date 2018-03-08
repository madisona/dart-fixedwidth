import 'fixedwidth_field.dart';
import '../exceptions.dart';

/// BooleanField is for a string output of Y/N
class BooleanField extends FixedWidthField {
  BooleanField({int length = 1, bool defaultValue})
      : super(length, defaultValue: defaultValue);

  void set value(dynamic val) {
    if (val is bool) {
      rawVal = val;
    } else if (val is String && ["Y", "N", "", " "].contains(val)) {
      rawVal = val == "Y" ? true : false;
    } else {
      throw new FieldValueException("'$value' is not valid.");
    }
  }

  String toString() {
    if (value is! bool) {
      throw new FieldValueException("'$value' is not valid. Must be Y/N.");
    }
    return value == true ? "Y" : "N";
  }
}
