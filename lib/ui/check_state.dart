import 'package:fleetmanagement/bloc/alarm_report/alarm_report_bloc.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_bloc.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_event.dart';
import 'package:fleetmanagement/bloc/authentication/authentication_state.dart';
import 'package:fleetmanagement/bloc/contact/contact_bloc.dart';
import 'package:fleetmanagement/bloc/finished_job/finished_job_bloc.dart';
import 'package:fleetmanagement/bloc/routeplan/route_plan_bloc.dart';
import 'package:fleetmanagement/bloc/save_finished_job/save_finish_job_bloc.dart';
import 'package:fleetmanagement/bloc/vehicles/vehicles_bloc.dart';
import 'package:fleetmanagement/bloc/vehiclesDetail/vehicles_detail_bloc.dart';
import 'package:fleetmanagement/data/alarm_report_repository.dart';
import 'package:fleetmanagement/data/auth_repository.dart';
import 'package:fleetmanagement/data/other_repostory.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/auth/admin/admin_login.dart';
import 'package:fleetmanagement/ui/home/driver_home_index.dart';
import 'package:fleetmanagement/ui/home/home_index.dart';
import 'package:fleetmanagement/ui/splash/splash_screen.dart';
import 'package:fleetmanagement/ui/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/notification/notification_bloc.dart';

class CheckState extends StatefulWidget {
  static const String route = '/check_state';
  const CheckState({Key? key}) : super(key: key);

  @override
  _CheckStateState createState() => _CheckStateState();
}

class _CheckStateState extends State<CheckState> {
  late AuthenticationBloc _authenticationBloc =
      AuthenticationBloc(getIt<AuthRepository>());

  @override
  void initState() {
    _authenticationBloc = AuthenticationBloc(getIt<AuthRepository>());
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
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
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationUninitialized) {
              return const SplashScreen();
            }
            if (state is AdminAuthenticationAuthenticated) {
              return const HomeIndex();
            }
            if (state is DriverAuthenticationAuthenticated) {
              return const DriverHomeIndex();
            }
            if (state is AuthenticationUnauthenticated) {
              return const AdminLogin();
            }
            if (state is AuthenticationLoading) {
              return const SplashScreen();
            }
            return LoadingIndicator();
          },
        ));
  }
}
