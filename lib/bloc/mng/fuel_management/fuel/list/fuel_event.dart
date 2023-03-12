part of 'fuel_bloc.dart';

@immutable
abstract class FuelEvent {
  const FuelEvent();
}

class GetFuel extends FuelEvent {
  GetFuel();
}

class ShowFuelLoading extends FuelEvent {}

class RefreshFuel extends FuelEvent {
  RefreshFuel();
}
