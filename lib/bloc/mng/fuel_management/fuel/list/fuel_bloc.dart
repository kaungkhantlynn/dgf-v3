import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/driver_repository.dart';

import 'package:fleetmanagement/models/driver/finished_job/finished_job_model.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuels.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_types.dart';

import 'package:meta/meta.dart';

part 'fuel_event.dart';
part 'fuel_state.dart';

class FuelBloc extends Bloc<FuelEvent, FuelState> {
  MngApi mngApi;

  FuelBloc(this.mngApi) : super(FuelInitial());

  @override
  Stream<FuelState> mapEventToState(
      FuelEvent event,
      ) async* {
    var currentState = state;

    if (event is ShowFuelLoading) {
      yield FuelLoading();
    }

    if (event is GetFuel) {
      try {
        int pageToFetch = 1;
        List<FuelData> fuelsModel = [];

        if (currentState is FuelInitial) {
          pageToFetch = 1;
          fuelsModel.clear();
        }

        if (currentState is FuelLoaded) {
          pageToFetch = currentState.page! + 1;
          fuelsModel = currentState.fuelDatas!;
        }

        print('PAGENO' + pageToFetch.toString());
        Fuel allFinishedJob =await mngApi.getFuels();
        print("FUEL_LENGTH " + allFinishedJob.data!.length.toString());

        // bool hasReachMax = allRoutePlan.meta!.currentPage! <= allalarmReportModel.meta!.lastPage! ? false : true;
        bool hasReachMax = true;

        fuelsModel.addAll(allFinishedJob.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield FuelLoaded(
            fuelDatas: fuelsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: allFinishedJob.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield FuelError(error: error.message);
      }
      on BadRequestException catch (error ) {
        yield FuelError(error: error.message);
      }on NoQueryResultException catch (error) {
        yield FuelError(error: error.message);
      } catch (error) {
        yield FuelError(error: 'Something went wrong');
      }
    }
  }
}
