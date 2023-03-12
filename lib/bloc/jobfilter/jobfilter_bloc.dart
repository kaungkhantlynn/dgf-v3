import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/models/driver/routeplan/route_plan_data.dart';
import 'package:fleetmanagement/models/driver/routeplan/route_plan_model.dart';
import 'package:meta/meta.dart';

part 'jobfilter_event.dart';
part 'jobfilter_state.dart';

class JobFilterBloc extends Bloc<JobFilterEvent, JobFilterState> {
  DriverRepository driverRepository;

  JobFilterBloc(this.driverRepository) : super(JobFilterInitial());
  @override
  // TODO: implement initialState
  JobFilterState get initialState => JobFilterInitial();

  @override
  Stream<JobFilterState> mapEventToState(
    JobFilterEvent event,
  ) async* {
    final currentState = state;
    if (event is GetJobFilter) {
      try {
        int pageToFetch = 1;
        List<RoutePlanData> routePlanModel = [];

        if (currentState is JobFilterLoaded) {
          // pageToFetch = currentState.page! + 1;
          routePlanModel = currentState.routePlanData!;
          print(routePlanModel);
        }

        RoutePlan allRouteModel =
            await driverRepository.getRoutePlanByDate(event.date!);

        bool hasReachMax = true;
        routePlanModel.addAll(allRouteModel.data!);

        yield JobFilterLoaded(
            routePlanData: routePlanModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax);
      } catch (e) {
        print("JOBFILTERERROR$e");
        JobFilterError(error: e.toString());
      }
    }
  }
}
