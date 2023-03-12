
import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_detail_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/network/app_interceptors.dart';
import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../di/components/service_locator.dart';
import 'driver_action_state.dart';

class DriverActionCubit extends Cubit<DriverActionState> {
  DriverActionCubit(this.mngApi) : super(DriverActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Track the progress of a downloaded file here.
  double progress = 0;

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;

  // Show the progress status to the user.
  String progressString = 'File has not been downloaded yet.';
  late String? _localPath;
  // This method uses Dio to download a file from the given URL
  // and saves the file to the provided `savePath`.
  // Future download(Dio dio, String url, String savePath) async {
  //   print(url);
  //   print(savePath);
  //   try {
  //     Response response = await dio.get(
  //       url,
  //       onReceiveProgress: updateProgress,
  //       options: Options(
  //           responseType: ResponseType.bytes,
  //           followRedirects: false,
  //           validateStatus: (status) { return status! < 500; }
  //       ),
  //     );
  //     var file = File(savePath).openSync(mode: FileMode.write);
  //     file.writeFromSync(response.data);
  //     await file.close();
  //
  //     // Here, you're catching an error and printing it. For production
  //     // apps, you should display the warning to the user and give them a
  //     // way to restart the download.
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // You can update the download progress here so that the user is
  // aware of the long-running task.
  // void updateProgress(done, total) {
  //   progress = done / total;
  //   if (progress >= 1) {
  //     progressString = '✅ File has finished downloading. Try opening the file.';
  //     didDownloadPDF = true;
  //     emit(DriverActionFinished());
  //   } else {
  //     progressString = 'Download progress: ' + (progress * 100).toStringAsFixed(0) + '% done.';
  //   }
  // }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;
    final savedDir = Directory(_localPath!);
    final hasExisted = savedDir.existsSync();
    if (!hasExisted) {
      await savedDir.create();
    }
  }


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
    print(externalStorageDirPath);
    return externalStorageDirPath;
  }


  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.driverExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    try{
      final result = await mngApi.postDriver(formData);
     await Future.delayed(Duration(microseconds: 1500));
      emit(DriverActionFinished());
    }on EmailAlreadyTakenException catch (error) {
      emit(DriverActionError(error: error.message));
    }
    on NoInternetConnectionException catch (error) {
      emit(DriverActionError(error: error.message));
    } on InternalServerErrorException catch (error) {
      emit(DriverActionError(error: error.message));
    } catch (e) {
      emit(DriverActionError(error: e.toString()));
    }
  }

  Future<void> update(formData, int id) async{
    emit(DriverActionLoading());
    final result = await mngApi.updateDriver(id, formData).then((value){
      emit(DriverActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(DriverActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(DriverActionLoading());
    await mngApi.getDriverShow(id).then((value){
      emit(DriverActionShowed(driverDetailData: value));
    }).onError((error, stackTrace){
      emit(DriverActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteDriver(id).then((value){
      emit(DriverActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(DriverActionError(error: error.toString()));
    });
  }
}
