part of 'vehicle_filter_bloc.dart';

@immutable
abstract class VehicleFilterState {
  const VehicleFilterState();
}

class FailedInternetConnection extends VehicleFilterState {}
class VehicleFilterInitial extends VehicleFilterState {}

class VehicleFilterLoading extends VehicleFilterState {}

class VehicleFilterLoaded extends VehicleFilterState {
  List<VehicleSummaryData>? vehiclesummarydatas;
  List<VehicleGroupModel>? vehiclegroupdatas;

  int? page;
  bool? hasReachedMax;

  VehicleFilterLoaded(
      {this.vehiclesummarydatas,this.vehiclegroupdatas, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'VehicleFilterLoaded { events: ${vehiclesummarydatas!.length}, hasReachedMax: $hasReachedMax }';
}

class VehicleFilterError extends VehicleFilterState {
  final String? error;

  const VehicleFilterError({this.error});
}
