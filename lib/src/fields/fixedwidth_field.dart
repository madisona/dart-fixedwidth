import '../exceptions.dart' show FieldLengthException;

/**
 * Anytime `value` is accessed, it should always be its dart type representation
 */
abstract class FixedWidthField {
  dynamic defaultValue;
  int length;
  dynamic rawVal;

  FixedWidthField(this.length, {this.defaultValue}) {
    if (defaultValue != null) {
      rawVal = defaultValue;
    }
  }

  dynamic get value => rawVal;
  void set value(dynamic val) => rawVal = val.trimRight();

  String toString() {
    if (value == null) {
      rawVal = "";
    }
    if (value.length > length) {
      throw new FieldLengthException(
          "Value '$value' is longer than {$length} chars.");
    }

    return value.padRight(length);
  }
}
