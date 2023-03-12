import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistant_data.dart';
import 'package:fleetmanagement/models/mng/driver_management/assistant/assistants.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/act_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/act/acts.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurance_data.dart';
import 'package:fleetmanagement/models/mng/insurance_management/insurance/insurances.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_types.dart';
import 'package:meta/meta.dart';


part 'sensor_type_event.dart';
part 'sensor_type_state.dart';

class SensorTypeBloc extends Bloc<SensorTypeEvent, SensorTypeState> {
  MngApi mngApi;

  SensorTypeBloc(this.mngApi) : super(SensorTypeInitial());

  @override
  Stream<SensorTypeState> mapEventToState(
      SensorTypeEvent event,
      ) async* {
    var currentState = state;

    if (event is SensorTypeLoading) {
      yield SensorTypeLoading();
    }

    if (event is GetSensorType) {
      try {
        int pageToFetch = 1;
        List<SensorTypeData> sensorsModel = [];

        if (currentState is SensorTypeInitial) {
          pageToFetch = 1;
          sensorsModel.clear();
        }

        if (currentState is SensorTypeLoaded) {
          pageToFetch = currentState.page! + 1;
          sensorsModel = currentState.sensorTypeData!;
        }

        print('PAGENO' + pageToFetch.toString());
        SensorTypes sensorTypes = await mngApi.getSensorsType();
        print("SENSOR_TYPE_LENGTH " + sensorTypes.data!.length.toString());

        bool hasReachMax = sensorTypes.meta!.currentPage! <= sensorTypes.meta!.lastPage! ? false : true;
        sensorsModel.addAll(sensorTypes.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield SensorTypeLoaded(
            sensorTypeData: sensorsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: sensorTypes.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield SensorTypeError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield SensorTypeError(error: error.message);
      } catch (error) {
        yield SensorTypeError(error: 'Something went wrong');
      }
    }
  }
}
