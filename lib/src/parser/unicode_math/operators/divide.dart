part of um_operators;

final _divideEntries = {
  ['/', UmChars.atop]: OperatorSpec(
    needsLeft: true,
    needsRight: true,
    associativity: Associativity.left,
    precedence: precedenceDivide,
    consumeLeftSpace: true,
    handler: (left, right, op, lexer) => [
      FracNode(
        numerator: left.wrapWithEquationRow(),
        denominator: right.wrapWithEquationRow(),
        barSize: checkOperator(op) == '/' ? null : Measurement.zero,
      )
    ],
  ),
};