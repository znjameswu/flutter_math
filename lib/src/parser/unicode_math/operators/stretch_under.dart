part of um_operators;

final _stretchUnderEntries = {
  [
    UmChars.underbrace,
    // UmChars.underparen,
    // UmChars.undershell,
    // UmChars.underbracket,
  ]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) => [
      AccentUnderNode(
        base: right.wrapWithEquationRow(),
        label: checkOperator(op),
      ),
    ],
  ),
};
