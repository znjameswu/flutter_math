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

  List<T> extendToByFill(int desiredLength, T fill) => [
        ...this,
        for (var i = 0; i < desiredLength - this.length; i++) fill,
      ];
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
