import 'package:fleetmanagement/models/mng/tracker_management/device_data.dart';
import 'package:fleetmanagement/models/mng/tracker_management/device_detail_data.dart';
import 'package:fleetmanagement/models/success_model.dart';

abstract class TrackerActionState {
  const TrackerActionState();
  @override
  List<Object> get props => [];
}

class TrackerActionInitial extends TrackerActionState {}

class TrackerActionLoading extends TrackerActionState {

  TrackerActionLoading();
}

class TrackerActionShowed extends TrackerActionState {
  DeviceData? deviceData;


  TrackerActionShowed(
      {this.deviceData});

  @override
  String toString() =>
      'TrackerActionShowed ';
}

class TrackerActionFinished extends TrackerActionState {
  SuccessModel? successModel;
  TrackerActionFinished(
      {this.successModel}
      );
}

class TrackerActionError extends TrackerActionState {
  final String? error;

  TrackerActionError({this.error});
}
