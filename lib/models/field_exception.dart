class FieldException implements Exception {
  final String title;
  final String message;
  const FieldException(this.message, this.title);
}
