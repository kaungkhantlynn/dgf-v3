part of 'alarm_report_bloc.dart';

@immutable
abstract class AlarmReportEvent {}

class ChangeAlarmReportKeyword extends AlarmReportEvent {
  ChangeAlarmReportKeyword();
}

class GetAlarmReportKeyword extends AlarmReportEvent {
  String? keyword;
  String? license;
  String? date;
  GetAlarmReportKeyword(this.keyword, this.license, this.date);
}

class RefreshAlarmReport extends AlarmReportEvent {
  RefreshAlarmReport();
}

class ShowAlarmReportLoading extends AlarmReportEvent {}

class ResetAlarmReportEvent extends AlarmReportEvent {
  AlarmReportModel alarmReportModel;
  int page;

  ResetAlarmReportEvent(this.alarmReportModel, this.page);
}
