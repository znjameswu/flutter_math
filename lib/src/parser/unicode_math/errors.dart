class UmFoldException implements Exception {
  final String message;

  UmFoldException(this.message);
}

class UmIllegalKeywordsException implements UmFoldException {
  final String message;

  UmIllegalKeywordsException(this.message);
}

class UmIllegalStateException implements UmFoldException {
  final String message;

  UmIllegalStateException(this.message);
}

class UmFoldAbortException implements UmFoldException {
  final String message;

  UmFoldAbortException(this.message);
}