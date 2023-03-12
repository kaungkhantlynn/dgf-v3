part of 'fuel_type_bloc.dart';

@immutable
abstract class FuelTypeEvent {
  const FuelTypeEvent();
}

class GetFuelType extends FuelTypeEvent {
  GetFuelType();
}

class ShowFuelTypeLoading extends FuelTypeEvent {}

class RefreshFuelType extends FuelTypeEvent {
  RefreshFuelType();
}
