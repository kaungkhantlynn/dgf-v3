class FuelTypeData {
  int? id;
  int? userDepartmentsId;
  String? type;
  String? createdAt;
  String? updatedAt;

  FuelTypeData(
      {this.id,
        this.userDepartmentsId,
        this.type,
        this.createdAt,
        this.updatedAt});

  FuelTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userDepartmentsId = json['user_departments_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_departments_id'] = userDepartmentsId;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}