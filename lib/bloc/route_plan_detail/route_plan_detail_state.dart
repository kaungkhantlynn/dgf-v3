part of 'route_plan_detail_bloc.dart';

@immutable
abstract class RoutePlanDetailState {
  const RoutePlanDetailState();
}
class FailedInternetConnection extends RoutePlanDetailState {}
class RoutePlanDetailInitial extends RoutePlanDetailState {}
class StartJobSuccess extends RoutePlanDetailState{

}
class RoutePlanDetailLoading extends RoutePlanDetailState {}

class RoutePlanDetailLoaded extends RoutePlanDetailState {
  RoutePlanDetailModel? routePlanDetailModel;
  RoutePlanDetailLoaded({this.routePlanDetailModel});
}

class RoutePlanDetailError extends RoutePlanDetailState {
  final String? error;

  const RoutePlanDetailError({this.error});
}
