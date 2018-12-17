import 'package:latlong/latlong.dart';
import 'dart:math';

const earthR = 6378137.0;

num abs(num x) => x > 0 ? x : -x;

class LatLngNoCheck implements LatLng {
  double latitude, longitude;
  LatLngNoCheck(this.latitude, this.longitude);
  LatLngNoCheck.fromLatLng(LatLng x) {
    latitude = x.latitude;
    longitude = x.longitude;
  }

  @override
  LatLng round({int decimals = 6}) => null;
  @override
  double get latitudeInRad => null;
  @override
  double get longitudeInRad => null;
  @override
  String toSexagesimal() => null;
}

bool outOfChina(lat, lng) {
  if ((lng < 72.004) || (lng > 137.8347)) {
    return true;
  }
  if ((lat < 0.8293) || (lat > 55.8271)) {
    return true;
  }
  return false;
}

LatLngNoCheck transform(num x, num y) {
  var xy = x * y;
  var absX = sqrt(abs(x));
  var xPi = x * PI;
  var yPi = y * PI;
  var d = 20.0 * sin(6.0 * xPi) + 20.0 * sin(2.0 * xPi);

  var lat = d;
  var lng = d;

  lat += 20.0 * sin(yPi) + 40.0 * sin(yPi / 3.0);
  lng += 20.0 * sin(xPi) + 40.0 * sin(xPi / 3.0);

  lat += 160.0 * sin(yPi / 12.0) + 320 * sin(yPi / 30.0);
  lng += 150.0 * sin(xPi / 12.0) + 300.0 * sin(xPi / 30.0);

  lat *= 2.0 / 3.0;
  lng *= 2.0 / 3.0;

  lat += -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * xy + 0.2 * absX;
  lng += 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * xy + 0.1 * absX;

  return LatLngNoCheck(lat, lng);
}

LatLngNoCheck delta(num lat, num lng) {
  var ee = 0.00669342162296594323;
  var d = transform(lat - 35.0, lng - 105.0);
  var radLat = lat / 180.0 * PI;
  var magic = sin(radLat);
  magic = 1 - ee * magic * magic;
  var sqrtMagic = sqrt(magic);
  d.latitude =
      (d.latitude * 180.0) / ((earthR * (1 - ee)) / (magic * sqrtMagic) * PI);
  d.longitude = (d.longitude * 180.0) / (earthR / sqrtMagic * cos(radLat) * PI);
  return d;
}

LatLng wgs2gcj(LatLng pos) {
  var wgsLat = pos.latitude;
  var wgsLng = pos.longitude;
  if (outOfChina(wgsLat, wgsLng)) {
    return pos;
  }
  var d = delta(wgsLat, wgsLng);
  return LatLng(wgsLat + d.latitude, wgsLng + d.longitude);
}

LatLng gcj2wgs(LatLng pos) {
  var gcjLat = pos.latitude;
  var gcjLng = pos.longitude;
  if (outOfChina(gcjLat, gcjLng)) {
    return pos;
  }
  var d = delta(gcjLat, gcjLng);
  return LatLng(gcjLat - d.latitude, gcjLng - d.longitude);
}

LatLng gcj2wgsExact(LatLng pos) {
  // newCoord = oldCoord = gcjCoord
  var gcjLat = pos.latitude, gcjLng = pos.longitude;
  var newLat = gcjLat, newLng = gcjLng;
  var oldLat = newLat, oldLng = newLng;
  var threshold = 1e-6; // ~0.55 m equator & latitude

  for (var i = 0; i < 30; i++) {
    // oldCoord = newCoord
    oldLat = newLat;
    oldLng = newLng;
    // newCoord = gcjCoord - wgs_to_gcj_delta(newCoord)
    var tmp = wgs2gcj(LatLngNoCheck(newLat, newLng));
    // approx difference using gcj-space difference
    newLat -= gcjLat - tmp.latitude;
    newLng -= gcjLng - tmp.longitude;
    // diffchk
    if (max(abs(oldLat - newLat), abs(oldLng - newLng)) < threshold) {
      break;
    }
  }
  return LatLng(newLat, newLng);
}

num distance(latA, lngA, latB, lngB) {
  var pi180 = PI / 180;
  var arcLatA = latA * pi180;
  var arcLatB = latB * pi180;
  var x = cos(arcLatA) * cos(arcLatB) * cos((lngA - lngB) * pi180);
  var y = sin(arcLatA) * sin(arcLatB);
  var s = x + y;
  if (s > 1) {
    s = 1;
  }
  if (s < -1) {
    s = -1;
  }
  var alpha = acos(s);
  var distance = alpha * earthR;
  return distance;
}

/*
function gcj2bd(gcjLat, gcjLng) {
	if (outOfChina(gcjLat, gcjLng)) {
		return {lat: gcjLat, lng: gcjLng};
	}

	var x = gcjLng, y = gcjLat;
	var z = sqrt(x * x + y * y) + 0.00002 * sin(y * PI);
	var theta = atan2(y, x) + 0.000003 * cos(x * PI);
	var bdLng = z * cos(theta) + 0.0065;
	var bdLat = z * sin(theta) + 0.006;
	return {lat: bdLat, lng: bdLng};
}


function bd2gcj(bdLat, bdLng) {
	if (outOfChina(bdLat, bdLng)) {
		return {lat: bdLat, lng: bdLng};
	}

	var x = bdLng - 0.0065, y = bdLat - 0.006;
	var z = sqrt(x * x + y * y) - 0.00002 * sin(y * PI);
	var theta = atan2(y, x) - 0.000003 * cos(x * PI);
	var gcjLng = z * cos(theta);
	var gcjLat = z * sin(theta);
	return {lat: gcjLat, lng: gcjLng};
}


function wgs2bd(wgsLat, wgsLng) {
	var gcj = wgs2gcj(wgsLat, wgsLng);
	return gcj2bd(gcj.latitude, gcj.longitude);
}


function bd2wgs(bdLat, bdLng) {
	var gcj = bd2gcj(bdLat, bdLng);
	return gcj2wgs(gcj.latitude, gcj.longitude);
}
*/
