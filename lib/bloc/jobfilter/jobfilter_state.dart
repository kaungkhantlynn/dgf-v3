part of 'jobfilter_bloc.dart';

@immutable
abstract class JobFilterState {
  const JobFilterState();
}

class JobFilterInitial extends JobFilterState {}

class JobFilterLoading extends JobFilterState {}

class JobFilterLoaded extends JobFilterState {
  List<RoutePlanData>? routePlanData;
  int? page;
  bool? hasReachedMax;

  JobFilterLoaded({this.routePlanData, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'JobFilterLoaded { events: ${routePlanData!.length}, hasReachedMax: $hasReachedMax }';
}

class JobFilterError extends JobFilterState {
  final String? error;

  const JobFilterError({this.error});
}
