import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistants.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/acts.dart';
import 'package:meta/meta.dart';


part 'act_event.dart';
part 'act_state.dart';

class ActBloc extends Bloc<ActEvent, ActState> {
  MngApi mngApi;

  ActBloc(this.mngApi) : super(ActInitial());

  @override
  Stream<ActState> mapEventToState(
      ActEvent event,
      ) async* {
    var currentState = state;

    if (event is ActLoading) {
      yield ActLoading();
    }

    if (event is GetAct) {
      try {
        int pageToFetch = 1;
        List<ActData> actsModel = [];

        if (currentState is ActInitial) {
          pageToFetch = 1;
          actsModel.clear();
        }

        if (currentState is ActLoaded) {
          pageToFetch = currentState.page! + 1;
          actsModel = currentState.actDatas!;
        }

        print('PAGENO' + pageToFetch.toString());
        Acts acts = await mngApi.getActs();
        print("ACT_LENGTH " + acts.data!.length.toString());

        bool hasReachMax = acts.meta!.currentPage! <= acts.meta!.lastPage! ? false : true;
        actsModel.addAll(acts.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield ActLoaded(
            actDatas: actsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: acts.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield ActError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield ActError(error: error.message);
      } catch (error) {
        yield ActError(error: 'Something went wrong');
      }
    }
  }
}
