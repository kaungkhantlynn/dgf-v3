import 'package:fleetmanagement/data/network/api/report/report_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/alarm_report/alarm_report_model.dart';

class AlarmReportRepository {
  //api object
  final ReportApi _reportApi;

  //shared pref object
  final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  AlarmReportRepository(this._reportApi, this._sharedPreferenceHelper);

  Future<AlarmReportModel> getReports(
      {String? type, String? license, String? date, int? page}) {
    switch (type) {
      case 'parking':
        return _reportApi.getAlarmReports(type!, page!);
      case 'overspeed':
        return _reportApi.getAlarmReports(type!, page!);
      case 'tracking_history':
        return _reportApi.getTrackingHistoryAlarms(license!, date!, page!);
      default:
        {
          return _reportApi.getTrackingHistoryAlarms(license!, date!, page!);
        }
    }
  }
}
