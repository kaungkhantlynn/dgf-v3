class GroupModel {
  bool? success;
  int? status;
  List<String>? data;

  GroupModel({this.success, this.status, this.data});

  GroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['data'] = this.data;
    return data;
  }
}
