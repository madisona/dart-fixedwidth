import 'package:fixedwidth/fixedwidth.dart';

part 'auto_truncate_example.g.dart';

@fixedWidth
class MyRecord extends Record with _$MyRecordFields {
  @override
  bool get autoTruncate => true;

  StringField animal = StringField(10);
  StringField description = StringField(10);

  MyRecord() : super();
  MyRecord.fromString(super.record) : super.fromString();
}

void main() {
  var record = MyRecord()
    ..animal.value = "Pigeon"
    ..description.value = "Pigeons are super cool";
  print("'${record.animal.value}'");
  print("'${record.description.value}'");
  print("'${record.toString()}'");
}
