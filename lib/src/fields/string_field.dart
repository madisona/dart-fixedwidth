import 'fixedwidth_field.dart';

class StringField extends FixedWidthField {
  StringField(int length, {String defaultValue})
      : super(length, defaultValue: defaultValue);
}

//class DecimalField {}
//
//class ImpliedDecimalField {}
//
//class SignedImpliedDecimalField {}
//
//class DateField {}
//
//class DateTimeField {}
//

//// Allows you to create a field on a record that is itself a complete
//// record. Similar to a ``ListField`` except it only occurs once.
//// class Phone(Record):
////     area_code = fields.IntegerField(length=3)
////     prefix = fields.IntegerField(length=3)
////     line_number = fields.IntegerField(length=4)
////
//// class Contact(Record):
////     name = fields.StringField(length=100)
////     phone_number = fields.FragmentField(record=Phone)
////     email = fields.StringField(length=100)
//class FragmentField {}
//
////ListField allows you to have a field made up of a number of
////other records. Similar to COBOL's OCCURS.
////parameters:
////- record: which Record the field is made up of
////- length: how many times that record occurs
//class ListField {}
