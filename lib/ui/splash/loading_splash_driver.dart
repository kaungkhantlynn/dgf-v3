import 'dart:async';
import 'dart:ui';

import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../bloc/alarm_report/alarm_report_bloc.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/contact/contact_bloc.dart';
import '../../bloc/finished_job/finished_job_bloc.dart';
import '../../bloc/notification/notification_bloc.dart';
import '../../bloc/routeplan/route_plan_bloc.dart';
import '../../bloc/save_finished_job/save_finish_job_bloc.dart';
import '../../bloc/vehicles/vehicles_bloc.dart';
import '../../bloc/vehiclesDetail/vehicles_detail_bloc.dart';
import '../../data/alarm_report_repository.dart';
import '../../data/auth_repository.dart';
import '../../data/other_repostory.dart';
import '../../data/tracking_repository.dart';
import '../../di/components/service_locator.dart';
import '../home/driver_home_index.dart';

class LoadingSplashDriver extends StatefulWidget {
  static const String route = '/loading_splash_driver';
  const LoadingSplashDriver({Key? key}) : super(key: key);

  @override
  _LoadingSplashDriverState createState() => _LoadingSplashDriverState();
}

class _LoadingSplashDriverState extends State<LoadingSplashDriver> {
  @override
  void initState() {
    // checkNetwork(context);
    // startTimer();
    navigate();
    super.initState();
  }

  navigate() async {
    Timer.periodic(Duration(seconds: 2), (timer) {
      Navigator.pushReplacementNamed(context,DriverHomeIndex.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // BlocProvider(
          //     create: (context) => _authenticationBloc..add(AppStarted())),

          BlocProvider<AuthenticationBloc>(
            create: (context) {
              return AuthenticationBloc(getIt<AuthRepository>())
                ..add(AppStarted());
            },

          ),
          // BlocProvider<FilterBloc>(create: (context) => FilterBloc()),
          //
          BlocProvider<VehiclesBloc>(create: (context) {
            return VehiclesBloc(getIt<TrackingRepository>())
              ..add(const GetVehicles());
          }),
          BlocProvider<VehiclesDetailBloc>(
            create: (context) {
              return VehiclesDetailBloc(getIt<TrackingRepository>());
            },
          ),

          BlocProvider<AlarmReportBloc>(create: (context) {
            return AlarmReportBloc(getIt<AlarmReportRepository>());
          }),

          BlocProvider<ContactBloc>(create: (context) {
            return ContactBloc(getIt<OtherRepository>())..add(const GetContact());
          }),

          BlocProvider<RoutePlanBloc>(create: (context) {
            return RoutePlanBloc(getIt<DriverRepository>())
              ..add(const GetRoutePlan());
          }),
          BlocProvider<NotificationBloc>(create: (context) {
            return NotificationBloc(getIt<DriverRepository>())
              ..add(GetNotification());
          }),
          BlocProvider<SaveFinishJobBloc>(create: (context) {
            return SaveFinishJobBloc(getIt<DriverRepository>());
          }),
          BlocProvider<FinishedJobBloc>(create: (context) {
            return FinishedJobBloc(getIt<DriverRepository>())
              ..add(const GetFinishedJob());
          }),


        ],
        child:
     splashLoading());
  }

  Scaffold splashLoading() {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Image.asset('assets/original_bg.png').image,
                    fit: BoxFit.cover)),
            child: const FrostedGlassBox(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )));
  }
}

class FrostedGlassBox extends StatelessWidget {
  final Widget child;

  const FrostedGlassBox({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        child: Stack(
          children: [
            BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 60.0,
                  sigmaY: 60.0,
                ),
                child: Container(color: Colors.grey.shade100.withOpacity(0.6))),
            Container(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
