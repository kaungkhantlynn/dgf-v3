import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/tracker_management/device_data.dart';
import 'package:fleetmanagement/models/mng/tracker_management/devices.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_type_data.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicle_type/vehicle_types.dart';
import 'package:fleetmanagement/models/mng/vehicles_management/vehicles/vehicles.dart';
import 'package:meta/meta.dart';

import '../../../../../models/mng/vehicles_management/vehicles/vehicle_data.dart';


part 'tracker_event.dart';
part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  MngApi mngApi;

  TrackerBloc(this.mngApi) : super(TrackerInitial());

  @override
  Stream<TrackerState> mapEventToState(
      TrackerEvent event,
      ) async* {
    var currentState = state;

    if (event is ShowTrackerLoading) {
      yield TrackerLoading();
    }

    if (event is GetTracker) {
      try {
        int pageToFetch = 1;
        List<DeviceData> devicesModel = [];

        if (currentState is TrackerInitial) {
          pageToFetch = 1;
          devicesModel.clear();
        }

        if (currentState is TrackerLoaded) {
          pageToFetch = currentState.page! + 1;
          devicesModel = currentState.deviceData!;
        }

        print('PAGENO' + pageToFetch.toString());
        Devices devices = await mngApi.getDevices();
        print("VEHICLESLENGTH " + devices.data!.length.toString());

        bool hasReachMax = devices.meta!.currentPage! <= devices.meta!.lastPage! ? false : true;
        devicesModel.addAll(devices.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield TrackerLoaded(
            deviceData: devicesModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: devices.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield TrackerError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield TrackerError(error: error.message);
      } catch (error) {
        yield TrackerError(error: 'Something went wrong');
      }
    }
  }
}
