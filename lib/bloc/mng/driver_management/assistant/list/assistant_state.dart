part of 'assistant_bloc.dart';

@immutable
abstract class AssistantState {
  const AssistantState();
}

class AssistantInitial extends AssistantState {}

class AssistantLoading extends AssistantState {}

class AssistantLoaded extends AssistantState {

  List<AssistantData>? assistantDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  AssistantLoaded(
      {this.assistantDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'AsssitantLoaded { events: ${assistantDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class AssistantError extends AssistantState {
  final String? error;

  AssistantError({this.error});
}
