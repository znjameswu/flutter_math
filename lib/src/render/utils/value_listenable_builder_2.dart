import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ValueListenableBuilder2<A, B> extends StatelessWidget {
  ValueListenableBuilder2({
    this.valueListenable1,
    this.valueListenable2, 
    Key key,
    this.builder,
    this.child,
  }) : super(key: key);

  final ValueListenable<A> valueListenable1;
  final ValueListenable<B> valueListenable2;
  final Widget child;
  final Widget Function(BuildContext context, A a, B b, Widget child) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
        valueListenable: valueListenable1,
        builder: (_, a, __) => ValueListenableBuilder<B>(
          valueListenable: valueListenable2,
          builder: (context, b, __) => builder(context, a, b, child),
        ),
      );
}
