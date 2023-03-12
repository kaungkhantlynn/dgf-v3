import 'package:fleetmanagement/models/driver/route_plan_detail/route_plan_detail_data.dart';

class RoutePlanDetailModel {
  bool? success;
  int? status;
  RoutePlanDetailData? data;

  RoutePlanDetailModel({this.success, this.status, this.data});

  RoutePlanDetailModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null
        ? RoutePlanDetailData.fromJson(json['data'])
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
