part of 'jobfilter_bloc.dart';

@immutable
abstract class JobFilterEvent {
  const JobFilterEvent();
}

class GetJobFilter extends JobFilterEvent {
  String? date;
  GetJobFilter({this.date});
}

class ShowGetJobFilterLoading extends JobFilterEvent {}

class RefreshGetJobFilter extends JobFilterEvent {
  const RefreshGetJobFilter();
}
