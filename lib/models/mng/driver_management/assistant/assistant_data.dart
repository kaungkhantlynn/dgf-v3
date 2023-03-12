class AssistantData {
  int? id;
  int? userDepartmentsId;
  String? licenseNumber;
  String? name;
  String? licenseType;
  String? status;
  String? createdAt;
  String? updatedAt;

  AssistantData(
      {this.id,
        this.userDepartmentsId,
        this.licenseNumber,
        this.name,
        this.licenseType,
        this.status,
        this.createdAt,
        this.updatedAt});

  AssistantData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userDepartmentsId = json['user_departments_id'];
    licenseNumber = json['license_number'];
    name = json['name'];
    licenseType = json['license_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_departments_id'] = userDepartmentsId;
    data['license_number'] = licenseNumber;
    data['name'] = name;
    data['license_type'] = licenseType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
