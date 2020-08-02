import 'package:flutter/widgets.dart';


import '../../render/symbols/make_atom.dart';
import '../../utils/unicode_literal.dart';
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
  AtomType get atomType => _atomType ??=
      getDefaultAtomTypeForSymbol(symbol, variantForm: variantForm, mode: mode);
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
      [
        makeAtom(
          symbol: symbol,
          variantForm: variantForm,
          atomType: atomType,
          overrideFont: overrideFont,
          mode: mode,
          options: options,
        )
      ];

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.mathFontOptions != newOptions.mathFontOptions ||
      oldOptions.textFontOptions != newOptions.textFontOptions ||
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;

  @override
  AtomType get leftType => atomType;

  @override
  AtomType get rightType => atomType;

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'mode': mode.toString(),
      'symbol': unicodeLiteral(symbol),
      if (variantForm) 'variantForm': variantForm,
      if (_atomType != null) 'atomType': _atomType.toString(),
    });

  AtomNode copyWith({
    String symbol,
    bool variantForm,
    AtomType atomType,
    FontOptions overrideFont,
    Mode mode,
  }) =>
      AtomNode(
        symbol: symbol ?? this.symbol,
        variantForm: variantForm ?? this.variantForm,
        atomType: _atomType ?? this._atomType,
        overrideFont: overrideFont ?? this.overrideFont,
        mode: mode ?? this.mode,
      );
}

EquationRowNode stringToNode(String string, [Mode mode = Mode.text]) =>
    EquationRowNode(
      children: string
          .split('')
          .map((ch) => AtomNode(symbol: ch, mode: mode))
          .toList(growable: false),
    );
