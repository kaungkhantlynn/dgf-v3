part of 'fuel_type_bloc.dart';

@immutable
abstract class FuelTypeState {
  const FuelTypeState();
}

class FuelTypeInitial extends FuelTypeState {}

class FuelTypeLoading extends FuelTypeState {}

class FuelTypeLoaded extends FuelTypeState {
  List<FuelTypeData>? fuelTypeDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  FuelTypeLoaded(
      {this.fuelTypeDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'FuelTypeLoaded { events: ${fuelTypeDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class FuelTypeError extends FuelTypeState {
  final String? error;

  FuelTypeError({this.error});
}
