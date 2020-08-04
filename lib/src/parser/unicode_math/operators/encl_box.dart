part of um_operators;

final _enclBoxEntries = {
  [UmChars.box]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) => [
      EquationRowNode(children: right),
    ],
  )
};
