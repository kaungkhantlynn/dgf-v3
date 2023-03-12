part of 'keyword_search_bloc.dart';

@immutable
abstract class KeywordSearchEvent {
  const KeywordSearchEvent();
}

class GetKeywordSearchEvent extends KeywordSearchEvent {
  String? keyword;

  GetKeywordSearchEvent({this.keyword});
}

class ShowKeywordSearchLoading extends KeywordSearchEvent {}

class ResetKeywordSearchEvent extends KeywordSearchEvent {
  VehiclesModel? vehiclesModel;

  ResetKeywordSearchEvent({this.vehiclesModel});
}
