import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';
import 'load_fonts.dart';

void main() {
  setUpAll(loadKaTeXFonts);

  group('Accent renderer', () {
    const accents = {
      '\\acute',
      '\\grave',
      '\\ddot',
      '\\tilde',
      '\\bar',
      '\\breve',
      '\\check',
      '\\hat',
      '\\vec',
      '\\dot',
      '\\mathring',
      '\\widecheck',
      '\\widehat',
      '\\widetilde',
      '\\overrightarrow',
      '\\overleftarrow',
      '\\Overrightarrow',
      '\\overleftrightarrow',
      // '\\overgroup',
      // '\\overlinesegment',
      '\\overleftharpoon',
      '\\overrightharpoon',
    };
    const accentsUnder = {
      '\\underleftarrow',
      '\\underrightarrow',
      '\\underleftrightarrow',
      '\\undergroup',
      // '\\underlinesegment': ,
      '\\utilde',
      '\\underline'
    };
    for (final command in [...accents, ...accentsUnder]) {
      testTexToMatchGoldenFile(
        'render $command',
        [for (var i = 1; i <= 6; i++) '$command{${'x' * i}}'].join(),
        location: 'golden/${command.substring(1)}.png',
      );
    }
  });

  testTexToMatchGoldenFile(
    'Enclosure renderer',
    r'\fcolorbox{blue}{yellow}{a b}\colorbox{red}{a b}\cancel{x}\bcancel{x}\xcancel{x}\sout{x}\fbox{\frac a b}',
    location: 'golden/enclosure.png',
  );

  testTexToMatchGoldenFile(
    'EqnArray renderer',
    r'\begin{aligned}a&=b&c&=d\\e&=f\end{aligned}',
    location: 'golden/eqnarray.png',
  );

  testTexToMatchGoldenFile(
    'LeftRight renderer',
    r'\left( \dfrac{x}{y} \middle| \dfrac{y}{z} \right} \left. \dfrac{x}{y} \middle|\right>',
    location: '../doc/img/leftright.png',
  );

  testTexToMatchGoldenFile(
    'Matrix renderer',
    r'\begin{array}{c|r:}a & b \\c & d\end{array}',
    location: '../doc/img/matrix.png',
  );

  testTexToMatchGoldenFile(
    'Nary renderer',
    r'\sum_a^b{x}\int_a^b{x}\oiint_a^b{x}',
    location: '../doc/img/nary.png',
  );

  testTexToMatchGoldenFile(
    'Under/over renderer',
    r'\overbrace{a+\dots+a}^{n}\underbrace{a+\dots+a}_{n}',
    location: '../doc/img/underover.png',
  );

  testTexToMatchGoldenFile(
    'Stretchy op renderer',
    r'\xleftarrow{a}\xrightarrow{b}',
    location: '../doc/img/stretchyop.png',
  );
}
