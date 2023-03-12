import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicle_data.dart';
import 'package:fleetmanagement/models/success_model.dart';
import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../models/mng/sensor_management/sensor_type/sensor_type_data.dart';

abstract class VehicleActionState {
  const VehicleActionState();
  @override
  List<Object> get props => [];
}

class VehicleActionInitial extends VehicleActionState {}

class VehicleActionLoading extends VehicleActionState {

  VehicleActionLoading();
}

class VehicleActionShowed extends VehicleActionState {
  VehicleData? vehicleData;

  VehicleActionShowed(
      {this.vehicleData});

  @override
  String toString() =>
      'VehicleActionShowed ';
}

class VehicleActionFinished extends VehicleActionState {
  SuccessModel? successModel;
  VehicleActionFinished(
      {this.successModel}
      );
}

class VehicleActionError extends VehicleActionState {
  final String? error;

  VehicleActionError({this.error});
}
