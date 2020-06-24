import 'package:flutter/widgets.dart';

import '../../font/metrics/font_metrics.dart';
import '../../font/metrics/font_metrics_data.dart';
import '../../parser/tex_parser/symbols.dart';
import '../../parser/tex_parser/types.dart';
import '../../render/layout/reset_dimension.dart';
import '../options.dart';
import '../size.dart';
import '../symbols.dart';
import '../syntax_tree.dart';

enum DelimiterSize {
  size1,
  size2,
  size3,
  size4,
}

class MathAtomNode extends LeafNode {
  final String text;
  final bool variantForm;
  final FontOptions fontOptions;
  AtomType _atomType;
  AtomType get atomType =>
      _atomType ??= symbolRenderConfigs[text].math.defaultType ?? AtomType.ord;

  MathAtomNode({
    this.text,
    this.variantForm = false,
    this.fontOptions,
    AtomType atomType,
  }) : _atomType = atomType;

  @override
  List<BuildResult> buildWidget(
      Options options, List<List<BuildResult>> childBuildResults) {
    if (fontOptions != null) {
      return [
        BuildResult(
          options: options,
          widget: makeChar(text, fontOptions, options),
          italic: Measurement.zero,
        )
      ];
    }

    // TODO incorporate symbolsOp.js

    final mode = options.mode; //TODO

    final useMathFont = mode == Mode.math ||
        (mode == Mode.text && options.mathFontOptions != null);
    final font =
        useMathFont ? options.mathFontOptions : options.textFontOptions;

    // surrogate pairs will ignore any user-specified font changes
    if (text.codeUnitAt(0) != 0xD835) {
      if (font != null) {
        if (lookupSymbol(text, font, mode) != null) {
          return [
            BuildResult(
              options: options,
              italic: lookupSymbol(text, font, mode).italic.cssEm,
              widget: makeChar(text, font, options),
            )
          ];
        } else if (ligatures.containsKey(text) &&
            font.fontFamily == 'Typewriter') {
          final expandedText = ligatures[text];
          return [
            BuildResult(
              options: options,
              widget: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: expandedText
                    .split('')
                    .map((e) => makeChar(e, font, options))
                    .toList(growable: false),
              ),
              italic: Measurement.zero,
            )
          ];
        }
      }
    }

    // If the code reaches here, it means we failed to find any appliable
    // user-specified font. We will use default render configs.
    final renderConfig = symbolRenderConfigs[text].math;
    final replaceChar = renderConfig.replaceChar ?? text;
    final defaultFont = renderConfig.defaultFont;
    final characterMetrics = getCharacterMetrics(
        character: replaceChar, fontName: defaultFont.fontName, mode: mode);
    // fontMetricsData[defaultFont.fontName][replaceChar.codeUnitAt(0)];
    return [
      BuildResult(
        options: options,
        widget: makeChar(replaceChar, defaultFont, options),
        italic: characterMetrics?.italic?.cssEm ?? Measurement.zero,
      )
    ];
  }

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      oldOptions.mode != newOptions.mode ||
      oldOptions.mathFontOptions != newOptions.mathFontOptions ||
      oldOptions.textFontOptions != newOptions.textFontOptions ||
      oldOptions.sizeMultiplier != newOptions.sizeMultiplier;

  @override
  int get width => 1;

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;
}

// BuildResult makeSymbol(
//     String text, String fontName, Mode mode, Options options) {}

Widget makeChar(String character, FontOptions font, Options options) {
  final characterMetrics =
      fontMetricsData[font.fontName][character.codeUnitAt(0)];
  return ResetDimension(
    height: characterMetrics?.height?.cssEm?.toLpUnder(options),
    depth: characterMetrics?.depth?.cssEm?.toLpUnder(options),
    child: Text(
      character,
      style: TextStyle(
        fontFamily: 'KaTeX_${font.fontFamily}',
        fontWeight: font.fontWeight,
        fontStyle: font.fontShape,
        fontSize: 1.21.cssEm.toLpUnder(options),
      ),
    ),
  );
}

CharacterMetrics lookupSymbol(String value, FontOptions font, Mode mode) {
  final renderConfig = mode == Mode.math
      ? symbolRenderConfigs[value].math
      : symbolRenderConfigs[value].text;
  return getCharacterMetrics(
    character: renderConfig?.replaceChar ?? value,
    fontName: (font?.fontName ?? renderConfig?.defaultFont?.fontName) ??
        'Main-Regular',
    mode: mode,
  );
}

final _numberDigitRegex = RegExp('[0-9]');

final _mathitLetters = {
  // "\\imath", TODO
  'ı', // dotless i
  // "\\jmath", TODO
  'ȷ', // dotless j
  // "\\pounds", "\\mathsterling", "\\textsterling", TODO
  '£', // pounds symbol
};

FontOptions mathdefault(String value) {
  if (_numberDigitRegex.hasMatch(value[0]) || _mathitLetters.contains(value)) {
    return FontOptions(
      fontFamily: 'Main',
      fontShape: FontStyle.italic,
    );
  } else {
    return FontOptions(
      fontFamily: 'Math',
      fontShape: FontStyle.italic,
    );
  }
}
