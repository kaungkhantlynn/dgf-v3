
part of 'device_cubit.dart';

@immutable
abstract class DeviceState {}

class DeviceStateInitial extends DeviceState {}

class DeviceStateLoaded extends DeviceState {
  List<DeviceData>? deviceData;

  DeviceStateLoaded({this.deviceData});
}

class DeviceStateError extends DeviceState {}