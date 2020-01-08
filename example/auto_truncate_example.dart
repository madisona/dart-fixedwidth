import 'package:fixedwidth/fixedwidth.dart';

class MyRecord extends Record {
  bool autoTruncate = true;

  StringField animal = StringField(10);
  StringField description = StringField(10);
}

void main() {
  var record = MyRecord()
    ..animal.value = "Pigeon"
    ..description.value = "Pigeons are super cool";
  print("'${record.animal.value}'");
  print("'${record.description.value}'");
  print("'${record.toString()}'");
}
