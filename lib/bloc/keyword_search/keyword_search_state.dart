part of 'keyword_search_bloc.dart';

@immutable
abstract class KeywordSearchState {
  const KeywordSearchState();
  @override
  List<Object> get props => [];
}

class FailedInternetConnection extends KeywordSearchState {}

class InitialKeywordSearchState extends KeywordSearchState {}

class KeywordSearchLoading extends KeywordSearchState {}

class KeywordSearchLoaded extends KeywordSearchState {
  KeywordSearchModel? keywordSearchModel;

  KeywordSearchLoaded({this.keywordSearchModel});
}

class KeywordSearchError extends KeywordSearchState {
  final String error;

  const KeywordSearchError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'KeywoardSearchFailure { error: $error }';
}
