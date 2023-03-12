part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class GetNotification extends NotificationEvent {
  GetNotification();
}

class RefreshNotification extends NotificationEvent {
  RefreshNotification();
}

class ShowNotificationLoading extends NotificationEvent {}

class ResetNotificationEvent extends NotificationEvent {
  NotificationModel notificationModel;
  int page;

  ResetNotificationEvent(this.notificationModel, this.page);
}
