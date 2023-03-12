import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LiveLocationLinkState {
  const LiveLocationLinkState();
  @override
  List<Object> get props => [];
}


class FailedInternetConnection extends LiveLocationLinkState {}

class LiveLocationLinkInitial extends LiveLocationLinkState {}

class LiveLocationLinkLoading extends LiveLocationLinkState {
  List<TracksData>? oldPosts;
  bool? isFirstFetch;

  LiveLocationLinkLoading(this.oldPosts, {this.isFirstFetch = false});
}

class LiveLocationLinkLoaded extends LiveLocationLinkState {
  List<TracksData>? trackData;
  LatLng? coordinate;
  bool? hasReachedMax;
  int? page;

  LiveLocationLinkLoaded(
      {this.trackData, this.coordinate, this.hasReachedMax, this.page});

  @override
  String toString() =>
      'LiveLocationLinkLoaded { events: ${trackData?.length}, coordinate: $coordinate, loadNoMore: $hasReachedMax,  page: $page}';
}

class LiveLocationLinkError extends LiveLocationLinkState {
  final String? error;

  LiveLocationLinkError({this.error});
}
