import 'exceptions.dart' show FieldLengthException;
import 'fields/fixedwidth_field.dart' show FixedWidthField;

/**
 * Record is the base item that makes up a fixed width record.
 *
 * It contains fields
 */
abstract class Record {
  // auto truncate?
  Map<String, FixedWidthField> fields = {};
  Record();

  /**
   * Takes a fixed width string and properly hydrates the Record class
   */
  Record.fromRecord(String record) {
    if (record.length != this.length()) {
      throw new FieldLengthException(
          "Fixed width record length is ${record.length} but should be ${this.length}");
    }

    var pos = 0;
    for (var field in this.fields.values) {
      field.value = record.substring(pos, pos + field.length);
      pos += field.length;
    }
  }

  String toString() => toRecord();

  num length() =>
      fields.values.fold(0, (prev, element) => prev + element.length);

  /**
   * Turns the record into the flat, properly padded string version
   *
   * todo: possibly pass auto_truncate here allowing a field that was set
   *       longer than allowed to be truncated.
   */
  String toRecord() => fields.values.map((f) => f.toString()).join();
}
