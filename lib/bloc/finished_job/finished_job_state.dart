part of 'finished_job_bloc.dart';

@immutable
abstract class FinishedJobState {
  const FinishedJobState();
}

class FinishedJobInitial extends FinishedJobState {}

class FinishedJobLoading extends FinishedJobState {}

class FinishedJobLoaded extends FinishedJobState {
  List<FinishedJobData>? finishedJobDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  FinishedJobLoaded(
      {this.finishedJobDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'FinishedJobLoaded { events: ${finishedJobDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class FinishedJobError extends FinishedJobState {
  final String? error;

  const FinishedJobError({this.error});
}
