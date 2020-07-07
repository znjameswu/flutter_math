import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../ast/syntax_tree.dart';

class FlutterMathController extends ChangeNotifier {
  FlutterMathController({SyntaxTree ast, dynamic error})
      : _error = error,
        _ast = ast;

  SyntaxTree _ast;
  SyntaxTree get ast => _ast;
  set ast(SyntaxTree value) {
    _ast = value;
    notifyListeners();
    // _error = null;
  }

  dynamic get error => _error;
  dynamic _error;
  set error(dynamic value) {
    _error = value;
    _ast = null;
  }
  // TextSelection _selection =
  //  const TextSelection.collapsed(offset: 0, affinity: TextAffinity.upstream);
  // TextSelection get selection => _selection;

}
