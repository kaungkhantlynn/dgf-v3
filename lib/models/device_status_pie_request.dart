import 'device_status.dart';

class DeviceStatusPieRequest {
  PieTitle? title;
  List<PieSeries>? series;

  DeviceStatusPieRequest({this.title, this.series});

  DeviceStatusPieRequest.fromJson(Map<String, dynamic> json) {
    title = json['title'] != null ? PieTitle.fromJson(json['title']) : null;
    if (json['series'] != null) {
      series = <PieSeries>[];
      json['series'].forEach((v) {
        series!.add(PieSeries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (series != null) {
      data['series'] = series!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PieTitle {
  String? text;

  PieTitle({this.text});

  PieTitle.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    return data;
  }
}

class PieSeries {
  String? type;
  String? name;
  List<Legends>? data;
  List<int>? center;
  int? size;
  bool? showInLegend;
  PieDataLabels? dataLabels;

  PieSeries(
      {this.type,
        this.name,
        this.data,
        this.center,
        this.size,
        this.showInLegend,
        this.dataLabels});

  PieSeries.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    if (json['data'] != null) {
      data = <Legends>[];
      json['data'].forEach((v) {
        data!.add(Legends.fromJson(v));
      });
    }
    center = json['center'].cast<int>();
    size = json['size'];
    showInLegend = json['showInLegend'];
    dataLabels = json['dataLabels'] != null
        ? PieDataLabels.fromJson(json['dataLabels'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['name'] = name;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['center'] = center;
    data['size'] = size;
    data['showInLegend'] = showInLegend;
    if (dataLabels != null) {
      data['dataLabels'] = dataLabels!.toJson();
    }
    return data;
  }
}

class PieSeriesData {
  String? name;
  int? y;
  String? color;

  PieSeriesData({this.name, this.y, this.color});

  PieSeriesData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    y = json['y'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['y'] = y;
    data['color'] = color;
    return data;
  }
}

class PieDataLabels {
  bool? enabled;

  PieDataLabels({this.enabled});

  PieDataLabels.fromJson(Map<String, dynamic> json) {
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enabled'] = enabled;
    return data;
  }
}
