part of latex_base;

const _phantomEntries = {
  ['\\phantom', '\\hphantom', '\\vphantom']:
      FunctionSpec(numArgs: 1, allowedInText: true, handler: _phantomHandler),
};

GreenNode _phantomHandler(TexParser parser, FunctionContext context) {
  final body = parser.parseArgNode(mode: null, optional: false);
  return PhantomNode(
    phantomChild: body.wrapWithEquationRow(),
    zeroHeight: context.funcName == '\\hphantom',
    zeroWidth: context.funcName == '\\vphantom',
  );
}
