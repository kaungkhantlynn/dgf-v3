part of 'camera_bloc.dart';

@immutable
abstract class CameraState {
  const CameraState();
}

class FailedInternetConnection extends CameraState {}

class CameraInitial extends CameraState {}

class CameraLoading extends CameraState {}

class CameraLoaded extends CameraState {
  List<CameraData>? cameraDatas;
  int? page;
  bool? hasReachedMax;

  CameraLoaded({this.cameraDatas, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'CameraLoaded { events: ${cameraDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class CameraError extends CameraState {
  final String? error;

  const CameraError({this.error});
}
