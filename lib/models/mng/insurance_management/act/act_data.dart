class ActData {
  int? id;
  int? vehicleId;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;

  ActData(
      {this.id,
        this.vehicleId,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt,
        this.vehicle});

  ActData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicle =
    json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicle_id'] = vehicleId;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
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
  String? name;
  String? license;
  String? brand;

  Vehicle({this.id, this.name, this.license, this.brand});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    license = json['license'];
    brand = json['brand'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['license'] = license;
    data['brand'] = brand;
    return data;
  }
}
