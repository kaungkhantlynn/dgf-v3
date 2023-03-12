import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_types.dart';
import 'package:meta/meta.dart';


part 'vehicle_type_event.dart';
part 'vehicle_type_state.dart';

class VehicleTypeBloc extends Bloc<VehicleTypeEvent, VehicleTypeState> {
  MngApi mngApi;

  VehicleTypeBloc(this.mngApi) : super(VehicleTypeInitial());

  @override
  Stream<VehicleTypeState> mapEventToState(
      VehicleTypeEvent event,
      ) async* {
    var currentState = state;

    if (event is ShowVehicleTypeLoading) {
      yield VehicleTypeLoading();
    }

    if (event is GetVehicleType) {
      try {
        int pageToFetch = 1;
        List<VehicleTypeData> vehiclesModel = [];

        if (currentState is VehicleTypeInitial) {
          pageToFetch = 1;
          vehiclesModel.clear();
        }

        if (currentState is VehicleTypeLoaded) {
          pageToFetch = currentState.page! + 1;
          vehiclesModel = currentState.vehicleTypeData!;
        }

        print('PAGENO' + pageToFetch.toString());
        VehicleTypes vehicleTypes = await mngApi.getVehicleType();
        print("VEHICLES_TYPE_LENGTH " + vehicleTypes.data!.length.toString());

        bool hasReachMax = vehicleTypes.meta!.currentPage! <= vehicleTypes.meta!.lastPage! ? false : true;
        vehiclesModel.addAll(vehicleTypes.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield VehicleTypeLoaded(
            vehicleTypeData: vehiclesModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: vehicleTypes.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield VehicleTypeError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield VehicleTypeError(error: error.message);
      } catch (error) {
        yield VehicleTypeError(error: 'Something went wrong');
      }
    }
  }
}
