
import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/data/network/dio_client.dart';
import 'package:fleetmanagement/data/network/rest_client.dart';
import 'package:fleetmanagement/models/jsession_model.dart';
import 'package:fleetmanagement/models/other/keyword_search_model.dart';
import 'package:fleetmanagement/models/tracking/tracking_model.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_model.dart';
import 'package:fleetmanagement/models/vehicle_group/group_detail.dart';
import 'package:fleetmanagement/models/vehicle_group/group_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_model.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';

import '../../../../models/tracking/longdo_location.dart';

class TrackingApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  TrackingApi(this._dioClient, this._restClient);

  Future<VehiclesModel> getVehicles({List<String>? status,List<String>? groupKey,String? licenseKey}) async {

    final res = await _dioClient
        .get(Endpoints.vehicles, queryParameters: {'status[]': status,'group[]':groupKey,'license':licenseKey});

    print("TRACKING_VEHICLE");
    return VehiclesModel.fromJson(res);
  }

  List<LongdoLocation> parseLongdoLocations(var responseBody) {
    // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return responseBody.map<LongdoLocation>((json) =>LongdoLocation.fromJson(json)).toList();
  }
  Future<List<LongdoLocation>?> fetchLongdoLocation(String lat, String lng) async {
    final response =  await _dioClient
        .get('http://api.longdo.com/map/services/addresses',
        queryParameters: {'locale': 'en','lon[]':lng,'lat[]':lat,'key':'078388adf4e2609e085f0b8225c6d325'});

   return parseLongdoLocations(response);


  }

  // Future<List<LongdoLocation>> getLongdoLocation(String lat, String lng) async {
  //   final res = await _dioClient
  //       .get('http://api.longdo.com/map/services/addresses',
  //       queryParameters: {'locale': 'en','lon[]':lng,'lat[]':lat,'key':'078388adf4e2609e085f0b8225c6d325'});
  //
  //   print("LONGDO_LOCATION_CALL");
  //   return LongdoLocation.fromJson(res);
  // }

  Future<VehiclesDetailModel> getVehiclesDetail(
      String license, String status) async {
    final res = await _dioClient.get('${Endpoints.vehicles}/$license',
        queryParameters: {'status': 1});
    return VehiclesDetailModel.fromJson(res);
  }

  Future<JsessionModel> generateJsession() async {
    final res = await _dioClient.get('${Endpoints.jsession}');
    return JsessionModel.fromJson(res);
  }

  Future<TrackingModel> getLiveTracking(String license, int page) async {
    final res = await _dioClient.get('${Endpoints.tracking}/$license',
        queryParameters: {'current_page': page});
    return TrackingModel.fromJson(res);
  }

  Future<TrackingHistoryModel> getTrackingHistory(
      String license, String date) async {
    final res = await _dioClient.get('${Endpoints.trackingHistory}/$license',
        queryParameters: {'date': date});
    return TrackingHistoryModel.fromJson(res);
  }

  Future<VehicleSummaryModel> getVehicleFilter() async {
    final res = await _dioClient.get(Endpoints.vehicleFilter);
    return VehicleSummaryModel.fromJson(res);
  }

  Future<GroupModel> getGroupList() async {
    final res = await _dioClient.get(Endpoints.vehicleGroupList);
    return GroupModel.fromJson(res);
  }

  Future<GroupDetail> getGroupDetail(String name) async {
    final res = await _dioClient
        .get(Endpoints.vehicleGroupDetail, queryParameters: {'group_name': name});
    return GroupDetail.fromJson(res);
  }

  Future<KeywordSearchModel> getKeywordSearchVehicle(String keyword) async {
    final res = await _dioClient
        .get(Endpoints.keywordSearch, queryParameters: {'q': keyword});
    return KeywordSearchModel.fromJson(res);
  }
}
