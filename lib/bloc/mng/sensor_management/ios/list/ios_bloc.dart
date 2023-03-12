import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/mng/mng_api.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensor_data.dart';
import 'package:fleetmanagement/models/mng/sensor_management/sensor/sensors.dart';

import 'ios_event.dart';
import 'ios_state.dart';

class IosBloc extends Bloc<IosEvent, IosState> {
  MngApi mngApi;

  IosBloc(this.mngApi) : super(IosInitial());

  @override
  Stream<IosState> mapEventToState(
      IosEvent event,
      ) async* {
    var currentState = state;

    if (event is IosLoading) {
      yield IosLoading();
    }

    if (event is GetIos) {
      try {
        int pageToFetch = 1;
        List<SensorData> IossModel = [];

        if (currentState is IosInitial) {
          pageToFetch = 1;
          IossModel.clear();
        }

        if (currentState is IosLoaded) {
          pageToFetch = currentState.page! + 1;
          IossModel = currentState.IosData!;
        }

        print('PAGENO' + pageToFetch.toString());
        Sensors Ioss = await mngApi.getSensors();
        print("Ios_TYPE_LENGTH " + Ioss.data!.length.toString());

        bool hasReachMax = Ioss.meta!.currentPage! <= Ioss.meta!.lastPage! ? false : true;
        IossModel.addAll(Ioss.data!);

        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield IosLoaded(
            IosData: IossModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax,
            success: Ioss.success);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield IosError(error: error.message);
      } on NoQueryResultException catch (error) {
        yield IosError(error: error.message);
      } catch (error) {
        yield IosError(error: 'Something went wrong');
      }
    }
  }
}
