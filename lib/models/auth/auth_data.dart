import 'package:fleetmanagement/models/auth/driver_model.dart';

class AuthData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? language;
  String? status;
  bool? emailVerified;
  bool? mobileVerified;

  bool? isDriver;
  Driver? driver;

  AuthData(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.mobile,
      this.language,
      this.status,
      this.emailVerified,
      this.mobileVerified,
      this.isDriver,
      this.driver});

  AuthData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    language = json['language'];
    status = json['status'];
    emailVerified = json['email_verified'];
    mobileVerified = json['mobile_verified'];

    isDriver = json['is_driver'];
    driver =
        json['driver'] != null ? Driver.fromJson(json['driver']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['language'] = language;
    data['status'] = status;
    data['email_verified'] = emailVerified;
    data['mobile_verified'] = mobileVerified;

    data['is_driver'] = isDriver;
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    return data;
  }
}
