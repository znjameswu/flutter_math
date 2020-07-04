import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:provider/provider.dart';

import 'package:flutter_tex/flutter_tex.dart';

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
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Flutter Math's output",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Consumer<TextEditingController>(
                      builder: (context, controller, _) =>
                          FlutterMath.fromTexString(
                        expression: controller.value.text,
                        options: Options(
                          style: MathStyle.display,
                          baseSizeMultiplier: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Flutter TeX's output",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Consumer<TextEditingController>(
                      builder: (context, controller, _) => TeXView(
                        renderingEngine: const TeXViewRenderingEngine.katex(),
                        child: TeXViewDocument(
                          '\$\$${controller.value.text}\$\$',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
}
