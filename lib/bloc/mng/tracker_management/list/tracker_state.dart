part of 'tracker_bloc.dart';

@immutable
abstract class TrackerState {
  const TrackerState();
}

class TrackerInitial extends TrackerState {}

class TrackerLoading extends TrackerState {}

class TrackerLoaded extends TrackerState {

  List<DeviceData>? deviceData;
  int? page;
  bool? hasReachedMax;
  bool? success;


  TrackerLoaded({this.deviceData, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'DeviceLoaded { events: ${deviceData!.length}, hasReachedMax: $hasReachedMax }';
}

class TrackerError extends TrackerState {
  final String? error;

  TrackerError({this.error});
}
