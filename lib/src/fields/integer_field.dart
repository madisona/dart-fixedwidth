import 'fixedwidth_field.dart' show FixedWidthField;
import '../exceptions.dart';

class IntegerField extends FixedWidthField {
  IntegerField(int length, [int defaultValue = 0])
      : super(length, defaultValue);

  void set value(dynamic val) {
    try {
      rawVal = int.parse(val.toString());
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
    return val.toString().padLeft(length, "0");
  }
}
