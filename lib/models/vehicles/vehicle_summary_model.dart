import 'package:fleetmanagement/models/vehicles/vehicle_group_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_data.dart';

class VehicleSummaryModel {
  bool? success;
  int? status;
  List<VehicleGroupModel>? groups;
  List<VehicleSummaryData>? summary;

  VehicleSummaryModel({this.success, this.status, this.groups, this.summary});

  VehicleSummaryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      groups = <VehicleGroupModel>[];
      json['data'].forEach((v) {
        groups!.add(VehicleGroupModel.fromJson(v));
      });
    }
    if (json['summary'] != null) {
      summary = <VehicleSummaryData>[];
      json['summary'].forEach((v) {
        summary!.add(VehicleSummaryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (groups != null) {
      data['data'] = groups!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['summary'] = summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}