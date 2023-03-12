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
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensors.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_type_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor_type/sensor_types.dart';
import 'package:meta/meta.dart';


part 'sensor_event.dart';
part 'sensor_state.dart';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  MngApi mngApi;

  SensorBloc(this.mngApi) : super(SensorInitial());

  @override
  Stream<SensorState> mapEventToState(
      SensorEvent event,
      ) async* {
    var currentState = state;

    if (event is SensorLoading) {
      yield SensorLoading();
    }

    if (event is GetSensor) {
      try {
        int pageToFetch = 1;
        List<SensorData> sensorsModel = [];

        if (currentState is SensorInitial) {
          pageToFetch = 1;
          sensorsModel.clear();
        }

        if (currentState is SensorLoaded) {
          pageToFetch = currentState.page! + 1;
          sensorsModel = currentState.sensorData!;
        }

        print('PAGENO' + pageToFetch.toString());
        Sensors sensors = await mngApi.getSensors();
        print("SENSOR_TYPE_LENGTH " + sensors.data!.length.toString());

        bool hasReachMax = sensors.meta!.currentPage! <= sensors.meta!.lastPage! ? false : true;
        sensorsModel.addAll(sensors.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield SensorLoaded(
            sensorData: sensorsModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: sensors.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield SensorError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield SensorError(error: error.message);
      } catch (error) {
        yield SensorError(error: 'Something went wrong');
      }
    }
  }
}
