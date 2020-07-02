import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:provider/provider.dart';

class DemoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => TextEditingController(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Consumer<TextEditingController>(
              builder: (context, controller, _) => TextField(
                controller: controller,
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Expanded(
              child: Center(
                child: Consumer<TextEditingController>(
                  builder: (context, controller, _) =>
                      FlutterMath.fromTexString(controller.value.text),
                ),
              ),
            )
          ],
        ),
      );
}
