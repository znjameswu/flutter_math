part of katex_base;

const _charEntries = {
  ['\\@char']:
      FunctionSpec(numArgs: 1, allowedInText: true, handler: _charHandler),
};
GreenNode _charHandler(TexParser parser, FunctionContext context) {
  final arg = assertNodeType<EquationRowNode>(
      parser.parseArgNode(mode: null, optional: false));
  final number = arg.children
      .map((child) => assertNodeType<AtomNode>(child).symbol)
      .join('');
  final code = int.tryParse(number);
  if (code == null) {
    throw ParseError('\\@char has non-numeric argument $number');
  }
  return AtomNode(
    symbol: String.fromCharCode(code),
    mode: parser.mode,
    atomType: AtomType.ord,
  );
}
