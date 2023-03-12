import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/api/other/other_api.dart';
import 'package:fleetmanagement/models/report_count.dart';
import 'package:meta/meta.dart';

part 'report_count_status.dart';

class ReportCountCubit extends Cubit<ReportCountState> {

  final OtherApi _otherApi;

  ReportCountCubit(this._otherApi,
      ) : super(ReportCountInitial());


  Future<void> reportCount(String keyword) async {
    try {
      var response = await _otherApi.getReportCount(keyword);
      print('RPCOUNTSUCCESS');
      emitLoadedData(response);
    }catch (error){
      print('RPCOUNTERROR ${error.toString()}');
      emitError();
    }
  }


  void emitLoading() => emit(ReportCountInitial());
  void emitLoadedData(ReportCount deviceData) => emit(ReportCountLoaded(deviceData: deviceData));
  void emitError() => emit(ReportCountError());
}