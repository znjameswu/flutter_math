extension NumIterableExtension<T extends num> on Iterable<T> {
  T? get minOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) > 0) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A minimal element of the iterable.
  ///
  /// The iterable must not be empty.
  T get min {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) > 0) {
          value = newValue;
        }
      }
      return value;
    }
    throw StateError('No element');
  }

  /// A maximal element of the iterable, or `null` if the iterable is empty.
  T? get maxOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) < 0) {
          value = newValue;
        }
      }
      return value;
    }
    return null;
  }

  /// A maximal element of the iterable.
  ///
  /// The iterable must not be empty.
  T get max {
    var iterator = this.iterator;
    if (iterator.moveNext()) {
      var value = iterator.current;
      while (iterator.moveNext()) {
        var newValue = iterator.current;
        if (value.compareTo(newValue) < 0) {
          value = newValue;
        }
      }
      return value;
    }
    throw StateError('No element');
  }
}

extension ListExtension<T> on List<T> {
  List<T> extendToByFill(int desiredLength, T fill) =>
      this.length >= desiredLength
          ? this
          : List.generate(
              desiredLength,
              (index) => index < this.length ? this[index] : fill,
              growable: false,
            );
}

extension NumListSearchExt<T extends num> on List<T> {
  /// Utility method to help determine node selection.
  ///
  /// If [value] matches one of the element, return the element index.
  /// If [value] is between two elements, return the midpoint.
  /// If [value] is out of the list's bounds, return [-0.5] or
  /// [List.length - 0.5].
  ///
  /// Should only be used on non-empty, monotonically increasing lists.
  double slotFor(T value) {
    // if (value < this[0]) return -1;
    var left = -1;
    var right = this.length;
    for (var i = 0; i < this.length; i++) {
      final element = this[i];
      if (element < value) {
        left = i;
      } else if (element == value) {
        return i.toDouble();
      } else if (element > value) {
        right = i;
        break;
      }
    }
    return (left + right) / 2;
    // return this.length.toDouble();
  }
}

extension SplitExt<T> on Iterable<T> {
  Iterable<List<T>> splitAt(bool Function(T element) test) sync* {
    var iterator = this.iterator;

    var chunk = <T>[];
    while (iterator.moveNext()) {
      var element = iterator.current;
      if (test(element)) {
        yield chunk;
        chunk = [];
      } else {
        chunk.add(element);
      }
    }
    yield chunk;
  }

  Iterable<List<T>> splitAtIndexed(
      bool Function(int index, T element) test) sync* {
    var iterator = this.iterator;

    var index = 0;
    var chunk = <T>[];
    while (iterator.moveNext()) {
      var element = iterator.current;
      if (test(index++, element)) {
        yield chunk;
        chunk = [];
      } else {
        chunk.add(element);
      }
    }
    yield chunk;
  }
}
