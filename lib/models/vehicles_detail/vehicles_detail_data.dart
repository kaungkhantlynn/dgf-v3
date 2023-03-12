import 'package:google_maps_flutter/google_maps_flutter.dart';

class VehiclesDetailData {
  int? id;
  String? company;
  String? name;
  String? remark;
  String? vehicleState;
  String? iconClass;
  String? deviceId;
  String? vehicleId;
  String? vehicleStatus;
  String? vehicleType;
  String? driverName;
  String? checkinStatus;
  String? duration;
  String? durationInHms;
  dynamic? durationOrg;
  String? updatedAt;
  dynamic ch;
  String? mapIcon;
  String? statusIcon;
  String? carIconColor;
  dynamic speed;
  dynamic speedLimit;
  dynamic maxSpeed;
  dynamic fuel;
  dynamic temp;
  dynamic lat;
  dynamic lon;
  dynamic direction;
  List<VehicleDetailAlarms>? alarms;
  RoutePlan? routePlan;
  Driver? driver;

  VehiclesDetailData(
      {this.id,
        this.company,
        this.name,
        this.remark,
        this.vehicleState,
        this.iconClass,
        this.deviceId,
        this.vehicleId,
        this.vehicleStatus,
        this.vehicleType,
        this.driverName,
        this.checkinStatus,
        this.duration,
        this.durationInHms,
        this.durationOrg,
        this.updatedAt,
        this.ch,
        this.mapIcon,
        this.statusIcon,
        this.carIconColor,
        this.speed,
        this.speedLimit,
        this.maxSpeed,
        this.fuel,
        this.temp,
        this.lat,
        this.lon,
        this.direction,
        this.alarms,
        this.routePlan,
      this.driver});

  LatLng get coordinate => LatLng(lat!, lon!);

  VehiclesDetailData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    company = json['company'];
    name = json['name'];
    remark = json['remark'];
    deviceId = json['device_id'];
    vehicleState = json['vehicle_state'];
    iconClass = json['icon_class'];
    vehicleId = json['vehicle_id'];
    vehicleStatus = json['vehicle_status'];
    vehicleType = json['vehicle_type'];
    driverName = json['driver_name'];
    checkinStatus = json['checkin_status'];
    duration = json['duration'];
    durationInHms = json['duration_in_hms'];
    durationOrg = json['duration_org'];
    updatedAt = json['updated_at'];
    ch = json['ch'];
    mapIcon = json['map_icon'];
    statusIcon = json['status_icon'];
    carIconColor = json['car_icon_color'];
    speed = json['speed'];
    speedLimit = json['speed_limit'];
    maxSpeed = json['max_speed'];
    fuel = json['fuel'];
    temp = json['temp'];
    lat = json['lat'];
    lon = json['lon'];
    direction = json['direction'];
    // routePlan = json['route_plan'];
    if (json['alarms'] != null) {
      alarms = <VehicleDetailAlarms>[];
      json['alarms'].forEach((v) {
        alarms!.add(VehicleDetailAlarms.fromJson(v));
      });
    }
    routePlan = json['route_plan'] != null
        ? RoutePlan.fromJson(json['route_plan'])
        : null;
    driver =
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company'] = company;
    data['name'] = name;
    data['remark'] = remark;
    data['vehicle_state'] = vehicleState;
    data['icon_class'] = iconClass;
    data['device_id'] = deviceId;
    data['vehicle_id'] = vehicleId;
    data['vehicle_status'] = vehicleStatus;
    data['vehicle_type'] = vehicleType;
    data['driver_name'] = driverName;
    data['checkin_status'] = checkinStatus;
    data['duration'] = duration;
    data['duration_in_hms'] = durationInHms;
    data['duration_org'] = durationOrg;
    data['updated_at'] = updatedAt;
    data['ch'] = ch;
    data['map_icon'] = mapIcon;
    data['status_icon'] = statusIcon;
    data['car_icon_color'] = carIconColor;
    data['speed'] = speed;
    data['speed_limit'] = speedLimit;
    data['max_speed'] = maxSpeed;
    data['fuel'] = fuel;
    data['temp'] = temp;
    data['lat'] = lat;
    data['lon'] = lon;
    data['direction'] = direction;

    if (alarms != null) {
      data['alarms'] = alarms!.map((v) => v.toJson()).toList();
    }
    if (routePlan != null) {
      data['route_plan'] = routePlan!.toJson();
    }
    if (this.driver != null) {
      data['driver'] = this.driver!.toJson();
    }
    return data;
  }
}

class VehicleDetailAlarms {
  int? id;
  String? name;
  String? description;
  String? startTime;
  String? color;

  VehicleDetailAlarms({this.id, this.name, this.description, this.startTime, this.color});

  VehicleDetailAlarms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    startTime = json['start_time'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['start_time'] = startTime;
    data['color'] = color;
    return data;
  }
}

class Driver {
  int? id;
  String? name;
  String? licenseNumber;
  String? licenseType;
  String? status;
  String? createdAt;

  Driver(
      {this.id,
        this.name,
        this.licenseNumber,
        this.licenseType,
        this.status,
        this.createdAt});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licenseNumber = json['license_number'];
    licenseType = json['license_type'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['license_number'] = this.licenseNumber;
    data['license_type'] = this.licenseType;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class RoutePlan {
  int? id;
  String? routeName;
  String? vehicleName;
  String? vehicleType;
  String? driverName;
  dynamic? estimatedTotalDistance;
  dynamic? estimatedTotalDuration;
  dynamic? actualTotalDistance;
  dynamic? actualTotalDuration;
  EndLocation? endLocation;
  String? endAddress;

  RoutePlan(
      {this.id,
        this.routeName,
        this.vehicleName,
        this.vehicleType,
        this.driverName,
        this.estimatedTotalDistance,
        this.estimatedTotalDuration,
        this.actualTotalDistance,
        this.actualTotalDuration,
        this.endLocation,
        this.endAddress});

  RoutePlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeName = json['route_name'];
    vehicleName = json['vehicle_name'];
    vehicleType = json['vehicle_type'];
    driverName = json['driver_name'];
    estimatedTotalDistance = json['estimated_total_distance'];
    estimatedTotalDuration = json['estimated_total_duration'];
    actualTotalDistance = json['actual_total_distance'];
    actualTotalDuration = json['actual_total_duration'];
    endLocation = json['end_location'] != null
        ? EndLocation.fromJson(json['end_location'])
        : null;
    endAddress = json['end_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route_name'] = routeName;
    data['vehicle_name'] = vehicleName;
    data['vehicle_type'] = vehicleType;
    data['driver_name'] = driverName;
    data['estimated_total_distance'] = estimatedTotalDistance;
    data['estimated_total_duration'] = estimatedTotalDuration;
    data['actual_total_distance'] = actualTotalDistance;
    data['actual_total_duration'] = actualTotalDuration;
    if (endLocation != null) {
      data['end_location'] = endLocation!.toJson();
    }
    data['end_address'] = endAddress;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}