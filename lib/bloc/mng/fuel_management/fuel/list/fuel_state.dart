part of 'fuel_bloc.dart';

@immutable
abstract class FuelState {
  const FuelState();
}

class FuelInitial extends FuelState {}

class FuelLoading extends FuelState {}

class FuelLoaded extends FuelState {
  List<FuelData>? fuelDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  FuelLoaded(
      {this.fuelDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'FuelLoaded { events: ${fuelDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class FuelError extends FuelState {
  final String? error;

  FuelError({this.error});
}
