import 'dart:convert';


class VehicleSummaryData {
  String? key;
  int? count;

  VehicleSummaryData({this.key, this.count});

  VehicleSummaryData.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['count'] = count;
    return data;
  }

  static Map<String, dynamic> toMap(VehicleSummaryData vehicleSummaryData) => {
        'key': vehicleSummaryData.key,
        'count': vehicleSummaryData.key,
      };

  static String encode(List<VehicleSummaryData> vehiclesummarydatas) =>
      json.encode(
        vehiclesummarydatas
            .map<Map<String, dynamic>>((vhcs) => VehicleSummaryData.toMap(vhcs))
            .toList(),
      );

  static List<VehicleSummaryData> decode(String vehiclesummaryString) {
    Iterable parsedJson = jsonDecode(vehiclesummaryString);
    List<VehicleSummaryData> posts = List<VehicleSummaryData>.from(
        parsedJson.map((model) => VehicleSummaryData.fromJson(model)));

    // print('MOREMORE : $posts');
    // print('RUNTYPE'+ parsedJson.runtimeType.toString());

    return posts;
  }
}
