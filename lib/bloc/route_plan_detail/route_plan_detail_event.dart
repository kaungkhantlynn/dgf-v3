part of 'route_plan_detail_bloc.dart';

@immutable
abstract class RoutePlanDetailsEvent {
  const RoutePlanDetailsEvent();
}

class GetRoutePlanDetails extends RoutePlanDetailsEvent {
  int? id;
  GetRoutePlanDetails({this.id});
}

class FinishJob extends RoutePlanDetailsEvent {
  int? id;
  FinishJob({this.id});

  @override
  String toString() => 'FinishJob ';
}

class StartJob extends RoutePlanDetailsEvent{
  int? id;
  StartJob({this.id});

  @override
  String toString() => 'StartJob ';
}



class ShowRoutePlanDetailsLoading extends RoutePlanDetailsEvent {}

class RefreshRoutePlanDetails extends RoutePlanDetailsEvent {
  const RefreshRoutePlanDetails();
}

class ResetRoutePlanDetails extends RoutePlanDetailsEvent {
  VehiclesDetailModel? vehiclesDetailModel;
  int? page;

  ResetRoutePlanDetails({this.vehiclesDetailModel, this.page});
}
