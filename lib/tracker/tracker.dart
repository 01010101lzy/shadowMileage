import 'dart:async';

import 'package:gps/gps.dart';

Stream<GpsLatlng> getGpsStream(
    {Duration interval = const Duration(milliseconds: 1000)}) async* {
  while (true) {
    var pos = await Gps.currentGps();
    yield pos;
    await Future.delayed(interval);
  }
}

class TrackPoint {
  GpsLatlng latlng;
  DateTime time;

  TrackPoint(this.latlng, this.time);
}

class PathTracker {
  List<TrackPoint> points = new List();

  Stream<GpsLatlng> _gpsStream;
  StreamSubscription<GpsLatlng> _subscription;

  void startTracking() {
    this._gpsStream = getGpsStream();
    this._subscription = this._gpsStream.listen(
        (point) => {this.points.add(TrackPoint(point, DateTime.now()))});
  }

  void stopTracking() {
    this._subscription.cancel();
  }
}
