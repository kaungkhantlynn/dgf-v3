import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../models/mng/sensor_management/sensor_type/sensor_type_data.dart';

abstract class SensorTypeActionState {
  const SensorTypeActionState();
  @override
  List<Object> get props => [];
}

class SensorTypeActionInitial extends SensorTypeActionState {}

class SensorTypeActionLoading extends SensorTypeActionState {

  SensorTypeActionLoading();
}

class SensorTypeActionShowed extends SensorTypeActionState {
  SensorTypeData? sensorTypeData;

  SensorTypeActionShowed(
      {this.sensorTypeData});

  @override
  String toString() =>
      'SensorTypeActionShowed ';
}

class SensorTypeActionFinished extends SensorTypeActionState {
  SuccessModel? successModel;
  SensorTypeActionFinished(
      {this.successModel}
      );
}

class SensorTypeActionError extends SensorTypeActionState {
  final String? error;

  SensorTypeActionError({this.error});
}
