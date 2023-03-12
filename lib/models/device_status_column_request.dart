import 'package:fleetmanagement/models/device_status.dart';

class DeviceStatusColumnRequest {
  ColumnTitle? title;
  ColumnXAxis? xAxis;
  List<Legends>? series;

  DeviceStatusColumnRequest({this.title, this.xAxis, this.series});

  DeviceStatusColumnRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? ColumnTitle.fromJson(json['title']) : null;
    xAxis = json['xAxis'] != null ? ColumnXAxis.fromJson(json['xAxis']) : null;
    if (json['series'] != null) {
      series = <Legends>[];
      json['series'].forEach((v) {
        series!.add(Legends.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (xAxis != null) {
      data['xAxis'] = xAxis!.toJson();
    }
    if (series != null) {
      data['series'] = series!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ColumnTitle {
  String? text;

  ColumnTitle({this.text});

  ColumnTitle.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    return data;
  }
}

class ColumnXAxis {
  List<String>? categories;

  ColumnXAxis({this.categories});

  ColumnXAxis.fromJson(Map<String, dynamic> json) {
    categories = json['categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['categories'] = categories;
    return data;
  }
}

class ColumnSeries {
  String? type = 'column';
  String? name;
  List<int>? data;

  ColumnSeries({this.type, this.name, this.data});

  ColumnSeries.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? 'column';
    name = json['name'];
    data = json['data'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    data['data'] = this.data;
    return data;
  }
}
