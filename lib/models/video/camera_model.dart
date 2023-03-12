import 'package:fleetmanagement/models/video/camera_data.dart';

class CameraModel {
  bool? success;
  int? status;
  List<CameraData>? data;

  CameraModel({this.success, this.status, this.data});

  CameraModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <CameraData>[];
      json['data'].forEach((v) {
        data!.add(CameraData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
