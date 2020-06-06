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

import 'dart:developer';

import 'macros.dart';
import 'parse_error.dart';
import 'token.dart';

enum Strict { ignore, warn, error, function }

class Settings {
  final bool displayMode;
  final bool throwOnError;
  final Map<String, MacroDefinition> macros;
  final int maxExpand;
  final Strict strict;
  final Strict Function(String, String, Token) strictFun;
  final bool globalGroup;
  final bool colorIsTextColor;
  const Settings({
    this.displayMode = false,
    this.throwOnError = true,
    this.macros = const {},
    this.maxExpand = 1000,
    this.strict = Strict.warn,
    this.strictFun,
    this.globalGroup = false,
    this.colorIsTextColor = false,
  })
  //: assert(strict != Strict.function || strictFun != null)
  ;

  void reportNonstrict(String errorCode, String errorMsg, [Token token]) {
    var strict = this.strict;
    if (this.strictFun != null) {
      strict = this.strictFun(errorCode, errorMsg, token);
    }
    switch (strict) {
      case Strict.ignore:
        return;
      case Strict.error:
        throw ParseError(
            "LaTeX-incompatible input and strict mode is set to 'error': "
            '$errorMsg [$errorCode]',
            token);
      case Strict.warn:
        log("LaTeX-incompatible input and strict mode is set to 'warn': "
            '$errorMsg [$errorCode]');
        break;
      case Strict.function:
        log("Illegal return value 'function' from strictFun on case: "
            '$errorMsg [$errorCode]');
    }
  }

  bool useStrictBehavior(String errorCode, String errorMsg, [Token token]) {
    var strict = this.strict;
    switch (strict) {
      case Strict.function:
        try {
          strict = strictFun(errorCode, errorMsg, token);
        } catch (e) {
          strict = Strict.error;
        }
        continue fallThrough;
      fallThrough:
      case Strict.ignore:
        return false;
      case Strict.error:
        return true;
      case Strict.warn:
        log("LaTeX-incompatible input and strict mode is set to 'warn': "
            '$errorMsg [$errorCode]');
        return false;
    }
  }
}
