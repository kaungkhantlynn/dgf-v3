import 'package:fleetmanagement/models/trackinghistory/tracking_history_data.dart';

class TrackingHistoryModel {
  bool? success;
  int? status;
  List<TrackingHistoryData>? data;
  int? alarmCount;

  TrackingHistoryModel({this.success, this.status, this.data, this.alarmCount});

  TrackingHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <TrackingHistoryData>[];
      json['data'].forEach((v) {
        data!.add(TrackingHistoryData.fromJson(v));
      });
    }
    alarmCount = json['alarm_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['alarm_count'] = alarmCount;
    return data;
  }
}
