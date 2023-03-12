class PointData {
  String? pointName;
  String? lat;
  String? lng;

  PointData({this.pointName,this.lat,this.lng});

  PointData.fromJson(Map<String, dynamic> json) {
    pointName = json['station_name'];
    lat = json['lat'];
    lng = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['station_name'] = pointName;
    data['lat'] = lat;
    data['lon'] = lng;
    return data;
  }
}
