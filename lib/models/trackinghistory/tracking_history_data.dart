import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackingHistoryData {
  String? icon;
  int? speed;
  String? latitude;
  String? longitude;
  int? direction;
  int? fuel;
  String? fuelUnit;

  TrackingHistoryData(
      {this.icon,
      this.speed,
      this.latitude,
      this.longitude,
      this.direction,
      this.fuel,
      this.fuelUnit});

  LatLng get coordinate =>
      LatLng(double.parse(latitude!), double.parse(longitude!));

  TrackingHistoryData.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    speed = json['speed'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    direction = json['direction'];
    fuel = json['fuel'];
    fuelUnit = json['fuel_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['speed'] = speed;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['direction'] = direction;
    data['fuel'] = fuel;
    data['fuel_unit'] = fuelUnit;
    return data;
  }
}
