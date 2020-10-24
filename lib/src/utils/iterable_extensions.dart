import 'dart:math' as math;

T orNull<T>() => null;

extension NumIterableExtension<T extends num> on Iterable<T> {
  T sum() => this.isEmpty ? 0 as T : this.reduce((a, b) => a + b as T);
  T max() => this.isEmpty ? null : this.reduce(math.max);
  T min() => this.isEmpty ? null : this.reduce(math.min);
}

extension NullableListGetterExt<T> on Iterable<T> {
  T get firstOrNull => this.isEmpty ? null : this.first;
  T get lastOrNull => this.isEmpty ? null : this.last;
  T firstWhereOrNull(bool Function(T element) f) =>
      this.firstWhere(f, orElse: orNull);
}

extension IterableExtension<T> on Iterable<T> {
  Iterable<T2> mapIndexed<T2>(T2 Function(T element, int index) f) sync* {
    var index = 0;
    for (final item in this) {
      yield f(item, index);
      index++;
    }
  }
}

extension ListExtension<T> on List<T> {
  void sortBy<T2 extends Comparable<T2>>(T2 Function(T element) f) {
    this.sort((a, b) => f(a).compareTo(f(b)));
  }

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

// extension MapExtension<K, V> on Map<K, V> {
//   Iterable<T2> mapToIterable<T2>(T2 Function(K key, V value) f) sync* {
//     var index = 0;
//     for (final item in this) {
//       yield f(item, index);
//       index++;
//     }
//   }
// }
