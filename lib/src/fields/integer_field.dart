import 'fixedwidth_field.dart' show FixedWidthField;
import '../exceptions.dart';

class IntegerField extends FixedWidthField {
  IntegerField(int length, {int defaultValue})
      : super(length, defaultValue: defaultValue);

  @override
  int populateFromString(val) {
    try {
      return int.parse(val.toString());
    } catch (FormatException) {
      throw new FieldValueException("'$val' is not valid input");
    }
  }

  @override
  String toRecord(val) => (val ?? 0).toString().padLeft(length, "0");
}
