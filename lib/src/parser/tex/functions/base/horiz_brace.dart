part of latex_base;

const _horizBraceEntries = {
  ['\\overbrace', '\\underbrace']:
      FunctionSpec(numArgs: 1, handler: _horizBraceHandler),
};

GreenNode _horizBraceHandler(TexParser parser, FunctionContext context) {
  final base = parser.parseArgNode(mode: null, optional: false);
  final scripts = parser.parseScripts();
  var res = base;
  if (context.funcName == '\\overbrace') {
    res = AccentNode(
      base: res.wrapWithEquationRow(),
      label: '\u23de',
      isStretchy: true,
      isShifty: false,
    );
    if (scripts.superscript != null) {
      res = OverNode(
        base: res.wrapWithEquationRow(),
        above: scripts.superscript,
      );
    }
    if (scripts.subscript != null) {
      res = UnderNode(
        base: res.wrapWithEquationRow(),
        below: scripts.subscript,
      );
    }
    return res;
  } else {
    res = AccentUnderNode(
      base: res.wrapWithEquationRow(),
      label: '\u23de',
    );
    if (scripts.subscript != null) {
      res = UnderNode(
        base: res.wrapWithEquationRow(),
        below: scripts.subscript,
      );
    }
    if (scripts.superscript != null) {
      res = OverNode(
        base: res.wrapWithEquationRow(),
        above: scripts.superscript,
      );
    }
    return res;
  }
}
