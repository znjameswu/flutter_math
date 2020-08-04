part of um_operators;

final _accentEntries = {
  umCharProps.entries
      .where((entry) => entry.value == UmCharProp.accent)
      .map((e) => e.key)
      .toList(growable: false): OperatorSpec(
    needsLeft: true,
    needsRight: false,
    unwrapLeft: true,
    unwrapRight: false,
    associativity: Associativity.left,
    precedence: precedenceCombMark,
    handler: (left, right, op, lexer) => [
      ...left.sublist(0, math.max(0, left.length - 1)),
      AccentNode(
        base: left.wrapWithEquationRow(),
        label: checkOperator(op), // TODO translate
        isStretchy: false, // TODO
        isShifty: false, // TODO
      )
    ],
  ),
};