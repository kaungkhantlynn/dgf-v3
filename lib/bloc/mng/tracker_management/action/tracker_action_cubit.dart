import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/models/mng/tracker_management/device_data.dart';
import 'package:fleetmanagement/models/mng/tracker_management/device_detail_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../models/mng/vehicles_management/vehicles/vehicle_data.dart';
import '../../../../data/network/constants/endpoints.dart';
import '../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../di/components/service_locator.dart';
import 'tracker_action_state.dart';

class TrackerActionCubit extends Cubit<TrackerActionState> {
  TrackerActionCubit(this.mngApi) : super(TrackerActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(TrackerActionLoading());
  //
  //   final result = await mngApi.exportDevices().onError((error, stackTrace){
  //     emit(TrackerActionError(error: error.toString()));
  //   });
  //   emit(TrackerActionFinished());
  // }

  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.devicesExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    final result = await mngApi.postDevices(formData).then((value){
      emit(TrackerActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(TrackerActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(TrackerActionLoading());
    final result = await mngApi.updateDevices(id, formData).then((value){
      emit(TrackerActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(TrackerActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(TrackerActionLoading());
    await mngApi.getDevicesShow(id).then((value){
      emit(TrackerActionShowed(deviceData: DeviceData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(TrackerActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteDevices(id).then((value){
      emit(TrackerActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(TrackerActionError(error: error.toString()));
    });
  }
}
