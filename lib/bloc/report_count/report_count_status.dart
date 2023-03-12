
part of 'report_count_cubit.dart';

@immutable
abstract class ReportCountState {}

class ReportCountInitial extends ReportCountState {}

class ReportCountLoaded extends ReportCountState {
  ReportCount? deviceData;

  ReportCountLoaded({this.deviceData});
}

class ReportCountError extends ReportCountState {}