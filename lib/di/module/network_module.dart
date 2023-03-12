import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class NetworkModule {
  /// A singleton dio provider.
  ///
  /// Calling it multiple times will return the same instance.

  static Dio provideDio(SharedPreferenceHelper sharedPreferenceHelper) {
    final dio = Dio();

    dio
      ..options.baseUrl = Endpoints.baseUrl

      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.responseType = ResponseType.json

      ..options.followRedirects = false
      ..options.headers = {'Content-Type': 'application/json'}
      ..options.headers = {'X-API-Key': 'x-api-key'}
      ..options.headers = {'Locale': 'en'}
      ..interceptors.add(AppInterceptors(
          dio: dio, sharedPreferenceHelper: sharedPreferenceHelper));
    dio.options.headers['Accept'] = 'application/json';
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      // compact: true,
    ));
    // ..interceptors
    //     .add(InterceptorsWrapper(onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
    //   //getting token
    //   var token = await sharedPreferenceHelper.loggedinToken;

    //   if (token != null) {
    //     options.headers.putIfAbsent('Authorization', () => "Bearer " + token);
    //   } else {
    //     print('Auth token is null');
    //   }

    //   return handler.next(options);
    // }));
    // dio.options.headers["Authorization"] =
    //     "Bearer " + sharedPreferenceHelper.loggedinToken!;

    return dio;
  }
}
