import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/other/other_api.dart';
import 'package:fleetmanagement/models/device_status.dart';
import 'package:meta/meta.dart';

part 'device_state.dart';

class DeviceCubit extends Cubit<DeviceState> {

  final OtherApi _otherApi;

  DeviceCubit(this._otherApi,
      ) : super(DeviceStateInitial());


  Future<void> loadChart() async {
    try {
      var response = await _otherApi.getDeviceStatus();
      print('GDSUCCESS');
      emitLoadedData(response.data!);
    }catch (error){
      print('GDERROR ${error.toString()}');
      emitError();
    }
  }


  void emitLoading() => emit(DeviceStateInitial());
  void emitLoadedData(List<DeviceData>? deviceData) => emit(DeviceStateLoaded(deviceData: deviceData));
  void emitError() => emit(DeviceStateError());
}