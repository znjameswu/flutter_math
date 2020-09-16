import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../render/layout/line.dart';
import '../utils/iterable_extensions.dart';
import '../utils/num_extension.dart';
import 'nodes/space.dart';
import 'nodes/sqrt.dart';
import 'nodes/symbol.dart';
import 'options.dart';
import 'spacing.dart';
import 'types.dart';

/// Roslyn's Red-Green Tree
///
/// [Description of Roslyn's Red-Green Tree](https://docs.microsoft.com/en-us/archive/blogs/ericlippert/persistence-facades-and-roslyns-red-green-trees)
class SyntaxTree {
  /// Root of the green tree
  final EquationRowNode greenRoot;

  SyntaxTree({
    @required this.greenRoot,
  }) : assert(greenRoot != null);

  /// Root of the red tree
  SyntaxNode _root;
  SyntaxNode get root => _root ??= SyntaxNode(
        parent: null,
        value: greenRoot,
        pos: -1, // Important
      );

  /// Replace node at [pos] with [newNode]
  SyntaxTree replaceNode(SyntaxNode pos, GreenNode newNode) {
    if (identical(pos.value, newNode)) {
      return this;
    }
    if (identical(pos, root)) {
      return SyntaxTree(greenRoot: newNode.wrapWithEquationRow());
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

  List<GreenNode> findNodesAtPosition(int position) {
    var curr = root;
    final res = <GreenNode>[];
    while (true) {
      res.add(curr.value);
      final next = curr.children.firstWhere((child) =>
          child.range.start <= position && child.range.end >= position);
      if (next == null) break;
      curr = next;
    }
    return res;
  }

  EquationRowNode findNodesManagesPosition(int position) {
    var curr = root;
    while (true) {
      final next = curr.children.firstWhere((child) =>
          child.range.start <= position && child.range.end >= position);
      if (next == null) break;
      curr = next;
    }
    // assert(curr.value is EquationRowNode);
    return curr.value as EquationRowNode;
  }

  // Build widget tree
  Widget buildWidget([Options options = Options.displayOptions]) =>
      root.buildWidget(options).widget;
}

/// Red Node. Immutable facade for math nodes.
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
      res[i] = value.children[i] != null
          ? SyntaxNode(
              parent: this,
              value: value.children[i],
              pos: this.pos + value.childPositions[i],
            )
          : null;
    }
    return _children = res;
  }

  /// [GreenNode.getRange]
  NodeRange _range;
  NodeRange get range => _range ??= value.getRange(pos);

  /// [GreenNode.editingWidth]
  int get width => value.editingWidth;

  /// [GreenNode.capturedCursor]
  int get capturedCursor => value.capturedCursor;

  /// This is where the actual widget building process happens.
  ///
  /// This method tries to reduce widget rebuilds. Rebuild bypass is determined
  /// by the following process:
  /// - If oldOptions == newOptions, bypass
  /// - If [GreenNode.shouldRebuildWidget], force rebuild
  /// - Call [buildWidget] on [children]. If the results are identical to the
  /// results returned by [buildWidget] called last time, then bypass.
  BuildResult buildWidget(Options options) {
    if (value is PositionDependentMixin) {
      (value as PositionDependentMixin).updatePos(pos);
    }

    if (value._oldOptions != null && options == value._oldOptions) {
      return value._oldBuildResult;
    }
    final childOptions = value.computeChildOptions(options);

    final newChildBuildResults = _buildChildWidgets(childOptions);

    final bypassRebuild = value._oldOptions != null &&
        !value.shouldRebuildWidget(value._oldOptions, options) &&
        listEquals(newChildBuildResults, value._oldChildBuildResults);

    value._oldOptions = options;
    value._oldChildBuildResults = newChildBuildResults;
    return bypassRebuild
        ? value._oldBuildResult
        : (value._oldBuildResult =
            value.buildWidget(options, newChildBuildResults));
  }

  List<BuildResult> _buildChildWidgets(List<Options> childOptions) {
    assert(children.length == childOptions.length);
    if (children.isEmpty) return const [];
    final result =
        List<BuildResult>.filled(children.length, null, growable: false);
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
/// capture cursor at all (e.g. [SymbolNode]), then [start] > [end]
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
/// - Context-free properties for other purposes. ([editingWidth], etc.)
///
/// Due to their context-free property, [GreenNode] can be canonicalized and
/// deduplicated.
abstract class GreenNode {
  /// Children of this node.
  ///
  /// [children] stores structural information of the Red-Green Tree.
  /// Used for green tree updates. The order of children should strictly
  /// adheres to the cursor-visiting order in editing mode, in order to get a
  /// correct cursor range in the editing mode. E.g., for [SqrtNode], when
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
  BuildResult buildWidget(Options options, List<BuildResult> childBuildResults);

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
  /// [editingWidth] stores intrinsic width in the editing mode.
  ///
  /// Please calculate (and cache) the width based on [children]'s widths.
  /// Note that it should strictly simulate the movement of the curosr.
  int get editingWidth;

  /// Number of cursor positions that can be captured within this node.
  ///
  /// By definition, [capturedCursor] = [editingWidth] - 1.
  /// By definition, [NodeRange.end] - [NodeRange.start] = capturedCursor - 1.
  int get capturedCursor => editingWidth - 1;

  /// [NodeRange]
  NodeRange getRange(int pos) => NodeRange(pos + 1, pos + capturedCursor);

  /// Position of child nodes.
  ///
  /// Used only for editing functionalities.
  ///
  /// This method stores the layout strucuture for cursor in the editing mode.
  /// You should return positions of children assume this current node is placed
  /// at the starting position.
  List<int> get childPositions;

  /// [AtomType] observed from the left side.
  AtomType get leftType;

  /// [AtomType] observed from the right side.
  AtomType get rightType;

  Options _oldOptions;
  BuildResult _oldBuildResult;
  List<BuildResult> _oldChildBuildResults;

  Map<String, Object> toJson() => {
        'type': runtimeType.toString(),
      };
}

/// [GreenNode] that can have children
abstract class ParentableNode<T extends GreenNode> extends GreenNode {
  @override
  List<T> get children;

  int _width;
  @override
  int get editingWidth => _width ??= computeWidth();

  /// Compute width from children. Abstract.
  int computeWidth();

  List<int> _childPositions;
  @override
  List<int> get childPositions => _childPositions ??= computeChildPositions();

  /// Compute children positions. Abstract.
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

/// [SlotableNode] is those composite node that has editable [EquationRowNode]
/// as children and lay them out into certain slots.
///
/// [SlotableNode] is the most commonly-used node. They share cursor logic and
/// editing logic.
///
/// Depending on node type, some [SlotableNode] can have nulls inside their
/// children list. When null is allowed, it usually means that node will have
/// different layout slot logic depending on non-null children number.
abstract class SlotableNode<T extends EquationRowNode>
    extends ParentableNode<T> {
  List<T> _children;
  @override
  List<T> get children => _children ??= computeChildren();

  /// Compute children. Abstract.
  ///
  /// Used to cache children list
  List<T> computeChildren();

  @override
  int computeWidth() =>
      children.map((child) => child?.capturedCursor ?? -1).sum() + 1;

  @override
  List<int> computeChildPositions() {
    var curPos = 0;
    final result = <int>[];
    for (final child in children) {
      result.add(curPos);
      curPos += child?.capturedCursor ?? -1;
    }
    return result;
  }
}

/// [TransparentNode] refers to those node who have zero rendering content
/// iteself, and are expected to be unwrapped for its children during rendering.
///
/// [TransparentNode]s are only allowed to appear directly under
/// [EquationRowNode]s and other [TransparentNode]s. And those nodes have to
/// explicitly unwrap transparent nodes during building stage.
abstract class TransparentNode extends ParentableNode<GreenNode> {
  @override
  int computeWidth() => children.map((child) => child.editingWidth).sum();

  @override
  List<int> computeChildPositions() {
    var curPos = 0;
    final result = <int>[];
    for (final child in children) {
      result.add(curPos);
      curPos += child.editingWidth;
    }
    return result;
  }

  @override
  BuildResult buildWidget(
          Options options, List<BuildResult> childBuildResults) =>
      BuildResult(
        widget: const Text('This widget should not appear. '
            'It means one of FlutterMath\'s AST nodes '
            'forgot to handle the case for TransparentNodes'),
        options: options,
        results: childBuildResults
            .expand((result) => result.results ?? [result])
            .toList(growable: false),
      );

  List<GreenNode> _flattenedChildList;

  /// Children list when fully expand any underlying [TransparentNode]
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

/// A row of unrelated [GreenNode]s.
///
/// [EquationRowNode] provides cursor-reachability and editability. It
/// represents a collection of nodes that you can freely edit and navigate.
class EquationRowNode extends ParentableNode<GreenNode>
    with PositionDependentMixin {
  /// If non-null, the leftmost and rightmost [AtomType] will be overriden.
  final AtomType overrideType;

  @override
  final List<GreenNode> children;

  GlobalKey _key;
  GlobalKey get key => _key;

  @override
  int computeWidth() => children.map((child) => child.editingWidth).sum() + 2;

  @override
  List<int> computeChildPositions() {
    var curPos = 1;
    return List.generate(children.length, (index) {
      final pos = curPos;
      curPos += children[index].editingWidth;
      return pos;
    }, growable: false);
  }

  EquationRowNode({@required this.children, this.overrideType})
      : assert(children != null),
        assert(children.every((child) => child != null));

  factory EquationRowNode.empty() => EquationRowNode(children: []);

  /// Children list when fully expand any underlying [TransparentNode]
  List<GreenNode> get flattenedChildList => _flattenedChildList ??= children
      .expand((child) =>
          child is TransparentNode ? child.flattenedChildList : [child])
      .toList(growable: false);
  List<GreenNode> _flattenedChildList;

  List<int> _caretPositions;
  List<int> get caretPositions => _caretPositions ??= computeCaretPositions();
  List<int> computeCaretPositions() {
    var curPos = 1;
    return List.generate(flattenedChildList.length, (index) {
      final pos = curPos;
      curPos += flattenedChildList[index].editingWidth;
      return pos;
    })
      ..add(curPos);
  }

  @override
  BuildResult buildWidget(
      Options options, List<BuildResult> childBuildResults) {
    final flattenedBuildResults = childBuildResults
        .expand((result) => result.results ?? [result])
        .toList(growable: false);
    final flattenedChildOptions =
        flattenedBuildResults.map((e) => e.options).toList(growable: false);
    // assert(flattenedChildList.length == actualChildWidgets.length);

    // We need to calculate spacings between nodes
    // There are several caveats to consider
    // - bin can only be bin, if it satisfies some conditions. Otherwise it will
    //   be seen as an ord
    // - There could aligners and spacers. We need to calculate the spacing
    //   after filtering them out, hence the [traverseNonSpaceNodes]
    final childSpacingConfs = flattenedChildList
        .mapIndexed((e, index) => _NodeSpacingConf(
            e.leftType, e.rightType, flattenedChildOptions[index], 0.0))
        .toList(growable: false);
    _traverseNonSpaceNodes(childSpacingConfs, (prev, curr) {
      if (prev?.rightType == AtomType.bin &&
          const {
            AtomType.rel,
            AtomType.close,
            AtomType.punct,
            null,
          }.contains(curr?.leftType)) {
        prev.rightType = AtomType.ord;
        if (prev.leftType == AtomType.bin) {
          prev.leftType = AtomType.ord;
        }
      } else if (curr?.leftType == AtomType.bin &&
          const {
            AtomType.bin,
            AtomType.open,
            AtomType.rel,
            AtomType.op,
            AtomType.punct,
            null
          }.contains(prev?.rightType)) {
        curr.leftType = AtomType.ord;
        if (curr.rightType == AtomType.bin) {
          curr.rightType = AtomType.ord;
        }
      }
    });

    _traverseNonSpaceNodes(childSpacingConfs, (prev, curr) {
      if (prev != null && curr != null) {
        prev.spacingAfter = getSpacingSize(
          prev.rightType,
          curr.leftType,
          curr.options.style,
        ).toLpUnder(curr.options);
      }
    });

    _key = GlobalKey();

    final lineChildren = List.generate(
      flattenedBuildResults.length,
      (index) => LineElement(
        child: flattenedBuildResults[index].widget,
        canBreakBefore: false, // TODO
        alignerOrSpacer: flattenedChildList[index] is SpaceNode &&
            (flattenedChildList[index] as SpaceNode).alignerOrSpacer,
        trailingMargin: childSpacingConfs[index].spacingAfter,
      ),
      growable: false,
    );

    // Each EquationRow will filter out unrelated selection changes (changes
    // happen entirely outside the range of this EquationRow)
    final widget = ProxyProvider<TextSelection, TextSelection>(
      create: (_) => const TextSelection.collapsed(offset: -1),
      update: (context, selection, _) => selection.copyWith(
        baseOffset: selection.baseOffset.clampInt(range.start, range.end),
        extentOffset: selection.extentOffset.clampInt(range.start, range.end),
      ),
      // Selector translates global cursor position to local LineElement index
      // Will only update Line when selection range actually changes
      child: Selector<TextSelection, TextSelection>(
        selector: (context, selection) {
          final start = selection.start - range.start + 1;
          final end = selection.end - range.start + 1;
          return TextSelection(
            baseOffset: start < 1
                ? -1
                : start > capturedCursor
                    ? caretPositions.length
                    : caretPositions.indexWhere((pos) => pos >= start),
            extentOffset: end > capturedCursor
                ? caretPositions.length
                : end < 1
                    ? -1
                    : caretPositions.lastIndexWhere((pos) => pos <= end),
          );
        },
        builder: (context, selection, _) => Line(
          key: _key,
          children: lineChildren,
          node: this,
          selection: selection,
        ),
      ),
    );

    return BuildResult(
      options: options,
      italic: flattenedBuildResults.lastOrNull?.italic ?? 0.0,
      skew: flattenedBuildResults.length == 1
          ? flattenedBuildResults.first.italic
          : 0.0,
      widget: widget,
    );
  }

  @override
  List<Options> computeChildOptions(Options options) =>
      List.filled(children.length, options, growable: false);

  @override
  bool shouldRebuildWidget(Options oldOptions, Options newOptions) => false;

  @override
  ParentableNode<GreenNode> updateChildren(List<GreenNode> newChildren) =>
      copyWith(children: newChildren);

  @override
  AtomType get leftType => overrideType ?? AtomType.ord;

  @override
  AtomType get rightType => overrideType ?? AtomType.ord;

  Map<String, Object> toJson() => super.toJson()
    ..addAll({
      'children': children.map<Object>((child) => child?.toJson()).toList(),
      if (overrideType != null) 'overrideType': overrideType,
    });

  /// Utility method.
  EquationRowNode copyWith({
    AtomType overrideType,
    List<GreenNode> children,
  }) =>
      EquationRowNode(
        overrideType: overrideType ?? this.overrideType,
        children: children ?? this.children,
      );
}

extension GreenNodeWrappingExt on GreenNode {
  /// Wrap a node in [EquationRowNode]
  ///
  /// If this node is already [EquationRowNode], then it won't be wrapped
  EquationRowNode wrapWithEquationRow() {
    if (this is EquationRowNode) {
      return this as EquationRowNode;
    }
    return EquationRowNode(children: [this]);
  }

  /// If this node is [EquationRowNode], its children will be returned. If not,
  /// itself will be returned in a list.
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

  /// Return the only child of [EquationRowNode]
  ///
  /// If the [EquationRowNode] has more than one child, an error will be thrown.
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
  /// Wrap list of [GreenNode] in an [EquationRowNode]
  ///
  /// If the list only contain one [EquationRowNode], then this note will be
  /// returned.
  EquationRowNode wrapWithEquationRow() {
    if (this.length == 1 && this[0] is EquationRowNode) {
      return this[0] as EquationRowNode;
    }
    return EquationRowNode(children: this);
  }
}

/// [GreenNode] that doesn't have any children
abstract class LeafNode extends GreenNode {
  /// [Mode] that this node acquires during parse.
  Mode get mode;

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

  @override
  int get editingWidth => 1;
}

/// Type of atoms. See TeXBook Chap.17
///
/// These following types will be determined by their repective [GreenNode] type
/// - over
/// - under
/// - acc
/// - rad
/// - vcent
enum AtomType {
  ord,
  op,
  bin,
  rel,
  open,
  close,
  punct,
  inner,

  spacing, // symbols

}

/// Only for improvisional use during parsing. Do not use.
class TemporaryNode extends LeafNode {
  @override
  Mode get mode => Mode.math;

  @override
  BuildResult buildWidget(
          Options options, List<BuildResult> childBuildResults) =>
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
  int get editingWidth =>
      throw UnsupportedError('Temporary node $runtimeType encountered.');
}

class BuildResult {
  final Widget widget;
  final Options options;
  final double italic;
  final double skew;
  final List<BuildResult> results;
  const BuildResult({
    @required this.widget,
    @required this.options,
    this.italic = 0.0,
    this.skew = 0.0,
    this.results,
  });
}

void _traverseNonSpaceNodes(
  List<_NodeSpacingConf> childTypeList,
  void Function(
    _NodeSpacingConf prev,
    _NodeSpacingConf curr,
  )
      callback,
) {
  _NodeSpacingConf prev;
  // Tuple2<AtomType, AtomType> curr;
  for (final child in childTypeList) {
    if (child.leftType == AtomType.spacing ||
        child.rightType == AtomType.spacing) {
      continue;
    }
    callback(prev, child);
    prev = child;
  }
  if (prev != null) {
    callback(prev, null);
  }
}

class _NodeSpacingConf {
  AtomType leftType;
  AtomType rightType;
  Options options;
  double spacingAfter;
  _NodeSpacingConf(
    this.leftType,
    this.rightType,
    this.options,
    this.spacingAfter,
  );
}
