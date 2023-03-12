import 'dart:async';

import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/maps_tracking_state.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/tracking_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/tracking_state.dart';

import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../maps/view/tracking_point_view.dart';


class LiveTracking extends StatefulWidget {
  String? license;
  LiveTracking({this.license, Key? key}) : super(key: key);

  @override
  _LiveTrackingState createState() => _LiveTrackingState();
}

class _LiveTrackingState extends State<LiveTracking> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Timer? timer;
  Timer? timerAlarm;
  bool? alarmVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchLivePoints(context, widget.license!);
    // dummyPoints();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        timer = Timer.periodic(const Duration(seconds: 5), (timer) {
          fetchLivePoints(context, widget.license!);

          alarmVisible = true;
        });

      });

    }
    timerAlarm= Timer.periodic(const Duration(seconds: 2), (alarmTimer) {
      alarmVisible = false;
    });
  }

  void fetchLivePoints(BuildContext context, String license) {
    // timer = Timer.periodic(Duration(seconds: 2), (timer) {
    //     Future.microtask((){
    //         context.read<LiveTrackingCubit>().fetchLivePoint(license);
    //     });
    // });
    print('CALL AGAIN LIVE TRACIING' );
    Future.microtask(() {
      context.read<TrackingCubit>().fetchPoint(license, '1');
    });
  }

  Center get buildCenterLoading => const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    // var args = ModalRoute.of(context)!.settings.arguments as VehicleArguments;

    var mediaQuery = MediaQuery.of(context);
    return BlocConsumer<TrackingCubit, TrackingState>(
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case MapsTrackingInitial:
            print('LIVE_TRACKING_INITIAL');
            fetchLivePoints(context, widget.license!);
            return buildCenterLoading;
          case TrackingCompleted:
            var data = (state as TrackingCompleted);
            context
                .read<LongdoLocationCubit>()
                .fetchLocationString(data.vehiclesDetailModel.vehiclesDetailData!.lat!, data.vehiclesDetailModel.vehiclesDetailData!.lon!);
            return TrackingPointView(
              alarmVisible: alarmVisible,
              license: widget.license,
              vehiclesDetailModel: data.vehiclesDetailModel,
            );
          default:
            {
              return Scaffold(
                body: buildCenterLoading,
              );
            }
        }
      },
    );
  }
}
