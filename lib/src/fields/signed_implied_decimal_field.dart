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

  @override
  num populateFromString(val) {
    // If we get a string we need to put the implied decimal back and
    // move the sign from the back to the front before parsing.
    try {
      var sign = val.substring(val.length - 1, val.length);
      var numberPart = val.substring(0, val.length - (decimals + 1));
      var decimalPart = decimals > 0
          ? val.substring(val.length - (decimals + 1), val.length - 1)
          : '0';
      return num.parse("$sign$numberPart.$decimalPart");
    } catch (FormatException) {
      throw FieldValueException("'$val' is not valid input");
    }
  }

  @override
  String toRecord(val) {
    var stringVal = impliedDecimalPadding(length - 1, (val ?? 0).abs(),
        fractionalDigits: decimals);
    var sign = val >= 0 ? '+' : '-';
    return stringVal + sign;
  }
}
