class SensorData {
  int? id;
  int? vehicleId;
  String? trackingNumber;
  int? sensorTypeId;
  String? serial;
  String? installationLocation;
  String? status;
  String? createdAt;
  String? updatedAt;
  Vehicle? vehicle;
  SensorType? sensorType;


  SensorData(
      {this.id,
        this.vehicleId,
        this.trackingNumber,
        this.sensorTypeId,
        this.serial,
        this.installationLocation,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.vehicle,
        this.sensorType});

  SensorData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    trackingNumber = json['tracking_number'];
    sensorTypeId = json['sensor_type_id'];
    serial = json['serial'];
    installationLocation = json['installation_location'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vehicle =
    json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    sensorType = json['sensor_type'] != null
        ? SensorType.fromJson(json['sensor_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicle_id'] = vehicleId;
    data['tracking_number'] = trackingNumber;
    data['sensor_type_id'] = sensorTypeId;
    data['serial'] = serial;
    data['installation_location'] = installationLocation;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (sensorType != null) {
      data['sensor_type'] = sensorType!.toJson();
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
  String? color;
  int? vehicleTypeId;
  String? brand;
  String? model;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? userDepartmentsId;

  Vehicle(
      {this.id,
        this.name,
        this.license,
        this.province,
        this.chassisNumber,
        this.color,
        this.vehicleTypeId,
        this.brand,
        this.model,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.userDepartmentsId});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    license = json['license'];
    province = json['province'];
    chassisNumber = json['chassis_number'];
    color = json['color'];
    vehicleTypeId = json['vehicle_type_id'];
    brand = json['brand'];
    model = json['model'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userDepartmentsId = json['user_departments_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['license'] = license;
    data['province'] = province;
    data['chassis_number'] = chassisNumber;
    data['color'] = color;
    data['vehicle_type_id'] = vehicleTypeId;
    data['brand'] = brand;
    data['model'] = model;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_departments_id'] = userDepartmentsId;
    return data;
  }
}

class SensorType {
  int? id;
  String? type;
  String? model;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? color;

  SensorType(
      {this.id,
        this.type,
        this.model,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.color});

  SensorType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    model = json['model'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['model'] = model;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['color'] = color;
    return data;
  }
}