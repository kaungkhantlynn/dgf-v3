import 'package:fleetmanagement/models/vehicles/vehicles_model.dart';

abstract class ClusterState {}

class ClusterInitial extends ClusterState {}

class ClusterCompleted extends ClusterState {
  final VehiclesModel coordinate;

  ClusterCompleted(this.coordinate);
}

class ClusterError extends ClusterState {
  final String message;

  ClusterError(this.message);
}
