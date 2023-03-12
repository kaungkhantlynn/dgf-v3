
class VehicleData {
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
  Department? department;

  VehicleData(
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
        this.userDepartmentsId,
        this.department});

  VehicleData.fromJson(Map<String, dynamic> json) {
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
    department = json['department'] != null
        ? Department.fromJson(json['department'])
        : null;
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
    if (department != null) {
      data['department'] = department!.toJson();
    }
    return data;
  }
}

class Department {
  int? id;
  String? title;

  Department({this.id, this.title});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}