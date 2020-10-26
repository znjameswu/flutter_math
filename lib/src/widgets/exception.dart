import 'package:flutter_math/src/encoder/exception.dart';
import 'package:flutter_math/src/parser/tex/parse_error.dart';

/// Base class for exceptions.
abstract class FlutterMathException implements Exception {
  String get message;

  String get messageWithType;
}

/// Exceptions occured during build.
class BuildException implements FlutterMathException {
  final String message;
  final StackTrace trace;

  const BuildException(this.message, {this.trace});

  String get messageWithType => 'Build Exception: $message';
}
