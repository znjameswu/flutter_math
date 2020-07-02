import 'package:flutter/widgets.dart';
import 'package:flutter_math/flutter_math.dart';

class DisplayMath extends StatelessWidget {
  final String expression;

  const DisplayMath({
    Key key,
    @required this.expression,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(expression, softWrap: true),
        Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Flutter Math:'),
            Expanded(child: FlutterMath.fromTexString(expression))
          ],
        )
      ],
    );
  }
}
