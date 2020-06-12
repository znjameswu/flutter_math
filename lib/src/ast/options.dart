import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../font/metrics/font_metrics.dart';
import 'font_metrics.dart';
import 'size.dart';
import 'style.dart';

class Options {
  final MathStyle style;
  final Color color;
  // final Size size;
  SizeMode get size => sizeUnderTextStyle.underStyle(style);
  final SizeMode sizeUnderTextStyle;
  final bool phantom;
  final FontOptions textFontOptions;
  final FontOptions mathFontOptions;
  double get sizeMultiplier => this.size.sizeMultiplier;
  final double maxSize;
  // final num minRuleThickness; //???
  // final bool isBlank;
  // final bool mathord;
  // final bool textord;
  // final Measurement raise; //raisebox // Hard to implement

  // final int tableColCount;
  FontMetrics get fontMetrics => getGlobalMetrics(size);
  const Options({
    @required this.style,
    @required this.color,
    @required this.sizeUnderTextStyle,
    @required this.phantom,
    @required this.textFontOptions,
    @required this.mathFontOptions,
    @required this.maxSize,
    // @required this.minRuleThickness,
    // @required this.tableColCount,
  });

  static const displayOptions = Options(
    style: MathStyle.display,
    color: Colors.black,
    sizeUnderTextStyle: SizeMode.normalsize,
    phantom: false,
    textFontOptions: FontOptions(),
    mathFontOptions: FontOptions(),
    maxSize: double.infinity
    // minRuleThickness: 
  );

  // Options discardNonInheritable() {
  //   if (tableColCount == 0) return this;
  //   return this.copyWith(
  //     tableColCount: 0,
  //   );
  // }

  // Options underTableRow(int tableRowCount) =>
  //     this.copyWith(tableColCount: tableRowCount);

  Options havingStyle(MathStyle style) {
    if (this.style == style) return this;
    return this.copyWith(
      style: style,
    );
  }

  Options havingCrampedStyle() {
    if (this.style.cramped) return this;
    return this.copyWith(
      style: style.cramp(),
    );
  }

  Options havingSize(SizeMode size) {
    if (this.size == size && this.sizeUnderTextStyle == size) return this;
    return this.copyWith(
      style: style.atLeastText(),
      sizeUnderTextStyle: size,
    );
  }

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

  Options havingBaseSize() {
    if (this.sizeUnderTextStyle == SizeMode.normalsize) return this;
    return this.copyWith(
      sizeUnderTextStyle: SizeMode.normalsize,
    );
  }

  Options withColor(Color color) {
    if (this.color == color) return this;
    return this.copyWith(color: color);
  }

  Options withPhantom() {
    if (this.phantom) return this;
    return this.copyWith(phantom: true);
  }

  Options withTextFont(PartialFontOptions font) {
    return this.copyWith(
      mathFontOptions: const FontOptions(),
      textFontOptions: this.textFontOptions.mergeWith(font),
    );
  }

  Options withMathFont(FontOptions font) {
    if (font == this.mathFontOptions) return this;
    return this.copyWith(mathFontOptions: font);
  }
  // TODO()

  Color getColor() => this.phantom ? Color(0x00000000) : this.color;

  Options copyWith({
    MathStyle style,
    Color color,
    SizeMode sizeUnderTextStyle,
    bool phantom,
    FontOptions textFontOptions,
    FontOptions mathFontOptions,
    double maxSize,
    // num minRuleThickness,
    int tableColCount,
  }) {
    return Options(
      style: style ?? this.style,
      color: color ?? this.color,
      sizeUnderTextStyle: sizeUnderTextStyle ?? this.sizeUnderTextStyle,
      phantom: phantom ?? this.phantom,
      textFontOptions: textFontOptions ?? this.textFontOptions,
      mathFontOptions: mathFontOptions ?? this.mathFontOptions,
      maxSize: maxSize ?? this.maxSize,
      // minRuleThickness: minRuleThickness ?? this.minRuleThickness,
      // tableColCount: tableColCount ?? this.tableColCount,
    );
  }
}

class PartialOptions {
  final MathStyle style;
  final Color color;
  final SizeMode size;
  // SizeMode get size => sizeUnderTextStyle.underStyle(style);
  // final SizeMode sizeUnderTextStyle;
  final bool phantom;
  final FontOptions textFontOptions;
  final FontOptions mathFontOptions;
  double get sizeMultiplier => this.size.sizeMultiplier;
  final num maxSize;
  final num minRuleThickness; //???
  // final bool isBlank;
  // final bool mathord;
  // final bool textord;
  // final Measurement raise; //raisebox // Hard to implement
  FontMetrics get fontMetrics => getGlobalMetrics(size);
  const PartialOptions({
    this.style,
    this.color,
    this.size,
    // this.sizeUnderTextStyle,
    this.phantom,
    this.textFontOptions,
    this.mathFontOptions,
    // @required this.sizeMultiplier,
    this.maxSize,
    this.minRuleThickness,
  });
} //TODO

class PartialFontOptions extends FontOptions {} //TODO

class FontOptions {
  // final String font;
  final String fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontShape;
  const FontOptions({
    // @required this.font,
    this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.fontShape = FontStyle.normal,
  });

  FontOptions copyWith({
    // String font,
    String fontFamily,
    FontWeight fontWeight,
    FontStyle fontShape,
  }) {
    return FontOptions(
      // font: font ?? this.font,
      fontFamily: fontFamily ?? this.fontFamily,
      fontWeight: fontWeight ?? this.fontWeight,
      fontShape: fontShape ?? this.fontShape,
    );
  }

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
        o.fontShape == fontShape;
  }

  @override
  int get hashCode =>
      hashValues(fontFamily.hashCode, fontWeight.hashCode, fontShape.hashCode);
}
