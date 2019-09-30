import 'package:ShadowMileage/views/styles.dart';
import 'package:flutter/material.dart';

class MileageDisplay extends StatelessWidget {
  MileageDisplay({this.distance, this.duration});

  double distance;
  Duration duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: <Widget>[
          Text(distance.toStringAsFixed(1),
              style: Theme.of(context).textTheme.display4),
          Text(
            "km",
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
      padding: EdgeInsets.all(16.0),
    );
  }
}
