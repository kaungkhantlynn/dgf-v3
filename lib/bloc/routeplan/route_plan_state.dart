part of 'route_plan_bloc.dart';

@immutable
abstract class RoutePlanState {
  const RoutePlanState();
}

class RoutePlanInitial extends RoutePlanState {}

class RoutePlanLoading extends RoutePlanState {}

class RoutePlanLoaded extends RoutePlanState {
  List<RoutePlanData>? routePlanDatas;
  int? page;
  bool? hasReachedMax;
  bool? success;
  RoutePlanLoaded(
      {this.routePlanDatas, this.page, this.hasReachedMax, this.success});

  @override
  String toString() =>
      'RoutePlanLoaded { events: ${routePlanDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class RoutePlanError extends RoutePlanState {
  final String? error;

  const RoutePlanError({this.error});
}
