import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistants.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/acts.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurances.dart';
import 'package:meta/meta.dart';


part 'insurance_event.dart';
part 'insurance_state.dart';

class InsuranceBloc extends Bloc<InsuranceEvent, InsuranceState> {
  MngApi mngApi;

  InsuranceBloc(this.mngApi) : super(InsuranceInitial());

  @override
  Stream<InsuranceState> mapEventToState(
      InsuranceEvent event,
      ) async* {
    var currentState = state;

    if (event is InsuranceLoading) {
      yield InsuranceLoading();
    }

    if (event is GetInsurance) {
      try {
        int pageToFetch = 1;
        List<InsuranceData> insurancesModel = [];

        if (currentState is InsuranceInitial) {
          pageToFetch = 1;
          insurancesModel.clear();
        }

        if (currentState is InsuranceLoaded) {
          pageToFetch = currentState.page! + 1;
          insurancesModel = currentState.insuranceData!;
        }

        print('PAGENO' + pageToFetch.toString());
        Insurances insurances = await mngApi.getInsurance();
        print("INSURANCE_LENGTH " + insurances.data!.length.toString());

        bool hasReachMax = insurances.meta!.currentPage! <= insurances.meta!.lastPage! ? false : true;
        insurancesModel.addAll(insurances.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield InsuranceLoaded(
            insuranceData: insurancesModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: insurances.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield InsuranceError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield InsuranceError(error: error.message);
      } catch (error) {
        yield InsuranceError(error: 'Something went wrong');
      }
    }
  }
}
