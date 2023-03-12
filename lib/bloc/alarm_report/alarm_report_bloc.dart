import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/alarm_report_repository.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/models/alarm_report/alarm_report_data.dart';
import 'package:fleetmanagement/models/alarm_report/alarm_report_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'alarm_report_event.dart';
part 'alarm_report_state.dart';

class AlarmReportBloc extends Bloc<AlarmReportEvent, AlarmReportState> {
  AlarmReportRepository alarmReportRepository;

  AlarmReportBloc(this.alarmReportRepository)
      : super(InitialAlarmReportState());

  @override
  Stream<AlarmReportState> mapEventToState(
    AlarmReportEvent event,
  ) async* {
    var currentState = state;

    if (event is ChangeAlarmReportKeyword) {
      yield InitialAlarmReportState();
    }
    if (event is RefreshAlarmReport) {
      yield InitialAlarmReportState();
    }
    if (event is ShowAlarmReportLoading) {
      yield AlarmReportLoading();
    }

    if (event is GetAlarmReportKeyword) {
      print('ALARMREPORTKEYWORD');
      yield* _mapEventKeywordChange(event, currentState);
    }
  }

  Stream<AlarmReportState> _mapEventKeywordChange(
      GetAlarmReportKeyword event, AlarmReportState currentState) async* {
    if (event is GetAlarmReportKeyword) {
      print('ALR_LICENSE ${event.license!}');
      print("ALR_DATE ${event.date!}");
      bool isConnected = await InternetConnectionChecker().hasConnection;
      if (isConnected) {
        try {
          int pageToFetch = 1;
          List<AlarmReportData> alarmReportModel = [];

          if (currentState is InitialAlarmReportState) {
            pageToFetch = 1;
            alarmReportModel.clear();
          }

          if (currentState is AlarmReportLoaded) {
            pageToFetch = currentState.page! + 1;
            alarmReportModel = currentState.alarmReports!;
          }

          print('PAGENO$pageToFetch');
          AlarmReportModel allalarmReportModel =
          await alarmReportRepository.getReports(
              type: event.keyword,
              license: event.license,
              date: event.date,
              page: pageToFetch);
          print("ALARM_REPORT_LENGTH ${allalarmReportModel.data!.length}");

          bool hasReachMax = allalarmReportModel.meta!.currentPage! <=
              allalarmReportModel.meta!.lastPage!
              ? false
              : true;

          print('LOADNOMORE $hasReachMax');

          alarmReportModel.addAll(allalarmReportModel.data!);

          print("PAGETOFETCH$pageToFetch");
          print("METACURRENTPAGE ${allalarmReportModel.meta!.currentPage}");
          print("METALASTPAGE ${allalarmReportModel.meta!.lastPage}");

          // bool hasReachMax =
          // servicesModel.addAll(allServicesModel.data!);

          yield AlarmReportLoaded(
              alarmReports: alarmReportModel,
              page: pageToFetch,
              loadNoMore: hasReachMax);

          print(pageToFetch);
        } on NoInternetConnectionException catch (error) {
          yield AlarmReportError(error.message);
        }
        on BadRequestException catch (error ) {
          yield AlarmReportError(error.message);
        }on InternalServerErrorException catch (error) {
          yield AlarmReportError(error.message);
        } on UnauthorizedException catch (error) {
          AlarmReportError(error.message);
        } catch (e) {
          print('ALARM_ERROR $e');
          yield AlarmReportError(e.toString());
        }
      }  else {
        yield FailedInternetConnection();
      }
    }
  }
}
