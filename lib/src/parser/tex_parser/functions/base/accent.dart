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

part of latex_base;

const _accentEntries = {
  [
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
    '\\overgroup',
    '\\overlinesegment',
    '\\overleftharpoon',
    '\\overrightharpoon',
  ]: FunctionSpec(
    numArgs: 1,
    handler: _accentHandler,
  ),
  [
    "\\'",
    '\\`',
    '\\^',
    '\\~',
    '\\=',
    '\\u',
    '\\.',
    '\\"',
    '\\r',
    '\\H',
    '\\v',
    '\\textcircled',
  ]: FunctionSpec(
    numArgs: 1,
    allowedInMath: false,
    allowedInText: true,
    handler: _textAccentHandler,
  ),
};

const _nonStrctchyAccents = {
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
};

const _shiftyAccents = {
  '\\widehat',
  '\\widetilde',
  '\\widecheck',
};
GreenNode _accentHandler(TexParser parser, FunctionContext context) {
  final base = parser.parseArgNode(mode: Mode.math, optional: false);

  final isStretchy = !_nonStrctchyAccents.contains(context.funcName);
  final isShifty = !isStretchy || _shiftyAccents.contains(context.funcName);

  return AccentNode(
    base: base.wrapWithEquationRow(),
    label: context.funcName,
    isStretchy: isStretchy,
    isShifty: isShifty,
  );
}

GreenNode _textAccentHandler(TexParser parser, FunctionContext context) {
  final base = parser.parseArgNode(mode: null, optional: false);
  return AccentNode(
    base: base.wrapWithEquationRow(),
    label: context.funcName,
    isStretchy: false,
    isShifty: true,
  );
}
