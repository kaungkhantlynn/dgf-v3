import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_type_data.dart';

class FuelTypeDetailData {
  bool? success;
  int? status;
  FuelTypeData? data;

  FuelTypeDetailData({this.success, this.status, this.data});

  FuelTypeDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? FuelTypeData.fromJson(json['data']) : null;
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