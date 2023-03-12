import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';
import 'package:meta/meta.dart';
part 'vehicles_details_event.dart';
part 'vehicles_detail_state.dart';

class VehiclesDetailBloc
    extends Bloc<VehiclesDetailsEvent, VehiclesDetailState> {
  TrackingRepository trackingRepository;

  VehiclesDetailBloc(this.trackingRepository) : super(VehiclesDetailInitial());

  @override
  Stream<VehiclesDetailState> mapEventToState(
    VehiclesDetailsEvent event,
  ) async* {
    if (event is GetVehiclesDetails) {
      yield* _mapEventSlugChange(event);
    }
  }

  Stream<VehiclesDetailState> _mapEventSlugChange(
      GetVehiclesDetails event) async* {
    yield VehiclesDetailLoading();

    try {
      VehiclesDetailModel vehiclesDetailModel = await trackingRepository
          .getVehiclesDetail(event.license!, event.status!);
      yield VehiclesDetailLoaded(vehiclesDetailModel: vehiclesDetailModel);
      print('VEHICLEDETAIL LOADED');
    } catch (e) {
      print("VEHICLEDETAILERROR ${e.toString()}");
      yield VehiclesDetailError(error: e.toString());
    }
  }

  @override
  // TODO: implement initialState
  VehiclesDetailState get initialState => VehiclesDetailInitial();
}
