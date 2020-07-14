import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../render/layout/custom_layout.dart';
import '../../render/layout/shift_baseline.dart';
import '../../render/utils/render_box_offset.dart';
import '../../utils/iterable_extensions.dart';
import '../options.dart';
import '../size.dart';
import '../style.dart';
import '../syntax_tree.dart';

enum MatrixSeparatorStyle {
  solid,
  dashed,
}

enum MatrixColumnAlign {
  left,
  center,
  right,
}

enum MatrixRowAlign {
  top,
  bottom,
  center,
  baseline,
  // axis,
}

class MatrixNode extends SlotableNode {
  final double arrayStretch;
  // Latex compatibility
  final bool hskipBeforeAndAfter;
  // refers to total spacing between columns, 2*arraycolsep
  // final List<Measurement> columnSpacing;

  final bool isSmall;
  final List<MatrixColumnAlign> columnAligns;

  // INCLUDE OUTERMOST LINES! DIFFERENT FROM MATHML!
  final List<MatrixSeparatorStyle> vLines;

  final List<Measurement> rowSpacings;

  // INCLUDE OUTERMOST LINES! DIFFERENT FROM MATHML!
  final List<MatrixSeparatorStyle> hLines;

  final List<List<EquationRowNode>> body;

  final int rows;
  final int cols;

  MatrixNode._({
    this.rows,
    this.cols,
    this.arrayStretch = 1.0,
    this.hskipBeforeAndAfter = false,
    this.isSmall = false,
    this.columnAligns,
    this.vLines,
    this.rowSpacings,
    // this.rowAligns,
    this.hLines,
    @required this.body,
  })  : assert(body != null),
        assert(body.length == rows),
        assert(body.every((row) => row != null)),
        assert(body.every((row) => row.length == cols)),
        assert(columnAligns.length == cols),
        assert(vLines.length == cols + 1),
        assert(rowSpacings.length == rows),
        assert(hLines.length == rows + 1);

  factory MatrixNode({
    double arrayStretch = 1.0,
    bool hskipBeforeAndAfter = false,
    bool isSmall = false,
    @required List<MatrixColumnAlign> columnAligns,
    @required List<MatrixSeparatorStyle> vLines,
    @required List<Measurement> rowSpacings,
    @required List<MatrixSeparatorStyle> hLines,
    @required List<List<EquationRowNode>> body,
  }) {
    final cols = [
      body.map((row) => row.length).max() ?? 0,
      columnAligns.length,
      vLines.length - 1,
    ].max();
    final sanitizedColumnAligns =
        columnAligns.extendToByFill(cols, MatrixColumnAlign.center);
    final sanitizedVLines = vLines.extendToByFill(cols + 1, null);

    final rows = [
      body.length,
      rowSpacings.length,
      hLines.length - 1,
    ].max();

    final sanitizedBody = body
        .map((row) => row.extendToByFill(cols, null))
        .toList(growable: false)
        .extendToByFill(rows, List.filled(cols, null));
    final sanitizedRowSpacing =
        rowSpacings.extendToByFill(rows, Measurement.zero);
    final sanitizedHLines = hLines.extendToByFill(rows + 1, null);

    return MatrixNode._(
      rows: rows,
      cols: cols,
      arrayStretch: arrayStretch,
      hskipBeforeAndAfter: hskipBeforeAndAfter,
      isSmall: isSmall,
      columnAligns: sanitizedColumnAligns,
      vLines: sanitizedVLines,
      rowSpacings: sanitizedRowSpacing,
      hLines: sanitizedHLines,
      body: sanitizedBody,
    );
  }

  @override
  List<BuildResult> buildSlotableWidget(
      Options options, List<BuildResult> childBuildResults) {
    assert(childBuildResults.length == rows * cols);
    // Flutter's Table does not provide fine-grained control of borders
    return [
      BuildResult(
        options: options,
        italic: 0.0,
        widget: ShiftBaseline(
          relativePos: 0.5,
          offset: options.fontMetrics.axisHeight.cssEm.toLpUnder(options),
          child: CustomLayout<int>(
            delegate: MatrixLayoutDelegate(
              rows: rows,
              cols: cols,
              ruleThickness: options.fontMetrics.defaultRuleThickness.cssEm
                  .toLpUnder(options),
              arrayskip: arrayStretch * 12.0.pt.toLpUnder(options),
              rowSpacings: rowSpacings
                  .map((e) => e?.toLpUnder(options) ?? 0.0)
                  .toList(growable: false),
              hLines: hLines,
              hskipBeforeAndAfter: hskipBeforeAndAfter,
              arraycolsep: isSmall
                  ? (5 / 18)
                      .cssEm
                      .toLpUnder(options.havingStyle(MathStyle.script))
                  : 5.0.pt.toLpUnder(options),
              vLines: vLines,
              columnAligns: columnAligns,
            ),
            children: childBuildResults
                .mapIndexed((result, index) =>
                    CustomLayoutId(id: index, child: result?.widget))
                .where((element) => element.child != null)
                .toList(growable: false),
          ),
        ),
      ),
    ];
  }

  @override
  List<Options> computeChildOptions(Options options) =>
      List.filled(rows * cols, options, growable: false);

  @override
  List<EquationRowNode> computeChildren() =>
      body.expand((row) => row).toList(growable: false);

  @override
  AtomType get leftType => AtomType.ord;

  @override
  AtomType get rightType => AtomType.ord;

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<EquationRowNode> updateChildren(
      List<EquationRowNode> newChildren) {
    assert(newChildren.length >= rows * cols);
    var body =
        List<List<EquationRowNode>>.filled(rows, const [], growable: false);
    for (var i = 0; i < rows; i++) {
      body[i] = newChildren.sublist(i * cols + (i + 1) * cols);
    }
    return copyWith(body: body);
  }

  MatrixNode copyWith({
    double arrayStretch,
    bool hskipBeforeAndAfter,
    bool isSmall,
    List<MatrixColumnAlign> columnAligns,
    List<MatrixSeparatorStyle> columnLines,
    List<Measurement> rowSpacing,
    List<MatrixSeparatorStyle> rowLines,
    List<List<EquationRowNode>> body,
  }) =>
      MatrixNode(
        arrayStretch: arrayStretch ?? this.arrayStretch,
        hskipBeforeAndAfter: hskipBeforeAndAfter ?? this.hskipBeforeAndAfter,
        isSmall: isSmall ?? this.isSmall,
        columnAligns: columnAligns ?? this.columnAligns,
        vLines: columnLines ?? this.vLines,
        rowSpacings: rowSpacing ?? this.rowSpacings,
        hLines: rowLines ?? this.hLines,
        body: body ?? this.body,
      );
}

class MatrixLayoutDelegate extends IntrinsicLayoutDelegate<int> {
  final int rows;
  final int cols;
  final double ruleThickness;
  final double arrayskip;
  final List<double> rowSpacings;
  final List<MatrixSeparatorStyle> hLines;
  final bool hskipBeforeAndAfter;
  final double arraycolsep;
  final List<MatrixSeparatorStyle> vLines;
  final List<MatrixColumnAlign> columnAligns;

  MatrixLayoutDelegate({
    @required this.rows,
    @required this.cols,
    @required this.ruleThickness,
    @required this.arrayskip,
    @required this.rowSpacings,
    @required this.hLines,
    @required this.hskipBeforeAndAfter,
    @required this.arraycolsep,
    @required this.vLines,
    @required this.columnAligns,
  })  : vLinePos = List.filled(cols + 1, 0.0),
        hLinePos = List.filled(rows + 1, 0.0);

  final List<double> hLinePos;

  final List<double> vLinePos;

  var totalHeight = 0.0;
  var width = 0.0;

  @override
  double computeDistanceToActualBaseline(
          TextBaseline baseline,
          // ignore: avoid_returning_null
          Map<int, RenderBox> childrenTable) =>
      null;

  @override
  AxisConfiguration<int> performIntrinsicLayout(
      {Axis layoutDirection,
      double Function(RenderBox child) childSize,
      Map<int, RenderBox> childrenTable,
      bool isComputingIntrinsics}) {
    if (layoutDirection == Axis.horizontal) {
      final childWidths = List.generate(cols * rows, (index) {
        final cell = childrenTable[index];
        return cell != null ? childSize(cell) : 0.0;
      }, growable: false);

      // Calculate width for each column
      final colWidths = List.filled(cols, 0.0);
      for (var i = 0; i < cols; i++) {
        for (var j = 0; j < rows; j++) {
          colWidths[i] = math.max(
            colWidths[i],
            childWidths[j * cols + i],
          );
        }
      }

      // Layout each column
      final colPos = List.filled(cols, 0.0, growable: false);

      var pos = 0.0;
      vLinePos[0] = pos;
      pos += (vLines[0] != null) ? ruleThickness : 0.0;
      pos += hskipBeforeAndAfter ? arraycolsep : 0.0;

      for (var i = 0; i < cols - 1; i++) {
        colPos[i] = pos;
        pos += colWidths[i] + arraycolsep;
        vLinePos[i + 1] = pos;
        pos += (vLines[i + 1] != null) ? ruleThickness : 0.0;
        pos += arraycolsep;
      }

      colPos[cols - 1] = pos;
      pos += colWidths[cols - 1];
      pos += hskipBeforeAndAfter ? arraycolsep : 0.0;
      vLinePos[cols] = pos;
      pos += (vLines[cols] != null) ? ruleThickness : 0.0;

      width = pos;

      // Determine position of children
      final childPos = List.generate(rows * cols, (index) {
        final col = index % cols;
        switch (columnAligns[col]) {
          case MatrixColumnAlign.left:
            return colPos[col];
          case MatrixColumnAlign.right:
            return colPos[col] + colWidths[col] - childWidths[index];
          case MatrixColumnAlign.center:
          default:
            return colPos[col] + (colWidths[col] - childWidths[index]) / 2;
        }
      }, growable: false);

      return AxisConfiguration(
        size: width,
        offsetTable: childPos.asMap(),
      );
    } else {
      final childHeights = List.generate(cols * rows, (index) {
        final cell = childrenTable[index];
        return cell != null
            ? (isComputingIntrinsics ? childSize(cell) : cell.layoutHeight)
            : 0.0;
      }, growable: false);
      final childDepth = List.generate(cols * rows, (index) {
        final cell = childrenTable[index];
        return cell != null
            ? (isComputingIntrinsics ? 0.0 : cell.layoutDepth)
            : 0.0;
      }, growable: false);

      // Calculate height and depth for each row
      // Minimum height and depth are 0.7 * arrayskip and 0.3 * arrayskip
      final rowHeights = List.filled(rows, 0.7 * arrayskip, growable: false);
      final rowDepth = List.filled(rows, 0.3 * arrayskip, growable: false);
      for (var i = 0; i < rows; i++) {
        for (var j = 0; j < cols; j++) {
          rowHeights[i] = math.max(
            rowHeights[i],
            childHeights[i * cols + j],
          );
          rowDepth[i] = math.max(
            rowDepth[i],
            childDepth[i * cols + j],
          );
        }
      }

      // Layout rows
      var pos = 0.0;
      final rowBaselinePos = List.filled(rows, 0.0, growable: false);

      for (var i = 0; i < rows; i++) {
        hLinePos[i] = pos;
        pos += (hLines[i] != null) ? ruleThickness : 0.0;
        pos += rowHeights[i];
        rowBaselinePos[i] = pos;
        pos += rowDepth[i];
        pos += i < rows - 1 ? rowSpacings[i] : 0;
      }
      hLinePos[rows] = pos;
      pos += (hLines[rows] != null) ? ruleThickness : 0.0;

      totalHeight = pos;

      // Calculate position for each children
      final childPos = List.generate(rows * cols, (index) {
        final row = index ~/ cols;
        return rowBaselinePos[row] - childHeights[index];
      }, growable: false);
      return AxisConfiguration(
        size: totalHeight,
        offsetTable: childPos.asMap(),
      );
    }
  }

  // Paint vlines and hlines
  @override
  void additionalPaint(PaintingContext context, Offset offset) {
    const dashSize = 4;
    final paint = Paint()..strokeWidth = ruleThickness;
    for (var i = 0; i < hLines.length; i++) {
      switch (hLines[i]) {
        case MatrixSeparatorStyle.solid:
          context.canvas.drawLine(
              Offset(
                offset.dx,
                offset.dy + hLinePos[i] + ruleThickness / 2,
              ),
              Offset(
                offset.dx + width,
                offset.dy + hLinePos[i] + ruleThickness / 2,
              ),
              paint);
          break;
        case MatrixSeparatorStyle.dashed:
          for (var dx = 0.0; dx < width; dx += dashSize) {
            context.canvas.drawLine(
                Offset(
                  offset.dx + dx,
                  offset.dy + hLinePos[i] + ruleThickness / 2,
                ),
                Offset(
                  offset.dx + math.min(dx + dashSize / 2, width),
                  offset.dy + hLinePos[i] + ruleThickness / 2,
                ),
                paint);
          }
          break;
      }
    }

    for (var i = 0; i < vLines.length; i++) {
      switch (vLines[i]) {
        case MatrixSeparatorStyle.solid:
          context.canvas.drawLine(
              Offset(
                offset.dx + vLinePos[i] + ruleThickness / 2,
                offset.dy,
              ),
              Offset(
                offset.dx + vLinePos[i] + ruleThickness / 2,
                offset.dy + totalHeight,
              ),
              paint);
          break;
        case MatrixSeparatorStyle.dashed:
          for (var dy = 0.0; dy < totalHeight; dy += dashSize) {
            context.canvas.drawLine(
                Offset(
                  offset.dx + vLinePos[i] + ruleThickness / 2,
                  offset.dy + dy,
                ),
                Offset(
                  offset.dx + vLinePos[i] + ruleThickness / 2,
                  offset.dy + math.min(dy + dashSize / 2, totalHeight),
                ),
                paint);
          }
          break;
      }
    }
  }
}
