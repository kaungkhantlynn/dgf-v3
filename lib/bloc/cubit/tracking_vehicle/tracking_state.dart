import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';

abstract class TrackingState {}

class TrackingInitial extends TrackingState {}

class TrackingCompleted extends TrackingState {
  final VehiclesDetailModel vehiclesDetailModel;

  TrackingCompleted(this.vehiclesDetailModel);
}

class TrackingError extends TrackingState {
  final String message;

  TrackingError(this.message);
}
