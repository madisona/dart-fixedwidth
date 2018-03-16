import 'package:fixedwidth/fixedwidth.dart';

class MyRecord extends Record {
  bool autoTruncate = true;

  StringField animal = new StringField(10);
  StringField description = new StringField(10);
}

void main() {
  var record = new MyRecord()
    ..animal.value = "Pigeon"
    ..description.value = "Pigeons are super cool";
  print("'${record.animal.value}'");
  print("'${record.description.value}'");
  print("'${record.toString()}'");
}
