import 'package:fleetmanagement/models/video/playback/playback_data.dart';

class PlaybackModel {
  bool? success;
  int? status;
  List<PlaybackData>? data;

  PlaybackModel({
    this.success,
    this.status,
    this.data,
  });

  PlaybackModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <PlaybackData>[];
      json['data'].forEach((v) {
        data!.add(PlaybackData.fromJson(v));
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
