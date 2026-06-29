import 'fixedwidth_field.dart' show FixedWidthField;
import '../exceptions.dart';

class IntegerField extends FixedWidthField {
  IntegerField(super.length, {int? super.defaultValue});

  @override
  int populateFromString(String val) {
    try {
      return int.parse(val);
    } on FormatException {
      throw FieldValueException("'$val' is not valid input");
    }
  }

  @override
  String toRecord(val) => (val ?? 0).toString().padLeft(length, '0');
}
