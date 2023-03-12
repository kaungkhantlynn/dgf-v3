import 'dart:async';

import 'package:fleetmanagement/data/network/api/auth/auth_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/auth/auth_check_model.dart';
import 'package:fleetmanagement/models/auth/auth_model.dart';
import 'package:fleetmanagement/models/auth/login_data.dart';

class AuthRepository {
  // api object
  final AuthApi _authApi;

  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  // constructor
  AuthRepository(this._authApi, this._sharedPrefsHelper);

  // Authenticate: ------------------------------------------------------------
  Future<AuthModel> authenticate({String? username, String? password}) async {
    return _authApi.authenticate(username: username, password: password);
  }

  //Auth Check
  Future<AuthCheckModel> checkAuth() async {
    return _authApi.checkAuth().catchError((error){
      print(error.toString());
    });
  }

  //Logout
  Future<AuthCheckModel> logout() async {
    return _authApi.logout();
  }

  // Remember Me ---------------------------------------------------------------
  Future<void> saveRememberMe(LoginData loginData) async {
    return _sharedPrefsHelper.saveRememberMe(loginData);
  }

  // Firsttime -----------------------------------------------------------------
  Future<String?> getFirstTimeUse() async {
    return _sharedPrefsHelper.getFirstTimeUse;
  }

  Future<void> doFirstTime() async {
    await _sharedPrefsHelper.doFirstTime();
  }

  // Auth Token ----------------------------------------------------------------
  Future<String?> getToken() async {
    return _sharedPrefsHelper.authToken;
  }

  Future<void> persistToken(String token) async {
    await _sharedPrefsHelper.persistToken(token);
  }

  Future<void> expiredToken() async {
    await _sharedPrefsHelper.expireToken();
  }

  Future<void> deleteToken() async {
    await logout();
    await _sharedPrefsHelper.deleteToken();
  }
}
