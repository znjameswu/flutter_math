import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../render/layout/custom_layout.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

/// Frac node.
class FracNode extends SlotableNode {
  /// Numerator.
  final EquationRowNode numerator;

  /// Denumerator.
  final EquationRowNode denominator;

  /// Bar size.
  ///
  /// If null, will use default bar size.
  final Measurement barSize;

  /// Whether it is a continued frac `\cfrac`.
  final bool continued; // TODO continued

  FracNode({
    // this.options,
    @required this.numerator,
    @required this.denominator,
    this.barSize,
    this.continued = false,
  })  : assert(numerator != null),
        assert(denominator != null);

  @override
  List<EquationRowNode> computeChildren() => [numerator, denominator];

  @override
  BuildResult buildWidget(
          MathOptions options, List<BuildResult> childBuildResults) =>
      BuildResult(
        options: options,
        widget: CustomLayout(
          delegate: FracLayoutDelegate(
            barSize: barSize,
            options: options,
          ),
          children: <Widget>[
            CustomLayoutId(
              id: _FracPos.numer,
              child: childBuildResults[0].widget,
            ),
            CustomLayoutId(
              id: _FracPos.denom,
              child: childBuildResults[1].widget,
            ),
          ],
        ),
      );

  @override
  List<MathOptions> computeChildOptions(MathOptions options) => [
        options.havingStyle(options.style.fracNum()),
        options.havingStyle(options.style.fracDen()),
      ];

  @override
  bool shouldRebuildWidget(MathOptions oldOptions, MathOptions newOptions) =>
      false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
          List<EquationRowNode> newChildren) =>
      this.copyWith(numerator: newChildren[0], denumerator: newChildren[1]);

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'numerator': numerator.toJson(),
      'denominator': denominator.toJson(),
      if (barSize != null) 'barSize': barSize.toString(),
      if (continued) 'continued': continued,
    });

  FracNode copyWith({
    MathOptions options,
    EquationRowNode numerator,
    EquationRowNode denumerator,
    Measurement barSize,
  }) =>
      FracNode(
        // options: options ?? this.options,
        numerator: numerator ?? this.numerator,
        denominator: denumerator ?? this.denominator,
        barSize: barSize ?? this.barSize,
      );
}

enum _FracPos {
  numer,
  denom,
}

class FracLayoutDelegate extends IntrinsicLayoutDelegate<_FracPos> {
  final Measurement barSize;
  final MathOptions options;

  FracLayoutDelegate({
    @required this.barSize,
    @required this.options,
  });

  var theta = 0.0;
  var height = 0.0;
  var a = 0.0;
  var width = 0.0;
  var barLength = 0.0;

  @override
  double computeDistanceToActualBaseline(
    TextBaseline baseline,
    Map<_FracPos, RenderBox> childrenTable,
  ) =>
      height;

  @override
  AxisConfiguration<_FracPos> performHorizontalIntrinsicLayout({
    @required Map<_FracPos, double> childrenWidths,
    bool isComputingIntrinsics = false,
  }) {
    final numerSize = childrenWidths[_FracPos.numer];
    final denomSize = childrenWidths[_FracPos.denom];
    final barLength = math.max(numerSize, denomSize);
    // KaTeX/src/katex.less
    final nullDelimiterWidth = 0.12.cssEm.toLpUnder(options);
    final width = barLength + 2 * nullDelimiterWidth;
    if (!isComputingIntrinsics) {
      this.barLength = barLength;
      this.width = width;
    }

    return AxisConfiguration(
      size: width,
      offsetTable: {
        _FracPos.numer: 0.5 * (width - numerSize),
        _FracPos.denom: 0.5 * (width - denomSize),
      },
    );
  }

  @override
  AxisConfiguration<_FracPos> performVerticalIntrinsicLayout({
    @required Map<_FracPos, double> childrenHeights,
    @required Map<_FracPos, double> childrenBaselines,
    bool isComputingIntrinsics = false,
  }) {
    final numerSize = childrenHeights[_FracPos.numer];
    final denomSize = childrenHeights[_FracPos.denom];
    final numerHeight = childrenBaselines[_FracPos.numer];
    final denomHeight = childrenBaselines[_FracPos.denom];
    final metrics = options.fontMetrics;
    final xi8 = metrics.defaultRuleThickness.cssEm.toLpUnder(options);
    theta = barSize?.toLpUnder(options) ?? xi8;
    // Rule 15b
    var u = (options.style > MathStyle.text
            ? metrics.num1
            : (theta != 0 ? metrics.num2 : metrics.num3))
        .cssEm
        .toLpUnder(options);
    var v = (options.style > MathStyle.text ? metrics.denom1 : metrics.denom2)
        .cssEm
        .toLpUnder(options);

    final hx = numerHeight;
    final dx = numerSize - numerHeight;
    final hz = denomHeight;
    final dz = denomSize - denomHeight;
    if (theta == 0) {
      // Rule 15c
      final phi = options.style > MathStyle.text ? 7 * xi8 : 3 * xi8;
      final psi = (u - dx) - (hz - v);
      if (psi < phi) {
        u += 0.5 * (phi - psi);
        v += 0.5 * (phi - psi);
      }
    } else {
      // Rule 15d
      final phi = options.style > MathStyle.text ? 3 * theta : theta;
      a = metrics.axisHeight.cssEm.toLpUnder(options);
      if (u - dx - a - 0.5 * theta < phi) {
        u = phi + dx + a + 0.5 * theta;
      }
      if (a - 0.5 * theta - hz + v < phi) {
        v = phi + hz - a + 0.5 * theta;
      }
    }
    final height = hx + u;
    final depth = dz + v;
    if (!isComputingIntrinsics) {
      this.height = height;
    }
    return AxisConfiguration(
      size: height + depth,
      offsetTable: {
        _FracPos.numer: height - u - hx,
        _FracPos.denom: height + v - hz,
      },
    );
  }

  @override
  void additionalPaint(PaintingContext context, Offset offset) {
    if (theta != 0) {
      final paint = Paint()
        ..color = options.color
        ..strokeWidth = theta;
      context.canvas.drawLine(
        Offset(0.5 * (width - barLength), height - a) + offset,
        Offset(0.5 * (width + barLength), height - a) + offset,
        paint,
      );
    }
  }
}
