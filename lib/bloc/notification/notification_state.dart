part of 'notification_bloc.dart';

@immutable
abstract class NotificationState {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class InitialNotificationState extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  List<NotiData>? notifications;
  int? page;
  final bool? loadNoMore;

  NotificationLoaded({this.notifications, this.page, this.loadNoMore});

  @override
  String toString() =>
      'NotificationLoaded { events: ${notifications?.length}, loadNoMore: $loadNoMore }';
}

class NotificationError extends NotificationState {
  String message;

  NotificationError(this.message);
}
