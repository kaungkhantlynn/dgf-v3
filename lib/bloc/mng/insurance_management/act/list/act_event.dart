part of 'act_bloc.dart';

@immutable
abstract class ActEvent {
  const ActEvent();
}

class GetAct extends ActEvent {
  GetAct();
}

class ShowActLoading extends ActEvent {}

class RefreshAct extends ActEvent {
  RefreshAct();
}
