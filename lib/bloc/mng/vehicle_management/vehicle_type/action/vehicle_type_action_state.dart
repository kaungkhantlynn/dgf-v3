import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';
import 'package:fleetmanagement/models/success_model.dart';


abstract class VehicleTypeActionState {
  const VehicleTypeActionState();
  @override
  List<Object> get props => [];
}

class VehicleTypeActionInitial extends VehicleTypeActionState {}

class VehicleTypeActionLoading extends VehicleTypeActionState {

  VehicleTypeActionLoading();
}

class VehicleTypeActionShowed extends VehicleTypeActionState {
  VehicleTypeData? vehicleTypeData;

  VehicleTypeActionShowed(
      {this.vehicleTypeData});

  @override
  String toString() =>
      'VehicleTypeActionShowed ';
}

class VehicleTypeActionFinished extends VehicleTypeActionState {
  SuccessModel? successModel;
  VehicleTypeActionFinished(
      {this.successModel}
      );
}

class VehicleTypeActionError extends VehicleTypeActionState {
  final String? error;

  VehicleTypeActionError({this.error});
}
