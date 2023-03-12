import 'package:fleetmanagement/models/mng/driver_management/driver/driver_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/driver_detail_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class DriverActionState {
  const DriverActionState();
  @override
  List<Object> get props => [];
}

class DriverActionInitial extends DriverActionState {}

class DriverActionLoading extends DriverActionState {

  DriverActionLoading();
}

class DriverActionShowed extends DriverActionState {
  DriverDetailData? driverDetailData;

  DriverActionShowed(
      {this.driverDetailData});

  @override
  String toString() =>
      'DriverActionShowed ';
}

class DriverActionFinished extends DriverActionState {
  SuccessModel? successModel;
  DriverActionFinished(
      {this.successModel}
      );
}

class DriverActionError extends DriverActionState {
  final String? error;

  DriverActionError({this.error});
}
