import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_type_data.dart';
import 'package:fleetmanagement/models/success_model.dart';

abstract class FuelTypeActionState {
  const FuelTypeActionState();
  @override
  List<Object> get props => [];
}

class FuelTypeActionInitial extends FuelTypeActionState {}

class FuelTypeActionLoading extends FuelTypeActionState {

  FuelTypeActionLoading();
}

class FuelTypeActionShowed extends FuelTypeActionState {
  FuelTypeData? fuelTypeData;

  FuelTypeActionShowed(
      {this.fuelTypeData});

  @override
  String toString() =>
      'FuelTypeActionShowed ';
}

class FuelTypeActionFinished extends FuelTypeActionState {
  SuccessModel? successModel;
  FuelTypeActionFinished(
      {this.successModel}
      );
}

class FuelTypeActionError extends FuelTypeActionState {
  final String? error;

  FuelTypeActionError({this.error});
}
