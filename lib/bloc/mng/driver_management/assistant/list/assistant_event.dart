part of 'assistant_bloc.dart';

@immutable
abstract class AssistantEvent {
  const AssistantEvent();
}

class GetAssistant extends AssistantEvent {
  GetAssistant();
}

class ReloadAssistant extends AssistantEvent {
  ReloadAssistant();
}

class ShowAssistantLoading extends AssistantEvent {}

class RefreshAssistant extends AssistantEvent {
  RefreshAssistant();
}
