class VehicleTypeData {
  int? id;
  String? type;
  int? maximumSpeed;
  int? alarmInterval;
  String? createdAt;
  String? updatedAt;
  String? iconColor;
  String? icon;

  VehicleTypeData(
      {this.id,
        this.type,
        this.maximumSpeed,
        this.alarmInterval,
        this.createdAt,
        this.updatedAt,
        this.iconColor,
        this.icon});

  VehicleTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    maximumSpeed = json['maximum_speed'];
    alarmInterval = json['alarm_interval'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iconColor = json['icon_color'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['maximum_speed'] = maximumSpeed;
    data['alarm_interval'] = alarmInterval;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['icon_color'] = iconColor;
    data['icon'] = icon;
    return data;
  }
}