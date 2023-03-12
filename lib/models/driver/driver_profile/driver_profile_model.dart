import 'package:fleetmanagement/models/driver/driver_profile/driver_profile_data.dart';

class DriverProfileModel {
  bool? success;
  int? status;
  DriverProfileData? data;

  DriverProfileModel({this.success, this.status, this.data});

  DriverProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null
        ? DriverProfileData.fromJson(json['data'])
        : null;
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
