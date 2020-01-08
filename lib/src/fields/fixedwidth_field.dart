import '../exceptions.dart' show FieldLengthException;

/// Base class for all FixedWidth record fields
///
/// `length` must always be present
/// `defaultValue` should match the type of field being used
///
/// `value` is how you get or set a field's contents as a dart type
/// `toString` is how you access the padded string value
///
/// `autoTruncate` - false by default
///
///     Sometimes you might have a field coming from one data source that is
///     allowed to be longer than your fixed width translated record can be.
///     (i.e. you may store address as 60 characters, but the fixed width
///     record you need to generate can only use 50 characters)
///
///     Instead of either a) blowing up, or b) having to always splice the strings
///     down to the appropriate length, you can set `autoTruncate = true` on the
///     `Record` class to do this automatically.
///
///     Example:
///
///       class AddressRecord extends Record {
///           autoTruncate = true;
///
///           StringField address = StringField(50);
///       }
///
abstract class FixedWidthField {
  bool autoTruncate = false;
  int length;
  dynamic rawVal;

  FixedWidthField(this.length, {defaultValue}) {
    if (defaultValue != null) {
      value = defaultValue;
    }
  }

  dynamic get value => rawVal;

  dynamic populateFromString(String val) => val.trimRight();
  dynamic populateFromObj(dynamic val) => val;

  /// Each subclass will define their own implementation
  /// Set value's job is to set rawVal equal to the appropriate
  /// "dart typed" object. I.E. a string / int / bool / etc...
  ///
  /// Values may either be set directly by assigning the typed object
  /// or it may be coming from a fixed width string and need to be converted.
  set value(dynamic val) {
    rawVal = val is String ? populateFromString(val) : populateFromObj(val);
  }

  /// `toRecord` will be overridden in each subclass
  ///
  /// its job is to turn the value into a properly formatted string
  String toRecord(dynamic val) => (value ?? '').padRight(length);

  /// toString turns the value to a string. Don't override this directly
  /// in subclasses. Instead - use `toRecord`.
  @override
  String toString() {
    var val = toRecord(value);
    if (autoTruncate == true) {
      val = val.substring(0, length);
    }
    _checkRecordLength(val);
    return val;
  }

  void _checkRecordLength(String val) {
    if (val.length != length) {
      throw FieldLengthException(
          "Value '$val' is ${val.length} chars. Expecting $length chars.");
    }
  }
}
