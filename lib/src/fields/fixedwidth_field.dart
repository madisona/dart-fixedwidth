import '../exceptions.dart' show FieldLengthException;

/**
 * Anytime `value` is accessed, it should always be its dart type representation
 */
abstract class FixedWidthField {
  String defaultValue;
  int length;
  String _val;

  FixedWidthField(this.length, [this.defaultValue]) {
    if (defaultValue != null) {
      _val = defaultValue;
    }
  }

  String get value => _val;
  void set value(String val) => _val = val.trimRight();

  String toString() {
    if (value == null) {
      _val = "";
    }
    if (value.length > length) {
      throw new FieldLengthException(
          "Value '$value' is longer than {$length} chars.");
    }

    return value.padRight(length);
  }
}

class StringField extends FixedWidthField {
  StringField(int length, [String defaultValue]) : super(length, defaultValue);
}
