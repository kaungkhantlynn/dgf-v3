import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/models/driver/finished_job/finished_job_data.dart';
import 'package:fleetmanagement/models/driver/finished_job/finished_job_model.dart';

import 'package:meta/meta.dart';

part 'finished_job_event.dart';
part 'finished_job_state.dart';

class FinishedJobBloc extends Bloc<FinishedJobEvent, FinishedJobState> {
  DriverRepository driverRepository;

  FinishedJobBloc(this.driverRepository) : super(FinishedJobInitial());

  @override
  Stream<FinishedJobState> mapEventToState(
    FinishedJobEvent event,
  ) async* {
    var currentState = state;

    if (event is ShowFinishedJobLoading) {
      yield FinishedJobLoading();
    }

    if (event is GetFinishedJob) {
      try {
        int pageToFetch = 1;
        List<FinishedJobData> finishedJobsModel = [];

        if (currentState is FinishedJobInitial) {
          pageToFetch = 1;
          finishedJobsModel.clear();
        }

        if (currentState is FinishedJobLoaded) {
          pageToFetch = currentState.page! + 1;
          finishedJobsModel = currentState.finishedJobDatas!;
        }

        print('PAGENO$pageToFetch');
        FinishedJobModel allFinishedJob =
            await driverRepository.getFinishedJobs();
        print("FINISHED_JOB_LENGTH ${allFinishedJob.data!.length}");

        // bool hasReachMax = allRoutePlan.meta!.currentPage! <= allalarmReportModel.meta!.lastPage! ? false : true;
        bool hasReachMax = true;

        print('FinishedJobLoaded Api');
        finishedJobsModel.addAll(allFinishedJob.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield FinishedJobLoaded(
            finishedJobDatas: finishedJobsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: allFinishedJob.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield FinishedJobError(error: error.message);
      } on BadRequestException catch (error ) {
        yield FinishedJobError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield FinishedJobError(error: error.message);
      } catch (error) {
        yield const FinishedJobError(error: 'Something went wrong');
      }
    }
  }
}
