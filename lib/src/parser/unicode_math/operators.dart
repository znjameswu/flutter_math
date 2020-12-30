import 'chars.dart';

const divideOperators = {'/', UmChars.atop};

const subsupOperators = {'_', '^', UmChars.above, UmChars.below};

final normalOperators = umCharProps.entries
    .where(
        (entry) => entry.value == UmCharProp.normal && entry.key != UmChars.of)
    .map((e) => e.key)
    .toSet();

const subsupPair = {
  '_': {'^', "'"},
  '^': {'_'},
  UmChars.above: {UmChars.below},
  UmChars.below: {UmChars.above},
  "'": {'_'},
};

const unaryableBinaryOp = {
  '+',
  '-',
  UmChars.mp,
  UmChars.pm,
};

const unary = {
  UmChars.exists,
  UmChars.forall,
  UmChars.inc,
  UmChars.nabla,
  UmChars.neg,
  UmChars.partial,
};

// TODO special case for ! and !!
