import 'package:fleetmanagement/models/vehicles/vehicles_data.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_summary.dart';

class VehiclesModel {
  bool? success;

  List<VehiclesData>? data;
  List<VehiclesSummary>? summary;

  VehiclesModel({this.success,  this.data, this.summary});

  VehiclesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(VehiclesData.fromJson(v));
      });
    }

    if (json['summary'] != null) {
      summary = <VehiclesSummary>[];
      json['summary'].forEach((v) {
        summary!.add(VehiclesSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (summary != null) {
      data['summary'] = summary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
