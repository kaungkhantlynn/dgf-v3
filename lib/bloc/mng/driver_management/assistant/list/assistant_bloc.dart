import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistants.dart';
import 'package:fleetmanagement/models/mng/fuel_management/fuel_type/fuel_types.dart';
import 'package:meta/meta.dart';
import '../../../../../models/mng/fuel_management/fuel_type/fuel_type_data.dart';

part 'assistant_event.dart';
part 'assistant_state.dart';

class AssistantBloc extends Bloc<AssistantEvent, AssistantState> {
  MngApi mngApi;

  AssistantBloc(this.mngApi) : super(AssistantInitial());



  @override
  Stream<AssistantState> mapEventToState(
      AssistantEvent event,
      ) async* {
    yield AssistantLoading();
    var currentState = state;

    if (event is RefreshAssistant) {
      print('THIS IS REFRESH ASSISTANT');
      yield AssistantInitial();
    await  Future.delayed(Duration(seconds: 2));
      add(GetAssistant());

    }
    if (event is AssistantLoading) {
      yield AssistantLoading();
    }

    if (event is GetAssistant) {
      try {
        int pageToFetch = 1;
        List<AssistantData> assistantsModel = [];

        if (currentState is AssistantInitial) {
          pageToFetch = 1;
          assistantsModel.clear();
        }

        if (currentState is AssistantLoaded) {
          pageToFetch = currentState.page! + 1;
          assistantsModel = currentState.assistantDatas!;
        }

        print('PAGENO' + pageToFetch.toString());
        Assistants assistants =await mngApi.getAssistants();
        print("ASSISTANT_LENGTH " + assistants.data!.length.toString());

        bool hasReachMax = assistants.meta!.currentPage! <= assistants.meta!.lastPage! ? false : true;
        assistantsModel.addAll(assistants.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield AssistantLoaded(
            assistantDatas: assistantsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: assistants.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        print(error.message);
        yield AssistantError(error: error.message);

      } on BadRequestException catch (error ) {
        yield AssistantError(error: error.message);
      } on NoQueryResultException catch (error) {
        print(error.message);
        yield AssistantError(error: error.message);
      } catch (error) {
        print(error.toString());
        yield AssistantError(error: 'Something went wrong');
      }
    }
  }
}
