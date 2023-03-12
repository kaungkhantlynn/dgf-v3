part of 'sensor_type_bloc.dart';

@immutable
abstract class SensorTypeState {
  const SensorTypeState();
}

class SensorTypeInitial extends SensorTypeState {}

class SensorTypeLoading extends SensorTypeState {}

class SensorTypeLoaded extends SensorTypeState {

  List<SensorTypeData>? sensorTypeData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  SensorTypeLoaded({this.sensorTypeData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'SensorTypeLoaded { events: ${sensorTypeData!.length}, hasReachedMax: $hasReachedMax }';
}

class SensorTypeError extends SensorTypeState {
  final String? error;

  SensorTypeError({this.error});
}
