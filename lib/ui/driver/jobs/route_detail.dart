import 'dart:convert';

import 'package:fleetmanagement/bloc/route_plan_detail/route_plan_detail_bloc.dart';
import 'package:fleetmanagement/data/driver_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/ui/check_state.dart';
import 'package:fleetmanagement/ui/driver/jobs/jobs.dart';
import 'package:fleetmanagement/ui/driver/jobs/sign_board.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/simple_info_card.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/restart_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/routeplan/route_plan_bloc.dart';
import '../../../bloc/start_job/start_job_bloc.dart';
import '../../home/driver_home_index.dart';
import '../../splash/loading_splash_driver.dart';
import '../../splash/splash_screen.dart';
import '../../widgets/snackbar.dart';

class RouteDetail extends StatefulWidget {
  static const String route = '/route_detail';
  const RouteDetail({Key? key}) : super(key: key);

  @override
  _RouteDetailState createState() => _RouteDetailState();
}

class SignBoardParam {
  int? id;
  String? appBarTitle;
  SignBoardParam({this.id,this.appBarTitle});
}

class _RouteDetailState extends State<RouteDetail> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isStartedJob = false;
  bool isFinishedJob = false;
  List<Coords> waypoints = [];
  @override
  void initState() {

  }

  Position? _currentPosition;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as JobArguments;
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (BuildContext context) {
            return RoutePlanDetailBloc(getIt<DriverRepository>())
              ..add(GetRoutePlanDetails(id: args.id));
          },

      ),
      BlocProvider(
        create: (BuildContext context) {
          return StartJobBloc(getIt<DriverRepository>());
        },

      ),
      BlocProvider<RoutePlanBloc>(create: (context) {
        return RoutePlanBloc(getIt<DriverRepository>());
      }),
    ], child: Scaffold(
        appBar: AppbarPage(
          title: args.routeName,
        ),
        body: BlocBuilder<RoutePlanDetailBloc, RoutePlanDetailState>(
          builder: (context, state) {
            if (state is FailedInternetConnection) {
              ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
                  color: Colors.redAccent);
            }
            if (state is RoutePlanDetailLoaded) {
              if (state.routePlanDetailModel!.success!) {
                if(state.routePlanDetailModel!.data!.isStarted!){
                  isStartedJob = true;
                }else{
                  isStartedJob = false;
                }

                if(state.routePlanDetailModel!.data!.isFinish!){
                  isFinishedJob = true;
                }else{
                  isFinishedJob = false;
                }

                for(int i=0; i < state.routePlanDetailModel!.data!.points!.length; i++){

                  waypoints.add(Coords(double.parse(state.routePlanDetailModel!.data!.points![i].lat!), double.parse(state.routePlanDetailModel!.data!.points![i].lng!)));
                }

                // print('Way Points');
                // print('${waypoints[0].latitude},${waypoints[0].longitude}' );
                // print('${waypoints[1].latitude},${waypoints[1].longitude}' );
                // print('${waypoints[2].latitude},${waypoints[2].longitude}' );

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(padding: EdgeInsets.all(15.5)),

                      BlocListener<StartJobBloc,StartJobStateState>(listener: (context,state){
                        if (state is StartJobCreated) {
                         setState(() {
                           isStartedJob = true;
                         });
                         BlocProvider.of<RoutePlanBloc>(context).add(const GetRoutePlan());
                          print('ISSTARTED $isStartedJob');
                          Alert(

                            context: context,
                            type: AlertType.success,
                            title: "SUCCESS",
                            desc: translate('driver.job_start_successfully'),
                            buttons: [
                              DialogButton(
                                child: Text(
                                  translate('ok'),
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => SchedulerBinding.instance.addPostFrameCallback((_) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      DriverHomeIndex.route, (Route<dynamic> route) => false);
                                }),
                                // onPressed: () => Navigator.pushReplacementNamed(context,DriverHomeIndex.route),
                                // onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      },
                        child:  Visibility(
                          visible: !isStartedJob,
                          child:  InkWell(
                            onTap: () {
                              print("CLICK START");
                              // if (state.routePlanDetailModel!.data!.startTime!.isNotEmpty ) {
                              //   print("CLICK START");
                              BlocProvider.of<StartJobBloc>(context)
                                  .add(StartJobPost(id:state.routePlanDetailModel!.data!.id!));
                              // RoutePlanDetailBloc(getIt<DriverRepository>())
                              //   ..add(StartJob(id:state.routePlanDetailModel!.data!.id!));
                              // BlocProvider.of<RoutePlanDetailBloc>(context).add(StartJob(id:state.routePlanDetailModel!.data!.id!));
                              // }

                            },
                            child: Container(
                              width: mediaQuery.size.width,
                              padding: const EdgeInsets.all(22.0),
                              margin: const EdgeInsets.only(
                                  bottom: 19, left: 12, right: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.5),
                                  shape: BoxShape.rectangle,
                                  color: state
                                      .routePlanDetailModel!.data!.startTime! !=''
                                      ? HexColor('#91ACD3')
                                      : HexColor('#1D75FA')),
                              child:  Center(
                                child: Text(
                                  translate('driver.start_job'),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        )),
                      //Finished Job Button
                    isFinishedJob ?  Container() : Visibility(
                       visible: isStartedJob,
                       child:  InkWell(
                       onTap: () {
                         Navigator.pushNamed(context, SignBoard.route,
                             arguments: SignBoardParam(
                                 id: args.id,
                                 appBarTitle: state.routePlanDetailModel!
                                     .data!.driverName!));
                       },
                       child: Container(
                         width: mediaQuery.size.width,
                         padding: const EdgeInsets.all(22.0),
                         margin: const EdgeInsets.only(
                             bottom: 19, left: 12, right: 12),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10.5),
                             shape: BoxShape.rectangle,
                             color: state
                                 .routePlanDetailModel!.data!.isFinish!
                                 ? HexColor('#9BA0A8')
                                 : HexColor('#434A53')),
                         child:  Center(
                           child: Text(
                             translate('driver.finish_job'),
                             style: TextStyle(
                                 color: Colors.white, fontSize: 18),
                           ),
                         ),
                       ),
                     ),),

                      //vehicle
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        child: Text(
                          translate('driver.vehicle'),
                          style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              color: Colors.grey.shade600),
                        ),
                      ),
                      SimpleInfoCard(
                          primaryText:  translate('driver.vehicle_name'),
                          secondaryText: state
                              .routePlanDetailModel!.data!.vehicleLicense!),
                      SimpleInfoCard(
                          primaryText: translate('driver.vehicle_type'),
                          secondaryText: state
                              .routePlanDetailModel!.data!.vehicleType!),
                      SimpleInfoCard(
                          primaryText:  translate('driver.state'), secondaryText: '-'),
                      SimpleInfoCard(
                          primaryText:  translate('driver.address'), secondaryText: '- '),
                      const Padding(padding: EdgeInsets.all(12.5)),

                      // Location Button
                      GestureDetector(
                        onTap: () async{
                          // Phoenix.rebirth(context);
                         await _determinePosition();
                         Future.delayed(Duration(seconds: 1));
                          final availableMaps = await MapLauncher.installedMaps;

                          await availableMaps.first.showMarker(
                              coords: Coords(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude),
                              title: 'DGF Tracking');
                        },
                        child: Container(
                          width: mediaQuery.size.width,
                          padding: const EdgeInsets.all(22.0),
                          margin: const EdgeInsets.only(
                              bottom: 19, left: 12, right: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.5),
                              shape: BoxShape.rectangle,
                              color: HexColor('#2CC3BE')),
                          child:  Center(
                            child: Text(
                              translate('driver.location'),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ),

                      // Directions from current location
                      InkWell(
                        onTap: () async{
                          await _determinePosition();
                          Future.delayed(Duration(seconds: 1));
                          final availableMaps = await MapLauncher.installedMaps;

                          // _launchURL('https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate');
                          // _launchURL('https://www.google.com/maps/dir/?api=1&origin=14.36969332,101.55932441&destination=13.77331500,100.63037100&waypoints=13.77232600,100.62901800|13.77356000, 100.63035600|13.77343200,100.62944800&travelmode=driving&dir_action=navigate');

                          await availableMaps.first.showDirections(
                            waypoints: waypoints,
                              destinationTitle: state.routePlanDetailModel!.data!.end!,
                            origin: Coords(double.parse(state.routePlanDetailModel!.data!.startLocation!.lat!), double.parse(state.routePlanDetailModel!.data!.startLocation!.lon!)),
                              destination: Coords(
                                double.parse(state.routePlanDetailModel!.data!.endLocation!.lat!),
                                  double.parse(state.routePlanDetailModel!.data!.endLocation!.lon!)),

                            originTitle: state.routePlanDetailModel!.data!.start,);
                        },
                        child: Container(
                          width: mediaQuery.size.width,
                          padding: const EdgeInsets.all(22.0),
                          margin: const EdgeInsets.only(
                              bottom: 19, left: 12, right: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.5),
                              shape: BoxShape.rectangle,
                              color: HexColor('#5B78FA')),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.only(right: 13.0),
                              child:  Text(
                                 translate('driver.directions_from_current_location'),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18)),
                            ),
                          ),
                        ),
                      ),

                      //Route Point
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        child: Text(
                          translate('driver.route_point'),
                          style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              color: Colors.grey.shade600),
                        ),
                      ),

                      SimpleInfoCard(
                          primaryText: translate('driver.start'),
                          secondaryText:
                          state.routePlanDetailModel!.data!.start!),
                      SizedBox(
                        height: (state.routePlanDetailModel!.data!.points!
                            .length) *
                            55.95,
                        child: ListView.builder(
                            itemCount: state
                                .routePlanDetailModel!.data!.points!.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return SimpleInfoCard(
                                  primaryText: '${translate('driver.point')} ${index + 1}',
                                  secondaryText: state.routePlanDetailModel!
                                      .data!.points![index].pointName!);
                            }),
                      ),
                      SimpleInfoCard(
                          primaryText: translate('driver.end'),
                          secondaryText:
                          state.routePlanDetailModel!.data!.end!),

                      const Padding(padding: EdgeInsets.all(12.5)),

                      Container(
                        width: mediaQuery.size.width,
                        padding: const EdgeInsets.all(22.0),
                        margin: const EdgeInsets.only(
                            bottom: 19, left: 12, right: 12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.5),
                            shape: BoxShape.rectangle,
                            color:Colors.grey),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.only(right: 13.0),
                            child:  Text(translate('driver.directions'),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ),
                        ),
                      ),

                      const Padding(padding: EdgeInsets.all(12.5)),

                      //Route Point
                      Container(
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        child: Text(
                          translate('driver.route'),
                          style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              color: Colors.grey.shade600),
                        ),
                      ),

                      SimpleInfoCard(
                          primaryText: translate('driver.route_name'),
                          secondaryText:
                          state.routePlanDetailModel!.data!.routeName!),
                      SimpleInfoCard(
                          primaryText: translate('driver.driver'),
                          secondaryText: state
                              .routePlanDetailModel!.data!.driverName!),
                      SimpleInfoCard(
                          primaryText: translate('driver.estimated_total_distance'),
                          secondaryText: state.routePlanDetailModel!.data!
                              .estimatedTotalDistance!
                              .toString() + 'km'),
                      SimpleInfoCard(
                          primaryText: translate('driver.estimated_total_duration'),
                          secondaryText: state.routePlanDetailModel!.data!
                              .estimatedTotalDuration!
                              .toString()),
                      SimpleInfoCard(
                          primaryText: translate('driver.actual_total_distance'),
                          secondaryText: state.routePlanDetailModel!.data!
                              .actualTotalDistance!
                              .toString()+'km'),
                      SimpleInfoCard(
                          primaryText: translate('driver.actual_total_duration'),
                          secondaryText: state.routePlanDetailModel!.data!
                              .actualTotalDuration!
                              .toString()),
                      const Padding(padding: EdgeInsets.all(12.5)),
                    ],
                  ),
                );
              } else {
                return  Center(
                  child: Text(
                    translate('there_is_no_route_detail'),
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                    ),
                  ),
                );
              }
            }
            if (state is RoutePlanDetailLoading){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )));

  }


  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
     await Geolocator.getCurrentPosition().then((Position position){
      setState(() {
        _currentPosition = position;
      });
    }).catchError((error){
      print('GEO LOCATOR ERROR ${error.toString()}');
    });
  }

}
