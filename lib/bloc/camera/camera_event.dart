part of 'camera_bloc.dart';

@immutable
abstract class CameraEvent {
  const CameraEvent();
}

class GetCamera extends CameraEvent {
  String? license;
  GetCamera({this.license});
}

class ShowCameraLoading extends CameraEvent {}

class RefreshCamera extends CameraEvent {
  const RefreshCamera();
}
