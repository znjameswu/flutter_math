part of latex_base;

const _raiseBoxEntries = {
  ['\\raisebox']:
      FunctionSpec(numArgs: 2, allowedInText: true, handler: _raiseBoxHandler),
};
GreenNode _raiseBoxHandler(TexParser parser, FunctionContext context) {
  final dy = parser.parseArgSize(optional: false);
  final body = parser.parseArgHbox(optional: false);
  return RaiseBoxNode(
    body: body.wrapWithEquationRow(),
    dy: dy,
  );
}
