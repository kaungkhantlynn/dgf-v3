import 'package:fleetmanagement/models/driver/route_plan_detail/point_data.dart';

class RoutePlanDetailData {
  int? id;
  String? vehicleName;
  String? vehicleType;
  String? vehicleLicense;
  String? startTime;
  String? endTime;
  bool? isFinish;
  bool? isStarted;
  String? start;
  List<PointData>? points;
  String? end;
  EndLocation? endLocation;
  StartLocation? startLocation;
  String? routeName;
  String? driverName;
  dynamic estimatedTotalDistance;
  dynamic estimatedTotalDuration;
  dynamic actualTotalDistance;
  dynamic actualTotalDuration;
  String? state;
  String? address;

  RoutePlanDetailData(
      {this.id,
      this.vehicleName,
      this.vehicleType,
      this.vehicleLicense,
      this.startTime,
      this.endTime,
      this.isFinish,
      this.isStarted,
      this.start,
      this.points,
      this.end,
      this.endLocation,
      this.startLocation,
      this.routeName,
      this.driverName,
      this.estimatedTotalDistance,
      this.estimatedTotalDuration,
      this.actualTotalDistance,
      this.actualTotalDuration,
      this.state,
      this.address});

  RoutePlanDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleName = json['vehicle_name'];
    vehicleType = json['vehicle_type'];
    vehicleLicense = json['vehicle_license'];
    startTime = json['start_time'] ?? '';
    endTime = json['end_time'] ?? '';
    isFinish = json['is_finish'];
    isStarted = json['is_started'];
    start = json['start'];
    if (json['points'] != null) {
      points = <PointData>[];
      json['points'].forEach((v) {
        points!.add(new PointData.fromJson(v));
      });
    }
    end = json['end'];
    endLocation = json['end_location'] != null
        ? new EndLocation.fromJson(json['end_location'])
        : null;
    startLocation = json['start_location'] != null
        ? new StartLocation.fromJson(json['start_location'])
        : null;
    routeName = json['route_name'];
    driverName = json['driver_name'];
    estimatedTotalDistance = json['estimated_total_distance'] ?? '-';
    estimatedTotalDuration = json['estimated_total_duration'] ?? '-';
    actualTotalDistance = json['actual_total_distance'] ?? '-';
    actualTotalDuration = json['actual_total_duration'] ?? '-';
    state = json['state'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicle_name'] = vehicleName;
    data['vehicle_type'] = vehicleType;
    data['vehicle_license'] = vehicleLicense;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['is_finish'] = isFinish;
    data['is_started'] = isStarted;
    data['start'] = start;
    if (points != null) {
      data['points'] = points!.map((v) => v.toJson()).toList();
    }
    data['end'] = end;
    if (this.endLocation != null) {
      data['end_location'] = this.endLocation!.toJson();
    }
    if (this.startLocation != null) {
      data['start_location'] = this.startLocation!.toJson();
    }
    data['route_name'] = routeName;
    data['driver_name'] = driverName;
    data['estimated_total_distance'] = estimatedTotalDistance;
    data['estimated_total_duration'] = estimatedTotalDuration;
    data['actual_total_distance'] = actualTotalDistance;
    data['actual_total_duration'] = actualTotalDuration;
    data['state'] = state;
    data['address'] = address;
    return data;
  }
}

class EndLocation {
  String? lat;
  String? lon;

  EndLocation({this.lat, this.lon});

  EndLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}

class StartLocation {
  String? lat;
  String? lon;

  StartLocation({this.lat, this.lon});

  StartLocation.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}