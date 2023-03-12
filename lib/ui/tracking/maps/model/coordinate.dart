import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coordinate {
  double? lat;
  double? lng;
  String? license;
  String? mapIcon;

  Coordinate({this.lat, this.lng, this.license, this.mapIcon});

  LatLng get coordinate => LatLng(lat!, lng!);

  Coordinate.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    license = json['license'];
    mapIcon = json['map_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    data['license'] = license;
    data['map_icon'] = mapIcon;
    return data;
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Coordinate &&
        o.lat == lat &&
        o.lng == lng &&
        o.license == license;
  }

  @override
  int get hashCode => lat.hashCode ^ lng.hashCode ^ license.hashCode;

  @override
  Coordinate fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return Coordinate.fromJson(json);
  }
}
