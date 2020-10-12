import 'package:flutter_math/src/ast/nodes/symbol.dart';
import 'package:flutter_math/src/ast/syntax_tree.dart';
import 'package:flutter_math/src/ast/types.dart';
import 'package:flutter_math/src/parser/tex/parser.dart';
import 'package:flutter_math/src/parser/tex/settings.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_math/src/encoder/tex/encoder.dart';

String recode(String tex, [Mode mode = Mode.math]) {
  if (mode == Mode.text) {
    tex = '\\text{$tex}';
  }
  var node = TexParser(tex, const Settings()).parse().children.first;
  while (node is ParentableNode) {
    node = node.children.first;
  }
  assert(node is SymbolNode);
  return node.encodeTeX();
}

void main() {
  group('symbol encoding test', () {
    test('base math symbols', () {
      expect(recode('a'), 'a');
      expect(recode('0'), '0');
      expect(recode('\\pm'), '\\pm');
    });

    test('base text symbols', () {
      expect(recode('a'), 'a');
      expect(recode('0'), '0');
      expect(recode('\\dag'), '\\dag');
    });
  });
}
