part of 'driver_bloc.dart';

@immutable
abstract class DriverEvent {
  const DriverEvent();
}

class GetDriver extends DriverEvent {
  GetDriver();
}

class ShowDriverLoading extends DriverEvent {}

class RefreshDriver extends DriverEvent {
  RefreshDriver();
}
