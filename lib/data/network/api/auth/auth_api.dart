import 'dart:async';

import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/data/network/dio_client.dart';
import 'package:fleetmanagement/data/network/rest_client.dart';
import 'package:fleetmanagement/models/auth/auth_check_model.dart';
import 'package:fleetmanagement/models/auth/auth_model.dart';
import 'package:flutter/material.dart';

class AuthApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  AuthApi(this._dioClient, this._restClient);

  Future<AuthModel> authenticate({
    @required String? username,
    @required String? password,
  }) async {
    var formData = FormData.fromMap({
      "email": username,
      "password": password,
    });
    final res = await _dioClient.post(Endpoints.adminLogin, data: formData);
    return AuthModel.fromJson(res);
  }

  Future<AuthCheckModel> checkAuth() async {
    final res = await _dioClient.get(Endpoints.authcheck);
    return AuthCheckModel.fromJson(res);
  }

  Future<AuthCheckModel> logout() async {
    final res = await _dioClient.post(Endpoints.logout);
    return AuthCheckModel.fromJson(res);
  }
}
