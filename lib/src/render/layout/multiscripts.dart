import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../ast/font_metrics.dart';
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
    @required this.baseFontMetrics,
    this.subDrop,
    this.supDrop,
    this.presubDrop,
    this.presupDrop,
    @required this.base,
    this.sub,
    this.sup,
    this.presub,
    this.presup,
  })  : assert(base != null),
        assert(italic != null),
        super(key: key);

  final bool alignPostscripts;
  final double italic;

  final FontMetrics baseFontMetrics;
  final double subDrop;
  final double supDrop;
  final double presubDrop;
  final double presupDrop;

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
        baseFontMetrics: baseFontMetrics,
        subDrop: subDrop,
        supDrop: supDrop,
        presubDrop: presubDrop,
        presupDrop: presupDrop,
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

class MultiscriptsLayoutDelegate extends IntrinsicLayoutDelegate<_ScriptPos> {
  final bool alignPostscripts;
  final double italic;

  final FontMetrics baseFontMetrics;
  final double subDrop;
  final double supDrop;
  final double presubDrop;
  final double presupDrop;

  const MultiscriptsLayoutDelegate({
    @required this.alignPostscripts,
    @required this.italic,
    @required this.baseFontMetrics,
    this.subDrop,
    this.supDrop,
    this.presubDrop,
    this.presupDrop,
  });

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline, Map<_ScriptPos, RenderBox> childrenTable) =>
      nPlus(
        childrenTable[_ScriptPos.base].offset.dy,
        childrenTable[_ScriptPos.base]
            .getDistanceToBaseline(baseline, onlyReal: true),
      );

  @override
  AxisConfiguration<_ScriptPos> performIntrinsicLayout({
    Axis layoutDirection,
    double Function(RenderBox child) childSize,
    Map<_ScriptPos, RenderBox> childrenTable,
  }) {
    final sizeTable =
        childrenTable.map((id, child) => MapEntry(id, childSize(child)));

    final baseSize = sizeTable[_ScriptPos.base];
    final subscriptSize = sizeTable[_ScriptPos.sub] ?? 0;
    final superscriptSize = sizeTable[_ScriptPos.sup] ?? 0;
    final presubscriptSize = sizeTable[_ScriptPos.presub] ?? 0;
    final presuperscriptSize = sizeTable[_ScriptPos.presup] ?? 0;

    if (layoutDirection == Axis.horizontal) {
      final postscriptWidth = math.max(
        italic + superscriptSize,
        (alignPostscripts ? italic : 0) + subscriptSize,
      );
      final prescriptWidth = math.max(presubscriptSize, presuperscriptSize);

      final size = postscriptWidth + prescriptWidth + baseSize;

      return AxisConfiguration(
        size: size as double,
        offsetTable: {
          _ScriptPos.base: prescriptWidth,
          _ScriptPos.sub:
              prescriptWidth + baseSize + (alignPostscripts ? italic : 0),
          _ScriptPos.sup: prescriptWidth + baseSize + italic,
          _ScriptPos.presub: prescriptWidth - presubscriptSize,
          _ScriptPos.presup: prescriptWidth - presuperscriptSize,
        },
      );
    } else {
      final u = 0;
      final v = 0;
      //TODO
    }
  }
}
