import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:flutter_tex/flutter_tex.dart';

class DisplayMath extends StatelessWidget {
  final String expression;

  const DisplayMath({
    Key key,
    @required this.expression,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        elevation: 5,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(expression, softWrap: true),
              ),
              Divider(
                thickness: 1.0,
                height: 1.0,
              ),
              Table(
                border: TableBorder(
                  horizontalInside: BorderSide(
                      width: 1.0, color: Theme.of(context).dividerColor),
                  verticalInside: BorderSide(
                      width: 1.0, color: Theme.of(context).dividerColor),
                ),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      Center(child: Text('Flutter Math')),
                      Center(child: Text('flutter_tex')),
                    ],
                  ),
                  TableRow(
                    children: [
                      Center(
                          child: FlutterMath.fromTexString(
                              expression: expression)),
                      Center(
                        child: TeXView(
                          renderingEngine: const TeXViewRenderingEngine.katex(),
                          child: TeXViewDocument(
                            '\$\$$expression\$\$',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
