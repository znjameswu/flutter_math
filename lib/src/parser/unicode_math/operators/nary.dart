part of um_operators;

final naryOperators = umCharProps.entries
      .where((entry) => entry.value == UmCharProp.nary)
      .map((e) => e.key)
      .toSet();

final _naryEntries = {
  umCharProps.entries
      .where((entry) => entry.value == UmCharProp.nary)
      .map((e) => e.key)
      .toList(growable: false): OperatorSpec(
    needsLeft: false,
    needsRight: false,
    associativity: Associativity.right,
    precedence: precedenceNary,
    handler: (left, right, op, lexer) => [
      NaryOperatorNode(
        operator: checkOperator(op),
        lowerLimit: null,
        upperLimit: null,
        naryand: EquationRowNode.empty(),
      ),
    ],
  ),
  [UmChars.of]: OperatorSpec.normal(
    associativity: Associativity.left, // It really is in Word, Whao!
    handler: (left, right, op, lexer) {
      if (left.length == 1) {
        final leftOperand = left[0];
        if (leftOperand is NaryOperatorNode) {
          return [
            leftOperand.copyWith(
              naryand: [...leftOperand.naryand.children, ...right]
                  .wrapWithEquationRow(),
            ),
          ];
        }
      }
      if (left.every((element) {
        final ch = checkChar(element);
        return ch != null &&
            (ch.isAsciiAlphaNumeric == true || ch == UmChars.nbsp);
      })) {
        return [
          FunctionNode(
            functionName: left.wrapWithEquationRow(), // Convert to text
            argument: right.wrapWithEquationRow(),
          ),
        ];
      }
      throw UmFoldAbortException('\\of has no suitable left candidate');
    },
  ),
};
