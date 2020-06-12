import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math/src/ast/nodes/math_atom.dart';
import 'package:provider/provider.dart';

import '../render/layout/eq_row.dart';
import '../widgets/scope.dart';
import 'options.dart';
import 'size.dart';
import 'spacing.dart';

/// Root of Roslyn's Red-Green Tree
///
/// [Description of Roslyn's Red-Green Tree](https://docs.microsoft.com/en-us/archive/blogs/ericlippert/persistence-facades-and-roslyns-red-green-trees)
class SyntaxTree {
  final GreenNode greenRoot;
  final Options options;
  SyntaxTree({
    @required this.greenRoot,
    this.options,
  })  : assert(greenRoot != null),
        assert(options != null);

  SyntaxNode _root;
  SyntaxNode get root => _root ??= SyntaxNode(
        parent: null,
        value: greenRoot,
        pos: -1, // Important
      );

  SyntaxTree replaceNode(SyntaxNode pos, GreenNode newNode) {
    if (identical(pos.value, newNode)) {
      return this;
    }
    if (identical(pos, root)) {
      return SyntaxTree(greenRoot: newNode);
    }
    if (pos.parent == null) {
      throw ArgumentError(
          'The replaced node is not the root of this tree but has no parent');
    }
    return replaceNode(
        pos.parent,
        pos.parent.value.updateChildren(pos.parent.value.children
            .map((child) => identical(child, pos.value) ? newNode : child)
            .toList(growable: false)));
  }
}

/// Node of Roslyn's Red Tree. Immutable facade for any math nodes.
///
/// [Description of Roslyn's Red-Green Tree](https://docs.microsoft.com/en-us/archive/blogs/ericlippert/persistence-facades-and-roslyns-red-green-trees).
///
/// [SyntaxNode] is an immutable facade over [GreenNode]. It stores absolute
/// information and context parameters of an abstract syntax node which cannot
/// be stored inside [GreenNode]. Every node of the red tree is evaluated
/// top-down on demand.
class SyntaxNode {
  final SyntaxNode parent;
  final GreenNode value;
  final int pos;
  SyntaxNode({
    @required this.parent,
    @required this.value,
    @required this.pos,
  })  : assert(value != null),
        assert(pos != null);

  /// Lazily evaluated children of current [SyntaxNode]
  List<SyntaxNode> _children;
  List<SyntaxNode> get children {
    if (_children != null) return _children;
    final res =
        List<SyntaxNode>.filled(value.children.length, null, growable: false);
    for (var i = 0; i < value.children.length; i++) {
      res[i] = SyntaxNode(
        parent: this,
        value: value.children[i],
        pos: this.pos + value.childPositions[i],
      );
    }
    return _children = res;
  }

  NodeRange _range;
  NodeRange get range => _range ??= value.getRange(pos);

  int get width => value.width;
  int get capturedCursor => value.capturedCursor;

  bool get isNull => value == null;
  bool get isLeaf => value is LeafNode;

  /// This is where the actual widget building process happens.
  ///
  /// This method tries to reduce widget rebuilds. Rebuild bypass is determined
  /// by the following process:
  /// - If oldOptions == newOptions, bypass
  /// - If [shouldRebuildWidget], force rebuild
  /// - Call [buildWidget] on [children]. If the results are identical to the
  /// results returned by [buildWidget] called last time, then bypass.
  Widget buildWidget(Options options) {
    if (value is PositionDependentMixin) {
      (value as PositionDependentMixin).updatePos(pos);
    }

    if (value._oldOptions != null && options == value._oldOptions) {
      return value._oldWidget;
    }
    final childOptions = value.computeChildOptions(options);

    final newChildWidgets = _buildChildWidgets(childOptions);

    final bypassRebuild = value._oldOptions != null &&
        !value.shouldRebuildWidget(value._oldOptions, options) &&
        listEquals(newChildWidgets, value._oldChildWidgets);

    value._oldOptions = options;
    value._oldChildWidgets = newChildWidgets;
    return bypassRebuild
        ? value._oldWidget
        : (value._oldWidget =
            value.buildWidget(options, newChildWidgets, childOptions));
  }

  List<Widget> _buildChildWidgets(List<Options> childOptions) {
    assert(children.length == childOptions.length);
    if (children.isEmpty) return const [];
    final result = List<Widget>.filled(children.length, null, growable: false);
    for (var i = 0; i < children.length; i++) {
      result[i] = children[i]?.buildWidget(childOptions[i]);
    }
    return result;
  }
}

/// The range of a node used for hit-testing.
///
/// Used only for editing functionalities. Not to be used in parser.
///
/// The [NodeRange] is a closed interval where the cursor whose position falls
/// inside this interval will be captured by the corresponding node. If the node
/// only captures 1 cursor position, then [start] == [end]. If the node does not
/// capture cursor at all (e.g. [OrdNode]), then [start] > [end]
///
/// The position of a cursor is defined as number of "Right" keystrokes needed
/// to move the cursor from the starting position to the current position.
class NodeRange {
  /// Number of "Right" keystrokes needed to move cursor from starting position
  /// of parent node to the leftmost position of this node.
  final int start;

  /// Number of "Right" keystrokes needed to move cursor from starting position
  /// of parent node to the leftmost position of the next sibling node.
  final int end;
  const NodeRange(
    this.start,
    this.end,
  );

  NodeRange copyWith({
    int start,
    int end,
  }) =>
      NodeRange(
        start ?? this.start,
        end ?? this.end,
      );

  NodeRange operator +(int offset) => NodeRange(start + offset, end + offset);

  bool contains(int pos) => pos >= start && pos <= end;
}

/// Node of Roslyn's Green Tree. Base class of any math nodes.
///
/// [Description of Roslyn's Red-Green Tree](https://docs.microsoft.com/en-us/archive/blogs/ericlippert/persistence-facades-and-roslyns-red-green-trees).
///
/// [GreenNode] stores any context-free information of a node and is
/// constructed bottom-up. It needs to indicate or store:
/// - Necessary parameters for this math node.
/// - Layout algorithm for this math node, if renderable.
/// - Strutural information of the tree ([children])
/// - Context-free properties for other purposes. ([width], etc.)
///
/// Due to their context-free property, [GreenNode] can be canonicalized and
/// deduplicated.
abstract class GreenNode {
  /// Children of this node.
  ///
  /// [children] stores structural information of the Red-Green Tree.
  /// Used for green tree updates. The order of children should strictly
  /// adheres to the cursor-visiting order in editing mode, in order to get a
  /// correct cursor range in the editing mode. E.g., for [RootNode], when
  /// moving cursor from left to right, the cursor first enters index, then
  /// base, so it should return [index, base].
  ///
  /// Please ensure [children] works in the same order as [updateChildren],
  /// [computeChildOptions], and [buildWidget].
  List<GreenNode> get children;

  /// Return a copy of this node with new children.
  ///
  /// Subclasses should override this method. This method provides a general
  /// interface to perform structural updates for the green tree (node
  /// replacement, insertion, etc).
  ///
  /// Please ensure [children] works in the same order as [updateChildren],
  /// [computeChildOptions], and [buildWidget].
  GreenNode updateChildren(covariant List<GreenNode> newChildren);

  /// Calculate the options passed to children when given [options] from parent
  ///
  /// Subclasses should override this method. This method provides a general
  /// description of the context & style modification introduced by this node.
  ///
  /// Please ensure [children] works in the same order as [updateChildren],
  /// [computeChildOptions], and [buildWidget].
  List<Options> computeChildOptions(Options options);

  /// Compose Flutter widget with child widgets already built
  ///
  /// Subclasses should override this method. This method provides a general
  /// description of the layout of this math node. The child nodes are built in
  /// prior. This method is only responsible for the placement of those child
  /// widgets accroding to the layout & other interactions.
  ///
  /// Please ensure [children] works in the same order as [updateChildren],
  /// [computeChildOptions], and [buildWidget].
  Widget buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions);

  /// Whether the specific [Options] parameters that this node directly depends
  /// upon have changed.
  ///
  /// Subclasses should override this method. This method is used to determine
  /// whether certain widget rebuilds can be bypassed even when the [Options]
  /// have changed.
  ///
  /// Rebuild bypass is determined by the following process:
  /// - If [oldOptions] == [newOptions], bypass
  /// - If [shouldRebuildWidget], force rebuild
  /// - Call [buildWidget] on [children]. If the results are identical to the
  /// the results returned by [buildWidget] called last time, then bypass.
  bool shouldRebuildWidget(Options oldOptions, Options newOptions);

  /// Minimum number of "right" keystrokes needed to move the cursor pass
  /// through this node (from the rightmost of the previous node, to the
  /// leftmost of the next node)
  ///
  /// Used only for editing functionalities.
  ///
  /// [width] stores intrinsic width in the editing mode.
  ///
  /// Please calculate (and cache) the width based on [children]'s widths.
  /// Note that it should strictly simulate the movement of the curosr.
  int get width;

  /// Number of cursor positions that can be captured within this node.
  ///
  /// By definition, [capturedCursor] = [width] - 1.
  /// By definition, [NodeRange.end] - [NodeRange.start] = capturedCursor - 1.
  int get capturedCursor => width - 1;

  NodeRange getRange(int pos) => NodeRange(pos + 1, pos + capturedCursor);

  /// Position of child nodes.
  ///
  /// Used only for editing functionalities.
  ///
  /// This method stores the layout strucuture for cursor in the editing mode.
  /// You should return positions of children assume this current node is placed
  /// at the starting position.
  List<int> get childPositions;

  AtomType get leftType;
  AtomType get rightType;

  Options _oldOptions;
  Widget _oldWidget;
  List<Widget> _oldChildWidgets;

  Map<String, Object> toJson() => {
        'type': runtimeType.toString(),
        'children': children.map<Object>((child) => child?.toJson()).toList(),
      };

  /// This is where the actual widget building process happens.
  ///
  /// This method tries to reduce widget rebuilds. Rebuild bypass is determined
  /// by the following process:
  /// - If oldOptions == newOptions, bypass
  /// - If [shouldRebuildWidget], force rebuild
  /// - Call [buildWidget] on [children]. If the results are identical to the
  /// results returned by [buildWidget] called last time, then bypass.
  // @mustCallSuper
  // Widget _buildWidget(Options options, int pos) {
  //   if (_oldOptions != null && options == _oldOptions) return _oldWidget;
  //   final childOptions = computeChildOptions(options);

  //   final newChildWidgets = _buildChildWidgets(childOptions, pos);
  //   if (_oldOptions != null &&
  //       !shouldRebuildWidget(_oldOptions, options) &&
  //       listEquals(newChildWidgets, _oldChildWidgets)) {
  //     return _oldWidget;
  //   }
  //   _oldOptions = options;
  //   _oldChildWidgets = newChildWidgets;
  //   return _oldWidget = buildWidget(options, newChildWidgets, childOptions);
  // }

  // List<Widget> _buildChildWidgets(List<Options> childOptions, int pos) {
  //   final childAbsPos = childPositions
  //       .map((childPos) => childPos + pos)
  //       .toList(growable: false);
  //   final children = this.children;
  //   assert(children.length == childOptions.length);
  //   final result = List<Widget>(children.length);
  //   for (var i = 0; i < children.length; i++) {
  //     result[i] = children[i]?._buildWidget(childOptions[i], childAbsPos[i]);
  //   }
  //   return result;
  // }
}

abstract class ParentableNode<T extends GreenNode> extends GreenNode {
  @override
  List<T> get children;

  int _width;
  int get width => _width = computeWidth();

  int computeWidth();

  /// We do not cache children here, because [EqRowNode] directly has a
  /// [children] property.

  ///
  List<int> _childPositions;
  List<int> get childPositions => _childPositions = computeChildPositions();

  List<int> computeChildPositions();

  @override
  ParentableNode<T> updateChildren(covariant List<T> newChildren);
}

mixin PositionDependentMixin<T extends GreenNode> on ParentableNode<T> {
  var range = const NodeRange(0, -1);

  void updatePos(int pos) {
    range = getRange(pos);
  }
}

abstract class SlotableNode<T extends EquationRowNode> extends ParentableNode<T>
    with PositionDependentMixin {
  List<T> _children;
  List<T> get children => _children ??= computeChildren();

  List<T> computeChildren();

  @override
  int computeWidth() =>
      children.fold<int>(
          0, (value, child) => value + child?.capturedCursor ?? -1) +
      1;

  @override
  List<int> computeChildPositions() {
    var curPos = 0;
    final result = <int>[];
    for (final child in children) {
      result.add(curPos);
      curPos += child.capturedCursor;
    }
    return result;
  }

  // @override
  // Widget _buildWidget(Options options, int pos) {
  //   range.value = getRange(pos);
  //   return super._buildWidget(options, pos);
  // }
  // @override
  // Widget buildWidget(
  //     Options options, List<Widget> childWidgets, List<Options> childOptions) {
  //   final actualWidget = buildActualWidget(childWidgets);
  //   return Consumer<FlutterMathScope>(
  //       child: actualWidget,
  //       builder: (context, scope, child) => Container(
  //             color: scope.showCursor.value &&
  //                     scope.controller.selection.isCollapsed &&
  //                     this.range.contains(scope.controller.selection.baseOffset)
  //                 ? Colors.grey
  //                 : null,
  //             child: child,
  //           ));
  // }

  // Widget buildActualWidget(List<Widget> childWidgets);
}

/// [TransparentNode] refers to those node who have zero rendering content
/// iteself, and are expected to be unwrapped for its children during rendering.
///
/// [TransparentNode]s are only allowed to appear directly under
/// [EquationRowNode]s and other [TransparentNode]s. And those nodes have to
/// explicitly unwrap transparent nodes during building stage.
abstract class TransparentNode extends ParentableNode<GreenNode> {
  @override
  int computeWidth() =>
      children.fold<int>(0, (value, child) => value + child.width);

  @override
  List<int> computeChildPositions() {
    var curPos = 0;
    final result = <int>[];
    for (final child in children) {
      result.add(curPos);
      curPos += child.width;
    }
    return result;
  }

  @override
  BuildResultWrapper buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions) {
    // I would be very happy if I can use Iterable.expand(). But expand() does
    // not come with an indexed version.
    final widgets = <Widget>[];
    final options = <Options>[];
    for (var i = 0; i < childWidgets.length; i++) {
      final childWidget = childWidgets[i];
      if (childWidget is BuildResultWrapper) {
        widgets.addAll(childWidget.widgets);
        options.addAll(childWidget.options);
      } else {
        widgets.add(childWidget);
        options.add(childOptions[i]);
      }
    }
    return BuildResultWrapper(
      widgets: widgets,
      options: options,
    );
  }

  List<GreenNode> _flattenedChildList;
  List<GreenNode> get flattenedChildList => _flattenedChildList ??= children
      .expand((child) =>
          child is TransparentNode ? child.flattenedChildList : [child])
      .toList(growable: false);

  AtomType _leftType;
  @override
  AtomType get leftType => _leftType ??= children[0].leftType;

  AtomType _rightType;
  @override
  AtomType get rightType => _rightType ??= children.last.rightType;
}

class EquationRowNode extends ParentableNode<GreenNode>
    with PositionDependentMixin {
  @override
  final List<GreenNode> children;

  Measurement get italic => flattenedChildList.isEmpty
      ? Measurement.zero
      : (flattenedChildList.last is MathAtomNode
          ? (flattenedChildList.last as MathAtomNode).italic
          : Measurement.zero);

  @override
  int computeWidth() =>
      children.fold<int>(0, (value, child) => value + child.width) + 2;

  @override
  List<int> computeChildPositions() {
    var curPos = 1;
    final result = <int>[];
    for (final child in children) {
      result.add(curPos);
      curPos += child.width;
    }
    return result;
  }

  EquationRowNode({@required this.children})
      : assert(children != null),
        assert(children.every((child) => child != null))
  // assert(children.every((child) => child is! EquationRowNode))
  ;

  factory EquationRowNode.empty() => EquationRowNode(children: []);

  List<GreenNode> _flattenedChildList;
  List<GreenNode> get flattenedChildList => _flattenedChildList ??= children
      .expand((child) =>
          child is TransparentNode ? child.flattenedChildList : [child])
      .toList(growable: false);

  @override
  Widget buildWidget(
      Options options, List<Widget> childWidgets, List<Options> childOptions) {
    // I would be very happy if I can use Iterable.expand(). But expand() does
    // not come with an indexed version.
    final actualChildWidgets = <Widget>[];
    final actualChildOptions = <Options>[];
    for (var i = 0; i < childWidgets.length; i++) {
      final childWidget = childWidgets[i];
      if (childWidget is BuildResultWrapper) {
        actualChildWidgets.addAll(childWidget.widgets);
        actualChildOptions.addAll(childWidget.options);
      } else {
        actualChildWidgets.add(childWidget);
        actualChildOptions.add(childOptions[i]);
      }
    }
    assert(flattenedChildList.length == actualChildWidgets.length);
    final spacings =
        List<double>.filled(flattenedChildList.length - 1, 0, growable: false);
    for (var i = 0; i < flattenedChildList.length - 1; i++) {
      spacings[i] = getSpacingSize(
        left: flattenedChildList[i].rightType,
        right: flattenedChildList[i + 1].leftType,
        style: actualChildOptions[i + 1].style,
      ).toLpUnder(
          actualChildOptions[i + 1]); // Behavior in accordance with KaTeX
    }

    // final actualChildWidgets = childWidgets
    //     .expand((childWidget) => childWidget is BuildResultWrapper
    //         ? childWidget.widgets
    //         : [childWidget])
    //     .toList(growable: false);

    return EquationRow(children: actualChildWidgets, spacings: spacings);
  }

  @override
  List<Options> computeChildOptions(Options options) =>
      List.filled(children.length, options, growable: false);

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<GreenNode> updateChildren(List<GreenNode> newChildren) =>
      EquationRowNode(children: newChildren);

  AtomType _leftType;
  @override
  AtomType get leftType => _leftType ??= children[0].leftType;

  AtomType _rightType;
  @override
  AtomType get rightType => _rightType ??= children.last.rightType;
}

extension GreenNodeWrappingExt on GreenNode {
  EquationRowNode wrapWithEquationRow() {
    if (this is EquationRowNode) {
      return this as EquationRowNode;
    }
    return EquationRowNode(children: [this]);
  }

  List<GreenNode> expandEquationRow() {
    if (this is EquationRowNode) {
      return this.children;
    }
    if (this != null) {
      return [this];
    } else {
      return null;
    }
  }

  GreenNode unwrapEquationRow() {
    if (this is EquationRowNode) {
      if (this.children.length == 1) {
        return this.children[0];
      }
      throw ArgumentError(
          'Unwrap equation row failed due to multiple children inside');
    }
    return this;
  }
}

extension GreenNodeListWrappingExt on List<GreenNode> {
  EquationRowNode wrapWithEquationRow() {
    if (this.length == 1 && this[0] is EquationRowNode) {
      return this[0] as EquationRowNode;
    }
    return EquationRowNode(children: this);
  }
}

abstract class LeafNode extends GreenNode {
  @override
  List<GreenNode> get children => const [];

  @override
  LeafNode updateChildren(List<GreenNode> newChildren) {
    assert(newChildren.isEmpty);
    return this;
  }

  @override
  List<Options> computeChildOptions(Options options) => const [];

  @override
  List<int> get childPositions => const [];
}

// abstract class AccentNode extends SlotableNode {
//   bool get isStretchy;
//   bool get isShifty;
// }

// abstract class AccentUnderNode extends SlotableNode {
//   bool get isStretchy;
//   bool get isShifty;
// }

class BuildResultWrapper extends Widget {
  final List<Widget> widgets;

  final List<Options> options;

  const BuildResultWrapper({this.widgets, this.options});

  @override
  Element createElement() => throw UnsupportedError('');
}

enum AtomType {
  ord,
  op,
  bin,
  rel,
  open,
  close,
  punct,
  inner,

  // These types will be determined by their repective GreenNode type
  // over,
  // under,
  // acc,
  // rad,
  // vcent,
}

class TemporaryNode extends LeafNode {
  @override
  Widget buildWidget(Options options, List<Widget> childWidgets,
          List<Options> childOptions) =>
      throw UnsupportedError('Temporary node $runtimeType encountered.');

  @override
  AtomType get leftType =>
      throw UnsupportedError('Temporary node $runtimeType encountered.');

  @override
  AtomType get rightType =>
      throw UnsupportedError('Temporary node $runtimeType encountered.');

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) =>
      throw UnsupportedError('Temporary node $runtimeType encountered.');

  @override
  int get width =>
      throw UnsupportedError('Temporary node $runtimeType encountered.');
}
