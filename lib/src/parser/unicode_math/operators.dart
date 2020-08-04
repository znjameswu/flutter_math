library um_operators;

import 'dart:math' as math;

import 'package:flutter_math/src/ast/nodes/enclosure.dart';
import 'package:flutter_math/src/ast/nodes/equation_array.dart';
import 'package:flutter_math/src/ast/nodes/matrix.dart';
import 'package:flutter_math/src/ast/nodes/phantom.dart';
import 'package:flutter_math/src/ast/nodes/space.dart';
import 'package:meta/meta.dart';

import '../../ast/nodes/accent.dart';
import '../../ast/nodes/accent_under.dart';
import '../../ast/nodes/atom.dart';
import '../../ast/nodes/frac.dart';
import '../../ast/nodes/function.dart';
import '../../ast/nodes/left_right.dart';
import '../../ast/nodes/multiscripts.dart';
import '../../ast/nodes/nary_op.dart';
import '../../ast/nodes/over.dart';
import '../../ast/nodes/sqrt.dart';
import '../../ast/nodes/under.dart';
import '../../ast/size.dart';
import '../../ast/syntax_tree.dart';
import '../../utils/iterable_extensions.dart';
import '../../utils/unicode_literal.dart';
import 'chars.dart';
import 'errors.dart';
import 'fold.dart';
import 'keywords.dart';

part 'operators/accent.dart';
part 'operators/divide.dart';
part 'operators/encl_bar.dart';
part 'operators/encl_box.dart';
part 'operators/encl_eqarray.dart';
part 'operators/encl_matrix.dart';
part 'operators/encl_phantom.dart';
part 'operators/encl_rect.dart';
part 'operators/encl_root.dart';
part 'operators/list_delims.dart';
part 'operators/nary.dart';
part 'operators/normal.dart';
part 'operators/openclose.dart';
part 'operators/stretch_horiz.dart';
part 'operators/stretch_over.dart';
part 'operators/stretch_under.dart';
part 'operators/subsup.dart';
part 'operators/subsupFA.dart';
part 'operators/unisubsup.dart';

const precedenceCR = 0.0;
const precedenceOpen = 1.0;
const precedenceClose = 2.0;
const precedenceListDelims = 3.0;
const precedenceNormal = 4.0;
const precedenceDivide = 5.0;
const precedenceNary = 6.0;
const precendeceSubsup = 7.0;
const precedenceUnaryFun = 8.0;
const precedenceCombMark = 9.0;

const precedenceAtom = double.infinity;

enum Associativity {
  left,
  right,
}

typedef UmOpHandler = List<GreenNode> Function(List<GreenNode> left,
    List<GreenNode> right, GreenNode op, UmReverseLexer lexer);

List<GreenNode> defaultHandler(List<GreenNode> left, List<GreenNode> right,
        GreenNode op, UmReverseLexer lexer) =>
    [...left, op, ...right];

class OperatorSpec {
  final bool needsLeft;
  final bool needsRight;

  final bool unwrapLeft;
  final bool unwrapRight;

  /// If marked as left associative, then in reverse parsing, it will fold left
  /// operand with the same level of precedence.
  ///
  /// If marked as right associative, then it will stop when encountering op
  /// with the same precedence.
  final Associativity associativity;

  final double precedence;

  ///
  final UmOpHandler handler;

  bool get causeFolding => _causeFolding ?? handler != defaultHandler;
  final bool _causeFolding;

  final bool consumeLeftSpace;

  const OperatorSpec({
    @required this.needsLeft,
    @required this.needsRight,
    this.unwrapLeft = true,
    this.unwrapRight = true,
    @required this.associativity,
    @required this.precedence,
    this.handler = defaultHandler,
    bool causeFolding,
    this.consumeLeftSpace = false,
  }) : _causeFolding = causeFolding;

  const OperatorSpec.normal({
    this.needsLeft = true,
    this.needsRight = true,
    this.unwrapLeft = false,
    this.unwrapRight = false,
    this.associativity = Associativity.right,
    this.precedence = precedenceNormal,
    this.handler = defaultHandler,
    bool causeFolding,
    this.consumeLeftSpace = false,
  }) : _causeFolding = causeFolding;

  const OperatorSpec.unaryFun({
    this.needsLeft = false,
    this.needsRight = true,
    this.unwrapLeft = false,
    this.unwrapRight = true,
    this.associativity = Associativity.right,
    this.precedence = precedenceUnaryFun,
    @required this.handler,
    bool causeFolding,
    this.consumeLeftSpace = false,
  }) : _causeFolding = causeFolding;
}

final Map<List<String>, OperatorSpec> umOperatorEntries = {
  ..._accentEntries,
  ..._divideEntries,
  ..._enclBarEntries,
  ..._enclBoxEntries,
  ..._enclEqarrayEntries,
  ..._enclMatrixEntries,
  ..._enclPhantomEntries,
  ..._enclRectEntries,
  ..._enclRootEntries,
  ..._listDelimsEntries,
  ..._naryEntries,
  ..._normalEntries,
  ..._opencloseEntries,
  ..._stretchHorizEntries,
  ..._stretchUnderEntries,
  ..._stretchOverEntries,
  ..._subsupEntries,
  ..._subsupFAEntries,
  // ..._unisubsupEntries,
};

extension RegisterFunctionExt<T> on Map<String, T> {
  void registerEntries(Map<Iterable<String>, T> entries) {
    entries.forEach((key, value) {
      for (final name in key) {
        this[name] = value;
      }
    });
  }
}

extension IsDigit on String {
  static final digitRegex = RegExp(r'^[0-9]$');
  static final asciiAlphaNumeric = RegExp(r'^[a-zA-Z0-9]$');
  bool get isDigit => digitRegex.hasMatch(this);
  bool get isAsciiAlphaNumeric => asciiAlphaNumeric.hasMatch(this);
}

Map<String, OperatorSpec> _umOperators;

Map<String, OperatorSpec> get umOperators => _umOperators ??=
    <String, OperatorSpec>{}..registerEntries(umOperatorEntries);

extension on Set<String> {
  Set<String> umAutoCorrect() => this.map((e) {
        if (e.length >= 1) {
          assert(umKeywords[e] != null);
          return umKeywords[e];
        }
        throw UmIllegalKeywordsException('Illegal keywords encountered： $e');
      }).toSet();
}

const divideOperators = {'/', UmChars.atop};

const subsupOperators = {'_', '^', UmChars.above, UmChars.below};

final normalOperators = umCharProps.entries
    .where(
        (entry) => entry.value == UmCharProp.normal && entry.key != UmChars.of)
    .map((e) => e.key)
    .toSet();

String checkOperator(GreenNode node) {
  if (node is AtomNode) {
    if (!node.unicodeMathLiteral && umOperators.containsKey(node.symbol)) {
      return node.symbol;
    } else if (node.unicodeMathLiteral &&
        umOperators[node.symbol]?.causeFolding == false) {
      return node.symbol;
    }
  }
  return null;
}

String checkChar(GreenNode node) {
  if (node is AtomNode) {
    return node.symbol;
  }
  // TODO spaces
  return null;
}

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
