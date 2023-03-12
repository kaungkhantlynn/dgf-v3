class JsessionModel {
  bool? status;
  Data? data;

  JsessionModel({this.status, this.data});

  JsessionModel.fromJson(Map<String, dynamic> json) {
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
  String? jession;

  Data({this.jession});

  Data.fromJson(Map<String, dynamic> json) {
    jession = json['jession'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jession'] = this.jession;
    return data;
  }
}
