class DeviceStatus {
  bool? success;
  bool? status;
  List<DeviceData>? data;

  DeviceStatus({this.success, this.status, this.data});

  DeviceStatus.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    if (json['data'] != null) {
      data = <DeviceData>[];
      json['data'].forEach((v) {
        data!.add(DeviceData.fromJson(v));
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

class DeviceData {
  String? slug;
  String? title;
  List<Legends>? legends;

  DeviceData({this.slug, this.title, this.legends});

  DeviceData.fromJson(Map<String, dynamic> json) {
    slug = json['slug'];
    title = json['title'];
    if (json['legends'] != null) {
      legends = <Legends>[];
      json['legends'].forEach((v) {
        if (v != null) {
          legends!.add(Legends.fromJson(v));
        }

      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['slug'] = slug;
    data['title'] = title;
    if (legends != null) {
      data['legends'] = legends!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Legends {
  String? name;
  int? y;
  String? color;
  List<int>? data;
  String? type = 'column';

  Legends({this.name, this.y, this.color, this.data,this.type});

  Legends.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? 'column';
    name = json['name'];
    y = json['y'] ?? 0;
    color = json['color'];
    data = json['data'] != null ? json['data'].cast<int>() : [0];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['y'] = y;
    data['color'] = color;
    data['data'] = this.data;
    return data;
  }
}
