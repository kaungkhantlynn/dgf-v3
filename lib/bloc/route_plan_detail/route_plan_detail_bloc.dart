import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/driver/route_plan_detail/route_plan_detail_model.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
part 'route_plan_detail_event.dart';
part 'route_plan_detail_state.dart';

class RoutePlanDetailBloc
    extends Bloc<RoutePlanDetailsEvent, RoutePlanDetailState> {
  DriverRepository driverRepository;

  RoutePlanDetailBloc(this.driverRepository) : super(RoutePlanDetailInitial());

  @override
  Stream<RoutePlanDetailState> mapEventToState(
    RoutePlanDetailsEvent event,
  ) async* {
    if (event is GetRoutePlanDetails) {
      yield* _mapEventSlugChange(event);
    }

    // if (event is FinishJob) {
    //   try {
    //     driverRepository.postFinishJob(event.id!);
    //     yield RoutePlanDetailInitial();
    //   } on InternalServerErrorException catch (error) {
    //     print('INTERNET_SERVER_ERROR ' + error.message);
    //     yield RoutePlanDetailInitial();
    //     yield RoutePlanDetailError(error: error.message);
    //   } catch (error) {
    //     print('ROUTEPLANDETAILERROR ' + error.toString());
    //     yield RoutePlanDetailError(error: error.toString());
    //   }
    // }

    if (event is StartJob) {
    print('PRess Start Job');
      // yield RoutePlanDetailInitial();

      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        try {
          driverRepository.postStartJob(event.id!);
          Future.delayed(Duration(seconds: 1));
          yield StartJobSuccess();
          print("STARTED FINISHED");
          Future.delayed(Duration(seconds: 13));
          // add(GetRoutePlanDetails(id:event.id!));


        } on InternalServerErrorException catch (error) {
          print('INTERNET_SERVER_ERROR ${error.message}');
          yield RoutePlanDetailInitial();
          yield RoutePlanDetailError(error: error.message);
        } catch (error) {
          print('ROUTEPLANDETAILERROR $error');
          yield RoutePlanDetailError(error: error.toString());
        }
      }  else {
          yield FailedInternetConnection();
      }


    }
  }

  Stream<RoutePlanDetailState> _mapEventSlugChange(
      GetRoutePlanDetails event) async* {
    yield RoutePlanDetailLoading();

    try {
      RoutePlanDetailModel routePlanDetailModel =
          await driverRepository.getRoutePlanDetail(event.id!);
      yield RoutePlanDetailLoaded(routePlanDetailModel: routePlanDetailModel);
      print('ROUTE_PLAN_DETAIL_LOADED');
    } catch (e) {
      print("ROUTE_PLAN_DETAIL_ERROR ${e.toString()}");
      yield RoutePlanDetailError(error: e.toString());
    }
  }

  @override
  // TODO: implement initialState
  RoutePlanDetailState get initialState => RoutePlanDetailInitial();
}
