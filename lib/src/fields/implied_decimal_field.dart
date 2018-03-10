import 'fixedwidth_field.dart' show FixedWidthField;
import '../utils.dart';
import '../exceptions.dart';

/// Implied Decimal Field is a numeric field with implied decimals
///
/// For example: 125.55 in a field of length 8 would be `00012555`
///
class ImpliedDecimalField extends FixedWidthField {
  num decimals;
  ImpliedDecimalField(int length, {num defaultValue, int this.decimals: 2})
      : super(length, defaultValue: defaultValue);

  void set value(dynamic val) {
    if (val is! String) {
      rawVal = val;
    } else {
      // If we get a string we need to put the implied decimal back.
      try {
        var numberPart = val.substring(0, val.length - decimals);
        var decimalPart = decimals > 0
            ? val.substring(val.length - decimals, val.length)
            : "0";
        rawVal = num.parse("$numberPart.$decimalPart");
      } catch (FormatException) {
        throw new FieldValueException("'$val' is not valid input");
      }
    }
  }

  String toString() {
    var val = value;
    if (val == null) {
      val = 0;
    }

    var stringVal =
        impliedDecimalPadding(length, val, fractionalDigits: decimals);

    if (stringVal.length > length) {
      throw new FieldLengthException(
          "Value '$val' is longer than {$length} chars.");
    }
    return stringVal;
  }
}
