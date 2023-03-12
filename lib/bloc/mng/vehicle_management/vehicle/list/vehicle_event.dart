part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleEvent {
  const VehicleEvent();
}

class GetVehicle extends VehicleEvent {
  GetVehicle();
}

class ShowVehicleLoading extends VehicleEvent {}

class RefreshVehicle extends VehicleEvent {
  RefreshVehicle();
}
