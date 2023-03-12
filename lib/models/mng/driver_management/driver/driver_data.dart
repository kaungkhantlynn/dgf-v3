class DriverData {
  int? id;
  int? userDepartmentsId;
  String? licenseNumber;
  String? name;
  String? licenseType;
  String? status;
  String? apiToken;
  String? createdAt;
  String? updatedAt;
  int? userId;


  DriverData(
      {this.id,
        this.userDepartmentsId,
        this.licenseNumber,
        this.name,
        this.licenseType,
        this.status,
        this.apiToken,
        this.createdAt,
        this.updatedAt,
        this.userId});

  DriverData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userDepartmentsId = json['user_departments_id'];
    licenseNumber = json['license_number'];
    name = json['name'];
    licenseType = json['license_type'];
    status = json['status'];
    apiToken = json['api_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_departments_id'] = userDepartmentsId;
    data['license_number'] = licenseNumber;
    data['name'] = name;
    data['license_type'] = licenseType;
    data['status'] = status;
    data['api_token'] = apiToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    return data;
  }
}