import 'package:fleetmanagement/bloc/vehicle_filter/vehicle_filter_bloc.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_group_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_data.dart';
import 'package:fleetmanagement/ui/tracking/components/tracking_search_item.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:hexcolor/hexcolor.dart';

class TrackingFilter extends StatefulWidget {
  static const String route = '/tracking_filter';

  static ValueNotifier<List<VehicleSummaryData>> notifier = ValueNotifier([]);
  static ValueNotifier<List<VehicleGroupModel>> groupNotifier =
      ValueNotifier([]);

  const TrackingFilter({Key? key}) : super(key: key);

  @override
  _TrackingFilterState createState() => _TrackingFilterState();
}

class _TrackingFilterState extends State<TrackingFilter> {
  List<VehicleSummaryData>? selectedFilter = [];
  List<VehicleGroupModel>? selectGroupFilter = [];

  TrackingRepository? trackingRepository = getIt<TrackingRepository>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String? selectedColor = '#6583FE';
  String? selectedTitleColor = '#575756';
  String? defaultColor = '#FFFFFF';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) {
          return VehicleFilterBloc(getIt<TrackingRepository>());
        },
        child: WillPopScope(
          onWillPop: () async {
            goHome();
            return true;
          },
          child: Scaffold(
              backgroundColor: Colors.blueGrey.shade50,
              appBar: AppBar(
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  translate('app_bar.tracking_filter'),
                  style: TextStyle(color: Colors.grey.shade800),
                ),
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    goHome();
                  },
                ),
              ),
              body: SafeArea(child: filterList())),
        ));
  }

  Widget filterList() {
    return BlocBuilder<VehicleFilterBloc, VehicleFilterState>(
        builder: (context, state) {

          if (state is FailedInternetConnection) {
            ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
                color: Colors.redAccent);
          }

      if (state is VehicleFilterInitial) {
        BlocProvider.of<VehicleFilterBloc>(context).add(const GetVehicleFilter());
      }
      if (state is VehicleFilterLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if (state is VehicleFilterLoaded) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            const Padding(
              padding: EdgeInsets.all(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                  child: Text(translate('tracking_filter_page.vehicle_status'),style: TextStyle(fontSize: 16, color: Colors.grey.shade600),),
                ),
              ],
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                  onTap: () {
                    setState(() {
                      checkAllFilter(
                          state.vehiclesummarydatas!, state.vehiclegroupdatas!);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    child: TrackingSearchItem(
                      color: checkFilterColor(state.vehiclesummarydatas![0]),
                      title: '${state.vehiclesummarydatas![0].key!.toUpperCase()} (${state.vehiclesummarydatas![0].count})',
                      titleColor: checkTextColor(state.vehiclesummarydatas![0]),
                    ),
                  )),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 25)),
            Expanded(
                child: ListView.builder(
                    itemCount: state.vehiclesummarydatas!.length - 1,
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                filterAction(
                                    state.vehiclesummarydatas![index + 1]);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: TrackingSearchItem(
                                color: checkFilterColor(
                                    state.vehiclesummarydatas![index + 1]),
                                title: '${state
                                        .vehiclesummarydatas![index + 1].key!
                                        .toUpperCase()} (${state.vehiclesummarydatas![index + 1].count}${')'.toUpperCase()}',
                                titleColor: checkTextColor(
                                    state.vehiclesummarydatas![index + 1]),
                              ),
                            )),
                      );
                    })),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                  child: Text(translate('tracking_filter_page.vehicle_group'),style: TextStyle(fontSize: 16, color: Colors.grey.shade600),),
                ),
              ],
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: state.vehiclegroupdatas!.length - 1,
                    itemBuilder: (context, index) {
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                filterGroupAction(
                                    state.vehiclegroupdatas![index + 1]);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              color: Colors.transparent,
                              child: TrackingSearchItem(
                                color: checkGroupFilterColor(
                                    state.vehiclegroupdatas![index + 1]),
                                title: state.vehiclegroupdatas![index + 1].name!
                                    .toUpperCase(),
                                titleColor: checkGroupTextColor(
                                    state.vehiclegroupdatas![index + 1]),
                              ),
                            )),
                      );
                    })),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: HexColor('#5A75FF'),
                  padding: const EdgeInsets.all(15.5),
                  textStyle: const TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  goHome();
                },
                child:  Text(
                  translate('submit'),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.all(25))
          ],
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  goHome() {
    TrackingFilter.notifier.value = selectedFilter!;
    TrackingFilter.groupNotifier.value = selectGroupFilter!;
    List<String>? keys = [];
    List<String>? groupKeys = [];

    for (int i = 0; i < selectedFilter!.length; i++) {
      keys.add(selectedFilter![i].key!);
    }

    for (int i = 0; i < selectGroupFilter!.length; i++) {
      groupKeys.add(selectGroupFilter![i].name!);
    }
    // trackingRepository!.setFilterKeyList(selectedFilter!);
    // trackingRepository!.setFilterKeys(keys);
    Navigator.pop(context, [selectedFilter, selectGroupFilter]);
  }

  void checkAllFilter(
      List<VehicleSummaryData> filters, List<VehicleGroupModel> groupfilters) {
    selectedFilter!.clear();
    selectGroupFilter!.clear();

    for (int i = 1; i < filters.length; i++) {
      if (filters[i].count! > 0) {
        selectedFilter!.add(filters[i]);
      }
    }

    for (int i = 1; i < groupfilters.length; i++) {
      if (groupfilters[i].children!.isNotEmpty) {
        selectGroupFilter!.add(groupfilters[i]);
      }
    }
  }

  void filterAction(VehicleSummaryData key) {
    if (selectedFilter!.contains(key)) {
      selectedFilter!.remove(key);
    } else {
      selectedFilter!.add(key);
    }
  }

  void filterGroupAction(VehicleGroupModel groupKey) {
    if (selectGroupFilter!.contains(groupKey)) {
      selectGroupFilter!.remove(groupKey);
    } else {
      selectGroupFilter!.add(groupKey);
    }
  }

  String checkFilterColor(VehicleSummaryData key) {
    if (selectedFilter!.contains(key)) {
      return selectedColor!;
    } else {
      return defaultColor!;
    }
  }

  String checkGroupFilterColor(VehicleGroupModel key) {
    if (selectGroupFilter!.contains(key)) {
      return selectedColor!;
    } else {
      return defaultColor!;
    }
  }

  String checkTextColor(VehicleSummaryData key) {
    if (selectedFilter!.contains(key)) {
      return defaultColor!;
    } else {
      return selectedTitleColor!;
    }
  }

  String checkGroupTextColor(VehicleGroupModel key) {
    if (selectGroupFilter!.contains(key)) {
      return defaultColor!;
    } else {
      return selectedTitleColor!;
    }
  }
}
