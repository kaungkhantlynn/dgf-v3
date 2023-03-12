
class InsuranceData {
  int? id;
  int? vehicleId;
  String? company;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;

  InsuranceData(
      {this.id,
        this.vehicleId,
        this.company,
        this.startDate,
        this.endDate,
        this.createdAt,
        this.updatedAt,
        this.vehicle});

  InsuranceData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    company = json['company'];
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
    data['company'] = company;
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
  String? province;
  String? chassisNumber;
  String? brand;
  String? color;

  Vehicle(
      {this.id,
        this.name,
        this.license,
        this.province,
        this.chassisNumber,
        this.brand,
        this.color});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    license = json['license'];
    province = json['province'];
    chassisNumber = json['chassis_number'];
    brand = json['brand'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['license'] = license;
    data['province'] = province;
    data['chassis_number'] = chassisNumber;
    data['brand'] = brand;
    data['color'] = color;
    return data;
  }
}