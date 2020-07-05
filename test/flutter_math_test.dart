// ignore_for_file: prefer_single_quotes
// Import the test package and Counter class
import 'dart:ui';

import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_math/src/ast/nodes/atom.dart';
import 'package:flutter_math/src/ast/nodes/frac.dart';
import 'package:flutter_math/src/ast/nodes/left_right.dart';
import 'package:flutter_math/src/ast/nodes/multiscripts.dart';
import 'package:flutter_math/src/ast/nodes/nary_op.dart';
import 'package:flutter_math/src/ast/nodes/style.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

// function\(\) \{   -> () {
// describe\("  -> group("
// it\("  -> test("
// Regex:
// expect(['"`])  ->  expect($1
// \(`([^`'\$]*)`([,\.])  ->  (r'$1'$2
// r(r'([^')'\$]*)`;  ->  r'$1';
// r(r'([^')'\$]*)`,  ->  r'$1',
// ([a-z^r]+)`([^`'\$]*)`  ->  $1(r'$2')
// \.(toparse\([^\)]*\))  ->  , $1)
// expect\((r?['"][^'"]*['"])\.toParseLike\((r?['"][^'"]*['"]), ([\S]*)\);  ->
// test\(("[ \S]+"), ?\(\) *\{\n *expect\(([^\)]*)\.toParseLike\(([^\)]*), ([\S]*)\);

void main() {
  group("A parser", () {
    test("should not fail on an empty string", () {
      expect(r'', toParse(strictSettings));
    });

    testTexToRenderLike(
        "should ignore whitespace", r'    x    y    ', "xy", strictSettings);

    testTexToRenderLike("should ignore whitespace in atom", r'    x   ^ y    ',
        "x^y", strictSettings);
  });

  group("An ord parser", () {
    final expression = "1234|/@.\"`abcdefgzABCDEFGZ";

    test("should not fail", () {
      expect(expression, toParse());
    });

    test("should build a list of ords", () {
      final parse = getParsed(expression);

      for (var i = 0; i < parse.children.length; i++) {
        final group = parse.children[i];
        expect(group, isA<AtomNode>());
        expect(group.leftType, AtomType.ord);
      }
    });

    test("should parse the right number of ords", () {
      final parse = getParsed(expression);

      expect(parse.children.length, expression.length);
    });
  });

  group("A bin parser", () {
    final expression = r'+-*\cdot\pm\div';

    test("should not fail", () {
      expect(expression, toParse());
    });

    test("should build a list of bins", () {
      final parse = getParsed(expression);

      for (var i = 0; i < parse.children.length; i++) {
        final group = parse.children[i];
        expect(group, isA<AtomNode>());
        expect(group.leftType, AtomType.bin);
      }
    });
  });

// group("A rel parser", () {
//     final expression = r'=<>\leq\geq\neq\nleq\ngeq\cong';
//     final notExpression = r'\not=\not<\not>\not\leq\not\geq\not\in';

//     test("should not fail", () {
//         expect(expression, toParse());
//         expect(notExpression, toParse());
//     });

//     test("should build a list of rels", () {
//         final parse = getParsed(expression);

//         for (var i = 0; i < parse.length; i++) {
//             var group = parse[i];
//             if (group.type === "htmlmathml") {
//                 expect(group.html.children.length, 1);
//                 group = group.html.children[0];
//             }
//             if (group.type === "mclass") {
//                 expect(group.mclass, "mrel");
//             } else {
//                 expect(group.type, "atom");
//                 expect(group.family, "rel");
//             }
//         }
//     });
// });

  group("A punct parser", () {
    final expression = ",;";

    test("should not fail", () {
      expect(expression, toParse(strictSettings));
    });

    test("should build a list of puncts", () {
      final parse = getParsed(expression);

      for (var i = 0; i < parse.children.length; i++) {
        final group = parse.children[i];
        expect(group, isA<AtomNode>());
        expect(group.leftType, AtomType.punct);
      }
    });
  });

  group("An open parser", () {
    final expression = "([";

    test("should not fail", () {
      expect(expression, toParse());
    });

    test("should build a list of opens", () {
      final parse = getParsed(expression);

      for (var i = 0; i < parse.children.length; i++) {
        final group = parse.children[i];
        expect(group, isA<AtomNode>());
        expect(group.leftType, AtomType.open);
      }
    });
  });

  group("A close parser", () {
    final expression = ")]?!";

    test("should not fail", () {
      expect(expression, toParse());
    });

    test("should build a list of closes", () {
      final parse = getParsed(expression);

      for (var i = 0; i < parse.children.length; i++) {
        final group = parse.children[i];
        expect(group, isA<AtomNode>());
        expect(group.leftType, AtomType.close);
      }
    });
  });

  group("A \\KaTeX parser", () {
    test("should not fail", () {
      expect(r'\KaTeX', toParse());
    });
  });

  group("A subscript and superscript parser", () {
    test("should not fail on superscripts", () {
      expect(r'x^2', toParse());
    });

    test("should not fail on subscripts", () {
      expect(r'x_3', toParse());
    });

    test("should not fail on both subscripts and superscripts", () {
      expect(r'x^2_3', toParse());

      expect(r'x_2^3', toParse());
    });

    test("should not fail when there is no nucleus", () {
      expect(r'^3', toParse());
      expect(r'^3+', toParse());
      expect(r'_2', toParse());
      expect(r'^3_2', toParse());
      expect(r'_2^3', toParse());
    });

    test("should produce supsubs for superscript", () {
      var parse = getParsed(r'x^2').children[0];

      expect(parse, isA<MultiscriptsNode>());
      if (parse is MultiscriptsNode) {
        expect(parse.base, isNotNull);
        expect(parse.sup, isNotNull);
        expect(parse.sub, null);
      }
    });

    test("should produce supsubs for subscript", () {
      final parse = getParsed(r'x_3').children[0];

      expect(parse, isA<MultiscriptsNode>());
      if (parse is MultiscriptsNode) {
        expect(parse.base, isNotNull);
        expect(parse.sub, isNotNull);
        expect(parse.sup, null);
      }
    });

    test("should produce supsubs for ^_", () {
      final parse = getParsed(r'x^2_3').children[0];

      expect(parse, isA<MultiscriptsNode>());
      if (parse is MultiscriptsNode) {
        expect(parse.base, isNotNull);
        expect(parse.sub, isNotNull);
        expect(parse.sup, isNotNull);
      }
    });

    test("should produce supsubs for _^", () {
      final parse = getParsed(r'x_3^2').children[0];

      expect(parse, isA<MultiscriptsNode>());
      if (parse is MultiscriptsNode) {
        expect(parse.base, isNotNull);
        expect(parse.sub, isNotNull);
        expect(parse.sup, isNotNull);
      }
    });
    testTexToRenderLike("should produce the same thing regardless of order",
        r'x^2_3', r'x_3^2');

    test("should not parse double subscripts or superscripts", () {
      expect(r'x^x^x', toNotParse());

      expect(r'x_x_x', toNotParse());

      expect(r'x_x^x_x', toNotParse());

      expect(r'x_x^x^x', toNotParse());

      expect(r'x^x_x_x', toNotParse());

      expect(r'x^x_x^x', toNotParse());
    });

    test("should work correctly with {}s", () {
      expect(r'x^{2+3}', toParse());

      expect(r'x_{3-2}', toParse());

      expect(r'x^{2+3}_3', toParse());

      expect(r'x^2_{3-2}', toParse());

      expect(r'x^{2+3}_{3-2}', toParse());

      expect(r'x_{3-2}^{2+3}', toParse());

      expect(r'x_3^{2+3}', toParse());

      expect(r'x_{3-2}^2', toParse());
    });

    test("should work with nested super/subscripts", () {
      expect(r'x^{x^x}', toParse());
      expect(r'x^{x_x}', toParse());
      expect(r'x_{x^x}', toParse());
      expect(r'x_{x_x}', toParse());
    });
  });

  group("A subscript and superscript tree-builder", () {
    test("should not fail when there is no nucleus", () {
      expect(r'^3', toBuild);
      expect(r'_2', toBuild);
      expect(r'^3_2', toBuild);
      expect(r'_2^3', toBuild);
    });
  });

  group("A parser with limit controls", () {
    test("should fail when the limit control is not preceded by an op node",
        () {
      expect(r'3\nolimits_2^2', toNotParse());
      expect(r'\sqrt\limits_2^2', toNotParse());
      expect(r'45 +\nolimits 45', toNotParse());
    });

    test("should parse when the limit control directly follows an op node", () {
      expect(r'\int\limits_2^2 3', toParse());
      expect(r'\sum\nolimits_3^4 4', toParse());
    });

    test(
        "should parse when the limit control is in the sup/sub area of an op node",
        () {
      expect(r'\int_2^2\limits', toParse());
      expect(r'\int^2\nolimits_2', toParse());
      expect(r'\int_2\limits^2', toParse());
    });

    test(
        "should allow multiple limit controls in the sup/sub area of an op node",
        () {
      expect(r'\int_2\nolimits^2\limits 3', toParse());
      expect(r'\int\nolimits\limits_2^2', toParse());
      expect(r'\int\limits\limits\limits_2^2', toParse());
    });

    test(
        "should have the rightmost limit control determine the limits property "
        "of the preceding op node", () {
      var parsedInput = getParsed(r'\int\nolimits\limits_2^2').children[0]
          as NaryOperatorNode;
      expect(parsedInput.limits, true);

      parsedInput = getParsed(r'\int\limits_2\nolimits^2').children[0]
          as NaryOperatorNode;
      expect(parsedInput.limits, false);
    });
  });

  group("A group parser", () {
    test("should not fail", () {
      expect(r'{xy}', toParse());
    });

    // test("should produce a single ord", () {
    //   final parse = getParsed(r'{xy}');

    //   expect(parse.children.length, 1);

    //   final ord = parse.children[0];

    //   expect(ord.leftType, AtomType.ord);
    // });
  });

  group("A \\begingroup...\\endgroup parser", () {
    test("should not fail", () {
      expect(r'\begingroup xy \endgroup', toParse());
    });

    test("should fail when it is mismatched", () {
      expect(r'\begingroup xy', toNotParse());
      expect(r'\begingroup xy }', toNotParse());
    });

    //TODO
    // test("should produce a semi-simple group", () {
    //   final parse = getParsed(r'\begingroup xy \endgroup');

    //   expect(parse.children.length, 1);

    //   final ord = parse.children[0];

    //   expect(ord.leftType, AtomType.ord);
    //   // expect(ord.body).toBeTruthy();
    //   // expect(ord.semisimple).toBeTruthy();
    // });

    //TODO
    // test("should not affect spacing in math mode", () {
    //     expect(r'\begingroup x+ \endgroup y'.toBuildLike(r'x+y');
    // });
  });

  group("An implicit group parser", () {
    test("should not fail", () {
      expect(r'\Large x', toParse());
      expect(r'abc {abc \Large xyz} abc', toParse());
    });

    test("should produce a single object", () {
      final parse = getParsed(r'\Large abc');

      expect(parse.children.length, 1);

      final sizing = parse.children[0];

      expect(sizing, isA<StyleNode>());
      if (sizing is StyleNode) {
        expect(sizing.optionsDiff.size, isNotNull);
      }
    });

    test("should apply only after the function", () {
      final parse = getParsed(r'a \Large abc');

      expect(parse.children.length, 2);

      final sizing = parse.children[1];

      expect(sizing, isA<StyleNode>());
      expect(sizing.children.length, 3);
    });

    test("should stop at the ends of groups", () {
      final parse = getParsed(r'a { b \Large c } d');

      final group = parse.children[1];
      final sizing = group.children[1];

      expect(sizing, isA<StyleNode>());
      expect(sizing.children.length, 1);
    });

    group("within optional groups", () {
      testTexToMatchGoldenFile(
          "should work with sizing commands: \\sqrt[\\small 3]{x}",
          r'\sqrt[\small 3]{x}');

      testTexToMatchGoldenFile(
          "should work with \\color: \\sqrt[\\color{red} 3]{x}",
          r'\sqrt[\color{red} 3]{x}');

      testTexToMatchGoldenFile(
          "should work style commands \\sqrt[\\textstyle 3]{x}",
          r'\sqrt[\textstyle 3]{x}');

      testTexToMatchGoldenFile(
          "should work with old font functions: \\sqrt[\\tt 3]{x}",
          r'\sqrt[\tt 3]{x}');
    });
  });

  group("A function parser", () {
    test("should parse no argument functions", () {
      expect(r'\div', toParse());
    });

    test("should parse 1 argument functions", () {
      expect(r'\blue x', toParse());
    });

    test("should parse 2 argument functions", () {
      expect(r'\frac 1 2', toParse());
    });

    test("should not parse 1 argument functions with no arguments", () {
      expect(r'\blue', toNotParse());
    });

    test("should not parse 2 argument functions with 0 or 1 arguments", () {
      expect(r'\frac', toNotParse());

      expect(r'\frac 1', toNotParse());
    });

    test("should not parse a function with text right after it", () {
      expect(r'\redx', toNotParse());
    });

    test("should parse a function with a number right after it", () {
      expect(r'\frac12', toParse());
    });

    test("should parse some functions with text right after it", () {
      expect(r'\;x', toParse());
    });
  });

  group("A frac parser", () {
    final expression = r'\frac{x}{y}';
    final dfracExpression = r'\dfrac{x}{y}';
    final tfracExpression = r'\tfrac{x}{y}';
    final cfracExpression = r'\cfrac{x}{y}';
    final genfrac1 = r'\genfrac ( ] {0.06em}{0}{a}{b+c}';
    final genfrac2 = r'\genfrac ( ] {0.8pt}{}{a}{b+c}';

    test("should not fail", () {
      expect(expression, toParse());
    });

    test("should produce a frac", () {
      final parse = getParsed(expression).children[0];

      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator, isNotNull);
        expect(parse.denominator, isNotNull);
      }
    });

    test("should also parse cfrac, dfrac, tfrac, and genfrac", () {
      expect(cfracExpression, toParse());
      expect(dfracExpression, toParse());
      expect(tfracExpression, toParse());
      expect(genfrac1, toParse());
      expect(genfrac2, toParse());
    });

    test("should parse cfrac, dfrac, tfrac, and genfrac as fracs", () {
      final dfracParse = getParsed(dfracExpression).children[0].children[0];

      expect(dfracParse, isA<FracNode>());
      if (dfracParse is FracNode) {
        expect(dfracParse.numerator, isNotNull);
        expect(dfracParse.denominator, isNotNull);
      }

      final tfracParse = getParsed(tfracExpression).children[0].children[0];

      expect(tfracParse, isA<FracNode>());
      if (tfracParse is FracNode) {
        expect(tfracParse.numerator, isNotNull);
        expect(tfracParse.denominator, isNotNull);
      }

      final cfracParse = getParsed(cfracExpression).children[0].children[0];

      expect(cfracParse, isA<FracNode>());
      if (cfracParse is FracNode) {
        expect(cfracParse.numerator, isNotNull);
        expect(cfracParse.denominator, isNotNull);
      }

      var genfracParse = getParsed(genfrac1).children[0];

      expect(genfracParse, isA<StyleNode>());
      genfracParse = genfracParse.children[0];

      expect(genfracParse, isA<LeftRightNode>());
      if (genfracParse is LeftRightNode) {
        expect(genfracParse.leftDelim, isNotNull);
        expect(genfracParse.rightDelim, isNotNull);
      }
      genfracParse = genfracParse.children[0].children[0];

      expect(genfracParse, isA<FracNode>());
      if (genfracParse is FracNode) {
        expect(genfracParse.numerator, isNotNull);
        expect(genfracParse.denominator, isNotNull);
      }
    });

    test("should fail, given math as a line thickness to genfrac", () {
      final badGenFrac = "\\genfrac ( ] {b+c}{0}{a}{b+c}";
      expect(badGenFrac, toNotParse());
    });

    test("should fail if genfrac is given less than 6 arguments", () {
      final badGenFrac = "\\genfrac ( ] {0.06em}{0}{a}";
      expect(badGenFrac, toNotParse());
    });

    test("should parse atop", () {
      final parse = getParsed(r'x \atop y').children[0];

      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator, isNotNull);
        expect(parse.denominator, isNotNull);
        expect(parse.barSize.value, 0);
      }
    });
  });

  group("An over/brace/brack parser", () {
    final simpleOver = r'1 \over x';
    final complexOver = r'1+2i \over 3+4i';
    final braceFrac = r'a+b \brace c+d';
    final brackFrac = r'a+b \brack c+d';

    test("should not fail", () {
      expect(simpleOver, toParse());
      expect(complexOver, toParse());
      expect(braceFrac, toParse());
      expect(brackFrac, toParse());
    });

    test("should produce a frac", () {
      GreenNode parse;

      parse = getParsed(simpleOver).children[0];

      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator, isNotNull);
        expect(parse.denominator, isNotNull);
      }

      parse = getParsed(complexOver).children[0];

      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator, isNotNull);
        expect(parse.denominator, isNotNull);
      }
      var parseBraceFrac = getParsed(braceFrac).children[0];

      expect(parseBraceFrac, isA<LeftRightNode>());
      if (parseBraceFrac is LeftRightNode) {
        expect(parseBraceFrac.leftDelim, isNotNull);
        expect(parseBraceFrac.rightDelim, isNotNull);
      }
      parseBraceFrac = parseBraceFrac.children[0].children[0];

      expect(parseBraceFrac, isA<FracNode>());
      if (parseBraceFrac is FracNode) {
        expect(parseBraceFrac.numerator, isNotNull);
        expect(parseBraceFrac.denominator, isNotNull);
      }

      var parseBrackFrac = getParsed(brackFrac).children[0];

      expect(parseBrackFrac, isA<LeftRightNode>());
      if (parseBrackFrac is LeftRightNode) {
        expect(parseBrackFrac.leftDelim, isNotNull);
        expect(parseBrackFrac.rightDelim, isNotNull);
      }
      parseBrackFrac = parseBrackFrac.children[0].children[0];

      expect(parseBrackFrac, isA<FracNode>());
      if (parseBrackFrac is FracNode) {
        expect(parseBrackFrac.numerator, isNotNull);
        expect(parseBrackFrac.denominator, isNotNull);
      }
    });

    test("should create a numerator from the atoms before \\over", () {
      final parse = getParsed(complexOver).children[0];

      final numer = (parse as FracNode).numerator;
      expect(numer.children.length, 4);
    });

    test("should create a demonimator from the atoms after \\over", () {
      final parse = getParsed(complexOver).children[0];

      final denom = (parse as FracNode).denominator;
      expect(denom.children.length, 4);
    });

    test("should handle empty numerators", () {
      final emptyNumerator = r'\over x';
      final parse = getParsed(emptyNumerator).children[0];
      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator, isNotNull);
        expect(parse.denominator, isNotNull);
      }
    });

    test("should handle empty denominators", () {
      final emptyDenominator = r'1 \over';
      final parse = getParsed(emptyDenominator).children[0];
      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator, isNotNull);
        expect(parse.denominator, isNotNull);
      }
    });

    test("should handle \\displaystyle correctly", () {
      final displaystyleExpression = r'\displaystyle 1 \over 2';
      final parse = getParsed(displaystyleExpression).children[0];
      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator.children[0], isA<StyleNode>());
        expect(parse.denominator, isNotNull);
      }
    });

    testTexToRenderLike("should handle \\textstyle correctly",
        r'\textstyle 1 \over 2', r'\frac{\textstyle 1}{2}');

    test("should handle nested factions", () {
      final nestedOverExpression = r'{1 \over 2} \over 3';
      final parse = getParsed(nestedOverExpression).children[0];
      expect(parse, isA<FracNode>());
      if (parse is FracNode) {
        expect(parse.numerator.children[0], isA<FracNode>());
        expect(
            (parse.numerator.children[0].children[0].children[0] as AtomNode)
                .symbol,
            "1");
        expect(
            (parse.numerator.children[0].children[1].children[0] as AtomNode)
                .symbol,
            "2");
        expect(
            (parse.denominator.children[0] as AtomNode).symbol, "3");
      }
    });

    test("should fail with multiple overs in the same group", () {
      final badMultipleOvers = r'1 \over 2 + 3 \over 4';
      expect(badMultipleOvers, toNotParse());

      final badOverChoose = r'1 \over 2 \choose 3';
      expect(badOverChoose, toNotParse());
    });
  });

  group("A genfrac builder", () {
    test("should not fail", () {
      expect("\\frac{x}{y}", toBuild);
      expect("\\dfrac{x}{y}", toBuild);
      expect("\\tfrac{x}{y}", toBuild);
      expect("\\cfrac{x}{y}", toBuild);
      expect("\\genfrac ( ] {0.06em}{0}{a}{b+c}", toBuild);
      expect("\\genfrac ( ] {0.8pt}{}{a}{b+c}", toBuild);
      expect("\\genfrac {} {} {0.8pt}{}{a}{b+c}", toBuild);
      expect("\\genfrac [ {} {0.8pt}{}{a}{b+c}", toBuild);
    });
  });

  group("A infix builder", () {
    test("should not fail", () {
      expect("a \\over b", toBuild);
      expect("a \\atop b", toBuild);
      expect("a \\choose b", toBuild);
      expect("a \\brace b", toBuild);
      expect("a \\brack b", toBuild);
    });
  });

  group("A sizing parser", () {
    final sizeExpression = r'\Huge{x}\small{x}';

    test("should not fail", () {
      expect(sizeExpression, toParse());
    });

    test("should produce a sizing node", () {
      final parse = getParsed(sizeExpression).children[0];

      expect(parse, isA<StyleNode>());
      if (parse is StyleNode) {
        expect(parse.optionsDiff.size, isNotNull);
      }
    });
  });

// group("A text parser", () {
//     final textExpression = r'\text{a b}';
//     final noBraceTextExpression = r'\text x';
//     final nestedTextExpression =
//         r'\text{a {b} \blue{c} \textcolor{#fff}{x} \llap{x}}';
//     final spaceTextExpression = r'\text{  a \ }';
//     final leadingSpaceTextExpression = r'\text {moo}';
//     final badTextExpression = r'\text{a b%}';
//     final badFunctionExpression = r'\text{\sqrt{x}}';
//     final mathTokenAfterText = r'\text{sin}^2';

//     test("should not fail", () {
//         expect(textExpression), toParse());
//     });

//     test("should produce a text", () {
//         final parse = getParsed(textExpression).children[0];

//         expect(parse.type, "text");
//         expect(parse.body).toBeDefined();
//     });

//     test("should produce textords instead of mathords", () {
//         final parse = getParsed(textExpression).children[0];
//         final group = parse.body;

//         expect(group.children[0].type, "textord");
//     });

//     test("should not parse bad text", () {
//         expect(badTextExpression).not, toParse());
//     });

//     test("should not parse bad functions inside text", () {
//         expect(badFunctionExpression).not, toParse());
//     });

//     test("should parse text with no braces around it", () {
//         expect(noBraceTextExpression), toParse());
//     });

//     test("should parse nested expressions", () {
//         expect(nestedTextExpression), toParse());
//     });

//     test("should contract spaces", () {
//         final parse = getParsed(spaceTextExpression).children[0];
//         final group = parse.body;

//         expect(group.children[0].type, "spacing");
//         expect(group.children[1].type, "textord");
//         expect(group.children[2].type, "spacing");
//         expect(group.children[3].type, "spacing");
//     });

//     test("should accept math mode tokens after its argument", () {
//         expect(mathTokenAfterText), toParse());
//     });

//     test("should ignore a space before the text group", () {
//         final parse = getParsed(leadingSpaceTextExpression).children[0];
//         // [m, o, o]
//         expect(parse.body.children.length, 3);
//         expect(parse.body.map(n => n.text).join("")).toBe("moo");
//     });

//     test("should parse math within text group", () {
//         expect(`\text{graph: $y = mx + b$}`, toParse(strictSettings));
//         expect(r'\text{graph: \(y = mx + b\)}', toParse(strictSettings));
//     });

//     test("should parse math within text within math within text", () {
//         expect(`\text{hello $x + \text{world $y$} + z$}`, toParse(strictSettings));
//         expect(`\text{hello \(x + \text{world $y$} + z\)}`, toParse(strictSettings));
//         expect(`\text{hello $x + \text{world \(y\)} + z$}`, toParse(strictSettings));
//         expect(r'\text{hello \(x + \text{world \(y\)} + z\)}', toParse(strictSettings));
//     });

//     test("should forbid \\( within math mode", () {
//         expect(r'\('.not, toParse());
//         expect(`\text{$\(x\)$}`.not, toParse());
//     });

//     test("should forbid $ within math mode", () {
//         expect(`$x$`.not, toParse());
//         expect(`\text{\($x$\)}`.not, toParse());
//     });

//     test("should detect unbalanced \\)", () {
//         expect(r'\)'.not, toParse());
//         expect(r'\text{\)}'.not, toParse());
//     });

//     test("should detect unbalanced $", () {
//         expect(`$`.not, toParse());
//         expect(`\text{$}`.not, toParse());
//     });

//     test("should not mix $ and \\(..\\)", () {
//         expect(`\text{$x\)}`.not, toParse());
//         expect(`\text{\(x$}`.not, toParse());
//     });

//     test("should parse spacing functions", () {
//         expect(r'a b\, \; \! \: \> ~ \thinspace \medspace \quad \ '.toBuild();
//         expect(r'\enspace \thickspace \qquad \space \nobreakspace'.toBuild();
//     });

//     test("should omit spaces after commands", () {
//         expect(r'\text{\textellipsis !}'.toParseLike(r'\text{\textellipsis!}');
//     });
// });

  group("A texvc builder", () {
    test("should not fail", () {
      expect("\\lang\\N\\darr\\R\\dArr\\Z\\Darr\\alef\\rang", toBuild);
      expect("\\alefsym\\uarr\\Alpha\\uArr\\Beta\\Uarr\\Chi", toBuild);
      expect("\\clubs\\diamonds\\hearts\\spades\\cnums\\Complex", toBuild);
      expect("\\Dagger\\empty\\harr\\Epsilon\\hArr\\Eta\\Harr\\exist", toBuild);
      expect("\\image\\larr\\infin\\lArr\\Iota\\Larr\\isin\\Kappa", toBuild);
      expect("\\Mu\\lrarr\\natnums\\lrArr\\Nu\\Lrarr\\Omicron", toBuild);
      expect("\\real\\rarr\\plusmn\\rArr\\reals\\Rarr\\Reals\\Rho", toBuild);
      expect("\\text{\\sect}\\sdot\\sub\\sube\\supe", toBuild);
      expect("\\Tau\\thetasym\\weierp\\Zeta", toBuild);
    });
  });

  group("A color parser", () {
    final colorExpression = r'\blue{x}';
    final newColorExpression = r'\redA{x}';
    final customColorExpression1 = r'\textcolor{#fA6}{x}';
    final customColorExpression2 = r'\textcolor{#fA6fA6}{x}';
    final customColorExpression3 = r'\textcolor{fA6fA6}{x}';
    final badCustomColorExpression1 = r'\textcolor{bad-color}{x}';
    final badCustomColorExpression2 = r'\textcolor{#fA6f}{x}';
    final badCustomColorExpression3 = r'\textcolor{#gA6}{x}';
    final oldColorExpression = r'\color{#fA6}xy';

    test("should not fail", () {
      expect(colorExpression, toParse());
    });

    test("should build a color node", () {
      final parse = getParsed(colorExpression).children[0];

      expect(parse, isA<StyleNode>());
      if (parse is StyleNode) {
        expect(parse.optionsDiff.color, isNotNull);
      }
    });

    test("should parse a custom color", () {
      expect(customColorExpression1, toParse());
      expect(customColorExpression2, toParse());
      expect(customColorExpression3, toParse());
    });

    test("should correctly extract the custom color", () {
      final parse1 = getParsed(customColorExpression1).children[0] as StyleNode;
      final parse2 = getParsed(customColorExpression2).children[0] as StyleNode;
      final parse3 = getParsed(customColorExpression3).children[0] as StyleNode;

      expect(parse1.optionsDiff.color, Color(0xffffAA66));
      expect(parse2.optionsDiff.color, Color(0xfffA6fA6));
      expect(parse3.optionsDiff.color, Color(0xfffA6fA6));
    });

    test("should not parse a bad custom color", () {
      expect(badCustomColorExpression1, toNotParse());
      expect(badCustomColorExpression2, toNotParse());
      expect(badCustomColorExpression3, toNotParse());
    });

    test("should parse new colors from the branding guide", () {
      expect(newColorExpression, toParse());
    });

    test("should have correct greediness", () {
      expect(r'\textcolor{red}a', toParse());
      expect(r'\textcolor{red}{\text{a}}', toParse());
      expect(r'\textcolor{red}\text{a}', toNotParse());
      expect(r'\textcolor{red}\frac12', toNotParse());
    });

    testTexToRenderLike("should use one-argument \\color by default",
        oldColorExpression, r'\textcolor{#fA6}{xy}');

    // test("should use one-argument \\color if requested", () {
    //     expect(oldColorExpression).toParseLike(r'\textcolor{#fA6}{xy}', {
    //         colorIsTextColor: false,
    //     });
    // });

    // test("should use two-argument \\color if requested", () {
    //     expect(oldColorExpression).toParseLike(r'\textcolor{#fA6}{x}y', {
    //         colorIsTextColor: true,
    //     });
    // });

    // test("should not define \\color in global context", () {
    //     final macros = {};
    //     expect(oldColorExpression).toParseLike(r'\textcolor{#fA6}{x}y', {
    //         colorIsTextColor: true,
    //         macros: macros,
    //     });
    //     expect(macros, {});
    // });
  });

// group("A tie parser", () {
//     final mathTie = "a~b";
//     final textTie = r'\text{a~ b}';

//     test("should parse ties in math mode", () {
//         expect(mathTie), toParse());
//     });

//     test("should parse ties in text mode", () {
//         expect(textTie), toParse());
//     });

//     test("should produce spacing in math mode", () {
//         final parse = getParsed(mathTie);

//         expect(parse.children[1].type, "spacing");
//     });

//     test("should produce spacing in text mode", () {
//         final text = getParsed(textTie).children[0];
//         final parse = text.body;

//         expect(parse.children[1].type, "spacing");
//     });

//     test("should not contract with spaces in text mode", () {
//         final text = getParsed(textTie).children[0];
//         final parse = text.body;

//         expect(parse.children[2].type, "spacing");
//     });
// });

// group("A delimiter sizing parser", () {
//     final normalDelim = r'\bigl |';
//     final notDelim = r'\bigl x';
//     final bigDelim = r'\Biggr \langle';

//     test("should parse normal delimiters", () {
//         expect(normalDelim), toParse());
//         expect(bigDelim), toParse());
//     });

//     test("should not parse not-delimiters", () {
//         expect(notDelim).not, toParse());
//     });

//     test("should produce a delimsizing", () {
//         final parse = getParsed(normalDelim).children[0];

//         expect(parse.type, "delimsizing");
//     });

//     test("should produce the correct direction delimiter", () {
//         final leftParse = getParsed(normalDelim).children[0];
//         final rightParse = getParsed(bigDelim).children[0];

//         expect(leftParse.mclass, "mopen");
//         expect(rightParse.mclass, "mclose");
//     });

//     test("should parse the correct size delimiter", () {
//         final smallParse = getParsed(normalDelim).children[0];
//         final bigParse = getParsed(bigDelim).children[0];

//         expect(smallParse.size, 1);
//         expect(bigParse.size, 4);
//     });
// });

// group("An overline parser", () {
//     final overline = r'\overline{x}';

//     test("should not fail", () {
//         expect(overline), toParse());
//     });

//     test("should produce an overline", () {
//         final parse = getParsed(overline).children[0];

//         expect(parse.type, "overline");
//     });
// });

// group("An lap parser", () {
//     test("should not fail on a text argument", () {
//         expect(r'\rlap{\,/}{=}', toParse());
//         expect(r'\mathrlap{\,/}{=}', toParse());
//         expect(r'{=}\llap{/\,}', toParse());
//         expect(r'{=}\mathllap{/\,}', toParse());
//         expect(r'\sum_{\clap{ABCDEFG}}', toParse());
//         expect(r'\sum_{\mathclap{ABCDEFG}}', toParse());
//     });

//     test("should not fail if math version is used", () {
//         expect(r'\mathrlap{\frac{a}{b}}{=}', toParse());
//         expect(r'{=}\mathllap{\frac{a}{b}}', toParse());
//         expect(r'\sum_{\mathclap{\frac{a}{b}}}', toParse());
//     });

//     test("should fail on math if AMS version is used", () {
//         expect(r'\rlap{\frac{a}{b}}{=}'.not, toParse());
//         expect(r'{=}\llap{\frac{a}{b}}'.not, toParse());
//         expect(r'\sum_{\clap{\frac{a}{b}}}'.not, toParse());
//     });

//     test("should produce a lap", () {
//         final parse = getParsed(r'\mathrlap{\,/}').children[0];

//         expect(parse.type, "lap");
//     });
// });

// group("A rule parser", () {
//     final emRule = r'\rule{1em}{2em}';
//     final exRule = r'\rule{1ex}{2em}';
//     final badUnitRule = r'\rule{1au}{2em}';
//     final noNumberRule = r'\rule{1em}{em}';
//     final incompleteRule = r'\rule{1em}';
//     final hardNumberRule = r'\rule{   01.24ex}{2.450   em   }';

//     test("should not fail", () {
//         expect(emRule), toParse());
//         expect(exRule), toParse());
//     });

//     test("should not parse invalid units", () {
//         expect(badUnitRule).not, toParse());

//         expect(noNumberRule).not, toParse());
//     });

//     test("should not parse incomplete rules", () {
//         expect(incompleteRule).not, toParse());
//     });

//     test("should produce a rule", () {
//         final parse = getParsed(emRule).children[0];

//         expect(parse.type, "rule");
//     });

//     test("should list the correct units", () {
//         final emParse = getParsed(emRule).children[0];
//         final exParse = getParsed(exRule).children[0];

//         expect(emParse.width.unit, "em");
//         expect(emParse.height.unit, "em");

//         expect(exParse.width.unit, "ex");
//         expect(exParse.height.unit, "em");
//     });

//     test("should parse the number correctly", () {
//         final hardNumberParse = getParsed(hardNumberRule).children[0];

//         expect(hardNumberParse.width.number).toBeCloseTo(1.24);
//         expect(hardNumberParse.height.number).toBeCloseTo(2.45);
//     });

//     test("should parse negative sizes", () {
//         final parse = getParsed(r'\rule{-1em}{- 0.2em}').children[0];

//         expect(parse.width.number).toBeCloseTo(-1);
//         expect(parse.height.number).toBeCloseTo(-0.2);
//     });
// });

// group("A kern parser", () {
//     final emKern = r'\kern{1em}';
//     final exKern = r'\kern{1ex}';
//     final muKern = r'\mkern{1mu}';
//     final abKern = r'a\kern{1em}b';
//     final badUnitRule = r'\kern{1au}';
//     final noNumberRule = r'\kern{em}';

//     test("should list the correct units", () {
//         final emParse = getParsed(emKern).children[0];
//         final exParse = getParsed(exKern).children[0];
//         final muParse = getParsed(muKern).children[0];
//         final abParse = getParsed(abKern).children[1];

//         expect(emParse.dimension.unit, "em");
//         expect(exParse.dimension.unit, "ex");
//         expect(muParse.dimension.unit, "mu");
//         expect(abParse.dimension.unit, "em");
//     });

//     test("should not parse invalid units", () {
//         expect(badUnitRule).not, toParse());
//         expect(noNumberRule).not, toParse());
//     });

//     test("should parse negative sizes", () {
//         final parse = getParsed(r'\kern{-1em}').children[0];
//         expect(parse.dimension.number).toBeCloseTo(-1);
//     });

//     test("should parse positive sizes", () {
//         final parse = getParsed(r'\kern{+1em}').children[0];
//         expect(parse.dimension.number).toBeCloseTo(1);
//     });
// });

// group("A non-braced kern parser", () {
//     final emKern = r'\kern1em';
//     final exKern = r'\kern 1 ex';
//     final muKern = r'\mkern 1mu';
//     final abKern1 = r'a\mkern1mub';
//     final abKern2 = r'a\mkern-1mub';
//     final abKern3 = r'a\mkern-1mu b';
//     final badUnitRule = r'\kern1au';
//     final noNumberRule = r'\kern em';

//     test("should list the correct units", () {
//         final emParse = getParsed(emKern).children[0];
//         final exParse = getParsed(exKern).children[0];
//         final muParse = getParsed(muKern).children[0];
//         final abParse1 = getParsed(abKern1).children[1];
//         final abParse2 = getParsed(abKern2).children[1];
//         final abParse3 = getParsed(abKern3).children[1];

//         expect(emParse.dimension.unit, "em");
//         expect(exParse.dimension.unit, "ex");
//         expect(muParse.dimension.unit, "mu");
//         expect(abParse1.dimension.unit, "mu");
//         expect(abParse2.dimension.unit, "mu");
//         expect(abParse3.dimension.unit, "mu");
//     });

//     test("should parse elements on either side of a kern", () {
//         final abParse1 = getParsed(abKern1);
//         final abParse2 = getParsed(abKern2);
//         final abParse3 = getParsed(abKern3);

//         expect(abParse1.children.length, 3);
//         expect(abParse1.children[0].text, "a");
//         expect(abParse1.children[2].text, "b");
//         expect(abParse2.children.length, 3);
//         expect(abParse2.children[0].text, "a");
//         expect(abParse2.children[2].text, "b");
//         expect(abParse3.children.length, 3);
//         expect(abParse3.children[0].text, "a");
//         expect(abParse3.children[2].text, "b");
//     });

//     test("should not parse invalid units", () {
//         expect(badUnitRule).not, toParse());
//         expect(noNumberRule).not, toParse());
//     });

//     test("should parse negative sizes", () {
//         final parse = getParsed(r'\kern-1em').children[0];
//         expect(parse.dimension.number).toBeCloseTo(-1);
//     });

//     test("should parse positive sizes", () {
//         final parse = getParsed(r'\kern+1em').children[0];
//         expect(parse.dimension.number).toBeCloseTo(1);
//     });

//     test("should handle whitespace", () {
//         final abKern = "a\\mkern\t-\r1  \n mu\nb";
//         final abParse = getParsed(abKern);

//         expect(abParse.children.length, 3);
//         expect(abParse.children[0].text, "a");
//         expect(abParse.children[1].dimension.unit, "mu");
//         expect(abParse.children[2].text, "b");
//     });
// });

// group("A left/right parser", () {
//     final normalLeftRight = r'\left( \dfrac{x}{y} \right)';
//     final emptyRight = r'\left( \dfrac{x}{y} \right.';

//     test("should not fail", () {
//         expect(normalLeftRight), toParse());
//     });

//     test("should produce a leftright", () {
//         final parse = getParsed(normalLeftRight).children[0];

//         expect(parse.type, "leftright");
//         expect(parse.left, "(");
//         expect(parse.right, ")");
//     });

//     test("should error when it is mismatched", () {
//         final unmatchedLeft = r'\left( \dfrac{x}{y}';
//         final unmatchedRight = r'\dfrac{x}{y} \right)';

//         expect(unmatchedLeft).not, toParse());

//         expect(unmatchedRight).not, toParse());
//     });

//     test("should error when braces are mismatched", () {
//         final unmatched = r'{ \left( \dfrac{x}{y} } \right)';
//         expect(unmatched).not, toParse());
//     });

//     test("should error when non-delimiters are provided", () {
//         final nonDelimiter = r`\left$ \dfrac{x}{y} \right)`;
//         expect(nonDelimiter).not, toParse());
//     });

//     test("should parse the empty '.' delimiter", () {
//         expect(emptyRight), toParse());
//     });

//     test("should parse the '.' delimiter with normal sizes", () {
//         final normalEmpty = r'\Bigl .';
//         expect(normalEmpty), toParse());
//     });

//     test("should handle \\middle", () {
//         final normalMiddle = r'\left( \dfrac{x}{y} \middle| \dfrac{y}{z} \right)';
//         expect(normalMiddle), toParse());
//     });

//     test("should handle multiple \\middles", () {
//         final multiMiddle = r'\left( \dfrac{x}{y} \middle| \dfrac{y}{z} \middle/ \dfrac{z}{q} \right)';
//         expect(multiMiddle), toParse());
//     });

//     test("should handle nested \\middles", () {
//         final nestedMiddle = r'\left( a^2 \middle| \left( b \middle/ c \right) \right)';
//         expect(nestedMiddle), toParse());
//     });

//     test("should error when \\middle is not in \\left...\\right", () {
//         final unmatchedMiddle = r'(\middle|\dfrac{x}{y})';
//         expect(unmatchedMiddle).not, toParse());
//     });
// });

// group("left/right builder", () => {
//     final cases = [
//         [r`([r'\left\langle \right\rangle', r(r'\left< \right>')],
//         [r`([r'\left\langle \right\rangle', '\\left\u27e8 \\right\u27e9'],
//         [r`([r'\left\lparen \right\rparen', r(r'\left( \right)')],
//     ];

//     for (final [actual, expected] of cases) {
//         it(`should build "${actual}" like "${expected}"`, () => {
//             expect(actual).toBuildLike(expected);
//         });
//     }
// });

// group("A begin/end parser", () {

//     test("should parse a simple environment", () {
//         expect(r'\begin{matrix}a&b\\c&d\end{matrix}', toParse());
//     });

//     test("should parse an environment with argument", () {
//         expect(r'\begin{array}{cc}a&b\\c&d\end{array}', toParse());
//     });

//     test("should parse an environment with hlines", () {
//         expect(r'\begin{matrix}\hline a&b\\ \hline c&d\end{matrix}', toParse());
//         expect(r'\begin{matrix}\hdashline a&b\\ \hdashline c&d\end{matrix}', toParse());
//     });

//     test("should forbid hlines outside array environment", () => {
//         expect(r'\hline'.not, toParse());
//     });

//     test("should error when name is mismatched", () {
//         expect(r'\begin{matrix}a&b\\c&d\end{pmatrix}'.not, toParse());
//     });

//     test("should error when commands are mismatched", () {
//         expect(r'\begin{matrix}a&b\\c&d\right{pmatrix}'.not, toParse());
//     });

//     test("should error when end is missing", () {
//         expect(r'\begin{matrix}a&b\\c&d'.not, toParse());
//     });

//     test("should error when braces are mismatched", () {
//         expect(r'{\begin{matrix}a&b\\c&d}\end{matrix}'.not, toParse());
//     });

//     test("should cooperate with infix notation", () {
//         expect(r'\begin{matrix}0&1\over2&3\\4&5&6\end{matrix}', toParse());
//     });

//     test("should nest", () {
//         final m1 = r'\begin{pmatrix}1&2\\3&4\end{pmatrix}';
//         final m2 = `\\begin{array}{rl}${m1}&0\\\\0&${m1}\\end{array}`;
//         expect(m2), toParse());
//     });

//     test("should allow \\cr as a line terminator", () {
//         expect(r'\begin{matrix}a&b\cr c&d\end{matrix}', toParse());
//     });

//     test("should eat a final newline", () {
//         final m3 = getParsed(r'\begin{matrix}a&b\\ c&d \\ \end{matrix}').children[0];
//         expect(m3.body.children.length, 2);
//     });

//     test("should grab \\arraystretch", () {
//         final parse = getParsed(r'\def\arraystretch{1.5}\begin{matrix}a&b\\c&d\end{matrix}');
//         expect(parse).toMatchSnapshot();
//     });
// });

// group("A sqrt parser", () {
//     final sqrt = r'\sqrt{x}';
//     final missingGroup = r'\sqrt';

//     test("should parse square roots", () {
//         expect(sqrt), toParse());
//     });

//     test("should error when there is no group", () {
//         expect(missingGroup).not, toParse());
//     });

//     test("should produce sqrts", () {
//         final parse = getParsed(sqrt).children[0];

//         expect(parse.type, "sqrt");
//     });

//     test("should build sized square roots", () {
//         expect("\\Large\\sqrt.children[3]{x}").toBuild();
//     });
// });

// group("A TeX-compliant parser", () {
//     test("should work", () {
//         expect(r'\frac 2 3', toParse());
//     });

//     test("should fail if there are not enough arguments", () {
//         final missingGroups = [
//             r`([r'\frac{x}',
//             r`([r'\textcolor{#fff}',
//             r`([r'\rule{1em}',
//             r`([r'\llap',
//             r`([r'\bigl',
//             r`([r'\text',
//         ];

//         for (var i = 0; i < missingGroups.length; i++) {
//             expect(missingGroups[i]).not, toParse());
//         }
//     });

//     test("should fail when there are missing sup/subscripts", () {
//         expect(r'x^'.not, toParse());
//         expect(r'x_'.not, toParse());
//     });

//     test("should fail when arguments require arguments", () {
//         final badArguments = [
//             r`([r'\frac \frac x y z',
//             r`([r'\frac x \frac y z',
//             r`([r'\frac \sqrt x y',
//             r`([r'\frac x \sqrt y',
//             r`([r'\frac \mathllap x y',
//             r`([r'\frac x \mathllap y',
//             // This actually doesn't work in real TeX, but it is suprisingly
//             // hard to get this to correctly work. So, we take hit of very small
//             // amounts of non-compatiblity in order for the rest of the tests to
//             // work
//             // r`([r'\llap \frac x y',
//             r`([r'\mathllap \mathllap x',
//             r`([r'\sqrt \mathllap x',
//         ];

//         for (var i = 0; i < badArguments.length; i++) {
//             expect(badArguments[i]).not, toParse());
//         }
//     });

//     test("should work when the arguments have braces", () {
//         final goodArguments = [
//             r`([r'\frac {\frac x y} z',
//             r`([r'\frac x {\frac y z}',
//             r`([r'\frac {\sqrt x} y',
//             r`([r'\frac x {\sqrt y}',
//             r`([r'\frac {\mathllap x} y',
//             r`([r'\frac x {\mathllap y}',
//             r`([r'\mathllap {\frac x y}',
//             r`([r'\mathllap {\mathllap x}',
//             r`([r'\sqrt {\mathllap x}',
//         ];

//         for (var i = 0; i < goodArguments.length; i++) {
//             expect(goodArguments[i]), toParse());
//         }
//     });

//     test("should fail when sup/subscripts require arguments", () {
//         final badSupSubscripts = [
//             r`([r'x^\sqrt x',
//             r`([r'x^\mathllap x',
//             r`([r'x_\sqrt x',
//             r`([r'x_\mathllap x',
//         ];

//         for (var i = 0; i < badSupSubscripts.length; i++) {
//             expect(badSupSubscripts[i]).not, toParse());
//         }
//     });

//     test("should work when sup/subscripts arguments have braces", () {
//         final goodSupSubscripts = [
//             r`([r'x^{\sqrt x}',
//             r`([r'x^{\mathllap x}',
//             r`([r'x_{\sqrt x}',
//             r`([r'x_{\mathllap x}',
//         ];

//         for (var i = 0; i < goodSupSubscripts.length; i++) {
//             expect(goodSupSubscripts[i]), toParse());
//         }
//     });

//     test("should parse multiple primes correctly", () {
//         expect("x''''", toParse());
//         expect(`x_2''`, toParse());
//         expect(`x''_2`, toParse());
//     });

//     test("should fail when sup/subscripts are interspersed with arguments", () {
//         expect(r'\sqrt^23'.not, toParse());
//         expect(r'\frac^234'.not, toParse());
//         expect(r'\frac2^34'.not, toParse());
//     });

//     test("should succeed when sup/subscripts come after whole functions", () {
//         expect(r'\sqrt2^3', toParse());
//         expect(r'\frac23^4', toParse());
//     });

//     test("should succeed with a sqrt around a text/frac", () {
//         expect(r'\sqrt \frac x y', toParse());
//         expect(r'\sqrt \text x', toParse());
//         expect(r'x^\frac x y', toParse());
//         expect(r'x_\text x', toParse());
//     });

//     test("should fail when arguments are \\left", () {
//         final badLeftArguments = [
//             r`([r'\frac \left( x \right) y',
//             r`([r'\frac x \left( y \right)',
//             r`([r'\mathllap \left( x \right)',
//             r`([r'\sqrt \left( x \right)',
//             r`([r'x^\left( x \right)',
//         ];

//         for (var i = 0; i < badLeftArguments.length; i++) {
//             expect(badLeftArguments[i]).not, toParse());
//         }
//     });

//     test("should succeed when there are braces around the \\left/\\right", () {
//         final goodLeftArguments = [
//             r`([r'\frac {\left( x \right)} y',
//             r`([r'\frac x {\left( y \right)}',
//             r`([r'\mathllap {\left( x \right)}',
//             r`([r'\sqrt {\left( x \right)}',
//             r`([r'x^{\left( x \right)}',
//         ];

//         for (var i = 0; i < goodLeftArguments.length; i++) {
//             expect(goodLeftArguments[i]), toParse());
//         }
//     });
// });

// group("An op symbol builder", () {
//     test("should not fail", () {
//         expect("\\int_i^n").toBuild();
//         expect("\\iint_i^n").toBuild();
//         expect("\\iiint_i^n").toBuild();
//         expect("\\int\nolimits_i^n").toBuild();
//         expect("\\iint\nolimits_i^n").toBuild();
//         expect("\\iiint\nolimits_i^n").toBuild();
//         expect("\\oint_i^n").toBuild();
//         expect("\\oiint_i^n").toBuild();
//         expect("\\oiiint_i^n").toBuild();
//         expect("\\oint\nolimits_i^n").toBuild();
//         expect("\\oiint\nolimits_i^n").toBuild();
//         expect("\\oiiint\nolimits_i^n").toBuild();
//     });
// });

// group("A style change parser", () {
//     test("should not fail", () {
//         expect(r'\displaystyle x', toParse());
//         expect(r'\textstyle x', toParse());
//         expect(r'\scriptstyle x', toParse());
//         expect(r'\scriptscriptstyle x', toParse());
//     });

//     test("should produce the correct style", () {
//         final displayParse = getParsed(r'\displaystyle x').children[0];
//         expect(displayParse.style, "display");

//         final scriptscriptParse = getParsed(r'\scriptscriptstyle x').children[0];
//         expect(scriptscriptParse.style, "scriptscript");
//     });

//     test("should only change the style within its group", () {
//         final text = r'a b { c d \displaystyle e f } g h';
//         final parse = getParsed(text);

//         final displayNode = parse.children[2].body.children[2];

//         expect(displayNode.type, "styling");

//         final displayBody = displayNode.body;

//         expect(displayBody.children.length, 2);
//         expect(displayBody.children[0].text, "e");
//     });
// });

// group("A font parser", () {
//     test("should parse \\mathrm, \\mathbb, \\mathit, and \\mathnormal", () {
//         expect(r'\mathrm x', toParse());
//         expect(r'\mathbb x', toParse());
//         expect(r'\mathit x', toParse());
//         expect(r'\mathnormal x', toParse());
//         expect(r'\mathrm {x + 1}', toParse());
//         expect(r'\mathbb {x + 1}', toParse());
//         expect(r'\mathit {x + 1}', toParse());
//         expect(r'\mathnormal {x + 1}', toParse());
//     });

//     test("should parse \\mathcal and \\mathfrak", () {
//         expect(r'\mathcal{ABC123}', toParse());
//         expect(r'\mathfrak{abcABC123}', toParse());
//     });

//     test("should produce the correct fonts", () {
//         final mathbbParse = getParsed(r'\mathbb x').children[0];
//         expect(mathbbParse.font, "mathbb");
//         expect(mathbbParse.type, "font");

//         final mathrmParse = getParsed(r'\mathrm x').children[0];
//         expect(mathrmParse.font, "mathrm");
//         expect(mathrmParse.type, "font");

//         final mathitParse = getParsed(r'\mathit x').children[0];
//         expect(mathitParse.font, "mathit");
//         expect(mathitParse.type, "font");

//         final mathnormalParse = getParsed(r'\mathnormal x').children[0];
//         expect(mathnormalParse.font, "mathnormal");
//         expect(mathnormalParse.type, "font");

//         final mathcalParse = getParsed(r'\mathcal C').children[0];
//         expect(mathcalParse.font, "mathcal");
//         expect(mathcalParse.type, "font");

//         final mathfrakParse = getParsed(r'\mathfrak C').children[0];
//         expect(mathfrakParse.font, "mathfrak");
//         expect(mathfrakParse.type, "font");
//     });

//     test("should parse nested font commands", () {
//         final nestedParse = getParsed(r'\mathbb{R \neq \mathrm{R}}').children[0];
//         expect(nestedParse.font, "mathbb");
//         expect(nestedParse.type, "font");

//         final bbBody = nestedParse.body.body;
//         expect(bbBody.children.length, 3);
//         expect(bbBody.children[0].type, "mathord");
//         expect(bbBody.children[2].type, "font");
//         expect(bbBody.children[2].font, "mathrm");
//         expect(bbBody.children[2].type, "font");
//     });

//     test("should work with \\textcolor", () {
//         final colorMathbbParse = getParsed(r'\textcolor{blue}{\mathbb R}').children[0];
//         expect(colorMathbbParse.type, "color");
//         expect(colorMathbbParse.color, "blue");
//         final body = colorMathbbParse.body;
//         expect(body.children.length, 1);
//         expect(body.children[0].type, "font");
//         expect(body.children[0].font, "mathbb");
//     });

//     test("should not parse a series of font commands", () {
//         expect(r'\mathbb \mathrm R'.not, toParse());
//     });

//     test("should nest fonts correctly", () {
//         final bf = getParsed(r'\mathbf{a\mathrm{b}c}').children[0];
//         expect(bf.type, "font");
//         expect(bf.font, "mathbf");
//         expect(bf.body.body.children.length, 3);
//         expect(bf.body.body.children[0].text, "a");
//         expect(bf.body.body.children[1].type, "font");
//         expect(bf.body.body.children[1].font, "mathrm");
//         expect(bf.body.body.children[2].text, "c");
//     });

//     test("should have the correct greediness", () {
//         expect(r'e^\mathbf{x}', toParse());
//     });

//     test("\\boldsymbol should inherit mbin/mrel from argument", () => {
//         final built = getBuilt(r'a\boldsymbol{}b\boldsymbol{=}c\boldsymbol{+}d\boldsymbol{++}e\boldsymbol{xyz}f');
//         expect(built).toMatchSnapshot();
//     });

//     test("old-style fonts work like new-style fonts", () => {
//         expect(r'\rm xyz'.toParseLike(r'\mathrm{xyz}');
//         expect(r'\sf xyz'.toParseLike(r'\mathsf{xyz}');
//         expect(r'\tt xyz'.toParseLike(r'\mathtt{xyz}');
//         expect(r'\bf xyz'.toParseLike(r'\mathbf{xyz}');
//         expect(r'\it xyz'.toParseLike(r'\mathit{xyz}');
//         expect(r'\cal xyz'.toParseLike(r'\mathcal{xyz}');
//     });
// });

// group("A \\pmb builder", () {
//     test("should not fail", () {
//         expect("\\pmb{\\mu}").toBuild();
//         expect("\\pmb{=}").toBuild();
//         expect("\\pmb{+}").toBuild();
//         expect("\\pmb{\\frac{x^2}{x_1}}").toBuild();
//         expect("\\pmb{}").toBuild();
//         expect("\\def\\x{1}\\pmb{\\x\\def\\x{2}}").toParseLike("\\pmb{1}");
//     });
// });

// group("A comment parser", () {
//     test("should parse comments at the end of a line", () => {
//         expect("a^2 + b^2 = c^2 % Pythagoras' Theorem\n"), toParse());
//     });

//     test("should parse comments at the start of a line", () => {
//         expect("% comment\n"), toParse());
//     });

//     test("should parse multiple lines of comments in a row", () => {
//         expect("% comment 1\n% comment 2\n"), toParse());
//     });

//     test("should parse comments between subscript and superscript", () => {
//         expect("x_3 %comment\n^2").toParseLike(r'x_3^2');
//         expect("x^ %comment\n{2}").toParseLike(r'x^{2}');
//         expect("x^ %comment\n\\frac{1}{2}").toParseLike(r'x^\frac{1}{2}');
//     });

//     test("should parse comments in size and color groups", () => {
//         expect("\\kern{1 %kern\nem}"), toParse());
//         expect("\\kern1 %kern\nem"), toParse());
//         expect("\\color{#f00%red\n}"), toParse());
//     });

//     test("should parse comments before an expression", () => {
//         expect("%comment\n{2}").toParseLike(r'{2}');
//     });

//     test("should parse comments before and between \\hline", () => {
//         expect("\\begin{matrix}a&b\\\\ %hline\n" +
//             "\\hline %hline\n" +
//             "\\hline c&d\\end{matrix}"), toParse());
//     });

//     test("should parse comments in the macro definition", () => {
//         expect("\\def\\foo{1 %}\n2}\n\\foo").toParseLike(r'12');
//     });

//     test("should not expand nor ignore spaces after a command sequence in a comment", () => {
//         expect("\\def\\foo{1\n2}\nx %\\foo\n").toParseLike(r'x');
//     });

//     test("should not parse a comment without newline in strict mode", () => {
//         expect(r'x%y'.not, toParse(strictSettings));
//         expect(r'x%y', toParse(nonstrictSettings));
//     });

//     test("should not produce or consume space", () => {
//         expect("\\text{hello% comment 1\nworld}").toParseLike(r'\text{helloworld}');
//         expect("\\text{hello% comment\n\nworld}").toParseLike(r'\text{hello world}');
//     });

//     test("should not include comments in the output", () => {
//         expect("5 % comment\n").toParseLike(r'5');
//     });
// });

// group("An HTML font tree-builder", () {
//     test("should render \\mathbb{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\mathbb{R}'));
//         expect(markup).toContain("<span class=\"mord mathbb\">R</span>");
//     });

//     test("should render \\mathrm{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\mathrm{R}'));
//         expect(markup).toContain("<span class=\"mord mathrm\">R</span>");
//     });

//     test("should render \\mathcal{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\mathcal{R}'));
//         expect(markup).toContain("<span class=\"mord mathcal\">R</span>");
//     });

//     test("should render \\mathfrak{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\mathfrak{R}'));
//         expect(markup).toContain("<span class=\"mord mathfrak\">R</span>");
//     });

//     test("should render \\text{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\text{R}'));
//         expect(markup).toContain("<span class=\"mord\">R</span>");
//     });

//     test("should render \\textit{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\textit{R}'));
//         expect(markup).toContain("<span class=\"mord textit\">R</span>");
//     });

//     test("should render \\text{\\textit{R}} with the correct font", () {
//         final markup = katex.renderToString(r(r'\text{\textit{R}}'));
//         expect(markup).toContain("<span class=\"mord textit\">R</span>");
//     });

//     test("should render \\textup{R} with the correct font", () {
//         final markup1 = katex.renderToString(r(r'\textup{R}'));
//         expect(markup1).toContain("<span class=\"mord textup\">R</span>");
//         final markup2 = katex.renderToString(r(r'\textit{\textup{R}}'));
//         expect(markup2).toContain("<span class=\"mord textup\">R</span>");
//         final markup3 = katex.renderToString(r(r'\textup{\textit{R}}'));
//         expect(markup3).toContain("<span class=\"mord textit\">R</span>");
//     });

//     test("should render \\text{R\\textit{S}T} with the correct fonts", () {
//         final markup = katex.renderToString(r(r'\text{R\textit{S}T}'));
//         expect(markup).toContain("<span class=\"mord\">R</span>");
//         expect(markup).toContain("<span class=\"mord textit\">S</span>");
//         expect(markup).toContain("<span class=\"mord\">T</span>");
//     });

//     test("should render \\textbf{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\textbf{R}'));
//         expect(markup).toContain("<span class=\"mord textbf\">R</span>");
//     });

//     test("should render \\textmd{R} with the correct font", () {
//         final markup1 = katex.renderToString(r(r'\textmd{R}'));
//         expect(markup1).toContain("<span class=\"mord textmd\">R</span>");
//         final markup2 = katex.renderToString(r(r'\textbf{\textmd{R}}'));
//         expect(markup2).toContain("<span class=\"mord textmd\">R</span>");
//         final markup3 = katex.renderToString(r(r'\textmd{\textbf{R}}'));
//         expect(markup3).toContain("<span class=\"mord textbf\">R</span>");
//     });

//     test("should render \\textsf{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\textsf{R}'));
//         expect(markup).toContain("<span class=\"mord textsf\">R</span>");
//     });

//     test("should render \\textsf{\\textit{R}G\\textbf{B}} with the correct font", () {
//         final markup = katex.renderToString(r(r'\textsf{\textit{R}G\textbf{B}}'));
//         expect(markup).toContain("<span class=\"mord textsf textit\">R</span>");
//         expect(markup).toContain("<span class=\"mord textsf\">G</span>");
//         expect(markup).toContain("<span class=\"mord textsf textbf\">B</span>");
//     });

//     test("should render \\textsf{\\textbf{$\\mathrm{A}$}} with the correct font", () {
//         final markup = katex.renderToString(r`\textsf{\textbf{$\mathrm{A}$}}`);
//         expect(markup).toContain("<span class=\"mord mathrm\">A</span>");
//     });

//     test("should render \\textsf{\\textbf{$\\mathrm{\\textsf{A}}$}} with the correct font", () {
//         final markup = katex.renderToString(r`\textsf{\textbf{$\mathrm{\textsf{A}}$}}`);
//         expect(markup).toContain("<span class=\"mord textsf textbf\">A</span>");
//     });

//     test("should render \\texttt{R} with the correct font", () {
//         final markup = katex.renderToString(r(r'\texttt{R}'));
//         expect(markup).toContain("<span class=\"mord texttt\">R</span>");
//     });

//     test("should render a combination of font and color changes", () {
//         var markup = katex.renderToString(r(r'\textcolor{blue}{\mathbb R}'));
//         var span = "<span class=\"mord mathbb\" style=\"color:blue;\">R</span>";
//         expect(markup).toContain(span);

//         markup = katex.renderToString(r(r'\mathbb{\textcolor{blue}{R}}'));
//         span = "<span class=\"mord mathbb\" style=\"color:blue;\">R</span>";
//         expect(markup).toContain(span);
//     });

//     test("should render wide characters with mord and with the correct font", () {
//         final markup = katex.renderToString(String.fromCharCode(0xD835, 0xDC00));
//         expect(markup).toContain("<span class=\"mord mathbf\">A</span>");

//         expect(String.fromCharCode(0xD835, 0xDC00) +
//                 " = " + String.fromCharCode(0xD835, 0xDC1A))
//             .toBuildLike(r'\mathbf A = \mathbf a');
//     });

//     test("should throw TypeError when the expression is of the wrong type", () {
//         expect(() {
//             katex.renderToString({badInputType: "yes"});
//         }).toThrowError(TypeError);
//         expect(() {
//             katex.renderToString([1, 2]);
//         }).toThrowError(TypeError);
//         expect(() {
//             katex.renderToString(undefined);
//         }).toThrowError(TypeError);
//         expect(() {
//             katex.renderToString(null);
//         }).toThrowError(TypeError);
//         expect(() {
//             katex.renderToString(1.234);
//         }).toThrowError(TypeError);
//     });

//     test("should not throw TypeError when the expression is a supported type", () {
//         expect(() {
//             katex.renderToString(r(r'\sqrt{123}'));
//         }).not.toThrowError(TypeError);
//         expect(() {
//             katex.renderToString(new String(r(r'\sqrt{123}')));
//         }).not.toThrowError(TypeError);
//     });
// });

// group("A MathML font tree-builder", () {
//     final contents = r'Ax2k\omega\Omega\imath+';

//     test("should render " + contents + " with the correct mathvariants", () {
//         final tree = getParsed(contents);
//         final markup = buildMathML(tree, contents, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi>A</mi>");
//         expect(markup).toContain("<mi>x</mi>");
//         expect(markup).toContain("<mn>2</mn>");
//         expect(markup).toContain("<mi>\u03c9</mi>");   // \omega
//         expect(markup).toContain("<mi mathvariant=\"normal\">\u03A9</mi>");   // \Omega
//         expect(markup).toContain("<mi>\u0131</mi>");   // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathbb{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathbb{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"double-struck\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"double-struck\">x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"double-struck\">2</mn>");
//         expect(markup).toContain("<mi mathvariant=\"double-struck\">\u03c9</mi>");  // \omega
//         expect(markup).toContain("<mi mathvariant=\"double-struck\">\u03A9</mi>"); // \Omega
//         expect(markup).toContain("<mi mathvariant=\"double-struck\">\u0131</mi>");  // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathrm{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathrm{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"normal\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"normal\">x</mi>");
//         expect(markup).toContain("<mn>2</mn>");
//         expect(markup).toContain("<mi>\u03c9</mi>");   // \omega
//         expect(markup).toContain("<mi mathvariant=\"normal\">\u03A9</mi>");   // \Omega
//         expect(markup).toContain("<mi>\u0131</mi>");   // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathit{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathit{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi>A</mi>");
//         expect(markup).toContain("<mi>x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"italic\">2</mn>");
//         expect(markup).toContain("<mi>\u03c9</mi>");   // \omega
//         expect(markup).toContain("<mi>\u03A9</mi>");   // \Omega
//         expect(markup).toContain("<mi>\u0131</mi>");   // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathnormal{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathnormal{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi>A</mi>");
//         expect(markup).toContain("<mi>x</mi>");
//         expect(markup).toContain("<mn>2</mn>");
//         expect(markup).toContain("<mi>\u03c9</mi>");   // \omega
//         expect(markup).toContain("<mi mathvariant=\"normal\">\u03A9</mi>");   // \Omega
//         expect(markup).toContain("<mi>\u0131</mi>");   // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathbf{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathbf{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"bold\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"bold\">x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"bold\">2</mn>");
//         expect(markup).toContain("<mi mathvariant=\"bold\">\u03c9</mi>");   // \omega
//         expect(markup).toContain("<mi mathvariant=\"bold\">\u03A9</mi>");   // \Omega
//         expect(markup).toContain("<mi mathvariant=\"bold\">\u0131</mi>");   // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathcal{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathcal{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"script\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"script\">x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"script\">2</mn>");
//         expect(markup).toContain("<mi mathvariant=\"script\">\u03c9</mi>"); // \omega
//         expect(markup).toContain("<mi mathvariant=\"script\">\u03A9</mi>"); // \Omega
//         expect(markup).toContain("<mi mathvariant=\"script\">\u0131</mi>"); // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathfrak{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathfrak{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"fraktur\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"fraktur\">x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"fraktur\">2</mn>");
//         expect(markup).toContain("<mi mathvariant=\"fraktur\">\u03c9</mi>"); // \omega
//         expect(markup).toContain("<mi mathvariant=\"fraktur\">\u03A9</mi>"); // \Omega
//         expect(markup).toContain("<mi mathvariant=\"fraktur\">\u0131</mi>"); // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathscr{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathscr{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"script\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"script\">x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"script\">2</mn>");
//         expect(markup).toContain("<mi mathvariant=\"script\">\u03c9</mi>"); // \omega
//         expect(markup).toContain("<mi mathvariant=\"script\">\u03A9</mi>"); // \Omega
//         expect(markup).toContain("<mi mathvariant=\"script\">\u0131</mi>"); // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render \\mathsf{" + contents + "} with the correct mathvariants", () {
//         final tex = `\\mathsf{${contents}}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mi mathvariant=\"sans-serif\">A</mi>");
//         expect(markup).toContain("<mi mathvariant=\"sans-serif\">x</mi>");
//         expect(markup).toContain("<mn mathvariant=\"sans-serif\">2</mn>");
//         expect(markup).toContain("<mi mathvariant=\"sans-serif\">\u03c9</mi>"); // \omega
//         expect(markup).toContain("<mi mathvariant=\"sans-serif\">\u03A9</mi>"); // \Omega
//         expect(markup).toContain("<mi mathvariant=\"sans-serif\">\u0131</mi>"); // \imath
//         expect(markup).toContain("<mo>+</mo>");
//     });

//     test("should render a combination of font and color changes", () {
//         var tex = r'\textcolor{blue}{\mathbb R}';
//         var tree = getParsed(tex);
//         var markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         var node = "<mstyle mathcolor=\"blue\">" +
//             "<mi mathvariant=\"double-struck\">R</mi>" +
//             "</mstyle>";
//         expect(markup).toContain(node);

//         // reverse the order of the commands
//         tex = r'\mathbb{\textcolor{blue}{R}}';
//         tree = getParsed(tex);
//         markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         node = "<mstyle mathcolor=\"blue\">" +
//             "<mi mathvariant=\"double-struck\">R</mi>" +
//             "</mstyle>";
//         expect(markup).toContain(node);
//     });

//     test("should render text as <mtext>", () {
//         final tex = r'\text{for }';
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mtext>for\u00a0</mtext>");
//     });

//     test("should render math within text as side-by-side children", () {
//         final tex = r`\text{graph: $y = mx + b$}`;
//         final tree = getParsed(tex);
//         final markup = buildMathML(tree, tex, defaultOptions).toMarkup();
//         expect(markup).toContain("<mrow><mtext>graph:\u00a0</mtext>");
//         expect(markup).toContain(
//             "<mi>y</mi><mo>=</mo><mi>m</mi><mi>x</mi><mo>+</mo><mi>b</mi>");
//     });
// });

// group("An includegraphics builder", () {
//     final img = "\\includegraphics[height=0.9em, totalheight=0.9em, width=0.9em, alt=KA logo]{https://cdn.kastatic.org/images/apple-touch-icon-57x57-precomposed.new.png}";
//     test("should not fail", () {
//         expect(img).toBuild(trustSettings);
//     });

//     test("should produce mords", () {
//         expect(getBuilt(img, trustSettings).children[0].classes).toContain("mord");
//     });

//     test("should not render without trust setting", () {
//         final built = getBuilt(img);
//         expect(built).toMatchSnapshot();
//     });

//     test("should render with trust setting", () {
//         final built = getBuilt(img, trustSettings);
//         expect(built).toMatchSnapshot();
//     });
// });

// group("A bin builder", () {
//     test("should create mbins normally", () {
//         final built = getBuilt(r'x + y');

//         // we add glue elements around the '+'
//         expect(built.children[2].classes).toContain("mbin");
//     });

//     test("should create ords when at the beginning of lists", () {
//         final built = getBuilt(r'+ x');

//         expect(built.children[0].classes).toContain("mord");
//         expect(built.children[0].classes).not.toContain("mbin");
//     });

//     test("should create ords after some other objects", () {
//         expect(getBuilt(r'x + + 2').children[4].classes).toContain("mord");
//         expect(getBuilt(r'( + 2').children[2].classes).toContain("mord");
//         expect(getBuilt(r'= + 2').children[2].classes).toContain("mord");
//         expect(getBuilt(r'\sin + 2').children[2].classes).toContain("mord");
//         expect(getBuilt(r', + 2').children[2].classes).toContain("mord");
//     });

//     test("should correctly interact with color objects", () {
//         expect(getBuilt(r'\blue{x}+y').children[2].classes).toContain("mbin");
//         expect(getBuilt(r'\blue{x+}+y').children[2].classes).toContain("mbin");
//         expect(getBuilt(r'\blue{x+}+y').children[4].classes).toContain("mord");
//     });
// });

// group("A \\phantom builder and \\smash builder", () {
//     test("should both build a mord", () {
//         expect(getBuilt(r'\hphantom{a}').children[0].classes).toContain("mord");
//         expect(getBuilt(r'a\hphantom{=}b').children[2].classes).toContain("mord");
//         expect(getBuilt(r'a\hphantom{+}b').children[2].classes).toContain("mord");
//         expect(getBuilt(r'\smash{a}').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\smash{=}').children[0].classes).toContain("mord");
//         expect(getBuilt(r'a\smash{+}b').children[2].classes).toContain("mord");
//     });
// });

// group("A markup generator", () {
//     test("marks trees up", () {
//         // Just a few quick sanity checks here...
//         final markup = katex.renderToString(r(r'\sigma^2'));
//         expect(markup.indexOf("<span")).toBe(0);
//         expect(markup).toContain("\u03c3");  // sigma
//         expect(markup).toContain("margin-right");
//         expect(markup).not.toContain("marginRight");
//     });

//     test("generates both MathML and HTML", () {
//         final markup = katex.renderToString("a");

//         expect(markup).toContain("<span");
//         expect(markup).toContain("<math");
//     });
// });

// group("A parse tree generator", () {
//     test("generates a tree", () {
//         final tree = stripPositions(getParsed(r'\sigma^2'));
//         expect(tree).toMatchSnapshot();
//     });
// });

// group("An accent parser", () {
//     test("should not fail", () {
//         expect(r'\vec{x}', toParse());
//         expect(r'\vec{x^2}', toParse());
//         expect(r'\vec{x}^2', toParse());
//         expect(r'\vec x', toParse());
//     });

//     test("should produce accents", () {
//         final parse = getParsed(r'\vec x').children[0];

//         expect(parse.type, "accent");
//     });

//     test("should be grouped more tightly than supsubs", () {
//         final parse = getParsed(r'\vec x^2').children[0];

//         expect(parse.type, "supsub");
//     });

//     test("should parse stretchy, shifty accents", () {
//         expect(r'\widehat{x}', toParse());
//         expect(r'\widecheck{x}', toParse());
//     });

//     test("should parse stretchy, non-shifty accents", () {
//         expect(r'\overrightarrow{x}', toParse());
//     });
// });

// group("An accent builder", () {
//     test("should not fail", () {
//         expect(r'\vec{x}'.toBuild();
//         expect(r'\vec{x}^2'.toBuild();
//         expect(r'\vec{x}_2'.toBuild();
//         expect(r'\vec{x}_2^2'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\vec x').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\vec +').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\vec +').children[0].classes).not.toContain("mbin");
//         expect(getBuilt(r'\vec )^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\vec )^2').children[0].classes).not.toContain("mclose");
//     });
// });

// group("A stretchy and shifty accent builder", () {
//     test("should not fail", () {
//         expect(r'\widehat{AB}'.toBuild();
//         expect(r'\widecheck{AB}'.toBuild();
//         expect(r'\widehat{AB}^2'.toBuild();
//         expect(r'\widehat{AB}_2'.toBuild();
//         expect(r'\widehat{AB}_2^2'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\widehat{AB}').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\widehat +').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\widehat +').children[0].classes).not.toContain("mbin");
//         expect(getBuilt(r'\widehat )^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\widehat )^2').children[0].classes).not.toContain("mclose");
//     });
// });

// group("A stretchy and non-shifty accent builder", () {
//     test("should not fail", () {
//         expect(r'\overrightarrow{AB}'.toBuild();
//         expect(r'\overrightarrow{AB}^2'.toBuild();
//         expect(r'\overrightarrow{AB}_2'.toBuild();
//         expect(r'\overrightarrow{AB}_2^2'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\overrightarrow{AB}').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overrightarrow +').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overrightarrow +').children[0].classes).not.toContain("mbin");
//         expect(getBuilt(r'\overrightarrow )^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overrightarrow )^2').children[0].classes).not.toContain("mclose");
//     });
// });

// group("An under-accent parser", () {
//     test("should not fail", () {
//         expect("\\underrightarrow{x}"), toParse());
//         expect("\\underrightarrow{x^2}"), toParse());
//         expect("\\underrightarrow{x}^2"), toParse());
//         expect("\\underrightarrow x"), toParse());
//     });

//     test("should produce accentUnder", () {
//         final parse = getParsed("\\underrightarrow x").children[0];

//         expect(parse.type, "accentUnder");
//     });

//     test("should be grouped more tightly than supsubs", () {
//         final parse = getParsed("\\underrightarrow x^2").children[0];

//         expect(parse.type, "supsub");
//     });
// });

// group("An under-accent builder", () {
//     test("should not fail", () {
//         expect("\\underrightarrow{x}").toBuild();
//         expect("\\underrightarrow{x}^2").toBuild();
//         expect("\\underrightarrow{x}_2").toBuild();
//         expect("\\underrightarrow{x}_2^2").toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt("\\underrightarrow x").children[0].classes).toContain("mord");
//         expect(getBuilt("\\underrightarrow +").children[0].classes).toContain("mord");
//         expect(getBuilt("\\underrightarrow +").children[0].classes).not.toContain("mbin");
//         expect(getBuilt("\\underrightarrow )^2").children[0].classes).toContain("mord");
//         expect(getBuilt("\\underrightarrow )^2").children[0].classes).not.toContain("mclose");
//     });
// });

// group("An extensible arrow parser", () {
//     test("should not fail", () {
//         expect("\\xrightarrow{x}"), toParse());
//         expect("\\xrightarrow{x^2}"), toParse());
//         expect("\\xrightarrow{x}^2"), toParse());
//         expect("\\xrightarrow x"), toParse());
//         expect("\\xrightarrow[under]{over}"), toParse());
//     });

//     test("should produce xArrow", () {
//         final parse = getParsed("\\xrightarrow x").children[0];

//         expect(parse.type, "xArrow");
//     });

//     test("should be grouped more tightly than supsubs", () {
//         final parse = getParsed("\\xrightarrow x^2").children[0];

//         expect(parse.type, "supsub");
//     });
// });

// group("An extensible arrow builder", () {
//     test("should not fail", () {
//         expect("\\xrightarrow{x}").toBuild();
//         expect("\\xrightarrow{x}^2").toBuild();
//         expect("\\xrightarrow{x}_2").toBuild();
//         expect("\\xrightarrow{x}_2^2").toBuild();
//         expect("\\xrightarrow[under]{over}").toBuild();
//     });

//     test("should produce mrell", () {
//         expect(getBuilt("\\xrightarrow x").children[0].classes).toContain("mrel");
//         expect(getBuilt("\\xrightarrow [under]{over}").children[0].classes).toContain("mrel");
//         expect(getBuilt("\\xrightarrow +").children[0].classes).toContain("mrel");
//         expect(getBuilt("\\xrightarrow +").children[0].classes).not.toContain("mbin");
//         expect(getBuilt("\\xrightarrow )^2").children[0].classes).toContain("mrel");
//         expect(getBuilt("\\xrightarrow )^2").children[0].classes).not.toContain("mclose");
//     });
// });

// group("A horizontal brace parser", () {
//     test("should not fail", () {
//         expect(r'\overbrace{x}', toParse());
//         expect(r'\overbrace{x^2}', toParse());
//         expect(r'\overbrace{x}^2', toParse());
//         expect(r'\overbrace x', toParse());
//         expect("\\underbrace{x}_2"), toParse());
//         expect("\\underbrace{x}_2^2"), toParse());
//     });

//     test("should produce horizBrace", () {
//         final parse = getParsed(r'\overbrace x').children[0];

//         expect(parse.type, "horizBrace");
//     });

//     test("should be grouped more tightly than supsubs", () {
//         final parse = getParsed(r'\overbrace x^2').children[0];

//         expect(parse.type, "supsub");
//     });
// });

// group("A horizontal brace builder", () {
//     test("should not fail", () {
//         expect(r'\overbrace{x}'.toBuild();
//         expect(r'\overbrace{x}^2'.toBuild();
//         expect("\\underbrace{x}_2").toBuild();
//         expect("\\underbrace{x}_2^2").toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\overbrace x').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overbrace{x}^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overbrace +').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overbrace +').children[0].classes).not.toContain("mbin");
//         expect(getBuilt(r'\overbrace )^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\overbrace )^2').children[0].classes).not.toContain("mclose");
//     });
// });

// group("A boxed parser", () {
//     test("should not fail", () {
//         expect(r'\boxed{x}', toParse());
//         expect(r'\boxed{x^2}', toParse());
//         expect(r'\boxed{x}^2', toParse());
//         expect(r'\boxed x', toParse());
//     });

//     test("should produce enclose", () {
//         final parse = getParsed(r'\boxed x').children[0];

//         expect(parse.type, "enclose");
//     });
// });

// group("A boxed builder", () {
//     test("should not fail", () {
//         expect(r'\boxed{x}'.toBuild();
//         expect(r'\boxed{x}^2'.toBuild();
//         expect(r'\boxed{x}_2'.toBuild();
//         expect(r'\boxed{x}_2^2'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\boxed x').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\boxed +').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\boxed +').children[0].classes).not.toContain("mbin");
//         expect(getBuilt(r'\boxed )^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\boxed )^2').children[0].classes).not.toContain("mclose");
//     });
// });

// group("An fbox parser, unlike a boxed parser,", () {
//     test("should fail when given math", () {
//         expect(r'\fbox{\frac a b}'.not, toParse());
//     });
// });

// group("A colorbox parser", () {
//     test("should not fail, given a text argument", () {
//         expect(r'\colorbox{red}{a b}', toParse());
//         expect(r'\colorbox{red}{x}^2', toParse());
//         expect(r'\colorbox{red} x', toParse());
//     });

//     test("should fail, given a math argument", () {
//         expect(r'\colorbox{red}{\alpha}'.not, toParse());
//         expect(r'\colorbox{red}{\frac{a}{b}}'.not, toParse());
//     });

//     test("should parse a color", () {
//         expect(r'\colorbox{red}{a b}', toParse());
//         expect(r'\colorbox{#197}{a b}', toParse());
//         expect(r'\colorbox{#1a9b7c}{a b}', toParse());
//     });

//     test("should produce enclose", () {
//         final parse = getParsed(r'\colorbox{red} x').children[0];
//         expect(parse.type, "enclose");
//     });
// });

// group("A colorbox builder", () {
//     test("should not fail", () {
//         expect(r'\colorbox{red}{a b}'.toBuild();
//         expect(r'\colorbox{red}{a b}^2'.toBuild();
//         expect(r'\colorbox{red} x'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\colorbox{red}{a b}').children[0].classes).toContain("mord");
//     });
// });

// group("An fcolorbox parser", () {
//     test("should not fail, given a text argument", () {
//         expect(r'\fcolorbox{blue}{yellow}{a b}', toParse());
//         expect(r'\fcolorbox{blue}{yellow}{x}^2', toParse());
//         expect(r'\fcolorbox{blue}{yellow} x', toParse());
//     });

//     test("should fail, given a math argument", () {
//         expect(r'\fcolorbox{blue}{yellow}{\alpha}'.not, toParse());
//         expect(r'\fcolorbox{blue}{yellow}{\frac{a}{b}}'.not, toParse());
//     });

//     test("should parse a color", () {
//         expect(r'\fcolorbox{blue}{yellow}{a b}', toParse());
//         expect(r'\fcolorbox{blue}{#197}{a b}', toParse());
//         expect(r'\fcolorbox{blue}{#1a9b7c}{a b}', toParse());
//     });

//     test("should produce enclose", () {
//         final parse = getParsed(r'\fcolorbox{blue}{yellow} x').children[0];
//         expect(parse.type, "enclose");
//     });
// });

// group("A fcolorbox builder", () {
//     test("should not fail", () {
//         expect(r'\fcolorbox{blue}{yellow}{a b}'.toBuild();
//         expect(r'\fcolorbox{blue}{yellow}{a b}^2'.toBuild();
//         expect(r'\fcolorbox{blue}{yellow} x'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\colorbox{red}{a b}').children[0].classes).toContain("mord");
//     });
// });

// group("A strike-through parser", () {
//     test("should not fail", () {
//         expect(r'\cancel{x}', toParse());
//         expect(r'\cancel{x^2}', toParse());
//         expect(r'\cancel{x}^2', toParse());
//         expect(r'\cancel x', toParse());
//     });

//     test("should produce enclose", () {
//         final parse = getParsed(r'\cancel x').children[0];

//         expect(parse.type, "enclose");
//     });

//     test("should be grouped more tightly than supsubs", () {
//         final parse = getParsed(r'\cancel x^2').children[0];

//         expect(parse.type, "supsub");
//     });
// });

// group("A strike-through builder", () {
//     test("should not fail", () {
//         expect(r'\cancel{x}'.toBuild();
//         expect(r'\cancel{x}^2'.toBuild();
//         expect(r'\cancel{x}_2'.toBuild();
//         expect(r'\cancel{x}_2^2'.toBuild();
//         expect(r'\sout{x}'.toBuild();
//         expect(r'\sout{x}^2'.toBuild();
//         expect(r'\sout{x}_2'.toBuild();
//         expect(r'\sout{x}_2^2'.toBuild();
//     });

//     test("should produce mords", () {
//         expect(getBuilt(r'\cancel x').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\cancel +').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\cancel +').children[0].classes).not.toContain("mbin");
//         expect(getBuilt(r'\cancel )^2').children[0].classes).toContain("mord");
//         expect(getBuilt(r'\cancel )^2').children[0].classes).not.toContain("mclose");
//     });
// });

// group("A phantom parser", () {
//     test("should not fail", () {
//         expect(r'\phantom{x}', toParse());
//         expect(r'\phantom{x^2}', toParse());
//         expect(r'\phantom{x}^2', toParse());
//         expect(r'\phantom x', toParse());
//         expect(r'\hphantom{x}', toParse());
//         expect(r'\hphantom{x^2}', toParse());
//         expect(r'\hphantom{x}^2', toParse());
//         expect(r'\hphantom x', toParse());
//     });

//     test("should build a phantom node", () {
//         final parse = getParsed(r'\phantom{x}').children[0];

//         expect(parse.type, "phantom");
//         expect(parse.body).toBeDefined();
//     });
// });

// group("A phantom builder", () {
//     test("should not fail", () {
//         expect(r'\phantom{x}'.toBuild();
//         expect(r'\phantom{x^2}'.toBuild();
//         expect(r'\phantom{x}^2'.toBuild();
//         expect(r'\phantom x'.toBuild();

//         expect(r'\hphantom{x}'.toBuild();
//         expect(r'\hphantom{x^2}'.toBuild();
//         expect(r'\hphantom{x}^2'.toBuild();
//         expect(r'\hphantom x'.toBuild();
//     });

//     test("should make the children transparent", () {
//         final children = getBuilt(r'\phantom{x+1}');
//         expect(children.children[0].style.color).toBe("transparent");
//         expect(children.children[2].style.color).toBe("transparent");
//         expect(children.children[4].style.color).toBe("transparent");
//     });

//     test("should make all descendants transparent", () {
//         final children = getBuilt(r'\phantom{x+\blue{1}}');
//         expect(children.children[0].style.color).toBe("transparent");
//         expect(children.children[2].style.color).toBe("transparent");
//         expect(children.children[4].style.color).toBe("transparent");
//     });
// });

// group("A smash parser", () {
//     test("should not fail", () {
//         expect(r'\smash{x}', toParse());
//         expect(r'\smash{x^2}', toParse());
//         expect(r'\smash{x}^2', toParse());
//         expect(r'\smash x', toParse());

//         expect(r'\smash[b]{x}', toParse());
//         expect(r'\smash[b]{x^2}', toParse());
//         expect(r'\smash[b]{x}^2', toParse());
//         expect(r'\smash[b] x', toParse());

//         expect(r'\smash.children[]{x}', toParse());
//         expect(r'\smash.children[]{x^2}', toParse());
//         expect(r'\smash.children[]{x}^2', toParse());
//         expect(r'\smash.children[] x', toParse());
//     });

//     test("should build a smash node", () {
//         final parse = getParsed(r'\smash{x}').children[0];

//         expect(parse.type, "smash");
//     });
// });

// group("A smash builder", () {
//     test("should not fail", () {
//         expect(r'\smash{x}'.toBuild(nonstrictSettings);
//         expect(r'\smash{x^2}'.toBuild(nonstrictSettings);
//         expect(r'\smash{x}^2'.toBuild(nonstrictSettings);
//         expect(r'\smash x'.toBuild(nonstrictSettings);

//         expect(r'\smash[b]{x}'.toBuild(nonstrictSettings);
//         expect(r'\smash[b]{x^2}'.toBuild(nonstrictSettings);
//         expect(r'\smash[b]{x}^2'.toBuild(nonstrictSettings);
//         expect(r'\smash[b] x'.toBuild(nonstrictSettings);
//     });
// });

// group("A document fragment", () {
//     test("should have paddings applied inside an extensible arrow", () {
//         final markup = katex.renderToString("\\tiny\\xrightarrow\\textcolor{red}{x}");
//         expect(markup).toContain("x-arrow-pad");
//     });

//     test("should have paddings applied inside an enclose", () {
//         final markup = katex.renderToString(r(r'\fbox\textcolor{red}{x}'));
//         expect(markup).toContain("boxpad");
//     });

//     test("should have paddings applied inside a square root", () {
//         final markup = katex.renderToString(r(r'\sqrt\textcolor{red}{x}'));
//         expect(markup).toContain("padding-left");
//     });
// });

// group("A parser error", () {
//     test("should report the position of an error", () {
//         try {
//             parseTree(r`([r'\sqrt}', new Settings());
//         } catch (e) {
//             expect(e.position, 5);
//         }
//     });
// });

// group("An optional argument parser", () {
//     test("should not fail", () {
//         // Note this doesn't actually make an optional argument, but still
//         // should work
//         expect(r'\frac.children[1]{2}{3}', toParse());

//         expect(r'\rule[0.2em]{1em}{1em}', toParse());
//     });

//     test("should work with sqrts with optional arguments", () {
//         expect(r'\sqrt.children[3]{2}', toParse());
//     });

//     test("should work when the optional argument is missing", () {
//         expect(r'\sqrt{2}', toParse());
//         expect(r'\rule{1em}{2em}', toParse());
//     });

//     test("should fail when the optional argument is malformed", () {
//         expect(r'\rule.children[1]{2em}{3em}'.not, toParse());
//     });

//     test("should not work if the optional argument isn't closed", () {
//         expect(r'\sqrt['.not, toParse());
//     });
// });

// group("An array environment", () {

//     test("should accept a single alignment character", () {
//         final parse = getParsed(r'\begin{array}r1\\20\end{array}');
//         expect(parse.children[0].type).toBe("array");
//         expect(parse.children[0].cols).toEqual([
//             {type: "align", align: "r"},
//         ]);
//     });

//     test("should accept vertical separators", () {
//         final parse = getParsed(r'\begin{array}{|l||c:r::}\end{array}');
//         expect(parse.children[0].type).toBe("array");
//         expect(parse.children[0].cols).toEqual([
//             {type: "separator", separator: "|"},
//             {type: "align", align: "l"},
//             {type: "separator", separator: "|"},
//             {type: "separator", separator: "|"},
//             {type: "align", align: "c"},
//             {type: "separator", separator: ":"},
//             {type: "align", align: "r"},
//             {type: "separator", separator: ":"},
//             {type: "separator", separator: ":"},
//         ]);
//     });

// });

// group("A subarray environment", () {

//     test("should accept only a single alignment character", () {
//         final parse = getParsed(r'\begin{subarray}{c}a \\ b\end{subarray}');
//         expect(parse.children[0].type).toBe("array");
//         expect(parse.children[0].cols).toEqual([
//             {type: "align", align: "c"},
//         ]);
//         expect(r'\begin{subarray}{cc}a \\ b\end{subarray}'.not, toParse());
//         expect(r'\begin{subarray}{c}a & b \\ c & d\end{subarray}'.not, toParse());
//         expect(r'\begin{subarray}{c}a \\ b\end{subarray}'.toBuild();
//     });

// });

// group("A substack function", () {

//     test("should build", () {
//         expect(r'\sum_{\substack{ 0<i<m \\ 0<j<n }}  P(i,j)'.toBuild();
//     });
//     test("should accommodate spaces in the argument", () {
//         expect(r'\sum_{\substack{ 0<i<m \\ 0<j<n }}  P(i,j)'.toBuild();
//     });
//     test("should accommodate macros in the argument", () {
//         expect(r'\sum_{\substack{ 0<i<\varPi \\ 0<j<\pi }}  P(i,j)'.toBuild();
//     });

// });

// group("A smallmatrix environment", () {

//     test("should build", () {
//         expect(r'\begin{smallmatrix} a & b \\ c & d \end{smallmatrix}'.toBuild();
//     });

// });

// group("A cases environment", () {

//     test("should parse its input", () {
//         expect(`f(a,b)=\begin{cases}a+1&\text{if }b\text{ is odd}\\a&\text{if }b=0\\a-1&\text{otherwise}\end{cases}`
//             , toParse());
//     });

// });

// group("An rcases environment", () {

//     test("should build", () {
//         expect(`\begin{rcases} a &\text{if } b \\ c &\text{if } d \end{rcases}⇒…`
//             .toBuild();
//     });

// });

// group("An aligned environment", () {

//     test("should parse its input", () {
//         expect(r'\begin{aligned}a&=b&c&=d\\e&=f\end{aligned}', toParse());
//     });

//     test("should allow cells in brackets", () {
//         expect(r'\begin{aligned}[a]&[b]\\ [c]&[d]\end{aligned}', toParse());
//     });

//     test("should forbid cells in brackets without space", () {
//         expect(r'\begin{aligned}[a]&[b]\\[c]&[d]\end{aligned}'.not, toParse());
//     });

//     test("should not eat the last row when its first cell is empty", () {
//         final ae = getParsed(r'\begin{aligned}&E_1 & (1)\\&E_2 & (2)\\&E_3 & (3)\end{aligned}').children[0];
//         expect(ae.body.children.length, 3);
//     });
// });

// group("operatorname support", () {
//     test("should not fail", () {
//         expect("\\operatorname{x*Π∑\\Pi\\sum\\frac a b}").toBuild();
//         expect("\\operatorname*{x*Π∑\\Pi\\sum\\frac a b}").toBuild();
//         expect("\\operatorname*{x*Π∑\\Pi\\sum\\frac a b}_y x").toBuild();
//         expect("\\operatorname*{x*Π∑\\Pi\\sum\\frac a b}\\limits_y x").toBuild();
//     });
// });

// group("href and url commands", () {
//     // We can't use raw strings for \url because \u is for Unicode escapes.

//     test("should parse its input", () {
//         expect(r'\href{http://example.com/}{\sin}'.toBuild(trustSettings);
//         expect("\\url{http://example.com/}").toBuild(trustSettings);
//     });

//     test("should allow empty URLs", () {
//         expect(r'\href{}{example here}'.toBuild(trustSettings);
//         expect("\\url{}").toBuild(trustSettings);
//     });

//     test("should allow single-character URLs", () => {
//         expect(r'\href%end'.toParseLike("\\href{%}end", trustSettings);
//         expect("\\url%end").toParseLike("\\url{%}end", trustSettings);
//         expect("\\url%%end\n").toParseLike("\\url{%}", trustSettings);
//         expect("\\url end").toParseLike("\\url{e}nd", trustSettings);
//         expect("\\url%end").toParseLike("\\url {%}end", trustSettings);
//     });

//     test("should allow spaces single-character URLs", () => {
//         expect(r'\href %end'.toParseLike("\\href{%}end", trustSettings);
//         expect("\\url %end").toParseLike("\\url{%}end", trustSettings);
//     });

//     test("should allow letters [#$%&~_^] without escaping", () {
//         final url = "http://example.org/~bar/#top?foo=$foo&bar=ba^r_boo%20baz";
//         final parsed1 = getParsed(`\\href{${url}}{\\alpha}`, trustSettings).children[0];
//         expect(parsed1.href).toBe(url);
//         final parsed2 = getParsed(`\\url{${url}}`, trustSettings).children[0];
//         expect(parsed2.href).toBe(url);
//     });

//     test("should allow balanced braces in url", () {
//         final url = "http://example.org/{{}t{oo}}";
//         final parsed1 = getParsed(`\\href{${url}}{\\alpha}`, trustSettings).children[0];
//         expect(parsed1.href).toBe(url);
//         final parsed2 = getParsed(`\\url{${url}}`, trustSettings).children[0];
//         expect(parsed2.href).toBe(url);
//     });

//     test("should not allow unbalanced brace(s) in url", () {
//         expect(r'\href{http://example.com/{a}{bar}'.not, toParse());
//         expect(r'\href{http://example.com/}a}{bar}'.not, toParse());
//         expect(r'\\url{http://example.com/{a}'.not, toParse());
//         expect(r'\\url{http://example.com/}a}'.not, toParse());
//     });

//     test("should allow escape for letters [#$%&~_^{}]", () {
//         final url = "http://example.org/~bar/#top?foo=$}foo{&bar=bar^r_boo%20baz";
//         final input = url.replace(/([#$%&~_^{}])/g, '\\$1');
//         final parsed1 = getParsed(`\\href{${input}}{\\alpha}`, trustSettings).children[0];
//         expect(parsed1.href).toBe(url);
//         final parsed2 = getParsed(`\\url{${input}}`, trustSettings).children[0];
//         expect(parsed2.href).toBe(url);
//     });

//     test("should allow comments after URLs", () {
//         expect("\\url{http://example.com/}%comment\n").toBuild();
//     });

//     test("should be marked up correctly", () {
//         final markup = katex.renderToString(r`([r'\href{http://example.com/}{example here}', {trust: true});
//         expect(markup).toContain("<a href=\"http://example.com/\">");
//     });

//     test("should not affect spacing around", () {
//         final built = getBuilt("a\\href{http://example.com/}{+b}", trustSettings);
//         expect(built).toMatchSnapshot();
//     });

//     test("should forbid relative URLs when trust option is false", () => {
//         final parsed = getParsed("\\href{relative}{foo}");
//         expect(parsed).toMatchSnapshot();
//     });

//     test("should allow explicitly allowed protocols", () => {
//         final parsed = getParsed(
//             "\\href{ftp://x}{foo}",
//             new Settings({trust: (context) => context.protocol === "ftp"}),
//         );
//         expect(parsed).toMatchSnapshot();
//     });

//     test("should allow all protocols when trust option is true", () => {
//         final parsed = getParsed("\\href{ftp://x}{foo}", trustSettings);
//         expect(parsed).toMatchSnapshot();
//     });

//     test("should not allow explicitly disallow protocols", () => {
//         final parsed = getParsed(
//             "\\href{javascript:alert('x')}{foo}",
//             new Settings({trust: context => context.protocol !== "javascript"}),
//         );
//         expect(parsed).toMatchSnapshot();
//     });
// });

// group("A raw text parser", () {
//     test("should not not parse a mal-formed string", () {
//         // In the next line, the first character passed to \includegraphics is a
//         // Unicode combining character. So this is a test that the parser will catch a bad string.
//         expect("\\includegraphics[\u030aheight=0.8em, totalheight=0.9em, width=0.9em]{" + "https://cdn.kastatic.org/images/apple-touch-icon-57x57-precomposed.new.png}").not, toParse());
//     });
//     test("should return null for a omitted optional string", () {
//         expect("\\includegraphics{https://cdn.kastatic.org/images/apple-touch-icon-57x57-precomposed.new.png}"), toParse());
//     });
// });

// group("A parser that does not throw on unsupported commands", () {
//     // The parser breaks on unsupported commands unless it is explicitly
//     // told not to
//     final errorColor = "#933";
//     final noThrowSettings = new Settings({
//         throwOnError: false,
//         errorColor: errorColor,
//     });

//     test("should still parse on unrecognized control sequences", () {
//         expect(r'\error', toParse(noThrowSettings));
//     });

//     group("should allow unrecognized controls sequences anywhere, including", () {
//         test("in superscripts and subscripts", () {
//             expect(r'2_\error'.toBuild(noThrowSettings);
//             expect(r'3^{\error}_\error'.toBuild(noThrowSettings);
//             expect(r'\int\nolimits^\error_\error'.toBuild(noThrowSettings);
//         });

//         test("in fractions", () {
//             expect(r'\frac{345}{\error}'.toBuild(noThrowSettings);
//             expect(r'\frac\error{\error}'.toBuild(noThrowSettings);
//         });

//         test("in square roots", () {
//             expect(r'\sqrt\error'.toBuild(noThrowSettings);
//             expect(r'\sqrt{234\error}'.toBuild(noThrowSettings);
//         });

//         test("in text boxes", () {
//             expect(r'\text{\error}'.toBuild(noThrowSettings);
//         });
//     });

//     test("should produce color nodes with a color value given by errorColor", () {
//         final parsedInput = getParsed(r`([r'\error', noThrowSettings);
//         expect(parsedInput.children[0].type).toBe("color");
//         expect(parsedInput.children[0].color).toBe(errorColor);
//     });

//     test("should build katex-error span for other type of KaTeX error", () {
//         final built = getBuilt("2^2^2", noThrowSettings);
//         expect(built).toMatchSnapshot();
//     });

//     test("should properly escape LaTeX in errors", () {
//         final html = katex.renderToString("2^&\"<>", noThrowSettings);
//         expect(html).toMatchSnapshot();
//     });
// });

// group("The symbol table integrity", () {
//     test("should treat certain symbols as synonyms", () {
//         expect(r'<'.toBuildLike(r'\lt');
//         expect(r'>'.toBuildLike(r'\gt');
//         expect(r'\left<\frac{1}{x}\right>'.toBuildLike(r'\left\lt\frac{1}{x}\right\gt');
//     });
// });

// group("Symbols", () {
//     test("should support AMS symbols in both text and math mode", () {
//         // These text+math symbols are from Section 6 of
//         // http://mirrors.ctan.org/fonts/amsfonts/doc/amsfonts.pdf
//         final symbols = r'\yen\checkmark\circledR\maltese';
//         expect(symbols).toBuild();
//         expect(`\\text{${symbols}}`).toBuild(strictSettings);
//     });
// });

// group("A macro expander", () {
//     test("should produce individual tokens", () {
//         expect(r'e^\foo'.toParseLike("e^1 23",
//             new Settings({macros: {"\\foo": "123"}}));
//     });

//     test("should preserve leading spaces inside macro definition", () {
//         expect(r'\text{\foo}'.toParseLike(r`([r'\text{ x}',
//             new Settings({macros: {"\\foo": " x"}}));
//     });

//     test("should preserve leading spaces inside macro argument", () {
//         expect(r'\text{\foo{ x}}'.toParseLike(r`([r'\text{ x}',
//             new Settings({macros: {"\\foo": "#1"}}));
//     });

//     test("should ignore expanded spaces in math mode", () {
//         expect(r'\foo'.toParseLike("x", new Settings({macros: {"\\foo": " x"}}));
//     });

//     test("should consume spaces after control-word macro", () {
//         expect(r'\text{\foo }'.toParseLike(r`([r'\text{x}',
//             new Settings({macros: {"\\foo": "x"}}));
//     });

//     test("should consume spaces after macro with \\relax", () {
//         expect(r'\text{\foo }'.toParseLike(r`([r'\text{}',
//             new Settings({macros: {"\\foo": "\\relax"}}));
//     });

//     test("should not consume spaces after control-word expansion", () {
//         expect(r'\text{\\ }'.toParseLike(r`([r'\text{ }',
//             new Settings({macros: {"\\\\": "\\relax"}}));
//     });

//     test("should consume spaces after \\relax", () {
//         expect(r'\text{\relax }'.toParseLike(r'\text{}');
//     });

//     test("should consume spaces after control-word function", () {
//         expect(r'\text{\KaTeX }'.toParseLike(r'\text{\KaTeX}');
//     });

//     test("should preserve spaces after control-symbol macro", () {
//         expect(r'\text{\% y}'.toParseLike(r`([r'\text{x y}',
//             new Settings({macros: {"\\%": "x"}}));
//     });

//     test("should preserve spaces after control-symbol function", () {
//         expect("\text{\' }", toParse());
//     });

//     test("should consume spaces between arguments", () {
//         expect(r'\text{\foo 1 2}'.toParseLike(r`([r'\text{12end}',
//             new Settings({macros: {"\\foo": "#1#2end"}}));
//         expect(r'\text{\foo {1} {2}}'.toParseLike(r`([r'\text{12end}',
//             new Settings({macros: {"\\foo": "#1#2end"}}));
//     });

//     test("should allow for multiple expansion", () {
//         expect(r'1\foo2'.toParseLike("1aa2", new Settings({macros: {
//             "\\foo": "\\bar\\bar",
//             "\\bar": "a",
//         }}));
//     });

//     test("should allow for multiple expansion with argument", () {
//         expect(r'1\foo2'.toParseLike("12222", new Settings({macros: {
//             "\\foo": "\\bar{#1}\\bar{#1}",
//             "\\bar": "#1#1",
//         }}));
//     });

//     test("should allow for macro argument", () {
//         expect(r'\foo\bar'.toParseLike("(x)", new Settings({macros: {
//             "\\foo": "(#1)",
//             "\\bar": "x",
//         }}));
//     });

//     test("should allow for space macro argument (text version)", () {
//         expect(r'\text{\foo\bar}'.toParseLike(r`([r'\text{( )}', new Settings({macros: {
//             "\\foo": "(#1)",
//             "\\bar": " ",
//         }}));
//     });

//     test("should allow for space macro argument (math version)", () {
//         expect(r'\foo\bar'.toParseLike("()", new Settings({macros: {
//             "\\foo": "(#1)",
//             "\\bar": " ",
//         }}));
//     });

//     test("should allow for space second argument (text version)", () {
//         expect(r'\text{\foo\bar\bar}'.toParseLike(r`([r'\text{( , )}', new Settings({macros: {
//             "\\foo": "(#1,#2)",
//             "\\bar": " ",
//         }}));
//     });

//     test("should allow for space second argument (math version)", () {
//         expect(r'\foo\bar\bar'.toParseLike("(,)", new Settings({macros: {
//             "\\foo": "(#1,#2)",
//             "\\bar": " ",
//         }}));
//     });

//     test("should allow for empty macro argument", () {
//         expect(r'\foo\bar'.toParseLike("()", new Settings({macros: {
//             "\\foo": "(#1)",
//             "\\bar": "",
//         }}));
//     });

//     // TODO: The following is not currently possible to get working, given that
//     // functions and macros are dealt with separately.
// /*
//     test("should allow for space function arguments", () {
//         expect(r'\frac\bar\bar'.toParseLike(r`([r'\frac{}{}', new Settings({macros: {
//             "\\bar": " ",
//         }}));
//     });
// */

//     test("should build \\overset and \\underset", () {
//         expect(r'\overset{f}{\rightarrow} Y'.toBuild();
//         expect("\\underset{f}{\\rightarrow} Y").toBuild();
//     });

//     test("should build \\iff, \\implies, \\impliedby", () {
//         expect(r'X \iff Y'.toBuild();
//         expect(r'X \implies Y'.toBuild();
//         expect(r'X \impliedby Y'.toBuild();
//     });

//     test("should allow aliasing characters", () {
//         expect(r'x’=c'.toParseLike("x'=c", new Settings({macros: {
//             "’": "'",
//         }}));
//     });

//     test("\\@firstoftwo should consume both, and avoid errors", () {
//         expect(r'\@firstoftwo{yes}{no}'.toParseLike(r'yes');
//         expect(`\@firstoftwo{yes}{1'_2^3}`.toParseLike(r'yes');
//     });

//     test("\\@ifstar should consume star but nothing else", () {
//         expect(r'\@ifstar{yes}{no}*!'.toParseLike(r'yes!');
//         expect(r'\@ifstar{yes}{no}?!'.toParseLike(r'no?!');
//     });

//     test("\\@ifnextchar should not consume nonspaces", () {
//         expect(r'\@ifnextchar!{yes}{no}!!'.toParseLike(r'yes!!');
//         expect(r'\@ifnextchar!{yes}{no}?!'.toParseLike(r'no?!');
//     });

//     test("\\@ifnextchar should consume spaces", () {
//         expect(`\def\x#1{\@ifnextchar x{yes}{no}}\x{}x\x{} x`
//             .toParseLike(r'yesxyesx');
//     });

//     test("\\@ifstar should consume star but nothing else", () {
//         expect(r'\@ifstar{yes}{no}*!'.toParseLike(r'yes!');
//         expect(r'\@ifstar{yes}{no}?!'.toParseLike(r'no?!');
//     });

//     test("\\TextOrMath should work immediately", () {
//         expect(r'\TextOrMath{text}{math}'.toParseLike(r'math');
//     });

//     test("\\TextOrMath should work after other math", () {
//         expect(r'x+\TextOrMath{text}{math}'.toParseLike(r'x+math');
//     });

//     test("\\TextOrMath should work immediately after \\text", () {
//         expect(r'\text{\TextOrMath{text}{math}}'.toParseLike(r'\text{text}');
//     });

//     test("\\TextOrMath should work later after \\text", () {
//         expect(r'\text{hello \TextOrMath{text}{math}}'.toParseLike(r'\text{hello text}');
//     });

//     test("\\TextOrMath should work immediately after \\text ends", () {
//         expect(`\text{\TextOrMath{text}{math}}\TextOrMath{text}{math}`
//             .toParseLike(r'\text{text}math');
//     });

//     test("\\TextOrMath should work immediately after $", () {
//         expect(`\text{$\TextOrMath{text}{math}$}`.toParseLike`\text{$math$}`;
//     });

//     test("\\TextOrMath should work later after $", () {
//         expect(`\text{$x+\TextOrMath{text}{math}$}`.toParseLike`\text{$x+math$}`;
//     });

//     test("\\TextOrMath should work immediately after $ ends", () {
//         expect(`\text{$\TextOrMath{text}{math}$\TextOrMath{text}{math}}`
//             .toParseLike`\text{$math$text}`;
//     });

//     test("\\TextOrMath should work in a macro", () {
//         expect(`\mode\text{\mode$\mode$\mode}\mode`
//             .toParseLike(r`math\text{text$math$text}math`, new Settings({macros: {
//                 "\\mode": "\\TextOrMath{text}{math}",
//             }}));
//     });

//     test("\\TextOrMath should work in a macro passed to \\text", () {
//         expect(r'\text\mode'.toParseLike(r`([r'\text t', new Settings({macros:
//             {"\\mode": "\\TextOrMath{t}{m}"}}));
//     });

//     test("\\char produces literal characters", () => {
//         expect("\\char(r'a").toParseLike("\\char')\\a");
//         expect("\\char`\\%").toParseLike("\\char37");
//         expect("\\char`\\%").toParseLike("\\char'45");
//         expect("\\char`\\%").toParseLike('\\char"25');
//         expect("\\char").not, toParse());
//         expect("\\char`").not, toParse());
//         expect("\\char'").not, toParse());
//         expect('\\char"').not, toParse());
//         expect("\\char'a").not, toParse());
//         expect('\\char"g').not, toParse());
//         expect('\\char"g').not, toParse());
//     });

//     test("should build Unicode private area characters", () {
//         expect(r'\gvertneqq\lvertneqq\ngeqq\ngeqslant\nleqq'.toBuild();
//         expect(r'\nleqslant\nshortmid\nshortparallel\varsubsetneq'.toBuild();
//         expect(r'\varsubsetneqq\varsupsetneq\varsupsetneqq'.toBuild();
//     });

//     // TODO(edemaine): This doesn't work yet.  Parses like `\text text`,
//     // which doesn't treat all four letters as an argument.
//     //test("\\TextOrMath should work in a macro passed to \\text", () {
//     //    expect(r'\text\mode'.toParseLike(r`([r'\text{text}', new Settings({macros:
//     //        {"\\mode": "\\TextOrMath{text}{math}"}});
//     //});

//     test("\\gdef defines macros", () {
//         expect(r'\gdef\foo{x^2}\foo+\foo'.toParseLike(r'x^2+x^2');
//         expect(r'\gdef{\foo}{x^2}\foo+\foo'.toParseLike(r'x^2+x^2');
//         expect(r'\gdef\foo{hi}\foo+\text{\foo}'.toParseLike(r'hi+\text{hi}');
//         expect(`\gdef\foo#1{hi #1}\text{\foo{Alice}, \foo{Bob}}`
//             .toParseLike(r'\text{hi Alice, hi Bob}');
//         expect(r'\gdef\foo#1#2{(#1,#2)}\foo 1 2+\foo 3 4'.toParseLike(r'(1,2)+(3,4)');
//         expect(r'\gdef\foo#2{}'.not, toParse());
//         expect(r'\gdef\foo#1#3{}'.not, toParse());
//         expect(r'\gdef\foo#1#2#3#4#5#6#7#8#9{}', toParse());
//         expect(r'\gdef\foo#1#2#3#4#5#6#7#8#9#10{}'.not, toParse());
//         expect(r'\gdef\foo#{}'.not, toParse());
//         expect(r'\gdef\foo\bar', toParse());
//         expect(r'\gdef{\foo\bar}{}'.not, toParse());
//         expect(r'\gdef{}{}'.not, toParse());
//         // TODO: These shouldn't work, but `1` and `{1}` are currently treated
//         // the same, as are `\foo(r' and '){\foo}`.
//         //expect(r'\gdef\foo1'.not, toParse());
//         //expect(r'\gdef{\foo}{}'.not, toParse());
//     });

//     test("\\def works locally", () => {
//         expect("\\def\\x{1}\\x{\\def\\x{2}\\x{\\def\\x{3}\\x}\\x}\\x")
//             .toParseLike(r'1{2{3}2}1');
//         expect("\\def\\x{1}\\x\\def\\x{2}\\x{\\def\\x{3}\\x\\def\\x{4}\\x}\\x")
//             .toParseLike(r'12{34}2');
//     });

//     test("\\gdef overrides at all levels", () => {
//         expect("\\def\\x{1}\\x{\\def\\x{2}\\x{\\gdef\\x{3}\\x}\\x}\\x")
//             .toParseLike(r'1{2{3}3}3');
//         expect("\\def\\x{1}\\x{\\def\\x{2}\\x{\\global\\def\\x{3}\\x}\\x}\\x")
//             .toParseLike(r'1{2{3}3}3');
//         expect("\\def\\x{1}\\x{\\def\\x{2}\\x{\\gdef\\x{3}\\x\\def\\x{4}\\x}" +
//             "\\x\\def\\x{5}\\x}\\x").toParseLike(r'1{2{34}35}3');
//     });

//     test("\\global needs to followed by \\def", () => {
//         expect(r'\global\def\foo{}\foo'.toParseLike(r'');
//         // TODO: This doesn't work yet; \global needs to expand argument.
//         //expect(r'\def\DEF{\def}\global\DEF\foo{}\foo'.toParseLike(r'');
//         expect(r'\global\foo'.not, toParse());
//         expect(r'\global\bar x'.not, toParse());
//     });

//     test("Macro arguments do not generate groups", () => {
//         expect("\\def\\x{1}\\x\\def\\foo#1{#1}\\foo{\\x\\def\\x{2}\\x}\\x")
//             .toParseLike(r'1122');
//     });

//     test("\\textbf arguments do generate groups", () => {
//         expect("\\def\\x{1}\\x\\textbf{\\x\\def\\x{2}\\x}\\x")
//             .toParseLike(r'1\textbf{12}1');
//     });

//     test("\\sqrt optional arguments generate groups", () => {
//         expect("\\def\\x{1}\\def\\y{1}\\x\\y" +
//             "\\sqrt[\\def\\x{2}\\x]{\\def\\y{2}\\y}\\x\\y")
//             .toParseLike(r'11\sqrt.children[2]{2}11');
//     });

//     test("array cells generate groups", () => {
//         expect(`\def\x{1}\begin{matrix}\x&\def\x{2}\x&\x\end{matrix}\x`
//             .toParseLike(r'\begin{matrix}1&2&1\end{matrix}1');
//         expect(`\def\x{1}\begin{matrix}\def\x{2}\x&\x\end{matrix}\x`
//             .toParseLike(r'\begin{matrix}2&1\end{matrix}1');
//     });

//     test("\\gdef changes settings.macros", () => {
//         final macros = {};
//         expect(r'\gdef\foo{1}', toParse(new Settings({macros})));
//         expect(macros["\\foo"]).toBeTruthy();
//     });

//     test("\\def doesn't change settings.macros", () => {
//         final macros = {};
//         expect(r'\def\foo{1}', toParse(new Settings({macros})));
//         expect(macros["\\foo"]).toBeFalsy();
//     });

//     test("\\def changes settings.macros with globalGroup", () => {
//         final macros = {};
//         expect(r'\gdef\foo{1}', toParse(new Settings({macros, globalGroup: true})));
//         expect(macros["\\foo"]).toBeTruthy();
//     });

//     test("\\newcommand doesn't change settings.macros", () => {
//         final macros = {};
//         expect(r'\newcommand\foo{x^2}\foo+\foo', toParse(new Settings({macros})));
//         expect(macros["\\foo"]).toBeFalsy();
//     });

//     test("\\newcommand changes settings.macros with globalGroup", () => {
//         final macros = {};
//         expect(r'\newcommand\foo{x^2}\foo+\foo'.toParse(
//             new Settings({macros, globalGroup: true}));
//         expect(macros["\\foo"]).toBeTruthy();
//     });

//     test("\\newcommand defines new macros", () => {
//         expect(r'\newcommand\foo{x^2}\foo+\foo'.toParseLike(r'x^2+x^2');
//         expect(r'\newcommand{\foo}{x^2}\foo+\foo'.toParseLike(r'x^2+x^2');
//         // Function detection
//         expect(r'\newcommand\bar{x^2}\bar+\bar'.not, toParse());
//         expect(r'\newcommand{\bar}{x^2}\bar+\bar'.not, toParse());
//         // Symbol detection
//         expect(r'\newcommand\lambda{x^2}\lambda'.not, toParse());
//         expect(r'\newcommand\textdollar{x^2}\textdollar'.not, toParse());
//         // Macro detection
//         expect(r'\newcommand{\foo}{1}\foo\newcommand{\foo}{2}\foo'.not, toParse());
//         // Implicit detection
//         expect(r'\newcommand\limits{}'.not, toParse());
//     });

//     test("\\renewcommand redefines macros", () => {
//         expect(r'\renewcommand\foo{x^2}\foo+\foo'.not, toParse());
//         expect(r'\renewcommand{\foo}{x^2}\foo+\foo'.not, toParse());
//         expect(r'\renewcommand\bar{x^2}\bar+\bar'.toParseLike(r'x^2+x^2');
//         expect(r'\renewcommand{\bar}{x^2}\bar+\bar'.toParseLike(r'x^2+x^2');
//         expect(r'\newcommand{\foo}{1}\foo\renewcommand{\foo}{2}\foo'.toParseLike(r'12');
//     });

//     test("\\providecommand (re)defines macros", () => {
//         expect(r'\providecommand\foo{x^2}\foo+\foo'.toParseLike(r'x^2+x^2');
//         expect(r'\providecommand{\foo}{x^2}\foo+\foo'.toParseLike(r'x^2+x^2');
//         expect(r'\providecommand\bar{x^2}\bar+\bar'.toParseLike(r'x^2+x^2');
//         expect(r'\providecommand{\bar}{x^2}\bar+\bar'.toParseLike(r'x^2+x^2');
//         expect(`\newcommand{\foo}{1}\foo\providecommand{\foo}{2}\foo`
//             .toParseLike(r'12');
//         expect(`\providecommand{\foo}{1}\foo\renewcommand{\foo}{2}\foo`
//             .toParseLike(r'12');
//         expect(`\providecommand{\foo}{1}\foo\providecommand{\foo}{2}\foo`
//             .toParseLike(r'12');
//     });

//     test("\\newcommand is local", () => {
//         expect(`\newcommand\foo{1}\foo{\renewcommand\foo{2}\foo}\foo`
//             .toParseLike(r'1{2}1');
//     });

//     test("\\newcommand accepts number of arguments", () => {
//         expect(r'\newcommand\foo.children[1]{#1^2}\foo x+\foo{y}'.toParseLike(r'x^2+y^2');
//         expect(r'\newcommand\foo.children[10]{#1^2}\foo 0123456789'.toParseLike(r'0^2');
//         expect(r'\newcommand\foo[x]{}'.not, toParse());
//         expect(r'\newcommand\foo[1.5]{}'.not, toParse());
//     });

//     // This may change in the future, if we support the extra features of
//     // \hspace.
//     test("should treat \\hspace, \\hskip like \\kern", () {
//         expect(r'\hspace{1em}'.toParseLike(r'\kern1em');
//         expect(r'\hskip{1em}'.toParseLike(r'\kern1em');
//     });

//     test("should expand \\limsup as expected", () => {
//         expect(r'\limsup'.toParseLike(r'\operatorname*{lim\,sup}');
//     });

//     test("should expand \\liminf as expected", () => {
//         expect(r'\liminf'.toParseLike(r'\operatorname*{lim\,inf}');
//     });

//     test("should expand \\plim as expected", () => {
//         expect(r'\plim'.toParseLike(r'\mathop{\operatorname{plim}}\limits');
//     });

//     test("should expand \\argmin as expected", () => {
//         expect(r'\argmin'.toParseLike(r'\operatorname*{arg\,min}');
//     });

//     test("should expand \\argmax as expected", () => {
//         expect(r'\argmax'.toParseLike(r'\operatorname*{arg\,max}');
//     });
// });

// group("\\tag support", () {
//     final displayMode = new Settings({displayMode: true});

//     test("should fail outside display mode", () => {
//         expect(r'\tag{hi}x+y'.not, toParse());
//     });

//     test("should fail with multiple tags", () => {
//         expect(r'\tag{1}\tag{2}x+y'.not, toParse(displayMode));
//     });

//     test("should build", () => {
//         expect(r'\tag{hi}x+y'.toBuild(displayMode);
//     });

//     test("should ignore location of \\tag", () => {
//         expect(r'\tag{hi}x+y'.toParseLike(r`([r'x+y\tag{hi}', displayMode);
//     });

//     test("should handle \\tag* like \\tag", () => {
//         expect(r'\tag{hi}x+y'.toParseLike(r`([r'\tag*{({hi})}x+y', displayMode);
//     });
// });

// group("leqno and fleqn rendering options", () => {
//     final expr = r'\tag{hi}x+y';
//     for (final opt of ["leqno", "fleqn"]) {
//         it(`should not add ${opt} class by default`, () => {
//             final settings = new Settings({displayMode: true});
//             final built = katex.__renderToDomTree(expr, settings);
//             expect(built.classes).not.toContain(opt);
//         });
//         it(`should not add ${opt} class when false`, () => {
//             final settings = new Settings({displayMode: true});
//             settings[opt] = false;
//             final built = katex.__renderToDomTree(expr, settings);
//             expect(built.classes).not.toContain(opt);
//         });
//         it(`should add ${opt} class when true`, () => {
//             final settings = new Settings({displayMode: true});
//             settings[opt] = true;
//             final built = katex.__renderToDomTree(expr, settings);
//             expect(built.classes).toContain(opt);
//         });
//     }
// });

// group("\\@binrel automatic bin/rel/ord", () => {
//     test("should generate proper class", () => {
//         expect("L\\@binrel+xR").toParseLike("L\\mathbin xR");
//         expect("L\\@binrel=xR").toParseLike("L\\mathrel xR");
//         expect("L\\@binrel xxR").toParseLike("L\\mathord xR");
//         expect("L\\@binrel{+}{x}R").toParseLike("L\\mathbin{{x}}R");
//         expect("L\\@binrel{=}{x}R").toParseLike("L\\mathrel{{x}}R");
//         expect("L\\@binrel{x}{x}R").toParseLike("L\\mathord{{x}}R");
//     });

//     test("should base on just first character in group", () => {
//         expect("L\\@binrel{+x}xR").toParseLike("L\\mathbin xR");
//         expect("L\\@binrel{=x}xR").toParseLike("L\\mathrel xR");
//         expect("L\\@binrel{xx}xR").toParseLike("L\\mathord xR");
//     });
// });

// group("A parser taking String objects", () {
//     test("should not fail on an empty String object", () {
//         expect(new String("")), toParse());
//     });

//     test("should parse the same as a regular string", () {
//         expect(new String("xy")).toParseLike(r'xy');
//         expect(new String(r(r'\div'))).toParseLike(r'\div');
//         expect(new String(r(r'\frac 1 2'))).toParseLike(r'\frac 1 2');
//     });
// });

// group("Unicode accents", () {
//     test("should parse Latin-1 letters in math mode", () {
//         // TODO(edemaine): Unsupported Latin-1 letters in math: ÇÐÞçðþ
//         expect(`ÀÁÂÃÄÅÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝàáâãäåèéêëìíîïñòóôõöùúûüýÿ`
//         .toParseLike(
//             r(r'\grave A\acute A\hat A\tilde A\ddot A\mathring A') +
//             r(r'\grave E\acute E\hat E\ddot E') +
//             r(r'\grave I\acute I\hat I\ddot I') +
//             r(r'\tilde N') +
//             r(r'\grave O\acute O\hat O\tilde O\ddot O') +
//             r(r'\grave U\acute U\hat U\ddot U') +
//             r(r'\acute Y') +
//             r(r'\grave a\acute a\hat a\tilde a\ddot a\mathring a') +
//             r(r'\grave e\acute e\hat e\ddot e') +
//             r(r'\grave ı\acute ı\hat ı\ddot ı') +
//             r(r'\tilde n') +
//             r(r'\grave o\acute o\hat o\tilde o\ddot o') +
//             r(r'\grave u\acute u\hat u\ddot u') +
//             r`([r'\acute y\ddot y', nonstrictSettings);
//     });

//     test("should parse Latin-1 letters in text mode", () {
//         // TODO(edemaine): Unsupported Latin-1 letters in text: ÇÐÞçðþ
//         expect(`\text{ÀÁÂÃÄÅÈÉÊËÌÍÎÏÑÒÓÔÕÖÙÚÛÜÝàáâãäåèéêëìíîïñòóôõöùúûüýÿ}`
//         .toParseLike(
//             r(r'\text{\')A\'A\^A\~A\"A\r A` +
//             r(r'\')E\'E\^E\"E` +
//             r(r'\')I\'I\^I\"I` +
//             r(r'\~N') +
//             r(r'\')O\'O\^O\~O\"O` +
//             r(r'\')U\'U\^U\"U` +
//             r`\'Y` +
//             r(r'\')a\'a\^a\~a\"a\r a` +
//             r(r'\')e\'e\^e\"e` +
//             r(r'\')ı\'ı\^ı\"ı` +
//             r(r'\~n') +
//             r(r'\')o\'o\^o\~o\"o` +
//             r(r'\')u\'u\^u\"u` +
//             r`\'y\"y}`, strictSettings);
//     });

//     test("should support \\aa in text mode", () {
//         expect(r'\text{\aa\AA}'.toParseLike(r`([r'\text{\r a\r A}', strictSettings);
//         expect(r'\aa'.not, toParse(strictSettings));
//         expect(r'\Aa'.not, toParse(strictSettings));
//     });

//     test("should parse combining characters", () {
//         expect("A\u0301C\u0301").toParseLike(r`([r'Á\acute C', nonstrictSettings);
//         expect("\\text{A\u0301C\u0301}").toParseLike(r`\text{Á\'C}`, strictSettings);
//     });

//     test("should parse multi-accented characters", () {
//         expect(r'ấā́ắ\text{ấā́ắ}', toParse(nonstrictSettings));
//         // Doesn't parse quite the same as
//         // "\\text{\\'{\\^a}\\'{\\=a}\\'{\\u a}}" because of the ordgroups.
//     });

//     test("should parse accented i's and j's", () {
//         expect(r'íȷ́'.toParseLike(r`([r'\acute ı\acute ȷ', nonstrictSettings);
//         expect(r'ấā́ắ\text{ấā́ắ}', toParse(nonstrictSettings));
//     });
// });

// group("Unicode", () {
//     test("should parse negated relations", () {
//         expect(r'∉∤∦≁≆≠≨≩≮≯≰≱⊀⊁⊈⊉⊊⊋⊬⊭⊮⊯⋠⋡⋦⋧⋨⋩⋬⋭⪇⪈⪉⪊⪵⪶⪹⪺⫋⫌', toParse(strictSettings));
//     });

//     test("should build relations", () {
//         expect(r'∈∋∝∼∽≂≃≅≈≊≍≎≏≐≑≒≓≖≗≜≡≤≥≦≧≪≫≬≳≷≺≻≼≽≾≿∴∵∣≔≕⩴⋘⋙⟂⊨∌'.toBuild(strictSettings);
//     });

//     test("should build big operators", () {
//         expect(r'∏∐∑∫∬∭∮⋀⋁⋂⋃⨀⨁⨂⨄⨆'.toBuild(strictSettings);
//     });

//     test("should build more relations", () {
//         expect(r'⊂⊃⊆⊇⊏⊐⊑⊒⊢⊣⊩⊪⊸⋈⋍⋐⋑⋔⋛⋞⋟⌢⌣⩾⪆⪌⪕⪖⪯⪰⪷⪸⫅⫆≘≙≚≛≝≞≟≲⩽⪅≶⋚⪋'.toBuild(strictSettings);
//     });

//     test("should parse symbols", () {
//         expect("£¥ℂℍℑℎℓℕ℘ℙℚℜℝℤℲℵðℶℷℸ⅁∀∁∂∃∇∞∠∡∢♠♡♢♣♭♮♯✓°¬‼⋮\u00B7\u00A9").toBuild(strictSettings);
//         expect("\\text{£¥ℂℍℎ\u00A9\u00AE\uFE0F}").toBuild(strictSettings);
//     });

//     test("should build Greek capital letters", () {
//         expect("\u0391\u0392\u0395\u0396\u0397\u0399\u039A\u039C\u039D" +
//                 "\u039F\u03A1\u03A4\u03A7\u03DD").toBuild(strictSettings);
//     });

//     test("should build arrows", () {
//         expect(r'←↑→↓↔↕↖↗↘↙↚↛↞↠↢↣↦↩↪↫↬↭↮↰↱↶↷↼↽↾↾↿⇀⇁⇂⇃⇄⇆⇇⇈⇉'.toBuild(strictSettings);
//     });

//     test("should build more arrows", () {
//         expect(r'⇊⇋⇌⇍⇎⇏⇐⇑⇒⇓⇔⇕⇚⇛⇝⟵⟶⟷⟸⟹⟺⟼'.toBuild(strictSettings);
//     });

//     test("should build binary operators", () {
//         expect("±×÷∓∔∧∨∩∪≀⊎⊓⊔⊕⊖⊗⊘⊙⊚⊛⊝⊞⊟⊠⊡⊺⊻⊼⋇⋉⋊⋋⋌⋎⋏⋒⋓⩞\u22C5").toBuild(strictSettings);
//     });

//     test("should build delimiters", () {
//         expect("\\left\u230A\\frac{a}{b}\\right\u230B").toBuild();
//         expect("\\left\u2308\\frac{a}{b}\\right\u2308").toBuild();
//         expect("\\left\u27ee\\frac{a}{b}\\right\u27ef").toBuild();
//         expect("\\left\u27e8\\frac{a}{b}\\right\u27e9").toBuild();
//         expect("\\left\u23b0\\frac{a}{b}\\right\u23b1").toBuild();
//         expect(r'┌x┐ └x┘'.toBuild();
//         expect("\u231Cx\u231D \u231Ex\u231F").toBuild();
//         expect("\u27E6x\u27E7").toBuild();
//         expect("\\llbracket \\rrbracket").toBuild();
//         expect("\\lBrace \\rBrace").toBuild();
//     });

//     test("should build some surrogate pairs", () {
//         var wideCharStr = "";
//         wideCharStr += String.fromCharCode(0xD835, 0xDC00);   // bold A
//         wideCharStr += String.fromCharCode(0xD835, 0xDC68);   // bold italic A
//         wideCharStr += String.fromCharCode(0xD835, 0xDD04);   // Fraktur A
//         wideCharStr += String.fromCharCode(0xD835, 0xDD38);   // double-struck
//         wideCharStr += String.fromCharCode(0xD835, 0xDC9C);   // script A
//         wideCharStr += String.fromCharCode(0xD835, 0xDDA0);   // sans serif A
//         wideCharStr += String.fromCharCode(0xD835, 0xDDD4);   // bold sans A
//         wideCharStr += String.fromCharCode(0xD835, 0xDE08);   // italic sans A
//         wideCharStr += String.fromCharCode(0xD835, 0xDE70);   // monospace A
//         wideCharStr += String.fromCharCode(0xD835, 0xDFCE);   // bold zero
//         wideCharStr += String.fromCharCode(0xD835, 0xDFE2);   // sans serif zero
//         wideCharStr += String.fromCharCode(0xD835, 0xDFEC);   // bold sans zero
//         wideCharStr += String.fromCharCode(0xD835, 0xDFF6);   // monospace zero
//         expect(wideCharStr).toBuild(strictSettings);

//         var wideCharText = "\text{";
//         wideCharText += String.fromCharCode(0xD835, 0xDC00);   // bold A
//         wideCharText += String.fromCharCode(0xD835, 0xDC68);   // bold italic A
//         wideCharText += String.fromCharCode(0xD835, 0xDD04);   // Fraktur A
//         wideCharText += String.fromCharCode(0xD835, 0xDD38);   // double-struck
//         wideCharText += String.fromCharCode(0xD835, 0xDC9C);   // script A
//         wideCharText += String.fromCharCode(0xD835, 0xDDA0);   // sans serif A
//         wideCharText += String.fromCharCode(0xD835, 0xDDD4);   // bold sans A
//         wideCharText += String.fromCharCode(0xD835, 0xDE08);   // italic sans A
//         wideCharText += String.fromCharCode(0xD835, 0xDE70);   // monospace A
//         wideCharText += String.fromCharCode(0xD835, 0xDFCE);   // bold zero
//         wideCharText += String.fromCharCode(0xD835, 0xDFE2);   // sans serif zero
//         wideCharText += String.fromCharCode(0xD835, 0xDFEC);   // bold sans zero
//         wideCharText += String.fromCharCode(0xD835, 0xDFF6);   // monospace zero
//         wideCharText += "}";
//         expect(wideCharText).toBuild(strictSettings);
//     });
// });

// group("The maxSize setting", () {
//     final rule = r'\rule{999em}{999em}';

//     test("should clamp size when set", () {
//         final built = getBuilt(rule, new Settings({maxSize: 5})).children[0];
//         expect(built.style.borderRightWidth, "5em");
//         expect(built.style.borderTopWidth, "5em");
//     });

//     test("should not clamp size when not set", () {
//         final built = getBuilt(rule).children[0];
//         expect(built.style.borderRightWidth, "999em");
//         expect(built.style.borderTopWidth, "999em");
//     });

//     test("should make zero-width rules if a negative maxSize is passed", () {
//         final built = getBuilt(rule, new Settings({maxSize: -5})).children[0];
//         expect(built.style.borderRightWidth, "0em");
//         expect(built.style.borderTopWidth, "0em");
//     });
// });

// group("The maxExpand setting", () => {
//     test("should prevent expansion", () => {
//         expect(r'\gdef\foo{1}\foo', toParse());
//         expect(r'\gdef\foo{1}\foo', toParse(new Settings({maxExpand: 2})));
//         expect(r'\gdef\foo{1}\foo'.not, toParse(new Settings({maxExpand: 1})));
//         expect(r'\gdef\foo{1}\foo'.not, toParse(new Settings({maxExpand: 0})));
//     });

//     test("should prevent infinite loops", () => {
//         expect(r'\gdef\foo{\foo}\foo'.not.toParse(
//             new Settings({maxExpand: 10}));
//     });
// });

// group("The \\mathchoice function", () {
//     final cmd = r'\sum_{k = 0}^{\infty} x^k';

//     test("should render as if there is nothing other in display math", () {
//         expect(`\\displaystyle\\mathchoice{${cmd}}{T}{S}{SS}`)
//             .toBuildLike(`\\displaystyle${cmd}`);
//     });

//     test("should render as if there is nothing other in text", () {
//         expect(`\\mathchoice{D}{${cmd}}{S}{SS}`).toBuildLike(cmd);
//     });

//     test("should render as if there is nothing other in scriptstyle", () {
//         expect(`x_{\\mathchoice{D}{T}{${cmd}}{SS}}`).toBuildLike(`x_{${cmd}}`);
//     });

//     test("should render  as if there is nothing other in scriptscriptstyle", () {
//         expect(`x_{y_{\\mathchoice{D}{T}{S}{${cmd}}}}`).toBuildLike(`x_{y_{${cmd}}}`);
//     });
// });

// group("Newlines via \\\\ and \\newline", () {
//     test("should build \\\\ and \\newline the same", () => {
//         expect(r'hello \\ world'.toBuildLike(r'hello \newline world');
//         expect(r'hello \\[1ex] world'.toBuildLike(
//             "hello \\newline[1ex] world");
//     });

//     test("should not allow \\cr at top level", () => {
//         expect(r'hello \cr world'.not.toBuild();
//     });

//     test("array redefines and resets \\\\", () => {
//         expect(`a\\b\begin{matrix}x&y\\z&w\end{matrix}\\c`
//             .toParseLike(r'a\newline b\begin{matrix}x&y\cr z&w\end{matrix}\newline c');
//     });

//     test("\\\\ causes newline, even after mrel and mop", () => {
//         final markup = katex.renderToString(r(r'M = \\ a + \\ b \\ c'));
//         // Ensure newlines appear outside base spans (because, in this regexp,
//         // base span occurs immediately after each newline span).
//         expect(markup).toMatch(
//             /(<span class="base">.*?<\/span><span class="mspace newline"><\/span>){3}<span class="base">/);
//         expect(markup).toMatchSnapshot();
//     });
// });

// group("Symbols", () {
//     test("should parse \\text{\\i\\j}", () => {
//         expect(r'\text{\i\j}'.toBuild(strictSettings);
//     });

//     test("should parse spacing functions in math or text mode", () => {
//         expect(r'A\;B\,C\nobreakspace \text{A\;B\,C\nobreakspace}'.toBuild(strictSettings);
//     });

//     test("should render ligature commands like their unicode characters", () => {
//         expect(r'\text{\ae\AE\oe\OE\o\O\ss}'.toBuildLike(r`([r'\text{æÆœŒøØß}', strictSettings);
//     });
// });

// group("strict setting", () {
//     test("should allow unicode text when not strict", () => {
//         expect(r'é', toParse(new Settings(nonstrictSettings)));
//         expect(r'試', toParse(new Settings(nonstrictSettings)));
//         expect(r'é', toParse(new Settings({strict: "ignore"})));
//         expect(r'試', toParse(new Settings({strict: "ignore"})));
//         expect(r'é', toParse(new Settings({strict: ()) => false}));
//         expect(r'試', toParse(new Settings({strict: ()) => false}));
//         expect(r'é', toParse(new Settings({strict: ()) => "ignore"}));
//         expect(r'試', toParse(new Settings({strict: ()) => "ignore"}));
//     });

//     test("should forbid unicode text when strict", () => {
//         expect(r'é'.not, toParse(new Settings({strict: true})));
//         expect(r'試'.not, toParse(new Settings({strict: true})));
//         expect(r'é'.not, toParse(new Settings({strict: "error"})));
//         expect(r'試'.not, toParse(new Settings({strict: "error"})));
//         expect(r'é'.not, toParse(new Settings({strict: ()) => true}));
//         expect(r'試'.not, toParse(new Settings({strict: ()) => true}));
//         expect(r'é'.not, toParse(new Settings({strict: ()) => "error"}));
//         expect(r'試'.not, toParse(new Settings({strict: ()) => "error"}));
//     });

//     test("should warn about unicode text when default", () => {
//         expect(r'é'.toWarn(new Settings());
//         expect(r'試'.toWarn(new Settings());
//     });

//     test("should always allow unicode text in text mode", () => {
//         expect(r'\text{é試}', toParse(nonstrictSettings));
//         expect(r'\text{é試}', toParse(strictSettings));
//         expect(r'\text{é試}', toParse());
//     });

//     test("should warn about top-level \\newline in display mode", () => {
//         expect(r'x\\y'.toWarn(new Settings({displayMode: true}));
//         expect(r'x\\y', toParse(new Settings({displayMode: false})));
//     });
// });

// group("Internal __* interface", () {
//     final latex = r'\sum_{k = 0}^{\infty} x^k';
//     final rendered = katex.renderToString(latex);

//     test("__parse renders same as renderToString", () => {
//         final parsed = katex.__parse(latex);
//         expect(buildTree(parsed, latex, new Settings()).toMarkup(), rendered);
//     });

//     test("__renderToDomTree renders same as renderToString", () => {
//         final tree = katex.__renderToDomTree(latex);
//         expect(tree.toMarkup(), rendered);
//     });

//     test("__renderToHTMLTree renders same as renderToString sans MathML", () => {
//         final tree = katex.__renderToHTMLTree(latex);
//         final renderedSansMathML = rendered.replace(
//             /<span class="katex-mathml">.*?<\/span>/, '');
//         expect(tree.toMarkup(), renderedSansMathML);
//     });
// });

// group("Extending katex by new fonts and symbols", () {
//     beforeAll(() => {
//         final fontName = "mockEasternArabicFont";
//         // add eastern arabic numbers to symbols table
//         // these symbols are ۰۱۲۳۴۵۶۷۸۹ and ٠١٢٣٤٥٦٧٨٩
//         for (var number = 0; number <= 9; number++) {
//             final persianNum = String.fromCharCode(0x0660 + number);
//             katex.__defineSymbol(
//                 "math", fontName, "textord", persianNum, persianNum);
//             final arabicNum = String.fromCharCode(0x06F0 + number);
//             katex.__defineSymbol(
//                 "math", fontName, "textord", arabicNum, arabicNum);
//         }
//     });
//     test("should throw on rendering new symbols with no font metrics", () => {
//         // Lets parse 99^11 in eastern arabic
//         final errorMessage = "Font metrics not found for font: mockEasternArabicFont-Regular.";
//         expect(() => {
//             katex.__renderToDomTree("۹۹^{۱۱}", strictSettings);
//         }).toThrow(errorMessage);
//     });
//     test("should add font metrics to metrics map and render successfully", () => {
//         final mockMetrics = {};
//         // mock font metrics for the symbols that we added previously
//         for (var number = 0; number <= 9; number++) {
//             mockMetrics[0x0660 + number] = [-0.00244140625, 0.6875, 0, 0];
//             mockMetrics[0x06F0 + number] = [-0.00244140625, 0.6875, 0, 0];
//         }
//         katex.__setFontMetrics('mockEasternArabicFont-Regular', mockMetrics);
//         expect(r'۹۹^{۱۱}'.toBuild();
//     });
//     test("Add new font class to new extended symbols", () => {
//         expect(katex.renderToString("۹۹^{۱۱}")).toMatchSnapshot();
//     });
// });
}
