import 'dart:mirrors';
import 'fixedwidth_field.dart';

/// RecordField can be used to share a common repeating section, like address,
/// or to help group a logical section.
///
/// Its length is the length of `Record` it contains.
///
/// Calling `.value` will return the `record_class`
///
/// You can set the `value` with either a properly formatted string or
/// an instantiated `Record` class.
///
class RecordField extends FixedWidthField {
  ClassMirror cls_mirror;

  RecordField(record_class) : super(null) {
    cls_mirror = reflectClass(record_class);
  }

  void set value(dynamic val) {
    if (val is String) {
      rawVal =
          cls_mirror.newInstance(new Symbol('fromRecord'), [val]).reflectee;
    } else {
      assert(val.runtimeType == cls_mirror.reflectedType);
      rawVal = val;
    }
  }

  String toString() {
    if (rawVal == null) {
      return _getEmptyRecord().toString();
    }
    return rawVal.toString();
  }

  int get length {
    return rawVal != null ? rawVal.length : _getEmptyRecord().length;
  }

  dynamic _getEmptyRecord() =>
      cls_mirror.newInstance(new Symbol(''), []).reflectee;
}
