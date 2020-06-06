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

/// Converted from KaTeX/src/katex.less

import 'dart:ui';

import '../../ast/options.dart';

Map<String, FontOptions> _fontOptionsTable;
Map<String, FontOptions> get fontOptionsTable {
  if (_fontOptionsTable != null) return _fontOptionsTable;
  _fontOptionsTable = {};
  _fontOptionsEntries.forEach((key, value) {
    for (final name in key) {
      _fontOptionsTable[name] = value;
    }
  });
  return _fontOptionsTable;
}

const _fontOptionsEntries = {
  // Text font weights.
  ['textbf']: FontOptions(
    fontWeight: FontWeight.bold,
  ),

  // Text font shapes.
  ['textit']: FontOptions(
    fontShape: FontStyle.italic,
  ),

  // Text font families.
  ['textrm']: FontOptions(fontFamily: 'KaTeX_Main'),

  ['textsf']: FontOptions(fontFamily: 'KaTeX_SansSerif'),

  ['texttt']: FontOptions(fontFamily: 'KaTeX_Typewriter'),

  // Math fonts.
  ['mathdefault']: FontOptions(
    fontFamily: 'KaTeX_Math',
    fontShape: FontStyle.italic,
  ),

  ['mathit']: FontOptions(
    fontFamily: 'KaTeX_Main',
    fontShape: FontStyle.italic,
  ),

  ['mathrm']: FontOptions(
    fontShape: FontStyle.normal,
  ),

  ['mathbf']: FontOptions(
    fontFamily: 'KaTeX_Main',
    fontWeight: FontWeight.bold,
  ),

  ['boldsymbol']: FontOptions(
    fontFamily: 'KaTeX_Math',
    fontWeight: FontWeight.bold,
    fontShape: FontStyle.italic,
  ),

  ['amsrm']: FontOptions(fontFamily: 'KaTeX_AMS'),

  ['mathbb', 'textbb']: FontOptions(fontFamily: 'KaTeX_AMS'),

  ['mathcal']: FontOptions(fontFamily: 'KaTeX_Caligraphic'),

  ['mathfrak', 'textfrak']: FontOptions(fontFamily: 'KaTeX_Fraktur'),

  ['mathtt']: FontOptions(fontFamily: 'KaTeX_Typewriter'),

  ['mathscr', 'textscr']: FontOptions(fontFamily: 'KaTeX_Script'),

  ['mathsf', 'textsf']: FontOptions(fontFamily: 'KaTeX_SansSerif'),

  ['mathboldsf', 'textboldsf']: FontOptions(
    fontFamily: 'KaTeX_SansSerif',
    fontWeight: FontWeight.bold,
  ),

  ['mathitsf', 'textitsf']: FontOptions(
    fontFamily: 'KaTeX_SansSerif',
    fontShape: FontStyle.italic,
  ),

  ['mainrm']: FontOptions(
    fontFamily: 'KaTeX_Main',
    fontShape: FontStyle.normal,
  ),
};

const fontFamilyFallback = ['KaTeX_Main', 'Times New Roman', 'serif'];
