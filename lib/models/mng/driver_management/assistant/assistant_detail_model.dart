import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';

class AssistantDetailModel {
  bool? success;
  int? status;
  AssistantData? data;

  AssistantDetailModel({this.success, this.status, this.data});

  AssistantDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? AssistantData.fromJson(json['data']) : null;
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
