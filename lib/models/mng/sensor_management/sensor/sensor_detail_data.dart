class SensorDetailData {
  bool? success;
  int? status;
  Data? data;

  SensorDetailData({this.success, this.status, this.data});

  SensorDetailData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  int? vehicleId;
  String? trackingNumber;
  int? sensorTypeId;
  String? serial;
  String? installationLocation;
  String? status;
  String? createdAt;
  String? updatedAt;

  Data(
      {this.id,
        this.vehicleId,
        this.trackingNumber,
        this.sensorTypeId,
        this.serial,
        this.installationLocation,
        this.status,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vehicleId = json['vehicle_id'];
    trackingNumber = json['tracking_number'];
    sensorTypeId = json['sensor_type_id'];
    serial = json['serial'];
    installationLocation = json['installation_location'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}