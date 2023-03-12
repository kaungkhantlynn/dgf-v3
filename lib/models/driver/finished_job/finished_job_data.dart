class FinishedJobData {
  int? id;
  String? routeName;
  String? vehicleName;
  String? vehicleLicense;
  String? startDatetime;
  String? endDatetime;
  String? startTime;
  String? endTime;
  bool? isFinish;

  FinishedJobData(
      {this.id,
      this.routeName,
      this.vehicleName,
      this.vehicleLicense,
      this.startDatetime,
      this.endDatetime,
      this.startTime,
      this.endTime,
      this.isFinish});

  FinishedJobData.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    routeName = json['route_name'];
    vehicleName = json['vehicle_name'];
    vehicleLicense = json['vehicle_license'];
    startDatetime = json['start_datetime'] ?? '-';
    endDatetime = json['end_datetime'] ?? '-';
    startTime = json['start_time'] ?? '-';
    endTime = json['end_time'] ?? '-';
    isFinish = json['is_finish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['route_name'] = routeName;
    data['vehicle_name'] = vehicleName;
    data['vehicle_license'] = vehicleLicense;
    data['start_datetime'] = startDatetime;
    data['end_datetime'] = endDatetime;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['is_finish'] = isFinish;
    return data;
  }
}
