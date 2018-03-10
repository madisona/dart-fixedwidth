import 'fixedwidth_field.dart' show FixedWidthField;
import '../utils.dart';
import '../exceptions.dart';

/// Signed Implied Decimal Field is numeric with implied decimal point
/// Length is the total length of the field including decimals and a +/- sign
/// The sign is always the last byte
///
/// For example:
///   125.55 in a field of length 8 with 2 digits would be `0012555+`
///   -125.55 in a field of length 8 with 2 digits would be `0012555-`
///
class SignedImpliedDecimalField extends FixedWidthField {
  num decimals;
  SignedImpliedDecimalField(int length,
      {num defaultValue, int this.decimals: 2})
      : super(length, defaultValue: defaultValue);

  void set value(dynamic val) {
    if (val is! String) {
      rawVal = val;
    } else {
      // If we get a string we need to put the implied decimal back and
      // move the sign from the back to the front before parsing.
      try {
        var sign = val.substring(val.length - 1, val.length);
        var numberPart = val.substring(0, val.length - (decimals + 1));
        var decimalPart = decimals > 0
            ? val.substring(val.length - (decimals + 1), val.length - 1)
            : "0";
        rawVal = num.parse("$sign$numberPart.$decimalPart");
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

    var stringVal = impliedDecimalPadding(length - 1, val.abs(),
        fractionalDigits: decimals);
    var sign = val >= 0 ? "+" : "-";
    stringVal = stringVal + sign;

    if (stringVal.length > length) {
      throw new FieldLengthException(
          "Value '$val' is longer than {$length} chars.");
    }
    return stringVal;
  }
}
