part of um_operators;

const openOperators = {'(', '[', '{', UmChars.open, UmChars.begin};

const closeOperators = {')', ']', '}', UmChars.close, UmChars.end};

const opencloseOperators = {'|' , UmChars.norm};

final _opencloseEntries = {
  [')', ']', '}', UmChars.close, UmChars.end]: OperatorSpec(
    needsLeft: true,
    needsRight: false,
    associativity: Associativity.left,
    precedence: precedenceClose,
    handler: (left, right, op, lexer) {
      final leftDelim = checkOperator(lexer.fetch());
      final rightDelim = checkOperator(op);
      if (openOperators.contains(leftDelim)) {
        lexer.consume();
        // TODO separators

        if (leftDelim == UmChars.begin && rightDelim == UmChars.end && true) {
          // TODO separator count == 1
          return left;
        }
        return [
          LeftRightNode(
            body: [
              left.wrapWithEquationRow(),
            ],
            leftDelim: leftDelim == UmChars.open ? null : leftDelim,
            rightDelim: rightDelim == UmChars.close ? null : rightDelim,
          )
        ];
      }

      throw 1;
    },
  ),
  ['(', '[', '{', UmChars.open, UmChars.begin]: OperatorSpec(
    needsLeft: false,
    needsRight: true,
    associativity: Associativity.right,
    precedence: precedenceOpen,
    handler: (left, right, op, parser) {
      throw UmIllegalStateException('Unmatched open operators found: '
          '${unicodeLiteral(checkOperator(op))}');
    },
  ),
  ['|']: OperatorSpec.normal(), // TODO
};