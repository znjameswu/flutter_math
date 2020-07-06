T nPlus<T extends num>(T a, T b) {
  if (a == null || b == null) return null;
  return a + b as T;
}
