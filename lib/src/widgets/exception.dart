/// Base class for exceptions.
abstract class FlutterMathException implements Exception {
  String get message;
}

/// Exceptions occured during build.
class BuildException implements FlutterMathException {
  final String message;
  final StackTrace trace;

  const BuildException(this.message, {this.trace});
}
