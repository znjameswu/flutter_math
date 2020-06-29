import '../../render/symbols/make_atom.dart';
import '../options.dart';
import '../symbols.dart';
import '../syntax_tree.dart';
import '../types.dart';
import 'math_atom.dart';

class TextAtomNode extends LeafNode implements AtomNode {
  // final List<GreenNode> children;
  final String symbol;
  final bool variantForm;
  AtomType _atomType;
  AtomType get atomType => _atomType ??=
      symbolRenderConfigs[symbol].text.defaultType ?? AtomType.ord;
  final FontOptions overrideFont;

  TextAtomNode({
    this.symbol,
    this.variantForm,
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
        mode: Mode.text,
        options: options,
      );

  @override
  AtomType get leftType => atomType;

  @override
  AtomType get rightType => atomType;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.mathFontOptions != newOptions.mathFontOptions ||
      oldOptions.textFontOptions != newOptions.textFontOptions ||
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;
}

//ignore: non_constant_identifier_names
TextAtomNode VerbNode({String text}) {}
