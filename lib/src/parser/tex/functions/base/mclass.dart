part of latex_base;

const _mclassEntries = {
  [
    '\\mathop',
    '\\mathord',
    '\\mathbin',
    '\\mathrel',
    '\\mathopen',
    '\\mathclose',
    '\\mathpunct',
    '\\mathinner',
  ]: FunctionSpec(numArgs: 1, handler: _mclassHandler),
};

GreenNode _mclassHandler(TexParser parser, FunctionContext context) {
  final body = parser.parseArgNode(mode: null, optional: false);
  return EquationRowNode(
      children: body.expandEquationRow(),
      overrideType: const {
        '\\mathop': AtomType.op,
        '\\mathord': AtomType.ord,
        '\\mathbin': AtomType.bin,
        '\\mathrel': AtomType.rel,
        '\\mathopen': AtomType.open,
        '\\mathclose': AtomType.close,
        '\\mathpunct': AtomType.punct,
        '\\mathinner': AtomType.inner,
      }[context.funcName]);
}
