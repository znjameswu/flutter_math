import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_math/src/parser/tex/parse_error.dart';
import 'package:flutter_math/src/parser/tex/parser.dart';
import 'package:flutter_math/src/parser/tex/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void testTexToMatchGoldenFile(
  String description,
  String expression, {
  String location,
  double scale = 1,
}) {
  testWidgets(description, (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue =
        Size(500 * scale, 300 * scale);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterMath.fromTexString(
                  expression,
                  options: Options(
                    style: MathStyle.display,
                    baseSizeMultiplier: scale,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (Platform.isWindows) {
      // Android-specific code
      await expectLater(find.byType(FlutterMath),
          matchesGoldenFile(location ?? 'golden/${description.hashCode}.png'));
    }
  });
}

void testTexToRender(
  String description,
  String expression,
  Future<void> Function(WidgetTester) callback,
) {
  testWidgets(description, (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterMath.fromTexString(
                  expression,
                  options: Options(
                    style: MathStyle.display,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await callback(tester);
  });
}

void testTexToRenderLike(
    String description, String expression1, String expression2,
    [Settings settings = strictSettings]) {
  testWidgets(description, (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterMath.fromTexString(
                  expression1,
                  options: Options(
                    style: MathStyle.display,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (Platform.isWindows) {
      // Android-specific code
      await expectLater(find.byType(FlutterMath),
          matchesGoldenFile('golden/${description.hashCode}.png'));
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RepaintBoundary(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlutterMath.fromTexString(
                  expression2,
                  options: Options(
                    style: MathStyle.display,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    if (Platform.isWindows) {
      // Android-specific code
      await expectLater(find.byType(FlutterMath),
          matchesGoldenFile('golden/${description.hashCode}.png'));
    }
  });
}

const strictSettings = Settings(strict: Strict.error);
const nonStrictSettings = Settings(strict: Strict.ignore);

GreenNode getParsed(String expr, [Settings settings = const Settings()]) {
  return TexParser(expr, settings).parse();
}

String prettyPrintJson(Map<String, Object> a) =>
    JsonEncoder.withIndent('| ').convert(a);

_ToParse toParse([Settings settings = strictSettings]) => _ToParse(settings);

class _ToParse extends Matcher {
  final Settings settings;

  _ToParse(this.settings);

  @override
  Description describe(Description description) =>
      description.add('a TeX string can be parsed with default settings');

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    try {
      if (item is String) {
        TexParser(item, settings).parse();
        return super
            .describeMismatch(item, mismatchDescription, matchState, verbose);
      }
      return mismatchDescription.add('input is not a string');
    } on ParseError catch (e) {
      return mismatchDescription.add(e.message);
    } on Object catch (e) {
      return mismatchDescription.add(e.toString());
    }
  }

  @override
  bool matches(dynamic item, Map matchState) {
    try {
      if (item is String) {
        final res = TexParser(item, const Settings()).parse();
        // print(prettyPrintJson(res.toJson()));
        return true;
      }
      return false;
    } on ParseError catch (_) {
      return false;
    }
  }
}

_ToNotParse toNotParse() => _ToNotParse();

class _ToNotParse extends Matcher {
  @override
  Description describe(Description description) =>
      description.add('a TeX string with parse errors');

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    try {
      if (item is String) {
        final res = TexParser(item, const Settings()).parse();
        return super
            .describeMismatch(item, mismatchDescription, matchState, verbose);
        // return mismatchDescription.add(prettyPrintJson(res.toJson()));
      }
      return mismatchDescription.add('input is not a string');
    } on ParseError catch (e) {
      return super
          .describeMismatch(item, mismatchDescription, matchState, verbose);
    }
  }

  @override
  bool matches(dynamic item, Map matchState) {
    try {
      if (item is String) {
        final res = TexParser(item, const Settings()).parse();
        // print(prettyPrintJson(res.toJson()));
        return false;
      }
      return false;
    } on ParseError catch (_) {
      return true;
    }
  }
}

final toBuild = _ToBuild();

class _ToBuild extends Matcher {
  final Options options;

  _ToBuild([this.options = Options.displayOptions]);

  @override
  Description describe(Description description) =>
      description.add('a TeX string can be built into widgets');

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    try {
      if (item is String) {
        final node = TexParser(item, const Settings()).parse();
        // ignore: unused_local_variable
        final widget = SyntaxTree(greenRoot: node).buildWidget(options);
        return super
            .describeMismatch(item, mismatchDescription, matchState, verbose);
      }
      return mismatchDescription.add('input is not a string');
    } on ParseError catch (e) {
      return mismatchDescription.add(e.message);
    } on Object catch (e) {
      return mismatchDescription.add(e.toString());
    }
  }

  @override
  bool matches(dynamic item, Map matchState) {
    try {
      if (item is String) {
        final res = TexParser(item, const Settings()).parse();
        // print(prettyPrintJson(res.toJson()));
        return true;
      }
      return false;
    } on ParseError catch (_) {
      return false;
    }
  }
}
