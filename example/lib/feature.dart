import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'display.dart';
import 'supported_data.dart';

const largeSections = {
  'Delimiter Sizing',
  'Environment',
};

class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entries = supportedData.entries.toList();
    return ListView.builder(
      itemCount: supportedData.length,
      itemBuilder: (context, i) => Column(children: [
        Text(
          entries[i].key,
          style: Theme.of(context).textTheme.headline3,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: entries[i].value.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent:
                largeSections.contains(entries[i].key) ? 500 : 250,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2,
          ),
          itemBuilder: (BuildContext context, int j) =>
              DisplayMath(expression: entries[i].value[j]),
        ),
        // Divider(),
      ]),
    );
  }
}
