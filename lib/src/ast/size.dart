//ignore_for_file: constant_identifier_names

import 'options.dart';
import 'style.dart';

// This table gives the number of TeX pts in one of each *absolute* TeX unit.
// Thus, multiplying a length by this number converts the length from units
// into pts.  Dividing the result by ptPerEm gives the number of ems
// *assuming* a font size of ptPerEm (normal size, normal style).

enum Unit {
  // https://en.wikibooks.org/wiki/LaTeX/Lengths and
  // https://tex.stackexchange.com/a/8263
  pt, // TeX point
  mm, // millimeter
  cm, // centimeter
  inches, // inch //Avoid name collision
  bp, // big (PostScript) points
  pc, // pica
  dd, // didot
  cc, // cicero (12 didot)
  nd, // new didot
  nc, // new cicero (12 new didot)
  sp, // scaled point (TeX's internal smallest unit)
  px, // \pdfpxdimen defaults to 1 bp in pdfTeX and LuaTeX

  ex, // The height of 'x'
  em, // The width of 'M', which is often the size of the font. ()
  mu,

  lp, // Flutter's logical pixel (96 lp per inch)
  cssEm, // Unit used for font metrics. Analogous to KaTeX's internal unit, but
  // always scale with options.
}

extension UnitExt on Unit {
  static const _ptPerUnit = {
    Unit.pt: 1.0,
    Unit.mm: 7227 / 2540,
    Unit.cm: 7227 / 254,
    Unit.inches: 72.27,
    Unit.bp: 803 / 800,
    Unit.pc: 12.0,
    Unit.dd: 1238 / 1157,
    Unit.cc: 14856 / 1157,
    Unit.nd: 685 / 642,
    Unit.nc: 1370 / 107,
    Unit.sp: 1 / 65536,
    // https://tex.stackexchange.com/a/41371
    Unit.px: 803 / 800,

    Unit.ex: null,
    Unit.em: null,
    Unit.mu: null,
    // https://api.flutter.dev/flutter/dart-ui/Window/devicePixelRatio.html
    // Unit.lp: 72.27 / 96,
    Unit.lp: 72.27 / 160, //TODO
    // Unit.lp: 72.27 / 200,
    Unit.cssEm: null,
  };
  double get toPt => _ptPerUnit[this];

  // Beware of null exceptions
  // double get toLp => lpPerUnit[this.index];
  // static Map<Unit, double> lpPerUnit = _ptPerUnit
  //     .map((key, value) => MapEntry(key, value / _ptPerUnit[Unit.lp]));
  static Unit parse(String unit) => unit.parseUnit();
}

extension UnitExtOnString on String {
  Unit parseUnit() => const {
        'pt': Unit.pt,
        'mm': Unit.mm,
        'cm': Unit.cm,
        'inches': Unit.inches,
        'bp': Unit.bp,
        'pc': Unit.pc,
        'dd': Unit.dd,
        'cc': Unit.cc,
        'nd': Unit.nd,
        'nc': Unit.nc,
        'sp': Unit.sp,
        'px': Unit.px,
        'ex': Unit.ex,
        'em': Unit.em,
        'mu': Unit.mu,
        'lp': Unit.lp,
        'cssEm': Unit.cssEm,
      }[this];
}

class Measurement {
  final double value;
  final Unit unit;
  const Measurement({this.value, this.unit});

  double toPtUnder(Options options) {
    if (unit.toPt != null) {
      // Absolute units
      return value * unit.toPt;
    } else {
      switch (unit) {
        // `mu` units scale with scriptstyle/scriptscriptstyle.
        case Unit.mu:
          return value *
              options.fontMetrics.cssEmPerMu *
              options.fontMetrics.ptPerEm *
              options.sizeMultiplier;
        // `ex` and `em` always refer to the *textstyle* font
        // in the current size.
        case Unit.ex:
          return value *
              options.fontMetrics.xHeight *
              options.fontMetrics.ptPerEm *
              options.havingStyle(options.style.atLeastText()).sizeMultiplier;
        case Unit.em:
          return value *
              options.fontMetrics.quad *
              options.fontMetrics.ptPerEm *
              options.havingStyle(options.style.atLeastText()).sizeMultiplier;
        case Unit.cssEm:
          return value * options.fontMetrics.ptPerEm * options.sizeMultiplier;
        default:
          throw ArgumentError("Invalid unit: '${unit.toString()}'");
      }
    }
  }

  double toLpUnder(Options options) =>
      toPtUnder(options) / Unit.lp.toPt * options.baseSizeMultiplier;
  double toCssEmUnder(Options options) =>
      toPtUnder(options) /
      (const Measurement(value: 1.0, unit: Unit.cssEm)).toPtUnder(options);

  // // Following code is from unit.js/calculateSize. It is only applicable to KaTeX's rendering mechanism.
  // double toEmUnder(Options options) {
  //   double scale;
  //   if (unit.toPt != null) {
  //     // Absolute units
  //     scale = unit.toPt / options.fontMetrics.ptPerEm / options.sizeMultiplier;
  //     // Unscale to make absolute units
  //   } else if (unit == Unit.mu) {
  //     // `mu` units scale with scriptstyle/scriptscriptstyle.
  //     scale = options.fontMetrics.cssEmPerMu;
  //   } else {
  //     // Other relative units always refer to the *textstyle* font
  //     // in the current size.
  //     // isTight() means current style is script/scriptscript.
  //     final unitOptions = options.style.isTight()
  //         ? options.havingStyle(options.style.atLeastText())
  //         : options;
  //     switch (unit) {
  //       case Unit.ex:
  //         scale = unitOptions.fontMetrics.xHeight;
  //         break;
  //       case Unit.em:
  //         scale = unitOptions.fontMetrics.quad;
  //         break;
  //       default:
  //         throw ArgumentError("Invalid unit: '${unit.toString()}'");
  //     }
  //     if (unitOptions != options) {
  //       scale *= unitOptions.sizeMultiplier / options.sizeMultiplier;
  //     }
  //   }
  //   return math.min(value * scale, options.maxSize);
  // }

  static const zero = Measurement(value: 0, unit: Unit.pt);
}

extension MeasurementExtOnNum on double {
  Measurement get pt => Measurement(value: this, unit: Unit.pt);
  Measurement get mm => Measurement(value: this, unit: Unit.mm);
  Measurement get cm => Measurement(value: this, unit: Unit.cm);
  Measurement get inches => Measurement(value: this, unit: Unit.inches);
  Measurement get bp => Measurement(value: this, unit: Unit.bp);
  Measurement get pc => Measurement(value: this, unit: Unit.pc);
  Measurement get dd => Measurement(value: this, unit: Unit.dd);
  Measurement get cc => Measurement(value: this, unit: Unit.cc);
  Measurement get nd => Measurement(value: this, unit: Unit.nd);
  Measurement get nc => Measurement(value: this, unit: Unit.nc);
  Measurement get sp => Measurement(value: this, unit: Unit.sp);
  Measurement get px => Measurement(value: this, unit: Unit.px);
  Measurement get ex => Measurement(value: this, unit: Unit.ex);
  Measurement get em => Measurement(value: this, unit: Unit.em);
  Measurement get mu => Measurement(value: this, unit: Unit.mu);
  Measurement get lp => Measurement(value: this, unit: Unit.lp);
  Measurement get cssEm => Measurement(value: this, unit: Unit.cssEm);
}

enum SizeMode {
  tiny,
  size2,
  scriptsize,
  footnotesize,
  small,
  normalsize,
  large,
  Large,
  LARGE,
  huge,
  HUGE,
}

extension SizeModeExt on SizeMode {
  double get sizeMultiplier => const [
        0.5,
        0.6,
        0.7,
        0.8,
        0.9,
        1.0,
        1.2,
        1.44,
        1.728,
        2.074,
        2.488,
      ][this.index];
  // static const measurementMapTable = [
  //   Measurement(5, Unit.pt),
  //   Measurement(6, Unit.pt),
  //   Measurement(7, Unit.pt),
  //   Measurement(8, Unit.pt),
  //   Measurement(9, Unit.pt),
  //   Measurement(10, Unit.pt),
  //   Measurement(12, Unit.pt),
  //   Measurement(14.4, Unit.pt),
  //   Measurement(17.28, Unit.pt),
  //   Measurement(20.74, Unit.pt),
  //   Measurement(24.88, Unit.pt),
  // ];
}
