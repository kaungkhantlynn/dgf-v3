import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_data.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
part 'vehicles_event.dart';
part 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  late TrackingRepository trackingRepository;

  // constructor:---------------------------------------------------------------
  // AuthenticationBloc() : super(AuthenticationUninitialized());

  VehiclesBloc(this.trackingRepository) : super(VehiclesInitial());
  @override
  // TODO: implement initialState
  VehiclesState get initialState => VehiclesInitial();

  @override
  Stream<VehiclesState> mapEventToState(
    VehiclesEvent event,
  ) async* {
    final currentState = state;
    if (event is GetVehicles) {
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        try {
          int pageToFetch = 1;
          List<VehiclesData> vehiclesModel = [];

          if (currentState is VehiclesLoaded) {
            // pageToFetch = currentState.page! + 1;
            vehiclesModel = currentState.vehicles!;
            print(vehiclesModel);
          }

          VehiclesModel allVehiclesModel = await trackingRepository.getVehicles();

          bool hasReachMax = true;
          vehiclesModel.addAll(allVehiclesModel.data!);

          yield VehiclesLoaded(
              vehicles: vehiclesModel,
              page: pageToFetch,
              hasReachedMax: hasReachMax);
        } on NoInternetConnectionException catch (error) {
          yield VehiclesInitial();
          yield VehiclesError(error: error.message);
        } on InternalServerErrorException catch (error) {
          yield VehiclesInitial();
          yield VehiclesError(error: error.message);
        } on UnauthorizedException catch (error) {
          yield VehiclesInitial();
          yield VehiclesError(error: error.message);
        } catch (e) {
          yield VehiclesError(error: e.toString());
        }
      }  else {
        yield FailedInternetConnection();
      }

    }
  }
}
