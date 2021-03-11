import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';

import 'load_fonts.dart';

void main() {
  setUpAll(loadKaTeXFonts);
  group('Flutter Math', () {
    testWidgets('Should show default error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Math.tex(r'\Gaarbled$')),
        ),
      );
      final finder = find.byType(SelectableText);
      expect(finder, findsOneWidget);
      expect(
          (finder.evaluate().single.widget as SelectableText)
              .data!
              .startsWith('Parser Error:'),
          isTrue);
    });
    testWidgets('Should show onErrorFallback widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Math.tex(
              r'\Gaarbled$',
              onErrorFallback: (_) => Container(
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      );
      final finder = find.byType(Container);
      expect(finder, findsOneWidget);
    });
  });
}
