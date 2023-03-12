import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/filter/filter_bloc.dart';
import 'package:fleetmanagement/bloc/cubit/live_video_link/live_video_link_cubit.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel/action/action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/fuel_management/fuel_type/action/fuel_type_action_bloc.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/act/action/act_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/insurance_management/insurance/action/insurance_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor/action/sensor_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/sensor_management/sensor_type/action/sensor_type_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/action/tracker_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/tracker_management/list/tracker_bloc.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle/action/vehicle_action_cubit.dart';
import 'package:fleetmanagement/bloc/mng/vehicle_management/vehicle_type/action/vehicle_type_action_cubit.dart';
import 'package:fleetmanagement/bloc/report_count/report_count_cubit.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/ui/check_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../bloc/cubit/live_location_link/live_location_link_cubit.dart';
import '../bloc/mng/driver_management/assistant/list/assistant_bloc.dart';
import '../core/utility/routes/routes.dart';
import '../data/network/api/mng/mng_api.dart';
import '../data/network/api/other/other_api.dart';
import '../di/components/service_locator.dart';

class FleetManagement extends StatelessWidget {
  const FleetManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<FilterBloc>(create: (context)=> FilterBloc()),
            BlocProvider<AssistantBloc>(create: (context)=> AssistantBloc(getIt<MngApi>())),
            BlocProvider<TrackerBloc>(create: (context)=> TrackerBloc(getIt<MngApi>())),
            BlocProvider<TrackerActionCubit>(create: (context)=> TrackerActionCubit(getIt<MngApi>())),
            BlocProvider<FuelTypeActionCubit>(create: (context)=> FuelTypeActionCubit(getIt<MngApi>())),
            BlocProvider<ActionCubit>(create: (context)=> ActionCubit(getIt<MngApi>())),
            BlocProvider<SensorTypeActionCubit>(create: (context)=> SensorTypeActionCubit(getIt<MngApi>())),
            BlocProvider<SensorActionCubit>(create: (context)=> SensorActionCubit(getIt<MngApi>())),
            BlocProvider<VehicleTypeActionCubit>(create: (context)=> VehicleTypeActionCubit(getIt<MngApi>())),
            BlocProvider<VehicleActionCubit>(create: (context)=> VehicleActionCubit(getIt<MngApi>())),
            BlocProvider<ActActionCubit>(create: (context)=> ActActionCubit(getIt<MngApi>())),
            BlocProvider<InsuranceActionCubit>(create: (context)=> InsuranceActionCubit(getIt<MngApi>())),
            BlocProvider<LongdoLocationCubit>(create: (context)=> LongdoLocationCubit(getIt<TrackingRepository>())),
            BlocProvider<ReportCountCubit>(create: (context)=> ReportCountCubit(getIt<OtherApi>())),
            BlocProvider<LiveVideoLinkCubit>(create: (context)=> LiveVideoLinkCubit(getIt<TrackingRepository>())),
            BlocProvider<LiveLocationLinkCubit>(create: (context)=> LiveLocationLinkCubit(getIt<TrackingRepository>())),

            // BlocProvider(create:(context)=> LongdoLocationCubit(getIt<TrackingRepository>())),
            // BlocProvider<TrackerBloc>(create: (context)=> TrackerBloc(getIt<MngApi>())),
            // BlocProvider<FuelTypeBloc>(create: (context)=> FuelTypeBloc(getIt<MngApi>())),
            // BlocProvider<SensorTypeBloc>(create: (context)=> SensorTypeBloc(getIt<MngApi>())),
            // BlocProvider<VehicleTypeBloc>(create: (context)=> VehicleTypeBloc(getIt<MngApi>())),
            // BlocProvider<VehicleBloc>(create: (context)=> VehicleBloc(getIt<MngApi>())),
            // BlocProvider<ActBloc>(create: (context)=> ActBloc(getIt<MngApi>())),
            // BlocProvider<InsuranceBloc>(create: (context)=> InsuranceBloc(getIt<MngApi>())),
          ],
          child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              localizationDelegate
            ],
            supportedLocales: localizationDelegate.supportedLocales,
            locale: localizationDelegate.currentLocale,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // primaryColor: Colors.indigo,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            builder: (context, widget) => ResponsiveWrapper.builder(
              BouncingScrollWrapper.builder(context, widget!),
              maxWidth: 1200,
              minWidth: 450,
              defaultScale: true,
              breakpoints: [
                const ResponsiveBreakpoint.resize(450, name: MOBILE),
                const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
              ],
            ),
            routes: Routes.routes,
            initialRoute: CheckState.route,
          ),
        )
    );
  }
}
