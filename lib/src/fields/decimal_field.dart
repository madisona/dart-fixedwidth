import 'fixedwidth_field.dart' show FixedWidthField;
import '../utils.dart';
import '../exceptions.dart';

class DecimalField extends FixedWidthField {
  num decimals;
  DecimalField(int length, {num defaultValue, this.decimals = 2})
      : super(length, defaultValue: defaultValue);

  @override
  num populateFromString(val) {
    try {
      return num.parse(val.toString());
    } catch (FormatException) {
      throw FieldValueException("'$val' is not valid input");
    }
  }

  @override
  String toRecord(val) =>
      floatPadding(length, val ?? 0, fractionalDigits: decimals);
}
