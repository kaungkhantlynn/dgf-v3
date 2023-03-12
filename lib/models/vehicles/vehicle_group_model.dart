import 'package:fleetmanagement/models/vehicles/vehicle_group_data.dart';

class VehicleGroupModel {
  int? id;
  String? name;
  List<VehicleGroupData>? children;

  VehicleGroupModel({this.id, this.name, this.children});

  VehicleGroupModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['children'] != null) {
      children = <VehicleGroupData>[];
      json['children'].forEach((v) {
        children!.add( VehicleGroupData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (children != null) {
      data['children'] = children!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}