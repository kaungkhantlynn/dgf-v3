class FuelData {
  int? id;
  int? vehicleId;
  int? fuelId;
  int? lowLoad;
  int? mediumLoad;
  int? highLoad;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;

  FuelData(
      {this.id,
        this.vehicleId,
        this.fuelId,
        this.lowLoad,
        this.mediumLoad,
        this.highLoad,
        this.createdAt,
        this.updatedAt,
        this.vehicle});

  FuelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    fuelId = json['fuel_id'];
    lowLoad = json['low_load'];
    mediumLoad = json['medium_load'];
    highLoad = json['high_load'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicle =
    json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicle_id'] = vehicleId;
    data['fuel_id'] = fuelId;
    data['low_load'] = lowLoad;
    data['medium_load'] = mediumLoad;
    data['high_load'] = highLoad;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}

class Vehicle {
  int? id;
  String? license;
  String? province;
  String? chassisNumber;

  Vehicle({this.id, this.license, this.province, this.chassisNumber});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    license = json['license'];
    province = json['province'];
    chassisNumber = json['chassis_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['license'] = license;
    data['province'] = province;
    data['chassis_number'] = chassisNumber;
    return data;
  }
}