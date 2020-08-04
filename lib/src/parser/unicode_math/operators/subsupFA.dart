// ignore_for_file: file_names
part of um_operators;

final _subsupFAEntries = {
  [UmChars.funcapply]: OperatorSpec.normal(
    associativity: Associativity.right,
    handler: (left, right, op, lexer) {
      if (left.every((element) {
        final ch = checkChar(element);
        return ch != null &&
            (ch.isAsciiAlphaNumeric == true || ch == UmChars.nbsp);
      })) {
        return [
          FunctionNode(
            functionName: left.wrapWithEquationRow(), // TODO Convert to text
            argument: right.wrapWithEquationRow(),
          ),
        ];
      } else {
        return [
          FunctionNode(
            functionName: left.wrapWithEquationRow(),
            argument: right.wrapWithEquationRow(),
          ),
        ];
      }
    },
  ),
};