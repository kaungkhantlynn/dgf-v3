part of 'vehicles_bloc.dart';

@immutable
abstract class VehiclesState {
  const VehiclesState();
}

class FailedInternetConnection extends VehiclesState {}

class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesLoaded extends VehiclesState {
  List<VehiclesData>? vehicles;
  int? page;
  bool? hasReachedMax;

  VehiclesLoaded({this.vehicles, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'VehiclesLoaded { events: ${vehicles!.length}, hasReachedMax: $hasReachedMax }';
}

class VehiclesError extends VehiclesState {
  final String? error;

  const VehiclesError({this.error});
}
