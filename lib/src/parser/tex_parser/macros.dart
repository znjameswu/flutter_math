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
import 'dart:developer';

import '../../font/metrics/font_metrics_data.dart';
import 'functions.dart';

import 'macro_expander.dart';
import 'parse_error.dart';
import 'symbols.dart';
import 'token.dart';
import 'types.dart';

Map<String, MacroDefinition> _builtinMacros;
Map<String, MacroDefinition> get builtinMacros {
  if (_builtinMacros == null) {
    _init();
  }
  return _builtinMacros;
}

class MacroDefinition {
  final MacroExpansion Function(MacroContext context) expand;
  const MacroDefinition(this.expand, {this.unexpandable = false});
  final bool unexpandable;

  bool get expandable => !unexpandable;

  MacroDefinition.fromString(String output)
      : this((context) => MacroExpansion.fromString(output, context));
  MacroDefinition.fromCtxString(String Function(MacroContext) expand)
      : this((context) => MacroExpansion.fromString(expand(context), context));
  MacroDefinition.fromMacroExpansion(MacroExpansion output)
      : this((_) => output, unexpandable: output.unexpandable);
}

class MacroExpansion {
  const MacroExpansion({this.tokens, this.numArgs, this.unexpandable = false});
  final List<Token> tokens;
  final int numArgs;

  final bool unexpandable;

  static final _strippedRegex = RegExp(r'##', multiLine: true);
  static MacroExpansion fromString(String expansion, MacroContext context) {
    var numArgs = 0;
    if (expansion.contains('#')) {
      final stripped = expansion.replaceAll(_strippedRegex, '');
      while (stripped.contains('#${numArgs + 1}')) {
        numArgs += 1;
      }
    }
    final bodyLexer = context.getNewLexer(expansion);
    final tokens = <Token>[];
    var tok = bodyLexer.lex();
    while (tok.text != 'EOF') {
      tokens.add(tok);
      tok = bodyLexer.lex();
    }
    return MacroExpansion(tokens: tokens.reversed.toList(), numArgs: numArgs);
  }
}

void defineMacro(String name, MacroDefinition body) {
  _builtinMacros = {};
  _builtinMacros[name] = body;
}

//////////////////////////////////////////////////////////////////////
// macro tools

/// Transformed by:
/// /defineMacro\((['"][^'"]*['"]),[\s\r]*(['"][^'"]*['"])/ -> defineMacro($1, MacroDefinition.fromString($2)
/// /defineMacro\((['"][^'"]*['"]), function/ -> defineMacro($1, MacroDefinition(
/// /const ([a-zA-Z]* = context.[a-zA-Z]*[^;]*;)/ -> final $1
/// /let ([^;]*;)$/ -> var $1
/// /==/ -> ==
/// /!=/ -> !=
/// \}\);(([\s\r]*|[\s]//[^\n]*)*defineMacro) -> }));$1
/// `([^']*)` -> '$1'
/// defineMacro\((['"][^'"]*['"]), \(context -> defineMacro($1, MacroDefinition.fromCtxString((context
/// (\([a-zA-Z,:_]*\))[\s]*=>[\s]*\{ -> $1 {
/// charCodeAt -> codeUnitAt
/// ([a-zA-Z.]*) in ([a-zA-Z.]*) -> $2.containsKey($1)

void _init() {
  defineMacro("\\noexpand", MacroDefinition((context) {
    // The expansion is the token itself; but that token is interpreted
    // as if its meaning were ‘\relax’ if it is a control sequence that
    // would ordinarily be expanded by TeX’s expansion rules.
    final t = context.popToken();
    if (context.isExpandable(t.text)) {
      t.noexpand = true;
      t.treatAsRelax = true;
    }
    return MacroExpansion(tokens: [t], numArgs: 0);
  }));

  defineMacro("\\expandafter", MacroDefinition((context) {
    // TeX first reads the token that comes immediately after \expandafter,
    // without expanding it; let’s call this token t. Then TeX reads the
    // token that comes after t (and possibly more tokens, if that token
    // has an argument), replacing it by its expansion. Finally TeX puts
    // t back in front of that expansion.
    final t = context.popToken();
    context.expandOnce(true); // expand only an expandable token
    return MacroExpansion(tokens: [t], numArgs: 0);
  }));

// LaTeX's \@firstoftwo{#1}{#2} expands to #1, skipping #2
// TeX source: \long\def\@firstoftwo#1#2{#1}
  defineMacro("\\@firstoftwo", MacroDefinition((context) {
    final args = context.consumeArgs(2);
    return MacroExpansion(tokens: args[0], numArgs: 0);
  }));

// LaTeX's \@secondoftwo{#1}{#2} expands to #2, skipping #1
// TeX source: \long\def\@secondoftwo#1#2{#2}
  defineMacro("\\@secondoftwo", MacroDefinition((context) {
    final args = context.consumeArgs(2);
    return MacroExpansion(tokens: args[1], numArgs: 0);
  }));

// LaTeX's \@ifnextchar{#1}{#2}{#3} looks ahead to the next (unexpanded)
// symbol that isn't a space, consuming any spaces but not consuming the
// first nonspace character.  If that nonspace character matches #1, then
// the macro expands to #2; otherwise, it expands to #3.
  defineMacro("\\@ifnextchar", MacroDefinition((context) {
    final args = context.consumeArgs(3); // symbol, if, else
    context.consumeSpaces();
    final nextToken = context.future();
    if (args[0].length == 1 && args[0][0].text == nextToken.text) {
      return MacroExpansion(tokens: args[1], numArgs: 0);
    } else {
      return MacroExpansion(tokens: args[2], numArgs: 0);
    }
  }));

// LaTeX's \@ifstar{#1}{#2} looks ahead to the next (unexpanded) symbol.
// If it is '*', then it consumes the symbol, and the macro expands to #1;
// otherwise, the macro expands to #2 (without consuming the symbol).
// TeX source: \def\@ifstar#1{\@ifnextchar *{\@firstoftwo{#1}}}
  defineMacro("\\@ifstar",
      MacroDefinition.fromString("\\@ifnextchar *{\\@firstoftwo{#1}}"));

// LaTeX's \TextOrMath{#1}{#2} expands to #1 in text mode, #2 in math mode
  defineMacro("\\TextOrMath", MacroDefinition((context) {
    final args = context.consumeArgs(2);
    if (context.mode == Mode.text) {
      return MacroExpansion(tokens: args[0], numArgs: 0);
    } else {
      return MacroExpansion(tokens: args[1], numArgs: 0);
    }
  }));

// Lookup table for parsing numbers in base 8 through 16
  const digitToNumber = {
    "0": 0,
    "1": 1,
    "2": 2,
    "3": 3,
    "4": 4,
    "5": 5,
    "6": 6,
    "7": 7,
    "8": 8,
    "9": 9,
    "a": 10,
    "A": 10,
    "b": 11,
    "B": 11,
    "c": 12,
    "C": 12,
    "d": 13,
    "D": 13,
    "e": 14,
    "E": 14,
    "f": 15,
    "F": 15,
  };

// TeX \char makes a literal character (catcode 12) using the following forms:
// (see The TeXBook, p. 43)
//   \char123  -- decimal
//   \char'123 -- octal
//   \char"123 -- hex
//   \char`x   -- character that can be written (i.e. isn't active)
//   \char`\x  -- character that cannot be written (e.g. %)
// These all refer to characters from the font, so we turn them into special
// calls to a function \@char dealt with in the Parser.
  defineMacro("\\char", MacroDefinition.fromCtxString((context) {
    var token = context.popToken();
    int base;
    int number;
    if (token.text == "'") {
      base = 8;
      token = context.popToken();
    } else if (token.text == '"') {
      base = 16;
      token = context.popToken();
    } else if (token.text == "`") {
      token = context.popToken();
      if (token.text[0] == "\\") {
        number = token.text.codeUnitAt(1);
      } else if (token.text == "EOF") {
        throw ParseError("\\char` missing argument");
      } else {
        number = token.text.codeUnitAt(0);
      }
    } else {
      base = 10;
    }
    if (base != null) {
      // Parse a number in the given base, starting with first 'token'.
      number = digitToNumber[token.text];
      if (number == null || number >= base) {
        throw ParseError('Invalid base-$base digit ${token.text}');
      }
      int digit;
      while ((digit = digitToNumber[context.future().text]) != null &&
          digit < base) {
        number *= base;
        number += digit;
        context.popToken();
      }
    }
    return '\\@char{$number}';
  }));

// \newcommand{\macro}[args]{definition}
// \renewcommand{\macro}[args]{definition}
// TODO: Optional arguments: \newcommand{\macro}[args][default]{definition}
  final newcommand = (MacroContext context, bool existsOK, bool nonexistsOK) {
    var arg = context.consumeArgs(1)[0];
    if (arg.length != 1) {
      throw ParseError("\\newcommand's first argument must be a macro name");
    }
    final name = arg[0].text;

    final exists = context.isDefined(name);
    if (exists && !existsOK) {
      throw ParseError('\\newcommand{$name} attempting to redefine '
          '$name; use \\renewcommand');
    }
    if (!exists && !nonexistsOK) {
      throw ParseError('\\renewcommand{$name} when command $name '
          'does not yet exist; use \\newcommand');
    }

    var numArgs = 0;
    arg = context.consumeArgs(1)[0];
    if (arg.length == 1 && arg[0].text == "[") {
      var argText = '';
      var token = context.expandNextToken();
      while (token.text != "]" && token.text != "EOF") {
        // TODO: Should properly expand arg, e.g., ignore {}s
        argText += token.text;
        token = context.expandNextToken();
      }
      if (!RegExp(r'^\s*[0-9]+\s*$').hasMatch(argText)) {
        throw ParseError('Invalid number of arguments: $argText');
      }
      numArgs = int.parse(argText);
      arg = context.consumeArgs(1)[0];
    }

    // Final arg is the expansion of the macro
    context.macros.set(
        name,
        MacroDefinition.fromMacroExpansion(MacroExpansion(
          tokens: arg,
          numArgs: numArgs,
        )));
    return '';
  };
  defineMacro(
      "\\newcommand",
      MacroDefinition.fromCtxString(
          (context) => newcommand(context, false, true)));
  defineMacro(
      "\\renewcommand",
      MacroDefinition.fromCtxString(
          (context) => newcommand(context, true, false)));
  defineMacro(
      "\\providecommand",
      MacroDefinition.fromCtxString(
          (context) => newcommand(context, true, true)));

// terminal (console) tools
  defineMacro("\\message", MacroDefinition.fromCtxString((context) {
    final arg = context.consumeArgs(1)[0];
    // eslint-disable-next-line no-console
    log(arg.reversed.map((token) => token.text).join(""));
    return '';
  }));
  defineMacro("\\errmessage", MacroDefinition.fromCtxString((context) {
    final arg = context.consumeArgs(1)[0];
    // eslint-disable-next-line no-console
    log(arg.reversed.map((token) => token.text).join(""));
    return '';
  }));
  defineMacro("\\show", MacroDefinition.fromCtxString((context) {
    final tok = context.popToken();
    final name = tok.text;
    // eslint-disable-next-line no-console
    log('$tok, ${context.macros.get(name)}, ${functions[name]},'
        '${symbols[Mode.math][name]}, ${symbols[Mode.text][name]}');
    return '';
  }));

//////////////////////////////////////////////////////////////////////
// Grouping
// \let\bgroup={ \let\egroup=}
  defineMacro("\\bgroup", MacroDefinition.fromString("{"));
  defineMacro("\\egroup", MacroDefinition.fromString("}"));

// Symbols from latex.ltx:
// \def\lq{`}
// \def\rq{'}
// \def \aa {\r a}
// \def \AA {\r A}
  defineMacro("\\lq", MacroDefinition.fromString("`"));
  defineMacro("\\rq", MacroDefinition.fromString("'"));
  defineMacro("\\aa", MacroDefinition.fromString("\\r a"));
  defineMacro("\\AA", MacroDefinition.fromString("\\r A"));

// Copyright (C) and registered (R) symbols. Use raw symbol in MathML.
// \DeclareTextCommandDefault{\textcopyright}{\textcircled{c}}
// \DeclareTextCommandDefault{\textregistered}{\textcircled{%
//      \check@mathfonts\fontsize\sf@size\z@\math@fontsfalse\selectfont R}}
// \DeclareRobustCommand{\copyright}{%
//    \ifmmode{\nfss@text{\textcopyright}}\else\textcopyright\fi}
  defineMacro("\\textcopyright",
      MacroDefinition.fromString("\\html@mathml{\\textcircled{c}}{\\char`©}"));
  defineMacro(
      "\\copyright",
      MacroDefinition.fromString(
          "\\TextOrMath{\\textcopyright}{\\text{\\textcopyright}}"));
  defineMacro(
      "\\textregistered",
      MacroDefinition.fromString(
          "\\html@mathml{\\textcircled{\\scriptsize R}}{\\char`®}"));

// Characters omitted from Unicode range 1D400–1D7FF
  defineMacro("\u212C", MacroDefinition.fromString("\\mathscr{B}")); // script
  defineMacro("\u2130", MacroDefinition.fromString("\\mathscr{E}"));
  defineMacro("\u2131", MacroDefinition.fromString("\\mathscr{F}"));
  defineMacro("\u210B", MacroDefinition.fromString("\\mathscr{H}"));
  defineMacro("\u2110", MacroDefinition.fromString("\\mathscr{I}"));
  defineMacro("\u2112", MacroDefinition.fromString("\\mathscr{L}"));
  defineMacro("\u2133", MacroDefinition.fromString("\\mathscr{M}"));
  defineMacro("\u211B", MacroDefinition.fromString("\\mathscr{R}"));
  defineMacro("\u212D", MacroDefinition.fromString("\\mathfrak{C}")); // Fraktur
  defineMacro("\u210C", MacroDefinition.fromString("\\mathfrak{H}"));
  defineMacro("\u2128", MacroDefinition.fromString("\\mathfrak{Z}"));

// Define \Bbbk with a macro that works in both HTML and MathML.
  defineMacro("\\Bbbk", MacroDefinition.fromString("\\Bbb{k}"));

// Unicode middle dot
// The KaTeX fonts do not contain U+00B7. Instead, \cdotp displays
// the dot at U+22C5 and gives it punct spacing.
  defineMacro("\u00b7", MacroDefinition.fromString("\\cdotp"));

// \llap and \rlap render their contents in text mode
  defineMacro("\\llap", MacroDefinition.fromString("\\mathllap{\\textrm{#1}}"));
  defineMacro("\\rlap", MacroDefinition.fromString("\\mathrlap{\\textrm{#1}}"));
  defineMacro("\\clap", MacroDefinition.fromString("\\mathclap{\\textrm{#1}}"));

// \not is defined by base/fontmath.ltx via
// \DeclareMathSymbol{\not}{\mathrel}{symbols}{"36}
// It's thus treated like a \mathrel, but defined by a symbol that has zero
// width but extends to the right.  We use \rlap to get that spacing.
// For MathML we write U+0338 here. buildMathML.js will then do the overlay.
  defineMacro(
      "\\not",
      MacroDefinition.fromString(
          '\\html@mathml{\\mathrel{\\mathrlap\\@not}}{\\char")338}'));

// Negated symbols from base/fontmath.ltx:
// \def\neq{\not=} \let\ne=\neq
// \DeclareRobustCommand
//   \notin{\mathrel{\m@th\mathpalette\c@ncel\in}}
// \def\c@ncel#1#2{\m@th\ooalign{$\hfil#1\mkern1mu/\hfil$\crcr$#1#2$}}
  defineMacro(
      "\\neq",
      MacroDefinition.fromString(
          "\\html@mathml{\\mathrel{\\not=}}{\\mathrel{\\char`≠}}"));
  defineMacro("\\ne", MacroDefinition.fromString("\\neq"));
  defineMacro("\u2260", MacroDefinition.fromString("\\neq"));
  defineMacro(
      "\\notin",
      MacroDefinition.fromString(
          "\\html@mathml{\\mathrel{{\\in}\\mathllap{/\\mskip1mu}}}"
          "{\\mathrel{\\char`∉}}"));
  defineMacro("\u2209", MacroDefinition.fromString("\\notin"));

// Unicode stacked relations
  defineMacro(
      "\u2258",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{=\\kern{-1em}\\raisebox{0.4em}{\$\\scriptsize\\frown\$}}"
          "}{\\mathrel{\\char`\u2258}}"));
  defineMacro(
      "\u2259",
      MacroDefinition.fromString(
          "\\html@mathml{\\stackrel{\\tiny\\wedge}{=}}{\\mathrel{\\char`\u2258}}"));
  defineMacro(
      "\u225A",
      MacroDefinition.fromString(
          "\\html@mathml{\\stackrel{\\tiny\\vee}{=}}{\\mathrel{\\char`\u225A}}"));
  defineMacro(
      "\u225B",
      MacroDefinition.fromString(
          "\\html@mathml{\\stackrel{\\scriptsize\\star}{=}}"
          "{\\mathrel{\\char`\u225B}}"));
  defineMacro(
      "\u225D",
      MacroDefinition.fromString(
          "\\html@mathml{\\stackrel{\\tiny\\mathrm{def}}{=}}"
          "{\\mathrel{\\char`\u225D}}"));
  defineMacro(
      "\u225E",
      MacroDefinition.fromString(
          "\\html@mathml{\\stackrel{\\tiny\\mathrm{m}}{=}}"
          "{\\mathrel{\\char`\u225E}}"));
  defineMacro(
      "\u225F",
      MacroDefinition.fromString(
          "\\html@mathml{\\stackrel{\\tiny?}{=}}{\\mathrel{\\char`\u225F}}"));

// Misc Unicode
  defineMacro("\u27C2", MacroDefinition.fromString("\\perp"));
  defineMacro(
      "\u203C", MacroDefinition.fromString("\\mathclose{!\\mkern-0.8mu!}"));
  defineMacro("\u220C", MacroDefinition.fromString("\\notni"));
  defineMacro("\u231C", MacroDefinition.fromString("\\ulcorner"));
  defineMacro("\u231D", MacroDefinition.fromString("\\urcorner"));
  defineMacro("\u231E", MacroDefinition.fromString("\\llcorner"));
  defineMacro("\u231F", MacroDefinition.fromString("\\lrcorner"));
  defineMacro("\u00A9", MacroDefinition.fromString("\\copyright"));
  defineMacro("\u00AE", MacroDefinition.fromString("\\textregistered"));
  defineMacro("\uFE0F", MacroDefinition.fromString("\\textregistered"));

// The KaTeX fonts have corners at codepoints that don't match Unicode.
// For MathML purposes, use the Unicode code point.
  defineMacro(
      "\\ulcorner",
      MacroDefinition.fromString(
          "\\html@mathml{\\@ulcorner}{\\mathop{\\char\")231c}}"));
  defineMacro(
      "\\urcorner",
      MacroDefinition.fromString(
          "\\html@mathml{\\@urcorner}{\\mathop{\\char\")231d}}"));
  defineMacro(
      "\\llcorner",
      MacroDefinition.fromString(
          "\\html@mathml{\\@llcorner}{\\mathop{\\char\")231e}}"));
  defineMacro(
      "\\lrcorner",
      MacroDefinition.fromString(
          "\\html@mathml{\\@lrcorner}{\\mathop{\\char\")231f}}"));

//////////////////////////////////////////////////////////////////////
// LaTeX_2ε

// \vdots{\vbox{\baselineskip4\p@  \lineskiplimit\z@
// \kern6\p@\hbox{.}\hbox{.}\hbox{.}}}
// We'll call \varvdots, which gets a glyph from symbols.js.
// The zero-width rule gets us an equivalent to the vertical 6pt kern.
  defineMacro("\\vdots",
      MacroDefinition.fromString("\\mathord{\\varvdots\\rule{0pt}{15pt}}"));
  defineMacro("\u22ee", MacroDefinition.fromString("\\vdots"));

//////////////////////////////////////////////////////////////////////
// amsmath.sty
// http://mirrors.concertpass.com/tex-archive/macros/latex/required/amsmath/amsmath.pdf

// Italic Greek capital letters.  AMS defines these with \DeclareMathSymbol,
// but they are equivalent to \mathit{\Letter}.
  defineMacro("\\varGamma", MacroDefinition.fromString("\\mathit{\\Gamma}"));
  defineMacro("\\varDelta", MacroDefinition.fromString("\\mathit{\\Delta}"));
  defineMacro("\\varTheta", MacroDefinition.fromString("\\mathit{\\Theta}"));
  defineMacro("\\varLambda", MacroDefinition.fromString("\\mathit{\\Lambda}"));
  defineMacro("\\varXi", MacroDefinition.fromString("\\mathit{\\Xi}"));
  defineMacro("\\varPi", MacroDefinition.fromString("\\mathit{\\Pi}"));
  defineMacro("\\varSigma", MacroDefinition.fromString("\\mathit{\\Sigma}"));
  defineMacro(
      "\\varUpsilon", MacroDefinition.fromString("\\mathit{\\Upsilon}"));
  defineMacro("\\varPhi", MacroDefinition.fromString("\\mathit{\\Phi}"));
  defineMacro("\\varPsi", MacroDefinition.fromString("\\mathit{\\Psi}"));
  defineMacro("\\varOmega", MacroDefinition.fromString("\\mathit{\\Omega}"));

//\newcommand{\substack}[1]{\subarray{c}#1\endsubarray}
  defineMacro("\\substack",
      MacroDefinition.fromString("\\begin{subarray}{c}#1\\end{subarray}"));

// \renewcommand{\colon}{\nobreak\mskip2mu\mathpunct{}\nonscript
// \mkern-\thinmuskip{:}\mskip6muplus1mu\relax}
  defineMacro(
      "\\colon",
      MacroDefinition.fromString("\\nobreak\\mskip2mu\\mathpunct{}"
          "\\mathchoice{\\mkern-3mu}{\\mkern-3mu}{}{}{:}\\mskip6mu"));

// \newcommand{\boxed}[1]{\fbox{\m@th$\displaystyle#1$}}
  defineMacro(
      "\\boxed", MacroDefinition.fromString("\\fbox{\$\\displaystyle{#1}\$}"));

// \def\iff{\DOTSB\;\Longleftrightarrow\;}
// \def\implies{\DOTSB\;\Longrightarrow\;}
// \def\impliedby{\DOTSB\;\Longleftarrow\;}
  defineMacro(
      "\\iff", MacroDefinition.fromString("\\DOTSB\\;\\Longleftrightarrow\\;"));
  defineMacro(
      "\\implies", MacroDefinition.fromString("\\DOTSB\\;\\Longrightarrow\\;"));
  defineMacro("\\impliedby",
      MacroDefinition.fromString("\\DOTSB\\;\\Longleftarrow\\;"));

// AMSMath's automatic \dots, based on \mdots@@ macro.
  const dotsByToken = {
    ',': '\\dotsc',
    '\\not': '\\dotsb',
    // \keybin@ checks for the following:
    '+': '\\dotsb',
    '=': '\\dotsb',
    '<': '\\dotsb',
    '>': '\\dotsb',
    '-': '\\dotsb',
    '*': '\\dotsb',
    ':': '\\dotsb',
    // Symbols whose definition starts with \DOTSB:
    '\\DOTSB': '\\dotsb',
    '\\coprod': '\\dotsb',
    '\\bigvee': '\\dotsb',
    '\\bigwedge': '\\dotsb',
    '\\biguplus': '\\dotsb',
    '\\bigcap': '\\dotsb',
    '\\bigcup': '\\dotsb',
    '\\prod': '\\dotsb',
    '\\sum': '\\dotsb',
    '\\bigotimes': '\\dotsb',
    '\\bigoplus': '\\dotsb',
    '\\bigodot': '\\dotsb',
    '\\bigsqcup': '\\dotsb',
    '\\And': '\\dotsb',
    '\\longrightarrow': '\\dotsb',
    '\\Longrightarrow': '\\dotsb',
    '\\longleftarrow': '\\dotsb',
    '\\Longleftarrow': '\\dotsb',
    '\\longleftrightarrow': '\\dotsb',
    '\\Longleftrightarrow': '\\dotsb',
    '\\mapsto': '\\dotsb',
    '\\longmapsto': '\\dotsb',
    '\\hookrightarrow': '\\dotsb',
    '\\doteq': '\\dotsb',
    // Symbols whose definition starts with \mathbin:
    '\\mathbin': '\\dotsb',
    // Symbols whose definition starts with \mathrel:
    '\\mathrel': '\\dotsb',
    '\\relbar': '\\dotsb',
    '\\Relbar': '\\dotsb',
    '\\xrightarrow': '\\dotsb',
    '\\xleftarrow': '\\dotsb',
    // Symbols whose definition starts with \DOTSI:
    '\\DOTSI': '\\dotsi',
    '\\int': '\\dotsi',
    '\\oint': '\\dotsi',
    '\\iint': '\\dotsi',
    '\\iiint': '\\dotsi',
    '\\iiiint': '\\dotsi',
    '\\idotsint': '\\dotsi',
    // Symbols whose definition starts with \DOTSX:
    '\\DOTSX': '\\dotsx',
  };

  defineMacro("\\dots", MacroDefinition.fromCtxString((context) {
    // TODO: If used in text mode, should expand to \textellipsis.
    // However, in KaTeX, \textellipsis and \ldots behave the same
    // (in text mode), and it's unlikely we'd see any of the math commands
    // that affect the behavior of \dots when in text mode.  So fine for now
    // (until we support \ifmmode ... \else ... \fi).
    var thedots = '\\dotso';
    final next = context.expandAfterFuture().text;
    if (dotsByToken.containsKey(next)) {
      thedots = dotsByToken[next];
    } else if (next.substring(0, 4) == '\\not') {
      thedots = '\\dotsb';
    } else if (symbols[Mode.math].containsKey(next)) {
      if (['bin', 'rel'].contains(symbols[Mode.math][next].group)) {
        thedots = '\\dotsb';
      }
    }
    return thedots;
  }));

  const spaceAfterDots = {
    // \rightdelim@ checks for the following:
    ')': true,
    ']': true,
    '\\rbrack': true,
    '\\}': true,
    '\\rbrace': true,
    '\\rangle': true,
    '\\rceil': true,
    '\\rfloor': true,
    '\\rgroup': true,
    '\\rmoustache': true,
    '\\right': true,
    '\\bigr': true,
    '\\biggr': true,
    '\\Bigr': true,
    '\\Biggr': true,
    // \extra@ also tests for the following:
    '\$': true,
    // \extrap@ checks for the following:
    ';': true,
    '.': true,
    ',': true,
  };

  defineMacro("\\dotso", MacroDefinition.fromCtxString((context) {
    final next = context.future().text;
    if (spaceAfterDots.containsKey(next)) {
      return "\\ldots\\,";
    } else {
      return "\\ldots";
    }
  }));

  defineMacro("\\dotsc", MacroDefinition.fromCtxString((context) {
    final next = context.future().text;
    // \dotsc uses \extra@ but not \extrap@, instead specially checking for
    // ';' and '.', but doesn't check for ','.
    if (spaceAfterDots.containsKey(next) && next != ',') {
      return "\\ldots\\,";
    } else {
      return "\\ldots";
    }
  }));

  defineMacro("\\cdots", MacroDefinition.fromCtxString((context) {
    final next = context.future().text;
    if (spaceAfterDots.containsKey(next)) {
      return "\\@cdots\\,";
    } else {
      return "\\@cdots";
    }
  }));

  defineMacro("\\dotsb", MacroDefinition.fromString("\\cdots"));
  defineMacro("\\dotsm", MacroDefinition.fromString("\\cdots"));
  defineMacro("\\dotsi", MacroDefinition.fromString("\\!\\cdots"));
// amsmath doesn't actually define \dotsx, but \dots followed by a macro
// starting with \DOTSX implies \dotso, and then \extra@ detects this case
// and forces the added '\,'.
  defineMacro("\\dotsx", MacroDefinition.fromString("\\ldots\\,"));

// \let\DOTSI\relax
// \let\DOTSB\relax
// \let\DOTSX\relax
  defineMacro("\\DOTSI", MacroDefinition.fromString("\\relax"));
  defineMacro("\\DOTSB", MacroDefinition.fromString("\\relax"));
  defineMacro("\\DOTSX", MacroDefinition.fromString("\\relax"));

// Spacing, based on amsmath.sty's override of LaTeX defaults
// \DeclareRobustCommand{\tmspace}[3]{%
//   \ifmmode\mskip#1#2\else\kern#1#3\fi\relax}
  defineMacro(
      "\\tmspace",
      MacroDefinition.fromString(
          "\\TextOrMath{\\kern#1#3}{\\mskip#1#2}\\relax"));
// \renewcommand{\,}{\tmspace+\thinmuskip{.1667em}}
// TODO: math mode should use \thinmuskip
  defineMacro("\\,", MacroDefinition.fromString("\\tmspace+{3mu}{.1667em}"));
// \let\thinspace\,
  defineMacro("\\thinspace", MacroDefinition.fromString("\\,"));
// \def\>{\mskip\medmuskip}
// \renewcommand{\:}{\tmspace+\medmuskip{.2222em}}
// TODO: \> and math mode of \: should use \medmuskip = 4mu plus 2mu minus 4mu
  defineMacro("\\>", MacroDefinition.fromString("\\mskip{4mu}"));
  defineMacro("\\:", MacroDefinition.fromString("\\tmspace+{4mu}{.2222em}"));
// \let\medspace\:
  defineMacro("\\medspace", MacroDefinition.fromString("\\:"));
// \renewcommand{\;}{\tmspace+\thickmuskip{.2777em}}
// TODO: math mode should use \thickmuskip = 5mu plus 5mu
  defineMacro("\\;", MacroDefinition.fromString("\\tmspace+{5mu}{.2777em}"));
// \let\thickspace\;
  defineMacro("\\thickspace", MacroDefinition.fromString("\\;"));
// \renewcommand{\!}{\tmspace-\thinmuskip{.1667em}}
// TODO: math mode should use \thinmuskip
  defineMacro("\\!", MacroDefinition.fromString("\\tmspace-{3mu}{.1667em}"));
// \let\negthinspace\!
  defineMacro("\\negthinspace", MacroDefinition.fromString("\\!"));
// \newcommand{\negmedspace}{\tmspace-\medmuskip{.2222em}}
// TODO: math mode should use \medmuskip
  defineMacro(
      "\\negmedspace", MacroDefinition.fromString("\\tmspace-{4mu}{.2222em}"));
// \newcommand{\negthickspace}{\tmspace-\thickmuskip{.2777em}}
// TODO: math mode should use \thickmuskip
  defineMacro(
      "\\negthickspace", MacroDefinition.fromString("\\tmspace-{5mu}{.277em}"));
// \def\enspace{\kern.5em }
  defineMacro("\\enspace", MacroDefinition.fromString("\\kern.5em "));
// \def\enskip{\hskip.5em\relax}
  defineMacro("\\enskip", MacroDefinition.fromString("\\hskip.5em\\relax"));
// \def\quad{\hskip1em\relax}
  defineMacro("\\quad", MacroDefinition.fromString("\\hskip1em\\relax"));
// \def\qquad{\hskip2em\relax}
  defineMacro("\\qquad", MacroDefinition.fromString("\\hskip2em\\relax"));

// \tag@in@display form of \tag
  defineMacro(
      "\\tag", MacroDefinition.fromString("\\@ifstar\\tag@literal\\tag@paren"));
  defineMacro(
      "\\tag@paren", MacroDefinition.fromString("\\tag@literal{({#1})}"));
  defineMacro("\\tag@literal", MacroDefinition.fromCtxString((context) {
    if (context.macros.get("\\df@tag") != null) {
      throw ParseError("Multiple \\tag");
    }
    return "\\gdef\\df@tag{\\text{#1}}";
  }));

// \renewcommand{\bmod}{\nonscript\mskip-\medmuskip\mkern5mu\mathbin
//   {\operator@font mod}\penalty900
//   \mkern5mu\nonscript\mskip-\medmuskip}
// \newcommand{\pod}[1]{\allowbreak
//   \if@display\mkern18mu\else\mkern8mu\fi(#1)}
// \renewcommand{\pmod}[1]{\pod{{\operator@font mod}\mkern6mu#1}}
// \newcommand{\mod}[1]{\allowbreak\if@display\mkern18mu
//   \else\mkern12mu\fi{\operator@font mod}\,\,#1}
// TODO: math mode should use \medmuskip = 4mu plus 2mu minus 4mu
  defineMacro(
      "\\bmod",
      MacroDefinition.fromString(
          "\\mathchoice{\\mskip1mu}{\\mskip1mu}{\\mskip5mu}{\\mskip5mu}"
          "\\mathbin{\\rm mod}"
          "\\mathchoice{\\mskip1mu}{\\mskip1mu}{\\mskip5mu}{\\mskip5mu}"));
  defineMacro(
      "\\pod",
      MacroDefinition.fromString("\\allowbreak"
          "\\mathchoice{\\mkern18mu}{\\mkern8mu}{\\mkern8mu}{\\mkern8mu}(#1)"));
  defineMacro(
      "\\pmod", MacroDefinition.fromString("\\pod{{\\rm mod}\\mkern6mu#1}"));
  defineMacro(
      "\\mod",
      MacroDefinition.fromString("\\allowbreak"
          "\\mathchoice{\\mkern18mu}{\\mkern12mu}{\\mkern12mu}{\\mkern12mu}"
          "{\\rm mod}\\,\\,#1"));

// \pmb    --   A simulation of bold.
// The version in ambsy.sty works by typesetting three copies of the argument
// with small offsets. We use two copies. We omit the vertical offset because
// of rendering problems that makeVList encounters in Safari.
  defineMacro(
      "\\pmb",
      MacroDefinition.fromString("\\html@mathml{"
          "\\@binrel{#1}{\\mathrlap{#1}\\kern0.5px#1}}"
          "{\\mathbf{#1}}"));

//////////////////////////////////////////////////////////////////////
// LaTeX source2e

// \\ defaults to \newline, but changes to \cr within array environment
  defineMacro("\\\\", MacroDefinition.fromString("\\newline"));

// \def\TeX{T\kern-.1667em\lower.5ex\hbox{E}\kern-.125emX\@}
// TODO: Doesn't normally work in math mode because \@ fails.  KaTeX doesn't
// support \@ yet, so that's omitted, and we add \text so that the result
// doesn't look funny in math mode.
  defineMacro(
      "\\TeX",
      MacroDefinition.fromString("\\textrm{\\html@mathml{"
          "T\\kern-.1667em\\raisebox{-.5ex}{E}\\kern-.125emX"
          "}{TeX}}"));

// \DeclareRobustCommand{\LaTeX}{L\kern-.36em%
//         {\sbox\z@ T%
//          \vbox to\ht\z@{\hbox{\check@mathfonts
//                               \fontsize\sf@size\z@
//                               \math@fontsfalse\selectfont
//                               A}%
//                         \vss}%
//         }%
//         \kern-.15em%
//         \TeX}
// This code aligns the top of the A with the T (from the perspective of TeX's
// boxes, though visually the A appears to extend above slightly).
// We compute the corresponding \raisebox when A is rendered in \normalsize
// \scriptstyle, which has a scale factor of 0.7 (see Options.js).
  final latexRaiseA =
      '${fontMetricsData['Main-Regular']["T".codeUnitAt(0)][1] - 0.7 * fontMetricsData['Main-Regular']["A".codeUnitAt(0)][1]}em';
  defineMacro(
      "\\LaTeX",
      MacroDefinition.fromString("\\textrm{\\html@mathml{"
          'L\\kern-.36em\\raisebox{$latexRaiseA}{\\scriptstyle A}'
          "\\kern-.15em\\TeX}{LaTeX}}"));

// KaTeX logo based on tweaking LaTeX logo
  defineMacro(
      "\\KaTeX",
      MacroDefinition.fromString("\\textrm{\\html@mathml{"
          'K\\kern-.17em\\raisebox{$latexRaiseA}{\\scriptstyle A}'
          "\\kern-.15em\\TeX}{KaTeX}}"));

// \DeclareRobustCommand\hspace{\@ifstar\@hspacer\@hspace}
// \def\@hspace#1{\hskip  #1\relax}
// \def\@hspacer#1{\vrule \@width\z@\nobreak
//                 \hskip #1\hskip \z@skip}
  defineMacro(
      "\\hspace", MacroDefinition.fromString("\\@ifstar\\@hspacer\\@hspace"));
  defineMacro("\\@hspace", MacroDefinition.fromString("\\hskip #1\\relax"));
  defineMacro("\\@hspacer",
      MacroDefinition.fromString("\\rule{0pt}{0pt}\\hskip #1\\relax"));

//////////////////////////////////////////////////////////////////////
// mathtools.sty

//\providecommand\ordinarycolon{:}
  defineMacro("\\ordinarycolon", MacroDefinition.fromString(":"));
//\def\vcentcolon{\mathrel{\mathop\ordinarycolon}}
//TODO(edemaine): Not yet centered. Fix via \raisebox or #726
  defineMacro("\\vcentcolon",
      MacroDefinition.fromString("\\mathrel{\\mathop\\ordinarycolon}"));
// \providecommand*\dblcolon{\vcentcolon\mathrel{\mkern-.9mu}\vcentcolon}
  defineMacro(
      "\\dblcolon",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\vcentcolon\\mathrel{\\mkern-.9mu}\\vcentcolon}}"
          "{\\mathop{\\char\"2237}}"));
// \providecommand*\coloneqq{\vcentcolon\mathrel{\mkern-1.2mu}=}
  defineMacro(
      "\\coloneqq",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}=}}"
          "{\\mathop{\\char\"2254}}")); // ≔
// \providecommand*\Coloneqq{\dblcolon\mathrel{\mkern-1.2mu}=}
  defineMacro(
      "\\Coloneqq",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}=}}"
          "{\\mathop{\\char\"2237\\char\"3d}}"));
// \providecommand*\coloneq{\vcentcolon\mathrel{\mkern-1.2mu}\mathrel{-}}
  defineMacro(
      "\\coloneq",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}\\mathrel{-}}}"
          "{\\mathop{\\char\"3a\\char\"2212}}"));
// \providecommand*\Coloneq{\dblcolon\mathrel{\mkern-1.2mu}\mathrel{-}}
  defineMacro(
      "\\Coloneq",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}\\mathrel{-}}}"
          "{\\mathop{\\char\"2237\\char\"2212}}"));
// \providecommand*\eqqcolon{=\mathrel{\mkern-1.2mu}\vcentcolon}
  defineMacro(
      "\\eqqcolon",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{=\\mathrel{\\mkern-1.2mu}\\vcentcolon}}"
          "{\\mathop{\\char\"2255}}")); // ≕
// \providecommand*\Eqqcolon{=\mathrel{\mkern-1.2mu}\dblcolon}
  defineMacro(
      "\\Eqqcolon",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{=\\mathrel{\\mkern-1.2mu}\\dblcolon}}"
          "{\\mathop{\\char\"3d\\char\"2237}}"));
// \providecommand*\eqcolon{\mathrel{-}\mathrel{\mkern-1.2mu}\vcentcolon}
  defineMacro(
      "\\eqcolon",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\mathrel{-}\\mathrel{\\mkern-1.2mu}\\vcentcolon}}"
          "{\\mathop{\\char\"2239}}"));
// \providecommand*\Eqcolon{\mathrel{-}\mathrel{\mkern-1.2mu}\dblcolon}
  defineMacro(
      "\\Eqcolon",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\mathrel{-}\\mathrel{\\mkern-1.2mu}\\dblcolon}}"
          "{\\mathop{\\char\"2212\\char\"2237}}"));
// \providecommand*\colonapprox{\vcentcolon\mathrel{\mkern-1.2mu}\approx}
  defineMacro(
      "\\colonapprox",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}\\approx}}"
          "{\\mathop{\\char\"3a\\char\"2248}}"));
// \providecommand*\Colonapprox{\dblcolon\mathrel{\mkern-1.2mu}\approx}
  defineMacro(
      "\\Colonapprox",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}\\approx}}"
          "{\\mathop{\\char\"2237\\char\"2248}}"));
// \providecommand*\colonsim{\vcentcolon\mathrel{\mkern-1.2mu}\sim}
  defineMacro(
      "\\colonsim",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\vcentcolon\\mathrel{\\mkern-1.2mu}\\sim}}"
          "{\\mathop{\\char\"3a\\char\"223c}}"));
// \providecommand*\Colonsim{\dblcolon\mathrel{\mkern-1.2mu}\sim}
  defineMacro(
      "\\Colonsim",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathrel{\\dblcolon\\mathrel{\\mkern-1.2mu}\\sim}}"
          "{\\mathop{\\char\"2237\\char\"223c}}"));

// Some Unicode characters are implemented with macros to mathtools functions.
  defineMacro("\u2237", MacroDefinition.fromString("\\dblcolon")); // ::
  defineMacro("\u2239", MacroDefinition.fromString("\\eqcolon")); // -:
  defineMacro("\u2254", MacroDefinition.fromString("\\coloneqq")); // :=
  defineMacro("\u2255", MacroDefinition.fromString("\\eqqcolon")); // =:
  defineMacro("\u2A74", MacroDefinition.fromString("\\Coloneqq")); // ::=

//////////////////////////////////////////////////////////////////////
// colonequals.sty

// Alternate names for mathtools's macros:
  defineMacro("\\ratio", MacroDefinition.fromString("\\vcentcolon"));
  defineMacro("\\coloncolon", MacroDefinition.fromString("\\dblcolon"));
  defineMacro("\\colonequals", MacroDefinition.fromString("\\coloneqq"));
  defineMacro("\\coloncolonequals", MacroDefinition.fromString("\\Coloneqq"));
  defineMacro("\\equalscolon", MacroDefinition.fromString("\\eqqcolon"));
  defineMacro("\\equalscoloncolon", MacroDefinition.fromString("\\Eqqcolon"));
  defineMacro("\\colonminus", MacroDefinition.fromString("\\coloneq"));
  defineMacro("\\coloncolonminus", MacroDefinition.fromString("\\Coloneq"));
  defineMacro("\\minuscolon", MacroDefinition.fromString("\\eqcolon"));
  defineMacro("\\minuscoloncolon", MacroDefinition.fromString("\\Eqcolon"));
// \colonapprox name is same in mathtools and colonequals.
  defineMacro(
      "\\coloncolonapprox", MacroDefinition.fromString("\\Colonapprox"));
// \colonsim name is same in mathtools and colonequals.
  defineMacro("\\coloncolonsim", MacroDefinition.fromString("\\Colonsim"));

// Additional macros, implemented by analogy with mathtools definitions:
  defineMacro(
      "\\simcolon",
      MacroDefinition.fromString(
          "\\mathrel{\\sim\\mathrel{\\mkern-1.2mu}\\vcentcolon}"));
  defineMacro(
      "\\simcoloncolon",
      MacroDefinition.fromString(
          "\\mathrel{\\sim\\mathrel{\\mkern-1.2mu}\\dblcolon}"));
  defineMacro(
      "\\approxcolon",
      MacroDefinition.fromString(
          "\\mathrel{\\approx\\mathrel{\\mkern-1.2mu}\\vcentcolon}"));
  defineMacro(
      "\\approxcoloncolon",
      MacroDefinition.fromString(
          "\\mathrel{\\approx\\mathrel{\\mkern-1.2mu}\\dblcolon}"));

// Present in newtxmath, pxfonts and txfonts
  defineMacro(
      "\\notni",
      MacroDefinition.fromString(
          "\\html@mathml{\\not\\ni}{\\mathrel{\\char`\u220C}}"));
  defineMacro("\\limsup",
      MacroDefinition.fromString("\\DOTSB\\operatorname*{lim\\,sup}"));
  defineMacro("\\liminf",
      MacroDefinition.fromString("\\DOTSB\\operatorname*{lim\\,inf}"));

//////////////////////////////////////////////////////////////////////
// MathML alternates for KaTeX glyphs in the Unicode private area
  defineMacro("\\gvertneqq",
      MacroDefinition.fromString("\\html@mathml{\\@gvertneqq}{\u2269}"));
  defineMacro("\\lvertneqq",
      MacroDefinition.fromString("\\html@mathml{\\@lvertneqq}{\u2268}"));
  defineMacro(
      "\\ngeqq", MacroDefinition.fromString("\\html@mathml{\\@ngeqq}{\u2271}"));
  defineMacro("\\ngeqslant",
      MacroDefinition.fromString("\\html@mathml{\\@ngeqslant}{\u2271}"));
  defineMacro(
      "\\nleqq", MacroDefinition.fromString("\\html@mathml{\\@nleqq}{\u2270}"));
  defineMacro("\\nleqslant",
      MacroDefinition.fromString("\\html@mathml{\\@nleqslant}{\u2270}"));
  defineMacro("\\nshortmid",
      MacroDefinition.fromString("\\html@mathml{\\@nshortmid}{∤}"));
  defineMacro("\\nshortparallel",
      MacroDefinition.fromString("\\html@mathml{\\@nshortparallel}{∦}"));
  defineMacro("\\nsubseteqq",
      MacroDefinition.fromString("\\html@mathml{\\@nsubseteqq}{\u2288}"));
  defineMacro("\\nsupseteqq",
      MacroDefinition.fromString("\\html@mathml{\\@nsupseteqq}{\u2289}"));
  defineMacro("\\varsubsetneq",
      MacroDefinition.fromString("\\html@mathml{\\@varsubsetneq}{⊊}"));
  defineMacro("\\varsubsetneqq",
      MacroDefinition.fromString("\\html@mathml{\\@varsubsetneqq}{⫋}"));
  defineMacro("\\varsupsetneq",
      MacroDefinition.fromString("\\html@mathml{\\@varsupsetneq}{⊋}"));
  defineMacro("\\varsupsetneqq",
      MacroDefinition.fromString("\\html@mathml{\\@varsupsetneqq}{⫌}"));

//////////////////////////////////////////////////////////////////////
// stmaryrd and semantic

// The stmaryrd and semantic packages render the next four items by calling a
// glyph. Those glyphs do not exist in the KaTeX fonts. Hence the macros.

  defineMacro(
      "\\llbracket",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathopen{[\\mkern-3.2mu[}}"
          "{\\mathopen{\\char`\u27e6}}"));
  defineMacro(
      "\\rrbracket",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathclose{]\\mkern-3.2mu]}}"
          "{\\mathclose{\\char`\u27e7}}"));

  defineMacro(
      "\u27e6", MacroDefinition.fromString("\\llbracket")); // blackboard bold [
  defineMacro(
      "\u27e7", MacroDefinition.fromString("\\rrbracket")); // blackboard bold ]

  defineMacro(
      "\\lBrace",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathopen{\\{\\mkern-3.2mu[}}"
          "{\\mathopen{\\char`\u2983}}"));
  defineMacro(
      "\\rBrace",
      MacroDefinition.fromString("\\html@mathml{"
          "\\mathclose{]\\mkern-3.2mu\\}}}"
          "{\\mathclose{\\char`\u2984}}"));

  defineMacro(
      "\u2983", MacroDefinition.fromString("\\lBrace")); // blackboard bold {
  defineMacro(
      "\u2984", MacroDefinition.fromString("\\rBrace")); // blackboard bold }

// TODO: Create variable sized versions of the last two items. I believe that
// will require font glyphs.

//////////////////////////////////////////////////////////////////////
// texvc.sty

// The texvc package contains macros available in mediawiki pages.
// We omit the functions deprecated at
// https://en.wikipedia.org/wiki/Help:Displaying_a_formula#Deprecated_syntax

// We also omit texvc's \O, which conflicts with \text{\O}

  defineMacro("\\darr", MacroDefinition.fromString("\\downarrow"));
  defineMacro("\\dArr", MacroDefinition.fromString("\\Downarrow"));
  defineMacro("\\Darr", MacroDefinition.fromString("\\Downarrow"));
  defineMacro("\\lang", MacroDefinition.fromString("\\langle"));
  defineMacro("\\rang", MacroDefinition.fromString("\\rangle"));
  defineMacro("\\uarr", MacroDefinition.fromString("\\uparrow"));
  defineMacro("\\uArr", MacroDefinition.fromString("\\Uparrow"));
  defineMacro("\\Uarr", MacroDefinition.fromString("\\Uparrow"));
  defineMacro("\\N", MacroDefinition.fromString("\\mathbb{N}"));
  defineMacro("\\R", MacroDefinition.fromString("\\mathbb{R}"));
  defineMacro("\\Z", MacroDefinition.fromString("\\mathbb{Z}"));
  defineMacro("\\alef", MacroDefinition.fromString("\\aleph"));
  defineMacro("\\alefsym", MacroDefinition.fromString("\\aleph"));
  defineMacro("\\Alpha", MacroDefinition.fromString("\\mathrm{A}"));
  defineMacro("\\Beta", MacroDefinition.fromString("\\mathrm{B}"));
  defineMacro("\\bull", MacroDefinition.fromString("\\bullet"));
  defineMacro("\\Chi", MacroDefinition.fromString("\\mathrm{X}"));
  defineMacro("\\clubs", MacroDefinition.fromString("\\clubsuit"));
  defineMacro("\\cnums", MacroDefinition.fromString("\\mathbb{C}"));
  defineMacro("\\Complex", MacroDefinition.fromString("\\mathbb{C}"));
  defineMacro("\\Dagger", MacroDefinition.fromString("\\ddagger"));
  defineMacro("\\diamonds", MacroDefinition.fromString("\\diamondsuit"));
  defineMacro("\\empty", MacroDefinition.fromString("\\emptyset"));
  defineMacro("\\Epsilon", MacroDefinition.fromString("\\mathrm{E}"));
  defineMacro("\\Eta", MacroDefinition.fromString("\\mathrm{H}"));
  defineMacro("\\exist", MacroDefinition.fromString("\\exists"));
  defineMacro("\\harr", MacroDefinition.fromString("\\leftrightarrow"));
  defineMacro("\\hArr", MacroDefinition.fromString("\\Leftrightarrow"));
  defineMacro("\\Harr", MacroDefinition.fromString("\\Leftrightarrow"));
  defineMacro("\\hearts", MacroDefinition.fromString("\\heartsuit"));
  defineMacro("\\image", MacroDefinition.fromString("\\Im"));
  defineMacro("\\infin", MacroDefinition.fromString("\\infty"));
  defineMacro("\\Iota", MacroDefinition.fromString("\\mathrm{I}"));
  defineMacro("\\isin", MacroDefinition.fromString("\\in"));
  defineMacro("\\Kappa", MacroDefinition.fromString("\\mathrm{K}"));
  defineMacro("\\larr", MacroDefinition.fromString("\\leftarrow"));
  defineMacro("\\lArr", MacroDefinition.fromString("\\Leftarrow"));
  defineMacro("\\Larr", MacroDefinition.fromString("\\Leftarrow"));
  defineMacro("\\lrarr", MacroDefinition.fromString("\\leftrightarrow"));
  defineMacro("\\lrArr", MacroDefinition.fromString("\\Leftrightarrow"));
  defineMacro("\\Lrarr", MacroDefinition.fromString("\\Leftrightarrow"));
  defineMacro("\\Mu", MacroDefinition.fromString("\\mathrm{M}"));
  defineMacro("\\natnums", MacroDefinition.fromString("\\mathbb{N}"));
  defineMacro("\\Nu", MacroDefinition.fromString("\\mathrm{N}"));
  defineMacro("\\Omicron", MacroDefinition.fromString("\\mathrm{O}"));
  defineMacro("\\plusmn", MacroDefinition.fromString("\\pm"));
  defineMacro("\\rarr", MacroDefinition.fromString("\\rightarrow"));
  defineMacro("\\rArr", MacroDefinition.fromString("\\Rightarrow"));
  defineMacro("\\Rarr", MacroDefinition.fromString("\\Rightarrow"));
  defineMacro("\\real", MacroDefinition.fromString("\\Re"));
  defineMacro("\\reals", MacroDefinition.fromString("\\mathbb{R}"));
  defineMacro("\\Reals", MacroDefinition.fromString("\\mathbb{R}"));
  defineMacro("\\Rho", MacroDefinition.fromString("\\mathrm{P}"));
  defineMacro("\\sdot", MacroDefinition.fromString("\\cdot"));
  defineMacro("\\sect", MacroDefinition.fromString("\\S"));
  defineMacro("\\spades", MacroDefinition.fromString("\\spadesuit"));
  defineMacro("\\sub", MacroDefinition.fromString("\\subset"));
  defineMacro("\\sube", MacroDefinition.fromString("\\subseteq"));
  defineMacro("\\supe", MacroDefinition.fromString("\\supseteq"));
  defineMacro("\\Tau", MacroDefinition.fromString("\\mathrm{T}"));
  defineMacro("\\thetasym", MacroDefinition.fromString("\\vartheta"));
// TODO: defineMacro("\\varcoppa", MacroDefinition.fromString("\\\mbox{\\coppa}"));
  defineMacro("\\weierp", MacroDefinition.fromString("\\wp"));
  defineMacro("\\Zeta", MacroDefinition.fromString("\\mathrm{Z}"));

//////////////////////////////////////////////////////////////////////
// statmath.sty
// https://ctan.math.illinois.edu/macros/latex/contrib/statmath/statmath.pdf

  defineMacro("\\argmin",
      MacroDefinition.fromString("\\DOTSB\\operatorname*{arg\\,min}"));
  defineMacro("\\argmax",
      MacroDefinition.fromString("\\DOTSB\\operatorname*{arg\\,max}"));
  defineMacro(
      "\\plim",
      MacroDefinition.fromString(
          "\\DOTSB\\mathop{\\operatorname{plim}}\\limits"));

//////////////////////////////////////////////////////////////////////
// braket.sty
// http://ctan.math.washington.edu/tex-archive/macros/latex/contrib/braket/braket.pdf

  defineMacro(
      "\\bra", MacroDefinition.fromString("\\mathinner{\\langle{#1}|}"));
  defineMacro(
      "\\ket", MacroDefinition.fromString("\\mathinner{|{#1}\\rangle}"));
  defineMacro("\\braket",
      MacroDefinition.fromString("\\mathinner{\\langle{#1}\\rangle}"));
  defineMacro("\\Bra", MacroDefinition.fromString("\\left\\langle#1\\right|"));
  defineMacro("\\Ket", MacroDefinition.fromString("\\left|#1\\right\\rangle"));

// Custom Khan Academy colors, should be moved to an optional package
  defineMacro(
      "\\blue", MacroDefinition.fromString("\\textcolor{##6495ed}{#1}"));
  defineMacro(
      "\\orange", MacroDefinition.fromString("\\textcolor{##ffa500}{#1}"));
  defineMacro(
      "\\pink", MacroDefinition.fromString("\\textcolor{##ff00af}{#1}"));
  defineMacro("\\red", MacroDefinition.fromString("\\textcolor{##df0030}{#1}"));
  defineMacro(
      "\\green", MacroDefinition.fromString("\\textcolor{##28ae7b}{#1}"));
  defineMacro("\\gray", MacroDefinition.fromString("\\textcolor{gray}{#1}"));
  defineMacro(
      "\\purple", MacroDefinition.fromString("\\textcolor{##9d38bd}{#1}"));
  defineMacro(
      "\\blueA", MacroDefinition.fromString("\\textcolor{##ccfaff}{#1}"));
  defineMacro(
      "\\blueB", MacroDefinition.fromString("\\textcolor{##80f6ff}{#1}"));
  defineMacro(
      "\\blueC", MacroDefinition.fromString("\\textcolor{##63d9ea}{#1}"));
  defineMacro(
      "\\blueD", MacroDefinition.fromString("\\textcolor{##11accd}{#1}"));
  defineMacro(
      "\\blueE", MacroDefinition.fromString("\\textcolor{##0c7f99}{#1}"));
  defineMacro(
      "\\tealA", MacroDefinition.fromString("\\textcolor{##94fff5}{#1}"));
  defineMacro(
      "\\tealB", MacroDefinition.fromString("\\textcolor{##26edd5}{#1}"));
  defineMacro(
      "\\tealC", MacroDefinition.fromString("\\textcolor{##01d1c1}{#1}"));
  defineMacro(
      "\\tealD", MacroDefinition.fromString("\\textcolor{##01a995}{#1}"));
  defineMacro(
      "\\tealE", MacroDefinition.fromString("\\textcolor{##208170}{#1}"));
  defineMacro(
      "\\greenA", MacroDefinition.fromString("\\textcolor{##b6ffb0}{#1}"));
  defineMacro(
      "\\greenB", MacroDefinition.fromString("\\textcolor{##8af281}{#1}"));
  defineMacro(
      "\\greenC", MacroDefinition.fromString("\\textcolor{##74cf70}{#1}"));
  defineMacro(
      "\\greenD", MacroDefinition.fromString("\\textcolor{##1fab54}{#1}"));
  defineMacro(
      "\\greenE", MacroDefinition.fromString("\\textcolor{##0d923f}{#1}"));
  defineMacro(
      "\\goldA", MacroDefinition.fromString("\\textcolor{##ffd0a9}{#1}"));
  defineMacro(
      "\\goldB", MacroDefinition.fromString("\\textcolor{##ffbb71}{#1}"));
  defineMacro(
      "\\goldC", MacroDefinition.fromString("\\textcolor{##ff9c39}{#1}"));
  defineMacro(
      "\\goldD", MacroDefinition.fromString("\\textcolor{##e07d10}{#1}"));
  defineMacro(
      "\\goldE", MacroDefinition.fromString("\\textcolor{##a75a05}{#1}"));
  defineMacro(
      "\\redA", MacroDefinition.fromString("\\textcolor{##fca9a9}{#1}"));
  defineMacro(
      "\\redB", MacroDefinition.fromString("\\textcolor{##ff8482}{#1}"));
  defineMacro(
      "\\redC", MacroDefinition.fromString("\\textcolor{##f9685d}{#1}"));
  defineMacro(
      "\\redD", MacroDefinition.fromString("\\textcolor{##e84d39}{#1}"));
  defineMacro(
      "\\redE", MacroDefinition.fromString("\\textcolor{##bc2612}{#1}"));
  defineMacro(
      "\\maroonA", MacroDefinition.fromString("\\textcolor{##ffbde0}{#1}"));
  defineMacro(
      "\\maroonB", MacroDefinition.fromString("\\textcolor{##ff92c6}{#1}"));
  defineMacro(
      "\\maroonC", MacroDefinition.fromString("\\textcolor{##ed5fa6}{#1}"));
  defineMacro(
      "\\maroonD", MacroDefinition.fromString("\\textcolor{##ca337c}{#1}"));
  defineMacro(
      "\\maroonE", MacroDefinition.fromString("\\textcolor{##9e034e}{#1}"));
  defineMacro(
      "\\purpleA", MacroDefinition.fromString("\\textcolor{##ddd7ff}{#1}"));
  defineMacro(
      "\\purpleB", MacroDefinition.fromString("\\textcolor{##c6b9fc}{#1}"));
  defineMacro(
      "\\purpleC", MacroDefinition.fromString("\\textcolor{##aa87ff}{#1}"));
  defineMacro(
      "\\purpleD", MacroDefinition.fromString("\\textcolor{##7854ab}{#1}"));
  defineMacro(
      "\\purpleE", MacroDefinition.fromString("\\textcolor{##543b78}{#1}"));
  defineMacro(
      "\\mintA", MacroDefinition.fromString("\\textcolor{##f5f9e8}{#1}"));
  defineMacro(
      "\\mintB", MacroDefinition.fromString("\\textcolor{##edf2df}{#1}"));
  defineMacro(
      "\\mintC", MacroDefinition.fromString("\\textcolor{##e0e5cc}{#1}"));
  defineMacro(
      "\\grayA", MacroDefinition.fromString("\\textcolor{##f6f7f7}{#1}"));
  defineMacro(
      "\\grayB", MacroDefinition.fromString("\\textcolor{##f0f1f2}{#1}"));
  defineMacro(
      "\\grayC", MacroDefinition.fromString("\\textcolor{##e3e5e6}{#1}"));
  defineMacro(
      "\\grayD", MacroDefinition.fromString("\\textcolor{##d6d8da}{#1}"));
  defineMacro(
      "\\grayE", MacroDefinition.fromString("\\textcolor{##babec2}{#1}"));
  defineMacro(
      "\\grayF", MacroDefinition.fromString("\\textcolor{##888d93}{#1}"));
  defineMacro(
      "\\grayG", MacroDefinition.fromString("\\textcolor{##626569}{#1}"));
  defineMacro(
      "\\grayH", MacroDefinition.fromString("\\textcolor{##3b3e40}{#1}"));
  defineMacro(
      "\\grayI", MacroDefinition.fromString("\\textcolor{##21242c}{#1}"));
  defineMacro(
      "\\kaBlue", MacroDefinition.fromString("\\textcolor{##314453}{#1}"));
  defineMacro(
      "\\kaGreen", MacroDefinition.fromString("\\textcolor{##71B307}{#1}"));
}
