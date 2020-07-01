part of latex_base;

const _arrayEntries = {
  ['\\hline', '\\hdashline']: FunctionSpec(
    numArgs: 0,
    allowedInText: true,
    allowedInMath: true,
    handler: _throwExceptionHandler,
  )
};

GreenNode _throwExceptionHandler(TexParser parser, FunctionContext context) {
  throw ParseError('${context.funcName} valid only within array environment');
}
