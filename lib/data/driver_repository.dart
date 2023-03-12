import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/driver/route/driver_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/driver/driver_profile/driver_profile_model.dart';
import 'package:fleetmanagement/models/driver/finished_job/finished_job_model.dart';
import 'package:fleetmanagement/models/driver/route_plan_detail/route_plan_detail_model.dart';
import 'package:fleetmanagement/models/driver/routeplan/route_plan_model.dart';
import 'package:fleetmanagement/models/notification/notification_model.dart';
import 'package:fleetmanagement/models/success_model.dart';

class DriverRepository {
  //api object
  final DriverApi _driverApi;

  //shared pref object
  final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  DriverRepository(this._driverApi, this._sharedPreferenceHelper);

  Future<RoutePlan> getRoutePlan() {
    return _driverApi.getRoutePlan();
  }

  Future<RoutePlanDetailModel> getRoutePlanDetail(int id) {
    return _driverApi.getRoutePlanDetail(id);
  }

  Future<FinishedJobModel> getFinishedJobs() {
    return _driverApi.getFinishedJobs();
  }

  Future<SuccessModel> postFinishJob(int id,FormData formData) {
    return _driverApi.postFinishJob(id,formData,_sharedPreferenceHelper);
  }
  Future<SuccessModel> postStartJob(int id) {
    return _driverApi.postStartJob(id);
  }

  Future<DriverProfileModel> getProfile() {
    return _driverApi.getDriverProfile();
  }

  Future<RoutePlan> getRoutePlanByDate(String date) {
    return _driverApi.getRoutePlanDate(date);
  }

  Future<NotificationModel> getNotifications(int page) {
    return _driverApi.getNotifications(page);
  }
}
