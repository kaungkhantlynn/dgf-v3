import 'package:fleetmanagement/bloc/cubit/tracking_history/line_tracking_history_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_history/tracking_history_cubit.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/line_point_view.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrackingHistoryIndex extends StatefulWidget {
  static const String route = '/tracking_history';

  const TrackingHistoryIndex({Key? key}) : super(key: key);

  @override
  _TrackingHistoryIndexState createState() => _TrackingHistoryIndexState();
}

class _TrackingHistoryIndexState extends State<TrackingHistoryIndex> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TrackingHistoryArguments;

    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  TrackingHistoryCubit(getIt<TrackingRepository>())),
          BlocProvider(create: (context) => LineTrackingHistoryCubit()),
        ],
        child: Scaffold(
          body: LinePointView(
            license: args.license,
            date: args.formattedDate,
          ),
        ));
  }
}
