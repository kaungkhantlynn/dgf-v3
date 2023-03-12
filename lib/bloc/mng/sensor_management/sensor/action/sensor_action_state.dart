import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../models/mng/sensor_management/sensor_type/sensor_type_data.dart';

abstract class SensorActionState {
  const SensorActionState();
  @override
  List<Object> get props => [];
}

class SensorActionInitial extends SensorActionState {}

class SensorActionLoading extends SensorActionState {

  SensorActionLoading();
}

class SensorActionShowed extends SensorActionState {
  SensorData? sensorData;

  SensorActionShowed(
      {this.sensorData});

  @override
  String toString() =>
      'SensorActionShowed ';
}

class SensorActionFinished extends SensorActionState {
  SuccessModel? successModel;
  SensorActionFinished(
      {this.successModel}
      );
}

class SensorActionError extends SensorActionState {
  final String? error;

  SensorActionError({this.error});
}
