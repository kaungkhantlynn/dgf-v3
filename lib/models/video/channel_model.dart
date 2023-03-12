import 'package:fleetmanagement/models/video/channel_data.dart';

class ChannelModel {
  bool? success;
  int? status;
  List<ChannelData>? data;

  ChannelModel({this.success, this.status, this.data});

  ChannelModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <ChannelData>[];
      json['data'].forEach((v) {
        data!.add(ChannelData.fromJson(v));
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
