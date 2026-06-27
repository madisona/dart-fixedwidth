import 'exceptions.dart' show FieldLengthException;

/// The base class for a fixed width record definition.
///
/// The Record class is made up of a series of FixedWidthField objects
/// which declare the length of the fixed width field and the type.
///
///     class AddressRecord extends Record {
///       address = StringField(length=50);
///       address2 = StringField(length=50);
///       city = StringField(length=20);
///       state = StringField(length=2);
///       postal_code = StringField(length=9);
///     }
///
///     var address = AddressRecord()
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
///     var address = AddressRecord.fromString(
///
abstract class Record {
  bool autoTruncate = false;

  Record();

  ///
  /// Takes a fixed width string and populates the Record class
  ///
  Record.fromString(String record) {
    populateFromString(record);
  }

  void populateFromString(String record) {
    if (record.length != length) {
      throw FieldLengthException(
          'Fixed width record length is ${record.length} but should be $length');
    }

    var pos = 0;
    for (var field in fields) {
      field.autoTruncate = autoTruncate;
      if (field is Record) {
        field.populateFromString(
            record.substring(pos, (pos + field.length) as int?));
      } else {
        field.value = record.substring(pos, (pos + field.length) as int?);
      }

      pos += field.length as int;
    }
  }

  /// returns the list of FixedWidthField instance variables in order defined
  Iterable<dynamic> get fields;

  /// Turns the record into the flat, properly padded string version
  @override
  String toString() {
    for (var field in fields) {
      field.autoTruncate = autoTruncate;
    }
    return fields.map((e) => e.toString()).join('');
  }

  /// Returns the total length of the defined Record
  num get length => fields.fold(0, (prev, element) => prev + element.length);
}
