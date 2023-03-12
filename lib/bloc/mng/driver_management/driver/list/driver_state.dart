part of 'driver_bloc.dart';

@immutable
abstract class DriverState {
  const DriverState();
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverLoaded extends DriverState {
  List<DriverData>? driverDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  DriverLoaded(
      {this.driverDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'DriverLoaded { events: ${driverDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class DriverError extends DriverState {
  final String? error;

  DriverError({this.error});
}
