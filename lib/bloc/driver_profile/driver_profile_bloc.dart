import 'dart:async';

import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/driver/driver_profile/driver_profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'driver_profile_event.dart';
part 'driver_profile_state.dart';

class DriverProfileBloc extends Bloc<DriverProfileEvent, DriverProfileState> {
  DriverRepository driverRepository;

  DriverProfileBloc(this.driverRepository) : super(DriverProfileInitial());

  @override
  Stream<DriverProfileState> mapEventToState(
    DriverProfileEvent event,
  ) async* {
    if (event is GetDriverProfile) {
      try {
        DriverProfileModel driverProfileModel =
            await driverRepository.getProfile();
        yield DriverProfileLoaded(driverProfileModel: driverProfileModel);
      } on NoInternetConnectionException catch (error) {
        yield DriverProfileError(error: error.message);
      } on BadRequestException catch (error ) {
        yield DriverProfileError(error: error.message);
      }on InternalServerErrorException catch (error) {
        yield DriverProfileError(error: error.message);
      } on UnauthorizedException catch (error) {
        yield DriverProfileError(error: error.message);
      } catch (e) {
        print("error msg ${e.toString()}");
        yield DriverProfileError(error: e.toString());
      }
    }
  }
}
