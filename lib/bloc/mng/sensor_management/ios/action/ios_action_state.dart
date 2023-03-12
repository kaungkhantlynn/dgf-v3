import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../models/mng/sensor_management/sensor_type/sensor_type_data.dart';

abstract class IosActionState {
  const IosActionState();
  @override
  List<Object> get props => [];
}

class IosActionInitial extends IosActionState {}

class IosActionLoading extends IosActionState {

  IosActionLoading();
}

class IosActionShowed extends IosActionState {
  SensorData? sensorData;

  IosActionShowed(
      {this.sensorData});

  @override
  String toString() =>
      'IosActionShowed ';
}

class IosActionFinished extends IosActionState {
  SuccessModel? successModel;
  IosActionFinished(
      {this.successModel}
      );
}

class IosActionError extends IosActionState {
  final String? error;

  IosActionError({this.error});
}
