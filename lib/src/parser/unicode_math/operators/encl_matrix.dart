part of um_operators;

final _enclMatrixEntries = {
  [UmChars.matrix]: OperatorSpec.unaryFun(
    handler: (left, right, op, lexer) {
      final rows = right
          .splitBy((element) => checkOperator(element) == '@')
          .map(
            (row) => row
                .splitBy((element) => checkOperator(element) == '&')
                .map((cell) => cell.wrapWithEquationRow())
                .toList(growable: false),
          )
          .toList(growable: false);
      return [MatrixNode(body: rows)];
    },
  )
};
