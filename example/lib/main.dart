import 'package:flutter/material.dart';
import 'package:flutter_math/flutter_math.dart';
import 'package:provider/provider.dart';

import 'zoom.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontFamily: 'KaTeX_Math'),
          ),
        ),
        body: ChangeNotifierProvider(
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
                child: ZoomableWidget(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 200,
                        height: 200,
                        color: Colors.red,
                      ),
                      Center(
                        child: Consumer<TextEditingController>(
                            builder: (context, controller, _) {
                          try {
                            final tree = SyntaxTree(
                              greenRoot: TexParser(controller.text, Settings())
                                  .parse(),
                            );
                            return tree.buildWidget(Options.displayOptions);
                          } on ParseError catch (e) {
                            return Text(e.message);
                          } on Object catch (e) {
                            return Text(e.toString());
                          }
                        }),
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            text: 'a',
                            style: TextStyle(
                                fontFamily: 'KaTeX_Math', fontSize: 33.48)),
                        TextSpan(
                            text: 'a',
                            style: TextStyle(
                                fontFamily: 'KaTeX_Math', fontSize: 23.44)),
                      ])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                                text: 'a',
                                style: TextStyle(
                                    fontFamily: 'KaTeX_Math', fontSize: 33.48)),
                          ),
                          Text.rich(
                            TextSpan(
                                text: 'a',
                                style: TextStyle(
                                    fontFamily: 'KaTeX_Math', fontSize: 23.44)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}
