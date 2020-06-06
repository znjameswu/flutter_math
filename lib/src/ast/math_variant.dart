// import 'dart:ui';

// import 'package:tuple/tuple.dart';

// enum MathVariant {
//   normal,
//   bold,
//   italic,
//   boldItalic,
//   doubleStruck,
//   frakturBold,
//   script,
//   boldScript,
//   fraktur,
//   sansSerif,
//   sansSerifBold,
//   sansSerifItalic,
//   sansSerifBoldItalic,
//   monospace,
//   initial,
//   tailed,
//   looped,
//   stretched,
// }

// extension MathVariantExt on MathVariant {
//   static const _propMap = [
//     Tuple4(FontWeight.normal, FontStyle.normal, 'KaTeX_Main', 'normal'),
//   ];
//   FontWeight get fontWeight => _propMap[this.index].item1;
//   FontStyle get fontStyle => _propMap[this.index].item2;
//   String get fontFamily => _propMap[this.index].item3;
//   String get mathVariant => _propMap[this.index].item4;
// }