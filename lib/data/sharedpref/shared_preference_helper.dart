import 'dart:async';
import 'dart:convert';

import 'package:fleetmanagement/models/auth/login_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/vehicles/vehicles_data.dart';
import 'constants/preferences.dart';

class SharedPreferenceHelper {
  // shared pref instance
  final SharedPreferences _sharedPreference;

  // constructor
  SharedPreferenceHelper(this._sharedPreference);

  // First Time: ---------------------------------------------------------------
  Future<String?> get getFirstTimeUse async {
    return _sharedPreference.getString(Preferences.firstTimeAppUse);
  }

  Future<void> doFirstTime() async {
    /// write to keystore/keychain
    // await  StorageService.setString(key: AppSetting.firstTimeAppUse, value: AppSetting.doneFirstTime);
    await _sharedPreference.setString(
        Preferences.firstTimeAppUse, Preferences.doneFirstTime);
    return;
  }

  Future<void> saveProvinces(String name) async {
    /// write to keystore/keychain
    // await  StorageService.setString(key: AppSetting.firstTimeAppUse, value: AppSetting.doneFirstTime);
    await _sharedPreference.setString(
        Preferences.provinces, name);
    return;
  }

  Future<void> saveParkingCount(String count) async {
    /// write to keystore/keychain
    // await  StorageService.setString(key: AppSetting.firstTimeAppUse, value: AppSetting.doneFirstTime);
    await _sharedPreference.setString(
        Preferences.parkingCount, count);
    return;
  }

  Future<void> saveNotiCount(String count) async {
    /// write to keystore/keychain
    // await  StorageService.setString(key: AppSetting.firstTimeAppUse, value: AppSetting.doneFirstTime);
    await _sharedPreference.setString(
        Preferences.notiCount, count);
    return;
  }

  String getParkingCount () {
    return _sharedPreference.getString(Preferences.parkingCount) ?? "-";
  }

  String getNotiCount () {
    return _sharedPreference.getString(Preferences.notiCount) ?? "-";
  }

  Future<void> saveOverspeedCount(String count) async {
    /// write to keystore/keychain
    // await  StorageService.setString(key: AppSetting.firstTimeAppUse, value: AppSetting.doneFirstTime);
    await _sharedPreference.setString(
        Preferences.overSpeedCount, count);
    return;
  }

  String getOverspeedCount () {
    return _sharedPreference.getString(Preferences.overSpeedCount) ?? "-";
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await _sharedPreference.setString(Preferences.userAlreadyLogin, token);
    return;
  }

  // General Methods: ----------------------------------------------------------
  Future<String?> get authToken async {
    return _sharedPreference.getString(Preferences.userAlreadyLogin);
  }

  Future<bool> saveAuthToken(String authToken) async {
    return _sharedPreference.setString(Preferences.auth_token, authToken);
  }

  String? get loggedinToken {
    return _sharedPreference.getString(Preferences.userAlreadyLogin);
  }

  Future<void> expireToken() async {
    await _sharedPreference.setString(
        Preferences.userAlreadyLogin, Preferences.logoutString);
  }

  Future<void> deleteToken() async {
    // String accessToken = StorageUtil.getString(AppSetting.userAlreadyLogin);
    // await _apiService.postUserLogout(accessToken);
    _sharedPreference.setString(
        Preferences.userAlreadyLogin, Preferences.logoutString);

    _sharedPreference.setString("refresh_token", "");

    return;
  }

  // Login:---------------------------------------------------------------------
  Future<bool> get isLoggedIn async {
    return _sharedPreference.getBool(Preferences.is_logged_in) ?? false;
  }

  Future<bool> saveIsLoggedIn(bool value) async {
    return _sharedPreference.setBool(Preferences.is_logged_in, value);
  }

  // Remember Me: -------------------------------------------------------------
  Future<void> saveRememberMe(LoginData loginData) async {
    _sharedPreference.setBool(Preferences.keyRememberMe, loginData.rememberMe);
    if (loginData.rememberMe) {
      print('REMEMBER TRUE');
      _sharedPreference.setString(Preferences.keyUsername, loginData.username);
      _sharedPreference.setString(Preferences.keyPassword, loginData.password);
      _sharedPreference.setBool(Preferences.keyRememberMe, false);
    } else {
      print('REMEMBER FALSE');
      _sharedPreference.setString(Preferences.keyUsername, '');
      _sharedPreference.setString(Preferences.keyPassword, '');
      _sharedPreference.setBool(Preferences.keyRememberMe, false);
    }
    return;
  }

  bool getRememberMe() {
    return _sharedPreference.getBool(Preferences.keyRememberMe) ?? false;
  }

  // String get getUsername {
  //   return _sharedPreference.getString(Preferences.keyUsername) ?? " ";
  // }

  String getUsername() {
    return _sharedPreference.getString(Preferences.keyUsername) ?? "";
  }

  String getPassword() {
    return _sharedPreference.getString(Preferences.keyPassword) ?? "";
  }

  // Theme:------------------------------------------------------
  bool get isDarkMode {
    return _sharedPreference.getBool(Preferences.is_dark_mode) ?? false;
  }

  Future<void> changeBrightnessToDark(bool value) {
    return _sharedPreference.setBool(Preferences.is_dark_mode, value);
  }

  // Language:---------------------------------------------------
  String? get currentLanguage {
    return _sharedPreference.getString(Preferences.current_language);
  }

  Future<void> changeLanguage(String language) {
    return _sharedPreference.setString(Preferences.current_language, language);
  }

  //License key for search
  Future<void> saveLicenseKey(String license){
    return _sharedPreference.setString(Preferences.licenseKey,license);
  }

  Future<void> clearLicenseKey(){
    return _sharedPreference.setString(Preferences.licenseKey,"");
  }

  String getLicenseKey() {
    return _sharedPreference.getString(Preferences.licenseKey) ?? "";
  }


  //Card Vehicle Page Change
  Future<void> changeCardVehicleIndex(int index) {
    return _sharedPreference.setInt(Preferences.cardVehicleIndexKey, index);
  }

  int? get currentCardVehicleIndex {
    return _sharedPreference.getInt(Preferences.cardVehicleIndexKey);
  }

  Future<void> changeVehicleNumber(String licenseNumber){
    return _sharedPreference.setString(Preferences.cardVehicleNumber, licenseNumber);
  }
  String? get currentVehicleNumber {
    return _sharedPreference.getString(Preferences.cardVehicleNumber);
  }

  Future<void> saveCardVehicleModel(VehiclesData vehicleData){
    return _sharedPreference.setString(Preferences.cardVehicleModelData, jsonEncode(vehicleData));
  }
  Future<void> clearCardVehicleModel(){
    return _sharedPreference.setString(Preferences.cardVehicleModelData, Preferences.emptyVehicle);
  }

  String? get currentVehicleModelData {
    if (_sharedPreference.containsKey(Preferences.cardVehicleModelData)) {
      return _sharedPreference.getString(Preferences.cardVehicleModelData) ?? Preferences.emptyVehicle;
    }  else {
      return Preferences.emptyVehicle;
    }

  }

  Future<void> setFilterKeys(List<String> filtersKey) {
    return _sharedPreference.setStringList(Preferences.filtersKey, filtersKey);
  }

  Future<void> setFilterKeysNull() async {
     _sharedPreference.setStringList(Preferences.filtersKey, []);
     _sharedPreference.setStringList(Preferences.groupFiltersKey, []);
  }

  Future<void> setGroupFilterKeys(List<String> filtersKey){
    return _sharedPreference.setStringList(Preferences.groupFiltersKey,filtersKey);
  }

  List<String>? get filtersKeys {
    return _sharedPreference.getStringList(Preferences.filtersKey);
  }

  List<String>? get groupfiltersKeys {
    return _sharedPreference.getStringList(Preferences.groupFiltersKey);
  }

  Future<void> persistMarkerSvg(String markerSvg) async {
    /// write to keystore/keychain
    await _sharedPreference.setString(Preferences.markerSvg, markerSvg);
    return;
  }

  Future<String?> get markerSvg async {
    return _sharedPreference.getString(Preferences.markerSvg);
  }

}
