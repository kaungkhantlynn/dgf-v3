part of 'vehicles_detail_bloc.dart';

@immutable
abstract class VehiclesDetailsEvent {
  const VehiclesDetailsEvent();
}

class GetVehiclesDetails extends VehiclesDetailsEvent {
  String? license;
  String? status;
  GetVehiclesDetails({this.license, this.status});
}

class ShowVehiclesDetailsLoading extends VehiclesDetailsEvent {}

class RefreshVehiclesDetails extends VehiclesDetailsEvent {
  const RefreshVehiclesDetails();
}

class ResetVehiclesDetails extends VehiclesDetailsEvent {
  VehiclesDetailModel? vehiclesDetailModel;
  int? page;

  ResetVehiclesDetails({this.vehiclesDetailModel, this.page});
}
