import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_math/src/ast/nodes/left_right.dart';
import 'package:flutter_math/src/ast/nodes/symbol.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_math/src/encoder/tex/encoder.dart';

import '../recode.dart';

void main() {
  group('LeftRight encoding test', () {
    test('general encoding', () {
      final node1 = LeftRightNode(
        leftDelim: '(',
        rightDelim: '}',
        body: [
          EquationRowNode(children: [SymbolNode(symbol: 'a')])
        ],
      );
      expect(node1.encodeTeX(), '\\left(a\\right\\}');

      const testStrings = [
        '\\left.a\\middle|b\\middle.c\\right)',
      ];
      for (final testString in testStrings) {
        expect(recodeTex(testString), testString);
      }
    });
  });
}
