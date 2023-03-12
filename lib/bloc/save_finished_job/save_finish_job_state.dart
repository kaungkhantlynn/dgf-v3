part of 'save_finish_job_bloc.dart';



@immutable
abstract class SaveFinishJobState {
  const SaveFinishJobState();
}

class SaveFinishJobInitial extends SaveFinishJobState {}

class SaveFinishJobLoading extends SaveFinishJobState {}

class SaveFinishJobDid extends SaveFinishJobState {

  const SaveFinishJobDid();
}

class GoBackFromSaveFinishJob extends SaveFinishJobState {
  const GoBackFromSaveFinishJob();
}

class SaveFinishJobError extends SaveFinishJobState {
  final String? error;

  const SaveFinishJobError({this.error});
}
