part of 'sensor_type_bloc.dart';

@immutable
abstract class SensorTypeEvent {
  const SensorTypeEvent();
}

class GetSensorType extends SensorTypeEvent {
  GetSensorType();
}

class ShowSensorTypeLoading extends SensorTypeEvent {}

class RefreshSensorType extends SensorTypeEvent {
  RefreshSensorType();
}
