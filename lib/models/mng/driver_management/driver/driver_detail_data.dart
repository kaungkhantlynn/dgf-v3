  class DriverDetailData {
  bool? success;
  int? status;
  Data? data;

  DriverDetailData({this.success, this.status, this.data});

  DriverDetailData.fromJson(Map<String, dynamic> json) {
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
  int? userDepartmentsId;
  String? licenseNumber;
  String? name;
  String? licenseType;
  String? status;
  String? apiToken;
  String? createdAt;
  String? updatedAt;
  int? userId;
  User? user;

  Data(
      {this.id,
        this.userDepartmentsId,
        this.licenseNumber,
        this.name,
        this.licenseType,
        this.status,
        this.apiToken,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? language;
  String? password;
  String? apiToken;
  int? emailVerified;
  int? mobileVerified;
  String? rememberToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? status;
  String? dashboardSetting;
  bool? isDriver;

  User(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.mobile,
        this.language,
        this.password,
        this.apiToken,
        this.emailVerified,
        this.mobileVerified,
        this.rememberToken,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.status,
        this.dashboardSetting,
        this.isDriver});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    language = json['language'];
    password = json['password'];
    apiToken = json['api_token'];
    emailVerified = json['email_verified'];
    mobileVerified = json['mobile_verified'];
    rememberToken = json['remember_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    status = json['status'];
    dashboardSetting = json['dashboard_setting'];
    isDriver = json['is_driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['language'] = language;
    data['password'] = password;
    data['api_token'] = apiToken;
    data['email_verified'] = emailVerified;
    data['mobile_verified'] = mobileVerified;
    data['remember_token'] = rememberToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['status'] = status;
    data['dashboard_setting'] = dashboardSetting;
    data['is_driver'] = isDriver;
    return data;
  }
}