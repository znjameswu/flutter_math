import 'package:flutter/foundation.dart';

class ShowCursorNotifier extends ChangeNotifier implements ValueNotifier<bool> {
  //ignore: avoid_positional_boolean_parameters
  ShowCursorNotifier(this._value);

  @override
  bool get value => _value;
  bool _value;
  set value(bool newValue) {
    if (_value == newValue || newValue == false) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}
