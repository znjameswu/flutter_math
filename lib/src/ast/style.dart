import 'size.dart';

enum MathStyle {
  display,
  displayCramped,
  text,
  textCramped,
  script,
  scriptCramped,
  scriptscript,
  scriptscriptCramped,
}

enum MathStyleDiff {
  sub,
  sup,
  fracNum,
  fracDen,
  cramp,
  text,
}

extension MathStyleExt on MathStyle {
  // MathStyle get pureStyle => MathStyle.values[(this.index / 2).floor()];

  bool get cramped => this.index.isEven;
  int get size => this.index ~/ 2;

  MathStyle reduce(MathStyleDiff diff) => diff == null
      ? this
      : MathStyle.values[reduceTable[diff.index][this.index]];

  static const reduceTable = [
    [4, 5, 4, 5, 6, 7, 6, 7], //sup
    [5, 5, 5, 5, 7, 7, 7, 7], //sub
    [2, 3, 4, 5, 6, 7, 6, 7], //fracNum
    [3, 3, 5, 5, 7, 7, 7, 7], //fracDen
    [1, 1, 3, 3, 5, 5, 7, 7], //cramp
    [0, 1, 2, 3, 2, 3, 2, 3], //text
  ];
  MathStyle sup() => this.reduce(MathStyleDiff.sup);
  MathStyle sub() => this.reduce(MathStyleDiff.sub);
  MathStyle fracNum() => this.reduce(MathStyleDiff.fracNum);
  MathStyle fracDen() => this.reduce(MathStyleDiff.fracDen);
  MathStyle cramp() => this.reduce(MathStyleDiff.cramp);
  MathStyle atLeastText() => this.reduce(MathStyleDiff.text);

  // MathStyle atLeastText() =>
  //     this.index > MathStyle.textCramped.index ? this : MathStyle.text;

  bool isTight() => this.size >= 2;
}

extension MathStyleExtOnInt on int {
  MathStyle toMathStyle() => MathStyle.values[(this * 2).clamp(0, 6).toInt()];
}

extension MathStyleExtOnSize on SizeMode {
  /// katex/src/Options.js/sizeStyleMap
  SizeMode underStyle(MathStyle style) {
    if (style.index <= MathStyle.textCramped.index) {
      return this;
    }
    return SizeMode.values[sizeStyleMap[this.index][style.size - 1]];
  }

  static const sizeStyleMap = [
    [1, 1, 1],
    [2, 1, 1],
    [3, 1, 1],
    [4, 2, 1],
    [5, 2, 1],
    [6, 3, 1],
    [7, 4, 2],
    [8, 6, 3],
    [9, 7, 6],
    [10, 8, 7],
    [11, 10, 9],
  ];
}
