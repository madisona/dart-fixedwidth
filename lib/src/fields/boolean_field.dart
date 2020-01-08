import 'fixedwidth_field.dart';
import '../exceptions.dart';

/// BooleanField is for a string output of Y/N
class BooleanField extends FixedWidthField {
  BooleanField({int length = 1, bool defaultValue})
      : super(length, defaultValue: defaultValue);

  @override
  bool populateFromString(val) {
    if (['Y', 'N', '', ' '].contains(val)) {
      return val == 'Y' ? true : false;
    } else {
      throw FieldValueException("'$value' is not valid.");
    }
  }

  @override
  String toRecord(val) {
    if (val is! bool) {
      throw FieldValueException("'$val' is not valid. Must be Y/N.");
    }
    return val == true ? 'Y' : 'N';
  }
}
