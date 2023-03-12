part of 'driver_profile_bloc.dart';

@immutable
abstract class DriverProfileState {
  const DriverProfileState();
}

class DriverProfileInitial extends DriverProfileState {}

class DriverProfileLoading extends DriverProfileState {}

class DriverProfileLoaded extends DriverProfileState {
  DriverProfileModel? driverProfileModel;
  DriverProfileLoaded({this.driverProfileModel});
}

class DriverProfileError extends DriverProfileState {
  final String? error;

  const DriverProfileError({this.error});
}
