import 'package:fleetmanagement/models/tracking/track_data.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LiveVideoLinkState {
  const LiveVideoLinkState();
  @override
  List<Object> get props => [];
}


class FailedInternetConnection extends LiveVideoLinkState {}

class LiveVideoLinkInitial extends LiveVideoLinkState {}

class LiveVideoLinkLoading extends LiveVideoLinkState {
  List<TracksData>? oldPosts;
  bool? isFirstFetch;

  LiveVideoLinkLoading(this.oldPosts, {this.isFirstFetch = false});
}

class LiveVideoLinkLoaded extends LiveVideoLinkState {
  List<TracksData>? trackData;
  LatLng? coordinate;
  bool? hasReachedMax;
  int? page;

  LiveVideoLinkLoaded(
      {this.trackData, this.coordinate, this.hasReachedMax, this.page});

  @override
  String toString() =>
      'LiveVideoLinkLoaded { events: ${trackData?.length}, coordinate: $coordinate, loadNoMore: $hasReachedMax,  page: $page}';
}

class LiveVideoLinkError extends LiveVideoLinkState {
  final String? error;

  LiveVideoLinkError({this.error});
}
