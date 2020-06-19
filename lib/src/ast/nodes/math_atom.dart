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
  final FontOptions fontOptions;
  final DelimiterSize delimSize;
  AtomType _atomType;
  AtomType get atomType =>
      _atomType ??= symbolRenderConfigs[text].math.defaultType ?? AtomType.ord;

  MathAtomNode({
    this.text,
    this.fontOptions,
    AtomType atomType,
    this.delimSize,
  }) : _atomType = atomType;

  @override
  List<BuildResult> buildWidget(
      Options options, List<List<BuildResult>> childBuildResults) {
    // TODO incorporate symbolsOp.js

    final mode = Mode.math; //TODO

    final useMathFont = mode == Mode.math ||
        (mode == Mode.text && options.mathFontOptions != null);
    final font =
        useMathFont ? options.mathFontOptions : options.textFontOptions;

    if (text.codeUnitAt(0) == 0xD835) {
      // surrogate pairs get special treatment
      //TODO
    } else if (font != null) {
      if (lookupSymbol(text, font.fontName, mode) != null) {
        return [makeSymbol(text, font.fontName, mode, options)];
      } else if (ligatures.contains(text) && font.fontFamily == 'Typewriter') {
        final text = symbols[mode][this.text].name;
        return [
          BuildResult(
            options: options,
            widget: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: text
                  .split('')
                  .map(
                      (e) => makeSymbol(e, font.fontName, mode, options).widget)
                  .toList(growable: false),
            ),
            italic: Measurement.zero,
          )
        ];
      }
    }

    final defaultFont = symbolRenderConfigs[text].math.defaultFont;
    final characterMetrics =
        fontMetricsData[defaultFont.fontName][text.codeUnitAt(0)];
    return [
      BuildResult(
        options: options,
        widget: ResetDimension(
          height: characterMetrics?.height?.cssEm?.toLpUnder(options),
          depth: characterMetrics?.depth?.cssEm?.toLpUnder(options),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'KaTeX_${defaultFont.fontFamily}',
              fontWeight: defaultFont.fontWeight,
              fontStyle: defaultFont.fontShape,
              fontSize: 1.21.cssEm.toLpUnder(options),
            ),
          ),
        ),
        italic: characterMetrics?.italic?.cssEm ?? Measurement.zero,
      )
    ];
    // if (mode == Mode.math) {
    //   final fontLookup = mathdefault(text);
    //   return makeSymbol(text, fontLookup.fontName, mode, options);
    // } else if (mode == Mode.text) {
    //   final font = symbols[mode][text]?.font;
    //   if (font == Font.ams) {
    //     final fontName = fontOptionsTable['amsrm'].fontName;
    //     return makeSymbol(text, fontName, mode, options);
    //   } else if (font == Font.ams || font == null) {
    //     final fontName = fontOptionsTable['textrm'].fontName;
    //     return makeSymbol(text, fontName, mode, options);
    //   } else {
    //     // fonts added by plugins
    //     // Currently we do not implement this
    //     throw UnsupportedError('We do not support plugin fonts at this time');
    //   }
    // }
  }

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) {
    // TODO: implement shouldRebuildWidget
    return null;
  }

  @override
  int get width => 1;

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;
}

BuildResult makeSymbol(
    String text, String fontName, Mode mode, Options options) {}

CharacterMetrics lookupSymbol(String value, String fontName, Mode mode) {
  // We will figure out a way to bypass KaTeX's symbol
  // TODO
  return getCharacterMetrics(character: value, font: fontName, mode: mode);
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
