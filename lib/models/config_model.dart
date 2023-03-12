class ConfigModel {
  bool? status;
  Data? data;

  ConfigModel({this.status, this.data});

  ConfigModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<String>? provinces;
  List<String>? colors;
  List<String>? brands;
  List<Types>? types;
  List<Departments>? departments;

  Data(
      {this.provinces, this.colors, this.brands, this.types, this.departments});

  Data.fromJson(Map<String, dynamic> json) {
    provinces = json['provinces'].cast<String>();
    colors = json['colors'].cast<String>();
    brands = json['brands'].cast<String>();
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(new Types.fromJson(v));
      });
    }
    if (json['departments'] != null) {
      departments = <Departments>[];
      json['departments'].forEach((v) {
        departments!.add(new Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provinces'] = this.provinces;
    data['colors'] = this.colors;
    data['brands'] = this.brands;
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    if (this.departments != null) {
      data['departments'] = this.departments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Types {
  int? id;
  String? type;
  int? maximumSpeed;
  int? alarmInterval;
  String? createdAt;
  String? updatedAt;
  String? iconColor;
  String? icon;

  Types(
      {this.id,
        this.type,
        this.maximumSpeed,
        this.alarmInterval,
        this.createdAt,
        this.updatedAt,
        this.iconColor,
        this.icon});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    maximumSpeed = json['maximum_speed'];
    alarmInterval = json['alarm_interval'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iconColor = json['icon_color'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['maximum_speed'] = this.maximumSpeed;
    data['alarm_interval'] = this.alarmInterval;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['icon_color'] = this.iconColor;
    data['icon'] = this.icon;
    return data;
  }
}

class Departments {
  int? id;
  String? title;
  int? parentId;
  var lineRegistrationKey;
  var lineGroupId;
  String? createdAt;
  String? updatedAt;

  Departments(
      {this.id,
        this.title,
        this.parentId,
        this.lineRegistrationKey,
        this.lineGroupId,
        this.createdAt,
        this.updatedAt});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    parentId = json['parent_id'];
    lineRegistrationKey = json['line_registration_key'];
    lineGroupId = json['line_group_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['parent_id'] = this.parentId;
    data['line_registration_key'] = this.lineRegistrationKey;
    data['line_group_id'] = this.lineGroupId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
