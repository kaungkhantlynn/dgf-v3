// part of 'ios_bloc.dart';
//
// @immutable
abstract class IosEvent {
  const IosEvent();
}

class GetIos extends IosEvent {
  GetIos();
}

class ShowIosLoading extends IosEvent {}

class RefreshSensor extends IosEvent {
  RefreshSensor();
}
