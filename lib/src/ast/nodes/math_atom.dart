import 'package:flutter/widgets.dart';

import '../../render/symbols/make_atom.dart';
import '../options.dart';
import '../symbols.dart';
import '../syntax_tree.dart';
import '../types.dart';

enum DelimiterSize {
  size1,
  size2,
  size3,
  size4,
}

abstract class AtomNode extends LeafNode {
  String get symbol;
  bool get variantForm;
  AtomType get atomType;

  
}

class MathAtomNode extends LeafNode implements AtomNode {
  final String symbol;
  final bool variantForm;
  AtomType _atomType;
  AtomType get atomType => _atomType ??=
      symbolRenderConfigs[symbol].math.defaultType ?? AtomType.ord;
  final FontOptions overrideFont;

  MathAtomNode({
    @required this.symbol,
    this.variantForm = false,
    AtomType atomType,
    this.overrideFont,
  }) : _atomType = atomType;

  @override
  List<BuildResult> buildWidget(
          Options options, List<List<BuildResult>> childBuildResults) =>
      makeAtom(
        symbol: symbol,
        variantForm: variantForm,
        atomType: atomType,
        overrideFont: overrideFont,
        mode: Mode.math,
        options: options,
      );

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.mathFontOptions != newOptions.mathFontOptions ||
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;

  @override
  AtomType get leftType => atomType;

  @override
  AtomType get rightType => atomType;
}
