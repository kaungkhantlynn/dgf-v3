import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_data.dart';

class SensorTypeDetailData {
  bool? success;
  int? status;
  SensorTypeData? data;

  SensorTypeDetailData({this.success, this.status, this.data});

  SensorTypeDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? SensorTypeData.fromJson(json['data']) : null;
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
