import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/bloc/mng/driver_management/assistant/action/assistant_action_state.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/network/app_interceptors.dart';
import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';



class AssistantActionCubit extends Cubit<AssistantActionState> {
  AssistantActionCubit(this.mngApi) : super(AssistantActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(AssistantActionLoading());
  //
  //   final result = await mngApi.exportAssistants().onError((error, stackTrace) {
  //     emit(AssistantActionError(error: error.toString()));
  //   });
  //   emit(AssistantActionFinished());
  // }
  late String _localPath;

  Future<String?> _findLocalPath() async {
    String? externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.downloadsPath;
      } catch (e) {
        final directory = await getExternalStorageDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<void> export () async {
    _localPath = (await _findLocalPath())!;
    print("LOCALPATH"+_localPath);
    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;

    print("EXTDIR");

    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.assistantsExport,
        savedDir: _localPath,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    try{
      final result = await mngApi.postAssistant(formData);
      await Future.delayed(Duration(microseconds: 1500));
      emit(AssistantActionFinished());
    }
    on BadRequestException catch (error ) {
      emit(AssistantActionError(error: error.message));
    }
    on NoInternetConnectionException catch (error) {
      emit(AssistantActionError(error: error.message));
    } on InternalServerErrorException catch (error) {
      emit(AssistantActionError(error: error.message));
    } catch (e) {
      emit(AssistantActionError(error: e.toString()));
    }
  }

  Future<void> update(formData, int id) async{
    emit(AssistantActionLoading());
    final result = await mngApi.updateAssistant(id,formData).then((value){
      print("VALIEREIORUI ${value.status}  ${value.success}");
      emit(AssistantActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(AssistantActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    await mngApi.getAssistantShow(id).then((value){
      emit(AssistantActionShowed(assistantData: AssistantData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(AssistantActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteAssistant(id).then((value){
      emit(AssistantActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(AssistantActionError(error: error.toString()));
    });
  }
}
