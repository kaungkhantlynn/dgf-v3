import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_types.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicles.dart';
import 'package:meta/meta.dart';

import '../../../../../models/mng/vehicles_management/vehicles/vehicle_data.dart';


part 'vehicle_event.dart';
part 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  MngApi mngApi;

  VehicleBloc(this.mngApi) : super(VehicleInitial());

  @override
  Stream<VehicleState> mapEventToState(
      VehicleEvent event,
      ) async* {
    var currentState = state;

    if (event is ShowVehicleLoading) {
      yield VehicleLoading();
    }

    if (event is GetVehicle) {
      print("THIS IS GetVehicle");
      try {
        int pageToFetch = 1;
        List<VehicleData> vehiclesModel = [];

        if (currentState is VehicleInitial) {
          pageToFetch = 1;
          vehiclesModel.clear();
        }

        if (currentState is VehicleLoaded) {
          pageToFetch = currentState.page! + 1;
          vehiclesModel = currentState.vehicleData!;
        }

        print('PAGENO' + pageToFetch.toString());
        Vehicles vehicles = await mngApi.getVehicles();
        print("VEHICLESLENGTH " + vehicles.data!.length.toString());

        // bool hasReachMax = vehicles.meta!.currentPage! <= vehicles.meta!.lastPage! ? false : true;
        bool hasReachMax = true;
        vehiclesModel.addAll(vehicles.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield VehicleLoaded(
            vehicleData: vehiclesModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: vehicles.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield VehicleError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield VehicleError(error: error.message);
      } catch (error) {
        yield VehicleError(error: 'Something went wrong');
      }
    }
  }
}
