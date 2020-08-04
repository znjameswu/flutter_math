class CustomFixedSizeListIterator<E> implements Iterator<E> {
  final List<E> _array;
  final int step;
  final int length;

  int _position;
  int get position => _position;

  CustomFixedSizeListIterator(
    this._array, {
    int start = 0,
    bool reverse = false,
  })  : step = reverse ? -1 : 1,
        length = _array.length {
    _position = start - step;
  }

  E _current;
  E get current => _current;

  @pragma('vm:prefer-inline')
  @override
  bool moveNext() {
    final nextPosition = _position + step;
    if (nextPosition >= 0 && nextPosition < length) {
      _current = _array[nextPosition];
      _position = nextPosition;
      return true;
    }
    _current = null;
    return false;
  }
}
