part of 'start_job_bloc.dart';


@immutable
abstract class StartJobEvent {
  const StartJobEvent();
}

class StartJobPost extends StartJobEvent{
  int? id;
  StartJobPost({this.id});

  @override
  String toString() => 'StartJob ';
}