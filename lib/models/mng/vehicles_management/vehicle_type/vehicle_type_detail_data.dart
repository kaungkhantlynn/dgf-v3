import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';

class VehicleTypeDetailData {
  bool? success;
  int? status;
  VehicleTypeData? data;

  VehicleTypeDetailData({this.success, this.status, this.data});

  VehicleTypeDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? VehicleTypeData.fromJson(json['data']) : null;
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
