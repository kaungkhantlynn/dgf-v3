part of 'vehicle_type_bloc.dart';

@immutable
abstract class VehicleTypeEvent {
  const VehicleTypeEvent();
}

class GetVehicleType extends VehicleTypeEvent {
  GetVehicleType();
}

class ShowVehicleTypeLoading extends VehicleTypeEvent {}

class RefreshVehicleType extends VehicleTypeEvent {
  RefreshVehicleType();
}
