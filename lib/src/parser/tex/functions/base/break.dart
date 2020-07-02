part of latex_base;

const _breakEntries = {
  ['\\nobreak', '\\allowbreak']:
      FunctionSpec(numArgs: 0, handler: _breakHandler)
};

GreenNode _breakHandler(TexParser parser, FunctionContext context) => SpaceNode(
      height: Measurement.zero,
      width: Measurement.zero,
      noBreak: context.funcName == '\\nobreak',
      mode: parser.mode,
    );
