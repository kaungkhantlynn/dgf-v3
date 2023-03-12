class GroupDetail {
  bool? success;
  int? status;
  List<GroupDetailData>? data;

  GroupDetail({this.success, this.status, this.data});

  GroupDetail.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <GroupDetailData>[];
      json['data'].forEach((v) {
        data!.add(GroupDetailData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupDetailData {
  String? company;
  String? license;


  GroupDetailData(
      {this.company,
        this.license,
       });

  GroupDetailData.fromJson(Map<String, dynamic> json) {
    company = json['company'];
    license = json['license'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company'] = company;
    data['license'] = license;

    return data;
  }
}
