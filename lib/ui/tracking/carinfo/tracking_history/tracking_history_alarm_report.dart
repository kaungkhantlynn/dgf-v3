import 'package:fleetmanagement/bloc/alarm_report/alarm_report_bloc.dart';
import 'package:fleetmanagement/data/alarm_report_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/parking/components/parking_noti_card.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/line_point_view.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../widgets/snackbar.dart';

class TrackingHistoryAlarmReport extends StatefulWidget {
  static const String route = '/tracking_history_alarm';
  const TrackingHistoryAlarmReport({Key? key}) : super(key: key);

  @override
  _TrackingHistoryAlarmReportState createState() =>
      _TrackingHistoryAlarmReportState();
}

class _TrackingHistoryAlarmReportState
    extends State<TrackingHistoryAlarmReport> {
  late RefreshController _refreshController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TharArguments;

    return BlocProvider(
      create: (BuildContext context) {
        return AlarmReportBloc(getIt<AlarmReportRepository>());
      },
      child: Scaffold(
        appBar: AppbarPage(
          title: translate('app_bar.tracking_history_alarm'),
        ),
        body: SafeArea(
            child: alarmList('tracking_history', args.license!, args.date!,context)),
      ),
    );
  }

  Widget alarmList(String keyword, String license, String date,BuildContext context) {
    return BlocListener<AlarmReportBloc, AlarmReportState>(
      listener: (context, state) {
        if (state is AlarmReportLoading) {}
        if (state is AlarmReportLoaded) {
          _refreshController
            ..loadComplete()
            ..refreshCompleted();
          if (state.loadNoMore!) {
            print('VIEWNOMORE');
            _refreshController.loadNoData();
          }
        }
        if (state is AlarmReportError) {
          _refreshController
            ..loadFailed()
            ..refreshFailed();
        }
        if (state is FailedInternetConnection) {
          ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
              color: Colors.redAccent);
        }
      },
      child: BlocBuilder<AlarmReportBloc, AlarmReportState>(
        builder: (context, state) {
          if (state is InitialAlarmReportState) {
            BlocProvider.of<AlarmReportBloc>(context)
                .add(GetAlarmReportKeyword(keyword, license, date));
          }
          if (state is AlarmReportLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is AlarmReportError) {
            print('ERRORMOREREPORT${state.message}');
            _refreshController
              ..loadFailed()
              ..refreshFailed();
          }
          if (state is AlarmReportLoaded) {
            return SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                header: const WaterDropHeader(
                  waterDropColor: Colors.cyan,
                ),
                onRefresh: () async {
                  BlocProvider.of<AlarmReportBloc>(context)
                    ..add(ShowAlarmReportLoading())
                    ..add(GetAlarmReportKeyword(keyword, license, date));
                },
                onLoading: () async {
                  BlocProvider.of<AlarmReportBloc>(context)
                      .add(GetAlarmReportKeyword(keyword, license, date));
                },
                child: state.alarmReports!.isNotEmpty
                    ? ListView.builder(
                        itemCount: state.alarmReports!.length,
                        itemBuilder: (context, index) {
                          return ParkingNotiCard(
                              color: state.alarmReports![index].backgroundColor,
                              notiTitle: 'Alarm',
                              carNumber: state.alarmReports![index].deviceName!,
                              status: state.alarmReports![index].alarmType!.toString(),
                              datetime: state.alarmReports![index].endTime!);


                        })
                    : Container(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child:  Text(
                              translate('no_reports'),
                              style: TextStyle(color: Colors.red, fontSize: 17),
                            ),
                          ),
                        ),
                      ));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
