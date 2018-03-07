import 'fixedwidth_field.dart';
import '../exceptions.dart';

/// BooleanField is for a string output of Y/N
class BooleanField extends FixedWidthField {
  BooleanField({int length = 1, bool defaultValue})
      : super(length, defaultValue);

  void set value(dynamic val) {
    var stringified = val.toString();
    if (stringified == "true" || stringified == "Y") {
      rawVal = true;
    } else if (stringified == "false" ||
        stringified == "F" ||
        stringified == ' ' ||
        stringified == '') {
      rawVal = false;
    } else {
      throw new FieldValueException("'$value' is not valid.");
    }
  }

  String toString() {
    if (value == true) {
      return "Y";
    } else if (value == false) {
      return "F";
    } else {
      throw new FieldValueException("'$value' is not valid. Must be Y/N.");
    }
  }
}
