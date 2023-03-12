import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/models/driver/routeplan/route_plan_data.dart';
import 'package:fleetmanagement/models/driver/routeplan/route_plan_model.dart';
import 'package:meta/meta.dart';

part 'route_plan_event.dart';
part 'route_plan_state.dart';

class RoutePlanBloc extends Bloc<RoutePlanEvent, RoutePlanState> {
  DriverRepository driverRepository;

  RoutePlanBloc(this.driverRepository) : super(RoutePlanInitial());

  @override
  Stream<RoutePlanState> mapEventToState(
    RoutePlanEvent event,
  ) async* {
    var currentState = state;

    if (event is ShowRoutePlanLoading) {
      yield RoutePlanLoading();
    }

    if (event is GetRoutePlan) {
      try {
        int pageToFetch = 1;
        List<RoutePlanData> routePlanModel = [];

        if (currentState is RoutePlanInitial) {
          pageToFetch = 1;
          routePlanModel.clear();
        }

        if (currentState is RoutePlanLoaded) {
          pageToFetch = currentState.page! + 1;
          routePlanModel = currentState.routePlanDatas!;
        }

        print('PAGENO$pageToFetch');
        RoutePlan allRoutePlan = await driverRepository.getRoutePlan();
        print("ROUTE_PLAN_LENGTH ${allRoutePlan.data!.length}");

        // bool hasReachMax = allRoutePlan.meta!.currentPage! <= allalarmReportModel.meta!.lastPage! ? false : true;
        bool hasReachMax = true;

        routePlanModel.addAll(allRoutePlan.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield RoutePlanLoaded(
            routePlanDatas: routePlanModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: allRoutePlan.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield RoutePlanError(error: error.message);
      }
    }
  }
}
