part of um_operators;

final _stretchOverEntries = {
  [
    UmChars.overbrace,
    // UmChars.overparen,
    // UmChars.overshell,
    // UmChars.overbracket,
  ]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) => [
      AccentNode(
        base: right.wrapWithEquationRow(),
        label: checkOperator(op),
        isStretchy: true,
        isShifty: false,
      ),
    ],
  ),
};
