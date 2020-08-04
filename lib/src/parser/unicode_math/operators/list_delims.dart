part of um_operators;

const listDelimsOperators = {
  '&',
  '@',
  UmChars.mid,
  UmChars.vbar,
};

const _listDelimsEntries = {
  [...listDelimsOperators]:
      OperatorSpec.normal(precedence: precedenceListDelims),
};
