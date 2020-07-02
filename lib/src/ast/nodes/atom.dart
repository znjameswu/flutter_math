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

class AtomNode extends LeafNode {
  final String symbol;
  final bool variantForm;
  AtomType _atomType;
  AtomType get atomType => _atomType ??= (mode == Mode.math
          ? symbolRenderConfigs[symbol].math.defaultType
          : symbolRenderConfigs[symbol].text.defaultType) ??
      AtomType.ord;
  final FontOptions overrideFont;

  final Mode mode;

  bool get noBreak => symbol == '\u00AF';

  AtomNode({
    @required this.symbol,
    this.variantForm = false,
    AtomType atomType,
    this.overrideFont,
    this.mode = Mode.math,
  }) : _atomType = atomType;

  @override
  List<BuildResult> buildWidget(
          Options options, List<List<BuildResult>> childBuildResults) =>
      makeAtom(
        symbol: symbol,
        variantForm: variantForm,
        atomType: atomType,
        overrideFont: overrideFont,
        mode: mode,
        options: options,
      );

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.mathFontOptions != newOptions.mathFontOptions ||
      oldOptions.textFontOptions != newOptions.textFontOptions ||
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;

  @override
  AtomType get leftType => atomType;

  @override
  AtomType get rightType => atomType;
}

EquationRowNode stringToNode(String string, [Mode mode = Mode.text]) {
  return EquationRowNode(
    children: string
        .split('')
        .map((ch) => AtomNode(symbol: ch, mode: mode))
        .toList(growable: false),
  );
}
