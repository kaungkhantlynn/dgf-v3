import 'package:fleetmanagement/models/mng/tracker_management/device_data.dart';

class DeviceDetailData {
  bool? success;
  int? status;
  DeviceData? data;

  DeviceDetailData({this.success, this.status, this.data});

  DeviceDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? DeviceData.fromJson(json['data']) : null;
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
