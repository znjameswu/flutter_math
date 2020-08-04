part of um_operators;

final _enclRectEntries = {
  [UmChars.rect]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexr) => [
      EnclosureNode(
        base: right.wrapWithEquationRow(),
        hasBorder: true,
      ),
    ],
  )
};
