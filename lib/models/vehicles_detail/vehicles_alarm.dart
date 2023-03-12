class VehiclesAlarm {
  String? description;
  int? alarmType;
  int? mileage;
  String? mileageUnit;
  int? direction;
  String? alarmTime;
  String? lat;
  String? lng;
  int? speed;
  String? speedUnit;
  String? license;
  int? handleStatus;
  int? typeOfSourceAlarm;
  String? sourceAlarmTime;
  int? typeOfSourceAlarmStarted;

  VehiclesAlarm(
      {this.description,
      this.alarmType,
      this.mileage,
      this.mileageUnit,
      this.direction,
      this.alarmTime,
      this.lat,
      this.lng,
      this.speed,
      this.speedUnit,
      this.license,
      this.handleStatus,
      this.typeOfSourceAlarm,
      this.sourceAlarmTime,
      this.typeOfSourceAlarmStarted});

  VehiclesAlarm.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    alarmType = json['alarm_type'];
    mileage = json['mileage'];
    mileageUnit = json['mileage_unit'];
    direction = json['direction'];
    alarmTime = json['alarm_time'];
    lat = json['lat'];
    lng = json['lng'];
    speed = json['speed'];
    speedUnit = json['speed_unit'];
    license = json['license'];
    handleStatus = json['handle_status'];
    typeOfSourceAlarm = json['type_of_source_alarm'];
    sourceAlarmTime = json['source_alarm_time'];
    typeOfSourceAlarmStarted = json['type_of_source_alarm_started'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['alarm_type'] = alarmType;
    data['mileage'] = mileage;
    data['mileage_unit'] = mileageUnit;
    data['direction'] = direction;
    data['alarm_time'] = alarmTime;
    data['lat'] = lat;
    data['lng'] = lng;
    data['speed'] = speed;
    data['speed_unit'] = speedUnit;
    data['license'] = license;
    data['handle_status'] = handleStatus;
    data['type_of_source_alarm'] = typeOfSourceAlarm;
    data['source_alarm_time'] = sourceAlarmTime;
    data['type_of_source_alarm_started'] = typeOfSourceAlarmStarted;
    return data;
  }
}
