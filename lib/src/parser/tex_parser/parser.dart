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

import 'dart:collection';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../../ast/nodes/accent.dart';
import '../../ast/nodes/math_atom.dart';
import '../../ast/nodes/multiscripts.dart';
import '../../ast/nodes/text.dart';
import '../../ast/options.dart';
import '../../ast/size.dart';
import '../../ast/syntax_tree.dart';
import '../../font/metrics/unicode_scripts.dart';
import 'colors.dart';
import 'functions.dart';
import 'lexer.dart';
import 'macro_expander.dart';
import 'macros.dart';
import 'parse_error.dart';
import 'settings.dart';
import 'symbols.dart';
import 'token.dart';
import 'types.dart';
import 'unicode_accents.dart';
import 'unicode_symbols.dart';

class TexParser {
  TexParser(this.content, this.settings)
      : this.leftrightDepth = 0,
        this.mode = Mode.math,
        this.macroExpander = MacroExpander(content, settings, Mode.math);

  String content;
  Settings settings;
  Mode mode;
  int leftrightDepth;

  final MacroExpander macroExpander;
  Token nextToken;

  EquationRowNode parse() {
    if (!this.settings.globalGroup) {
      this.macroExpander.beginGroup();
    }
    if (this.settings.colorIsTextColor) {
      this
          .macroExpander
          .macros
          .set('\\color', MacroDefinition.fromString('\\textcolor'));
    }
    final parse = this.parseExpression(breakOnInfix: false);

    this.expect('EOF');

    if (!this.settings.globalGroup) {
      this.macroExpander.endGroup();
    }
    return parse.wrapWithEquationRow();
  }

  List<GreenNode> parseExpression({
    bool breakOnInfix = false,
    String breakOnTokenText,
    bool infixArgumentMode = false,
  }) {
    final body = <GreenNode>[];
    // TODO : is this typecheck necessary?
    // if (!breakTokens.contains(breakOnTokenText)) {
    //   breakOnTokenText = null;
    // }
    while (true) {
      if (this.mode == Mode.math) {
        this.consumeSpaces();
      }
      final lex = this.fetch();
      if (endOfExpression.contains(lex.text)) {
        break;
      }
      if (breakOnTokenText != null && lex.text == breakOnTokenText) {
        break;
      }
      // Detects a infix function
      if (functions.containsKey(lex.text) &&
          functions[lex.text].infix != false) {
        if (infixArgumentMode) {
          throw ParseError('only one infix operator per group', lex);
        }
        if (breakOnInfix) {
          break;
        }
        _enterArgumentParsingMode(lex.text, functions[lex.text]);
        try {
          // A new way to handle infix operations
          final atom = functions[lex.text].handler(
            this,
            FunctionContext(
              funcName: lex.text,
              breakOnTokenText: breakOnTokenText,
              token: lex,
              infixExistingArguments: body,
            ),
          );
          body.clear();
          body.add(atom);
        } finally {
          _leaveArgumentParsingMode(lex.text);
        }
      } else {
        // Add a normal atom
        final atom = this._parseAtom(breakOnTokenText).expandEquationRow();
        if (atom == null) {
          break;
        }
        body.addAll(atom);
      }
    }

    return body;
    // We will NOT handle ligatures between '-' and "'", as neither did MathJax.
    // if (this.mode == Mode.text) {
    //   formLigatures(body);
    // }
    // We will not handle infix as well
    // return handleInfixNodes(body);
  }

  static const Set<String> breakTokens = {
    ']',
    '}',
    '\\endgroup',
    '\$',
    '\\)',
    '\\cr',
  };
  static const Set<String> endOfExpression = {
    '}',
    '\\endgroup',
    '\\end',
    '\\right',
    '&',
  };

  static const Map<String, String> endOfGroup = {
    '[': ']',
    '{': '}',
    '\\begingroup': '\\endgroup',
  };

  void expect(String text, {bool consume = true}) {
    if (this.fetch().text != text) {
      throw ParseError(
          'Expected \'$text\', got \'${this.fetch().text}\'', this.fetch());
    }
    if (consume) {
      this.consume();
    }
  }

  void consumeSpaces() {
    while (this.fetch().text == ' ') {
      this.consume();
    }
  }

  GreenNode _parseAtom(String breakOnTokenText) {
    final base = this.parseGroup('atom',
        optional: false, greediness: null, breakOnTokenText: breakOnTokenText);

    if (this.mode == Mode.text) {
      return base;
    }

    final scriptsResult = parseScripts(allowLimits: false);

    if (!scriptsResult.empty) {
      return MultiscriptsNode(
        base: base.wrapWithEquationRow(),
        sub: scriptsResult.subscript,
        sup: scriptsResult.superscript,
      );
    } else {
      return base;
    }
  }

  /// The following functions are separated from parseAtoms in KaTeX
  ScriptsParsingResults parseScripts({bool allowLimits = false}) {
    EquationRowNode subscript;
    EquationRowNode superscript;
    bool limits;
    loop:
    while (true) {
      this.consumeSpaces();
      final lex = this.fetch();
      switch (lex.text) {
        case '\\limits':
        case '\\nolimits':
          if (!allowLimits) {
            throw ParseError('Limit controls must follow a math operator', lex);
          }
          limits = lex.text == '\\limits';
          break;
        case '^':
          if (superscript != null) {
            throw ParseError('Double superscript', lex);
          }
          superscript = this._handleScript().wrapWithEquationRow();
          break;
        case '_':
          if (subscript != null) {
            throw ParseError('Double subscript', lex);
          }
          subscript = this._handleScript().wrapWithEquationRow();
          break;
        case "'":
          if (superscript != null) {
            throw ParseError('Double superscript', lex);
          }
          //TODO
          final superscriptList = <GreenNode>[
            makeOrdNode(mode: this.mode, text: '\\prime')
          ];
          while (this.fetch().text == "'") {
            superscriptList.add(makeOrdNode(mode: this.mode, text: '\\prime'));
            this.consume();
          }
          if (this.fetch().text == '^') {
            superscriptList.addAll(this._handleScript().expandEquationRow());
          }
          superscript = superscriptList.wrapWithEquationRow();
          break;
        default:
          break loop;
      }
    }
    return ScriptsParsingResults(
      subscript: subscript,
      superscript: superscript,
      limits: limits,
    );
  }

  GreenNode _handleScript() {
    final symbolToken = this.fetch();
    final symbol = symbolToken.text;
    this.consume();
    final group = this.parseGroup(
      symbol == '_' ? 'subscript' : 'superscript',
      optional: false,
      greediness: TexParser.supsubGreediness,
      consumeSpaces: true,
    );
    if (group == null) {
      throw ParseError("Expected group after '$symbol'", symbolToken);
    }
    return group;
  }

  static const supsubGreediness = 1;

  Token fetch() {
    if (this.nextToken == null) {
      this.nextToken = this.macroExpander.expandNextToken();
    }
    return this.nextToken;
  }

  void consume() {
    this.nextToken = null;
  }

  /// [parseGroup] Return a row if encounters [] or {}. Returns single function
  /// node or a single symbol otherwise.
  ///
  ///
  /// If `optional` is false or absent, this parses an ordinary group,
  /// which is either a single nucleus (like "x") or an expression
  /// in braces (like "{x+y}") or an implicit group, a group that starts
  /// at the current position, and ends right before a higher explicit
  /// group ends, or at EOF.
  /// If `optional` is true, it parses either a bracket-delimited expression
  /// (like "[x+y]") or returns null to indicate the absence of a
  /// bracket-enclosed group.
  /// If `mode` is present, switches to that mode while parsing the group,
  /// and switches back after.
  GreenNode parseGroup(
    String name, {
    bool optional,
    int greediness,
    String breakOnTokenText,
    Mode mode,
    bool consumeSpaces,
  }) {
    // Save current mode and restore after completion
    final outerMode = this.mode;
    if (mode != null) {
      this._switchMode(mode);
    }
    // Consume spaces if requested, crucially *after* we switch modes,
    // so that the next non-space token is parsed in the correct mode.
    if (consumeSpaces == true) {
      this.consumeSpaces();
    }
    // Get first token
    final firstToken = this.fetch();
    final text = firstToken.text;
    GreenNode result;
    // Try to parse an open brace or \begingroup
    if (optional ? text == '[' : text == '{' || text == '\\begingroup') {
      this.consume();
      final groupEnd = endOfGroup[text];
      // Start a new group namespace
      this.macroExpander.beginGroup();
      // If we get a brace, parse an expression
      final expression =
          this.parseExpression(breakOnInfix: false, breakOnTokenText: groupEnd);
      // final lastToken = this.fetch();
      // Check that we got a matching closing brace
      this.expect(groupEnd);
      result = this.mode == Mode.math
          ? expression.wrapWithEquationRow()
          : TextNode(children: expression);
    } else if (optional) {
      // Return nothing for an optional group
      result = null;
    } else {
      // If there exists a function with this name, parse the function.
      // Otherwise, just return a nucleus
      result = this.parseFunction(breakOnTokenText, name, greediness) ??
          this._parseSymbol();
      if (result == null &&
          text[0] == '\\' &&
          !implicitCommands.contains(text)) {
        if (this.settings.throwOnError) {
          throw ParseError('Undefined control sequence: $text', firstToken);
        }
        result = this._formatUnsuppotedCmd(text);
        this.consume();
      }
    }
    if (mode != null) {
      this._switchMode(outerMode);
    }
    return result;
  }

  ///Parses an entire function, including its base and all of its arguments.

  GreenNode parseFunction(
      String breakOnTokenText, String name, int greediness) {
    final token = this.fetch();
    final func = token.text;
    final funcData = functions[func];
    if (funcData == null) {
      return null;
    }
    this.consume();

    if (greediness != null && funcData.greediness <= greediness) {
      throw ParseError(
          '''Got function '$func' with no arguments ${name != null ? ' as $name' : ''}''',
          token);
    } else if (this.mode == Mode.text && !funcData.allowedInText) {
      throw ParseError('''Can't use function '$func' in text mode''', token);
    } else if (this.mode == Mode.math && funcData.allowedInMath == false) {
      throw ParseError('''Can't use function '$func' in math mode''', token);
    }

    // final funcArgs = parseArgument(func, funcData);

    final context = FunctionContext(
      funcName: func,
      token: token,
      breakOnTokenText: breakOnTokenText,
    );

    if (funcData.handler != null) {
      _enterArgumentParsingMode(func, funcData);
      try {
        return funcData.handler(this, context);
      } finally {
        _leaveArgumentParsingMode(func);
      }
    } else {
      throw ParseError('''No function handler for $name''');
    }
    // return this.callFunction(func, token, breakOnTokenText);
  }

  // GreenNode callFunction(String name, Token token, String breakOnTokenText) {
  //   final context = FunctionContext(
  //       funcName: name,
  //       parser: this,
  //       token: token,
  //       breakOnTokenText: breakOnTokenText);
  //   final func = functions[name];
  //   if (func != null && func.handler != null) {
  //     return func.handler(context);
  //   } else {
  //     throw ParseError('''No function handler for $name''');
  //   }
  // }

  // Tuple2<List<GreenNode>, List<GreenNode>> parseArgument(
  //     String func, FunctionSpec<GreenNode> funcData) {
  //   if (funcData.totalArgs == 0) {
  //     return Tuple2([], []);
  //   }
  //   final args = <GreenNode>[];
  //   final optArgs = <GreenNode>[];

  //   for (var i = 0; i < funcData.totalArgs; i++) {
  //     final argType = funcData.argTypes[i];
  //     final isOptional = i < funcData.numOptionalArgs;
  //     // Ignore spaces between arguments.  As the TeXbook says:
  //     // "After you have said ‘\def\row#1#2{...}’, you are allowed to
  //     //  put spaces between the arguments (e.g., ‘\row x n’), because
  //     //  TeX doesn’t use single spaces as undelimited arguments."
  //     final consumeSpaces = (i > 0 && !isOptional) ||
  //         // Also consume leading spaces in math mode, as parseSymbol
  //         // won't know what to do with them.  This can only happen with
  //         // macros, e.g. \frac\foo\foo where \foo expands to a space symbol.
  //         // In LaTeX, the \foo's get treated as (blank) arguments.
  //         // In KaTeX, for now, both spaces will get consumed.
  //         // TODO(edemaine)
  //         (i == 0 && !isOptional && this.mode == Mode.math);
  //     final arg = this.parseGroupOfType('''argument to '$func' ''',
  //         type: argType,
  //         optional: isOptional,
  //         greediness: funcData.greediness,
  //         consumeSpaces: consumeSpaces);
  //     if (arg == null) {
  //       if (isOptional) {
  //         optArgs.add(null);
  //         continue;
  //       }
  //       throw ParseError('''Expected group after '$func' ''', this.fetch());
  //     }
  //     (isOptional ? optArgs : args).add(arg);
  //   }
  // }

  // GreenNode parseGroupOfType(String name,
  //     {ArgType type,
  //     @required bool optional,
  //     int greediness,
  //     @required bool consumeSpaces}) {
  //   switch (type) {
  //     case ArgType.color:
  //       if (consumeSpaces) {
  //         this.consumeSpaces();
  //       }
  //       return this.parseColorGroup(optional);
  //     case ArgType.size:
  //       if (consumeSpaces) {
  //         this.consumeSpaces();
  //       }
  //       return this.parseSizeGroup(optional);
  //     case ArgType.url:
  //       return this.parseUrlGroup(optional);
  //     case ArgType.math:
  //     case ArgType.text:
  //       return this.parseGroup(name,
  //           optional: optional,
  //           greediness: greediness,
  //           breakOnTokenText: null,
  //           mode: type == ArgType.text ? Mode.text : Mode.math,
  //           consumeSpaces: consumeSpaces);
  //     case ArgType.hBox:
  //       final group = this.parseGroup(name,
  //           optional: optional,
  //           greediness: greediness,
  //           breakOnTokenText: null,
  //           mode: Mode.text,
  //           consumeSpaces: consumeSpaces);
  //       if (group == null) {
  //         //???????
  //         return group;
  //       }
  //       return StyledGroup();
  //     case ArgType.raw:
  //       if (consumeSpaces) {
  //         this.consumeSpaces();
  //       }
  //       if (optional && this.fetch().text == '{') {
  //         return null;
  //       }
  //       final token =
  //          this.parseStringGroup(ArgType.raw, optional: optional, raw: true);
  //       if (token != null) {
  //         return RawNode();
  //       }
  //       throw ParseError('Expected raw group', this.fetch());
  //     case ArgType.original:
  //     default:
  //       if (type == null || type == ArgType.original) {
  //         return this.parseGroup(name,
  //             optional: optional,
  //             greediness: greediness,
  //             breakOnTokenText: null,
  //             mode: null,
  //             consumeSpaces: consumeSpaces);
  //       } else {
  //         throw ParseError('Unknown group type as $name', this.fetch());
  //       }
  //   }
  // }

  final argParsingContexts = Queue<ArgumentParsingContext>();
  ArgumentParsingContext get currArgParsingContext => argParsingContexts.last;

  void _enterArgumentParsingMode(String name, FunctionSpec funcData) {
    argParsingContexts
        .addLast(ArgumentParsingContext(funcName: name, funcData: funcData));
  }

  void _leaveArgumentParsingMode(String name) {
    assert(currArgParsingContext.funcName == name);
    argParsingContexts.removeLast();
  }

  void _assertOptionalBeforeReturn(dynamic value, {@required bool optional}) {
    if (!optional && value == null) {
      throw ParseError('Expected group after ${currArgParsingContext.funcName}',
          this.fetch());
    }
  }

  static final _parseColorRegex1 =
      RegExp(r'#([a-f0-9])([a-f0-9])([a-f0-9])', caseSensitive: false);
  static final _parseColorRegex2 = RegExp(
      r'#?([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})',
      caseSensitive: false);
  static final _parseColorRegex3 = RegExp(r'([a-z]+)', caseSensitive: false);
  // static final _parseColorRegex =
  //     RegExp(r'^(#[a-f0-9]{3}|#?[a-f0-9]{6}|[a-z]+)$', caseSensitive: false);
  // static final _matchColorRegex =
  //     RegExp(r'[0-9a-f]{6}', caseSensitive: false);
  Color parseArgColor({@required bool optional}) {
    currArgParsingContext.newArgument(optional: optional);
    final i = currArgParsingContext.currArgNum;
    final consumeSpaces =
        (i > 0 && !optional) || (i == 0 && !optional && this.mode == Mode.math);
    if (consumeSpaces) {
      this.consumeSpaces();
    }
    // final res = this.parseColorGroup(optional: optional);
    final res = this._parseStringGroup('color', optional: optional);
    if (res == null) {
      _assertOptionalBeforeReturn(null, optional: optional);
      return null;
    }

    final match3 = _parseColorRegex3.firstMatch(res.text);

    if (match3 != null) {
      final color = colorByName[match3[0].toLowerCase()];
      if (color != null) {
        return color;
      }
    }

    final match2 = _parseColorRegex2.firstMatch(res.text);
    if (match2 != null) {
      return Color.fromARGB(
        0xff,
        int.parse(match3[0], radix: 16),
        int.parse(match3[1], radix: 16),
        int.parse(match3[2], radix: 16),
      );
    }

    final match1 = _parseColorRegex1.firstMatch(res.text);
    if (match1 != null) {
      return Color.fromARGB(
        0xff,
        int.parse(match3[0] * 2, radix: 16),
        int.parse(match3[1] * 2, radix: 16),
        int.parse(match3[2] * 2, radix: 16),
      );
    }
    throw ParseError("Invalid color: '${res.text}'");
  }

  static final _parseSizeRegex =
      RegExp(r'^[-+]? *(?:$|\d+|\d+\.\d*|\.\d*) *[a-z]{0,2} *$');
  static final _parseMeasurementRegex =
      RegExp(r'([-+]?) *(\d+(?:\.\d*)?|\.\d+) *([a-z]{2})');
  Measurement parseArgSize({@required bool optional}) {
    currArgParsingContext.newArgument(optional: optional);
    final i = currArgParsingContext.currArgNum;
    final consumeSpaces =
        (i > 0 && !optional) || (i == 0 && !optional && this.mode == Mode.math);
    if (consumeSpaces) {
      this.consumeSpaces();
    }

    // final res = this.parseSizeGroup(optional: optional);
    Token res;
    if (!optional && this.fetch().text != '{') {
      res = _parseRegexGroup(_parseSizeRegex, 'size');
    } else {
      res = _parseStringGroup('size', optional: optional);
    }
    if (res == null) {
      _assertOptionalBeforeReturn(null, optional: optional);
      return null;
    }
    if (!optional && res.text.isEmpty) {
      // res.text = '0pt';
      // This means default width for genfrac, and 0pt for above
      return null;
    }
    final match = _parseMeasurementRegex.firstMatch(res.text);
    if (match == null) {
      throw ParseError("Invalid size: '${res.text}'", res);
    }

    final unit = match[3].parseUnit();
    if (unit == null) {
      throw ParseError("Invalid unit: '${match[3]}'", res);
    }
    final size =
        Measurement(value: double.parse(match[1] + match[2]), unit: unit);
    return size;
  }

  String parseArgUrl({@required bool optional}) {
    currArgParsingContext.newArgument(optional: optional);
    // final i = currArgParsingContext.currArgNum;
    // final consumeSpaces =
    //  (i > 0 && !optional) || (i == 0 && !optional && this.mode == Mode.math);
    // if (consumeSpaces) {
    //   this.consumeSpaces();
    // }
    // final res = this.parseUrlGroup(optional: optional);
    throw UnimplementedError();
  }

  GreenNode parseArgNode({@required Mode mode, @required bool optional}) {
    currArgParsingContext.newArgument(optional: optional);
    final i = currArgParsingContext.currArgNum;
    final consumeSpaces =
        (i > 0 && !optional) || (i == 0 && !optional && this.mode == Mode.math);
    // if (consumeSpaces) {
    //   this.consumeSpaces();
    // }
    final res = this.parseGroup(
      currArgParsingContext.name,
      optional: optional,
      greediness: currArgParsingContext.funcData.greediness,
      mode: mode,
      consumeSpaces: consumeSpaces,
    );
    _assertOptionalBeforeReturn(res, optional: optional);
    return res;
  }

  GreenNode parserArgHbox({@required bool optional}) {
    //TODO
    throw UnimplementedError();
  }

  String parseArgRaw({@required bool optional}) {
    currArgParsingContext.newArgument(optional: optional);
    final i = currArgParsingContext.currArgNum;
    final consumeSpaces =
        (i > 0 && !optional) || (i == 0 && !optional && this.mode == Mode.math);
    if (consumeSpaces) {
      this.consumeSpaces();
    }
    if (optional && this.fetch().text == '{') {
      return null;
    }
    final token = this._parseStringGroup('raw', optional: optional);
    if (token != null) {
      return token.text;
    } else {
      throw ParseError('Expected raw group', this.fetch());
    }
  }

  static final _parseStringGroupRegex = RegExp('''[^{}[\]]''');

  Token _parseStringGroup(String modeName,
      {@required bool optional, bool raw = false}) {
    final groupBegin = optional ? '[' : '{';
    final groupEnd = optional ? ']' : '}';
    final beginToken = this.fetch();
    if (beginToken.text != groupBegin) {
      if (optional) {
        return null;
      } else if (raw &&
          beginToken.text != 'EOF' &&
          _parseStringGroupRegex.hasMatch(beginToken.text)) {
        this.consume();
        return beginToken;
      }
    }
    final outerMode = this.mode;
    this.mode = Mode.text;
    this.expect(groupBegin);

    var str = '';
    final firstToken = this.fetch();
    var nested = 0;
    var lastToken = firstToken;
    Token nextToken;
    while ((nextToken = this.fetch()).text != groupEnd || (raw && nested > 0)) {
      if (nextToken.text == 'EOF') {
        throw ParseError('Unexpected end of input in $modeName',
            Token.range(firstToken, lastToken, str));
      } else if (nextToken.text == groupBegin) {
        nested++;
      } else if (nextToken.text == groupEnd) {
        nested--;
      }
      lastToken = nextToken;
      str += lastToken.text;
      this.consume();
    }
    this.expect(groupEnd);
    this.mode = outerMode;
    return Token.range(firstToken, lastToken, str);
  }

  Token _parseRegexGroup(RegExp regex, String modeName) {
    final outerMode = this.mode;
    this.mode = Mode.text;
    final firstToken = this.fetch();
    var lastToken = firstToken;
    var str = '';
    Token nextToken;
    while ((nextToken = this.fetch()).text != 'EOF' &&
        regex.hasMatch(str + nextToken.text)) {
      lastToken = nextToken;
      str += lastToken.text;
      this.consume();
    }
    if (str.isEmpty) {
      throw ParseError("Invalid $modeName: '${firstToken.text}'", firstToken);
    }
    this.mode = outerMode;
    return Token.range(firstToken, lastToken, str);
  }

  static final _parseVerbRegex = RegExp(r'^\\verb[^a-zA-Z]');
  GreenNode _parseSymbol() {
    final nucleus = this.fetch();
    var text = nucleus.text;
    if (_parseVerbRegex.hasMatch(text)) {
      this.consume();
      var arg = text.substring(5);
      final star = (arg[0] == '*'); //?
      if (star) {
        arg = arg.substring(1);
      }
      // Lexer's tokenRegex is constructed to always have matching
      // first/last characters.

      if (arg.length < 2 || arg[0] != arg[arg.length - 1]) {
        throw ParseError('''\\verb assertion failed --
                    please report what input caused this bug''');
      }
      arg = arg.substring(1, arg.length - 1);
      return VerbNode(text: arg);
    }
    // At this point, we should have a symbol, possibly with accents.
    // First expand any accented base symbol according to unicodeSymbols.
    if (unicodeSymbols.containsKey(text[0]) &&
        !symbols[this.mode].containsKey(text[0])) {
      if (this.mode == Mode.math) {
        this.settings.reportNonstrict(
            'unicodeTextInMathMode',
            'Accented Unicode text character "${text[0]}" used in math mode',
            nucleus);
      }
      text = unicodeSymbols[text[0]] + text.substring(1);
    }
    // Strip off any combining characters
    final match = combiningDiacriticalMarksEndRegex.firstMatch(text);
    if (match != null) {
      text = text.substring(0, match.start);
      if (text == 'i') {
        text = '\u0131'; // dotless i, in math and text mode
      } else if (text == 'j') {
        text = '\u0237'; // dotless j, in math and text mode
      }
    }
    // Recognize base symbol
    GreenNode symbol;
    if (symbols[this.mode].containsKey(text)) {
      if (this.mode == Mode.math && extraLatin.contains(text)) {
        this.settings.reportNonstrict(
            'unicodeTextInMathMode',
            'Latin-1/Unicode text character "${text[0]}" used in math mode',
            nucleus);
      }
      final group = symbols[this.mode][text].group;
      // final loc = SourceLocation.range(nucleus);
      if (atoms.contains(group)) {
        symbol = makeOperatorNode(mode: this.mode, text: text, family: group);
      } else {
        symbol =
            makeNodeBasedOnGroup(mode: this.mode, text: text, family: group);
        // throw ArgumentError(
        //     'Illegal definition of group on symbol $text'); //TODO
        // symbol = 0;
      }
    } else if (text.codeUnitAt(0) >= 0x80) {
      if (!supportedCodepoint(text.codeUnitAt(0))) {
        this.settings.reportNonstrict(
            'unknownSymbol',
            'Unrecognized Unicode character "${text[0]}" '
                '(${text.codeUnitAt(0)})',
            nucleus);
      } else if (this.mode == Mode.math) {
        this.settings.reportNonstrict('unicodeTextInMathMode',
            'Unicode text character "${text[0]} used in math mode"', nucleus);
      }
      symbol = MathAtomNode(text: text);
    } else {
      return null;
    }
    this.consume();
    // Transform combining characters into accents
    if (match != null) {
      for (var i = 0; i < match[0].length; i++) {
        final accent = match[0][i];
        if (!unicodeAccents.containsKey(accent)) {
          throw ParseError("Unknown accent ' $accent'", nucleus);
        }
        final command = unicodeAccents[accent][this.mode];
        if (command == null) {
          throw ParseError(
              'Accent $accent unsupported in ${this.mode} mode', nucleus);
        }
        symbol = AccentNode(
          base: symbol.wrapWithEquationRow(),
          label: command,
          isShifty: true,
          isStretchy: false,
        );
      }
    }
    return symbol;
  }

  void _switchMode(Mode newMode) {
    this.mode = newMode;
    this.macroExpander.mode = newMode;
  }

  GreenNode _formatUnsuppotedCmd(String text) {
    //TODO
    throw UnimplementedError();
  }
}

class ArgumentParsingContext {
  final String funcName;
  int currArgNum;
  final FunctionSpec funcData;

  bool get optional => _optional;
  bool _optional;
  set optional(bool value) {
    assert(_optional || !value);
    _optional = value;
  }

  String get name => 'argument to $funcName';

  ArgumentParsingContext({
    @required this.funcData,
    @required this.funcName,
    this.currArgNum = -1,
    bool optional = true,
  }) : _optional = optional;

  void newArgument({bool optional}) {
    currArgNum++;
    this.optional = optional;
  }
}

class ScriptsParsingResults {
  final EquationRowNode subscript;
  final EquationRowNode superscript;
  final bool limits;
  const ScriptsParsingResults({
    @required this.subscript,
    @required this.superscript,
    this.limits,
  });

  bool get empty => subscript == null && superscript == null;
}

GreenNode makeOrdNode(
    {@required Mode mode, @required String text, FontOptions fontOptions}) {
  switch (mode) {
    case Mode.math:
      return MathAtomNode(text: text, fontOptions: fontOptions);
    case Mode.text:
      return MathAtomNode(text: text, fontOptions: fontOptions);
  }
  throw ArgumentError(mode);
}

GreenNode makeOperatorNode({
  @required Mode mode,
  @required String text,
  @required Group family,
}) {
  return makeOrdNode(mode: mode, text: text);
}

GreenNode makeNodeBasedOnGroup({
  @required Mode mode,
  @required String text,
  @required Group family,
}) {
  return makeOrdNode(mode: mode, text: text);
}

T assertNodeType<T extends GreenNode>(GreenNode node) {
  if (node is T) {
    return node;
  }
  throw ParseError(
      'Expected node of type $T, but got node of type ${node.runtimeType}');
}
