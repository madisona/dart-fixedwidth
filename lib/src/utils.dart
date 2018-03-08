String floatPadding(int length, num val, {int fractionalDigits: 2}) {
  return val.toStringAsFixed(fractionalDigits).padLeft(length, '0');
}
