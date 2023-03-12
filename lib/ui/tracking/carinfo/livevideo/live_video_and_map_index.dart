import 'dart:async';
import 'dart:convert';

import 'package:fleetmanagement/bloc/cubit/jsession_for_live_video/jsession_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/cubit/cluster/longdo_location_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/maps_tracking_state.dart';
import '../../../../bloc/cubit/tracking_vehicle/tracking_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/tracking_state.dart';
import '../../../widgets/appbar_page.dart';
import '../../maps/view/tracking_point_view.dart';
import 'live_video_and_map_view.dart';

class LiveVideoAndMapIndex extends StatefulWidget {
  String? license;
 String? deviceId;
  String? status;
  String? speed;
  String? speedUnit;
  String? temperature;
  String? temperatureUnit;
  String? oil;
  String? oilUnit;
  String? mapIcon;
  String? channel;
  LiveVideoAndMapIndex({Key? key,this.license,this.deviceId,this.status,this.speed,this.speedUnit,this.temperature,this.temperatureUnit,this.oil,this.oilUnit,this.mapIcon,this.channel}) : super(key: key);

  @override
  State<LiveVideoAndMapIndex> createState() => _LiveVideoAndMapIndexState();
}

class _LiveVideoAndMapIndexState extends State<LiveVideoAndMapIndex> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  Timer? timer;
  Timer? timerAlarm;
  bool? alarmVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLivePoints(context, widget.license!);
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
    Future.microtask(() {
      context.read<TrackingCubit>().fetchPoint(license, '1');
    });
  }



  Center get buildCenterLoading => const Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
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
            print('TRACKING DETAIL WEB LIVE');
            print(jsonEncode(data.vehiclesDetailModel));
            context
                .read<LongdoLocationCubit>()
                .fetchLocationString(data.vehiclesDetailModel.vehiclesDetailData!.lat!, data.vehiclesDetailModel.vehiclesDetailData!.lon!);
            return LiveVideoAndMapView(
              alarmVisible: alarmVisible,
              license: widget.license,
              vehiclesDetailModel: data.vehiclesDetailModel,
              deviceId: widget.deviceId,
              status: '1',
              speed:widget.speed,
              speedUnit: 'km/hr',
              temperature: widget.temperature,
              temperatureUnit:'°C',
              oil: widget.temperatureUnit,
              oilUnit: 'L',
              mapIcon: widget.mapIcon,
              channel: widget.channel,
            );
          default:
            {
              return Scaffold(
                body: buildCenterLoading
              );
            }
        }
      },
    );
  }
}
