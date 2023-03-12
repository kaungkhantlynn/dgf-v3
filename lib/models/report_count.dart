class ReportCount {
  bool? success;
  int? status;
  int? count;

  ReportCount({this.success, this.status, this.count});

  ReportCount.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['count'] = count;
    return data;
  }
}
