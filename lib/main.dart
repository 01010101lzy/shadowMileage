import 'package:flutter/material.dart';
import 'package:ShadowMileage/styles.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ShadowMileage',
      theme: new ThemeData(
        primarySwatch: SStyles.akaneColorSwatch,
        backgroundColor: Color(0xff231f20),
        splashColor: Color(0xff231f20),
        textTheme: SStyles.mainTextTheme,
      ),
      home: new HomePage(title: 'ShadowMileage'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
          style: new TextStyle(
            fontFamily: 'DDIN',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: new Stack(
        children: <Widget>[
          new Container(
              child: new Center(child: new Text("Placeholder for map."))),
          new Align(
            alignment: Alignment.bottomCenter,
            child: new Card(
              margin: new EdgeInsets.all(8.0),
              child: new Container(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text("1.1", style: SStyles.mainTextTheme.display4),
                    new Text(
                      "km",
                      style: SStyles.mainTextTheme.body2,
                    ),
                  ],
                ),
                padding: new EdgeInsets.all(16.0),
              ),
              color: new Color(SStyles.lightInkColor),
            ),
          )
        ],
      ),
      backgroundColor: Color(0xff231f20),
    );
  }
}
