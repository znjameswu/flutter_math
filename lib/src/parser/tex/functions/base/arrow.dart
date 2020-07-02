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
