import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LiveTrackingState {
  const LiveTrackingState();
  @override
  List<Object> get props => [];
}


class FailedInternetConnection extends LiveTrackingState {}

class LiveTrackingInitial extends LiveTrackingState {}

class LiveTrackingLoading extends LiveTrackingState {
  List<TracksData>? oldPosts;
  bool? isFirstFetch;

  LiveTrackingLoading(this.oldPosts, {this.isFirstFetch = false});
}

class LiveTrackingLoaded extends LiveTrackingState {
  List<TracksData>? trackData;
  LatLng? coordinate;
  bool? hasReachedMax;
  int? page;

  LiveTrackingLoaded(
      {this.trackData, this.coordinate, this.hasReachedMax, this.page});

  @override
  String toString() =>
      'LiveTrackingLoaded { events: ${trackData?.length}, coordinate: $coordinate, loadNoMore: $hasReachedMax,  page: $page}';
}

class LiveTrackingError extends LiveTrackingState {
  final String? error;

  LiveTrackingError({this.error});
}
