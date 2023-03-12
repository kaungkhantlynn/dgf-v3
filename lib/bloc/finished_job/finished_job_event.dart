part of 'finished_job_bloc.dart';

@immutable
abstract class FinishedJobEvent {
  const FinishedJobEvent();
}

class GetFinishedJob extends FinishedJobEvent {
  const GetFinishedJob();
}

class ShowFinishedJobLoading extends FinishedJobEvent {}

class RefreshFinishedJob extends FinishedJobEvent {
  const RefreshFinishedJob();
}
