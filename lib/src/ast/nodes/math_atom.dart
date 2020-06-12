import 'package:flutter/widgets.dart';
import 'package:flutter_math/src/ast/size.dart';

import '../../parser/tex_parser/symbols.dart';
import '../../parser/tex_parser/types.dart';
import '../options.dart';
import '../syntax_tree.dart';

enum DelimiterSize {
  size1,
  size2,
  size3,
  size4,
}

class MathAtomNode extends LeafNode {
  final String text;
  final FontOptions fontOptions;
  final DelimiterSize delimSize;
  AtomType _atomType;
  AtomType get atomType =>
      _atomType ??= symbols[Mode.math][text].group.atomType ?? AtomType.ord;

  Measurement get italic => throw UnimplementedError();

  MathAtomNode({
    this.text,
    this.fontOptions,
    AtomType atomType,
    this.delimSize,
  }) : _atomType = atomType;

  @override
  Widget buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions) {
    return null;
  }

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) {
    // TODO: implement shouldRebuildWidget
    return null;
  }

  @override
  // TODO: implement width
  int get width => null;

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;
}
