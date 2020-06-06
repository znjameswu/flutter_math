// import 'package:built_collection/built_collection.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';

// import '../../util/lazy.dart';
// import 'style.dart';
// import 'styled_text.dart';
// import 'syntax_tree.dart';






// @freezed
// abstract class VecNode extends AccentNode with _$VecNode {
//   VecNode._();
//   factory VecNode({
//     Mode mode,
//     @Default(Options()) Options style,
//     GreenNode child,
//   }) = _VecNode;

//   @late
//   BuiltList<GreenNode> get children => BuiltList(<GreenNode>[child]);

//   @override
//   GreenNode updateChildren(BuiltList<GreenNode> newChildren) {
//     assert(newChildren.length == 1);
//     return this.copyWith(child: newChildren[0]);
//   }
//   // bool get isStretchy => true;
//   // bool get isShifty => false;
// }



// class OverBraceNode extends AccentNode {}

// class UnderBraceNode extends AccentUnderNode {}

// class LeftMiddleRightNode extends VariableChildCountNode<Node> {
//   List<String> delims;
// }

// @freezed
// abstract class OperatorNode extends DoubleChildrenNode<GreenNode>
//     with _$OperatorNode {
//   OperatorNode._();
//   factory OperatorNode({
//     Mode mode,
//     @Default(Options()) Options style,
//     GreenNode operatorName,
//     GreenNode argument,
//   }) = _OperatorNode;

//   @late
//   BuiltList<GreenNode> get children =>
//       BuiltList(<GreenNode>[operatorName, argument]);

//   @override
//   GreenNode updateChildren(BuiltList<GreenNode> newChildren) {
//     assert(newChildren.length == 2);
//     return this
//         .copyWith(operatorName: newChildren[0], argument: newChildren[1]);
//   }
// }

// class OverlineNode extends AccentNode {}

// class PhantomNode extends SingleChildNode<Node> {
//   bool heightConstraint = true;
//   bool verticalConstraint = false;
// }

// class SqrtNode extends DoubleChildNode<Node> {
//   Node get body => valueListenable1;
//   set body(Node value) {
//     valueListenable1 = value;
//   }

//   Node get index => valueListenable2;
//   set index(Node value) {
//     valueListenable2 = value;
//   }
// }

// class UnderLineNode extends AccentUnderNode {}

// class XArrowNode extends DoubleChildNode<Node> {
//   Node get above => valueListenable1;
//   set above(Node value) {
//     valueListenable1 = value;
//   }

//   Node get below => valueListenable2;
//   set below(Node value) {
//     valueListenable2 = value;
//   }

//   String arrowType;
// }
