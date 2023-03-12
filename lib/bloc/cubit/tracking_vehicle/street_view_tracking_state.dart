import 'package:flutter_google_street_view/flutter_google_street_view.dart';

abstract class StreetViewTrackingState {}

class StreetViewTrackingInitial extends StreetViewTrackingState {}

class StreetViewTrackingLoad extends StreetViewTrackingState {
  final StreetViewController controller;

  StreetViewTrackingLoad(this.controller);
}

class StreetViewTrackingUpdate extends StreetViewTrackingState {
  StreetViewTrackingUpdate();
}
