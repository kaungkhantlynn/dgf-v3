import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:meta/meta.dart';

part 'save_finish_job_event.dart';
part 'save_finish_job_state.dart';

class SaveFinishJobBloc
    extends Bloc<SaveFinishJobEvent, SaveFinishJobState> {
 late DriverRepository driverRepository;

  SaveFinishJobBloc(this.driverRepository) : super(SaveFinishJobInitial());

  @override
  Stream<SaveFinishJobState> mapEventToState(
      SaveFinishJobEvent event,
      ) async* {

      if (event is SaveFinishJobPress){
        yield SaveFinishJobLoading();
        await Future.delayed(const Duration(seconds: 2));
        print("SAVESUBMIT");
        try {
          driverRepository.postFinishJob(event.id!, event.formData!);

          await Future.delayed(const Duration(seconds: 2));
          yield const SaveFinishJobDid();
          print('SAVEFINISHJOBXDID');
          //
          // yield const GoBackFromSaveFinishJob();
        } on OtherException catch (error) {
          print("OTHERERROR ${error.message}");
          yield SaveFinishJobError(error: error.message);
        }
        on InternalServerErrorException catch (error) {
              print('INTERNET_SERVER_ERROR ${error.message}');

              yield SaveFinishJobError(error: error.message);
            } catch (error) {
              print('SAVEFINISHJOBERROR $error');
              yield SaveFinishJobError(error: error.toString());
            }
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
  }



  @override
  // TODO: implement initialState
  SaveFinishJobState get initialState => SaveFinishJobInitial();
}
