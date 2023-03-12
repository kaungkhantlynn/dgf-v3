
part of 'filter_bloc.dart';


@immutable
abstract class FilterState {
  const FilterState();
  @override
  List<Object> get props => [];
}

class FilterFailedInternetConnection extends FilterState {}
class InitialFilterState extends FilterState {}

class FilterLoading extends FilterState {}

class FilterKeyReceived extends FilterState {
  String? license;

  FilterKeyReceived({this.license});
}

class FilterError extends FilterState {
  final String error;

  const FilterError(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FilterFailure { error: $error }';
}
