import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/data/network/dio_client.dart';
import 'package:fleetmanagement/data/network/rest_client.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/driver/driver_profile/driver_profile_model.dart';
import 'package:fleetmanagement/models/driver/finished_job/finished_job_model.dart';
import 'package:fleetmanagement/models/driver/route_plan_detail/route_plan_detail_model.dart';
import 'package:fleetmanagement/models/driver/routeplan/route_plan_model.dart';
import 'package:fleetmanagement/models/success_model.dart';

import '../../../../../models/notification/notification_model.dart';

class DriverApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  DriverApi(this._dioClient, this._restClient);

  Future<RoutePlan> getRoutePlan() async {
    final res = await _dioClient.get(Endpoints.routePlans);
    return RoutePlan.fromJson(res);
  }

  Future<RoutePlan> getRoutePlanDate(String date) async {
    final res = await _dioClient.get('${Endpoints.routePlans}/search',queryParameters: {'date':date});
    return RoutePlan.fromJson(res);
  }

  Future<RoutePlanDetailModel> getRoutePlanDetail(int id) async {
    final res =
        await _dioClient.get('${Endpoints.routePlanDetail}/$id');
    return RoutePlanDetailModel.fromJson(res);
  }

  Future<FinishedJobModel> getFinishedJobs() async {
    final res = await _dioClient.get(Endpoints.finished);
    return FinishedJobModel.fromJson(res);
  }

  Future<SuccessModel> postFinishJob(int id,FormData formData,SharedPreferenceHelper sharedPreferenceHelper) async {
      print('POST FINISH URL ${Endpoints.postFinish}${id.toString()}');
          final res = await _dioClient.postForm(Endpoints.postFinish + id.toString(),data: formData);
    return SuccessModel.fromJson(res);
  }

  Future<SuccessModel> postStartJob(int id) async {

    final res = await _dioClient.post(Endpoints.postStart + id.toString());
    return SuccessModel.fromJson(res);
  }

  Future<DriverProfileModel> getDriverProfile() async {
    final res = await _dioClient.get(Endpoints.profile);
    return DriverProfileModel.fromJson(res);
  }

  Future<NotificationModel> getNotifications( int page) async {
    final res = await _dioClient.get(Endpoints.notification);
    return NotificationModel.fromJson(res);
  }


}
