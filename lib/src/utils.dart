/// Pads zeros to left and right to assure proper length and precision
/// Values may be rounded.
String floatPadding(int length, num val, {int fractionalDigits: 2}) {
  return val.toStringAsFixed(fractionalDigits).padLeft(length, '0');
}

/// Pads zeros to left and right to assure proper length and precision
/// If decimals are present, we add 1 to the fill so the length is
/// correct after stripping out the decimal.
String impliedDecimalPadding(int length, num val, {int fractionalDigits: 2}) {
  length = fractionalDigits > 0 ? length + 1 : length;
  var padded = floatPadding(length, val, fractionalDigits: fractionalDigits);
  return padded.replaceFirst('.', '');
}
