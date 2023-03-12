import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';
import 'vehicle_type_action_state.dart';

class VehicleTypeActionCubit extends Cubit<VehicleTypeActionState> {
  VehicleTypeActionCubit(this.mngApi) : super(VehicleTypeActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(VehicleTypeActionLoading());
  //
  //   final result = await mngApi.exportVehicleType().onError((error, stackTrace){
  //     emit(VehicleTypeActionError(error: error.toString()));
  //   });
  //   emit(VehicleTypeActionFinished());
  // }

  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.vehiclesExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    final result = await mngApi.postVehicleType(formData).then((value){
      emit(VehicleTypeActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(VehicleTypeActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(VehicleTypeActionLoading());
    final result = await mngApi.updateVehicleType(id,formData).then((value){
      emit(VehicleTypeActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(VehicleTypeActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(VehicleTypeActionLoading());
    await mngApi.getVehicleTypeShow(id).then((value){
      emit(VehicleTypeActionShowed(vehicleTypeData: VehicleTypeData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(VehicleTypeActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteVehicleType(id).then((value){
      emit(VehicleTypeActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(VehicleTypeActionError(error: error.toString()));
    });
  }

}
