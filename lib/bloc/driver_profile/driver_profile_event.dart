part of 'driver_profile_bloc.dart';

@immutable
abstract class DriverProfileEvent {
  const DriverProfileEvent();
}

class GetDriverProfile extends DriverProfileEvent {
  const GetDriverProfile();
}

class ShowVehiclesDetailsLoading extends DriverProfileEvent {}

class RefreshVehiclesDetails extends DriverProfileEvent {
  const RefreshVehiclesDetails();
}

class ResetVehiclesDetails extends DriverProfileEvent {
  const ResetVehiclesDetails();
}
