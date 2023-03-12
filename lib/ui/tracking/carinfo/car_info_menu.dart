import 'package:fleetmanagement/bloc/cubit/live_video_link/live_video_link_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/live_video_link/live_video_link_state.dart';
import 'package:fleetmanagement/bloc/vehiclesDetail/vehicles_detail_bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/setting/components/setting_card.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker_web.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/playback_filter.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/route_description.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking/tracking.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_filter.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../maps/view/cluster_points_view.dart';
import 'driver_information.dart';
import 'livevideo/live_video_and_map.dart';
import 'livevideo/web_video_test.dart';

class CarInfoMenu extends StatefulWidget {
  static const String route = '/car_info_menu';
  const CarInfoMenu({Key? key}) : super(key: key);

  @override
  _CarInfoMenuState createState() => _CarInfoMenuState();
}

class DriverArguments {
  final String? drivername;
  final String? driverLicense;
  final String? startDate;
  final String? type;

  DriverArguments(
      {this.drivername, this.driverLicense, this.startDate, this.type});
}

class PlaybackFilterArguments {
  String? license;
  String? fromWidget;

  PlaybackFilterArguments({this.license, this.fromWidget});
}

class JobDesArguments {
  final String? name;
  final String? time;
  final String? status;
  final String? vehicle;
  final String? driver;
  final String? registrationDate;
  final String? distination;
  final String? note;

  JobDesArguments(
      {this.name,
      this.time,
      this.status,
      this.vehicle,
      this.driver,
      this.registrationDate,
      this.distination,
      this.note});
}

class RouteDesArguments {
  final String? name;
  final String? vehicle;
  final String? drivername;
  final String? estimatedTotalDistance;
  final String? estimatedTotalDuration;
  final String? acturalTotalDistance;
  final String? acturalTotalDuration;

  RouteDesArguments(
      {this.name,
      this.vehicle,
      this.drivername,
      this.estimatedTotalDistance,
      this.estimatedTotalDuration,
      this.acturalTotalDistance,
      this.acturalTotalDuration});
}

class VehicleArguments {
  String? license;
  String? status;
  String? speed;
  String? speedUnit;
  String? temperature;
  String? temperatureUnit;
  String? oil;
  String? oilUnit;
  String? mapIcon;

  VehicleArguments(
      {this.license,
      this.status,
      this.speed,
      this.speedUnit,
      this.temperature,
      this.temperatureUnit,
      this.oil,
      this.oilUnit,
      this.mapIcon});
}

class TrackingHistoryFilterArguments {
  String? license;

  TrackingHistoryFilterArguments({this.license});
}

class _CarInfoMenuState extends State<CarInfoMenu> with SingleTickerProviderStateMixin{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late Animation<double> _animation;
  late AnimationController _animationController;

  int zoom = 18;
  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void generateLiveVideoLink(BuildContext contextX, String license) async{

    print('LICENSE LIVELINK');
    Future.microtask(() {
      contextX
          .read<LiveVideoLinkCubit>()
          .fetchLiveVideoLink(license);
    });
  }



  @override
  Widget build(BuildContext context) {
    // vehiclesDetailBloc = BlocProvider.of<VehiclesDetailBloc>(context);
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    final state = context.watch<LiveVideoLinkCubit>().state;
    // VehiclesDetailBloc vehiclesDetailBloc = context.read<VehiclesDetailBloc>();
    // vehiclesDetailBloc.add(GetVehiclesDetails(license: args.license,status: "1"));
    // vehiclesDetailBloc!.add(GetVehiclesDetails(license: args.license,status: "1"));

    FloatingActionBubble floatingActionBubble(){
      return FloatingActionBubble(
        // Menu items
        items: <Bubble>[

          // Floating action menu item
          Bubble(
            title:"Live Video Link",
            iconColor :Colors.white,
            bubbleColor : Colors.blue,
            icon:LineIcons.video,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              generateLiveVideoLink(context,args.license);
              context
                  .read<LiveVideoLinkCubit>()
                  .share();
              _animationController.reverse();
            },
          ),
          // Floating action menu item
          Bubble(
            title:"Live Location Link",
            iconColor :Colors.white,
            bubbleColor : Colors.blue,
            icon:LineIcons.locationArrow,
            titleStyle:TextStyle(fontSize: 16 , color: Colors.white),
            onPress: () {
              generateLiveVideoLink(context,args.license);
              context
                  .read<LiveVideoLinkCubit>()
                  .share();
              _animationController.reverse();
            },
          ),
          //Floating action menu item

        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: Colors.blue,

        // Flaoting Action button Icon
        iconData: Icons.share,
        backGroundColor: Colors.white,
      );

    }

    return MultiBlocProvider(
        providers: [

          BlocProvider<VehiclesDetailBloc>(
              create: (BuildContext context) =>
                  VehiclesDetailBloc(getIt<TrackingRepository>())),


        ],
        child: Scaffold(
            backgroundColor: Colors.blueGrey.shade50,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: floatingActionBubble(),
            appBar:  AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              iconTheme: const IconThemeData(color: Colors.black87),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context,true),
              ) ,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              title: Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      args.license!,
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                  )),
            ),
            body: SafeArea(
              child: BlocBuilder<VehiclesDetailBloc, VehiclesDetailState>(
                builder: (context, state) {
                  if (state is VehiclesDetailInitial) {
                    print('VEHICLEDETAILINITIAL');
                    context.read<VehiclesDetailBloc>().add(
                        GetVehiclesDetails(license: args.license, status: "1"));
                  }

                  if (state is VehiclesDetailLoaded) {
                    return ListView(
                        children: [
                          const Padding(padding: EdgeInsets.all(10.10)),
                          SettingCard(
                            title: translate('car_info_menu_page.vehicle_name'),
                            color: '#00C6BF',
                            iconData: LineIcons.car,
                            isInfoExit: true,
                            info: args.license,
                          ),
                          SettingCard(
                            title: translate('car_info_menu_page.type_product'),
                            color: '#FF856F',
                            iconData: LineIcons.video,
                            isInfoExit: true,
                            info: 'MDVR',
                          ),
                          SettingCard(
                            title: translate('car_info_menu_page.camera'),
                            color: '#FFB341',
                            iconData: LineIcons.camera,
                            isInfoExit: true,
                            info: '',
                          ),
                          InkWell(
                            onTap: () {
                              // ShowSnackBar.showWithScaffold(
                              //     _scaffoldKey, context, 'No Driver Information',
                              //     color: Colors.blueAccent);
                              if (state.vehiclesDetailModel!.vehiclesDetailData!
                                  .driver !=
                                  null) {
                                Navigator.pushNamed(context, DriverInformation.route,
                                    arguments: DriverArguments(
                                        drivername: state.vehiclesDetailModel!
                                            .vehiclesDetailData!.driverName,
                                        driverLicense: state
                                            .vehiclesDetailModel!
                                            .vehiclesDetailData!
                                            .driver!
                                            .licenseNumber,
                                        // startDate: state.vehiclesDetailModel.vehiclesDetailData.driver.
                                        type: state
                                            .vehiclesDetailModel!
                                            .vehiclesDetailData!
                                            .driver!
                                            .licenseType));
                              } else {
                                ShowSnackBar.showWithScaffold(
                                    _scaffoldKey, context, translate('no_driver_information'),
                                    color: Colors.blueAccent);
                              }
                            },
                            child: SettingCard(
                              title: translate('car_info_menu_page.driver'),
                              color: '#6481FF',
                              iconData: LineIcons.identificationCard,
                              isInfoExit: false,
                              info: '',
                            ),
                          ),
                          const Padding(padding: EdgeInsets.all(10.10)),
                          // InkWell(
                          //   onTap: () {
                          //     if (state.vehiclesDetailModel!.vehiclesDetailData!.planWork != null) {
                          //       Navigator.pushNamed(context, JobDescription.route,arguments: JobDesArguments(
                          //         name: state.vehiclesDetailModel!.vehiclesDetailData!.planWork!.name,
                          //         time: state.vehiclesDetailModel!.vehiclesDetailData!.planWork!.jobTime,
                          //         status: state.vehiclesDetailModel!.vehiclesDetailData!.planWork!.status,
                          //         vehicle: state.vehiclesDetailModel!.vehiclesDetailData!.planWork!.vehicleName,
                          //         driver: state.vehiclesDetailModel!.vehiclesDetailData!.planWork!.driverName,
                          //         note: state.vehiclesDetailModel!.vehiclesDetailData!.planWork!.note
                          //       ));
                          //     } else {
                          //       ShowSnackBar.showWithScaffold(_scaffoldKey, context, 'No Job Description', color: Colors.blueAccent);
                          //     }
                          //
                          //   },
                          //   child: SettingCard(
                          //       title: 'Job Description',
                          //       color: '#FFCC36',
                          //       iconData: LineIcons.infoCircle,
                          //       isInfoExit: false,
                          //       info: ''),
                          // ),
                          InkWell(
                            onTap: () {
                              // ShowSnackBar.showWithScaffold(
                              //     _scaffoldKey, context, 'No Route Description',
                              //     color: Colors.blueAccent);
                              if (state.vehiclesDetailModel!.vehiclesDetailData!
                                  .routePlan !=
                                  null) {
                                Navigator.pushNamed(context, RouteDescription.route,
                                    arguments: RouteDesArguments(
                                      name: state.vehiclesDetailModel!
                                          .vehiclesDetailData!.routePlan!.routeName,
                                      vehicle: state.vehiclesDetailModel!
                                          .vehiclesDetailData!.routePlan!.vehicleName,
                                      drivername: state.vehiclesDetailModel!
                                          .vehiclesDetailData!.routePlan!.driverName,
                                      estimatedTotalDistance: state
                                          .vehiclesDetailModel!
                                          .vehiclesDetailData!
                                          .routePlan!
                                          .estimatedTotalDistance
                                          .toString(),
                                      estimatedTotalDuration: state
                                          .vehiclesDetailModel!
                                          .vehiclesDetailData!
                                          .routePlan!
                                          .estimatedTotalDuration
                                          .toString(),
                                      acturalTotalDistance: state
                                          .vehiclesDetailModel!
                                          .vehiclesDetailData!
                                          .routePlan!
                                          .actualTotalDistance
                                          .toString(),
                                      acturalTotalDuration: state
                                          .vehiclesDetailModel!
                                          .vehiclesDetailData!
                                          .routePlan!
                                          .actualTotalDuration
                                          .toString(),
                                    ));
                              } else {
                                ShowSnackBar.showWithScaffold(
                                    _scaffoldKey, context, translate('no_route_description'),
                                    color: Colors.blueAccent);
                              }
                            },
                            child: SettingCard(
                                title: translate('car_info_menu_page.route_description'),
                                color: '#9761EF',
                                iconData: LineIcons.infoCircle,
                                isInfoExit: false,
                                info: ''),
                          ),
                          const Padding(padding: EdgeInsets.all(10.10)),
                          InkWell(
                            onTap: () {
                              if (state.vehiclesDetailModel!.vehiclesDetailData!.deviceId!.isNotEmpty) {
                                showMaterialModalBottomSheet(
                                    clipBehavior: Clip.hardEdge,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(17)),
                                    elevation: 12,
                                    isDismissible: true,
                                    context: context,
                                    builder: (context) => ChannelPickerWeb(
                                      license: args.license,
                                      deviceId: state.vehiclesDetailModel!.vehiclesDetailData!.deviceId!,
                                      status: '1',
                                      speed: state.vehiclesDetailModel!
                                          .vehiclesDetailData!.speed
                                          .toString(),
                                      speedUnit: 'km/hr',
                                      temperature: state.vehiclesDetailModel!
                                          .vehiclesDetailData!.temp
                                          .toString(),
                                      temperatureUnit:'°C',
                                      oil: state
                                          .vehiclesDetailModel!.vehiclesDetailData!.fuel
                                          .toString(),
                                      oilUnit: 'L',
                                      mapIcon: state.vehiclesDetailModel!
                                          .vehiclesDetailData!.mapIcon,

                                      date: '',
                                      fromWidget: Strings.liveVideo,
                                    )
                                );
                              }  else {
                                ShowSnackBar.show(context, translate('there_is_no_device_id'));
                              }
                              // Navigator.pushNamed(
                              //   context,
                              //   LiveVideoAndMap.route,
                              //   arguments: VehicleArguments(
                              //       license: args.license,
                              //       status: '1',
                              //       speed: state.vehiclesDetailModel!
                              //           .vehiclesDetailData!.speed
                              //           .toString(),
                              //       speedUnit: 'km/hr',
                              //       temperature: state.vehiclesDetailModel!
                              //           .vehiclesDetailData!.temp
                              //           .toString(),
                              //       temperatureUnit:'°C',
                              //       oil: state
                              //           .vehiclesDetailModel!.vehiclesDetailData!.fuel
                              //           .toString(),
                              //       oilUnit: 'L',
                              //       mapIcon: state.vehiclesDetailModel!
                              //           .vehiclesDetailData!.mapIcon),
                              // );

                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.live_video_and_map'),
                                color: '#9761EF',
                                iconData: LineIcons.video,
                                isInfoExit: false,
                                info: ''),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Tracking.route,
                                arguments: VehicleArguments(
                                    license: args.license,
                                    status: '1',
                                    speed: '0',
                                    speedUnit: 'km/hr',
                                    temperature: state.vehiclesDetailModel!
                                        .vehiclesDetailData!.temp
                                        .toString(),
                                    temperatureUnit:'°C',
                                    oil: state
                                        .vehiclesDetailModel!.vehiclesDetailData!.fuel
                                        .toString(),
                                    oilUnit: 'L',
                                    mapIcon: state.vehiclesDetailModel!
                                        .vehiclesDetailData!.mapIcon),
                              );
                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.tracking'),
                                color: '#707070',
                                iconData: LineIcons.locationArrow,
                                isInfoExit: false,
                                info: ''),
                          ),

                          InkWell(
                            onTap: () {
                              // ShowSnackBar.showWithScaffold(_scaffoldKey, context, Strings.commingSoon,
                              //     color: Colors.blueGrey.shade700);
                              Navigator.pushNamed(context, PlaybackFilter.route,
                                  arguments: PlaybackFilterArguments(
                                      license: args.license,
                                      fromWidget: Strings.playbackVideo));
                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.video_playback'),
                                color: '#FFCD57',
                                iconData: LineIcons.playCircle,
                                isInfoExit: false,
                                info: ''),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, TrackingHistoryFilter.route,
                                  arguments: TrackingHistoryFilterArguments(
                                      license: args.license));
                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.tracking_history'),
                                color: '#EF6961',
                                iconData: LineIcons.barChart,
                                isInfoExit: false,
                                info: ''),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, TrackingHistoryFilter.route,arguments: TrackingHistoryFilterArguments(
                              //     license: args.license
                              // ));
                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.gallery'),
                                color: '#707070',
                                iconData: LineIcons.camera,
                                isInfoExit: false,
                                info: ''),
                          ),
                          InkWell(
                            onTap: () async {
                              // ShowSnackBar.showWithScaffold(
                              //     _scaffoldKey, context, 'No Route Description',
                              //     color: Colors.blueAccent);
                              final availableMaps = await MapLauncher.installedMaps;

                              await availableMaps.first.showMarker(
                                  coords: Coords(
                                      double.parse(state
                                          .vehiclesDetailModel!
                                          .vehiclesDetailData!
                                          .routePlan!
                                          .endLocation!
                                          .lat!),
                                      double.parse(state
                                          .vehiclesDetailModel!
                                          .vehiclesDetailData!
                                          .routePlan!
                                          .endLocation!
                                          .lon!)),
                                  title: 'DGF Tracking');
                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.destination'),
                                color: '#00C6BF',
                                iconData: LineIcons.locationArrow,
                                isInfoExit: false,
                                info: ''),
                          ),
                          InkWell(
                            onTap: () async {
                              // ShowSnackBar.showWithScaffold(
                              //     _scaffoldKey, context, 'No Route Description',
                              //     color: Colors.blueAccent);
                              final availableMaps = await MapLauncher.installedMaps;
                              await availableMaps.first.showDirections(
                                destination: Coords(
                                    state.vehiclesDetailModel!.vehiclesDetailData!
                                        .lat!,
                                    state.vehiclesDetailModel!.vehiclesDetailData!
                                        .lon!),
                                // destinationTitle: destinationTitle,
                                origin: Coords(
                                    double.parse(state
                                        .vehiclesDetailModel!
                                        .vehiclesDetailData!
                                        .routePlan!
                                        .endLocation!
                                        .lat!),
                                    double.parse(state
                                        .vehiclesDetailModel!
                                        .vehiclesDetailData!
                                        .routePlan!
                                        .endLocation!
                                        .lon!)),
                                // originTitle: originTitle,
                                // waypoints: waypoints,
                                directionsMode: DirectionsMode.driving,
                              );
                            },
                            child: SettingCard(
                                title:  translate('car_info_menu_page.direction_from_current_location'),
                                color: '#5A75FF',
                                iconData: LineIcons.mapMarker,
                                isInfoExit: false,
                                info: ''),
                          ),
                          const Padding(padding: EdgeInsets.all(10.10)),
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, MileageAnalytics.route);
                              ShowSnackBar.showWithScaffold(
                                  _scaffoldKey, context, Strings.commingSoon,
                                  color: Colors.blueGrey.shade700);
                            },
                            child: SettingCard(
                                title: translate('car_info_menu_page.mileage_analysis'),
                                color: '#FFB341',
                                iconData: LineIcons.barChart,
                                isInfoExit: false,
                                info: ''),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigator.pushNamed(context, FuelGraphIndex.route);
                              ShowSnackBar.showWithScaffold(
                                  _scaffoldKey, context, Strings.commingSoon,
                                  color: Colors.blueGrey.shade700);
                            },
                            child: SettingCard(
                                title: translate('car_info_menu_page.fuel_usage_graph'),
                                color: '#FF4D36',
                                iconData: LineIcons.barChart,
                                isInfoExit: false,
                                info: ''),
                          )
                        ]);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            )
        ),
    );
  }
}
