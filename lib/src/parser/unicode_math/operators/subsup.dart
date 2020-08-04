part of um_operators;

final _subsupEntries = {
  ['_', '^']: OperatorSpec(
    needsLeft: true,
    needsRight: true,
    unwrapLeft: false,
    associativity: Associativity.right,
    precedence: precendeceSubsup,
    handler: (left, right, op, lexer) {
      var leftOperand = left;
      if (left.isEmpty) {
        final forward = lexer.fetch();
        if (forward != null) {
          final ch = checkOperator(forward);
          if (ch == ' ') {
            leftOperand = [forward];
            lexer.consume();
          } // TODO open close handling here or in exception hanlding?
        }
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

      GreenNode folded;
      if (checkOperator(op) == '_') {
        if (base.length == 1) {
          final baseNode = base[0];
          if (baseNode is MultiscriptsNode && baseNode.sub == null) {
            folded = baseNode.copyWith(sub: right.wrapWithEquationRow());
          }
        }
        folded ??= MultiscriptsNode(
          base: base.wrapWithEquationRow(),
          sub: right.wrapWithEquationRow(),
        );
      } else {
        if (base.length == 1) {
          final baseNode = base[0];
          if (baseNode is MultiscriptsNode) {
            if (baseNode.sup == null) {
              folded = baseNode.copyWith(sup: right.wrapWithEquationRow());
            // } else if (baseNode.sup.children
            //     .every((element) => checkOperator(element) == "'")) {
            //   folded = baseNode.copyWith(
            //     sup: [...baseNode.sup.children, ...right].wrapWithEquationRow(),
            //   );
            }
          }
        }
        folded ??= MultiscriptsNode(
          base: base.wrapWithEquationRow(),
          sup: right.wrapWithEquationRow(),
        );
      }
      return [...remainingLeft, folded];
    },
  ),
  [UmChars.above, UmChars.below]: OperatorSpec(
    needsLeft: true,
    needsRight: true,
    associativity: Associativity.right,
    precedence: precendeceSubsup,
    handler: (left, right, op, lexer) {
      var leftOperand = left;
      if (left.isEmpty) {
        final forward = lexer.fetch();
        if (forward != null && checkOperator(forward) != ' ') {
          leftOperand = [forward];
          lexer.consume();
        }
      }
      if (checkOperator(op) == UmChars.above) {
        return [
          OverNode(
            base: leftOperand.wrapWithEquationRow(),
            above: right.wrapWithEquationRow(),
          )
        ];
      } else {
        return [
          UnderNode(
            base: leftOperand.wrapWithEquationRow(),
            below: right.wrapWithEquationRow(),
          )
        ];
      }
    },
  ),
};
