import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/driver_management/driver/drivers.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_types.dart';

import 'package:meta/meta.dart';

import '../../../../../models/mng/driver_management/driver/driver_data.dart';
import '../../../../../models/mng/fuel_management/fuel_type/fuel_type_data.dart';

part 'driver_event.dart';
part 'driver_state.dart';

class DriverBloc extends Bloc<DriverEvent, DriverState> {
  MngApi mngApi;

  DriverBloc(this.mngApi) : super(DriverInitial());

  @override
  Stream<DriverState> mapEventToState(
      DriverEvent event,
      ) async* {
    var currentState = state;

    if (event is ShowDriverLoading) {
      yield DriverLoading();
    }

    if (event is GetDriver) {
      try {
        int pageToFetch = 1;
        List<DriverData> driversModel = [];

        if (currentState is DriverInitial) {
          pageToFetch = 1;
          driversModel.clear();
        }

        if (currentState is DriverLoaded) {
          pageToFetch = currentState.page! + 1;
          driversModel = currentState.driverDatas!;
        }

        print('PAGENO' + pageToFetch.toString());
        Drivers allDrivers =await mngApi.getDrivers();
        print("Driver_LENGTH " + allDrivers.data!.length.toString());

        bool hasReachMax = allDrivers.meta!.currentPage! <= allDrivers.meta!.lastPage! ? false : true;


        driversModel.addAll(allDrivers.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield DriverLoaded(
            driverDatas: driversModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: allDrivers.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield DriverError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield DriverError(error: error.message);
      } catch (error) {
        yield DriverError(error: 'Something went wrong');
      }
    }
  }
}
