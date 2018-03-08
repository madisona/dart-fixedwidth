import 'fixedwidth_field.dart' show FixedWidthField;
import '../utils.dart';
import '../exceptions.dart';

class DecimalField extends FixedWidthField {
  num decimals;
  DecimalField(int length, {num defaultValue, int this.decimals: 2})
      : super(length, defaultValue: defaultValue);

  void set value(dynamic val) {
    try {
      rawVal = num.parse(val.toString());
    } catch (FormatException) {
      throw new FieldValueException("'$val' is not valid input");
    }
  }

  String toString() {
    var val = value;
    if (val == null) {
      val = 0;
    }
    if (val.toString().length > length) {
      throw new FieldLengthException(
          "Value '$val' is longer than {$length} chars.");
    }
    return floatPadding(length, val, fractionalDigits: decimals);
  }
}
