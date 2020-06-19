import 'package:flutter/widgets.dart';
import 'package:flutter_math/src/parser/tex_parser/font.dart';

import '../../font/metrics/font_metrics.dart';
import '../../parser/tex_parser/symbols.dart';
import '../../parser/tex_parser/types.dart';
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

  Measurement get italic => 0.0.pt; // TODO

  MathAtomNode({
    this.text,
    this.fontOptions,
    AtomType atomType,
    this.delimSize,
  }) : _atomType = atomType;

  @override
  Widget buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions) {
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
        return makeSymbol(text, font.fontName, mode, options);
      } else if (ligatures.contains(text) && font.fontFamily == 'Typewriter') {
        final text = symbols[mode][this.text].name;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: text
              .split('')
              .map((e) => makeSymbol(e, font.fontName, mode, options))
              .toList(growable: false),
        );
      }
    }

    final defaultFont = symbolRenderConfigs[text].math.defaultFont;
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'KaTeX_' + defaultFont.fontFamily,
        fontWeight: defaultFont.fontWeight,
        fontStyle: defaultFont.fontShape,
        fontSize: 1.0.cssEm.toLpUnder(options),
      ),
    );
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

Widget makeSymbol(String text, String fontName, Mode mode, Options options) {
}

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
