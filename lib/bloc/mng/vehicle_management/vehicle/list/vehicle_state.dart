part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleState {
  const VehicleState();
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {

  List<VehicleData>? vehicleData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  VehicleLoaded({this.vehicleData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'VehicleLoaded { events: ${vehicleData!.length}, hasReachedMax: $hasReachedMax }';
}

class VehicleError extends VehicleState {
  final String? error;

  VehicleError({this.error});
}
