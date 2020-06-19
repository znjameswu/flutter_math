
// The MIT License (MIT)
//
// Copyright (c) 2013-2019 Khan Academy and other contributors
// Copyright (c) 2020 znjameswu <znjameswu@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// This file is transfromed from KaTeX/src/symbols.js

import 'dart:ui';

import 'package:meta/meta.dart';

import 'options.dart';
import 'syntax_tree.dart';

class SymbolId {
  final String symbol;
  final bool variantForm;
  const SymbolId(
    this.symbol,
    {this.variantForm = false}
  );

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is SymbolId &&
      o.symbol == symbol &&
      o.variantForm == variantForm;
  }

  @override
  int get hashCode => symbol.hashCode ^ variantForm.hashCode;
}
  
class RenderConfig {
  final String replaceChar;
  final FontOptions defaultFont;
  final AtomType defaultType;
  const RenderConfig({
    this.replaceChar,
    @required this.defaultFont,
    @required this.defaultType,
  });
}

class SymbolRenderConfig {
  final RenderConfig math;
  final RenderConfig text;
  final SymbolRenderConfig variantForm;
  const SymbolRenderConfig({
    @required this.math,
    @required this.text,
    this.variantForm,
  });
}

const mainrm = FontOptions();
const amsrm = FontOptions(fontFamily: 'AMS');
const mathdefault = FontOptions(
  fontFamily: 'Math', 
  fontShape: FontStyle.italic,
);

const mainit = FontOptions(fontShape: FontStyle.italic);

// I would like to use combined char + variantForm as map indexes.
// However Dart does not allow custom classes to be used as const map indexes.
// Hence here's the ugly solution.
const symbolRenderConfigs = {
  '0': SymbolRenderConfig( // 0
    math: RenderConfig( // 0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '1': SymbolRenderConfig( // 1
    math: RenderConfig( // 1
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 1
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '2': SymbolRenderConfig( // 2
    math: RenderConfig( // 2
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 2
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '3': SymbolRenderConfig( // 3
    math: RenderConfig( // 3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '4': SymbolRenderConfig( // 4
    math: RenderConfig( // 4
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 4
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '5': SymbolRenderConfig( // 5
    math: RenderConfig( // 5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '6': SymbolRenderConfig( // 6
    math: RenderConfig( // 6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '7': SymbolRenderConfig( // 7
    math: RenderConfig( // 7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '8': SymbolRenderConfig( // 8
    math: RenderConfig( // 8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '9': SymbolRenderConfig( // 9
    math: RenderConfig( // 9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // 9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2261': SymbolRenderConfig( // ≡
    math: RenderConfig( // \equiv, \u2261
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u227A': SymbolRenderConfig( // ≺
    math: RenderConfig( // \prec, \u227A
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u227B': SymbolRenderConfig( // ≻
    math: RenderConfig( // \succ, \u227B
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u223C': SymbolRenderConfig( // ∼
    math: RenderConfig( // \sim, \u223C
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \thicksim
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u22A5': SymbolRenderConfig( // ⊥
    math: RenderConfig( // \perp
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AAF': SymbolRenderConfig( // ⪯
    math: RenderConfig( // \preceq, \u2AAF
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AB0': SymbolRenderConfig( // ⪰
    math: RenderConfig( // \succeq, \u2AB0
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2243': SymbolRenderConfig( // ≃
    math: RenderConfig( // \simeq, \u2243
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2223': SymbolRenderConfig( // ∣
    math: RenderConfig( // \mid, \u2223
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \shortmid
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u226A': SymbolRenderConfig( // ≪
    math: RenderConfig( // \ll, \u226A
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u226B': SymbolRenderConfig( // ≫
    math: RenderConfig( // \gg, \u226B
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u224D': SymbolRenderConfig( // ≍
    math: RenderConfig( // \asymp, \u224D
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2225': SymbolRenderConfig( // ∥
    math: RenderConfig( // \parallel
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: RenderConfig( // \textbardbl
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \shortparallel
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u22C8': SymbolRenderConfig( // ⋈
    math: RenderConfig( // \bowtie, \u22C8, \Join
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2323': SymbolRenderConfig( // ⌣
    math: RenderConfig( // \smile, \u2323
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \smallsmile
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u2291': SymbolRenderConfig( // ⊑
    math: RenderConfig( // \sqsubseteq, \u2291
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2292': SymbolRenderConfig( // ⊒
    math: RenderConfig( // \sqsupseteq, \u2292
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2250': SymbolRenderConfig( // ≐
    math: RenderConfig( // \doteq, \u2250
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2322': SymbolRenderConfig( // ⌢
    math: RenderConfig( // \frown, \u2322
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \smallfrown
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u220B': SymbolRenderConfig( // ∋
    math: RenderConfig( // \ni, \u220B, \owns
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u221D': SymbolRenderConfig( // ∝
    math: RenderConfig( // \propto, \u221D
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \varpropto
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u22A2': SymbolRenderConfig( // ⊢
    math: RenderConfig( // \vdash, \u22A2
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22A3': SymbolRenderConfig( // ⊣
    math: RenderConfig( // \dashv, \u22A3
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '.': SymbolRenderConfig( // .
    math: RenderConfig( // .
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // .
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u22C5': SymbolRenderConfig( // ⋅
    math: RenderConfig( // \cdot, \u22C5
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \centerdot
        defaultFont: amsrm,
        defaultType: AtomType.bin,
      ),
      text: null,
    ),
  ),
  '#': SymbolRenderConfig( // #
    math: RenderConfig( // \#
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \#
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '&': SymbolRenderConfig( // &
    math: RenderConfig( // \&
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \&
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2135': SymbolRenderConfig( // ℵ
    math: RenderConfig( // \aleph, \u2135
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2200': SymbolRenderConfig( // ∀
    math: RenderConfig( // \forall, \u2200
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u210F': SymbolRenderConfig( // ℏ
    math: RenderConfig( // \hbar, \u210F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \hslash
        defaultFont: amsrm,
        defaultType: AtomType.ord,
      ),
      text: null,
    ),
  ),
  '\u2203': SymbolRenderConfig( // ∃
    math: RenderConfig( // \exists, \u2203
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2207': SymbolRenderConfig( // ∇
    math: RenderConfig( // \nabla, \u2207
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u266D': SymbolRenderConfig( // ♭
    math: RenderConfig( // \flat, \u266D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2113': SymbolRenderConfig( // ℓ
    math: RenderConfig( // \ell, \u2113
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u266E': SymbolRenderConfig( // ♮
    math: RenderConfig( // \natural, \u266E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2663': SymbolRenderConfig( // ♣
    math: RenderConfig( // \clubsuit, \u2663
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2118': SymbolRenderConfig( // ℘
    math: RenderConfig( // \wp, \u2118
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u266F': SymbolRenderConfig( // ♯
    math: RenderConfig( // \sharp, \u266F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2662': SymbolRenderConfig( // ♢
    math: RenderConfig( // \diamondsuit, \u2662
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u211C': SymbolRenderConfig( // ℜ
    math: RenderConfig( // \Re, \u211C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2661': SymbolRenderConfig( // ♡
    math: RenderConfig( // \heartsuit, \u2661
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2111': SymbolRenderConfig( // ℑ
    math: RenderConfig( // \Im, \u2111
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2660': SymbolRenderConfig( // ♠
    math: RenderConfig( // \spadesuit, \u2660
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2020': SymbolRenderConfig( // †
    math: RenderConfig( // \dagger
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: RenderConfig( // \textdagger
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2021': SymbolRenderConfig( // ‡
    math: RenderConfig( // \ddagger
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: RenderConfig( // \textdaggerdbl
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u23B1': SymbolRenderConfig( // ⎱
    math: RenderConfig( // \rmoustache, \u23B1
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '\u23B0': SymbolRenderConfig( // ⎰
    math: RenderConfig( // \lmoustache, \u23B0
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  '\u27EF': SymbolRenderConfig( // ⟯
    math: RenderConfig( // \rgroup, \u27EF
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '\u27EE': SymbolRenderConfig( // ⟮
    math: RenderConfig( // \lgroup, \u27EE
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  '\u2213': SymbolRenderConfig( // ∓
    math: RenderConfig( // \mp, \u2213
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2296': SymbolRenderConfig( // ⊖
    math: RenderConfig( // \ominus, \u2296
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u228E': SymbolRenderConfig( // ⊎
    math: RenderConfig( // \uplus, \u228E
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2293': SymbolRenderConfig( // ⊓
    math: RenderConfig( // \sqcap, \u2293
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2217': SymbolRenderConfig( // ∗
    math: RenderConfig( // \ast
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2294': SymbolRenderConfig( // ⊔
    math: RenderConfig( // \sqcup, \u2294
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u25EF': SymbolRenderConfig( // ◯
    math: RenderConfig( // \bigcirc
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: RenderConfig( // \textcircled
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u2219': SymbolRenderConfig( // ∙
    math: RenderConfig( // \bullet
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2240': SymbolRenderConfig( // ≀
    math: RenderConfig( // \wr, \u2240
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2A3F': SymbolRenderConfig( // ⨿
    math: RenderConfig( // \amalg
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u27F5': SymbolRenderConfig( // ⟵
    math: RenderConfig( // \longleftarrow, \u27F5
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21D0': SymbolRenderConfig( // ⇐
    math: RenderConfig( // \Leftarrow, \u21D0
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u27F8': SymbolRenderConfig( // ⟸
    math: RenderConfig( // \Longleftarrow, \u27F8
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u27F6': SymbolRenderConfig( // ⟶
    math: RenderConfig( // \longrightarrow, \u27F6
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21D2': SymbolRenderConfig( // ⇒
    math: RenderConfig( // \Rightarrow, \u21D2
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u27F9': SymbolRenderConfig( // ⟹
    math: RenderConfig( // \Longrightarrow, \u27F9
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2194': SymbolRenderConfig( // ↔
    math: RenderConfig( // \leftrightarrow, \u2194
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u27F7': SymbolRenderConfig( // ⟷
    math: RenderConfig( // \longleftrightarrow, \u27F7
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21D4': SymbolRenderConfig( // ⇔
    math: RenderConfig( // \Leftrightarrow, \u21D4
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u27FA': SymbolRenderConfig( // ⟺
    math: RenderConfig( // \Longleftrightarrow, \u27FA
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21A6': SymbolRenderConfig( // ↦
    math: RenderConfig( // \mapsto, \u21A6
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u27FC': SymbolRenderConfig( // ⟼
    math: RenderConfig( // \longmapsto, \u27FC
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2197': SymbolRenderConfig( // ↗
    math: RenderConfig( // \nearrow, \u2197
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21A9': SymbolRenderConfig( // ↩
    math: RenderConfig( // \hookleftarrow, \u21A9
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21AA': SymbolRenderConfig( // ↪
    math: RenderConfig( // \hookrightarrow, \u21AA
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2198': SymbolRenderConfig( // ↘
    math: RenderConfig( // \searrow, \u2198
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21BC': SymbolRenderConfig( // ↼
    math: RenderConfig( // \leftharpoonup, \u21BC
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C0': SymbolRenderConfig( // ⇀
    math: RenderConfig( // \rightharpoonup, \u21C0
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2199': SymbolRenderConfig( // ↙
    math: RenderConfig( // \swarrow, \u2199
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21BD': SymbolRenderConfig( // ↽
    math: RenderConfig( // \leftharpoondown, \u21BD
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C1': SymbolRenderConfig( // ⇁
    math: RenderConfig( // \rightharpoondown, \u21C1
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2196': SymbolRenderConfig( // ↖
    math: RenderConfig( // \nwarrow, \u2196
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21CC': SymbolRenderConfig( // ⇌
    math: RenderConfig( // \rightleftharpoons, \u21CC
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u226E': SymbolRenderConfig( // ≮
    math: RenderConfig( // \nless, \u226E
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE010': SymbolRenderConfig( // 
    math: RenderConfig( // \@nleqslant
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE011': SymbolRenderConfig( // 
    math: RenderConfig( // \@nleqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A87': SymbolRenderConfig( // ⪇
    math: RenderConfig( // \lneq, \u2A87
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2268': SymbolRenderConfig( // ≨
    math: RenderConfig( // \lneqq, \u2268
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE00C': SymbolRenderConfig( // 
    math: RenderConfig( // \@lvertneqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22E6': SymbolRenderConfig( // ⋦
    math: RenderConfig( // \lnsim, \u22E6
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A89': SymbolRenderConfig( // ⪉
    math: RenderConfig( // \lnapprox, \u2A89
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2280': SymbolRenderConfig( // ⊀
    math: RenderConfig( // \nprec, \u2280
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22E0': SymbolRenderConfig( // ⋠
    math: RenderConfig( // \npreceq, \u22E0
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22E8': SymbolRenderConfig( // ⋨
    math: RenderConfig( // \precnsim, \u22E8
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AB9': SymbolRenderConfig( // ⪹
    math: RenderConfig( // \precnapprox, \u2AB9
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2241': SymbolRenderConfig( // ≁
    math: RenderConfig( // \nsim, \u2241
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE006': SymbolRenderConfig( // 
    math: RenderConfig( // \@nshortmid
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2224': SymbolRenderConfig( // ∤
    math: RenderConfig( // \nmid, \u2224
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22AC': SymbolRenderConfig( // ⊬
    math: RenderConfig( // \nvdash, \u22AC
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22AD': SymbolRenderConfig( // ⊭
    math: RenderConfig( // \nvDash, \u22AD
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22EA': SymbolRenderConfig( // ⋪
    math: RenderConfig( // \ntriangleleft
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22EC': SymbolRenderConfig( // ⋬
    math: RenderConfig( // \ntrianglelefteq, \u22EC
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u228A': SymbolRenderConfig( // ⊊
    math: RenderConfig( // \subsetneq, \u228A
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE01A': SymbolRenderConfig( // 
    math: RenderConfig( // \@varsubsetneq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2ACB': SymbolRenderConfig( // ⫋
    math: RenderConfig( // \subsetneqq, \u2ACB
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE017': SymbolRenderConfig( // 
    math: RenderConfig( // \@varsubsetneqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u226F': SymbolRenderConfig( // ≯
    math: RenderConfig( // \ngtr, \u226F
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE00F': SymbolRenderConfig( // 
    math: RenderConfig( // \@ngeqslant
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE00E': SymbolRenderConfig( // 
    math: RenderConfig( // \@ngeqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A88': SymbolRenderConfig( // ⪈
    math: RenderConfig( // \gneq, \u2A88
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2269': SymbolRenderConfig( // ≩
    math: RenderConfig( // \gneqq, \u2269
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE00D': SymbolRenderConfig( // 
    math: RenderConfig( // \@gvertneqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22E7': SymbolRenderConfig( // ⋧
    math: RenderConfig( // \gnsim, \u22E7
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A8A': SymbolRenderConfig( // ⪊
    math: RenderConfig( // \gnapprox, \u2A8A
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2281': SymbolRenderConfig( // ⊁
    math: RenderConfig( // \nsucc, \u2281
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22E1': SymbolRenderConfig( // ⋡
    math: RenderConfig( // \nsucceq, \u22E1
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22E9': SymbolRenderConfig( // ⋩
    math: RenderConfig( // \succnsim, \u22E9
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2ABA': SymbolRenderConfig( // ⪺
    math: RenderConfig( // \succnapprox, \u2ABA
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2246': SymbolRenderConfig( // ≆
    math: RenderConfig( // \ncong, \u2246
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE007': SymbolRenderConfig( // 
    math: RenderConfig( // \@nshortparallel
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2226': SymbolRenderConfig( // ∦
    math: RenderConfig( // \nparallel, \u2226
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22AF': SymbolRenderConfig( // ⊯
    math: RenderConfig( // \nVDash, \u22AF
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22EB': SymbolRenderConfig( // ⋫
    math: RenderConfig( // \ntriangleright
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22ED': SymbolRenderConfig( // ⋭
    math: RenderConfig( // \ntrianglerighteq, \u22ED
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE018': SymbolRenderConfig( // 
    math: RenderConfig( // \@nsupseteqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u228B': SymbolRenderConfig( // ⊋
    math: RenderConfig( // \supsetneq, \u228B
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE01B': SymbolRenderConfig( // 
    math: RenderConfig( // \@varsupsetneq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2ACC': SymbolRenderConfig( // ⫌
    math: RenderConfig( // \supsetneqq, \u2ACC
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE019': SymbolRenderConfig( // 
    math: RenderConfig( // \@varsupsetneqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22AE': SymbolRenderConfig( // ⊮
    math: RenderConfig( // \nVdash, \u22AE
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AB5': SymbolRenderConfig( // ⪵
    math: RenderConfig( // \precneqq, \u2AB5
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AB6': SymbolRenderConfig( // ⪶
    math: RenderConfig( // \succneqq, \u2AB6
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE016': SymbolRenderConfig( // 
    math: RenderConfig( // \@nsubseteqq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22B4': SymbolRenderConfig( // ⊴
    math: RenderConfig( // \trianglelefteq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22B5': SymbolRenderConfig( // ⊵
    math: RenderConfig( // \trianglerighteq
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u219A': SymbolRenderConfig( // ↚
    math: RenderConfig( // \nleftarrow, \u219A
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u219B': SymbolRenderConfig( // ↛
    math: RenderConfig( // \nrightarrow, \u219B
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21CD': SymbolRenderConfig( // ⇍
    math: RenderConfig( // \nLeftarrow, \u21CD
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21CF': SymbolRenderConfig( // ⇏
    math: RenderConfig( // \nRightarrow, \u21CF
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21AE': SymbolRenderConfig( // ↮
    math: RenderConfig( // \nleftrightarrow, \u21AE
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21CE': SymbolRenderConfig( // ⇎
    math: RenderConfig( // \nLeftrightarrow, \u21CE
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u25B3': SymbolRenderConfig( // △
    math: RenderConfig( // \bigtriangleup
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \vartriangle
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u25BD': SymbolRenderConfig( // ▽
    math: RenderConfig( // \bigtriangledown
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \triangledown
        defaultFont: amsrm,
        defaultType: AtomType.ord,
      ),
      text: null,
    ),
  ),
  '\u25CA': SymbolRenderConfig( // ◊
    math: RenderConfig( // \lozenge, \Diamond
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u24C8': SymbolRenderConfig( // Ⓢ
    math: RenderConfig( // \circledS
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u00AE': SymbolRenderConfig( // ®
    math: RenderConfig( // \circledR
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \circledR
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2221': SymbolRenderConfig( // ∡
    math: RenderConfig( // \measuredangle, \u2221
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2204': SymbolRenderConfig( // ∄
    math: RenderConfig( // \nexists
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2127': SymbolRenderConfig( // ℧
    math: RenderConfig( // \mho
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2132': SymbolRenderConfig( // Ⅎ
    math: RenderConfig( // \Finv, \u2132
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2141': SymbolRenderConfig( // ⅁
    math: RenderConfig( // \Game, \u2141
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2035': SymbolRenderConfig( // ‵
    math: RenderConfig( // \backprime
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u25B2': SymbolRenderConfig( // ▲
    math: RenderConfig( // \blacktriangle
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u25BC': SymbolRenderConfig( // ▼
    math: RenderConfig( // \blacktriangledown
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u25A0': SymbolRenderConfig( // ■
    math: RenderConfig( // \blacksquare
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u29EB': SymbolRenderConfig( // ⧫
    math: RenderConfig( // \blacklozenge
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2605': SymbolRenderConfig( // ★
    math: RenderConfig( // \bigstar
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2222': SymbolRenderConfig( // ∢
    math: RenderConfig( // \sphericalangle, \u2222
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2201': SymbolRenderConfig( // ∁
    math: RenderConfig( // \complement, \u2201
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u00F0': SymbolRenderConfig( // ð
    math: RenderConfig( // \eth, \u00F0
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u00F0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2571': SymbolRenderConfig( // ╱
    math: RenderConfig( // \diagup
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2572': SymbolRenderConfig( // ╲
    math: RenderConfig( // \diagdown
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u25A1': SymbolRenderConfig( // □
    math: RenderConfig( // \square, \Box
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u00A5': SymbolRenderConfig( // ¥
    math: RenderConfig( // \yen, \u00A5
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \yen, \u00A5
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2713': SymbolRenderConfig( // ✓
    math: RenderConfig( // \checkmark, \u2713
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \checkmark
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2136': SymbolRenderConfig( // ℶ
    math: RenderConfig( // \beth, \u2136
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2138': SymbolRenderConfig( // ℸ
    math: RenderConfig( // \daleth, \u2138
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2137': SymbolRenderConfig( // ℷ
    math: RenderConfig( // \gimel, \u2137
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03DD': SymbolRenderConfig( // ϝ
    math: RenderConfig( // \digamma, \u03DD
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03F0': SymbolRenderConfig( // ϰ
    math: RenderConfig( // \varkappa
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u250C': SymbolRenderConfig( // ┌
    math: RenderConfig( // \@ulcorner, \u250C
      defaultFont: amsrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  '\u2510': SymbolRenderConfig( // ┐
    math: RenderConfig( // \@urcorner, \u2510
      defaultFont: amsrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '\u2514': SymbolRenderConfig( // └
    math: RenderConfig( // \@llcorner, \u2514
      defaultFont: amsrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  '\u2518': SymbolRenderConfig( // ┘
    math: RenderConfig( // \@lrcorner, \u2518
      defaultFont: amsrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '\u2266': SymbolRenderConfig( // ≦
    math: RenderConfig( // \leqq, \u2266
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A7D': SymbolRenderConfig( // ⩽
    math: RenderConfig( // \leqslant, \u2A7D
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A95': SymbolRenderConfig( // ⪕
    math: RenderConfig( // \eqslantless, \u2A95
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2272': SymbolRenderConfig( // ≲
    math: RenderConfig( // \lesssim, \u2272
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A85': SymbolRenderConfig( // ⪅
    math: RenderConfig( // \lessapprox, \u2A85
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u224A': SymbolRenderConfig( // ≊
    math: RenderConfig( // \approxeq, \u224A
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22D6': SymbolRenderConfig( // ⋖
    math: RenderConfig( // \lessdot
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22D8': SymbolRenderConfig( // ⋘
    math: RenderConfig( // \lll, \u22D8, \llless
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2276': SymbolRenderConfig( // ≶
    math: RenderConfig( // \lessgtr, \u2276
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22DA': SymbolRenderConfig( // ⋚
    math: RenderConfig( // \lesseqgtr, \u22DA
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A8B': SymbolRenderConfig( // ⪋
    math: RenderConfig( // \lesseqqgtr, \u2A8B
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2251': SymbolRenderConfig( // ≑
    math: RenderConfig( // \doteqdot, \Doteq, \u2251
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2253': SymbolRenderConfig( // ≓
    math: RenderConfig( // \risingdotseq, \u2253
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2252': SymbolRenderConfig( // ≒
    math: RenderConfig( // \fallingdotseq, \u2252
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u223D': SymbolRenderConfig( // ∽
    math: RenderConfig( // \backsim, \u223D
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22CD': SymbolRenderConfig( // ⋍
    math: RenderConfig( // \backsimeq, \u22CD
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AC5': SymbolRenderConfig( // ⫅
    math: RenderConfig( // \subseteqq, \u2AC5
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22D0': SymbolRenderConfig( // ⋐
    math: RenderConfig( // \Subset, \u22D0
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u228F': SymbolRenderConfig( // ⊏
    math: RenderConfig( // \sqsubset, \u228F
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u227C': SymbolRenderConfig( // ≼
    math: RenderConfig( // \preccurlyeq, \u227C
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22DE': SymbolRenderConfig( // ⋞
    math: RenderConfig( // \curlyeqprec, \u22DE
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u227E': SymbolRenderConfig( // ≾
    math: RenderConfig( // \precsim, \u227E
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AB7': SymbolRenderConfig( // ⪷
    math: RenderConfig( // \precapprox, \u2AB7
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22B2': SymbolRenderConfig( // ⊲
    math: RenderConfig( // \lhd
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \vartriangleleft
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u22A8': SymbolRenderConfig( // ⊨
    math: RenderConfig( // \vDash, \u22A8
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \models
        defaultFont: mainrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u22AA': SymbolRenderConfig( // ⊪
    math: RenderConfig( // \Vvdash, \u22AA
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u224F': SymbolRenderConfig( // ≏
    math: RenderConfig( // \bumpeq, \u224F
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u224E': SymbolRenderConfig( // ≎
    math: RenderConfig( // \Bumpeq, \u224E
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2267': SymbolRenderConfig( // ≧
    math: RenderConfig( // \geqq, \u2267
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A7E': SymbolRenderConfig( // ⩾
    math: RenderConfig( // \geqslant, \u2A7E
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A96': SymbolRenderConfig( // ⪖
    math: RenderConfig( // \eqslantgtr, \u2A96
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2273': SymbolRenderConfig( // ≳
    math: RenderConfig( // \gtrsim, \u2273
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A86': SymbolRenderConfig( // ⪆
    math: RenderConfig( // \gtrapprox, \u2A86
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22D7': SymbolRenderConfig( // ⋗
    math: RenderConfig( // \gtrdot
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22D9': SymbolRenderConfig( // ⋙
    math: RenderConfig( // \ggg, \u22D9, \gggtr
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2277': SymbolRenderConfig( // ≷
    math: RenderConfig( // \gtrless, \u2277
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22DB': SymbolRenderConfig( // ⋛
    math: RenderConfig( // \gtreqless, \u22DB
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2A8C': SymbolRenderConfig( // ⪌
    math: RenderConfig( // \gtreqqless, \u2A8C
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2256': SymbolRenderConfig( // ≖
    math: RenderConfig( // \eqcirc, \u2256
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2257': SymbolRenderConfig( // ≗
    math: RenderConfig( // \circeq, \u2257
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u225C': SymbolRenderConfig( // ≜
    math: RenderConfig( // \triangleq, \u225C
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2248': SymbolRenderConfig( // ≈
    math: RenderConfig( // \approx, \u2248
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \thickapprox
        defaultFont: amsrm,
        defaultType: AtomType.rel,
      ),
      text: null,
    ),
  ),
  '\u2AC6': SymbolRenderConfig( // ⫆
    math: RenderConfig( // \supseteqq, \u2AC6
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22D1': SymbolRenderConfig( // ⋑
    math: RenderConfig( // \Supset, \u22D1
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2290': SymbolRenderConfig( // ⊐
    math: RenderConfig( // \sqsupset, \u2290
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u227D': SymbolRenderConfig( // ≽
    math: RenderConfig( // \succcurlyeq, \u227D
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22DF': SymbolRenderConfig( // ⋟
    math: RenderConfig( // \curlyeqsucc, \u22DF
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u227F': SymbolRenderConfig( // ≿
    math: RenderConfig( // \succsim, \u227F
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2AB8': SymbolRenderConfig( // ⪸
    math: RenderConfig( // \succapprox, \u2AB8
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22B3': SymbolRenderConfig( // ⊳
    math: RenderConfig( // \vartriangleright
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22A9': SymbolRenderConfig( // ⊩
    math: RenderConfig( // \Vdash, \u22A9
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u226C': SymbolRenderConfig( // ≬
    math: RenderConfig( // \between, \u226C
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22D4': SymbolRenderConfig( // ⋔
    math: RenderConfig( // \pitchfork, \u22D4
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u25C0': SymbolRenderConfig( // ◀
    math: RenderConfig( // \blacktriangleleft
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2234': SymbolRenderConfig( // ∴
    math: RenderConfig( // \therefore, \u2234
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u220D': SymbolRenderConfig( // ∍
    math: RenderConfig( // \backepsilon
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u25B6': SymbolRenderConfig( // ▶
    math: RenderConfig( // \blacktriangleright
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2235': SymbolRenderConfig( // ∵
    math: RenderConfig( // \because, \u2235
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2242': SymbolRenderConfig( // ≂
    math: RenderConfig( // \eqsim, \u2242
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2214': SymbolRenderConfig( // ∔
    math: RenderConfig( // \dotplus, \u2214
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2216': SymbolRenderConfig( // ∖
    math: RenderConfig( // \setminus
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \smallsetminus
        defaultFont: amsrm,
        defaultType: AtomType.bin,
      ),
      text: null,
    ),
  ),
  '\u22D2': SymbolRenderConfig( // ⋒
    math: RenderConfig( // \Cap, \u22D2, \doublecap
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22D3': SymbolRenderConfig( // ⋓
    math: RenderConfig( // \Cup, \u22D3, \doublecup
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2A5E': SymbolRenderConfig( // ⩞
    math: RenderConfig( // \doublebarwedge, \u2A5E
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u229F': SymbolRenderConfig( // ⊟
    math: RenderConfig( // \boxminus, \u229F
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u229E': SymbolRenderConfig( // ⊞
    math: RenderConfig( // \boxplus, \u229E
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22C7': SymbolRenderConfig( // ⋇
    math: RenderConfig( // \divideontimes, \u22C7
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22C9': SymbolRenderConfig( // ⋉
    math: RenderConfig( // \ltimes, \u22C9
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22CA': SymbolRenderConfig( // ⋊
    math: RenderConfig( // \rtimes, \u22CA
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22CB': SymbolRenderConfig( // ⋋
    math: RenderConfig( // \leftthreetimes, \u22CB
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22CC': SymbolRenderConfig( // ⋌
    math: RenderConfig( // \rightthreetimes, \u22CC
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22CF': SymbolRenderConfig( // ⋏
    math: RenderConfig( // \curlywedge, \u22CF
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22CE': SymbolRenderConfig( // ⋎
    math: RenderConfig( // \curlyvee, \u22CE
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u229D': SymbolRenderConfig( // ⊝
    math: RenderConfig( // \circleddash, \u229D
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u229B': SymbolRenderConfig( // ⊛
    math: RenderConfig( // \circledast, \u229B
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22BA': SymbolRenderConfig( // ⊺
    math: RenderConfig( // \intercal, \u22BA
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22A0': SymbolRenderConfig( // ⊠
    math: RenderConfig( // \boxtimes, \u22A0
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u21E2': SymbolRenderConfig( // ⇢
    math: RenderConfig( // \dashrightarrow, \u21E2
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21E0': SymbolRenderConfig( // ⇠
    math: RenderConfig( // \dashleftarrow, \u21E0
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C7': SymbolRenderConfig( // ⇇
    math: RenderConfig( // \leftleftarrows, \u21C7
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C6': SymbolRenderConfig( // ⇆
    math: RenderConfig( // \leftrightarrows, \u21C6
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21DA': SymbolRenderConfig( // ⇚
    math: RenderConfig( // \Lleftarrow, \u21DA
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u219E': SymbolRenderConfig( // ↞
    math: RenderConfig( // \twoheadleftarrow, \u219E
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21A2': SymbolRenderConfig( // ↢
    math: RenderConfig( // \leftarrowtail, \u21A2
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21AB': SymbolRenderConfig( // ↫
    math: RenderConfig( // \looparrowleft, \u21AB
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21CB': SymbolRenderConfig( // ⇋
    math: RenderConfig( // \leftrightharpoons, \u21CB
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21B6': SymbolRenderConfig( // ↶
    math: RenderConfig( // \curvearrowleft, \u21B6
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21BA': SymbolRenderConfig( // ↺
    math: RenderConfig( // \circlearrowleft, \u21BA
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21B0': SymbolRenderConfig( // ↰
    math: RenderConfig( // \Lsh, \u21B0
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C8': SymbolRenderConfig( // ⇈
    math: RenderConfig( // \upuparrows, \u21C8
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21BF': SymbolRenderConfig( // ↿
    math: RenderConfig( // \upharpoonleft, \u21BF
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C3': SymbolRenderConfig( // ⇃
    math: RenderConfig( // \downharpoonleft, \u21C3
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u22B8': SymbolRenderConfig( // ⊸
    math: RenderConfig( // \multimap, \u22B8
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21AD': SymbolRenderConfig( // ↭
    math: RenderConfig( // \leftrightsquigarrow, \u21AD
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C9': SymbolRenderConfig( // ⇉
    math: RenderConfig( // \rightrightarrows, \u21C9
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C4': SymbolRenderConfig( // ⇄
    math: RenderConfig( // \rightleftarrows, \u21C4
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21A0': SymbolRenderConfig( // ↠
    math: RenderConfig( // \twoheadrightarrow, \u21A0
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21A3': SymbolRenderConfig( // ↣
    math: RenderConfig( // \rightarrowtail, \u21A3
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21AC': SymbolRenderConfig( // ↬
    math: RenderConfig( // \looparrowright, \u21AC
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21B7': SymbolRenderConfig( // ↷
    math: RenderConfig( // \curvearrowright, \u21B7
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21BB': SymbolRenderConfig( // ↻
    math: RenderConfig( // \circlearrowright, \u21BB
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21B1': SymbolRenderConfig( // ↱
    math: RenderConfig( // \Rsh, \u21B1
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21CA': SymbolRenderConfig( // ⇊
    math: RenderConfig( // \downdownarrows, \u21CA
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21BE': SymbolRenderConfig( // ↾
    math: RenderConfig( // \upharpoonright, \u21BE, \restriction
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21C2': SymbolRenderConfig( // ⇂
    math: RenderConfig( // \downharpoonright, \u21C2
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21DD': SymbolRenderConfig( // ⇝
    math: RenderConfig( // \rightsquigarrow, \u21DD, \leadsto
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21DB': SymbolRenderConfig( // ⇛
    math: RenderConfig( // \Rrightarrow, \u21DB
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '`': SymbolRenderConfig( // `
    math: RenderConfig( // `
      replaceChar: '\u2018', // ‘
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // `
      replaceChar: '\u2018', // ‘
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\$': SymbolRenderConfig( // $
    math: RenderConfig( // \\$
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \\$, \textdollar
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '%': SymbolRenderConfig( // %
    math: RenderConfig( // \%
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \%
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '_': SymbolRenderConfig( // _
    math: RenderConfig( // \_
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \_, \textunderscore
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2220': SymbolRenderConfig( // ∠
    math: RenderConfig( // \angle, \u2220
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u221E': SymbolRenderConfig( // ∞
    math: RenderConfig( // \infty, \u221E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2032': SymbolRenderConfig( // ′
    math: RenderConfig( // \prime
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0393': SymbolRenderConfig( // Γ
    math: RenderConfig( // \Gamma, \u0393
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0394': SymbolRenderConfig( // Δ
    math: RenderConfig( // \Delta, \u0394
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0398': SymbolRenderConfig( // Θ
    math: RenderConfig( // \Theta, \u0398
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u039B': SymbolRenderConfig( // Λ
    math: RenderConfig( // \Lambda, \u039B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u039E': SymbolRenderConfig( // Ξ
    math: RenderConfig( // \Xi, \u039E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A0': SymbolRenderConfig( // Π
    math: RenderConfig( // \Pi, \u03A0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A3': SymbolRenderConfig( // Σ
    math: RenderConfig( // \Sigma, \u03A3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A5': SymbolRenderConfig( // Υ
    math: RenderConfig( // \Upsilon, \u03A5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A6': SymbolRenderConfig( // Φ
    math: RenderConfig( // \Phi, \u03A6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A8': SymbolRenderConfig( // Ψ
    math: RenderConfig( // \Psi, \u03A8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A9': SymbolRenderConfig( // Ω
    math: RenderConfig( // \Omega, \u03A9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0391': SymbolRenderConfig( // Α
    math: RenderConfig( // \u0391
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0392': SymbolRenderConfig( // Β
    math: RenderConfig( // \u0392
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0395': SymbolRenderConfig( // Ε
    math: RenderConfig( // \u0395
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0396': SymbolRenderConfig( // Ζ
    math: RenderConfig( // \u0396
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0397': SymbolRenderConfig( // Η
    math: RenderConfig( // \u0397
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u0399': SymbolRenderConfig( // Ι
    math: RenderConfig( // \u0399
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u039A': SymbolRenderConfig( // Κ
    math: RenderConfig( // \u039A
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u039C': SymbolRenderConfig( // Μ
    math: RenderConfig( // \u039C
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u039D': SymbolRenderConfig( // Ν
    math: RenderConfig( // \u039D
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u039F': SymbolRenderConfig( // Ο
    math: RenderConfig( // \u039F
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A1': SymbolRenderConfig( // Ρ
    math: RenderConfig( // \u03A1
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A4': SymbolRenderConfig( // Τ
    math: RenderConfig( // \u03A4
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03A7': SymbolRenderConfig( // Χ
    math: RenderConfig( // \u03A7
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u00AC': SymbolRenderConfig( // ¬
    math: RenderConfig( // \neg, \u00AC, \lnot
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u22A4': SymbolRenderConfig( // ⊤
    math: RenderConfig( // \top
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2205': SymbolRenderConfig( // ∅
    math: RenderConfig( // \emptyset
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
    variantForm: SymbolRenderConfig(
      math: RenderConfig( // \varnothing
        defaultFont: amsrm,
        defaultType: AtomType.ord,
      ),
      text: null,
    ),
  ),
  '\u03B1': SymbolRenderConfig( // α
    math: RenderConfig( // \alpha, \u03B1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B2': SymbolRenderConfig( // β
    math: RenderConfig( // \beta, \u03B2
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B3': SymbolRenderConfig( // γ
    math: RenderConfig( // \gamma, \u03B3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B4': SymbolRenderConfig( // δ
    math: RenderConfig( // \delta, \u03B4
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03F5': SymbolRenderConfig( // ϵ
    math: RenderConfig( // \epsilon, \u03F5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B6': SymbolRenderConfig( // ζ
    math: RenderConfig( // \zeta, \u03B6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B7': SymbolRenderConfig( // η
    math: RenderConfig( // \eta, \u03B7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B8': SymbolRenderConfig( // θ
    math: RenderConfig( // \theta, \u03B8
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B9': SymbolRenderConfig( // ι
    math: RenderConfig( // \iota, \u03B9
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03BA': SymbolRenderConfig( // κ
    math: RenderConfig( // \kappa, \u03BA
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03BB': SymbolRenderConfig( // λ
    math: RenderConfig( // \lambda, \u03BB
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03BC': SymbolRenderConfig( // μ
    math: RenderConfig( // \mu, \u03BC
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03BD': SymbolRenderConfig( // ν
    math: RenderConfig( // \nu, \u03BD
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03BE': SymbolRenderConfig( // ξ
    math: RenderConfig( // \xi, \u03BE
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03BF': SymbolRenderConfig( // ο
    math: RenderConfig( // \omicron, \u03BF
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C0': SymbolRenderConfig( // π
    math: RenderConfig( // \pi, \u03C0
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C1': SymbolRenderConfig( // ρ
    math: RenderConfig( // \rho, \u03C1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C3': SymbolRenderConfig( // σ
    math: RenderConfig( // \sigma, \u03C3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C4': SymbolRenderConfig( // τ
    math: RenderConfig( // \tau, \u03C4
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C5': SymbolRenderConfig( // υ
    math: RenderConfig( // \upsilon, \u03C5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03D5': SymbolRenderConfig( // ϕ
    math: RenderConfig( // \phi, \u03D5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C7': SymbolRenderConfig( // χ
    math: RenderConfig( // \chi, \u03C7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C8': SymbolRenderConfig( // ψ
    math: RenderConfig( // \psi, \u03C8
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C9': SymbolRenderConfig( // ω
    math: RenderConfig( // \omega, \u03C9
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03B5': SymbolRenderConfig( // ε
    math: RenderConfig( // \varepsilon, \u03B5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03D1': SymbolRenderConfig( // ϑ
    math: RenderConfig( // \vartheta, \u03D1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03D6': SymbolRenderConfig( // ϖ
    math: RenderConfig( // \varpi, \u03D6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03F1': SymbolRenderConfig( // ϱ
    math: RenderConfig( // \varrho, \u03F1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C2': SymbolRenderConfig( // ς
    math: RenderConfig( // \varsigma, \u03C2
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u03C6': SymbolRenderConfig( // φ
    math: RenderConfig( // \varphi, \u03C6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '*': SymbolRenderConfig( // *
    math: RenderConfig( // *
      replaceChar: '\u2217', // ∗
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: RenderConfig( // *
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '+': SymbolRenderConfig( // +
    math: RenderConfig( // +
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: RenderConfig( // +
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '-': SymbolRenderConfig( // -
    math: RenderConfig( // -
      replaceChar: '\u2212', // −
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: RenderConfig( // -
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2218': SymbolRenderConfig( // ∘
    math: RenderConfig( // \circ
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u00F7': SymbolRenderConfig( // ÷
    math: RenderConfig( // \div, \u00F7
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u00B1': SymbolRenderConfig( // ±
    math: RenderConfig( // \pm, \u00B1
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u00D7': SymbolRenderConfig( // ×
    math: RenderConfig( // \times, \u00D7
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2229': SymbolRenderConfig( // ∩
    math: RenderConfig( // \cap, \u2229
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u222A': SymbolRenderConfig( // ∪
    math: RenderConfig( // \cup, \u222A
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2227': SymbolRenderConfig( // ∧
    math: RenderConfig( // \land, \wedge, \u2227
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2228': SymbolRenderConfig( // ∨
    math: RenderConfig( // \lor, \vee, \u2228
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u221A': SymbolRenderConfig( // √
    math: RenderConfig( // \surd
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '(': SymbolRenderConfig( // (
    math: RenderConfig( // (, \lparen
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: RenderConfig( // (
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '[': SymbolRenderConfig( // [
    math: RenderConfig( // [, \lbrack
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: RenderConfig( // \lbrack, [
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u27E8': SymbolRenderConfig( // ⟨
    math: RenderConfig( // \langle, \u27E8
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  ')': SymbolRenderConfig( // )
    math: RenderConfig( // ), \rparen
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: RenderConfig( // )
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  ']': SymbolRenderConfig( // ]
    math: RenderConfig( // ], \rbrack
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: RenderConfig( // \rbrack, ]
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '?': SymbolRenderConfig( // ?
    math: RenderConfig( // ?
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: RenderConfig( // ?
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '!': SymbolRenderConfig( // !
    math: RenderConfig( // !
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: RenderConfig( // !
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u27E9': SymbolRenderConfig( // ⟩
    math: RenderConfig( // \rangle, \u27E9
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '=': SymbolRenderConfig( // =
    math: RenderConfig( // =
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: RenderConfig( // =
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '<': SymbolRenderConfig( // <
    math: RenderConfig( // <, \lt
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: RenderConfig( // \textless, <
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '>': SymbolRenderConfig( // >
    math: RenderConfig( // >, \gt
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: RenderConfig( // \textgreater, >
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  ':': SymbolRenderConfig( // :
    math: RenderConfig( // :
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: RenderConfig( // :
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2245': SymbolRenderConfig( // ≅
    math: RenderConfig( // \cong, \u2245
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2265': SymbolRenderConfig( // ≥
    math: RenderConfig( // \ge, \geq, \u2265
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2190': SymbolRenderConfig( // ←
    math: RenderConfig( // \gets, \leftarrow, \u2190
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2208': SymbolRenderConfig( // ∈
    math: RenderConfig( // \in, \u2208
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\uE020': SymbolRenderConfig( // 
    math: RenderConfig( // \@not
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2282': SymbolRenderConfig( // ⊂
    math: RenderConfig( // \subset, \u2282
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2283': SymbolRenderConfig( // ⊃
    math: RenderConfig( // \supset, \u2283
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2286': SymbolRenderConfig( // ⊆
    math: RenderConfig( // \subseteq, \u2286
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2287': SymbolRenderConfig( // ⊇
    math: RenderConfig( // \supseteq, \u2287
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2288': SymbolRenderConfig( // ⊈
    math: RenderConfig( // \nsubseteq, \u2288
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2289': SymbolRenderConfig( // ⊉
    math: RenderConfig( // \nsupseteq, \u2289
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2264': SymbolRenderConfig( // ≤
    math: RenderConfig( // \le, \leq, \u2264
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2192': SymbolRenderConfig( // →
    math: RenderConfig( // \rightarrow, \u2192, \to
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2271': SymbolRenderConfig( // ≱
    math: RenderConfig( // \ngeq, \u2271
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2270': SymbolRenderConfig( // ≰
    math: RenderConfig( // \nleq, \u2270
      defaultFont: amsrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u00A0': SymbolRenderConfig( //  
    math: RenderConfig( // \ , ~, \space, \nobreakspace
      defaultFont: mainrm,
      defaultType: AtomType.spacing,
    ),
    text: RenderConfig( // \ , ~, \space, \nobreakspace
      defaultFont: mainrm,
      defaultType: AtomType.spacing,
    ),
  ),
  ',': SymbolRenderConfig( // ,
    math: RenderConfig( // ,
      defaultFont: mainrm,
      defaultType: AtomType.punct,
    ),
    text: RenderConfig( // ,
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  ';': SymbolRenderConfig( // ;
    math: RenderConfig( // ;
      defaultFont: mainrm,
      defaultType: AtomType.punct,
    ),
    text: RenderConfig( // ;
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u22BC': SymbolRenderConfig( // ⊼
    math: RenderConfig( // \barwedge, \u22BC
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22BB': SymbolRenderConfig( // ⊻
    math: RenderConfig( // \veebar, \u22BB
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2299': SymbolRenderConfig( // ⊙
    math: RenderConfig( // \odot, \u2299
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2295': SymbolRenderConfig( // ⊕
    math: RenderConfig( // \oplus, \u2295
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2297': SymbolRenderConfig( // ⊗
    math: RenderConfig( // \otimes, \u2297
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u2202': SymbolRenderConfig( // ∂
    math: RenderConfig( // \partial, \u2202
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u2298': SymbolRenderConfig( // ⊘
    math: RenderConfig( // \oslash, \u2298
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u229A': SymbolRenderConfig( // ⊚
    math: RenderConfig( // \circledcirc, \u229A
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22A1': SymbolRenderConfig( // ⊡
    math: RenderConfig( // \boxdot, \u22A1
      defaultFont: amsrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22C4': SymbolRenderConfig( // ⋄
    math: RenderConfig( // \diamond
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u22C6': SymbolRenderConfig( // ⋆
    math: RenderConfig( // \star
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u25C3': SymbolRenderConfig( // ◃
    math: RenderConfig( // \triangleleft
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '\u25B9': SymbolRenderConfig( // ▹
    math: RenderConfig( // \triangleright
      defaultFont: mainrm,
      defaultType: AtomType.bin,
    ),
    text: null,
  ),
  '{': SymbolRenderConfig( // {
    math: RenderConfig( // \{, \lbrace
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: RenderConfig( // \{, \textbraceleft
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '}': SymbolRenderConfig( // }
    math: RenderConfig( // \}, \rbrace
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: RenderConfig( // \}, \textbraceright
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u230A': SymbolRenderConfig( // ⌊
    math: RenderConfig( // \lfloor, \u230A
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  '\u230B': SymbolRenderConfig( // ⌋
    math: RenderConfig( // \rfloor, \u230B
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '\u2308': SymbolRenderConfig( // ⌈
    math: RenderConfig( // \lceil, \u2308
      defaultFont: mainrm,
      defaultType: AtomType.open,
    ),
    text: null,
  ),
  '\u2309': SymbolRenderConfig( // ⌉
    math: RenderConfig( // \rceil, \u2309
      defaultFont: mainrm,
      defaultType: AtomType.close,
    ),
    text: null,
  ),
  '\\': SymbolRenderConfig( // \
    math: RenderConfig( // \backslash
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \textbackslash
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '|': SymbolRenderConfig( // |
    math: RenderConfig( // |
      replaceChar: '\u2223', // ∣
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \textbar, |
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2191': SymbolRenderConfig( // ↑
    math: RenderConfig( // \uparrow, \u2191
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21D1': SymbolRenderConfig( // ⇑
    math: RenderConfig( // \Uparrow, \u21D1
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2193': SymbolRenderConfig( // ↓
    math: RenderConfig( // \downarrow, \u2193
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21D3': SymbolRenderConfig( // ⇓
    math: RenderConfig( // \Downarrow, \u21D3
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2195': SymbolRenderConfig( // ↕
    math: RenderConfig( // \updownarrow, \u2195
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u21D5': SymbolRenderConfig( // ⇕
    math: RenderConfig( // \Updownarrow, \u21D5
      defaultFont: mainrm,
      defaultType: AtomType.rel,
    ),
    text: null,
  ),
  '\u2210': SymbolRenderConfig( // ∐
    math: RenderConfig( // \coprod
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u22C1': SymbolRenderConfig( // ⋁
    math: RenderConfig( // \bigvee
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u22C0': SymbolRenderConfig( // ⋀
    math: RenderConfig( // \bigwedge
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2A04': SymbolRenderConfig( // ⨄
    math: RenderConfig( // \biguplus
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u22C2': SymbolRenderConfig( // ⋂
    math: RenderConfig( // \bigcap
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u22C3': SymbolRenderConfig( // ⋃
    math: RenderConfig( // \bigcup
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u222B': SymbolRenderConfig( // ∫
    math: RenderConfig( // \int, \intop, \smallint
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u222C': SymbolRenderConfig( // ∬
    math: RenderConfig( // \iint
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u222D': SymbolRenderConfig( // ∭
    math: RenderConfig( // \iiint
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u220F': SymbolRenderConfig( // ∏
    math: RenderConfig( // \prod
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2211': SymbolRenderConfig( // ∑
    math: RenderConfig( // \sum
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2A02': SymbolRenderConfig( // ⨂
    math: RenderConfig( // \bigotimes
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2A01': SymbolRenderConfig( // ⨁
    math: RenderConfig( // \bigoplus
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2A00': SymbolRenderConfig( // ⨀
    math: RenderConfig( // \bigodot
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u222E': SymbolRenderConfig( // ∮
    math: RenderConfig( // \oint
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u222F': SymbolRenderConfig( // ∯
    math: RenderConfig( // \oiint
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2230': SymbolRenderConfig( // ∰
    math: RenderConfig( // \oiiint
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2A06': SymbolRenderConfig( // ⨆
    math: RenderConfig( // \bigsqcup
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u2026': SymbolRenderConfig( // …
    math: RenderConfig( // \mathellipsis, \ldots, \u2026
      defaultFont: mainrm,
      defaultType: AtomType.inner,
    ),
    text: RenderConfig( // \textellipsis, \ldots, \u2026
      defaultFont: mainrm,
      defaultType: AtomType.inner,
    ),
  ),
  '\u22EF': SymbolRenderConfig( // ⋯
    math: RenderConfig( // \@cdots, \u22EF
      defaultFont: mainrm,
      defaultType: AtomType.inner,
    ),
    text: null,
  ),
  '\u22F1': SymbolRenderConfig( // ⋱
    math: RenderConfig( // \ddots, \u22F1
      defaultFont: mainrm,
      defaultType: AtomType.inner,
    ),
    text: null,
  ),
  '\u22EE': SymbolRenderConfig( // ⋮
    math: RenderConfig( // \varvdots
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: null,
  ),
  '\u02CA': SymbolRenderConfig( // ˊ
    math: RenderConfig( // \acute
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \\'
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u02CB': SymbolRenderConfig( // ˋ
    math: RenderConfig( // \grave
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \`
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u00A8': SymbolRenderConfig( // ¨
    math: RenderConfig( // \ddot
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \"
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '~': SymbolRenderConfig( // ~
    math: RenderConfig( // \tilde
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \textasciitilde
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u02C9': SymbolRenderConfig( // ˉ
    math: RenderConfig( // \bar
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \=
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u02D8': SymbolRenderConfig( // ˘
    math: RenderConfig( // \breve
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \u
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u02C7': SymbolRenderConfig( // ˇ
    math: RenderConfig( // \check
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \v
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '^': SymbolRenderConfig( // ^
    math: RenderConfig( // \hat
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \textasciicircum
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u20D7': SymbolRenderConfig( // ⃗
    math: RenderConfig( // \vec
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: null,
  ),
  '\u02D9': SymbolRenderConfig( // ˙
    math: RenderConfig( // \dot
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \.
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u02DA': SymbolRenderConfig( // ˚
    math: RenderConfig( // \mathring
      defaultFont: mainrm,
      defaultType: null,
    ),
    text: RenderConfig( // \r
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u0131': SymbolRenderConfig( // ı
    math: RenderConfig( // \imath, \u0131
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \i, \u0131
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u0237': SymbolRenderConfig( // ȷ
    math: RenderConfig( // \jmath, \u0237
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \j, \u0237
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00B0': SymbolRenderConfig( // °
    math: RenderConfig( // \degree, \u00B0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \degree, \textdegree, \u00B0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00A3': SymbolRenderConfig( // £
    math: RenderConfig( // \pounds, \mathsterling, \u00A3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \pounds, \textsterling, \u00A3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2720': SymbolRenderConfig( // ✠
    math: RenderConfig( // \maltese
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \maltese
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '/': SymbolRenderConfig( // /
    math: RenderConfig( // /
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // /
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '@': SymbolRenderConfig( // @
    math: RenderConfig( // @
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // @
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\"': SymbolRenderConfig( // "
    math: RenderConfig( // "
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // "
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'A': SymbolRenderConfig( // A
    math: RenderConfig( // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'B': SymbolRenderConfig( // B
    math: RenderConfig( // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'C': SymbolRenderConfig( // C
    math: RenderConfig( // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'D': SymbolRenderConfig( // D
    math: RenderConfig( // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'E': SymbolRenderConfig( // E
    math: RenderConfig( // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'F': SymbolRenderConfig( // F
    math: RenderConfig( // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'G': SymbolRenderConfig( // G
    math: RenderConfig( // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'H': SymbolRenderConfig( // H
    math: RenderConfig( // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'I': SymbolRenderConfig( // I
    math: RenderConfig( // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'J': SymbolRenderConfig( // J
    math: RenderConfig( // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'K': SymbolRenderConfig( // K
    math: RenderConfig( // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'L': SymbolRenderConfig( // L
    math: RenderConfig( // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'M': SymbolRenderConfig( // M
    math: RenderConfig( // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'N': SymbolRenderConfig( // N
    math: RenderConfig( // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'O': SymbolRenderConfig( // O
    math: RenderConfig( // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'P': SymbolRenderConfig( // P
    math: RenderConfig( // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'Q': SymbolRenderConfig( // Q
    math: RenderConfig( // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'R': SymbolRenderConfig( // R
    math: RenderConfig( // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'S': SymbolRenderConfig( // S
    math: RenderConfig( // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'T': SymbolRenderConfig( // T
    math: RenderConfig( // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'U': SymbolRenderConfig( // U
    math: RenderConfig( // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'V': SymbolRenderConfig( // V
    math: RenderConfig( // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'W': SymbolRenderConfig( // W
    math: RenderConfig( // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'X': SymbolRenderConfig( // X
    math: RenderConfig( // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'Y': SymbolRenderConfig( // Y
    math: RenderConfig( // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'Z': SymbolRenderConfig( // Z
    math: RenderConfig( // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'a': SymbolRenderConfig( // a
    math: RenderConfig( // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'b': SymbolRenderConfig( // b
    math: RenderConfig( // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'c': SymbolRenderConfig( // c
    math: RenderConfig( // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'd': SymbolRenderConfig( // d
    math: RenderConfig( // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'e': SymbolRenderConfig( // e
    math: RenderConfig( // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'f': SymbolRenderConfig( // f
    math: RenderConfig( // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'g': SymbolRenderConfig( // g
    math: RenderConfig( // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'h': SymbolRenderConfig( // h
    math: RenderConfig( // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'i': SymbolRenderConfig( // i
    math: RenderConfig( // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'j': SymbolRenderConfig( // j
    math: RenderConfig( // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'k': SymbolRenderConfig( // k
    math: RenderConfig( // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'l': SymbolRenderConfig( // l
    math: RenderConfig( // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'm': SymbolRenderConfig( // m
    math: RenderConfig( // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'n': SymbolRenderConfig( // n
    math: RenderConfig( // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'o': SymbolRenderConfig( // o
    math: RenderConfig( // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'p': SymbolRenderConfig( // p
    math: RenderConfig( // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'q': SymbolRenderConfig( // q
    math: RenderConfig( // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'r': SymbolRenderConfig( // r
    math: RenderConfig( // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  's': SymbolRenderConfig( // s
    math: RenderConfig( // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  't': SymbolRenderConfig( // t
    math: RenderConfig( // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'u': SymbolRenderConfig( // u
    math: RenderConfig( // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'v': SymbolRenderConfig( // v
    math: RenderConfig( // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'w': SymbolRenderConfig( // w
    math: RenderConfig( // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'x': SymbolRenderConfig( // x
    math: RenderConfig( // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'y': SymbolRenderConfig( // y
    math: RenderConfig( // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  'z': SymbolRenderConfig( // z
    math: RenderConfig( // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2102': SymbolRenderConfig( // ℂ
    math: RenderConfig( // \u2102
      replaceChar: 'C', // C
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u2102
      replaceChar: 'C', // C
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u210D': SymbolRenderConfig( // ℍ
    math: RenderConfig( // \u210D
      replaceChar: 'H', // H
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u210D
      replaceChar: 'H', // H
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2115': SymbolRenderConfig( // ℕ
    math: RenderConfig( // \u2115
      replaceChar: 'N', // N
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u2115
      replaceChar: 'N', // N
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2119': SymbolRenderConfig( // ℙ
    math: RenderConfig( // \u2119
      replaceChar: 'P', // P
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u2119
      replaceChar: 'P', // P
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u211A': SymbolRenderConfig( // ℚ
    math: RenderConfig( // \u211A
      replaceChar: 'Q', // Q
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u211A
      replaceChar: 'Q', // Q
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u211D': SymbolRenderConfig( // ℝ
    math: RenderConfig( // \u211D
      replaceChar: 'R', // R
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u211D
      replaceChar: 'R', // R
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2124': SymbolRenderConfig( // ℤ
    math: RenderConfig( // \u2124
      replaceChar: 'Z', // Z
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u2124
      replaceChar: 'Z', // Z
      defaultFont: amsrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u210E': SymbolRenderConfig( // ℎ
    math: RenderConfig( // \u210E
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u210E
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC00': SymbolRenderConfig( // 𝐀
    math: RenderConfig( // \uD835\uDC00
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC00
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC34': SymbolRenderConfig( // 𝐴
    math: RenderConfig( // \uD835\uDC34
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC34
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC68': SymbolRenderConfig( // 𝑨
    math: RenderConfig( // \uD835\uDC68
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC68
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD04': SymbolRenderConfig( // 𝔄
    math: RenderConfig( // \uD835\uDD04
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD04
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA0': SymbolRenderConfig( // 𝖠
    math: RenderConfig( // \uD835\uDDA0
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA0
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD4': SymbolRenderConfig( // 𝗔
    math: RenderConfig( // \uD835\uDDD4
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD4
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE08': SymbolRenderConfig( // 𝘈
    math: RenderConfig( // \uD835\uDE08
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE08
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE70': SymbolRenderConfig( // 𝙰
    math: RenderConfig( // \uD835\uDE70
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE70
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD38': SymbolRenderConfig( // 𝔸
    math: RenderConfig( // \uD835\uDD38
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD38
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC9C': SymbolRenderConfig( // 𝒜
    math: RenderConfig( // \uD835\uDC9C
      replaceChar: 'A', // A
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC9C
      replaceChar: 'A', // A
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC01': SymbolRenderConfig( // 𝐁
    math: RenderConfig( // \uD835\uDC01
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC01
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC35': SymbolRenderConfig( // 𝐵
    math: RenderConfig( // \uD835\uDC35
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC35
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC69': SymbolRenderConfig( // 𝑩
    math: RenderConfig( // \uD835\uDC69
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC69
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD05': SymbolRenderConfig( // 𝔅
    math: RenderConfig( // \uD835\uDD05
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD05
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA1': SymbolRenderConfig( // 𝖡
    math: RenderConfig( // \uD835\uDDA1
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA1
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD5': SymbolRenderConfig( // 𝗕
    math: RenderConfig( // \uD835\uDDD5
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD5
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE09': SymbolRenderConfig( // 𝘉
    math: RenderConfig( // \uD835\uDE09
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE09
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE71': SymbolRenderConfig( // 𝙱
    math: RenderConfig( // \uD835\uDE71
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE71
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD39': SymbolRenderConfig( // 𝔹
    math: RenderConfig( // \uD835\uDD39
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD39
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC9D': SymbolRenderConfig( // 𝒝
    math: RenderConfig( // \uD835\uDC9D
      replaceChar: 'B', // B
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC9D
      replaceChar: 'B', // B
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC02': SymbolRenderConfig( // 𝐂
    math: RenderConfig( // \uD835\uDC02
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC02
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC36': SymbolRenderConfig( // 𝐶
    math: RenderConfig( // \uD835\uDC36
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC36
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC6A': SymbolRenderConfig( // 𝑪
    math: RenderConfig( // \uD835\uDC6A
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC6A
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD06': SymbolRenderConfig( // 𝔆
    math: RenderConfig( // \uD835\uDD06
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD06
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA2': SymbolRenderConfig( // 𝖢
    math: RenderConfig( // \uD835\uDDA2
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA2
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD6': SymbolRenderConfig( // 𝗖
    math: RenderConfig( // \uD835\uDDD6
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD6
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE0A': SymbolRenderConfig( // 𝘊
    math: RenderConfig( // \uD835\uDE0A
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE0A
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE72': SymbolRenderConfig( // 𝙲
    math: RenderConfig( // \uD835\uDE72
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE72
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD3A': SymbolRenderConfig( // 𝔺
    math: RenderConfig( // \uD835\uDD3A
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD3A
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC9E': SymbolRenderConfig( // 𝒞
    math: RenderConfig( // \uD835\uDC9E
      replaceChar: 'C', // C
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC9E
      replaceChar: 'C', // C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC03': SymbolRenderConfig( // 𝐃
    math: RenderConfig( // \uD835\uDC03
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC03
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC37': SymbolRenderConfig( // 𝐷
    math: RenderConfig( // \uD835\uDC37
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC37
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC6B': SymbolRenderConfig( // 𝑫
    math: RenderConfig( // \uD835\uDC6B
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC6B
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD07': SymbolRenderConfig( // 𝔇
    math: RenderConfig( // \uD835\uDD07
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD07
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA3': SymbolRenderConfig( // 𝖣
    math: RenderConfig( // \uD835\uDDA3
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA3
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD7': SymbolRenderConfig( // 𝗗
    math: RenderConfig( // \uD835\uDDD7
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD7
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE0B': SymbolRenderConfig( // 𝘋
    math: RenderConfig( // \uD835\uDE0B
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE0B
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE73': SymbolRenderConfig( // 𝙳
    math: RenderConfig( // \uD835\uDE73
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE73
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD3B': SymbolRenderConfig( // 𝔻
    math: RenderConfig( // \uD835\uDD3B
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD3B
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC9F': SymbolRenderConfig( // 𝒟
    math: RenderConfig( // \uD835\uDC9F
      replaceChar: 'D', // D
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC9F
      replaceChar: 'D', // D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC04': SymbolRenderConfig( // 𝐄
    math: RenderConfig( // \uD835\uDC04
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC04
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC38': SymbolRenderConfig( // 𝐸
    math: RenderConfig( // \uD835\uDC38
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC38
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC6C': SymbolRenderConfig( // 𝑬
    math: RenderConfig( // \uD835\uDC6C
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC6C
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD08': SymbolRenderConfig( // 𝔈
    math: RenderConfig( // \uD835\uDD08
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD08
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA4': SymbolRenderConfig( // 𝖤
    math: RenderConfig( // \uD835\uDDA4
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA4
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD8': SymbolRenderConfig( // 𝗘
    math: RenderConfig( // \uD835\uDDD8
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD8
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE0C': SymbolRenderConfig( // 𝘌
    math: RenderConfig( // \uD835\uDE0C
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE0C
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE74': SymbolRenderConfig( // 𝙴
    math: RenderConfig( // \uD835\uDE74
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE74
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD3C': SymbolRenderConfig( // 𝔼
    math: RenderConfig( // \uD835\uDD3C
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD3C
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA0': SymbolRenderConfig( // 𝒠
    math: RenderConfig( // \uD835\uDCA0
      replaceChar: 'E', // E
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA0
      replaceChar: 'E', // E
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC05': SymbolRenderConfig( // 𝐅
    math: RenderConfig( // \uD835\uDC05
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC05
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC39': SymbolRenderConfig( // 𝐹
    math: RenderConfig( // \uD835\uDC39
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC39
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC6D': SymbolRenderConfig( // 𝑭
    math: RenderConfig( // \uD835\uDC6D
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC6D
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD09': SymbolRenderConfig( // 𝔉
    math: RenderConfig( // \uD835\uDD09
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD09
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA5': SymbolRenderConfig( // 𝖥
    math: RenderConfig( // \uD835\uDDA5
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA5
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD9': SymbolRenderConfig( // 𝗙
    math: RenderConfig( // \uD835\uDDD9
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD9
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE0D': SymbolRenderConfig( // 𝘍
    math: RenderConfig( // \uD835\uDE0D
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE0D
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE75': SymbolRenderConfig( // 𝙵
    math: RenderConfig( // \uD835\uDE75
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE75
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD3D': SymbolRenderConfig( // 𝔽
    math: RenderConfig( // \uD835\uDD3D
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD3D
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA1': SymbolRenderConfig( // 𝒡
    math: RenderConfig( // \uD835\uDCA1
      replaceChar: 'F', // F
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA1
      replaceChar: 'F', // F
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC06': SymbolRenderConfig( // 𝐆
    math: RenderConfig( // \uD835\uDC06
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC06
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC3A': SymbolRenderConfig( // 𝐺
    math: RenderConfig( // \uD835\uDC3A
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC3A
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC6E': SymbolRenderConfig( // 𝑮
    math: RenderConfig( // \uD835\uDC6E
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC6E
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD0A': SymbolRenderConfig( // 𝔊
    math: RenderConfig( // \uD835\uDD0A
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD0A
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA6': SymbolRenderConfig( // 𝖦
    math: RenderConfig( // \uD835\uDDA6
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA6
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDDA': SymbolRenderConfig( // 𝗚
    math: RenderConfig( // \uD835\uDDDA
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDDA
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE0E': SymbolRenderConfig( // 𝘎
    math: RenderConfig( // \uD835\uDE0E
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE0E
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE76': SymbolRenderConfig( // 𝙶
    math: RenderConfig( // \uD835\uDE76
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE76
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD3E': SymbolRenderConfig( // 𝔾
    math: RenderConfig( // \uD835\uDD3E
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD3E
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA2': SymbolRenderConfig( // 𝒢
    math: RenderConfig( // \uD835\uDCA2
      replaceChar: 'G', // G
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA2
      replaceChar: 'G', // G
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC07': SymbolRenderConfig( // 𝐇
    math: RenderConfig( // \uD835\uDC07
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC07
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC3B': SymbolRenderConfig( // 𝐻
    math: RenderConfig( // \uD835\uDC3B
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC3B
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC6F': SymbolRenderConfig( // 𝑯
    math: RenderConfig( // \uD835\uDC6F
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC6F
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD0B': SymbolRenderConfig( // 𝔋
    math: RenderConfig( // \uD835\uDD0B
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD0B
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA7': SymbolRenderConfig( // 𝖧
    math: RenderConfig( // \uD835\uDDA7
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA7
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDDB': SymbolRenderConfig( // 𝗛
    math: RenderConfig( // \uD835\uDDDB
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDDB
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE0F': SymbolRenderConfig( // 𝘏
    math: RenderConfig( // \uD835\uDE0F
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE0F
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE77': SymbolRenderConfig( // 𝙷
    math: RenderConfig( // \uD835\uDE77
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE77
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD3F': SymbolRenderConfig( // 𝔿
    math: RenderConfig( // \uD835\uDD3F
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD3F
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA3': SymbolRenderConfig( // 𝒣
    math: RenderConfig( // \uD835\uDCA3
      replaceChar: 'H', // H
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA3
      replaceChar: 'H', // H
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC08': SymbolRenderConfig( // 𝐈
    math: RenderConfig( // \uD835\uDC08
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC08
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC3C': SymbolRenderConfig( // 𝐼
    math: RenderConfig( // \uD835\uDC3C
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC3C
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC70': SymbolRenderConfig( // 𝑰
    math: RenderConfig( // \uD835\uDC70
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC70
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD0C': SymbolRenderConfig( // 𝔌
    math: RenderConfig( // \uD835\uDD0C
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD0C
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA8': SymbolRenderConfig( // 𝖨
    math: RenderConfig( // \uD835\uDDA8
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA8
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDDC': SymbolRenderConfig( // 𝗜
    math: RenderConfig( // \uD835\uDDDC
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDDC
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE10': SymbolRenderConfig( // 𝘐
    math: RenderConfig( // \uD835\uDE10
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE10
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE78': SymbolRenderConfig( // 𝙸
    math: RenderConfig( // \uD835\uDE78
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE78
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD40': SymbolRenderConfig( // 𝕀
    math: RenderConfig( // \uD835\uDD40
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD40
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA4': SymbolRenderConfig( // 𝒤
    math: RenderConfig( // \uD835\uDCA4
      replaceChar: 'I', // I
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA4
      replaceChar: 'I', // I
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC09': SymbolRenderConfig( // 𝐉
    math: RenderConfig( // \uD835\uDC09
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC09
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC3D': SymbolRenderConfig( // 𝐽
    math: RenderConfig( // \uD835\uDC3D
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC3D
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC71': SymbolRenderConfig( // 𝑱
    math: RenderConfig( // \uD835\uDC71
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC71
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD0D': SymbolRenderConfig( // 𝔍
    math: RenderConfig( // \uD835\uDD0D
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD0D
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDA9': SymbolRenderConfig( // 𝖩
    math: RenderConfig( // \uD835\uDDA9
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDA9
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDDD': SymbolRenderConfig( // 𝗝
    math: RenderConfig( // \uD835\uDDDD
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDDD
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE11': SymbolRenderConfig( // 𝘑
    math: RenderConfig( // \uD835\uDE11
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE11
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE79': SymbolRenderConfig( // 𝙹
    math: RenderConfig( // \uD835\uDE79
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE79
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD41': SymbolRenderConfig( // 𝕁
    math: RenderConfig( // \uD835\uDD41
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD41
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA5': SymbolRenderConfig( // 𝒥
    math: RenderConfig( // \uD835\uDCA5
      replaceChar: 'J', // J
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA5
      replaceChar: 'J', // J
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC0A': SymbolRenderConfig( // 𝐊
    math: RenderConfig( // \uD835\uDC0A
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC0A
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC3E': SymbolRenderConfig( // 𝐾
    math: RenderConfig( // \uD835\uDC3E
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC3E
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC72': SymbolRenderConfig( // 𝑲
    math: RenderConfig( // \uD835\uDC72
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC72
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD0E': SymbolRenderConfig( // 𝔎
    math: RenderConfig( // \uD835\uDD0E
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD0E
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDAA': SymbolRenderConfig( // 𝖪
    math: RenderConfig( // \uD835\uDDAA
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDAA
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDDE': SymbolRenderConfig( // 𝗞
    math: RenderConfig( // \uD835\uDDDE
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDDE
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE12': SymbolRenderConfig( // 𝘒
    math: RenderConfig( // \uD835\uDE12
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE12
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE7A': SymbolRenderConfig( // 𝙺
    math: RenderConfig( // \uD835\uDE7A
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE7A
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD42': SymbolRenderConfig( // 𝕂
    math: RenderConfig( // \uD835\uDD42
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD42
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA6': SymbolRenderConfig( // 𝒦
    math: RenderConfig( // \uD835\uDCA6
      replaceChar: 'K', // K
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA6
      replaceChar: 'K', // K
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC0B': SymbolRenderConfig( // 𝐋
    math: RenderConfig( // \uD835\uDC0B
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC0B
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC3F': SymbolRenderConfig( // 𝐿
    math: RenderConfig( // \uD835\uDC3F
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC3F
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC73': SymbolRenderConfig( // 𝑳
    math: RenderConfig( // \uD835\uDC73
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC73
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD0F': SymbolRenderConfig( // 𝔏
    math: RenderConfig( // \uD835\uDD0F
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD0F
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDAB': SymbolRenderConfig( // 𝖫
    math: RenderConfig( // \uD835\uDDAB
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDAB
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDDF': SymbolRenderConfig( // 𝗟
    math: RenderConfig( // \uD835\uDDDF
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDDF
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE13': SymbolRenderConfig( // 𝘓
    math: RenderConfig( // \uD835\uDE13
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE13
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE7B': SymbolRenderConfig( // 𝙻
    math: RenderConfig( // \uD835\uDE7B
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE7B
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD43': SymbolRenderConfig( // 𝕃
    math: RenderConfig( // \uD835\uDD43
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD43
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA7': SymbolRenderConfig( // 𝒧
    math: RenderConfig( // \uD835\uDCA7
      replaceChar: 'L', // L
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA7
      replaceChar: 'L', // L
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC0C': SymbolRenderConfig( // 𝐌
    math: RenderConfig( // \uD835\uDC0C
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC0C
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC40': SymbolRenderConfig( // 𝑀
    math: RenderConfig( // \uD835\uDC40
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC40
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC74': SymbolRenderConfig( // 𝑴
    math: RenderConfig( // \uD835\uDC74
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC74
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD10': SymbolRenderConfig( // 𝔐
    math: RenderConfig( // \uD835\uDD10
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD10
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDAC': SymbolRenderConfig( // 𝖬
    math: RenderConfig( // \uD835\uDDAC
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDAC
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE0': SymbolRenderConfig( // 𝗠
    math: RenderConfig( // \uD835\uDDE0
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE0
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE14': SymbolRenderConfig( // 𝘔
    math: RenderConfig( // \uD835\uDE14
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE14
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE7C': SymbolRenderConfig( // 𝙼
    math: RenderConfig( // \uD835\uDE7C
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE7C
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD44': SymbolRenderConfig( // 𝕄
    math: RenderConfig( // \uD835\uDD44
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD44
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA8': SymbolRenderConfig( // 𝒨
    math: RenderConfig( // \uD835\uDCA8
      replaceChar: 'M', // M
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA8
      replaceChar: 'M', // M
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC0D': SymbolRenderConfig( // 𝐍
    math: RenderConfig( // \uD835\uDC0D
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC0D
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC41': SymbolRenderConfig( // 𝑁
    math: RenderConfig( // \uD835\uDC41
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC41
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC75': SymbolRenderConfig( // 𝑵
    math: RenderConfig( // \uD835\uDC75
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC75
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD11': SymbolRenderConfig( // 𝔑
    math: RenderConfig( // \uD835\uDD11
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD11
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDAD': SymbolRenderConfig( // 𝖭
    math: RenderConfig( // \uD835\uDDAD
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDAD
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE1': SymbolRenderConfig( // 𝗡
    math: RenderConfig( // \uD835\uDDE1
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE1
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE15': SymbolRenderConfig( // 𝘕
    math: RenderConfig( // \uD835\uDE15
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE15
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE7D': SymbolRenderConfig( // 𝙽
    math: RenderConfig( // \uD835\uDE7D
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE7D
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD45': SymbolRenderConfig( // 𝕅
    math: RenderConfig( // \uD835\uDD45
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD45
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCA9': SymbolRenderConfig( // 𝒩
    math: RenderConfig( // \uD835\uDCA9
      replaceChar: 'N', // N
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCA9
      replaceChar: 'N', // N
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC0E': SymbolRenderConfig( // 𝐎
    math: RenderConfig( // \uD835\uDC0E
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC0E
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC42': SymbolRenderConfig( // 𝑂
    math: RenderConfig( // \uD835\uDC42
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC42
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC76': SymbolRenderConfig( // 𝑶
    math: RenderConfig( // \uD835\uDC76
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC76
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD12': SymbolRenderConfig( // 𝔒
    math: RenderConfig( // \uD835\uDD12
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD12
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDAE': SymbolRenderConfig( // 𝖮
    math: RenderConfig( // \uD835\uDDAE
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDAE
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE2': SymbolRenderConfig( // 𝗢
    math: RenderConfig( // \uD835\uDDE2
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE2
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE16': SymbolRenderConfig( // 𝘖
    math: RenderConfig( // \uD835\uDE16
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE16
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE7E': SymbolRenderConfig( // 𝙾
    math: RenderConfig( // \uD835\uDE7E
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE7E
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD46': SymbolRenderConfig( // 𝕆
    math: RenderConfig( // \uD835\uDD46
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD46
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCAA': SymbolRenderConfig( // 𝒪
    math: RenderConfig( // \uD835\uDCAA
      replaceChar: 'O', // O
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCAA
      replaceChar: 'O', // O
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC0F': SymbolRenderConfig( // 𝐏
    math: RenderConfig( // \uD835\uDC0F
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC0F
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC43': SymbolRenderConfig( // 𝑃
    math: RenderConfig( // \uD835\uDC43
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC43
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC77': SymbolRenderConfig( // 𝑷
    math: RenderConfig( // \uD835\uDC77
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC77
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD13': SymbolRenderConfig( // 𝔓
    math: RenderConfig( // \uD835\uDD13
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD13
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDAF': SymbolRenderConfig( // 𝖯
    math: RenderConfig( // \uD835\uDDAF
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDAF
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE3': SymbolRenderConfig( // 𝗣
    math: RenderConfig( // \uD835\uDDE3
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE3
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE17': SymbolRenderConfig( // 𝘗
    math: RenderConfig( // \uD835\uDE17
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE17
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE7F': SymbolRenderConfig( // 𝙿
    math: RenderConfig( // \uD835\uDE7F
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE7F
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD47': SymbolRenderConfig( // 𝕇
    math: RenderConfig( // \uD835\uDD47
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD47
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCAB': SymbolRenderConfig( // 𝒫
    math: RenderConfig( // \uD835\uDCAB
      replaceChar: 'P', // P
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCAB
      replaceChar: 'P', // P
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC10': SymbolRenderConfig( // 𝐐
    math: RenderConfig( // \uD835\uDC10
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC10
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC44': SymbolRenderConfig( // 𝑄
    math: RenderConfig( // \uD835\uDC44
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC44
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC78': SymbolRenderConfig( // 𝑸
    math: RenderConfig( // \uD835\uDC78
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC78
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD14': SymbolRenderConfig( // 𝔔
    math: RenderConfig( // \uD835\uDD14
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD14
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB0': SymbolRenderConfig( // 𝖰
    math: RenderConfig( // \uD835\uDDB0
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB0
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE4': SymbolRenderConfig( // 𝗤
    math: RenderConfig( // \uD835\uDDE4
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE4
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE18': SymbolRenderConfig( // 𝘘
    math: RenderConfig( // \uD835\uDE18
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE18
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE80': SymbolRenderConfig( // 𝚀
    math: RenderConfig( // \uD835\uDE80
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE80
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD48': SymbolRenderConfig( // 𝕈
    math: RenderConfig( // \uD835\uDD48
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD48
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCAC': SymbolRenderConfig( // 𝒬
    math: RenderConfig( // \uD835\uDCAC
      replaceChar: 'Q', // Q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCAC
      replaceChar: 'Q', // Q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC11': SymbolRenderConfig( // 𝐑
    math: RenderConfig( // \uD835\uDC11
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC11
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC45': SymbolRenderConfig( // 𝑅
    math: RenderConfig( // \uD835\uDC45
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC45
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC79': SymbolRenderConfig( // 𝑹
    math: RenderConfig( // \uD835\uDC79
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC79
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD15': SymbolRenderConfig( // 𝔕
    math: RenderConfig( // \uD835\uDD15
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD15
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB1': SymbolRenderConfig( // 𝖱
    math: RenderConfig( // \uD835\uDDB1
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB1
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE5': SymbolRenderConfig( // 𝗥
    math: RenderConfig( // \uD835\uDDE5
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE5
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE19': SymbolRenderConfig( // 𝘙
    math: RenderConfig( // \uD835\uDE19
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE19
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE81': SymbolRenderConfig( // 𝚁
    math: RenderConfig( // \uD835\uDE81
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE81
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD49': SymbolRenderConfig( // 𝕉
    math: RenderConfig( // \uD835\uDD49
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD49
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCAD': SymbolRenderConfig( // 𝒭
    math: RenderConfig( // \uD835\uDCAD
      replaceChar: 'R', // R
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCAD
      replaceChar: 'R', // R
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC12': SymbolRenderConfig( // 𝐒
    math: RenderConfig( // \uD835\uDC12
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC12
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC46': SymbolRenderConfig( // 𝑆
    math: RenderConfig( // \uD835\uDC46
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC46
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC7A': SymbolRenderConfig( // 𝑺
    math: RenderConfig( // \uD835\uDC7A
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC7A
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD16': SymbolRenderConfig( // 𝔖
    math: RenderConfig( // \uD835\uDD16
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD16
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB2': SymbolRenderConfig( // 𝖲
    math: RenderConfig( // \uD835\uDDB2
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB2
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE6': SymbolRenderConfig( // 𝗦
    math: RenderConfig( // \uD835\uDDE6
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE6
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE1A': SymbolRenderConfig( // 𝘚
    math: RenderConfig( // \uD835\uDE1A
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE1A
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE82': SymbolRenderConfig( // 𝚂
    math: RenderConfig( // \uD835\uDE82
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE82
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD4A': SymbolRenderConfig( // 𝕊
    math: RenderConfig( // \uD835\uDD4A
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD4A
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCAE': SymbolRenderConfig( // 𝒮
    math: RenderConfig( // \uD835\uDCAE
      replaceChar: 'S', // S
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCAE
      replaceChar: 'S', // S
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC13': SymbolRenderConfig( // 𝐓
    math: RenderConfig( // \uD835\uDC13
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC13
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC47': SymbolRenderConfig( // 𝑇
    math: RenderConfig( // \uD835\uDC47
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC47
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC7B': SymbolRenderConfig( // 𝑻
    math: RenderConfig( // \uD835\uDC7B
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC7B
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD17': SymbolRenderConfig( // 𝔗
    math: RenderConfig( // \uD835\uDD17
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD17
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB3': SymbolRenderConfig( // 𝖳
    math: RenderConfig( // \uD835\uDDB3
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB3
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE7': SymbolRenderConfig( // 𝗧
    math: RenderConfig( // \uD835\uDDE7
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE7
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE1B': SymbolRenderConfig( // 𝘛
    math: RenderConfig( // \uD835\uDE1B
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE1B
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE83': SymbolRenderConfig( // 𝚃
    math: RenderConfig( // \uD835\uDE83
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE83
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD4B': SymbolRenderConfig( // 𝕋
    math: RenderConfig( // \uD835\uDD4B
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD4B
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCAF': SymbolRenderConfig( // 𝒯
    math: RenderConfig( // \uD835\uDCAF
      replaceChar: 'T', // T
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCAF
      replaceChar: 'T', // T
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC14': SymbolRenderConfig( // 𝐔
    math: RenderConfig( // \uD835\uDC14
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC14
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC48': SymbolRenderConfig( // 𝑈
    math: RenderConfig( // \uD835\uDC48
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC48
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC7C': SymbolRenderConfig( // 𝑼
    math: RenderConfig( // \uD835\uDC7C
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC7C
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD18': SymbolRenderConfig( // 𝔘
    math: RenderConfig( // \uD835\uDD18
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD18
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB4': SymbolRenderConfig( // 𝖴
    math: RenderConfig( // \uD835\uDDB4
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB4
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE8': SymbolRenderConfig( // 𝗨
    math: RenderConfig( // \uD835\uDDE8
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE8
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE1C': SymbolRenderConfig( // 𝘜
    math: RenderConfig( // \uD835\uDE1C
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE1C
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE84': SymbolRenderConfig( // 𝚄
    math: RenderConfig( // \uD835\uDE84
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE84
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD4C': SymbolRenderConfig( // 𝕌
    math: RenderConfig( // \uD835\uDD4C
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD4C
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCB0': SymbolRenderConfig( // 𝒰
    math: RenderConfig( // \uD835\uDCB0
      replaceChar: 'U', // U
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCB0
      replaceChar: 'U', // U
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC15': SymbolRenderConfig( // 𝐕
    math: RenderConfig( // \uD835\uDC15
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC15
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC49': SymbolRenderConfig( // 𝑉
    math: RenderConfig( // \uD835\uDC49
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC49
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC7D': SymbolRenderConfig( // 𝑽
    math: RenderConfig( // \uD835\uDC7D
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC7D
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD19': SymbolRenderConfig( // 𝔙
    math: RenderConfig( // \uD835\uDD19
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD19
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB5': SymbolRenderConfig( // 𝖵
    math: RenderConfig( // \uD835\uDDB5
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB5
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDE9': SymbolRenderConfig( // 𝗩
    math: RenderConfig( // \uD835\uDDE9
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDE9
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE1D': SymbolRenderConfig( // 𝘝
    math: RenderConfig( // \uD835\uDE1D
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE1D
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE85': SymbolRenderConfig( // 𝚅
    math: RenderConfig( // \uD835\uDE85
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE85
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD4D': SymbolRenderConfig( // 𝕍
    math: RenderConfig( // \uD835\uDD4D
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD4D
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCB1': SymbolRenderConfig( // 𝒱
    math: RenderConfig( // \uD835\uDCB1
      replaceChar: 'V', // V
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCB1
      replaceChar: 'V', // V
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC16': SymbolRenderConfig( // 𝐖
    math: RenderConfig( // \uD835\uDC16
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC16
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC4A': SymbolRenderConfig( // 𝑊
    math: RenderConfig( // \uD835\uDC4A
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC4A
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC7E': SymbolRenderConfig( // 𝑾
    math: RenderConfig( // \uD835\uDC7E
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC7E
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD1A': SymbolRenderConfig( // 𝔚
    math: RenderConfig( // \uD835\uDD1A
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD1A
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB6': SymbolRenderConfig( // 𝖶
    math: RenderConfig( // \uD835\uDDB6
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB6
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDEA': SymbolRenderConfig( // 𝗪
    math: RenderConfig( // \uD835\uDDEA
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDEA
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE1E': SymbolRenderConfig( // 𝘞
    math: RenderConfig( // \uD835\uDE1E
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE1E
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE86': SymbolRenderConfig( // 𝚆
    math: RenderConfig( // \uD835\uDE86
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE86
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD4E': SymbolRenderConfig( // 𝕎
    math: RenderConfig( // \uD835\uDD4E
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD4E
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCB2': SymbolRenderConfig( // 𝒲
    math: RenderConfig( // \uD835\uDCB2
      replaceChar: 'W', // W
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCB2
      replaceChar: 'W', // W
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC17': SymbolRenderConfig( // 𝐗
    math: RenderConfig( // \uD835\uDC17
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC17
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC4B': SymbolRenderConfig( // 𝑋
    math: RenderConfig( // \uD835\uDC4B
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC4B
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC7F': SymbolRenderConfig( // 𝑿
    math: RenderConfig( // \uD835\uDC7F
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC7F
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD1B': SymbolRenderConfig( // 𝔛
    math: RenderConfig( // \uD835\uDD1B
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD1B
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB7': SymbolRenderConfig( // 𝖷
    math: RenderConfig( // \uD835\uDDB7
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB7
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDEB': SymbolRenderConfig( // 𝗫
    math: RenderConfig( // \uD835\uDDEB
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDEB
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE1F': SymbolRenderConfig( // 𝘟
    math: RenderConfig( // \uD835\uDE1F
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE1F
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE87': SymbolRenderConfig( // 𝚇
    math: RenderConfig( // \uD835\uDE87
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE87
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD4F': SymbolRenderConfig( // 𝕏
    math: RenderConfig( // \uD835\uDD4F
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD4F
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCB3': SymbolRenderConfig( // 𝒳
    math: RenderConfig( // \uD835\uDCB3
      replaceChar: 'X', // X
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCB3
      replaceChar: 'X', // X
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC18': SymbolRenderConfig( // 𝐘
    math: RenderConfig( // \uD835\uDC18
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC18
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC4C': SymbolRenderConfig( // 𝑌
    math: RenderConfig( // \uD835\uDC4C
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC4C
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC80': SymbolRenderConfig( // 𝒀
    math: RenderConfig( // \uD835\uDC80
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC80
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD1C': SymbolRenderConfig( // 𝔜
    math: RenderConfig( // \uD835\uDD1C
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD1C
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB8': SymbolRenderConfig( // 𝖸
    math: RenderConfig( // \uD835\uDDB8
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB8
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDEC': SymbolRenderConfig( // 𝗬
    math: RenderConfig( // \uD835\uDDEC
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDEC
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE20': SymbolRenderConfig( // 𝘠
    math: RenderConfig( // \uD835\uDE20
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE20
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE88': SymbolRenderConfig( // 𝚈
    math: RenderConfig( // \uD835\uDE88
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE88
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD50': SymbolRenderConfig( // 𝕐
    math: RenderConfig( // \uD835\uDD50
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD50
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCB4': SymbolRenderConfig( // 𝒴
    math: RenderConfig( // \uD835\uDCB4
      replaceChar: 'Y', // Y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCB4
      replaceChar: 'Y', // Y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC19': SymbolRenderConfig( // 𝐙
    math: RenderConfig( // \uD835\uDC19
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC19
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC4D': SymbolRenderConfig( // 𝑍
    math: RenderConfig( // \uD835\uDC4D
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC4D
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC81': SymbolRenderConfig( // 𝒁
    math: RenderConfig( // \uD835\uDC81
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC81
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD1D': SymbolRenderConfig( // 𝔝
    math: RenderConfig( // \uD835\uDD1D
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD1D
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDB9': SymbolRenderConfig( // 𝖹
    math: RenderConfig( // \uD835\uDDB9
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDB9
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDED': SymbolRenderConfig( // 𝗭
    math: RenderConfig( // \uD835\uDDED
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDED
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE21': SymbolRenderConfig( // 𝘡
    math: RenderConfig( // \uD835\uDE21
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE21
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE89': SymbolRenderConfig( // 𝚉
    math: RenderConfig( // \uD835\uDE89
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE89
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD51': SymbolRenderConfig( // 𝕑
    math: RenderConfig( // \uD835\uDD51
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD51
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDCB5': SymbolRenderConfig( // 𝒵
    math: RenderConfig( // \uD835\uDCB5
      replaceChar: 'Z', // Z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDCB5
      replaceChar: 'Z', // Z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC1A': SymbolRenderConfig( // 𝐚
    math: RenderConfig( // \uD835\uDC1A
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC1A
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC4E': SymbolRenderConfig( // 𝑎
    math: RenderConfig( // \uD835\uDC4E
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC4E
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC82': SymbolRenderConfig( // 𝒂
    math: RenderConfig( // \uD835\uDC82
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC82
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD1E': SymbolRenderConfig( // 𝔞
    math: RenderConfig( // \uD835\uDD1E
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD1E
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDBA': SymbolRenderConfig( // 𝖺
    math: RenderConfig( // \uD835\uDDBA
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDBA
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDEE': SymbolRenderConfig( // 𝗮
    math: RenderConfig( // \uD835\uDDEE
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDEE
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE22': SymbolRenderConfig( // 𝘢
    math: RenderConfig( // \uD835\uDE22
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE22
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE8A': SymbolRenderConfig( // 𝚊
    math: RenderConfig( // \uD835\uDE8A
      replaceChar: 'a', // a
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE8A
      replaceChar: 'a', // a
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC1B': SymbolRenderConfig( // 𝐛
    math: RenderConfig( // \uD835\uDC1B
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC1B
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC4F': SymbolRenderConfig( // 𝑏
    math: RenderConfig( // \uD835\uDC4F
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC4F
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC83': SymbolRenderConfig( // 𝒃
    math: RenderConfig( // \uD835\uDC83
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC83
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD1F': SymbolRenderConfig( // 𝔟
    math: RenderConfig( // \uD835\uDD1F
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD1F
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDBB': SymbolRenderConfig( // 𝖻
    math: RenderConfig( // \uD835\uDDBB
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDBB
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDEF': SymbolRenderConfig( // 𝗯
    math: RenderConfig( // \uD835\uDDEF
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDEF
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE23': SymbolRenderConfig( // 𝘣
    math: RenderConfig( // \uD835\uDE23
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE23
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE8B': SymbolRenderConfig( // 𝚋
    math: RenderConfig( // \uD835\uDE8B
      replaceChar: 'b', // b
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE8B
      replaceChar: 'b', // b
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC1C': SymbolRenderConfig( // 𝐜
    math: RenderConfig( // \uD835\uDC1C
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC1C
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC50': SymbolRenderConfig( // 𝑐
    math: RenderConfig( // \uD835\uDC50
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC50
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC84': SymbolRenderConfig( // 𝒄
    math: RenderConfig( // \uD835\uDC84
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC84
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD20': SymbolRenderConfig( // 𝔠
    math: RenderConfig( // \uD835\uDD20
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD20
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDBC': SymbolRenderConfig( // 𝖼
    math: RenderConfig( // \uD835\uDDBC
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDBC
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF0': SymbolRenderConfig( // 𝗰
    math: RenderConfig( // \uD835\uDDF0
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF0
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE24': SymbolRenderConfig( // 𝘤
    math: RenderConfig( // \uD835\uDE24
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE24
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE8C': SymbolRenderConfig( // 𝚌
    math: RenderConfig( // \uD835\uDE8C
      replaceChar: 'c', // c
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE8C
      replaceChar: 'c', // c
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC1D': SymbolRenderConfig( // 𝐝
    math: RenderConfig( // \uD835\uDC1D
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC1D
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC51': SymbolRenderConfig( // 𝑑
    math: RenderConfig( // \uD835\uDC51
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC51
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC85': SymbolRenderConfig( // 𝒅
    math: RenderConfig( // \uD835\uDC85
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC85
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD21': SymbolRenderConfig( // 𝔡
    math: RenderConfig( // \uD835\uDD21
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD21
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDBD': SymbolRenderConfig( // 𝖽
    math: RenderConfig( // \uD835\uDDBD
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDBD
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF1': SymbolRenderConfig( // 𝗱
    math: RenderConfig( // \uD835\uDDF1
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF1
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE25': SymbolRenderConfig( // 𝘥
    math: RenderConfig( // \uD835\uDE25
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE25
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE8D': SymbolRenderConfig( // 𝚍
    math: RenderConfig( // \uD835\uDE8D
      replaceChar: 'd', // d
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE8D
      replaceChar: 'd', // d
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC1E': SymbolRenderConfig( // 𝐞
    math: RenderConfig( // \uD835\uDC1E
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC1E
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC52': SymbolRenderConfig( // 𝑒
    math: RenderConfig( // \uD835\uDC52
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC52
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC86': SymbolRenderConfig( // 𝒆
    math: RenderConfig( // \uD835\uDC86
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC86
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD22': SymbolRenderConfig( // 𝔢
    math: RenderConfig( // \uD835\uDD22
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD22
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDBE': SymbolRenderConfig( // 𝖾
    math: RenderConfig( // \uD835\uDDBE
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDBE
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF2': SymbolRenderConfig( // 𝗲
    math: RenderConfig( // \uD835\uDDF2
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF2
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE26': SymbolRenderConfig( // 𝘦
    math: RenderConfig( // \uD835\uDE26
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE26
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE8E': SymbolRenderConfig( // 𝚎
    math: RenderConfig( // \uD835\uDE8E
      replaceChar: 'e', // e
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE8E
      replaceChar: 'e', // e
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC1F': SymbolRenderConfig( // 𝐟
    math: RenderConfig( // \uD835\uDC1F
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC1F
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC53': SymbolRenderConfig( // 𝑓
    math: RenderConfig( // \uD835\uDC53
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC53
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC87': SymbolRenderConfig( // 𝒇
    math: RenderConfig( // \uD835\uDC87
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC87
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD23': SymbolRenderConfig( // 𝔣
    math: RenderConfig( // \uD835\uDD23
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD23
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDBF': SymbolRenderConfig( // 𝖿
    math: RenderConfig( // \uD835\uDDBF
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDBF
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF3': SymbolRenderConfig( // 𝗳
    math: RenderConfig( // \uD835\uDDF3
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF3
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE27': SymbolRenderConfig( // 𝘧
    math: RenderConfig( // \uD835\uDE27
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE27
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE8F': SymbolRenderConfig( // 𝚏
    math: RenderConfig( // \uD835\uDE8F
      replaceChar: 'f', // f
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE8F
      replaceChar: 'f', // f
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC20': SymbolRenderConfig( // 𝐠
    math: RenderConfig( // \uD835\uDC20
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC20
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC54': SymbolRenderConfig( // 𝑔
    math: RenderConfig( // \uD835\uDC54
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC54
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC88': SymbolRenderConfig( // 𝒈
    math: RenderConfig( // \uD835\uDC88
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC88
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD24': SymbolRenderConfig( // 𝔤
    math: RenderConfig( // \uD835\uDD24
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD24
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC0': SymbolRenderConfig( // 𝗀
    math: RenderConfig( // \uD835\uDDC0
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC0
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF4': SymbolRenderConfig( // 𝗴
    math: RenderConfig( // \uD835\uDDF4
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF4
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE28': SymbolRenderConfig( // 𝘨
    math: RenderConfig( // \uD835\uDE28
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE28
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE90': SymbolRenderConfig( // 𝚐
    math: RenderConfig( // \uD835\uDE90
      replaceChar: 'g', // g
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE90
      replaceChar: 'g', // g
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC21': SymbolRenderConfig( // 𝐡
    math: RenderConfig( // \uD835\uDC21
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC21
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC55': SymbolRenderConfig( // 𝑕
    math: RenderConfig( // \uD835\uDC55
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC55
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC89': SymbolRenderConfig( // 𝒉
    math: RenderConfig( // \uD835\uDC89
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC89
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD25': SymbolRenderConfig( // 𝔥
    math: RenderConfig( // \uD835\uDD25
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD25
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC1': SymbolRenderConfig( // 𝗁
    math: RenderConfig( // \uD835\uDDC1
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC1
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF5': SymbolRenderConfig( // 𝗵
    math: RenderConfig( // \uD835\uDDF5
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF5
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE29': SymbolRenderConfig( // 𝘩
    math: RenderConfig( // \uD835\uDE29
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE29
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE91': SymbolRenderConfig( // 𝚑
    math: RenderConfig( // \uD835\uDE91
      replaceChar: 'h', // h
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE91
      replaceChar: 'h', // h
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC22': SymbolRenderConfig( // 𝐢
    math: RenderConfig( // \uD835\uDC22
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC22
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC56': SymbolRenderConfig( // 𝑖
    math: RenderConfig( // \uD835\uDC56
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC56
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC8A': SymbolRenderConfig( // 𝒊
    math: RenderConfig( // \uD835\uDC8A
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC8A
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD26': SymbolRenderConfig( // 𝔦
    math: RenderConfig( // \uD835\uDD26
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD26
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC2': SymbolRenderConfig( // 𝗂
    math: RenderConfig( // \uD835\uDDC2
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC2
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF6': SymbolRenderConfig( // 𝗶
    math: RenderConfig( // \uD835\uDDF6
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF6
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE2A': SymbolRenderConfig( // 𝘪
    math: RenderConfig( // \uD835\uDE2A
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE2A
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE92': SymbolRenderConfig( // 𝚒
    math: RenderConfig( // \uD835\uDE92
      replaceChar: 'i', // i
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE92
      replaceChar: 'i', // i
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC23': SymbolRenderConfig( // 𝐣
    math: RenderConfig( // \uD835\uDC23
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC23
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC57': SymbolRenderConfig( // 𝑗
    math: RenderConfig( // \uD835\uDC57
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC57
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC8B': SymbolRenderConfig( // 𝒋
    math: RenderConfig( // \uD835\uDC8B
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC8B
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD27': SymbolRenderConfig( // 𝔧
    math: RenderConfig( // \uD835\uDD27
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD27
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC3': SymbolRenderConfig( // 𝗃
    math: RenderConfig( // \uD835\uDDC3
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC3
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF7': SymbolRenderConfig( // 𝗷
    math: RenderConfig( // \uD835\uDDF7
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF7
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE2B': SymbolRenderConfig( // 𝘫
    math: RenderConfig( // \uD835\uDE2B
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE2B
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE93': SymbolRenderConfig( // 𝚓
    math: RenderConfig( // \uD835\uDE93
      replaceChar: 'j', // j
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE93
      replaceChar: 'j', // j
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC24': SymbolRenderConfig( // 𝐤
    math: RenderConfig( // \uD835\uDC24
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC24
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC58': SymbolRenderConfig( // 𝑘
    math: RenderConfig( // \uD835\uDC58
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC58
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC8C': SymbolRenderConfig( // 𝒌
    math: RenderConfig( // \uD835\uDC8C
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC8C
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD28': SymbolRenderConfig( // 𝔨
    math: RenderConfig( // \uD835\uDD28
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD28
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC4': SymbolRenderConfig( // 𝗄
    math: RenderConfig( // \uD835\uDDC4
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC4
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF8': SymbolRenderConfig( // 𝗸
    math: RenderConfig( // \uD835\uDDF8
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF8
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE2C': SymbolRenderConfig( // 𝘬
    math: RenderConfig( // \uD835\uDE2C
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE2C
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE94': SymbolRenderConfig( // 𝚔
    math: RenderConfig( // \uD835\uDE94
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE94
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC25': SymbolRenderConfig( // 𝐥
    math: RenderConfig( // \uD835\uDC25
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC25
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC59': SymbolRenderConfig( // 𝑙
    math: RenderConfig( // \uD835\uDC59
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC59
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC8D': SymbolRenderConfig( // 𝒍
    math: RenderConfig( // \uD835\uDC8D
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC8D
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD29': SymbolRenderConfig( // 𝔩
    math: RenderConfig( // \uD835\uDD29
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD29
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC5': SymbolRenderConfig( // 𝗅
    math: RenderConfig( // \uD835\uDDC5
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC5
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDF9': SymbolRenderConfig( // 𝗹
    math: RenderConfig( // \uD835\uDDF9
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDF9
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE2D': SymbolRenderConfig( // 𝘭
    math: RenderConfig( // \uD835\uDE2D
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE2D
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE95': SymbolRenderConfig( // 𝚕
    math: RenderConfig( // \uD835\uDE95
      replaceChar: 'l', // l
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE95
      replaceChar: 'l', // l
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC26': SymbolRenderConfig( // 𝐦
    math: RenderConfig( // \uD835\uDC26
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC26
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC5A': SymbolRenderConfig( // 𝑚
    math: RenderConfig( // \uD835\uDC5A
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC5A
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC8E': SymbolRenderConfig( // 𝒎
    math: RenderConfig( // \uD835\uDC8E
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC8E
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD2A': SymbolRenderConfig( // 𝔪
    math: RenderConfig( // \uD835\uDD2A
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD2A
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC6': SymbolRenderConfig( // 𝗆
    math: RenderConfig( // \uD835\uDDC6
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC6
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDFA': SymbolRenderConfig( // 𝗺
    math: RenderConfig( // \uD835\uDDFA
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDFA
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE2E': SymbolRenderConfig( // 𝘮
    math: RenderConfig( // \uD835\uDE2E
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE2E
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE96': SymbolRenderConfig( // 𝚖
    math: RenderConfig( // \uD835\uDE96
      replaceChar: 'm', // m
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE96
      replaceChar: 'm', // m
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC27': SymbolRenderConfig( // 𝐧
    math: RenderConfig( // \uD835\uDC27
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC27
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC5B': SymbolRenderConfig( // 𝑛
    math: RenderConfig( // \uD835\uDC5B
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC5B
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC8F': SymbolRenderConfig( // 𝒏
    math: RenderConfig( // \uD835\uDC8F
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC8F
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD2B': SymbolRenderConfig( // 𝔫
    math: RenderConfig( // \uD835\uDD2B
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD2B
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC7': SymbolRenderConfig( // 𝗇
    math: RenderConfig( // \uD835\uDDC7
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC7
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDFB': SymbolRenderConfig( // 𝗻
    math: RenderConfig( // \uD835\uDDFB
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDFB
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE2F': SymbolRenderConfig( // 𝘯
    math: RenderConfig( // \uD835\uDE2F
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE2F
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE97': SymbolRenderConfig( // 𝚗
    math: RenderConfig( // \uD835\uDE97
      replaceChar: 'n', // n
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE97
      replaceChar: 'n', // n
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC28': SymbolRenderConfig( // 𝐨
    math: RenderConfig( // \uD835\uDC28
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC28
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC5C': SymbolRenderConfig( // 𝑜
    math: RenderConfig( // \uD835\uDC5C
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC5C
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC90': SymbolRenderConfig( // 𝒐
    math: RenderConfig( // \uD835\uDC90
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC90
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD2C': SymbolRenderConfig( // 𝔬
    math: RenderConfig( // \uD835\uDD2C
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD2C
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC8': SymbolRenderConfig( // 𝗈
    math: RenderConfig( // \uD835\uDDC8
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC8
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDFC': SymbolRenderConfig( // 𝗼
    math: RenderConfig( // \uD835\uDDFC
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDFC
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE30': SymbolRenderConfig( // 𝘰
    math: RenderConfig( // \uD835\uDE30
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE30
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE98': SymbolRenderConfig( // 𝚘
    math: RenderConfig( // \uD835\uDE98
      replaceChar: 'o', // o
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE98
      replaceChar: 'o', // o
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC29': SymbolRenderConfig( // 𝐩
    math: RenderConfig( // \uD835\uDC29
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC29
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC5D': SymbolRenderConfig( // 𝑝
    math: RenderConfig( // \uD835\uDC5D
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC5D
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC91': SymbolRenderConfig( // 𝒑
    math: RenderConfig( // \uD835\uDC91
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC91
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD2D': SymbolRenderConfig( // 𝔭
    math: RenderConfig( // \uD835\uDD2D
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD2D
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDC9': SymbolRenderConfig( // 𝗉
    math: RenderConfig( // \uD835\uDDC9
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDC9
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDFD': SymbolRenderConfig( // 𝗽
    math: RenderConfig( // \uD835\uDDFD
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDFD
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE31': SymbolRenderConfig( // 𝘱
    math: RenderConfig( // \uD835\uDE31
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE31
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE99': SymbolRenderConfig( // 𝚙
    math: RenderConfig( // \uD835\uDE99
      replaceChar: 'p', // p
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE99
      replaceChar: 'p', // p
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC2A': SymbolRenderConfig( // 𝐪
    math: RenderConfig( // \uD835\uDC2A
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC2A
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC5E': SymbolRenderConfig( // 𝑞
    math: RenderConfig( // \uD835\uDC5E
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC5E
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC92': SymbolRenderConfig( // 𝒒
    math: RenderConfig( // \uD835\uDC92
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC92
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD2E': SymbolRenderConfig( // 𝔮
    math: RenderConfig( // \uD835\uDD2E
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD2E
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDCA': SymbolRenderConfig( // 𝗊
    math: RenderConfig( // \uD835\uDDCA
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDCA
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDFE': SymbolRenderConfig( // 𝗾
    math: RenderConfig( // \uD835\uDDFE
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDFE
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE32': SymbolRenderConfig( // 𝘲
    math: RenderConfig( // \uD835\uDE32
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE32
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE9A': SymbolRenderConfig( // 𝚚
    math: RenderConfig( // \uD835\uDE9A
      replaceChar: 'q', // q
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE9A
      replaceChar: 'q', // q
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC2B': SymbolRenderConfig( // 𝐫
    math: RenderConfig( // \uD835\uDC2B
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC2B
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC5F': SymbolRenderConfig( // 𝑟
    math: RenderConfig( // \uD835\uDC5F
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC5F
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC93': SymbolRenderConfig( // 𝒓
    math: RenderConfig( // \uD835\uDC93
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC93
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD2F': SymbolRenderConfig( // 𝔯
    math: RenderConfig( // \uD835\uDD2F
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD2F
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDCB': SymbolRenderConfig( // 𝗋
    math: RenderConfig( // \uD835\uDDCB
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDCB
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDFF': SymbolRenderConfig( // 𝗿
    math: RenderConfig( // \uD835\uDDFF
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDFF
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE33': SymbolRenderConfig( // 𝘳
    math: RenderConfig( // \uD835\uDE33
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE33
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE9B': SymbolRenderConfig( // 𝚛
    math: RenderConfig( // \uD835\uDE9B
      replaceChar: 'r', // r
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE9B
      replaceChar: 'r', // r
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC2C': SymbolRenderConfig( // 𝐬
    math: RenderConfig( // \uD835\uDC2C
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC2C
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC60': SymbolRenderConfig( // 𝑠
    math: RenderConfig( // \uD835\uDC60
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC60
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC94': SymbolRenderConfig( // 𝒔
    math: RenderConfig( // \uD835\uDC94
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC94
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD30': SymbolRenderConfig( // 𝔰
    math: RenderConfig( // \uD835\uDD30
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD30
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDCC': SymbolRenderConfig( // 𝗌
    math: RenderConfig( // \uD835\uDDCC
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDCC
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE00': SymbolRenderConfig( // 𝘀
    math: RenderConfig( // \uD835\uDE00
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE00
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE34': SymbolRenderConfig( // 𝘴
    math: RenderConfig( // \uD835\uDE34
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE34
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE9C': SymbolRenderConfig( // 𝚜
    math: RenderConfig( // \uD835\uDE9C
      replaceChar: 's', // s
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE9C
      replaceChar: 's', // s
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC2D': SymbolRenderConfig( // 𝐭
    math: RenderConfig( // \uD835\uDC2D
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC2D
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC61': SymbolRenderConfig( // 𝑡
    math: RenderConfig( // \uD835\uDC61
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC61
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC95': SymbolRenderConfig( // 𝒕
    math: RenderConfig( // \uD835\uDC95
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC95
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD31': SymbolRenderConfig( // 𝔱
    math: RenderConfig( // \uD835\uDD31
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD31
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDCD': SymbolRenderConfig( // 𝗍
    math: RenderConfig( // \uD835\uDDCD
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDCD
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE01': SymbolRenderConfig( // 𝘁
    math: RenderConfig( // \uD835\uDE01
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE01
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE35': SymbolRenderConfig( // 𝘵
    math: RenderConfig( // \uD835\uDE35
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE35
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE9D': SymbolRenderConfig( // 𝚝
    math: RenderConfig( // \uD835\uDE9D
      replaceChar: 't', // t
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE9D
      replaceChar: 't', // t
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC2E': SymbolRenderConfig( // 𝐮
    math: RenderConfig( // \uD835\uDC2E
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC2E
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC62': SymbolRenderConfig( // 𝑢
    math: RenderConfig( // \uD835\uDC62
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC62
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC96': SymbolRenderConfig( // 𝒖
    math: RenderConfig( // \uD835\uDC96
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC96
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD32': SymbolRenderConfig( // 𝔲
    math: RenderConfig( // \uD835\uDD32
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD32
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDCE': SymbolRenderConfig( // 𝗎
    math: RenderConfig( // \uD835\uDDCE
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDCE
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE02': SymbolRenderConfig( // 𝘂
    math: RenderConfig( // \uD835\uDE02
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE02
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE36': SymbolRenderConfig( // 𝘶
    math: RenderConfig( // \uD835\uDE36
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE36
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE9E': SymbolRenderConfig( // 𝚞
    math: RenderConfig( // \uD835\uDE9E
      replaceChar: 'u', // u
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE9E
      replaceChar: 'u', // u
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC2F': SymbolRenderConfig( // 𝐯
    math: RenderConfig( // \uD835\uDC2F
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC2F
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC63': SymbolRenderConfig( // 𝑣
    math: RenderConfig( // \uD835\uDC63
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC63
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC97': SymbolRenderConfig( // 𝒗
    math: RenderConfig( // \uD835\uDC97
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC97
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD33': SymbolRenderConfig( // 𝔳
    math: RenderConfig( // \uD835\uDD33
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD33
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDCF': SymbolRenderConfig( // 𝗏
    math: RenderConfig( // \uD835\uDDCF
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDCF
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE03': SymbolRenderConfig( // 𝘃
    math: RenderConfig( // \uD835\uDE03
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE03
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE37': SymbolRenderConfig( // 𝘷
    math: RenderConfig( // \uD835\uDE37
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE37
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE9F': SymbolRenderConfig( // 𝚟
    math: RenderConfig( // \uD835\uDE9F
      replaceChar: 'v', // v
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE9F
      replaceChar: 'v', // v
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC30': SymbolRenderConfig( // 𝐰
    math: RenderConfig( // \uD835\uDC30
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC30
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC64': SymbolRenderConfig( // 𝑤
    math: RenderConfig( // \uD835\uDC64
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC64
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC98': SymbolRenderConfig( // 𝒘
    math: RenderConfig( // \uD835\uDC98
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC98
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD34': SymbolRenderConfig( // 𝔴
    math: RenderConfig( // \uD835\uDD34
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD34
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD0': SymbolRenderConfig( // 𝗐
    math: RenderConfig( // \uD835\uDDD0
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD0
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE04': SymbolRenderConfig( // 𝘄
    math: RenderConfig( // \uD835\uDE04
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE04
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE38': SymbolRenderConfig( // 𝘸
    math: RenderConfig( // \uD835\uDE38
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE38
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDEA0': SymbolRenderConfig( // 𝚠
    math: RenderConfig( // \uD835\uDEA0
      replaceChar: 'w', // w
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDEA0
      replaceChar: 'w', // w
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC31': SymbolRenderConfig( // 𝐱
    math: RenderConfig( // \uD835\uDC31
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC31
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC65': SymbolRenderConfig( // 𝑥
    math: RenderConfig( // \uD835\uDC65
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC65
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC99': SymbolRenderConfig( // 𝒙
    math: RenderConfig( // \uD835\uDC99
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC99
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD35': SymbolRenderConfig( // 𝔵
    math: RenderConfig( // \uD835\uDD35
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD35
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD1': SymbolRenderConfig( // 𝗑
    math: RenderConfig( // \uD835\uDDD1
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD1
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE05': SymbolRenderConfig( // 𝘅
    math: RenderConfig( // \uD835\uDE05
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE05
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE39': SymbolRenderConfig( // 𝘹
    math: RenderConfig( // \uD835\uDE39
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE39
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDEA1': SymbolRenderConfig( // 𝚡
    math: RenderConfig( // \uD835\uDEA1
      replaceChar: 'x', // x
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDEA1
      replaceChar: 'x', // x
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC32': SymbolRenderConfig( // 𝐲
    math: RenderConfig( // \uD835\uDC32
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC32
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC66': SymbolRenderConfig( // 𝑦
    math: RenderConfig( // \uD835\uDC66
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC66
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC9A': SymbolRenderConfig( // 𝒚
    math: RenderConfig( // \uD835\uDC9A
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC9A
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD36': SymbolRenderConfig( // 𝔶
    math: RenderConfig( // \uD835\uDD36
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD36
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD2': SymbolRenderConfig( // 𝗒
    math: RenderConfig( // \uD835\uDDD2
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD2
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE06': SymbolRenderConfig( // 𝘆
    math: RenderConfig( // \uD835\uDE06
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE06
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE3A': SymbolRenderConfig( // 𝘺
    math: RenderConfig( // \uD835\uDE3A
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE3A
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDEA2': SymbolRenderConfig( // 𝚢
    math: RenderConfig( // \uD835\uDEA2
      replaceChar: 'y', // y
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDEA2
      replaceChar: 'y', // y
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC33': SymbolRenderConfig( // 𝐳
    math: RenderConfig( // \uD835\uDC33
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC33
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC67': SymbolRenderConfig( // 𝑧
    math: RenderConfig( // \uD835\uDC67
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC67
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDC9B': SymbolRenderConfig( // 𝒛
    math: RenderConfig( // \uD835\uDC9B
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDC9B
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD37': SymbolRenderConfig( // 𝔷
    math: RenderConfig( // \uD835\uDD37
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD37
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDDD3': SymbolRenderConfig( // 𝗓
    math: RenderConfig( // \uD835\uDDD3
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDDD3
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE07': SymbolRenderConfig( // 𝘇
    math: RenderConfig( // \uD835\uDE07
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE07
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDE3B': SymbolRenderConfig( // 𝘻
    math: RenderConfig( // \uD835\uDE3B
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDE3B
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDEA3': SymbolRenderConfig( // 𝚣
    math: RenderConfig( // \uD835\uDEA3
      replaceChar: 'z', // z
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDEA3
      replaceChar: 'z', // z
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDD5C': SymbolRenderConfig( // 𝕜
    math: RenderConfig( // \uD835\uDD5C
      replaceChar: 'k', // k
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDD5C
      replaceChar: 'k', // k
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFCE': SymbolRenderConfig( // 𝟎
    math: RenderConfig( // \uD835\uDFCE
      replaceChar: '0', // 0
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFCE
      replaceChar: '0', // 0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE2': SymbolRenderConfig( // 𝟢
    math: RenderConfig( // \uD835\uDFE2
      replaceChar: '0', // 0
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE2
      replaceChar: '0', // 0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFEC': SymbolRenderConfig( // 𝟬
    math: RenderConfig( // \uD835\uDFEC
      replaceChar: '0', // 0
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFEC
      replaceChar: '0', // 0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF6': SymbolRenderConfig( // 𝟶
    math: RenderConfig( // \uD835\uDFF6
      replaceChar: '0', // 0
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF6
      replaceChar: '0', // 0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFCF': SymbolRenderConfig( // 𝟏
    math: RenderConfig( // \uD835\uDFCF
      replaceChar: '1', // 1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFCF
      replaceChar: '1', // 1
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE3': SymbolRenderConfig( // 𝟣
    math: RenderConfig( // \uD835\uDFE3
      replaceChar: '1', // 1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE3
      replaceChar: '1', // 1
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFED': SymbolRenderConfig( // 𝟭
    math: RenderConfig( // \uD835\uDFED
      replaceChar: '1', // 1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFED
      replaceChar: '1', // 1
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF7': SymbolRenderConfig( // 𝟷
    math: RenderConfig( // \uD835\uDFF7
      replaceChar: '1', // 1
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF7
      replaceChar: '1', // 1
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD0': SymbolRenderConfig( // 𝟐
    math: RenderConfig( // \uD835\uDFD0
      replaceChar: '2', // 2
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD0
      replaceChar: '2', // 2
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE4': SymbolRenderConfig( // 𝟤
    math: RenderConfig( // \uD835\uDFE4
      replaceChar: '2', // 2
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE4
      replaceChar: '2', // 2
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFEE': SymbolRenderConfig( // 𝟮
    math: RenderConfig( // \uD835\uDFEE
      replaceChar: '2', // 2
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFEE
      replaceChar: '2', // 2
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF8': SymbolRenderConfig( // 𝟸
    math: RenderConfig( // \uD835\uDFF8
      replaceChar: '2', // 2
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF8
      replaceChar: '2', // 2
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD1': SymbolRenderConfig( // 𝟑
    math: RenderConfig( // \uD835\uDFD1
      replaceChar: '3', // 3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD1
      replaceChar: '3', // 3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE5': SymbolRenderConfig( // 𝟥
    math: RenderConfig( // \uD835\uDFE5
      replaceChar: '3', // 3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE5
      replaceChar: '3', // 3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFEF': SymbolRenderConfig( // 𝟯
    math: RenderConfig( // \uD835\uDFEF
      replaceChar: '3', // 3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFEF
      replaceChar: '3', // 3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF9': SymbolRenderConfig( // 𝟹
    math: RenderConfig( // \uD835\uDFF9
      replaceChar: '3', // 3
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF9
      replaceChar: '3', // 3
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD2': SymbolRenderConfig( // 𝟒
    math: RenderConfig( // \uD835\uDFD2
      replaceChar: '4', // 4
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD2
      replaceChar: '4', // 4
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE6': SymbolRenderConfig( // 𝟦
    math: RenderConfig( // \uD835\uDFE6
      replaceChar: '4', // 4
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE6
      replaceChar: '4', // 4
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF0': SymbolRenderConfig( // 𝟰
    math: RenderConfig( // \uD835\uDFF0
      replaceChar: '4', // 4
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF0
      replaceChar: '4', // 4
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFFA': SymbolRenderConfig( // 𝟺
    math: RenderConfig( // \uD835\uDFFA
      replaceChar: '4', // 4
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFFA
      replaceChar: '4', // 4
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD3': SymbolRenderConfig( // 𝟓
    math: RenderConfig( // \uD835\uDFD3
      replaceChar: '5', // 5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD3
      replaceChar: '5', // 5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE7': SymbolRenderConfig( // 𝟧
    math: RenderConfig( // \uD835\uDFE7
      replaceChar: '5', // 5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE7
      replaceChar: '5', // 5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF1': SymbolRenderConfig( // 𝟱
    math: RenderConfig( // \uD835\uDFF1
      replaceChar: '5', // 5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF1
      replaceChar: '5', // 5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFFB': SymbolRenderConfig( // 𝟻
    math: RenderConfig( // \uD835\uDFFB
      replaceChar: '5', // 5
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFFB
      replaceChar: '5', // 5
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD4': SymbolRenderConfig( // 𝟔
    math: RenderConfig( // \uD835\uDFD4
      replaceChar: '6', // 6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD4
      replaceChar: '6', // 6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE8': SymbolRenderConfig( // 𝟨
    math: RenderConfig( // \uD835\uDFE8
      replaceChar: '6', // 6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE8
      replaceChar: '6', // 6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF2': SymbolRenderConfig( // 𝟲
    math: RenderConfig( // \uD835\uDFF2
      replaceChar: '6', // 6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF2
      replaceChar: '6', // 6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFFC': SymbolRenderConfig( // 𝟼
    math: RenderConfig( // \uD835\uDFFC
      replaceChar: '6', // 6
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFFC
      replaceChar: '6', // 6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD5': SymbolRenderConfig( // 𝟕
    math: RenderConfig( // \uD835\uDFD5
      replaceChar: '7', // 7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD5
      replaceChar: '7', // 7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFE9': SymbolRenderConfig( // 𝟩
    math: RenderConfig( // \uD835\uDFE9
      replaceChar: '7', // 7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFE9
      replaceChar: '7', // 7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF3': SymbolRenderConfig( // 𝟳
    math: RenderConfig( // \uD835\uDFF3
      replaceChar: '7', // 7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF3
      replaceChar: '7', // 7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFFD': SymbolRenderConfig( // 𝟽
    math: RenderConfig( // \uD835\uDFFD
      replaceChar: '7', // 7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFFD
      replaceChar: '7', // 7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD6': SymbolRenderConfig( // 𝟖
    math: RenderConfig( // \uD835\uDFD6
      replaceChar: '8', // 8
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD6
      replaceChar: '8', // 8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFEA': SymbolRenderConfig( // 𝟪
    math: RenderConfig( // \uD835\uDFEA
      replaceChar: '8', // 8
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFEA
      replaceChar: '8', // 8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF4': SymbolRenderConfig( // 𝟴
    math: RenderConfig( // \uD835\uDFF4
      replaceChar: '8', // 8
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF4
      replaceChar: '8', // 8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFFE': SymbolRenderConfig( // 𝟾
    math: RenderConfig( // \uD835\uDFFE
      replaceChar: '8', // 8
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFFE
      replaceChar: '8', // 8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFD7': SymbolRenderConfig( // 𝟗
    math: RenderConfig( // \uD835\uDFD7
      replaceChar: '9', // 9
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFD7
      replaceChar: '9', // 9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFEB': SymbolRenderConfig( // 𝟫
    math: RenderConfig( // \uD835\uDFEB
      replaceChar: '9', // 9
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFEB
      replaceChar: '9', // 9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFF5': SymbolRenderConfig( // 𝟵
    math: RenderConfig( // \uD835\uDFF5
      replaceChar: '9', // 9
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFF5
      replaceChar: '9', // 9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\uD835\uDFFF': SymbolRenderConfig( // 𝟿
    math: RenderConfig( // \uD835\uDFFF
      replaceChar: '9', // 9
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \uD835\uDFFF
      replaceChar: '9', // 9
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00C7': SymbolRenderConfig( // Ç
    math: RenderConfig( // \u00C7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u00C7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00D0': SymbolRenderConfig( // Ð
    math: RenderConfig( // \u00D0
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u00D0
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00DE': SymbolRenderConfig( // Þ
    math: RenderConfig( // \u00DE
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u00DE
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00E7': SymbolRenderConfig( // ç
    math: RenderConfig( // \u00E7
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u00E7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00FE': SymbolRenderConfig( // þ
    math: RenderConfig( // \u00FE
      defaultFont: mathdefault,
      defaultType: AtomType.ord,
    ),
    text: RenderConfig( // \u00FE
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00A7': SymbolRenderConfig( // §
    math: null,
    text: RenderConfig( // \S, \u00A7
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00B6': SymbolRenderConfig( // ¶
    math: null,
    text: RenderConfig( // \P, \u00B6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00DF': SymbolRenderConfig( // ß
    math: null,
    text: RenderConfig( // \ss, \u00DF
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00E6': SymbolRenderConfig( // æ
    math: null,
    text: RenderConfig( // \ae, \u00E6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u0153': SymbolRenderConfig( // œ
    math: null,
    text: RenderConfig( // \oe, \u0153
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00F8': SymbolRenderConfig( // ø
    math: null,
    text: RenderConfig( // \o, \u00F8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00C6': SymbolRenderConfig( // Æ
    math: null,
    text: RenderConfig( // \AE, \u00C6
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u0152': SymbolRenderConfig( // Œ
    math: null,
    text: RenderConfig( // \OE, \u0152
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u00D8': SymbolRenderConfig( // Ø
    math: null,
    text: RenderConfig( // \O, \u00D8
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u02C6': SymbolRenderConfig( // ˆ
    math: null,
    text: RenderConfig( // \^
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u02DC': SymbolRenderConfig( // ˜
    math: null,
    text: RenderConfig( // \~
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u02DD': SymbolRenderConfig( // ˝
    math: null,
    text: RenderConfig( // \H
      defaultFont: mainrm,
      defaultType: null,
    ),
  ),
  '\u2013': SymbolRenderConfig( // –
    math: null,
    text: RenderConfig( // --, \textendash, \u2013
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2014': SymbolRenderConfig( // —
    math: null,
    text: RenderConfig( // ---, \textemdash, \u2014
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2018': SymbolRenderConfig( // ‘
    math: null,
    text: RenderConfig( // \textquoteleft, \u2018
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\'': SymbolRenderConfig( // '
    math: null,
    text: RenderConfig( // \'
      replaceChar: '\u2019', // ’
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u2019': SymbolRenderConfig( // ’
    math: null,
    text: RenderConfig( // \textquoteright, \u2019
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u201C': SymbolRenderConfig( // “
    math: null,
    text: RenderConfig( // ``, \textquotedblleft, \u201C
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  '\u201D': SymbolRenderConfig( // ”
    math: null,
    text: RenderConfig( // \'\', \textquotedblright, \u201D
      defaultFont: mainrm,
      defaultType: AtomType.ord,
    ),
  ),
  ' ': SymbolRenderConfig( //  
    math: null,
    text: RenderConfig( //  
      replaceChar: '\u00A0', //  
      defaultFont: mainrm,
      defaultType: AtomType.spacing,
    ),
  ),
};
