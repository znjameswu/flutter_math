import 'package:flutter_math/src/ast/symbols.dart';

import '../../ast/options.dart';
import '../../ast/size.dart';
import '../../ast/style.dart';
import '../../font/metrics/font_metrics.dart';
import '../../parser/tex_parser/types.dart';
import '../../utils/unicode_literal.dart';



class DelimiterConf{
  final String fontName;
  final MathStyle style;

  const DelimiterConf(this.fontName, this.style);
}

const stackNeverDelimiterSequence = [
  DelimiterConf('Main-Regular', MathStyle.scriptscript),
  DelimiterConf('Main-Regular', MathStyle.script),
  DelimiterConf('Main-Regular', MathStyle.text),
  DelimiterConf('Size1-Regular', MathStyle.text),
  DelimiterConf('Size2-Regular', MathStyle.text),
  DelimiterConf('Size3-Regular', MathStyle.text),
  DelimiterConf('Size4-Regular', MathStyle.text),
];

const stackAlwaysDelimiterSequence = [
  DelimiterConf('Main-Regular', MathStyle.scriptscript),
  DelimiterConf('Main-Regular', MathStyle.script),
  DelimiterConf('Main-Regular', MathStyle.text),
];

const stackLargeDelimiterSequence = [
  DelimiterConf('Main-Regular', MathStyle.scriptscript),
  DelimiterConf('Main-Regular', MathStyle.script),
  DelimiterConf('Main-Regular', MathStyle.text),
  DelimiterConf('Size1-Regular', MathStyle.text),
  DelimiterConf('Size2-Regular', MathStyle.text),
  DelimiterConf('Size3-Regular', MathStyle.text),
  DelimiterConf('Size4-Regular', MathStyle.text),
];

double getHeightForDelim({
  String delim,
  String fontName,
  MathStyle style,
  Options options,
}) {
  final char = symbolRenderConfigs[delim]?.math?.replaceChar ?? delim;
  final metrics = getCharacterMetrics(
      character: char, fontName: fontName, mode: Mode.math);
  if (metrics == null) {
    throw StateError('Illegal delimiter char $delim'
        '(${unicodeLiteral(delim)}) appeared in AST');
  }
  final fullHeight = metrics.height + metrics.depth;
  final newOptions = options.havingStyle(style);
  return fullHeight.cssEm.toLpUnder(newOptions);
}