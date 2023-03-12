part of 'vehicles_detail_bloc.dart';

@immutable
abstract class VehiclesDetailState {
  const VehiclesDetailState();
}

class VehiclesDetailInitial extends VehiclesDetailState {}

class VehiclesDetailLoading extends VehiclesDetailState {}

class VehiclesDetailLoaded extends VehiclesDetailState {
  VehiclesDetailModel? vehiclesDetailModel;
  VehiclesDetailLoaded({this.vehiclesDetailModel});
}

class VehiclesDetailError extends VehiclesDetailState {
  final String? error;

  const VehiclesDetailError({this.error});
}
