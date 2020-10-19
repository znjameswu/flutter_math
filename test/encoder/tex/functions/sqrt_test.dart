import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_math/src/ast/nodes/accent_under.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_math/src/encoder/tex/encoder.dart';

import '../recode.dart';

void main() {
  group('SqrtNode encoding', () {
    test('general encoding', () {
      const testStrings = [
        '\\sqrt{a}',
        '\\sqrt[a]{b}',
      ];
      for (final testString in testStrings) {
        expect(recodeTex(testString), testString);
      }
    });
  });
}
