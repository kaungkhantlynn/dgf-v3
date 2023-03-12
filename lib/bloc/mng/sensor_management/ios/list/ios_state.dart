import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';

// part of 'ios_bloc.dart';
//
// @immutable
abstract class IosState {
  const IosState();
}

class IosInitial extends IosState {}

class IosLoading extends IosState {}

class IosLoaded extends IosState {

  List<SensorData>? IosData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  IosLoaded({this.IosData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'IosLoaded { events: ${IosData!.length}, hasReachedMax: $hasReachedMax }';
}

class IosError extends IosState {
  final String? error;

  IosError({this.error});
}
