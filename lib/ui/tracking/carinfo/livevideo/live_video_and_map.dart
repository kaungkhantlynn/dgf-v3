import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';


import '../../../../bloc/cubit/jsession_for_live_video/jsession_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/maps_tracking_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/tracking_cubit.dart';
import '../../../../data/tracking_repository.dart';
import '../../../../di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import '../../../widgets/appbar_page.dart';
import 'live_video_and_map_index.dart';

class LiveVideoAndMap extends StatefulWidget {
  static const String route = '/live_video_and_map';
  const LiveVideoAndMap({Key? key}) : super(key: key);

  @override
  State<LiveVideoAndMap> createState() => _LiveVideoAndMapState();
}

class _LiveVideoAndMapState extends State<LiveVideoAndMap> {
  @override
  Widget build(BuildContext context) {
    // var args = ModalRoute.of(context)!.settings.arguments as VehicleArguments;
    var liveVideoMapArgs = ModalRoute.of(context)!.settings.arguments as LiveVideoMapArguments;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TrackingCubit(getIt<TrackingRepository>())),
          BlocProvider(create: (context) => MapsTrackingCubit()),
          BlocProvider(create: (context) => JsessionCubit(getIt<TrackingRepository>()))
        ],
        child: LiveVideoAndMapIndex(
          license: liveVideoMapArgs.license!,
          deviceId: liveVideoMapArgs.deviceId,
          status: '1',
          speed:liveVideoMapArgs.speed,
          speedUnit: 'km/hr',
          temperature: liveVideoMapArgs.temperature,
          temperatureUnit:'°C',
          oil: liveVideoMapArgs.temperatureUnit,
          oilUnit: 'L',
          mapIcon: liveVideoMapArgs.mapIcon,
          channel: liveVideoMapArgs.channel,
        ),
    );
  }
}
