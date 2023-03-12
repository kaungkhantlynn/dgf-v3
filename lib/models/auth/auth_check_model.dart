class AuthCheckModel {
  bool? success;
  int? status;
  bool? authenticated;
  bool? isDriver;

  AuthCheckModel(
      {this.success, this.status, this.authenticated, this.isDriver});

  AuthCheckModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    authenticated = json['authenticated'];
    isDriver = json['is_driver'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['authenticated'] = authenticated;
    data['is_driver'] = isDriver;
    return data;
  }
}
