class FieldLengthException implements Exception {
  String message;
  FieldLengthException(this.message);

  String toString() => message;
}

class FieldValueException implements Exception {
  String message;
  FieldValueException(this.message);

  String toString() => message;
}
