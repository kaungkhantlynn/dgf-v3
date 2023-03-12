import 'dart:convert';

import 'package:fleetmanagement/data/network/api/tracking/tracking_api.dart';
import 'package:fleetmanagement/data/sharedpref/constants/preferences.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/jsession_model.dart';
import 'package:fleetmanagement/models/other/keyword_search_model.dart';
import 'package:fleetmanagement/models/tracking/tracking_model.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_model.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';

import '../models/tracking/longdo_location.dart';
import '../models/vehicles/vehicles_data.dart';

class TrackingRepository {
  //api object
  final TrackingApi _trackingApi;

  //shared pref object
  final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  TrackingRepository(
    this._trackingApi,
    this._sharedPreferenceHelper,
  );

  Future<VehiclesModel> getVehicles({List<String>? status, List<String>? groupKey,String? licenseKey}) async {
    return _trackingApi.getVehicles(status: status,groupKey: groupKey,licenseKey: licenseKey);
  }


  Future<List<LongdoLocation>?> getLongdoLocation({String? lat, String? lng}) async {
    return _trackingApi.fetchLongdoLocation(lat!,lng!);

  }

  Future<VehiclesDetailModel> getVehiclesDetail(
      String license, String status) async {
    return _trackingApi.getVehiclesDetail(license, status);
  }

  Future<JsessionModel> getJsessionToken(){
    return _trackingApi.generateJsession();
  }

  Future<TrackingModel> getLiveTracking(String license, int page) async {
    return _trackingApi.getLiveTracking(license, page);
  }

  Future<TrackingHistoryModel> getTrackingHistory(
      String license, String date) async {
    return _trackingApi.getTrackingHistory(license, date);
  }

  Future<VehicleSummaryModel> getVehicleFilter() async {
    return _trackingApi.getVehicleFilter();
  }

  Future<KeywordSearchModel> getKeywordSearch(String keyword) async {
    return _trackingApi.getKeywordSearchVehicle(keyword);
  }

  // sharepreferences
  Future<void> setCardVehicleIndex(int index) {
    return _sharedPreferenceHelper.changeCardVehicleIndex(index);
  }

  int? get cardVehicleIndex => _sharedPreferenceHelper.currentCardVehicleIndex;

  Future<void> setVehicleNumber(String licenseNumber){
    return _sharedPreferenceHelper.changeVehicleNumber(licenseNumber);
  }
  String? get cardVehicleNumber => _sharedPreferenceHelper.currentVehicleNumber;

  Future<void> setVehicleModelData(VehiclesData vehicleData){
    return _sharedPreferenceHelper.saveCardVehicleModel(vehicleData);
  }
  Future<void> clearVehicleModelData(){
    return _sharedPreferenceHelper.clearCardVehicleModel();
  }
   getVehicleData (){
    if (_sharedPreferenceHelper.currentVehicleModelData == "empty_data" ||_sharedPreferenceHelper.currentVehicleModelData == Preferences.emptyVehicle) {
      print("SDFSDF");
      return Preferences.emptyVehicle;
    } else {
      print("REPOGETV ${_sharedPreferenceHelper.currentVehicleModelData!}");
      Map<String,dynamic>  result = jsonDecode(_sharedPreferenceHelper.currentVehicleModelData!);
      return result;
    }


  }

  Future<void> setFilterKeys(List<String> filtersKey) {
    return _sharedPreferenceHelper.setFilterKeys(filtersKey);
  }

  Future<void> setFilterKeysNull() {
    return _sharedPreferenceHelper.setFilterKeysNull();
  }

  List<String>? get filterKeys {
    return _sharedPreferenceHelper.filtersKeys;
  }
  List<String>? get groupfilterKeys {
    return _sharedPreferenceHelper.groupfiltersKeys;
  }


}
