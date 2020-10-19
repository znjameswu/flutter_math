class EncoderException implements Exception {
  final String message;
  final dynamic token;

  const EncoderException(this.message, [this.token]);
}
