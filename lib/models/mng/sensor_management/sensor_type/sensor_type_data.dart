class SensorTypeData {
  int? id;
  String? type;
  String? model;
  String? description;
  String? createdAt;
  String? updatedAt;
  String? color;

  SensorTypeData(
      {this.id,
        this.type,
        this.model,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.color});

  SensorTypeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    model = json['model'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['model'] = model;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['color'] = color;
    return data;
  }
}