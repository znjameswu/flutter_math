part of um_operators;

final _enclPhantomEntries = {
  [
    // UmChars.asmash,
    // UmChars.dsmash,
    UmChars.hphantom,
    // UmChars.hsmash,
    UmChars.phantom,
    // UmChars.smash,
    UmChars.vphantom,
  ]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) {
      final ch = checkOperator(op);
      return [
        PhantomNode(
          zeroWidth: ch == UmChars.hphantom,
          zeroHeight: ch == UmChars.vphantom,
          zeroDepth: ch == UmChars.vphantom,
          phantomChild: right.wrapWithEquationRow(),
        ),
      ];
    },
  )
};
