class FieldLengthException implements Exception {
  String message;
  FieldLengthException(this.message);

  @override
  String toString() => message;
}

class FieldValueException implements Exception {
  String message;
  FieldValueException(this.message);

  @override
  String toString() => message;
}
