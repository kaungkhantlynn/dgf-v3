import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
part 'start_job_event.dart';
part 'start_job_state.dart';

class StartJobBloc
    extends Bloc<StartJobEvent, StartJobStateState> {
  DriverRepository driverRepository;

  StartJobBloc(this.driverRepository) : super(StartJobInitial());



  @override
  Stream<StartJobStateState> mapEventToState(
      StartJobEvent event,
      ) async* {
    if (event is StartJobPost) {
      print('PRess Start Job');
      // yield RoutePlanDetailInitial();

      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        try {
          driverRepository.postStartJob(event.id!);
          Future.delayed(Duration(seconds: 1));
          yield StartJobCreated();
          print("STARTED FINISHED");
          Future.delayed(Duration(seconds: 13));
          // add(GetRoutePlanDetails(id:event.id!));


        } on InternalServerErrorException catch (error) {
          print('INTERNET_SERVER_ERROR ${error.message}');
          yield StartJobInitial();
          yield StartJobError(error: error.message);
        } catch (error) {
          print('ROUTEPLANDETAILERROR $error');
          yield StartJobError(error: error.toString());
        }
      }  else {
        yield FailedInternetConnectionStartJob();
      }


    }

  }



  @override
  // TODO: implement initialState
  StartJobStateState get initialState => StartJobInitial();
}
