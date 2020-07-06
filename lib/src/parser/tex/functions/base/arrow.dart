part of latex_base;

const _arrowEntries = {
  [
    '\\xleftarrow', '\\xrightarrow', '\\xLeftarrow', '\\xRightarrow',
    '\\xleftrightarrow', '\\xLeftrightarrow', '\\xhookleftarrow',
    '\\xhookrightarrow', '\\xmapsto', '\\xrightharpoondown',
    '\\xrightharpoonup', '\\xleftharpoondown', '\\xleftharpoonup',
    '\\xrightleftharpoons', '\\xleftrightharpoons', '\\xlongequal',
    '\\xtwoheadrightarrow', '\\xtwoheadleftarrow', '\\xtofrom',
    // The next 3 functions are here to support the mhchem extension.
    // Direct use of these functions is discouraged and may break someday.
    '\\xrightleftarrows', '\\xrightequilibrium', '\\xleftequilibrium',
  ]: FunctionSpec(
    numArgs: 1,
    numOptionalArgs: 1,
    handler: _arrowHandler,
  )
};

const _arrowCommandMapping = {
  '\\xleftarrow': '\u2190',
  '\\xrightarrow': '\u2192',
  '\\xleftrightarrow': '\u2194',

  '\\xLeftarrow': '\u21d0',
  '\\xRightarrow': '\u21d2',
  '\\xLeftrightarrow': '\u21d4',

  '\\xhookleftarrow': '\u21a9',
  '\\xhookrightarrow': '\u21aa',

  '\\xmapsto': '\u21a6',

  '\\xrightharpoondown': '\u21c1',
  '\\xrightharpoonup': '\u21c0',
  '\\xleftharpoondown': '\u21bd',
  '\\xleftharpoonup': '\u21bc',
  '\\xrightleftharpoons': '\u21cc',
  '\\xleftrightharpoons': '\u21cb',

  '\\xlongequal': '=',

  '\\xtwoheadleftarrow': '\u219e',
  '\\xtwoheadrightarrow': '\u21a0',
  
  '\\xtofrom': '\u21c4',
  '\\xrightleftarrows': '\u21c4',
  '\\xrightequilibrium': '\u21cc', // Not a perfect match.
  '\\xleftequilibrium': '\u21cb', // None better available.
};

GreenNode _arrowHandler(TexParser parser, FunctionContext context) {
  final below = parser.parseArgNode(mode: null, optional: true);
  final above = parser.parseArgNode(mode: null, optional: false);
  return StretchyOpNode(
    above: above.wrapWithEquationRow(),
    below: below?.wrapWithEquationRow(),
    symbol: _arrowCommandMapping[context.funcName] ?? context.funcName,
  );
}
