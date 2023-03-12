import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/data/network/dio_client.dart';
import 'package:fleetmanagement/data/network/rest_client.dart';
import 'package:fleetmanagement/models/alarm_report/alarm_report_model.dart';

class ReportApi {
  //dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  ReportApi(this._dioClient, this._restClient);

  Future<AlarmReportModel> getTrackingHistoryAlarms(
      String license, String date, int page) async {
    final res = await _dioClient.get(
        '${Endpoints.trackingHistoryAlarmList}/$license',
        queryParameters: {'date': date, 'page': page});

    return AlarmReportModel.fromJson(res);
  }

  Future<AlarmReportModel> getAlarmReports(String type, int page) async {
    final res = await _dioClient.get('${Endpoints.reportAlarm}/$type',
        queryParameters: {'page': page});
    return AlarmReportModel.fromJson(res);
  }
}
