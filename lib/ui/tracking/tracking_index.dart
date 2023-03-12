import 'dart:async';

import 'package:fleetmanagement/bloc/cubit/live_video_link/live_video_link_cubit.dart';
import 'package:fleetmanagement/core/utility/string_extensions.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_data.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_summary.dart';
import 'package:fleetmanagement/ui/tracking/tracking_filter.dart';
import 'package:fleetmanagement/ui/tracking/vehicle_group_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import '../../bloc/cubit/cluster/cluster_cubit.dart';
import '../../bloc/cubit/cluster/maps_cluster_cubit.dart';
import '../../models/vehicles/vehicle_group_model.dart';
import 'maps/view/cluster_points_view.dart';

class TrackingIndex extends StatefulWidget {
  const TrackingIndex({Key? key}) : super(key: key);

  @override
  _TrackingIndexState createState() => _TrackingIndexState();
}

class _TrackingIndexState extends State<TrackingIndex> {
  final int _focusedIndex = 0;

  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey();

  //summary status and group data when back (onGoBack)
  List<VehicleSummaryData>? filterDatas = [];
  List<VehicleGroupModel> groupFilterDatas = [];

  VehiclesSummary? vehiclesFilter;


  @override
  void initState() {
    super.initState();
  }


  FutureOr onGoBack(dynamic filters) {
    setState(() {

      filterDatas = filters[0];
      groupFilterDatas = filters[1];
      // print(filterDatas!.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ClusterCubit(getIt<TrackingRepository>())),
          BlocProvider(create: (context) => MapsClusterCubit()),



          // BlocProvider<FilterBloc>(create: (BuildContext context) => FilterBloc()),



        ],
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, TrackingFilter.route)
                    .then(onGoBack);
              },
              icon: const Icon(
                Icons.menu_rounded,
                size: 28,
              ),
            ),
            title: Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    translate('app_bar.vehicles'),
                    style: TextStyle(color: Colors.grey.shade800),
                  ),
                )),
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  filterDatas!.clear();
                  groupFilterDatas.clear();
                  Navigator.pushNamed(context, VehicleGroupSearch.route);
                },
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ],
            backgroundColor: Colors.white,
          ),
          body: SafeArea(
              child: Stack(
            children: [
              ClusterPointsView(
                filtersKey: filterDatas,
                groupFilterKey: groupFilterDatas,
              ),
            ],
          )),
        ));
  }

  Container filterItem(VehicleSummaryData vehicleSummaryData, String key) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50.10)),
        padding: const EdgeInsets.only(left: 10, right: 4),
        margin: const EdgeInsets.only(right: 5.5),
        child: Center(
            child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '${vehicleSummaryData.key!.capitalize()} ( ${vehicleSummaryData.count} )',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  fontSize: 16),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    filterDatas!.remove(vehicleSummaryData);
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade800,
                ))
          ],
        )));
  }
}
