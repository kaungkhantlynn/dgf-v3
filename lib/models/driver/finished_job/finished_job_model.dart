import 'package:fleetmanagement/models/driver/finished_job/finished_job_data.dart';

class FinishedJobModel {
  bool? success;
  int? status;
  List<FinishedJobData>? data;

  FinishedJobModel({this.success, this.status, this.data});

  FinishedJobModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <FinishedJobData>[];
      json['data'].forEach((v) {
        data!.add(FinishedJobData.fromJson(v));
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
