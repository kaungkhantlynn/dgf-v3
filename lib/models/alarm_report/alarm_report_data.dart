class AlarmReportData {
  int? id;
  String? backgroundColor;
  String? deviceName;
  dynamic? alarmType;
  dynamic? info;
  String? startTime;
  String? endTime;


  AlarmReportData(
      {this.id,
        this.backgroundColor,
        this.deviceName,
        this.alarmType,
        this.info,
        this.startTime,
        this.endTime});

  AlarmReportData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    backgroundColor = json['background_color'];
    deviceName = json['device_name'];
    alarmType = json['alarm_type'];
    info = json['info'];
    startTime = json['start_time'];
    endTime = json['end_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['background_color'] = backgroundColor;
    data['device_name'] = deviceName;
    data['alarm_type'] = alarmType;
    data['info'] = info;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    return data;
  }
}
