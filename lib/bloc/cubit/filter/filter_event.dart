part of 'filter_bloc.dart';

@immutable
abstract class FilterEvent {
  const FilterEvent();
}

class GetFilterEvent extends FilterEvent {
  String? keyword;

  GetFilterEvent({this.keyword});
}

class ShowFilterLoading extends FilterEvent {}

class ResetFilterEvent extends FilterEvent {
  String? license;

  ResetFilterEvent({this.license});
}
