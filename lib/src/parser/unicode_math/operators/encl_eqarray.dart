part of um_operators;

final _enclEqarrayEntries = {
  [UmChars.eqarray]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) {
      final rows = right
          .splitBy((element) => checkOperator(element) == '@')
          .map(
            (row) => row
                .map((e) =>
                    checkOperator(e) == '&' ? SpaceNode.alignerOrSpacer() : e)
                .toList(growable: false)
                .wrapWithEquationRow(),
          )
          .toList(growable: false);
      return [EquationArrayNode(body: rows)];
    },
  )
};
