import 'package:fleetmanagement/models/auth/auth_data.dart';

class AuthModel {
  bool? success;
  int? status;
  String? token;
  String? type;
  AuthData? data;

  AuthModel({this.success, this.status, this.token, this.type, this.data});

  AuthModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    token = json['token'];
    type = json['type'];
    data = json['data'] != null ? AuthData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['token'] = token;
    data['type'] = type;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}
