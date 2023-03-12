import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';

class FuelDetailData {
  bool? success;
  int? status;
  FuelData? data;

  FuelDetailData({this.success, this.status, this.data});

  FuelDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? FuelData.fromJson(json['data']) : null;
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
