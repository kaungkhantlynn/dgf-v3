class VehiclesPlanWork {
  int? id;
  String? name;
  String? jobTime;
  String? status;
  String? vehicleName;
  String? vehicleType;
  String? driverName;
  String? jobDate;
  String? address;
  String? note;

  VehiclesPlanWork(
      {this.id,
      this.name,
      this.jobTime,
      this.status,
      this.vehicleName,
      this.vehicleType,
      this.driverName,
      this.jobDate,
      this.address,
      this.note});

  VehiclesPlanWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    jobTime = json['job_time'];
    status = json['status'];
    vehicleName = json['vehicle_name'];
    vehicleType = json['vehicle_type'];
    driverName = json['driver_name'];
    jobDate = json['job_date'];
    address = json['address'];
    note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['job_time'] = jobTime;
    data['status'] = status;
    data['vehicle_name'] = vehicleName;
    data['vehicle_type'] = vehicleType;
    data['driver_name'] = driverName;
    data['job_date'] = jobDate;
    data['address'] = address;
    data['note'] = note;
    return data;
  }
}
