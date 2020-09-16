import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import '../ast/syntax_tree.dart';

class FlutterMathController extends ChangeNotifier {
  FlutterMathController({
    SyntaxTree ast,
    dynamic error,
    TextSelection selection = const TextSelection.collapsed(offset: -1),
  })  : _error = error,
        _ast = ast,
        _selection = selection;

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

  TextSelection get selection => _selection;
  TextSelection _selection;
  set selection(TextSelection value) {
    if (_selection != value) {
      _selection = value;
      notifyListeners();
    }
  }
}
