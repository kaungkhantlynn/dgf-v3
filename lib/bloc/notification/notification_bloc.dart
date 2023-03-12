
import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/notification/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent,NotificationState> {
  DriverRepository driverRepository;

  NotificationBloc(this.driverRepository)
      : super(InitialNotificationState());

  @override
  Stream<NotificationState> mapEventToState(
      NotificationEvent event,
  ) async* {
    var currentState = state;

    if (event is GetNotification) {
      print('GETTINGNOTI');
      yield* _mapEventKeywordChange(event, currentState);
    }
  }

  Stream<NotificationState> _mapEventKeywordChange(
      GetNotification event, NotificationState currentState) async* {
    if (event is GetNotification) {

      try {
        int pageToFetch = 1;
        List<NotiData> notiModels = [];

        if (currentState is InitialNotificationState) {
          pageToFetch = 1;
          notiModels.clear();
        }

        if (currentState is NotificationLoaded) {
          pageToFetch = currentState.page! + 1;
          notiModels = currentState.notifications!;
        }

        print('PAGENO$pageToFetch');
        NotificationModel allNotificationModel =
            await driverRepository.getNotifications(pageToFetch);
        print("NOTIFICATION LENGTH ${allNotificationModel.data!.length}");

        bool hasReachMax = allNotificationModel.meta!.currentPage! <=
            allNotificationModel.meta!.lastPage!
            ? false
            : true;

        print('LOADNOMORE $hasReachMax');

        notiModels.addAll(allNotificationModel.data!);

        print("PAGETOFETCH$pageToFetch");


        // bool hasReachMax =
        // servicesModel.addAll(allServicesModel.data!);

        yield NotificationLoaded(
            notifications: notiModels,
            page: pageToFetch,
            loadNoMore: hasReachMax);

        print(pageToFetch);
      } on NoInternetConnectionException catch (error) {
        yield NotificationError(error.message);
      } on InternalServerErrorException catch (error) {
        yield NotificationError(error.message);
      } on UnauthorizedException catch (error) {
        NotificationError(error.message);
      } catch (e) {
        print('ALARM_ERROR_NOTI $e');
        yield NotificationError(e.toString());
      }
    }
  }
}
