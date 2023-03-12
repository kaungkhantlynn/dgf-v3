import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/driver_repository.dart';

import 'package:fleetmanagement/models/driver/finished_job/finished_job_model.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuel_data.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel/fuels.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_types.dart';

import 'package:meta/meta.dart';

import '../../../../../models/mng/fuel_management/fuel_type/fuel_type_data.dart';
import '../../../../../ui/vehicle/fuel_management/fuel_type/fuel_type.dart';

part 'fuel_type_event.dart';
part 'fuel_type_state.dart';

class FuelTypeBloc extends Bloc<FuelTypeEvent, FuelTypeState> {
  MngApi mngApi;

  FuelTypeBloc(this.mngApi) : super(FuelTypeInitial());

  @override
  Stream<FuelTypeState> mapEventToState(
      FuelTypeEvent event,
      ) async* {
    var currentState = state;

    if (event is ShowFuelTypeLoading) {
      yield FuelTypeLoading();
    }

    if (event is GetFuelType) {
      try {
        int pageToFetch = 1;
        List<FuelTypeData> fuelsModel = [];

        if (currentState is FuelTypeInitial) {
          pageToFetch = 1;
          fuelsModel.clear();
        }

        if (currentState is FuelTypeLoaded) {
          pageToFetch = currentState.page! + 1;
          fuelsModel = currentState.fuelTypeDatas!;
        }

        print('PAGENO' + pageToFetch.toString());
        FuelTypes allFuelTypes =await mngApi.getFueltypes();
        print("FUEL_TYPE_LENGTH " + allFuelTypes.data!.length.toString());

        bool hasReachMax = allFuelTypes.meta!.currentPage! <= allFuelTypes.meta!.lastPage! ? false : true;
        fuelsModel.addAll(allFuelTypes.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield FuelTypeLoaded(
            fuelTypeDatas: fuelsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: allFuelTypes.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield FuelTypeError(error: error.message);
      }  on BadRequestException catch (error ) {
        yield FuelTypeError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield FuelTypeError(error: error.message);
      } catch (error) {
        yield FuelTypeError(error: 'Something went wrong');
      }
    }
  }
}
