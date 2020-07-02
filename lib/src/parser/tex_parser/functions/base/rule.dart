part of latex_base;

const _ruleEntries = {
  ['\\rule']:
      FunctionSpec(numArgs: 2, numOptionalArgs: 1, handler: _ruleHandler),
};
GreenNode _ruleHandler(TexParser parser, FunctionContext context) {
  final shift = parser.parseArgSize(optional: true) ?? Measurement.zero;
  final width = parser.parseArgSize(optional: false);
  final height = parser.parseArgSize(optional: false);

  return SpaceNode(
    height: height,
    width: width,
    shift: shift,
    background: Colors.black,
    mode: Mode.math,
  );
}
