import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:tuple/tuple.dart';

import '../../ast/options.dart';
import '../../ast/size.dart';
import '../../ast/style.dart';
import '../utils/nullable_plus.dart';
import '../utils/render_box_offset.dart';
import 'custom_layout.dart';

/// This should be the perfect use case for [CustomMultiChildLayout] and
/// [MultiChildLayoutDelegate]. However, they don't support baseline
/// functionalities. So we have to start from [MultiChildRenderObjectWidget].
///
/// This should also be a great showcase for [LayoutId], but the generic
/// parameter prevents us to use or extend from [LayoutId].
///
/// This should also be a great showcase for [MultiChildLayoutParentData],
/// but the lack of generic ([Object] type) is undesirable.

enum _ScriptPos {
  base,
  sub,
  sup,
  presub,
  presup,
}

class Multiscripts extends StatelessWidget {
  const Multiscripts({
    Key key,
    this.alignPostscripts = false,
    @required this.italic,
    @required this.isBaseCharacterBox,
    @required this.baseOptions,
    this.subOptions,
    this.supOptions,
    this.presubOptions,
    this.presupOptions,
    @required this.base,
    this.sub,
    this.sup,
    this.presub,
    this.presup,
  })  : assert(base != null && baseOptions != null),
        assert(sup == null || supOptions != null),
        assert(sub == null || subOptions != null),
        assert(presup == null || presupOptions != null),
        assert(presub == null || presubOptions != null),
        assert(sup != null || sub != null || presub != null || presup != null),
        assert(italic != null),
        super(key: key);

  final bool alignPostscripts;
  final Measurement italic;
  final bool isBaseCharacterBox;

  final Options baseOptions;
  final Options subOptions;
  final Options supOptions;
  final Options presubOptions;
  final Options presupOptions;

  final Widget base;
  final Widget sub;
  final Widget sup;
  final Widget presub;
  final Widget presup;

  @override
  Widget build(BuildContext context) {
    return CustomLayout(
      delegate: MultiscriptsLayoutDelegate(
        alignPostscripts: alignPostscripts,
        italic: italic,
        isBaseCharacterBox: isBaseCharacterBox,
        baseOptions: baseOptions,
        subOptions: subOptions,
        supOptions: supOptions,
        presubOptions: presubOptions,
        presupOptions: presupOptions,
      ),
      children: <Widget>[
        CustomLayoutId(
          id: _ScriptPos.base,
          child: base,
        ),
        if (sub != null)
          CustomLayoutId(
            id: _ScriptPos.sub,
            child: sub,
          ),
        if (sup != null)
          CustomLayoutId(
            id: _ScriptPos.sup,
            child: sup,
          ),
        if (presub != null)
          CustomLayoutId(
            id: _ScriptPos.presub,
            child: presub,
          ),
        if (presup != null)
          CustomLayoutId(
            id: _ScriptPos.presup,
            child: presup,
          ),
      ],
    );
  }
}

// Superscript and subscripts are handled in the TeXbook on page
// 445-446, rules 18(a-f).
class MultiscriptsLayoutDelegate extends IntrinsicLayoutDelegate<_ScriptPos> {
  final bool alignPostscripts;
  final Measurement italic;

  final bool isBaseCharacterBox;
  final Options baseOptions;
  final Options subOptions;
  final Options supOptions;
  final Options presubOptions;
  final Options presupOptions;

  MultiscriptsLayoutDelegate({
    @required this.alignPostscripts,
    @required this.italic,
    @required this.isBaseCharacterBox,
    @required this.baseOptions,
    @required this.subOptions,
    @required this.supOptions,
    @required this.presubOptions,
    @required this.presupOptions,
  });

  var baselineDistance = 0.0;

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<_ScriptPos, RenderBox> childrenTable) =>
      baselineDistance;
  // // This will trigger Flutter assertion error
  // nPlus(
  //   childrenTable[_ScriptPos.base].offset.dy,
  //   childrenTable[_ScriptPos.base]
  //       .getDistanceToBaseline(baseline, onlyReal: true),
  // );

  @override
  AxisConfiguration<_ScriptPos> performIntrinsicLayout({
    Axis layoutDirection,
    double Function(RenderBox child) childSize,
    Map<_ScriptPos, RenderBox> childrenTable,
    bool isComputingIntrinsics,
  }) {
    final italic = this.italic.toLpUnder(baseOptions);
    final base = childrenTable[_ScriptPos.base];
    final sub = childrenTable[_ScriptPos.sub];
    final sup = childrenTable[_ScriptPos.sup];
    final presub = childrenTable[_ScriptPos.presub];
    final presup = childrenTable[_ScriptPos.presup];

    final sizeTable =
        childrenTable.map((id, child) => MapEntry(id, childSize(child)));

    final baseSize = sizeTable[_ScriptPos.base];
    final subSize = sizeTable[_ScriptPos.sub] ?? 0;
    final supSize = sizeTable[_ScriptPos.sup] ?? 0;
    final presubSize = sizeTable[_ScriptPos.presub] ?? 0;
    final presupSize = sizeTable[_ScriptPos.presup] ?? 0;

    if (layoutDirection == Axis.horizontal) {
      final scriptSpace = 0.5.pt.toLpUnder(supOptions);

      final extendedSubSize = sub != null ? subSize + scriptSpace : 0.0;
      final extendedSupSize = sup != null ? supSize + scriptSpace : 0.0;
      final extendedPresubSize =
          presub != null ? presubSize + scriptSpace : 0.0;
      final extendedPresupSize =
          presup != null ? presupSize + scriptSpace : 0.0;

      final postscriptWidth = math.max(
        extendedSupSize,
        - (alignPostscripts ? 0.0 : italic) + extendedSubSize,
      );
      final prescriptWidth = math.max(extendedPresubSize, extendedPresupSize);

      final fullSize = postscriptWidth + prescriptWidth + baseSize;

      return AxisConfiguration(
        size: fullSize,
        offsetTable: {
          _ScriptPos.base: prescriptWidth,
          _ScriptPos.sub:
              prescriptWidth + baseSize - (alignPostscripts ? 0.0 : italic),
          _ScriptPos.sup: prescriptWidth + baseSize,
          _ScriptPos.presub: prescriptWidth - presubSize,
          _ScriptPos.presup: prescriptWidth - presupSize,
        },
      );
    } else {
      // Dart is no good without Go-style garbage. ^_^
      final postscriptRes = calculateUV(
        base: base,
        sub: sub,
        sup: sup,
        baseSize: baseSize,
        supSize: supSize,
        subSize: subSize,
        baseOptions: baseOptions,
        subOptions: subOptions,
        supOptions: supOptions,
        isBaseCharacterBox: isBaseCharacterBox,
        isComputingIntrinsics: isComputingIntrinsics,
      );

      final prescriptRes = calculateUV(
        base: base,
        sub: presub,
        sup: presup,
        baseSize: baseSize,
        supSize: presupSize,
        subSize: presubSize,
        baseOptions: baseOptions,
        subOptions: presubOptions,
        supOptions: presupOptions,
        isBaseCharacterBox: isBaseCharacterBox,
        isComputingIntrinsics: isComputingIntrinsics,
      );

      final subShift = postscriptRes.item2;
      final supShift = postscriptRes.item1;
      final presubShift = prescriptRes.item2;
      final presupShift = prescriptRes.item1;

      final subHeight =
          isComputingIntrinsics ? subSize : (sub?.layoutHeight ?? 0.0);
      final subDepth = isComputingIntrinsics ? 0.0 : (sub?.layoutDepth ?? 0.0);
      final supHeight =
          isComputingIntrinsics ? supSize : (sup?.layoutHeight ?? 0.0);
      final presubHeight =
          isComputingIntrinsics ? presubSize : (presub?.layoutHeight ?? 0.0);
      final presubDepth =
          isComputingIntrinsics ? 0.0 : (presub?.layoutDepth ?? 0.0);
      final presupHeight =
          isComputingIntrinsics ? presupSize : (presup?.layoutHeight ?? 0.0);

      // Rule 18f
      final height = math.max(supHeight + supShift, presupHeight + presupShift);
      final depth = math.max(subDepth + subShift, presubDepth + presubShift);

      if (!isComputingIntrinsics) {
        baselineDistance = height;
      }

      return AxisConfiguration(
        size: height + depth,
        offsetTable: {
          _ScriptPos.base: height - base.layoutHeight,
          _ScriptPos.sub: height + subShift - subHeight,
          _ScriptPos.sup: height - supShift - supHeight,
          _ScriptPos.presub: height + presubShift - presubHeight,
          _ScriptPos.presup: height - presupShift - presupHeight,
        },
      );
    }
  }
}

Tuple2<double, double> calculateUV({
  RenderBox base,
  RenderBox sub,
  RenderBox sup,
  double baseSize,
  double supSize,
  double subSize,
  Options baseOptions,
  Options subOptions,
  Options supOptions,
  bool isBaseCharacterBox,
  bool isComputingIntrinsics,
}) {
  final metrics = baseOptions.fontMetrics;

  // TexBook Rule 18a
  final h = isComputingIntrinsics ? baseSize : base.layoutHeight;
  final d = baseSize - h;
  var u = 0.0;
  var v = 0.0;
  if (sub != null) {
    final r = subOptions.fontMetrics.subDrop.cssEm.toLpUnder(subOptions);
    v = isBaseCharacterBox ? 0 : d + r;
  }
  if (sup != null) {
    final q = supOptions.fontMetrics.supDrop.cssEm.toLpUnder(supOptions);
    v = isBaseCharacterBox ? 0 : h - q;
  }

  if (sup == null && sub != null) {
    // Rule 18b
    final hx = isComputingIntrinsics ? subSize : sub.layoutHeight;
    v = math.max(
      v,
      math.max(
        metrics.sub1.cssEm.toLpUnder(baseOptions),
        hx - 0.8 * metrics.xHeight.cssEm.toLpUnder(baseOptions),
      ),
    );
  } else if (sup != null) {
    // Rule 18c
    final dx = isComputingIntrinsics ? 0.0 : sup.layoutDepth;
    final p = (baseOptions.style == MathStyle.display
            ? metrics.sup1
            : (baseOptions.style.cramped ? metrics.sup3 : metrics.sup2))
        .cssEm
        .toLpUnder(baseOptions);

    u = math.max(
      u,
      math.max(
        p,
        dx + 0.25 * metrics.xHeight.cssEm.toLpUnder(baseOptions),
      ),
    );
    // Rule 18d
    if (sub != null) {
      v = math.max(v, metrics.sub2.cssEm.toLpUnder(baseOptions));
      // Rule 18e
      final theta = metrics.defaultRuleThickness.cssEm.toLpUnder(baseOptions);
      final hy = isComputingIntrinsics ? subSize : sub.layoutHeight;
      if ((u - dx) - (hy - v) < 4 * theta) {
        v = 4 * theta - u + dx + hy;
        final psi = 0.8 * metrics.xHeight.cssEm.toLpUnder(baseOptions);
        if (psi > 0) {
          u += psi;
          v -= psi;
        }
      }
    }
  }
  return Tuple2(u, v);
}
