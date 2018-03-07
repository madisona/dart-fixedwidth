import 'exceptions.dart' show FieldLengthException;
import 'fields/fixedwidth_field.dart' show FixedWidthField;
import 'dart:mirrors';

class isInstance<T> {
  bool check(a) => a is T;
  Type get type => T;
}

/// The base class for a fixed with record definition.
///
/// The Record class is made up of a series of FixedWidthField objects
/// which declare the length of the fixed width field and the type.
///
///     class AddressRecord extends Record {
///       address = new StringField(length=50);
///       address2 = new StringField(length=50);
///       city = new StringField(length=20);
///       state = new StringField(length=2);
///       postal_code = new StringField(length=9);
///     }
///
///     var address = new AddressRecord()
///       ..address.value = "123 Main Street"
///       ..city.value = "Mountain View"
///       ..state.value = "CA"
///       ..postal_code.value = "94043";
///
///     Use `toString` to turn the object into its properly padded string:
///
///     print(address.toString());
///
///     Use `fromString` to take a padded string and turn it into the
///     dart typed Record class.
///
///     var address = new AddressRecord.fromString(
///
abstract class Record {
  Iterable<dynamic> _fieldsList;

  Record();

  /**
   * Takes a fixed width string and populates the Record class
   */
  Record.fromString(String record) {
    if (record.length != this.length()) {
      throw new FieldLengthException(
          "Fixed width record length is ${record.length} but should be ${this.length}");
    }

    var pos = 0;
    for (var field in fields) {
      field.value = record.substring(pos, pos + field.length);
      pos += field.length;
    }
  }

  /// returns the list of FixedWidthField instance variables in order defined
  Iterable<dynamic> get fields {
    if (_fieldsList == null) {
      InstanceMirror im = reflect(this);
      ClassMirror cm = im.type;

      var isFixedWidth = new isInstance<FixedWidthField>();
      var fieldList = [];

      for (var s in cm.declarations.keys) {
        try {
          var field = im.getField(s).reflectee;
          if (isFixedWidth.check(field)) {
            fieldList.add(field);
          }
        } catch (NoSuchMethodError) {}
      }

      _fieldsList = fieldList;
    }
    return _fieldsList;
  }

  /// Turns the record into the flat, properly padded string version
  String toString() => fields.map((e) => e.toString()).join("");

  /// Returns the total length of the defined Record
  num length() => fields.fold(0, (prev, element) => prev + element.length);
}
