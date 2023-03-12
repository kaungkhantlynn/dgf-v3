import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_data.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_model.dart';
import 'package:meta/meta.dart';

part 'tracking_history_state.dart';

class TrackingHistoryCubit extends Cubit<TrackingHistoryState> {
  TrackingHistoryCubit(this.trackingRepository)
      : super(TrackingHistoryInitial());
  final TrackingRepository trackingRepository;

  Future<void> fetchPoints(String license, String date) async {
    final responseItems =
        await trackingRepository.getTrackingHistory(license, date);
    if (responseItems.data!.isNotEmpty) {
      print('TRACKING_HISTORY_DATA${responseItems.data!.length}');
      emit(TrackingHistoryCompleted(responseItems, selectedItem: 0));
    } else {
      print("TRACKING_HISTORY_DATA_NOT_FOUND");
      emit(TrackingHistoryNoData("Data Not Found"));
    }
  }

  Future<void> fetchPointsCustomMarker(String license, String date) async {
    final responseItems =
        await trackingRepository.getTrackingHistory(license, date);
    if (responseItems != null) {
      emit(TrackingHistoryCompleted(responseItems, selectedItem: 0));
    } else {
      emit(TrackingHistoryError("Data Not Found"));
    }
  }

  void changeSelectedCoordinate(int index, List<TrackingHistoryData> items) {
    final stateData = state as TrackingHistoryCompleted;
    emit(stateData.copyWith(selectedItem: index));
  }
}
