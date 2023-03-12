class VehiclesSummary {
  String? key;
  int? count;

  VehiclesSummary({this.key, this.count});

  VehiclesSummary.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['count'] = count;
    return data;
  }
}
