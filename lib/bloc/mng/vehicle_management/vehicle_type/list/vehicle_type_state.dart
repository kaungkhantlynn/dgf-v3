part of 'vehicle_type_bloc.dart';

@immutable
abstract class VehicleTypeState {
  const VehicleTypeState();
}

class VehicleTypeInitial extends VehicleTypeState {}

class VehicleTypeLoading extends VehicleTypeState {}

class VehicleTypeLoaded extends VehicleTypeState {

  List<VehicleTypeData>? vehicleTypeData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  VehicleTypeLoaded({this.vehicleTypeData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'VehicleTypeLoaded { events: ${vehicleTypeData!.length}, hasReachedMax: $hasReachedMax }';
}

class VehicleTypeError extends VehicleTypeState {
  final String? error;

  VehicleTypeError({this.error});
}
