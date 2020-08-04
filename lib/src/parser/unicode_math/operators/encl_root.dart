part of um_operators;

final _enclRootEntries = {
  [UmChars.sqrt, UmChars.cbrt, UmChars.qdrt]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) {
      List<GreenNode> index;
      List<GreenNode> base;
      switch (checkOperator(op)) {
        case UmChars.cbrt:
          index = [AtomNode(symbol: '3')];
          base = right;
          break;
        case UmChars.qdrt:
          index = [AtomNode(symbol: '4')];
          base = right;
          break;
        case UmChars.sqrt:
          final splitPos =
              right.indexWhere((element) => checkOperator(element) == '&');
          if (splitPos != -1 &&
              right.indexWhere((element) => checkOperator(element) == '&',
                      splitPos + 1) ==
                  -1) {
            base = right.sublist(splitPos + 1, right.length);
            index = right.sublist(0, splitPos);
          } else {
            base = right;
          }
          break;
        default:
          throw StateError('');
      }
      return [
        SqrtNode(
          index: index?.wrapWithEquationRow(),
          base: base.wrapWithEquationRow(),
        ),
      ];
    },
  ),
};
