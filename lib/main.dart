import 'package:flutter/material.dart';
import 'package:ShadowMileage/styles.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:latlong/latlong.dart';

import 'latlng_transform.dart';

import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShadowMileage',
      theme: ThemeData(
        primarySwatch: SStyles.akaneColorSwatch,
        backgroundColor: Color(0xff231f20),
        splashColor: Color(0xff231f20),
        textTheme: SStyles.mainTextTheme,
      ),
      home: HomePage(title: 'ShadowMileage'),
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
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static var _points = [
    [116.275461, 40.152659],
    [116.275552, 40.152819],
    [116.275648, 40.152872],
    [116.275766, 40.152938],
    [116.275858, 40.152942],
    [116.275858, 40.152942],
    [116.276040, 40.152938],
    [116.276158, 40.152897],
    [116.276255, 40.152827],
    [116.276319, 40.152749],
    [116.276448, 40.151855],
    [116.276394, 40.151716],
    [116.276265, 40.151593],
    [116.276029, 40.151523],
    [116.276029, 40.151523],
    [116.275799, 40.151564],
    [116.275707, 40.151605],
    [116.275568, 40.151749],
    [116.275482, 40.152413],
    [116.275461, 40.152659]
  ];

  List<LatLng> getBasePoints() {
    return _points.map((t) => gcj2wgs(LatLng(t[1], t[0]))).toList();
  }

  LatLng copy(LatLng other) => LatLng(other.latitude, other.longitude);

  void _generatePoints() {
    var base = getBasePoints();
    const driftCoef = 0.00005;
    int rounds = generator.nextInt(10) + 3;
    var points = List<LatLng>();
    for (int i = 0; i < rounds; i++) {
      var len = base.length;
      for (int j = 0; j < len; j++) {
        LatLng v;
        v = copy(base[j]);
        if (generator.nextBool() && j != 0) {
          v.latitude = (v.latitude + base[j - 1].latitude) / 2;
          v.longitude = (v.longitude + base[j - 1].longitude) / 2;
        }
        v.latitude += (generator.nextDouble() - 0.5) * driftCoef;
        v.longitude += (generator.nextDouble() - 0.5) * driftCoef;
        points.add(v);
      }
    }
    double dist = 0;
    for (int i = 0; i < points.length - 1; i++) {
      dist += distance(points[i].latitude, points[i].longitude,
          points[i + 1].latitude, points[i + 1].longitude);
    }
    setState(() {
      this.mileage = dist / 1000;
      this.polylinePoints = points;
    });
  }

  void regeneratePoints() {
    _generatePoints();
    print('Points generated!');
  }

  var generator = Random();
  List<LatLng> polylinePoints = <LatLng>[];
  List<CircleMarker> get markers {
    try {
      if (polylinePoints != null && polylinePoints.length > 1)
        return [
          CircleMarker(
            point: polylinePoints.first ?? LatLng(0, 0),
            radius: 5.0,
            color: Color(0xffff0000),
            borderStrokeWidth: 2.0,
            borderColor: Color(0xffcc8800),
          ),
          CircleMarker(
            point: polylinePoints.last ?? LatLng(0, 0),
            radius: 5.0,
            borderColor: Color(0xffffffff),
            borderStrokeWidth: 2.0,
            color: Color(0xff0000ff),
          ),
        ];
      else
        return [];
    } catch (_) {
      return [];
    }
  }

  double mileage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'DDIN',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: FlutterMap(
              options: MapOptions(
                center: gcj2wgs(LatLng(40.152329, 116.275701)),
                zoom: 18.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{scale}.png",
                  additionalOptions: {
                    // "basemap_id": "base-flatblue",
                    "scale": "@3x"
                  },
                  subdomains: ["a", "b", "c", "d"],
                ),
                PolylineLayerOptions(polylines: [
                  Polyline(
                      points: polylinePoints,
                      strokeWidth: 2.0,
                      color: Color(0xffcc8800)),
                ]),
                CircleLayerOptions(circles: markers),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              margin: EdgeInsets.all(8.0),
              child: InkWell(
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(mileage.toStringAsFixed(1),
                          style: SStyles.mainTextTheme.display4),
                      Text(
                        "km",
                        style: SStyles.mainTextTheme.body2,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.0),
                ),
                onTap: () => regeneratePoints(),
              ),
              color: Color(SStyles.lightInkColor),
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xff231f20),
    );
  }
}
