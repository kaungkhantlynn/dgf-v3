import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_data.dart';

class VehiclesDetailModel {

  VehiclesDetailData? vehiclesDetailData;

  VehiclesDetailModel({ this.vehiclesDetailData});

  VehiclesDetailModel.fromJson(Map<String, dynamic> json) {
    print('SSEEDDGG');
    print(json);

    vehiclesDetailData =
        json['data'] != null ? VehiclesDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (vehiclesDetailData != null) {
      data['data'] = vehiclesDetailData!.toJson();
    }
    return data;
  }
}
