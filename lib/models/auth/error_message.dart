class ErrorMessage {
  bool? success;
  String? message;
  int? status;

  ErrorMessage({this.success, this.message, this.status});

  ErrorMessage.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
