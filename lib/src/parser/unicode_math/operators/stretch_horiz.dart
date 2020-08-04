part of um_operators;

const stretchHorizOperators = {
  UmChars.dashv,
  UmChars.gets,
  UmChars.hookleftarrow,
  UmChars.hookrightarrow,
  UmChars.Leftarrow,
  UmChars.leftharpoondown,
  UmChars.leftharpoonup,
  UmChars.Leftrightarrow,
  UmChars.leftrightarrow,
  UmChars.mapsto,
  UmChars.models,
  UmChars.Rightarrow,
  UmChars.rightarrow,
  UmChars.rightharpoondown,
  UmChars.rightharpoonup,
  UmChars.vdash,
};

const _stretchHorizEntries = {
  [...stretchHorizOperators]: OperatorSpec.normal(),
};
