class DriverProfileData {
  int? id;
  String? name;
  String? licenseNumber;
  String? licenseType;
  String? status;
  String? createdAt;

  DriverProfileData(
      {this.id,
      this.name,
      this.licenseNumber,
      this.licenseType,
      this.status,
      this.createdAt});

  DriverProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licenseNumber = json['license_number'];
    licenseType = json['license_type'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['license_number'] = licenseNumber;
    data['license_type'] = licenseType;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
