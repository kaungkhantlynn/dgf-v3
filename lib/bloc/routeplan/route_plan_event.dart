part of 'route_plan_bloc.dart';

@immutable
abstract class RoutePlanEvent {
  const RoutePlanEvent();
}

class GetRoutePlan extends RoutePlanEvent {
  const GetRoutePlan();
}

class ShowRoutePlanLoading extends RoutePlanEvent {}

class RefreshRoutePlan extends RoutePlanEvent {
  const RefreshRoutePlan();
}
