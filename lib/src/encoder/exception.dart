import 'package:flutter_math/src/widgets/exception.dart';

class EncoderException implements FlutterMathException {
  final String message;
  final dynamic token;

  const EncoderException(this.message, [this.token]);
}
