import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_group_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_data.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'vehicle_filter_state.dart';
part 'vehicle_filter_event.dart';

class VehicleFilterBloc extends Bloc<VehicleFilterEvent, VehicleFilterState> {
  TrackingRepository trackingRepository;

  VehicleFilterBloc(this.trackingRepository) : super(VehicleFilterInitial());
  @override
  // TODO: implement initialState
  VehicleFilterState get initialState => VehicleFilterInitial();

  @override
  Stream<VehicleFilterState> mapEventToState(
    VehicleFilterEvent event,
  ) async* {
    final currentState = state;
    if (event is GetVehicleFilter) {
      bool isConnected = await InternetConnectionChecker().hasConnection;

     if (isConnected) {
       try {
         int pageToFetch = 1;
         List<VehicleSummaryData> vehicleFilterModel = [];
         List<VehicleGroupModel> vehicleGroupFilterModel = [];

         if (currentState is VehicleFilterLoaded) {
           // pageToFetch = currentState.page! + 1;
           vehicleFilterModel = currentState.vehiclesummarydatas!;
           vehicleGroupFilterModel = currentState.vehiclegroupdatas!;
           print(vehicleFilterModel);
         }

         VehicleSummaryModel allVehicleSummaryModel =
         await trackingRepository.getVehicleFilter();

         bool hasReachMax = true;
         vehicleFilterModel.addAll(allVehicleSummaryModel.summary!);
         vehicleGroupFilterModel.addAll(allVehicleSummaryModel.groups!);

         yield VehicleFilterLoaded(
             vehiclesummarydatas: vehicleFilterModel,
             vehiclegroupdatas: vehicleGroupFilterModel,
             page: pageToFetch,
             hasReachedMax: hasReachMax);
       } catch (e) {
         print("Division_EE$e");
         VehicleFilterError(error: e.toString());
       }
     }  else {
        yield FailedInternetConnection();
     }
    }
  }
}
