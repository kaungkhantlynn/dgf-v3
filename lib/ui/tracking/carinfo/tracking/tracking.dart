import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/maps_tracking_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/street_view_tracking_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/tracking_cubit.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking/live_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Tracking extends StatelessWidget {
  static const String route = '/live_tracking';
  const Tracking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as VehicleArguments;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TrackingCubit(getIt<TrackingRepository>())),
          BlocProvider(create: (context) => MapsTrackingCubit()),
          BlocProvider(create: (context) => StreetViewTrackingCubit())
        ],
        child: LiveTracking(
          license: args.license,
        ));
  }
}
