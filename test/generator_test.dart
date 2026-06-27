import 'package:fixedwidth/fixedwidth.dart';
import 'package:test/test.dart';

part 'generator_test.g.dart';

@fixedWidth
class GenTestRecord extends Record with _$GenTestRecordFields {
  // Valid fields that should be included
  StringField name = StringField(10);
  IntegerField age = IntegerField(3);

  // Static field (should be ignored)
  static StringField ignoredStatic = StringField(5);

  // Private field (should be ignored)
  // ignore: unused_field
  IntegerField _ignoredPrivate = IntegerField(2);

  // Synthetic field / getter (should be ignored)
  StringField get ignoredGetter => StringField(4);

  // Normal field (should be ignored because it is not a FixedWidthField or Record)
  String helperString = "test";

  GenTestRecord() : super();
  GenTestRecord.fromString(super.record) : super.fromString();
}

@fixedWidth
class GenNestedChildRecord extends Record with _$GenNestedChildRecordFields {
  StringField value = StringField(5);

  GenNestedChildRecord() : super();
  GenNestedChildRecord.fromString(super.record) : super.fromString();
}

@fixedWidth
class GenParentRecord extends Record with _$GenParentRecordFields {
  StringField header = StringField(10);
  GenNestedChildRecord child = GenNestedChildRecord();
  ListField<GenNestedChildRecord> children =
      ListField(() => GenNestedChildRecord(), occurs: 2);

  GenParentRecord() : super();
  GenParentRecord.fromString(super.record) : super.fromString();
}

@fixedWidth
class GenEmptyRecord extends Record with _$GenEmptyRecordFields {
  GenEmptyRecord() : super();
  GenEmptyRecord.fromString(super.record) : super.fromString();
}

void main() {
  group('Code Generator tests', () {
    test(
        'Generated fields list contains only non-static, non-private, non-synthetic FixedWidthFields',
        () {
      var record = GenTestRecord();

      // The length should only be the sum of 'name' (10) and 'age' (3) = 13.
      expect(record.length, equals(13));

      // Check fields list content
      var fieldsList = record.fields.toList();
      expect(fieldsList.length, equals(2));
      expect(fieldsList[0], equals(record.name));
      expect(fieldsList[1], equals(record.age));
    });

    test(
        'Nested Record and ListField fields are correctly processed and ordered',
        () {
      var record = GenParentRecord();

      // Length should be header (10) + child (5) + children (5 * 2) = 25
      expect(record.length, equals(25));

      var fieldsList = record.fields.toList();
      expect(fieldsList.length, equals(3));
      expect(fieldsList[0], equals(record.header));
      expect(fieldsList[1], equals(record.child));
      expect(fieldsList[2], equals(record.children));
    });

    test('Empty Record compiles and has 0 fields and length 0', () {
      var record = GenEmptyRecord();
      expect(record.length, equals(0));
      expect(record.fields.isEmpty, isTrue);
    });
  });
}
