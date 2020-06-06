import 'package:flutter/widgets.dart';
import '../options.dart';
import '../syntax_tree.dart';

class TextNode extends EquationRowNode {
  // final List<GreenNode> children;
  final FontOptions fontOptions;

  TextNode({
    List<GreenNode> children,
    this.fontOptions,
  }) : super(children: children);
}

//ignore: non_constant_identifier_names
TextNode VerbNode({String text}) {}
