part of um_operators;

final _enclBarEntries = {
  [UmChars.overbar, UmChars.underbar]: OperatorSpec(
    needsLeft: false,
    needsRight: true,
    unwrapLeft: false,
    unwrapRight: true,
    associativity: Associativity.right,
    precedence: precedenceUnaryFun,
    handler: (left, right, op, lexer) {
      final ch = checkOperator(op);
      if (ch == UmChars.overbar) {
        return [
          AccentNode(
            base: right.wrapWithEquationRow(),
            label: '\u00AF',
            isStretchy: true,
            isShifty: false,
          ),
        ];
      } else {
        return [
          AccentUnderNode(
            base: right.wrapWithEquationRow(),
            label: '\u00AF',
          ),
        ];
      }
    },
  ),
};
