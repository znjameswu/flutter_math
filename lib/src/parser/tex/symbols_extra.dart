// These symbols are migrated from elsewhere in KaTeX, e.g., macro

import '../../ast/syntax_tree.dart';
import '../../ast/types.dart';
import 'symbols.dart';

const extraTexSymbolCommandConfigs = {
  Mode.math: {
    // Stacked operator
    '\u2258': TexSymbolConfig('\u2258'),
    '\u2259': TexSymbolConfig('\u2259'),
    '\u225A': TexSymbolConfig('\u225A'),
    '\u225B': TexSymbolConfig('\u225B'),
    '\u225D': TexSymbolConfig('\u225D'),
    '\u225E': TexSymbolConfig('\u225E'),
    '\u225F': TexSymbolConfig('\u225F'),

    // Circled characters
    '\\copyright': TexSymbolConfig('\u00A9'), // ©

    // Negated relations
    '\\not': TexSymbolConfig('\u0338'),
    '\\neq': TexSymbolConfig('\u2260'),
    '\\notin': TexSymbolConfig('\u2209'),
    '\\notni': TexSymbolConfig('\u220C'),
    '\u2260': TexSymbolConfig('\u2260'),
    '\u2209': TexSymbolConfig('\u2209'),
    '\u220C': TexSymbolConfig('\u220C'),

    // colon
    '\\colon': TexSymbolConfig(':', type: AtomType.punct), // From MathJax

    // Composite characters
    '\\dblcolon': TexSymbolConfig('\u2237', type: AtomType.rel),
    '\\coloneqq': TexSymbolConfig('\u2254', type: AtomType.rel),
    '\\eqqcolon': TexSymbolConfig('\u2255', type: AtomType.rel),
    '\\eqcolon': TexSymbolConfig('\u2239', type: AtomType.rel),
    '\\llbracket': TexSymbolConfig('\u27e6', type: AtomType.open),
    '\\rrbracket': TexSymbolConfig('\u27e7', type: AtomType.close),
    '\\lBrace': TexSymbolConfig('\u2983', type: AtomType.open),
    '\\rBrace': TexSymbolConfig('\u2984', type: AtomType.close),

    // // Private KaTeX code point
    // '\\gvertneqq"': TexSymbolConfig('\u2269', type: AtomType.rel),
    // '\\lvertneqq"': TexSymbolConfig('\u2268', type: AtomType.rel),
    // '\\ngeqq",': TexSymbolConfig('\u2271', type: AtomType.rel),
    // '\\ngeqslant"': TexSymbolConfig('\u2271', type: AtomType.rel),
    // '\\nleqq",': TexSymbolConfig('\u2270', type: AtomType.rel),
    // '\\nleqslant"': TexSymbolConfig('\u2270', type: AtomType.rel),
    // '\\nshortmid"': TexSymbolConfig('∤', type: AtomType.rel),
    // '\\nshortparallel"': TexSymbolConfig('∦', type: AtomType.rel),
    // '\\nsubseteqq"': TexSymbolConfig('\u2288', type: AtomType.rel),
    // '\\nsupseteqq"': TexSymbolConfig('\u2289', type: AtomType.rel),
    // '\\varsubsetneq"': TexSymbolConfig('⊊', type: AtomType.rel),
    // '\\varsubsetneqq"': TexSymbolConfig('⫋', type: AtomType.rel),
    // '\\varsupsetneq"': TexSymbolConfig('⊋', type: AtomType.rel),
    // '\\varsupsetneqq"': TexSymbolConfig('⫌', type: AtomType.rel),
  },
  Mode.text: {
    '\\textcopyright': TexSymbolConfig('\u00A9'), // ©
    '\\textregistered': TexSymbolConfig('\u00AE'), // ®
  }
};
