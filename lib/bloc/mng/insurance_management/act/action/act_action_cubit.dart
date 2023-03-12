import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';
import 'act_action_state.dart';

class ActActionCubit extends Cubit<ActActionState> {
  ActActionCubit(this.mngApi) : super(ActActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(ActActionLoading());
  //
  //   final result = await mngApi.exportAct().onError((error, stackTrace){
  //     emit(ActActionError(error: error.toString()));
  //   });
  //   emit(ActActionFinished());
  // }

  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.actsExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    final result = await mngApi.postAct(formData).then((value){
      emit(ActActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(ActActionError(error: error.toString()));
    });
  }

  Future<void> update(formData, int id) async{
    emit(ActActionLoading());
    final result = await mngApi.updateAct(id, formData).then((value){
      emit(ActActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(ActActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(ActActionLoading());
    await mngApi.getActShow(id).then((value){
      emit(ActActionShowed(actData: ActData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(ActActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteAct(id).then((value){
      emit(ActActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(ActActionError(error: error.toString()));
    });
  }
}
