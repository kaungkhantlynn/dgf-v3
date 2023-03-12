part of 'vehicles_bloc.dart';

@immutable
abstract class VehiclesEvent {
  const VehiclesEvent();
}

class GetVehicles extends VehiclesEvent {
  const GetVehicles();
}

class ShowVehiclesLoading extends VehiclesEvent {}

class RefreshVehicles extends VehiclesEvent {
  const RefreshVehicles();
}

class ResetVehicles extends VehiclesEvent {
  VehiclesModel? vehiclesModel;
  int? page;

  ResetVehicles({this.vehiclesModel, this.page});
}
