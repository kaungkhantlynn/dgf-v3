import 'package:fleetmanagement/models/video/live_video/live_video_data.dart';

class LiveVideoModel {
  bool? success;
  int? status;
  List<LiveVideoData>? data;

  LiveVideoModel({this.success, this.status, this.data});

  LiveVideoModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <LiveVideoData>[];
      json['data'].forEach((v) {
        data!.add(LiveVideoData.fromJson(v));
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
