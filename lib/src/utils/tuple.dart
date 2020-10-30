import 'package:flutter/cupertino.dart';

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;
  const Tuple2(
    this.item1,
    this.item2,
  );

  @override
  bool operator ==(Object o) =>
      o is Tuple2<T1, T2> && o.item1 == item1 && o.item2 == item2;

  @override
  int get hashCode => hashValues(item1, item2);
}

class Tuple3<T1, T2, T3> {
  final T1 item1;
  final T2 item2;
  final T3 item3;
  const Tuple3(
    this.item1,
    this.item2,
    this.item3,
  );

  @override
  bool operator ==(Object o) =>
      o is Tuple3<T1, T2, T3> &&
      o.item1 == item1 &&
      o.item2 == item2 &&
      o.item3 == item3;

  @override
  int get hashCode => hashValues(item1, item2, item3);
}
