import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_bloc.dart';
import 'package:fleetmanagement/bloc/cubit/filter/filter_bloc.dart';
import 'package:fleetmanagement/bloc/jobfilter/jobfilter_bloc.dart';
import 'package:fleetmanagement/bloc/notification/notification_bloc.dart';
import 'package:fleetmanagement/bloc/routeplan/route_plan_bloc.dart';
import 'package:fleetmanagement/bloc/save_finished_job/save_finish_job_bloc.dart';
import 'package:fleetmanagement/bloc/vehicles/vehicles_bloc.dart';
import 'package:fleetmanagement/bloc/vehiclesDetail/vehicles_detail_bloc.dart';
import 'package:fleetmanagement/data/alarm_report_repository.dart';
// import 'package:fleetmanagement/bloc/tracking/vehicles/vehicles_detail_bloc.dart';
import 'package:fleetmanagement/data/auth_repository.dart';
import 'package:fleetmanagement/data/network/api/auth/auth_api.dart';
import 'package:fleetmanagement/data/network/api/driver/route/driver_api.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/api/other/other_api.dart';
import 'package:fleetmanagement/data/network/api/report/report_api.dart';
import 'package:fleetmanagement/data/network/api/tracking/tracking_api.dart';
import 'package:fleetmanagement/data/network/api/video/video_api.dart';
import 'package:fleetmanagement/data/network/dio_client.dart';
import 'package:fleetmanagement/data/network/rest_client.dart';
import 'package:fleetmanagement/data/other_repostory.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/module/local_module.dart';
import 'package:fleetmanagement/di/module/network_module.dart';
import 'package:fleetmanagement/ui/driver/jobs/job_filter.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ui/driver/notification/notifications.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // async singletons:----------------------------------------------------------
  getIt.registerSingletonAsync<SharedPreferences>(
      () => LocalModule.provideSharedPreferences());

  // singletons:----------------------------------------------------------------
  getIt.registerSingleton(
      SharedPreferenceHelper(await getIt.getAsync<SharedPreferences>()));
  getIt.registerSingleton<Dio>(
      NetworkModule.provideDio(getIt<SharedPreferenceHelper>()));
  getIt.registerSingleton(DioClient(getIt<Dio>()));
  getIt.registerSingleton(RestClient());

  // api's:---------------------------------------------------------------------
  getIt.registerSingleton(AuthApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(TrackingApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(ReportApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(OtherApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(VideoApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(DriverApi(getIt<DioClient>(), getIt<RestClient>()));
  getIt.registerSingleton(MngApi(getIt<DioClient>(), getIt<RestClient>()));

  // auth repository:----------------------------------------------------------------
  getIt.registerSingleton(AuthRepository(
    getIt<AuthApi>(),
    getIt<SharedPreferenceHelper>(),
  ));

  // tracking repository: ----------------------------------------------------------------
  getIt.registerSingleton(TrackingRepository(
    getIt<TrackingApi>(),
    getIt<SharedPreferenceHelper>(),
  ));

  // report repository: ------------------------------------------------------
  getIt.registerSingleton(AlarmReportRepository(
    getIt<ReportApi>(),
    getIt<SharedPreferenceHelper>(),
  ));

  // other repository: -------------------------------------------------------
  getIt.registerSingleton(OtherRepository(
    getIt<OtherApi>(),
    getIt<SharedPreferenceHelper>(),
  ));

  // video repository: -------------------------------------------------------
  getIt.registerSingleton(VideoRepository(
    getIt<VideoApi>(),
    getIt<SharedPreferenceHelper>(),
  ));

  // route repository: --------------------------------------------------------
  getIt.registerSingleton(
      DriverRepository(getIt<DriverApi>(), getIt<SharedPreferenceHelper>()));

  // bloc: --------------------------------------------------------------------
  getIt.registerSingleton(AuthenticationBloc(getIt<AuthRepository>()));
  getIt.registerSingleton(VehiclesBloc(getIt<TrackingRepository>()));
  getIt.registerSingleton(VehiclesDetailBloc(getIt<TrackingRepository>()));
  getIt.registerSingleton(RoutePlanBloc(getIt<DriverRepository>()));
  getIt.registerSingleton(FilterBloc());
  getIt.registerSingleton(SaveFinishJobBloc(getIt<DriverRepository>()));
  getIt.registerSingleton(const JobFilter());
  getIt.registerSingleton(JobFilterBloc(getIt<DriverRepository>()));
  getIt.registerSingleton(const Notifications());
  getIt.registerSingleton(NotificationBloc(getIt<DriverRepository>()));
}
