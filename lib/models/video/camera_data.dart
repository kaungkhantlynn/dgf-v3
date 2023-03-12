class CameraData {
  int? key;
  String? value;
  String? status;

  CameraData({this.key, this.value, this.status});

  CameraData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['value'] = value;
    data['status'] = status;
    return data;
  }
}
