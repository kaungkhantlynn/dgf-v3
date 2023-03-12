part of 'act_bloc.dart';

@immutable
abstract class ActState {
  const ActState();
}

class ActInitial extends ActState {}

class ActLoading extends ActState {}

class ActLoaded extends ActState {

  List<ActData>? actDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  ActLoaded(
      {this.actDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'AsssitantLoaded { events: ${actDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class ActError extends ActState {
  final String? error;

  ActError({this.error});
}
