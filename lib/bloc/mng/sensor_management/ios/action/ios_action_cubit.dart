import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/ios/action/ios_action_state.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';

class IosActionCubit extends Cubit<IosActionState> {
  IosActionCubit(this.mngApi) : super(IosActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(IosActionLoading());
  //
  //   final result = await mngApi.exportSensor().onError((error, stackTrace){
  //     emit(IosActionError(error: error.toString()));
  //   });
  //   emit(IosActionFinished());
  // }

  // Future<void> export () async {
  //
  //   final status = await Permission.storage.request();
  //   var token = getIt<SharedPreferenceHelper>().loggedinToken;
  //   final externalDir = await getExternalStorageDirectory();
  //   // print(externalDir!.path);
  //   if (status.isGranted) {
  //     final taskId = await FlutterDownloader.enqueue(
  //       url: Endpoints.sensorExport,
  //       savedDir: externalDir!.path,
  //       fileName: 'sensors.xlsx',
  //       showNotification: true, // show do
  //       headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
  //       openFileFromNotification: true, // click on notification to open downloaded file (for Android)
  //     );
  //   }
  // }

  Future<void> create(FormData formData) async {
    final result = await mngApi.postSensor(formData).then((value){
      emit(IosActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(IosActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(IosActionLoading());
    final result = await mngApi.sensorUpdate(id, formData).then((value){
      emit(IosActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(IosActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(IosActionLoading());
    await mngApi.getSensorShow(id).then((value){
      emit(IosActionShowed(sensorData: SensorData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(IosActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteSensor(id).then((value){
      emit(IosActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(IosActionError(error: error.toString()));
    });
  }

}
