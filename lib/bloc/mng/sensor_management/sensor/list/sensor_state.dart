part of 'sensor_bloc.dart';

@immutable
abstract class SensorState {
  const SensorState();
}

class SensorInitial extends SensorState {}

class SensorLoading extends SensorState {}

class SensorLoaded extends SensorState {

  List<SensorData>? sensorData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  SensorLoaded({this.sensorData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'SensorLoaded { events: ${sensorData!.length}, hasReachedMax: $hasReachedMax }';
}

class SensorError extends SensorState {
  final String? error;

  SensorError({this.error});
}
