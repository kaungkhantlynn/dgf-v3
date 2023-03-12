class SuccessModel {
  bool? success;
  int? status;

  SuccessModel({this.success, this.status});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    return data;
  }
}
