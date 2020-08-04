import 'dart:convert';

// ignore_for_file: prefer_relative_imports
import 'package:flutter_math/src/parser/tex/parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_math/src/parser/tex/settings.dart';
import 'package:flutter_math/src/parser/unicode_math/fold.dart';

void main() {
  test('should work', () {
    final exp = r'(1)/2 /3/(4)';
    final parsed = TexParser(exp, Settings()).parse();
    final folded = foldOnce(parsed.children, parsed.children.length, 0);
    final json = folded.map((e) => e.toJson()).toList();
    print(JsonEncoder.withIndent('  ').convert(json));
  });
}

final testCases = {
  r'a/\sum\of a'
};