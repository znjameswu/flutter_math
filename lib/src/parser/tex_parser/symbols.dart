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

//ignore_for_file: prefer_single_quotes
//ignore_for_file: lines_longer_than_80_chars
import 'package:flutter/foundation.dart';
import '../../ast/syntax_tree.dart';

import 'types.dart';

enum Font { main, ams }

// const atoms = {'bin', 'close', 'inner', 'open', 'punct', 'rel'};
// const nonAtoms = {'accent-token', 'mathord', 'op-token', 'spacing', 'textord'};
// const Group = {...atoms, ...nonAtoms};
const atoms = {
  Group.bin,
  Group.rel,
  Group.open,
  Group.close,
  Group.inner,
  Group.punct,
};

const nonAtoms = {
  Group.accentToken,
  Group.mathord,
  Group.opToken,
  Group.spacing,
  Group.textord,
};

enum Group {
  bin,
  rel,
  open,
  close,
  inner,
  punct,

  accentToken,
  mathord,
  opToken,
  spacing,
  textord,
}

extension GroupExt on Group {
  AtomType get atomType =>
      const {
        Group.bin: AtomType.bin,
        Group.rel: AtomType.rel,
        Group.open: AtomType.open,
        Group.close: AtomType.close,
        Group.inner: AtomType.inner,
        Group.punct: AtomType.punct,
        Group.opToken: AtomType.op,
      }[this] ??
      AtomType.ord;
}

class CharInfo {
  final Font font;
  final Group group;
  final String replace;
  final String name;
  CharInfo({
    @required this.font,
    @required this.group,
    this.replace,
    this.name,
  });
}

Map<Mode, Map<String, CharInfo>> _symbols;

Map<Mode, Map<String, CharInfo>> get symbols {
  if (_symbols == null) {
    _symbols = {Mode.math: {}, Mode.text: {}};
    _initSymbols();
  }
  return _symbols;
}

void defineSymbol(
    Mode mode, Font font, Group group, String replace, String name,
    //ignore: avoid_positional_boolean_parameters
    [bool acceptUnicodeChar = false]) {
  _symbols[mode][name] = CharInfo(font: font, group: group, replace: replace, name: name);
  if (acceptUnicodeChar && replace != null) {
    _symbols[mode][replace] = symbols[mode][name];
  }
}

const ligatures = {
  "\u2013",
  "\u2014",
  "\u201c",
  "\u201d",
};

void _initSymbols() {
// groups:
  const accent = Group.accentToken;
  const bin = Group.bin;
  const close = Group.close;
  const inner = Group.inner;
  const mathord = Group.mathord;
  const op = Group.opToken;
  const open = Group.open;
  const punct = Group.punct;
  const rel = Group.rel;
  const spacing = Group.spacing;
  const textord = Group.textord;

// Now comes the symbol table

// Relation Symbols
  defineSymbol(Mode.math, Font.main, rel, "\u2261", "\\equiv", true);
  defineSymbol(Mode.math, Font.main, rel, "\u227a", "\\prec", true);
  defineSymbol(Mode.math, Font.main, rel, "\u227b", "\\succ", true);
  defineSymbol(Mode.math, Font.main, rel, "\u223c", "\\sim", true);
  defineSymbol(Mode.math, Font.main, rel, "\u22a5", "\\perp");
  defineSymbol(Mode.math, Font.main, rel, "\u2aaf", "\\preceq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2ab0", "\\succeq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2243", "\\simeq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2223", "\\mid", true);
  defineSymbol(Mode.math, Font.main, rel, "\u226a", "\\ll", true);
  defineSymbol(Mode.math, Font.main, rel, "\u226b", "\\gg", true);
  defineSymbol(Mode.math, Font.main, rel, "\u224d", "\\asymp", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2225", "\\parallel");
  defineSymbol(Mode.math, Font.main, rel, "\u22c8", "\\bowtie", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2323", "\\smile", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2291", "\\sqsubseteq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2292", "\\sqsupseteq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2250", "\\doteq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2322", "\\frown", true);
  defineSymbol(Mode.math, Font.main, rel, "\u220b", "\\ni", true);
  defineSymbol(Mode.math, Font.main, rel, "\u221d", "\\propto", true);
  defineSymbol(Mode.math, Font.main, rel, "\u22a2", "\\vdash", true);
  defineSymbol(Mode.math, Font.main, rel, "\u22a3", "\\dashv", true);
  defineSymbol(Mode.math, Font.main, rel, "\u220b", "\\owns");

// Punctuation
  defineSymbol(Mode.math, Font.main, punct, "\u002e", "\\ldotp");
  defineSymbol(Mode.math, Font.main, punct, "\u22c5", "\\cdotp");

// Misc Symbols
  defineSymbol(Mode.math, Font.main, textord, "\u0023", "\\#");
  defineSymbol(Mode.text, Font.main, textord, "\u0023", "\\#");
  defineSymbol(Mode.math, Font.main, textord, "\u0026", "\\&");
  defineSymbol(Mode.text, Font.main, textord, "\u0026", "\\&");
  defineSymbol(Mode.math, Font.main, textord, "\u2135", "\\aleph", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2200", "\\forall", true);
  defineSymbol(Mode.math, Font.main, textord, "\u210f", "\\hbar", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2203", "\\exists", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2207", "\\nabla", true);
  defineSymbol(Mode.math, Font.main, textord, "\u266d", "\\flat", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2113", "\\ell", true);
  defineSymbol(Mode.math, Font.main, textord, "\u266e", "\\natural", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2663", "\\clubsuit", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2118", "\\wp", true);
  defineSymbol(Mode.math, Font.main, textord, "\u266f", "\\sharp", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2662", "\\diamondsuit", true);
  defineSymbol(Mode.math, Font.main, textord, "\u211c", "\\Re", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2661", "\\heartsuit", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2111", "\\Im", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2660", "\\spadesuit", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00a7", "\\S", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00b6", "\\P", true);

// Math and Text
  defineSymbol(Mode.math, Font.main, textord, "\u2020", "\\dag");
  defineSymbol(Mode.text, Font.main, textord, "\u2020", "\\dag");
  defineSymbol(Mode.text, Font.main, textord, "\u2020", "\\textdagger");
  defineSymbol(Mode.math, Font.main, textord, "\u2021", "\\ddag");
  defineSymbol(Mode.text, Font.main, textord, "\u2021", "\\ddag");
  defineSymbol(Mode.text, Font.main, textord, "\u2021", "\\textdaggerdbl");

// Large Delimiters
  defineSymbol(Mode.math, Font.main, close, "\u23b1", "\\rmoustache", true);
  defineSymbol(Mode.math, Font.main, open, "\u23b0", "\\lmoustache", true);
  defineSymbol(Mode.math, Font.main, close, "\u27ef", "\\rgroup", true);
  defineSymbol(Mode.math, Font.main, open, "\u27ee", "\\lgroup", true);

// Binary Operators
  defineSymbol(Mode.math, Font.main, bin, "\u2213", "\\mp", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2296", "\\ominus", true);
  defineSymbol(Mode.math, Font.main, bin, "\u228e", "\\uplus", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2293", "\\sqcap", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2217", "\\ast");
  defineSymbol(Mode.math, Font.main, bin, "\u2294", "\\sqcup", true);
  defineSymbol(Mode.math, Font.main, bin, "\u25ef", "\\bigcirc");
  defineSymbol(Mode.math, Font.main, bin, "\u2219", "\\bullet");
  defineSymbol(Mode.math, Font.main, bin, "\u2021", "\\ddagger");
  defineSymbol(Mode.math, Font.main, bin, "\u2240", "\\wr", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2a3f", "\\amalg");
  defineSymbol(Mode.math, Font.main, bin, "\u0026", "\\And"); // from amsmath

// Arrow Symbols
  defineSymbol(Mode.math, Font.main, rel, "\u27f5", "\\longleftarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21d0", "\\Leftarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u27f8", "\\Longleftarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u27f6", "\\longrightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21d2", "\\Rightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u27f9", "\\Longrightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2194", "\\leftrightarrow", true);
  defineSymbol(
      Mode.math, Font.main, rel, "\u27f7", "\\longleftrightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21d4", "\\Leftrightarrow", true);
  defineSymbol(
      Mode.math, Font.main, rel, "\u27fa", "\\Longleftrightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21a6", "\\mapsto", true);
  defineSymbol(Mode.math, Font.main, rel, "\u27fc", "\\longmapsto", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2197", "\\nearrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21a9", "\\hookleftarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21aa", "\\hookrightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2198", "\\searrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21bc", "\\leftharpoonup", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21c0", "\\rightharpoonup", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2199", "\\swarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21bd", "\\leftharpoondown", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21c1", "\\rightharpoondown", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2196", "\\nwarrow", true);
  defineSymbol(
      Mode.math, Font.main, rel, "\u21cc", "\\rightleftharpoons", true);

// AMS Negated Binary Relations
  defineSymbol(Mode.math, Font.ams, rel, "\u226e", "\\nless", true);
// Symbol names preceeded by "@" each have a corresponding macro.
  defineSymbol(Mode.math, Font.ams, rel, "\ue010", "\\@nleqslant");
  defineSymbol(Mode.math, Font.ams, rel, "\ue011", "\\@nleqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u2a87", "\\lneq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2268", "\\lneqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue00c", "\\@lvertneqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u22e6", "\\lnsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a89", "\\lnapprox", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2280", "\\nprec", true);
// unicode-math maps \u22e0 to \npreccurlyeq. We'll use the AMS synonym.
  defineSymbol(Mode.math, Font.ams, rel, "\u22e0", "\\npreceq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22e8", "\\precnsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2ab9", "\\precnapprox", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2241", "\\nsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue006", "\\@nshortmid");
  defineSymbol(Mode.math, Font.ams, rel, "\u2224", "\\nmid", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22ac", "\\nvdash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22ad", "\\nvDash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22ea", "\\ntriangleleft");
  defineSymbol(Mode.math, Font.ams, rel, "\u22ec", "\\ntrianglelefteq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u228a", "\\subsetneq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue01a", "\\@varsubsetneq");
  defineSymbol(Mode.math, Font.ams, rel, "\u2acb", "\\subsetneqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue017", "\\@varsubsetneqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u226f", "\\ngtr", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue00f", "\\@ngeqslant");
  defineSymbol(Mode.math, Font.ams, rel, "\ue00e", "\\@ngeqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u2a88", "\\gneq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2269", "\\gneqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue00d", "\\@gvertneqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u22e7", "\\gnsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a8a", "\\gnapprox", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2281", "\\nsucc", true);
// unicode-math maps \u22e1 to \nsucccurlyeq. We'll use the AMS synonym.
  defineSymbol(Mode.math, Font.ams, rel, "\u22e1", "\\nsucceq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22e9", "\\succnsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2aba", "\\succnapprox", true);
// unicode-math maps \u2246 to \simneqq. We'll use the AMS synonym.
  defineSymbol(Mode.math, Font.ams, rel, "\u2246", "\\ncong", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue007", "\\@nshortparallel");
  defineSymbol(Mode.math, Font.ams, rel, "\u2226", "\\nparallel", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22af", "\\nVDash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22eb", "\\ntriangleright");
  defineSymbol(Mode.math, Font.ams, rel, "\u22ed", "\\ntrianglerighteq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue018", "\\@nsupseteqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u228b", "\\supsetneq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue01b", "\\@varsupsetneq");
  defineSymbol(Mode.math, Font.ams, rel, "\u2acc", "\\supsetneqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue019", "\\@varsupsetneqq");
  defineSymbol(Mode.math, Font.ams, rel, "\u22ae", "\\nVdash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2ab5", "\\precneqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2ab6", "\\succneqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\ue016", "\\@nsubseteqq");
  defineSymbol(Mode.math, Font.ams, bin, "\u22b4", "\\unlhd");
  defineSymbol(Mode.math, Font.ams, bin, "\u22b5", "\\unrhd");

// AMS Negated Arrows
  defineSymbol(Mode.math, Font.ams, rel, "\u219a", "\\nleftarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u219b", "\\nrightarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21cd", "\\nLeftarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21cf", "\\nRightarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21ae", "\\nleftrightarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21ce", "\\nLeftrightarrow", true);

// AMS Misc
  defineSymbol(Mode.math, Font.ams, rel, "\u25b3", "\\vartriangle");
  defineSymbol(Mode.math, Font.ams, textord, "\u210f", "\\hslash");
  defineSymbol(Mode.math, Font.ams, textord, "\u25bd", "\\triangledown");
  defineSymbol(Mode.math, Font.ams, textord, "\u25ca", "\\lozenge");
  defineSymbol(Mode.math, Font.ams, textord, "\u24c8", "\\circledS");
  defineSymbol(Mode.math, Font.ams, textord, "\u00ae", "\\circledR");
  defineSymbol(Mode.text, Font.ams, textord, "\u00ae", "\\circledR");
  defineSymbol(Mode.math, Font.ams, textord, "\u2221", "\\measuredangle", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2204", "\\nexists");
  defineSymbol(Mode.math, Font.ams, textord, "\u2127", "\\mho");
  defineSymbol(Mode.math, Font.ams, textord, "\u2132", "\\Finv", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2141", "\\Game", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2035", "\\backprime");
  defineSymbol(Mode.math, Font.ams, textord, "\u25b2", "\\blacktriangle");
  defineSymbol(Mode.math, Font.ams, textord, "\u25bc", "\\blacktriangledown");
  defineSymbol(Mode.math, Font.ams, textord, "\u25a0", "\\blacksquare");
  defineSymbol(Mode.math, Font.ams, textord, "\u29eb", "\\blacklozenge");
  defineSymbol(Mode.math, Font.ams, textord, "\u2605", "\\bigstar");
  defineSymbol(
      Mode.math, Font.ams, textord, "\u2222", "\\sphericalangle", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2201", "\\complement", true);
// unicode-math maps U+F0 to \matheth. We map to AMS function \eth
  defineSymbol(Mode.math, Font.ams, textord, "\u00f0", "\\eth", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00f0", "\u00f0");
  defineSymbol(Mode.math, Font.ams, textord, "\u2571", "\\diagup");
  defineSymbol(Mode.math, Font.ams, textord, "\u2572", "\\diagdown");
  defineSymbol(Mode.math, Font.ams, textord, "\u25a1", "\\square");
  defineSymbol(Mode.math, Font.ams, textord, "\u25a1", "\\Box");
  defineSymbol(Mode.math, Font.ams, textord, "\u25ca", "\\Diamond");
// unicode-math maps U+A5 to \mathyen. We map to AMS function \yen
  defineSymbol(Mode.math, Font.ams, textord, "\u00a5", "\\yen", true);
  defineSymbol(Mode.text, Font.ams, textord, "\u00a5", "\\yen", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2713", "\\checkmark", true);
  defineSymbol(Mode.text, Font.ams, textord, "\u2713", "\\checkmark");

// AMS Hebrew
  defineSymbol(Mode.math, Font.ams, textord, "\u2136", "\\beth", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2138", "\\daleth", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2137", "\\gimel", true);

// AMS Greek
  defineSymbol(Mode.math, Font.ams, textord, "\u03dd", "\\digamma", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u03f0", "\\varkappa");

// AMS Delimiters
  defineSymbol(Mode.math, Font.ams, open, "\u250c", "\\@ulcorner", true);
  defineSymbol(Mode.math, Font.ams, close, "\u2510", "\\@urcorner", true);
  defineSymbol(Mode.math, Font.ams, open, "\u2514", "\\@llcorner", true);
  defineSymbol(Mode.math, Font.ams, close, "\u2518", "\\@lrcorner", true);

// AMS Binary Relations
  defineSymbol(Mode.math, Font.ams, rel, "\u2266", "\\leqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a7d", "\\leqslant", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a95", "\\eqslantless", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2272", "\\lesssim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a85", "\\lessapprox", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u224a", "\\approxeq", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22d6", "\\lessdot");
  defineSymbol(Mode.math, Font.ams, rel, "\u22d8", "\\lll", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2276", "\\lessgtr", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22da", "\\lesseqgtr", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a8b", "\\lesseqqgtr", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2251", "\\doteqdot");
  defineSymbol(Mode.math, Font.ams, rel, "\u2253", "\\risingdotseq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2252", "\\fallingdotseq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u223d", "\\backsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22cd", "\\backsimeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2ac5", "\\subseteqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22d0", "\\Subset", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u228f", "\\sqsubset", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u227c", "\\preccurlyeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22de", "\\curlyeqprec", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u227e", "\\precsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2ab7", "\\precapprox", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22b2", "\\vartriangleleft");
  defineSymbol(Mode.math, Font.ams, rel, "\u22b4", "\\trianglelefteq");
  defineSymbol(Mode.math, Font.ams, rel, "\u22a8", "\\vDash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22aa", "\\Vvdash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2323", "\\smallsmile");
  defineSymbol(Mode.math, Font.ams, rel, "\u2322", "\\smallfrown");
  defineSymbol(Mode.math, Font.ams, rel, "\u224f", "\\bumpeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u224e", "\\Bumpeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2267", "\\geqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a7e", "\\geqslant", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a96", "\\eqslantgtr", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2273", "\\gtrsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a86", "\\gtrapprox", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22d7", "\\gtrdot");
  defineSymbol(Mode.math, Font.ams, rel, "\u22d9", "\\ggg", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2277", "\\gtrless", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22db", "\\gtreqless", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2a8c", "\\gtreqqless", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2256", "\\eqcirc", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2257", "\\circeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u225c", "\\triangleq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u223c", "\\thicksim");
  defineSymbol(Mode.math, Font.ams, rel, "\u2248", "\\thickapprox");
  defineSymbol(Mode.math, Font.ams, rel, "\u2ac6", "\\supseteqq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22d1", "\\Supset", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2290", "\\sqsupset", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u227d", "\\succcurlyeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22df", "\\curlyeqsucc", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u227f", "\\succsim", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2ab8", "\\succapprox", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22b3", "\\vartriangleright");
  defineSymbol(Mode.math, Font.ams, rel, "\u22b5", "\\trianglerighteq");
  defineSymbol(Mode.math, Font.ams, rel, "\u22a9", "\\Vdash", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2223", "\\shortmid");
  defineSymbol(Mode.math, Font.ams, rel, "\u2225", "\\shortparallel");
  defineSymbol(Mode.math, Font.ams, rel, "\u226c", "\\between", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22d4", "\\pitchfork", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u221d", "\\varpropto");
  defineSymbol(Mode.math, Font.ams, rel, "\u25c0", "\\blacktriangleleft");
// unicode-math says that \therefore is a mathord atom.
// We kept the amssymb atom type, which is rel.
  defineSymbol(Mode.math, Font.ams, rel, "\u2234", "\\therefore", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u220d", "\\backepsilon");
  defineSymbol(Mode.math, Font.ams, rel, "\u25b6", "\\blacktriangleright");
// unicode-math says that \because is a mathord atom.
// We kept the amssymb atom type, which is rel.
  defineSymbol(Mode.math, Font.ams, rel, "\u2235", "\\because", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22d8", "\\llless");
  defineSymbol(Mode.math, Font.ams, rel, "\u22d9", "\\gggtr");
  defineSymbol(Mode.math, Font.ams, bin, "\u22b2", "\\lhd");
  defineSymbol(Mode.math, Font.ams, bin, "\u22b3", "\\rhd");
  defineSymbol(Mode.math, Font.ams, rel, "\u2242", "\\eqsim", true);
  defineSymbol(Mode.math, Font.main, rel, "\u22c8", "\\Join");
  defineSymbol(Mode.math, Font.ams, rel, "\u2251", "\\Doteq", true);

// AMS Binary Operators
  defineSymbol(Mode.math, Font.ams, bin, "\u2214", "\\dotplus", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u2216", "\\smallsetminus");
  defineSymbol(Mode.math, Font.ams, bin, "\u22d2", "\\Cap", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22d3", "\\Cup", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u2a5e", "\\doublebarwedge", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u229f", "\\boxminus", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u229e", "\\boxplus", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22c7", "\\divideontimes", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22c9", "\\ltimes", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22ca", "\\rtimes", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22cb", "\\leftthreetimes", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22cc", "\\rightthreetimes", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22cf", "\\curlywedge", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22ce", "\\curlyvee", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u229d", "\\circleddash", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u229b", "\\circledast", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22c5", "\\centerdot");
  defineSymbol(Mode.math, Font.ams, bin, "\u22ba", "\\intercal", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22d2", "\\doublecap");
  defineSymbol(Mode.math, Font.ams, bin, "\u22d3", "\\doublecup");
  defineSymbol(Mode.math, Font.ams, bin, "\u22a0", "\\boxtimes", true);

// AMS Arrows
// Note: unicode-math maps \u21e2 to their own function \rightdasharrow.
// We'll map it to AMS function \dashrightarrow. It produces the same atom.
  defineSymbol(Mode.math, Font.ams, rel, "\u21e2", "\\dashrightarrow", true);
// unicode-math maps \u21e0 to \leftdasharrow. We'll use the AMS synonym.
  defineSymbol(Mode.math, Font.ams, rel, "\u21e0", "\\dashleftarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c7", "\\leftleftarrows", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c6", "\\leftrightarrows", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21da", "\\Lleftarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u219e", "\\twoheadleftarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21a2", "\\leftarrowtail", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21ab", "\\looparrowleft", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21cb", "\\leftrightharpoons", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21b6", "\\curvearrowleft", true);
// unicode-math maps \u21ba to \acwopencirclearrow. We'll use the AMS synonym.
  defineSymbol(Mode.math, Font.ams, rel, "\u21ba", "\\circlearrowleft", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21b0", "\\Lsh", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c8", "\\upuparrows", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21bf", "\\upharpoonleft", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c3", "\\downharpoonleft", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u22b8", "\\multimap", true);
  defineSymbol(
      Mode.math, Font.ams, rel, "\u21ad", "\\leftrightsquigarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c9", "\\rightrightarrows", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c4", "\\rightleftarrows", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21a0", "\\twoheadrightarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21a3", "\\rightarrowtail", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21ac", "\\looparrowright", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21b7", "\\curvearrowright", true);
// unicode-math maps \u21bb to \cwopencirclearrow. We'll use the AMS synonym.
  defineSymbol(Mode.math, Font.ams, rel, "\u21bb", "\\circlearrowright", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21b1", "\\Rsh", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21ca", "\\downdownarrows", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21be", "\\upharpoonright", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21c2", "\\downharpoonright", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21dd", "\\rightsquigarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21dd", "\\leadsto");
  defineSymbol(Mode.math, Font.ams, rel, "\u21db", "\\Rrightarrow", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u21be", "\\restriction");

  defineSymbol(Mode.math, Font.main, textord, "\u2018", "`");
  defineSymbol(Mode.math, Font.main, textord, "\$", "\\\$");
  defineSymbol(Mode.text, Font.main, textord, "\$", "\\\$");
  defineSymbol(Mode.text, Font.main, textord, "\$", "\\textdollar");
  defineSymbol(Mode.math, Font.main, textord, "%", "\\%");
  defineSymbol(Mode.text, Font.main, textord, "%", "\\%");
  defineSymbol(Mode.math, Font.main, textord, "_", "\\_");
  defineSymbol(Mode.text, Font.main, textord, "_", "\\_");
  defineSymbol(Mode.text, Font.main, textord, "_", "\\textunderscore");
  defineSymbol(Mode.math, Font.main, textord, "\u2220", "\\angle", true);
  defineSymbol(Mode.math, Font.main, textord, "\u221e", "\\infty", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2032", "\\prime");
  defineSymbol(Mode.math, Font.main, textord, "\u25b3", "\\triangle");
  defineSymbol(Mode.math, Font.main, textord, "\u0393", "\\Gamma", true);
  defineSymbol(Mode.math, Font.main, textord, "\u0394", "\\Delta", true);
  defineSymbol(Mode.math, Font.main, textord, "\u0398", "\\Theta", true);
  defineSymbol(Mode.math, Font.main, textord, "\u039b", "\\Lambda", true);
  defineSymbol(Mode.math, Font.main, textord, "\u039e", "\\Xi", true);
  defineSymbol(Mode.math, Font.main, textord, "\u03a0", "\\Pi", true);
  defineSymbol(Mode.math, Font.main, textord, "\u03a3", "\\Sigma", true);
  defineSymbol(Mode.math, Font.main, textord, "\u03a5", "\\Upsilon", true);
  defineSymbol(Mode.math, Font.main, textord, "\u03a6", "\\Phi", true);
  defineSymbol(Mode.math, Font.main, textord, "\u03a8", "\\Psi", true);
  defineSymbol(Mode.math, Font.main, textord, "\u03a9", "\\Omega", true);
  defineSymbol(Mode.math, Font.main, textord, "A", "\u0391");
  defineSymbol(Mode.math, Font.main, textord, "B", "\u0392");
  defineSymbol(Mode.math, Font.main, textord, "E", "\u0395");
  defineSymbol(Mode.math, Font.main, textord, "Z", "\u0396");
  defineSymbol(Mode.math, Font.main, textord, "H", "\u0397");
  defineSymbol(Mode.math, Font.main, textord, "I", "\u0399");
  defineSymbol(Mode.math, Font.main, textord, "K", "\u039A");
  defineSymbol(Mode.math, Font.main, textord, "M", "\u039C");
  defineSymbol(Mode.math, Font.main, textord, "N", "\u039D");
  defineSymbol(Mode.math, Font.main, textord, "O", "\u039F");
  defineSymbol(Mode.math, Font.main, textord, "P", "\u03A1");
  defineSymbol(Mode.math, Font.main, textord, "T", "\u03A4");
  defineSymbol(Mode.math, Font.main, textord, "X", "\u03A7");
  defineSymbol(Mode.math, Font.main, textord, "\u00ac", "\\neg", true);
  defineSymbol(Mode.math, Font.main, textord, "\u00ac", "\\lnot");
  defineSymbol(Mode.math, Font.main, textord, "\u22a4", "\\top");
  defineSymbol(Mode.math, Font.main, textord, "\u22a5", "\\bot");
  defineSymbol(Mode.math, Font.main, textord, "\u2205", "\\emptyset");
  defineSymbol(Mode.math, Font.ams, textord, "\u2205", "\\varnothing");
  defineSymbol(Mode.math, Font.main, mathord, "\u03b1", "\\alpha", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b2", "\\beta", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b3", "\\gamma", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b4", "\\delta", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03f5", "\\epsilon", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b6", "\\zeta", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b7", "\\eta", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b8", "\\theta", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b9", "\\iota", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03ba", "\\kappa", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03bb", "\\lambda", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03bc", "\\mu", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03bd", "\\nu", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03be", "\\xi", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03bf", "\\omicron", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c0", "\\pi", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c1", "\\rho", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c3", "\\sigma", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c4", "\\tau", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c5", "\\upsilon", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03d5", "\\phi", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c7", "\\chi", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c8", "\\psi", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c9", "\\omega", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03b5", "\\varepsilon", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03d1", "\\vartheta", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03d6", "\\varpi", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03f1", "\\varrho", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c2", "\\varsigma", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u03c6", "\\varphi", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2217", "*");
  defineSymbol(Mode.math, Font.main, bin, "+", "+");
  defineSymbol(Mode.math, Font.main, bin, "\u2212", "-");
  defineSymbol(Mode.math, Font.main, bin, "\u22c5", "\\cdot", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2218", "\\circ");
  defineSymbol(Mode.math, Font.main, bin, "\u00f7", "\\div", true);
  defineSymbol(Mode.math, Font.main, bin, "\u00b1", "\\pm", true);
  defineSymbol(Mode.math, Font.main, bin, "\u00d7", "\\times", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2229", "\\cap", true);
  defineSymbol(Mode.math, Font.main, bin, "\u222a", "\\cup", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2216", "\\setminus");
  defineSymbol(Mode.math, Font.main, bin, "\u2227", "\\land");
  defineSymbol(Mode.math, Font.main, bin, "\u2228", "\\lor");
  defineSymbol(Mode.math, Font.main, bin, "\u2227", "\\wedge", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2228", "\\vee", true);
  defineSymbol(Mode.math, Font.main, textord, "\u221a", "\\surd");
  defineSymbol(Mode.math, Font.main, open, "\u27e8", "\\langle", true);
  defineSymbol(Mode.math, Font.main, open, "\u2223", "\\lvert");
  defineSymbol(Mode.math, Font.main, open, "\u2225", "\\lVert");
  defineSymbol(Mode.math, Font.main, close, "?", "?");
  defineSymbol(Mode.math, Font.main, close, "!", "!");
  defineSymbol(Mode.math, Font.main, close, "\u27e9", "\\rangle", true);
  defineSymbol(Mode.math, Font.main, close, "\u2223", "\\rvert");
  defineSymbol(Mode.math, Font.main, close, "\u2225", "\\rVert");
  defineSymbol(Mode.math, Font.main, rel, "=", "=");
  defineSymbol(Mode.math, Font.main, rel, ":", ":");
  defineSymbol(Mode.math, Font.main, rel, "\u2248", "\\approx", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2245", "\\cong", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2265", "\\ge");
  defineSymbol(Mode.math, Font.main, rel, "\u2265", "\\geq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2190", "\\gets");
  defineSymbol(Mode.math, Font.main, rel, ">", "\\gt", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2208", "\\in", true);
  defineSymbol(Mode.math, Font.main, rel, "\ue020", "\\@not");
  defineSymbol(Mode.math, Font.main, rel, "\u2282", "\\subset", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2283", "\\supset", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2286", "\\subseteq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2287", "\\supseteq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2288", "\\nsubseteq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2289", "\\nsupseteq", true);
  defineSymbol(Mode.math, Font.main, rel, "\u22a8", "\\models");
  defineSymbol(Mode.math, Font.main, rel, "\u2190", "\\leftarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2264", "\\le");
  defineSymbol(Mode.math, Font.main, rel, "\u2264", "\\leq", true);
  defineSymbol(Mode.math, Font.main, rel, "<", "\\lt", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2192", "\\rightarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2192", "\\to");
  defineSymbol(Mode.math, Font.ams, rel, "\u2271", "\\ngeq", true);
  defineSymbol(Mode.math, Font.ams, rel, "\u2270", "\\nleq", true);
  defineSymbol(Mode.math, Font.main, spacing, "\u00a0", "\\ ");
  defineSymbol(Mode.math, Font.main, spacing, "\u00a0", "~");
  defineSymbol(Mode.math, Font.main, spacing, "\u00a0", "\\space");
// Ref: LaTeX Source 2e: \DeclareRobustCommand{\nobreakspace}{%
  defineSymbol(Mode.math, Font.main, spacing, "\u00a0", "\\nobreakspace");
  defineSymbol(Mode.text, Font.main, spacing, "\u00a0", "\\ ");
  defineSymbol(Mode.text, Font.main, spacing, "\u00a0", " ");
  defineSymbol(Mode.text, Font.main, spacing, "\u00a0", "~");
  defineSymbol(Mode.text, Font.main, spacing, "\u00a0", "\\space");
  defineSymbol(Mode.text, Font.main, spacing, "\u00a0", "\\nobreakspace");
  defineSymbol(Mode.math, Font.main, spacing, null, "\\nobreak");
  defineSymbol(Mode.math, Font.main, spacing, null, "\\allowbreak");
  defineSymbol(Mode.math, Font.main, punct, ",", ",");
  defineSymbol(Mode.math, Font.main, punct, ";", ";");
  defineSymbol(Mode.math, Font.ams, bin, "\u22bc", "\\barwedge", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22bb", "\\veebar", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2299", "\\odot", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2295", "\\oplus", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2297", "\\otimes", true);
  defineSymbol(Mode.math, Font.main, textord, "\u2202", "\\partial", true);
  defineSymbol(Mode.math, Font.main, bin, "\u2298", "\\oslash", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u229a", "\\circledcirc", true);
  defineSymbol(Mode.math, Font.ams, bin, "\u22a1", "\\boxdot", true);
  defineSymbol(Mode.math, Font.main, bin, "\u25b3", "\\bigtriangleup");
  defineSymbol(Mode.math, Font.main, bin, "\u25bd", "\\bigtriangledown");
  defineSymbol(Mode.math, Font.main, bin, "\u2020", "\\dagger");
  defineSymbol(Mode.math, Font.main, bin, "\u22c4", "\\diamond");
  defineSymbol(Mode.math, Font.main, bin, "\u22c6", "\\star");
  defineSymbol(Mode.math, Font.main, bin, "\u25c3", "\\triangleleft");
  defineSymbol(Mode.math, Font.main, bin, "\u25b9", "\\triangleright");
  defineSymbol(Mode.math, Font.main, open, "{", "\\{");
  defineSymbol(Mode.text, Font.main, textord, "{", "\\{");
  defineSymbol(Mode.text, Font.main, textord, "{", "\\textbraceleft");
  defineSymbol(Mode.math, Font.main, close, "}", "\\}");
  defineSymbol(Mode.text, Font.main, textord, "}", "\\}");
  defineSymbol(Mode.text, Font.main, textord, "}", "\\textbraceright");
  defineSymbol(Mode.math, Font.main, open, "{", "\\lbrace");
  defineSymbol(Mode.math, Font.main, close, "}", "\\rbrace");
  defineSymbol(Mode.math, Font.main, open, "[", "\\lbrack", true);
  defineSymbol(Mode.text, Font.main, textord, "[", "\\lbrack", true);
  defineSymbol(Mode.math, Font.main, close, "]", "\\rbrack", true);
  defineSymbol(Mode.text, Font.main, textord, "]", "\\rbrack", true);
  defineSymbol(Mode.math, Font.main, open, "(", "\\lparen", true);
  defineSymbol(Mode.math, Font.main, close, ")", "\\rparen", true);
  defineSymbol(
      Mode.text, Font.main, textord, "<", "\\textless", true); // in T1 fontenc
  defineSymbol(Mode.text, Font.main, textord, ">", "\\textgreater",
      true); // in T1 fontenc
  defineSymbol(Mode.math, Font.main, open, "\u230a", "\\lfloor", true);
  defineSymbol(Mode.math, Font.main, close, "\u230b", "\\rfloor", true);
  defineSymbol(Mode.math, Font.main, open, "\u2308", "\\lceil", true);
  defineSymbol(Mode.math, Font.main, close, "\u2309", "\\rceil", true);
  defineSymbol(Mode.math, Font.main, textord, "\\", "\\backslash");
  defineSymbol(Mode.math, Font.main, textord, "\u2223", "|");
  defineSymbol(Mode.math, Font.main, textord, "\u2223", "\\vert");
  defineSymbol(
      Mode.text, Font.main, textord, "|", "\\textbar", true); // in T1 fontenc
  defineSymbol(Mode.math, Font.main, textord, "\u2225", "\\|");
  defineSymbol(Mode.math, Font.main, textord, "\u2225", "\\Vert");
  defineSymbol(Mode.text, Font.main, textord, "\u2225", "\\textbardbl");
  defineSymbol(Mode.text, Font.main, textord, "~", "\\textasciitilde");
  defineSymbol(Mode.text, Font.main, textord, "\\", "\\textbackslash");
  defineSymbol(Mode.text, Font.main, textord, "^", "\\textasciicircum");
  defineSymbol(Mode.math, Font.main, rel, "\u2191", "\\uparrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21d1", "\\Uparrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2193", "\\downarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21d3", "\\Downarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u2195", "\\updownarrow", true);
  defineSymbol(Mode.math, Font.main, rel, "\u21d5", "\\Updownarrow", true);
  defineSymbol(Mode.math, Font.main, op, "\u2210", "\\coprod");
  defineSymbol(Mode.math, Font.main, op, "\u22c1", "\\bigvee");
  defineSymbol(Mode.math, Font.main, op, "\u22c0", "\\bigwedge");
  defineSymbol(Mode.math, Font.main, op, "\u2a04", "\\biguplus");
  defineSymbol(Mode.math, Font.main, op, "\u22c2", "\\bigcap");
  defineSymbol(Mode.math, Font.main, op, "\u22c3", "\\bigcup");
  defineSymbol(Mode.math, Font.main, op, "\u222b", "\\int");
  defineSymbol(Mode.math, Font.main, op, "\u222b", "\\intop");
  defineSymbol(Mode.math, Font.main, op, "\u222c", "\\iint");
  defineSymbol(Mode.math, Font.main, op, "\u222d", "\\iiint");
  defineSymbol(Mode.math, Font.main, op, "\u220f", "\\prod");
  defineSymbol(Mode.math, Font.main, op, "\u2211", "\\sum");
  defineSymbol(Mode.math, Font.main, op, "\u2a02", "\\bigotimes");
  defineSymbol(Mode.math, Font.main, op, "\u2a01", "\\bigoplus");
  defineSymbol(Mode.math, Font.main, op, "\u2a00", "\\bigodot");
  defineSymbol(Mode.math, Font.main, op, "\u222e", "\\oint");
  defineSymbol(Mode.math, Font.main, op, "\u2a06", "\\bigsqcup");
  defineSymbol(Mode.math, Font.main, op, "\u222b", "\\smallint");
  defineSymbol(Mode.text, Font.main, inner, "\u2026", "\\textellipsis");
  defineSymbol(Mode.math, Font.main, inner, "\u2026", "\\mathellipsis");
  defineSymbol(Mode.text, Font.main, inner, "\u2026", "\\ldots", true);
  defineSymbol(Mode.math, Font.main, inner, "\u2026", "\\ldots", true);
  defineSymbol(Mode.math, Font.main, inner, "\u22ef", "\\@cdots", true);
  defineSymbol(Mode.math, Font.main, inner, "\u22f1", "\\ddots", true);
  defineSymbol(Mode.math, Font.main, textord, "\u22ee",
      "\\varvdots"); // \vdots is a macro
  defineSymbol(Mode.math, Font.main, accent, "\u02ca", "\\acute");
  defineSymbol(Mode.math, Font.main, accent, "\u02cb", "\\grave");
  defineSymbol(Mode.math, Font.main, accent, "\u00a8", "\\ddot");
  defineSymbol(Mode.math, Font.main, accent, "\u007e", "\\tilde");
  defineSymbol(Mode.math, Font.main, accent, "\u02c9", "\\bar");
  defineSymbol(Mode.math, Font.main, accent, "\u02d8", "\\breve");
  defineSymbol(Mode.math, Font.main, accent, "\u02c7", "\\check");
  defineSymbol(Mode.math, Font.main, accent, "\u005e", "\\hat");
  defineSymbol(Mode.math, Font.main, accent, "\u20d7", "\\vec");
  defineSymbol(Mode.math, Font.main, accent, "\u02d9", "\\dot");
  defineSymbol(Mode.math, Font.main, accent, "\u02da", "\\mathring");
  defineSymbol(Mode.math, Font.main, mathord, "\u0131", "\\imath", true);
  defineSymbol(Mode.math, Font.main, mathord, "\u0237", "\\jmath", true);
  defineSymbol(Mode.text, Font.main, textord, "\u0131", "\\i", true);
  defineSymbol(Mode.text, Font.main, textord, "\u0237", "\\j", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00df", "\\ss", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00e6", "\\ae", true);
  defineSymbol(Mode.text, Font.main, textord, "\u0153", "\\oe", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00f8", "\\o", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00c6", "\\AE", true);
  defineSymbol(Mode.text, Font.main, textord, "\u0152", "\\OE", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00d8", "\\O", true);
  defineSymbol(Mode.text, Font.main, accent, "\u02ca", "\\'"); // acute
  defineSymbol(Mode.text, Font.main, accent, "\u02cb", "\\`"); // grave
  defineSymbol(Mode.text, Font.main, accent, "\u02c6", "\\^"); // circumflex
  defineSymbol(Mode.text, Font.main, accent, "\u02dc", "\\~"); // tilde
  defineSymbol(Mode.text, Font.main, accent, "\u02c9", "\\="); // macron
  defineSymbol(Mode.text, Font.main, accent, "\u02d8", "\\u"); // breve
  defineSymbol(Mode.text, Font.main, accent, "\u02d9", "\\."); // dot above
  defineSymbol(Mode.text, Font.main, accent, "\u02da", "\\r"); // ring above
  defineSymbol(Mode.text, Font.main, accent, "\u02c7", "\\v"); // caron
  defineSymbol(Mode.text, Font.main, accent, "\u00a8", '\\"'); // diaresis
  defineSymbol(Mode.text, Font.main, accent, "\u02dd", "\\H"); // double acute
  defineSymbol(Mode.text, Font.main, accent, "\u25ef",
      "\\textcircled"); // \bigcirc glyph

  defineSymbol(Mode.text, Font.main, textord, "\u2013", "--", true);
  defineSymbol(Mode.text, Font.main, textord, "\u2013", "\\textendash");
  defineSymbol(Mode.text, Font.main, textord, "\u2014", "---", true);
  defineSymbol(Mode.text, Font.main, textord, "\u2014", "\\textemdash");
  defineSymbol(Mode.text, Font.main, textord, "\u2018", "`", true);
  defineSymbol(Mode.text, Font.main, textord, "\u2018", "\\textquoteleft");
  defineSymbol(Mode.text, Font.main, textord, "\u2019", "'", true);
  defineSymbol(Mode.text, Font.main, textord, "\u2019", "\\textquoteright");
  defineSymbol(Mode.text, Font.main, textord, "\u201c", "``", true);
  defineSymbol(Mode.text, Font.main, textord, "\u201c", "\\textquotedblleft");
  defineSymbol(Mode.text, Font.main, textord, "\u201d", "''", true);
  defineSymbol(Mode.text, Font.main, textord, "\u201d", "\\textquotedblright");
//  \degree from gensymb package
  defineSymbol(Mode.math, Font.main, textord, "\u00b0", "\\degree", true);
  defineSymbol(Mode.text, Font.main, textord, "\u00b0", "\\degree");
// \textdegree from inputenc package
  defineSymbol(Mode.text, Font.main, textord, "\u00b0", "\\textdegree", true);
// TODO: In LaTeX, \pounds can generate a different character in text and math
// mode, but among our fonts, only Main-Italic defines this character "163".
  defineSymbol(Mode.math, Font.main, mathord, "\u00a3", "\\pounds");
  defineSymbol(Mode.math, Font.main, mathord, "\u00a3", "\\mathsterling", true);
  defineSymbol(Mode.text, Font.main, mathord, "\u00a3", "\\pounds");
  defineSymbol(Mode.text, Font.main, mathord, "\u00a3", "\\textsterling", true);
  defineSymbol(Mode.math, Font.ams, textord, "\u2720", "\\maltese");
  defineSymbol(Mode.text, Font.ams, textord, "\u2720", "\\maltese");

// There are lots of symbols which are the same, so we add them in afterwards.
// All of these are textords in math mode
  const mathTextSymbols = "0123456789/@.\"";
  for (var i = 0; i < mathTextSymbols.length; i++) {
    final ch = mathTextSymbols[i];
    defineSymbol(Mode.math, Font.main, textord, ch, ch);
  }

// All of these are textords in text mode
  const textSymbols = "0123456789!@*()-=+\";:?/.,";
  for (var i = 0; i < textSymbols.length; i++) {
    final ch = textSymbols[i];
    defineSymbol(Mode.text, Font.main, textord, ch, ch);
  }

// All of these are textords in text mode, and mathords in math mode
  const letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  for (var i = 0; i < letters.length; i++) {
    final ch = letters[i];
    defineSymbol(Mode.math, Font.main, mathord, ch, ch);
    defineSymbol(Mode.text, Font.main, textord, ch, ch);
  }

// Blackboard bold and script letters in Unicode range
  defineSymbol(Mode.math, Font.ams, textord, "C", "\u2102"); // blackboard bold
  defineSymbol(Mode.text, Font.ams, textord, "C", "\u2102");
  defineSymbol(Mode.math, Font.ams, textord, "H", "\u210D");
  defineSymbol(Mode.text, Font.ams, textord, "H", "\u210D");
  defineSymbol(Mode.math, Font.ams, textord, "N", "\u2115");
  defineSymbol(Mode.text, Font.ams, textord, "N", "\u2115");
  defineSymbol(Mode.math, Font.ams, textord, "P", "\u2119");
  defineSymbol(Mode.text, Font.ams, textord, "P", "\u2119");
  defineSymbol(Mode.math, Font.ams, textord, "Q", "\u211A");
  defineSymbol(Mode.text, Font.ams, textord, "Q", "\u211A");
  defineSymbol(Mode.math, Font.ams, textord, "R", "\u211D");
  defineSymbol(Mode.text, Font.ams, textord, "R", "\u211D");
  defineSymbol(Mode.math, Font.ams, textord, "Z", "\u2124");
  defineSymbol(Mode.text, Font.ams, textord, "Z", "\u2124");
  defineSymbol(Mode.math, Font.main, mathord, "h",
      "\u210E"); // italic h, Planck constant
  defineSymbol(Mode.text, Font.main, mathord, "h", "\u210E");

// The next loop loads wide (surrogate pair) characters.
// We support some letters in the Unicode range U+1D400 to U+1D7FF,
// Mathematical Alphanumeric Symbols.
// Some editors do not deal well with wide characters. So don't write the
// string into this file. Instead, create the string from the surrogate pair.
  String wideChar = "";
  for (var i = 0; i < letters.length; i++) {
    final ch = letters[i];

    // The hex numbers in the next line are a surrogate pair.
    // 0xD835 is the high surrogate for all letters in the range we support.
    // 0xDC00 is the low surrogate for bold A.
    wideChar = String.fromCharCodes([0xD835, 0xDC00 + i]); // A-Z a-z bold
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDC34 + i]); // A-Z a-z italic
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar =
        String.fromCharCodes([0xD835, 0xDC68 + i]); // A-Z a-z bold italic
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDD04 + i]); // A-Z a-z Fractur
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDDA0 + i]); // A-Z a-z sans-serif
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDDD4 + i]); // A-Z a-z sans bold
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar =
        String.fromCharCodes([0xD835, 0xDE08 + i]); // A-Z a-z sans italic
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDE70 + i]); // A-Z a-z monospace
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    if (i < 26) {
      // KaTeX fonts have only capital letters for blackboard bold and script.
      // See exception for k below.
      wideChar =
          String.fromCharCodes([0xD835, 0xDD38 + i]); // A-Z double struck
      defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
      defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

      wideChar = String.fromCharCodes([0xD835, 0xDC9C + i]); // A-Z script
      defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
      defineSymbol(Mode.text, Font.main, textord, ch, wideChar);
    }

    // TODO: Add bold script when it is supported by a KaTeX font.
  }
// "k" is the only double struck lower case letter in the KaTeX fonts.
  wideChar = String.fromCharCodes([0xD835, 0xDD5C]); // k double struck
  defineSymbol(Mode.math, Font.main, mathord, "k", wideChar);
  defineSymbol(Mode.text, Font.main, textord, "k", wideChar);

// Next, some wide character numerals
  for (var i = 0; i < 10; i++) {
    final ch = i.toString();

    wideChar = String.fromCharCodes([0xD835, 0xDFCE + i]); // 0-9 bold
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDFE2 + i]); // 0-9 sans serif
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDFEC + i]); // 0-9 bold sans
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);

    wideChar = String.fromCharCodes([0xD835, 0xDFF6 + i]); // 0-9 monospace
    defineSymbol(Mode.math, Font.main, mathord, ch, wideChar);
    defineSymbol(Mode.text, Font.main, textord, ch, wideChar);
  }
// const extraLatin = {'Ç', 'Ð', 'Þ', 'ç', 'þ'};
// final a = '\u00c7';
  const extraLatin = "\u00c7\u00d0\u00de\u00e7\u00fe";
  for (var i = 0; i < extraLatin.length; i++) {
    final ch = extraLatin[i];
    defineSymbol(Mode.math, Font.main, mathord, ch, ch);
    defineSymbol(Mode.text, Font.main, textord, ch, ch);
  }
}

const extraLatin = {'Ç', 'Ð', 'Þ', 'ç', 'þ'};
