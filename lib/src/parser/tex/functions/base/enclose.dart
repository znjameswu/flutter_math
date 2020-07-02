part of latex_base;

const _encloseEntries = {
  ['\\colorbox']: FunctionSpec(
      numArgs: 2,
      allowedInText: true,
      greediness: 3,
      handler: _colorboxHandler),
  ['\\fcolorbox']: FunctionSpec(
      numArgs: 3,
      allowedInText: true,
      greediness: 3,
      handler: _fcolorboxHandler),
  ['\\fbox']:
      FunctionSpec(numArgs: 1, allowedInText: true, handler: _fboxHandler),
  ['\\cancel', '\\bcancel', '\\xcancel', '\\sout']:
      FunctionSpec(numArgs: 1, handler: _cancelHandler),
};

GreenNode _colorboxHandler(TexParser parser, FunctionContext context) {
  final color = parser.parseArgColor(optional: false);
  final body = parser.parseArgNode(mode: Mode.text, optional: false);
  return EnclosureNode(
    backgroundcolor: color,
    base: body.wrapWithEquationRow(),
    hasBorder: false,
    // FontMetrics.fboxsep
    verticalPadding: 0.3.cssEm,
    // katex.less/.boxpad
    horizontalPadding: 0.3.cssEm,
  );
}

GreenNode _fcolorboxHandler(TexParser parser, FunctionContext context) {
  final borderColor = parser.parseArgColor(optional: false);
  final color = parser.parseArgColor(optional: false);
  final body = parser.parseArgNode(mode: Mode.text, optional: false);
  return EnclosureNode(
    hasBorder: true,
    bordercolor: borderColor,
    backgroundcolor: color,
    base: body.wrapWithEquationRow(),
    // FontMetrics.fboxsep
    verticalPadding: 0.3.cssEm,
    // katex.less/.boxpad
    horizontalPadding: 0.3.cssEm,
  );
}

GreenNode _fboxHandler(TexParser parser, FunctionContext context) {
  final body = parser.parseArgHbox(optional: false);
  return EnclosureNode(
    hasBorder: true,
    base: body.wrapWithEquationRow(),
    // FontMetrics.fboxsep
    verticalPadding: 0.3.cssEm,
    // katex.less/.boxpad
    horizontalPadding: 0.3.cssEm,
  );
}

GreenNode _cancelHandler(TexParser parser, FunctionContext context) {
  final body = parser.parseArgNode(mode: Mode.text, optional: false);
  return EnclosureNode(
    notation: const {
      '\\cancel': ['updiagonalstrike'],
      '\\bcancel': ['downdiagonalstrike'],
      '\\xcancel': ['updiagonalstrike, downdiagonalstrike'],
      '\\sout': ['horizontalstrike'],
    }[context.funcName],
    hasBorder: false,
    base: body.wrapWithEquationRow(),
    // KaTeX/src/functions/enclose.js line 59
    // KaTeX will remove this padding if base is not single char. We won't, as
    // MathJax neither.
    verticalPadding: 0.2.cssEm,
    // katex.less/.cancel-pad
    // KaTeX failed to apply this value, but we will, as MathJax had
    horizontalPadding: 0.2.cssEm,
  );
}
