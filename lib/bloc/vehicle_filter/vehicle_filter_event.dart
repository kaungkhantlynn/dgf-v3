part of 'vehicle_filter_bloc.dart';

@immutable
abstract class VehicleFilterEvent {
  const VehicleFilterEvent();
}

class GetVehicleFilter extends VehicleFilterEvent {
  const GetVehicleFilter();
}

class ShowVehicleFilterLoading extends VehicleFilterEvent {}

class RefreshVehicleFilter extends VehicleFilterEvent {
  const RefreshVehicleFilter();
}
