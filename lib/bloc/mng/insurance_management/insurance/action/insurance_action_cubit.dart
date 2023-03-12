import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';
import 'insurance_action_state.dart';

class InsuranceActionCubit extends Cubit<InsuranceActionState> {
  InsuranceActionCubit(this.mngApi) : super(InsuranceActionInitial());

  final MngApi mngApi;
  int page = 1;
  //
  // Future<void> export () async {
  //   emit(InsuranceActionLoading());
  //
  //   final result = await mngApi.exportInsurance().onError((error, stackTrace){
  //     emit(InsuranceActionError(error: error.toString()));
  //   });
  //   emit(InsuranceActionFinished());
  // }

  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.insurancesExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    final result = await mngApi.postInsurance(formData).then((value){
      emit(InsuranceActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(InsuranceActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(InsuranceActionLoading());
    final result = await mngApi.updateInsurance(id, formData).then((value){
      emit(InsuranceActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(InsuranceActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(InsuranceActionLoading());
    await mngApi.getInsuranceShow(id).then((value){
      emit(InsuranceActionShowed(insuranceData: InsuranceData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(InsuranceActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteInsurance(id).then((value){
      emit(InsuranceActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(InsuranceActionError(error: error.toString()));
    });
  }

}
