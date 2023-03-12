class VehicleGroupData {
  int? id;
  String? name;
  String? remark;
  String? vehicleStatus;
  String? duration;

  VehicleGroupData(
      {this.id, this.name, this.remark, this.vehicleStatus, this.duration});

  VehicleGroupData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    remark = json['remark'];
    vehicleStatus = json['vehicle_status'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['remark'] = remark;
    data['vehicle_status'] = vehicleStatus;
    data['duration'] = duration;
    return data;
  }
}
