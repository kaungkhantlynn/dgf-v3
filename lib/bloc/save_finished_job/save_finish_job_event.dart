part of 'save_finish_job_bloc.dart';


@immutable
abstract class SaveFinishJobEvent {
  const SaveFinishJobEvent();
}



class SaveFinishJobPress extends SaveFinishJobEvent {
  int? id;
  FormData? formData;
  SaveFinishJobPress({this.id,this.formData});

  @override
  String toString() => 'FinishJob ';
}

class ShowFinishJobLoading extends SaveFinishJobEvent {}

