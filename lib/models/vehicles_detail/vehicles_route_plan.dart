import 'package:fleetmanagement/models/vehicles_detail/end_location.dart';

class VehiclesRoutePlan {
  int? id;
  String? routeName;
  String? vehicleName;
  String? vehicleType;
  String? driverName;
  int? estimatedTotalDistance;
  int? estimatedTotalDuration;
  int? actualTotalDistance;
  int? actualTotalDuration;
  EndLocation? endLocation;
  String? endAddress;

  VehiclesRoutePlan(
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

  VehiclesRoutePlan.fromJson(Map<String, dynamic> json) {
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
