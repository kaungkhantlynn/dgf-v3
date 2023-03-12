import 'dart:async';

import 'package:fleetmanagement/bloc/cubit/cluster/cluster_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/cluster_state.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/maps_cluster_state.dart';
import 'package:fleetmanagement/bloc/cubit/filter/filter_bloc.dart';
import 'package:fleetmanagement/core/constants/extension/context_extension.dart';
import 'package:fleetmanagement/core/utility/string_extensions.dart';
import 'package:fleetmanagement/data/sharedpref/constants/preferences.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_group_model.dart';
import 'package:fleetmanagement/models/vehicles/vehicle_summary_data.dart';
import 'package:fleetmanagement/models/vehicles/vehicles_model.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/car_info_menu.dart';
import 'package:fleetmanagement/ui/tracking/components/vehicle_card.dart';
import 'package:fleetmanagement/ui/tracking/tracking_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../bloc/cubit/cluster/maps_cluster_cubit.dart';
import '../../../../constants/strings.dart';
import '../../../widgets/snackbar.dart';
import '../../carinfo/components/channel_picker.dart';
import '../../carinfo/tracking/tracking.dart';


class ClusterPointsView extends StatefulWidget {
  List<VehicleSummaryData>? filtersKey = [];
  List<VehicleGroupModel>? groupFilterKey = [];

  ClusterPointsView({this.filtersKey, this.groupFilterKey, Key? key})
      : super(key: key);

  @override
  _ClusterPointsViewState createState() => _ClusterPointsViewState();
}

class ScreenArguments {
  final String license;
  ScreenArguments(this.license);
}

class _ClusterPointsViewState extends State<ClusterPointsView> {

  TrackingRepository? trackingRepository = getIt<TrackingRepository>();
  final SharedPreferenceHelper _sharedPreferenceHelper = getIt<SharedPreferenceHelper>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey();
  String? licenseKey;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? timer;
  @override
  void initState() {
    super.initState();
    trackingRepository!.setCardVehicleIndex(0);
    trackingRepository!.clearVehicleModelData();

    licenseKey = '';
  }

  @override
  void dispose() {
    timer?.cancel();
    trackingRepository!.setCardVehicleIndex(0);
    trackingRepository!.clearVehicleModelData();
    trackingRepository!.setFilterKeysNull();
    super.dispose();
  }

  void fetchAllPoints(BuildContext context,
      {List<String>? status, List<String>? groupStatus,String? license}) {
    // print("FILTER_LICENSE_FETCH $license");
    Future.microtask(() {
      context
          .read<ClusterCubit>()
          .fetchAllPoints(status: status, groupStatus: groupStatus,licenseKey: license);
    });
  }

  @override
  Widget build(BuildContext context) {

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {

    });
    return BlocListener<FilterBloc,FilterState>(
      listener : (context,state){
        if (state is FilterKeyReceived) {

          setState(() {
            licenseKey = state.license;
          });
        }

        if (state is FailedInternetConnection) {
          ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
              color: Colors.redAccent);
        }

      },
      child: ValueListenableBuilder<List<VehicleGroupModel>>(
          valueListenable: TrackingFilter.groupNotifier,
          builder: (_, groupfilterData, __) {
            // trackingRepository!.setFilterKeys(keys);
            trackingRepository!.setCardVehicleIndex(0);

            return ValueListenableBuilder<List<VehicleSummaryData>>(
                valueListenable: TrackingFilter.notifier,
                builder: (_, filterData, __) {
                  List<String>? keys = [];
                  for (int i = 0; i < filterData.length; i++) {
                    if (filterData[i].count! > 0) {
                      keys.add(filterData[i].key!);
                    }
                  }
                  List<String>? groupkeys = [];
                  for (int i = 0; i < groupfilterData.length; i++) {
                    if (groupfilterData[i].children!.isNotEmpty) {
                      groupkeys.add(groupfilterData[i].name!);
                    }
                  }
                  trackingRepository!.setFilterKeys(keys);
                  trackingRepository!.setCardVehicleIndex(0);
                  print("BEFORE_FETCH_LICENSE  $licenseKey");

                  fetchAllPoints(context, status: keys, groupStatus: groupkeys,license: licenseKey);

                  return Scaffold(
                    key: scaffoldKey,
                    body: SafeArea(
                        child: Stack(
                          children: [
                            BlocConsumer<ClusterCubit, ClusterState>(
                              listener: (context, state) {},
                              builder: (context, state) {
                                switch (state.runtimeType) {
                                  case ClusterInitial:
                                    print('CLUSTER_INITIAL');
                                    fetchAllPoints(context,
                                        status: keys, groupStatus: groupkeys);
                                    return buildCenterLoading;
                                  case ClusterCompleted:
                                    print('CLUSTER_COMPLETED');
                                    // vehiclesFilter = (state as ClusterCompleted).coordinate.summary;


                                    if ((state as ClusterCompleted).coordinate.data!.isEmpty ) {
                                      return  Center(
                                        child: Text(translate('tracking_page.there_is_no_vehicles')),
                                      );
                                    }
                                    return clusterMapView(
                                        ((state).coordinate),
                                        MediaQuery.of(context),
                                        widget.filtersKey!,
                                        widget.groupFilterKey!,
                                        licenseKey!);
                                  default:
                                    {
                                      return buildCenterLoading;
                                    }
                                }
                              },
                            ),
                          ],
                        )),
                  );
                });
          }),);

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
                    widget.filtersKey!.remove(vehicleSummaryData);
                    TrackingFilter.notifier.value = widget.filtersKey!;
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade800,
                ))
          ],
        )));
  }
  Container licenseFilterItem() {
    return Container(

        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(50.10)),
        padding: const EdgeInsets.only(left: 10, right: 4),
        margin: const EdgeInsets.only(right: 5.5,left: 15.5),
        child: Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                 licenseKey!,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                      fontSize: 16),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        licenseKey = '';
                        _sharedPreferenceHelper.clearLicenseKey();
                        TrackingFilter.notifier.value = widget.filtersKey!;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade800,
                    ))
              ],
            )));
  }

  Container groupfilterItem(VehicleGroupModel vehicleGroupModel, String name) {
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
              name,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  fontSize: 16),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.groupFilterKey!.remove(vehicleGroupModel);
                    TrackingFilter.groupNotifier.value = widget.groupFilterKey!;
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey.shade800,
                ))
          ],
        )));
  }

  //loading
  Center get buildCenterLoading => const Center(child: CircularProgressIndicator());

  Widget clusterMapView(
      VehiclesModel cluster,
      MediaQueryData mediaQuery,
      List<VehicleSummaryData> filtersKey,
      List<VehicleGroupModel> groupfiltersKey,
      String licenseKey) {


    if ( trackingRepository!.getVehicleData() == Preferences.emptyVehicle ) {
      print("CLUSTER_LENGTH ${cluster.data![0].name}");
      trackingRepository!.setVehicleModelData(cluster.data![0]);
    }
    Set<Marker> markers;
    int selectedIndex = 0;
    if (cluster.data!.isNotEmpty) {
      context.read<MapsClusterCubit>().changeAllMarker(cluster.data);
    }

    return BlocConsumer<MapsClusterCubit, MapsClusterState>(
      listener: (context, state) {
        if (state is MapsClusterUpdate) {
          print('MapsClusterUpdateLISTENER');
          // scaffoldKey.currentState!.hideCurrentSnackBar();
          // scaffoldKey.currentState!.showSnackBar(snackBarWidget);
        }

        if (state is MapsClusterSelectedDefaultMarker) {
          print('DEFAULT_MARKER_WORK$selectedIndex');
        }
        if (state is FailedInternetConnection) {
          ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
              color: Colors.redAccent);
        }
      },
      builder: (context, state) {
        // Set<Marker>? markers;
        markers = <Marker>{};

        if (state is MapsClusterInitial) {
          print("MapsClusterInitial");
          // return Container(
          //   child: Text("MapsClusterInitial"),
          // );
        } else if (state is MapsClusterLoad) {
          print("MapsClusterLoad");
          // return Container(
          //   child: Text("MapsClusterLoad"),
          // );
        } else if (state is MapsClusterUpdate) {
          // print('CLUSTERDATA '+ cluster.data![0].coordinate.latitude.toString() + ','+ cluster.data![0].coordinate.longitude.toString() );
          print('MapsClusterUpdate');

          print('Maps Cluster ${state.mapMarkers.length}');
          markers = state.mapMarkers;

          print('SET MARKER ${markers.length}');
          // return Center(child: Text('This is Google Map'),);
        } else if (state is MapsClusterSelectedDefaultMarker) {
          print('SELECTED_PAGE_CHANGE ${state.index}');
        }

        return Stack(
          children: [
            // WidgetMarker(globalKeyMyWidget: globalKey),
            GoogleMap(
              onMapCreated: (controller) {
                context.read<MapsClusterCubit>().initMapController(
                    controller, context, cluster.data!, globalKey);
              },
              markers: markers,
              onCameraMove: (position) =>
                  context.read<MapsClusterCubit>().updateMarkers(position.zoom),
              initialCameraPosition: CameraPosition(
                  target: cluster.data!.first.coordinate, zoom: 10),
            ),

            positionedPageView(context, cluster),
            trackingButton(context),

            // videoButton(context),


            licenseKey.isNotEmpty ?
                Positioned(

                    width: 160,
                    top: 15,

                    child: SizedBox(

                      child: licenseFilterItem(),
                    )
                ): Container(),

            filtersKey.isNotEmpty ?
            Positioned(
              left: 15,
              top: 15,
              right: 15,
              child: SizedBox(
                  width: mediaQuery.size.width,
                  height: 55,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filtersKey.length,
                      itemBuilder: (context, index) {
                        return filterItem(
                            filtersKey[index], filtersKey[index].key!);
                      })),
            )
                : Container(),

            groupfiltersKey.isNotEmpty ?Positioned(
                left: 15,
                top: 75,
                right: 15,
                child: SizedBox(
                    width: mediaQuery.size.width,
                    height: 55,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: groupfiltersKey.length,
                        itemBuilder: (context, index) {
                          return groupfilterItem(groupfiltersKey[index],
                              groupfiltersKey[index].name!);
                        }))) : Container()


          ],
        );
      },
    );
  }

  Positioned trackingButton(BuildContext context) {
    return Positioned(
        right: 7,
        top: context.height /4.5,
        child:     InkWell(
          onTap: (){
            Navigator.pushNamed(
              context,
              Tracking.route,
              arguments: VehicleArguments(
                  license: trackingRepository!.getVehicleData()['name'],
                  status: '1',
                  speed: trackingRepository!.getVehicleData()['speed'].toString(),
                  speedUnit: 'Km/',
                  temperature: trackingRepository!.getVehicleData()!['temp'].toString(),
                  temperatureUnit: '°C',
                  oil: trackingRepository!.getVehicleData()!['fuel']
                      .toString(),
                  oilUnit: 'L',
                  mapIcon: trackingRepository!.getVehicleData()!['mapIcon']),
            );
          },
          child:Container(
            padding: const EdgeInsets.all(15.5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.5)),
            child: Icon(
              LineAwesomeIcons.location_arrow,
              color: Colors.grey.shade800,
            ),
          ),
        ),);
  }

  Positioned videoButton(BuildContext context) {
    return Positioned(
        right: 7,
        top: context.height / 3.5,
        child:   InkWell(
          onTap: (){
            print(trackingRepository!.getVehicleData()['name']);
            showMaterialModalBottomSheet(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17)),
                elevation: 12,
                isDismissible: true,
                context: context,
                builder: (context) => ChannelPicker(
                  license:  trackingRepository!.getVehicleData()['name'],
                  date: '',
                  fromWidget: Strings.liveVideo,
                ));
          },
          child:Container(
            padding: const EdgeInsets.all(15.5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.5)),
            child: Icon(
              Icons.videocam_outlined,
              color: Colors.grey.shade800,
            ),
          )
        ), );
  }

  Positioned positionedPageView(
      BuildContext context, VehiclesModel vehiclesModel) {
    int selectedValue = 0;
    late LongdoLocationCubit? longdoCubit =
    LongdoLocationCubit(getIt<TrackingRepository>());

    // context.read<MapsClusterCubit>().changeMarker(selectedValue, completed.data![selectedValue]);
    return
      Positioned(
        height: 230,
        bottom: 10,
        right: 0,
        left: -context.dynamicWidth(0.07),
        child: PageView.builder(
            onPageChanged: (value) {
              print('PAGE_CHANGE $value');
              trackingRepository!.setCardVehicleIndex(value);
              trackingRepository!.setVehicleNumber(vehiclesModel.data![value].name!);
              trackingRepository!.setVehicleModelData(vehiclesModel.data![value]);
              print('PAGE_CHANGE_NUM ${trackingRepository!.cardVehicleIndex}');
              context
                  .read<MapsClusterCubit>()
                  .changeMarker(value, vehiclesModel.data![value],BlocProvider.of<LongdoLocationCubit>(context));
            },
            itemCount: vehiclesModel.data!.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index){
              // dataPrinter() async{
              //   print("LONGDO_DATA");
              //   var result = await fetchLongdoLocation(widget.lat.toString(), widget.lng.toString());
              //   print("LONGDO_DATA_RES");
              //   print(result![0]);
              // }
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, CarInfoMenu.route,
                      arguments: ScreenArguments(
                          vehiclesModel.data![index].name!));
                },

                child: VehicleCard(
                  iconUrl: vehiclesModel.data![index].statusIcon,
                  routeName: 'Render',
                  carNumber: vehiclesModel.data![index].name,
                  driverName:  vehiclesModel.data![index].driverName !=null ? vehiclesModel.data![index].driverName! : '-' ,
                  speed: vehiclesModel.data![index].speed.toString(),
                  speedUnit: translate('tracking_page.kmhr'),
                  temperature: vehiclesModel.data![index].temp.toString(),
                  temperatureUnit: translate('tracking_page.c'),
                  fuel: vehiclesModel.data![index].fuel.toString(),
                  fuelUnit: translate('tracking_page.l'),
                  lat: vehiclesModel.data![index].lat,
                  lng: vehiclesModel.data![index].lon ,
                  time: vehiclesModel.data![index].durationInHms,
                  duration: vehiclesModel.data![index].duration,
                  updatedAt: vehiclesModel.data![index].updatedAt,
                ),
              );
            }));
  }
  // List<LongdoLocation> parseLongdoLocations(var responseBody) {
  //   // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  //   return responseBody.map<LongdoLocation>((json) =>LongdoLocation.fromJson(json)).toList();
  // }

// _getHttp(String lon, String lat) async {
//     try {
//       var response = await Dio().get('http://api.longdo.com/map/services/addresses',
//           queryParameters: {'locale': 'en','lon[]':lon ,'lat[]': lat,'key':'078388adf4e2609e085f0b8225c6d325'});
//       print("LONGDO_RESPONSE");
//       print(response.data[0].province);
//       return "UUUUEEE";
//     } catch (e) {
//       print(e);
//     }
//
//   }

}
