part of 'sensor_bloc.dart';

@immutable
abstract class SensorEvent {
  const SensorEvent();
}

class GetSensor extends SensorEvent {
  GetSensor();
}

class ShowSensorLoading extends SensorEvent {}

class RefreshSensor extends SensorEvent {
  RefreshSensor();
}
