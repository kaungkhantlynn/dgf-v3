import 'package:fleetmanagement/models/driver/routeplan/route_plan_data.dart';

class RoutePlan {
  bool? success;
  int? status;
  List<RoutePlanData>? data;

  RoutePlan({this.success, this.status, this.data});

  RoutePlan.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <RoutePlanData>[];
      json['data'].forEach((v) {
        data!.add(RoutePlanData.fromJson(v));
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
