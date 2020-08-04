part of um_operators;

final _unisubsupEntries = {
  [
    UmChars.prime,
    UmChars.pprime,
    UmChars.ppprime,
    UmChars.pppprime,
  ]: OperatorSpec(
      needsLeft: true,
      needsRight: false,
      unwrapLeft: true,
      unwrapRight: false,
      associativity: Associativity.left,
      precedence: precedenceCombMark,
      handler: (left, right, op, lexer) {
        var leftOperand = left;
        if (left.isEmpty) {
          final forward = lexer.fetch();
          if (forward != null) {
            final ch = checkOperator(forward);
            if (ch != ' ' && ch != "'") {
              leftOperand = [forward];
              lexer.consume();
            } // TODO open close handling here or in exception hanlding?
          }
        }
        if (leftOperand.isEmpty || checkOperator(leftOperand.last) == "'") {
          return [...leftOperand, op];
        }

        var metDecimal = false;
        var basePos = leftOperand.length - 1;
        for (var i = leftOperand.length - 1; i >= 0; i--) {
          final ch = checkChar(leftOperand[i]);
          if (ch?.isDigit != true && ch != '.') {
            basePos = i + 1;
            break;
          }
          if (ch == '.') {
            if (metDecimal) {
              basePos = i + 1;
              break;
            } else {
              metDecimal = true;
            }
          }
        }
        basePos = math.max(0, math.min(basePos, leftOperand.length - 1));
        final base = leftOperand.sublist(basePos, leftOperand.length);
        final remainingLeft = leftOperand.sublist(0, basePos);

        final sup = List.filled(
          const {
            UmChars.prime: 1,
            UmChars.pprime: 2,
            UmChars.ppprime: 3,
            UmChars.pppprime: 4,
          }[checkOperator(op)],
          AtomNode(symbol: UmChars.prime),
        );
        if (base.length == 1) {
          final baseNode = base[0];
          if (baseNode is MultiscriptsNode && baseNode.sup == null) {
            return [
              ...remainingLeft,
              baseNode.copyWith(sup: sup.wrapWithEquationRow()),
            ];
          }
        }
        return [
          ...remainingLeft,
          MultiscriptsNode(
            base: base.wrapWithEquationRow(),
            sup: sup.wrapWithEquationRow(),
          ),
        ];
      }),
};
