part of 'alarm_report_bloc.dart';

@immutable
abstract class AlarmReportState {
  const AlarmReportState();
  @override
  List<Object> get props => [];
}

class FailedInternetConnection extends AlarmReportState {}
class InitialAlarmReportState extends AlarmReportState {}

class AlarmReportLoading extends AlarmReportState {}

class AlarmReportLoaded extends AlarmReportState {
  List<AlarmReportData>? alarmReports;
  int? page;
  final bool? loadNoMore;

  AlarmReportLoaded({this.alarmReports, this.page, this.loadNoMore});

  @override
  String toString() =>
      'AlarmReportLoaded { events: ${alarmReports?.length}, loadNoMore: $loadNoMore }';
}

class AlarmReportError extends AlarmReportState {
  String message;

  AlarmReportError(this.message);
}
