import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicle_data.dart';

class VehicleDetailData {
  bool? success;
  int? status;
  VehicleData? data;

  VehicleDetailData({this.success, this.status, this.data});

  VehicleDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? VehicleData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
