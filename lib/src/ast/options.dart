import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../font/metrics/font_metrics.dart';
import 'font_metrics.dart';
import 'size.dart';
import 'style.dart';
import 'syntax_tree.dart';

/// Options for equation element rendering
///
/// Every [GreenNode] is rendered with an [Options]. It controls their size,
/// color, font, etc.
///
/// [Options] is immutable. Each modification returns a new instance of
/// [Options].
class Options {
  /// The style used to render the math node
  final MathStyle style;

  /// Text color
  final Color color;

  /// Real size applied to equation elements under current style
  SizeMode get size => sizeUnderTextStyle.underStyle(style);

  /// Declared size for equation elements.
  ///
  /// User declared size such as \tiny \Huge. The real size applied to equation
  /// elements also depends on current style.
  final SizeMode sizeUnderTextStyle;

  /// Font options for text mode
  ///
  /// Text-mode font options will merge on top of each other. And they will be
  /// reset if any math-mode font style is declared
  final FontOptions textFontOptions;

  /// Font options for math mode
  ///
  /// Math-mode font options will override each other.
  final FontOptions mathFontOptions;

  /// Size multiplier applied to equation elements.
  double get sizeMultiplier => this.size.sizeMultiplier;

  // final double maxSize;
  // final num minRuleThickness; //???
  // final bool isBlank;

  /// Font metrics under current size
  FontMetrics get fontMetrics => getGlobalMetrics(size);

  /// Font size under current size
  ///
  /// This is the font size passed to Flutter's [Text] widget.
  final double fontSize;

  final double logicalPpi;

  const Options._({
    @required this.fontSize,
    @required this.logicalPpi,
    @required this.style,
    this.color = Colors.black,
    this.sizeUnderTextStyle = SizeMode.normalsize,
    this.textFontOptions,
    this.mathFontOptions,
    // @required this.maxSize,
    // @required this.minRuleThickness,
  });

  factory Options({
    MathStyle style = MathStyle.display,
    Color color = Colors.black,
    SizeMode sizeUnderTextStyle = SizeMode.normalsize,
    FontOptions textFontOptions,
    FontOptions mathFontOptions,
    double fontSize,
    double logicalPpi,
    double baseSizeMultiplier = 1.0,
    // @required this.maxSize,
    // @required this.minRuleThickness,
  }) {
    final effectiveFontSize = fontSize ??
        (logicalPpi == null
            ? _defaultPtPerEm / Unit.lp.toPt
            : defaultFontSizeFor(logicalPpi: logicalPpi));
    final effectiveLogicalPPI =
        logicalPpi ?? defaultLogicalPpiFor(fontSize: effectiveFontSize);
    return Options._(
      fontSize: effectiveFontSize * baseSizeMultiplier,
      logicalPpi: effectiveLogicalPPI * baseSizeMultiplier,
      style: style,
      color: color,
      sizeUnderTextStyle: sizeUnderTextStyle,
      mathFontOptions: mathFontOptions,
      textFontOptions: textFontOptions,
    );
  }

  static const _defaultLpPerPt = 72.27 / 160;

  static const _defaultPtPerEm = 10;

  static const defaultLogicalPpi = 72.27 / _defaultLpPerPt;

  static const defaultFontSize = _defaultPtPerEm / _defaultLpPerPt;

  static double defaultLogicalPpiFor({double fontSize}) =>
      fontSize * Unit.inches.toPt / _defaultPtPerEm;

  static double defaultFontSizeFor({double logicalPpi}) =>
      _defaultPtPerEm / Unit.inches.toPt * logicalPpi;

  /// Default options for displayed equations
  static const displayOptions = Options._(
    fontSize: defaultFontSize,
    logicalPpi: defaultLogicalPpi,
    style: MathStyle.display,
  );

  /// Default options for in-line equations
  static const textOptions = Options._(
    fontSize: defaultFontSize,
    logicalPpi: defaultLogicalPpi,
    style: MathStyle.text,
  );

  /// Returns [Options] with given [MathStyle]
  Options havingStyle(MathStyle style) {
    if (this.style == style) return this;
    return this.copyWith(
      style: style,
    );
  }

  /// Returns [Options] with their styles set to cramped (e.g. textCramped)
  Options havingCrampedStyle() {
    if (this.style.cramped) return this;
    return this.copyWith(
      style: style.cramp(),
    );
  }

  /// Returns [Options] with their user-declared size set to given size
  Options havingSize(SizeMode size) {
    if (this.size == size && this.sizeUnderTextStyle == size) return this;
    return this.copyWith(
      style: style.atLeastText(),
      sizeUnderTextStyle: size,
    );
  }

  /// Returns [Options] with size reset to [SizeMode.normalsize] and given
  /// style. If style is not given, then the current style will be increased to
  /// at least [MathStyle.text]
  Options havingStyleUnderBaseSize(MathStyle style) {
    style = style ?? this.style.atLeastText();
    if (this.sizeUnderTextStyle == SizeMode.normalsize && this.style == style) {
      return this;
    }
    return this.copyWith(
      style: style,
      sizeUnderTextStyle: SizeMode.normalsize,
    );
  }

  /// Returns [Options] with size reset to [SizeMode.normalsize]
  Options havingBaseSize() {
    if (this.sizeUnderTextStyle == SizeMode.normalsize) return this;
    return this.copyWith(
      sizeUnderTextStyle: SizeMode.normalsize,
    );
  }

  /// Returns [Options] with given text color
  Options withColor(Color color) {
    if (this.color == color) return this;
    return this.copyWith(color: color);
  }

  /// Returns [Options] with current text-mode font options merged with given
  /// font differences
  Options withTextFont(PartialFontOptions font) => this.copyWith(
        mathFontOptions: null,
        textFontOptions:
            (this.textFontOptions ?? FontOptions()).mergeWith(font),
      );

  /// Returns [Options] with given math font
  Options withMathFont(FontOptions font) {
    if (font == this.mathFontOptions) return this;
    return this.copyWith(mathFontOptions: font);
  }

  /// Utility method copyWith
  Options copyWith({
    MathStyle style,
    Color color,
    SizeMode sizeUnderTextStyle,
    FontOptions textFontOptions,
    FontOptions mathFontOptions,
    // double maxSize,
    // num minRuleThickness,
  }) =>
      Options._(
        fontSize: this.fontSize,
        logicalPpi: this.logicalPpi,
        style: style ?? this.style,
        color: color ?? this.color,
        sizeUnderTextStyle: sizeUnderTextStyle ?? this.sizeUnderTextStyle,
        textFontOptions: textFontOptions ?? this.textFontOptions,
        mathFontOptions: mathFontOptions ?? this.mathFontOptions,
        // maxSize: maxSize ?? this.maxSize,
        // minRuleThickness: minRuleThickness ?? this.minRuleThickness,
      );

  /// Merge an [OptionsDiff] into current [Options]
  Options merge(OptionsDiff partialOptions) {
    var res = this;
    if (partialOptions.size != null) {
      res = res.havingSize(partialOptions.size);
    }
    if (partialOptions.style != null) {
      res = res.havingStyle(partialOptions.style);
    }
    if (partialOptions.color != null) {
      res = res.withColor(partialOptions.color);
    }
    // if (partialOptions.phantom == true) {
    //   res = res.withPhantom();
    // }
    if (partialOptions.textFontOptions != null) {
      res = res.withTextFont(partialOptions.textFontOptions);
    }
    if (partialOptions.mathFontOptions != null) {
      res = res.withMathFont(partialOptions.mathFontOptions);
    }
    return res;
  }
}

/// Difference between the current [Options] and the desired [Options]
///
/// This is used to declaratively describe the modifications to [Options]
class OptionsDiff {
  /// Override [Options.style]
  final MathStyle style;

  /// Override declared size
  final SizeMode size;

  /// Override text color
  final Color color;

  /// Merge font differences into text-mode font options.
  final PartialFontOptions textFontOptions;

  /// Override math-mode font
  final FontOptions mathFontOptions;

  const OptionsDiff({
    this.style,
    this.color,
    this.size,
    // this.phantom,
    this.textFontOptions,
    this.mathFontOptions,
  });
}

/// Options for font selection
class FontOptions {
  /// Font family. E.g. Main, Math, Sans-Serif, etc
  final String fontFamily;

  /// Font weight. Bold or normal
  final FontWeight fontWeight;

  /// Font weight. Italic or normal
  final FontStyle fontShape;

  /// Fallback font options if a character cannot be found in this font
  final List<FontOptions> fallback;

  const FontOptions({
    this.fontFamily = 'Main',
    this.fontWeight = FontWeight.normal,
    this.fontShape = FontStyle.normal,
    this.fallback = const [],
  });

  /// Complete font name. Used to index [CharacterMetrics]
  String get fontName {
    final postfix = '${fontWeight == FontWeight.bold ? 'Bold' : ''}'
        '${fontShape == FontStyle.italic ? "Italic" : ""}';
    return '$fontFamily-${postfix.isEmpty ? "Regular" : postfix}';
  }

  /// Utility method
  FontOptions copyWith({
    String fontFamily,
    FontWeight fontWeight,
    FontStyle fontShape,
    List<FontOptions> fallback,
  }) =>
      FontOptions(
        fontFamily: fontFamily ?? this.fontFamily,
        fontWeight: fontWeight ?? this.fontWeight,
        fontShape: fontShape ?? this.fontShape,
        fallback: fallback ?? this.fallback,
      );

  /// Merge a font difference into current font
  FontOptions mergeWith(PartialFontOptions value) {
    if (value == null) return this;
    return copyWith(
      fontFamily: value.fontFamily,
      fontWeight: value.fontWeight,
      fontShape: value.fontShape,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is FontOptions &&
        o.fontFamily == fontFamily &&
        o.fontWeight == fontWeight &&
        o.fontShape == fontShape &&
        listEquals(o.fallback, fallback);
  }

  @override
  int get hashCode =>
      hashValues(fontFamily.hashCode, fontWeight.hashCode, fontShape.hashCode);
}

/// Difference between the current [FontOptions] and the desired [FontOptions]
///
/// This is used to declaratively describe the modifications to [FontOptions]
class PartialFontOptions extends FontOptions {
  /// Override font family
  final String fontFamily;

  /// Override font weight
  final FontWeight fontWeight;

  /// Override font style
  final FontStyle fontShape;

  const PartialFontOptions({
    this.fontFamily,
    this.fontWeight,
    this.fontShape,
  });
}
