import 'package:fixedwidth/fixedwidth.dart';
import '../exceptions.dart';

/// NullBooleanField is for a string output of Y/N, or ' '
///
/// Same as a BooleanField, but allows a null value
///
class NullBooleanField extends BooleanField {
  NullBooleanField({int length = 1, bool defaultValue})
      : super(length: length, defaultValue: defaultValue);

  void set value(dynamic val) {
    var stringified = val.toString();
    if (stringified == "true" || stringified == "Y") {
      rawVal = true;
    } else if (stringified == "false" || stringified == "F") {
      rawVal = false;
    } else if (stringified.trim() == "") {
      rawVal = null;
    } else {
      throw new FieldValueException("'$value' is not valid.");
    }
  }

  String toString() {
    if (value == true) {
      return "Y";
    } else if (value == false) {
      return "F";
    } else if (value == null) {
      return " ";
    } else {
      throw new FieldValueException(
          "'$value' is not valid. Must be Y/N or null.");
    }
  }
}
