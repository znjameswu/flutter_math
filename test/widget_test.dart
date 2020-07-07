import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';

import 'load_fonts.dart';

void main() {
  setUpAll(loadKaTeXFonts);
  group('Flutter Math', () {
    testWidgets('Should show default error message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: FlutterMath.fromTexString(r'\Gaarbled$')),
        ),
      );
      final finder = find.byType(Text);
      expect(finder, findsOneWidget);
      expect(
          (finder.evaluate().single.widget as Text)
              .data
              .startsWith('parser error'),
          isTrue);
    });
    testWidgets('Should show onErrorFallback widget', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FlutterMath.fromTexString(
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
