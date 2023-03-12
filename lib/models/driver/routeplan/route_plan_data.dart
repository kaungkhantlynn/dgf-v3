class RoutePlanData {
  int? id;
  String? routeName;
  String? vehicleLicense;
  String? startTime;
  String? endTime;
  String? color;

  RoutePlanData(
      {this.id,
      this.routeName,
      this.vehicleLicense,
      this.startTime,
      this.endTime,
      this.color});

  RoutePlanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeName = json['route_name'];
    if (json['vehicle_license']!=null) {
      vehicleLicense = json['vehicle_license'];
    }  else {
      vehicleLicense = '-';
    }

    startTime = json['start_time'] ?? ' - ';
    endTime = json['end_time'] ?? ' - ';
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route_name'] = routeName;
    data['vehicle_license'] = vehicleLicense;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['color'] = color;
    return data;
  }
}
