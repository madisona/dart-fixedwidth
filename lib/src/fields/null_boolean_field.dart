import 'package:fixedwidth/fixedwidth.dart';
import '../exceptions.dart';

/// NullBooleanField is for a string output of Y/N, or ' '
///
/// Same as a BooleanField, but allows a null value
///
class NullBooleanField extends BooleanField {
  NullBooleanField({int length = 1, bool defaultValue})
      : super(length: length, defaultValue: defaultValue);

  @override
  bool populateFromString(val) {
    if (val is String && ['Y', 'N'].contains(val)) {
      return val == 'Y' ? true : false;
    } else if ([null, '', ' '].contains(val)) {
      return null;
    } else {
      throw FieldValueException("'$value' is not valid.");
    }
  }

  @override
  String toRecord(val) {
    if (val == true) {
      return 'Y';
    } else if (val == false) {
      return 'N';
    } else if (val == null) {
      return ' ';
    } else {
      throw FieldValueException("'$val' is not valid. Must be Y/N or null.");
    }
  }
}
