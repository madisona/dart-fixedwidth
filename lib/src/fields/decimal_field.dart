import 'fixedwidth_field.dart' show FixedWidthField;
import '../utils.dart';
import '../exceptions.dart';

class DecimalField extends FixedWidthField {
  int decimals;
  DecimalField(super.length, {num? super.defaultValue, this.decimals = 2});

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
