import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'display.dart';
import 'supported_data.dart';
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        children: supportedData.entries
            .expand((entry) => [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  ...entry.value.map((expr) => DisplayMath(expression: expr)),
                  Divider(),
                ])
            .toList(),
      );
}
