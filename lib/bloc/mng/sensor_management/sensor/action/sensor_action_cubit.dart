import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_data.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';
import 'sensor_action_state.dart';

class SensorActionCubit extends Cubit<SensorActionState> {
  SensorActionCubit(this.mngApi) : super(SensorActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(SensorActionLoading());
  //
  //   final result = await mngApi.exportSensor().onError((error, stackTrace){
  //     emit(SensorActionError(error: error.toString()));
  //   });
  //   emit(SensorActionFinished());
  // }

  Future<void> export () async {
    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.sensorExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        saveInPublicStorage: true,
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }


  Future<void> create(FormData formData) async {
    final result = await mngApi.postSensor(formData).then((value){
      emit(SensorActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(SensorActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(SensorActionLoading());
    final result = await mngApi.sensorUpdate(id, formData).then((value){
      emit(SensorActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(SensorActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(SensorActionLoading());
    await mngApi.getSensorShow(id).then((value){
      emit(SensorActionShowed(sensorData: SensorData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(SensorActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteSensor(id).then((value){
      emit(SensorActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(SensorActionError(error: error.toString()));
    });
  }

}
