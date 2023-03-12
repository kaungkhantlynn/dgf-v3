part of 'start_job_bloc.dart';

@immutable
abstract class StartJobStateState {
  const StartJobStateState();
}
class FailedInternetConnectionStartJob extends StartJobStateState {}
class StartJobInitial extends StartJobStateState {}
class StartJobCreated extends StartJobStateState{

}
class StartJobPosting extends StartJobStateState {}


class StartJobError extends StartJobStateState {
  final String? error;

  const StartJobError({this.error});
}
