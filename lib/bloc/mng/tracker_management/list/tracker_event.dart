part of 'tracker_bloc.dart';

@immutable
abstract class TrackerEvent {
  const TrackerEvent();
}

class GetTracker extends TrackerEvent {
  GetTracker();
}

class ShowTrackerLoading extends TrackerEvent {}

class RefreshTracker extends TrackerEvent {
  RefreshTracker();
}
