import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';
import '../../../../../models/mng/vehicles_management/vehicles/vehicle_data.dart';
import 'vehicle_action_state.dart';

class VehicleActionCubit extends Cubit<VehicleActionState> {
  VehicleActionCubit(this.mngApi) : super(VehicleActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(VehicleActionLoading());
  //
  //   final result = await mngApi.exportVehicle().onError((error, stackTrace){
  //     emit(VehicleActionError(error: error.toString()));
  //   });
  //   emit(VehicleActionFinished());
  // }

  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    print('TOKEN_VEHICLE_EXPORT $token');
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.vehiclesExport,
        savedDir: externalDir!.path,

        showNotification: true, // show do
        saveInPublicStorage: true,
        headers: {'Authorization':"Bearer $token"}, // wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    final result = await mngApi.postVehicle(formData).then((value){
      emit(VehicleActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(VehicleActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(VehicleActionLoading());
    final result = await mngApi.updateVehicle(id,formData).then((value){
      emit(VehicleActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(VehicleActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(VehicleActionLoading());
    await mngApi.getVehiclesShow(id).then((value){
      emit(VehicleActionShowed(vehicleData: VehicleData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(VehicleActionError(error: error.toString()));
    });
  }





  Future<void> delete(int id) async{
    await mngApi.deleteVehicle(id).then((value){
      emit(VehicleActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(VehicleActionError(error: error.toString()));
    });
  }

}
