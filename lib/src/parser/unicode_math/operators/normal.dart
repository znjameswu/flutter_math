part of um_operators;

final _normalEntries = {
  // [' ']: OperatorSpec.normal(),
  umCharProps.entries
      .where((entry) =>
          entry.value == UmCharProp.normal && entry.key != UmChars.of)
      .map((e) => e.key)
      .toList(growable: false): const OperatorSpec.normal(),

  [UmChars.of]: OperatorSpec.normal(
    precedence: precedenceNormal,
    handler: (left, right, op, lexer) {
      if (left.length > 0) {
        final leftLast = left.last;
        if (leftLast is NaryOperatorNode) {
          return [
            ...left.sublist(0, left.length - 1),
            leftLast.copyWith(
              naryand: [...leftLast.naryand.children, ...right]
                  .wrapWithEquationRow(),
            ),
          ];
        }
      }
      return umOperators[UmChars.funcapply].handler(left, right, op, lexer);
    },
  )
};
