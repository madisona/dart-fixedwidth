class FieldLengthException implements Exception {
  String message;
  FieldLengthException(this.message);

  String toString() => message;
}
