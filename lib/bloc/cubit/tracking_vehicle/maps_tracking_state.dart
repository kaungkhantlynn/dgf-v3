import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapsTrackingState {}

class MapsTrackingInitial extends MapsTrackingState {}

class MapsTrackingLoad extends MapsTrackingState {
  final GoogleMapController controller;

  MapsTrackingLoad(this.controller);
}

class MapsTrackingUpdate extends MapsTrackingState {
  final Set<Marker> mapMarkers;
  MapsTrackingUpdate(this.mapMarkers);
}
