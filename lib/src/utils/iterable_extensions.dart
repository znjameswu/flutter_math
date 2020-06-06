import 'dart:math' as math;


extension NumIterableExtension<T extends num> on Iterable<T> {
  T sum() => this.reduce((a,b) => a+b as T);
  T max() => this.reduce(math.max);
}