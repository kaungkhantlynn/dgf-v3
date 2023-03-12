import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@immutable
abstract class LineTrackingHistoryState {}

class LineTrackingHistoryStateInitial extends LineTrackingHistoryState {}

class LineTrackingHistoryStateLoad extends LineTrackingHistoryState {
  final GoogleMapController controller;

  LineTrackingHistoryStateLoad(this.controller);
}

// class MapsMarkerChange extends LineTrackingHistoryState {
//   MapsMarkerChange(GoogleMapController controller, int currentIndex)
//       : super(controller, currentIndex);
//
//   @override
//   List<Object> get props => [currentIndex];
// }

class LineTrackingHistoryStateMarkers extends LineTrackingHistoryState {
  final List<Marker> markers;

  LineTrackingHistoryStateMarkers(this.markers);
}
