import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../data/network/constants/endpoints.dart';
import '../../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../../di/components/service_locator.dart';
import 'action_state.dart';

class ActionCubit extends Cubit<ActionState> {
  ActionCubit(this.mngApi) : super(ActionInitial());

  final MngApi mngApi;
  int page = 1;

  // Future<void> export () async {
  //   emit(ActionLoading());
  //
  //   final result = await mngApi.exportFuel().onError((error, stackTrace){
  //     emit(ActionError(error: error.toString()));
  //   });
  //   emit(ActionFinished());
  // }

  Future<void> export () async {

    final status = await Permission.storage.request();
    var token = getIt<SharedPreferenceHelper>().loggedinToken;
    final externalDir = await getExternalStorageDirectory();
    // print(externalDir!.path);
    if (status.isGranted) {
      final taskId = await FlutterDownloader.enqueue(
        url: Endpoints.fuelsExport,
        savedDir: externalDir!.path,
        showNotification: true, // show do
        headers: {'Authorization':"Bearer $token"},// wnload progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  Future<void> create(FormData formData) async {
    final result = await mngApi.createFuel(formData).then((value){
      emit(ActionFinished(successModel: value));
    }).onError((error, stackTrace) {
      emit(ActionError(error: error.toString()));
    });
  }

  Future<void> update(formData,int id) async{
    emit(ActionLoading());
    final result = await mngApi.updateFuel(id, formData).then((value){
      emit(ActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(ActionError(error: error.toString()));
    });
  }

  Future<void> show(int id) async {
    emit(ActionLoading());
    await mngApi.getFuelShow(id).then((value){
      emit(ActionShowed(fuelData: FuelData.fromJson(value.data!.toJson())));
    }).onError((error, stackTrace){
      emit(ActionError(error: error.toString()));
    });
  }

  Future<void> delete(int id) async{
    await mngApi.deleteFuel(id).then((value){
      emit(ActionFinished(successModel: value));
    }).onError((error, stackTrace){
      emit(ActionError(error: error.toString()));
    });
  }

  // Future<void> fetchLivePoint(String license) async {
  //   print('FETCHLIVEPOINT $license');
  //   if (state is LiveTrackingLoading) return;
  //   final currentState = state;
  //   var oldPosts = <TracksData>[];
  //
  //   if (currentState is LiveTrackingLoaded) {
  //     oldPosts = currentState.trackData!;
  //   }
  //
  //   emit(LiveTrackingLoading(oldPosts, isFirstFetch: page == 1));
  //
  //   trackingRepository.getLiveTracking(license, page).then((newPosts) {
  //     if (newPosts.pagination!.currentPage! <=
  //         newPosts.pagination!.totalPages!) {
  //       page++;
  //     }
  //
  //     bool hasReachMax =
  //     newPosts.pagination!.currentPage! <= newPosts.pagination!.totalPages!
  //         ? false
  //         : true;
  //     final posts = (state as LiveTrackingLoading).oldPosts;
  //     posts!.addAll(newPosts.tracks!);
  //
  //     for (var i = 0; i < posts.length; i++) {
  //       print('LOOPTEST BLOC ' + posts[i].mlat!);
  //       // emit(LiveTrackingLoaded(trackData: posts, coordinate: LatLng(double.parse(posts[i].mlat!),double.parse(posts[i].mlng!)),hasReachedMax: hasReachMax,page: page));
  //     }
  //
  //     // print('POSTSIZE'+posts.length.toString());
  //
  //     //
  //     // posts.forEach((element) {
  //     //   print('MYELEMENT '+element.toString());
  //     //
  //     // });
  //   });
  // }
}
