
class DeviceData {
  int? id;
  String? name;
  String? serial;
  String? brand;
  String? model;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? vehicleId;
  Vehicle? vehicle;

  DeviceData(
      {this.id,
        this.name,
        this.serial,
        this.brand,
        this.model,
        this.type,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.vehicleId,
        this.vehicle});

  DeviceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    serial = json['serial'];
    brand = json['brand'];
    model = json['model'];
    type = json['type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicleId = json['vehicle_id'];
    vehicle =
    json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['serial'] = serial;
    data['brand'] = brand;
    data['model'] = model;
    data['type'] = type;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['vehicle_id'] = vehicleId;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}


class Vehicle {
  int? id;
  String? license;

  Vehicle({this.id, this.license});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    license = json['license'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['license'] = license;
    return data;
  }
}