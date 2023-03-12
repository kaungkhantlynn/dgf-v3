import 'dart:async';
import 'package:fleetmanagement/bloc/cubit/tracking_history/line_tracking_history_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_history/line_tracking_history_state.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_history/tracking_history_cubit.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/data/tracking_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_data.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/line_point_view.dart';
import 'package:fleetmanagement/ui/tracking/maps/marker_icon.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uuid/uuid.dart';

class TrackingHistoryPlay extends StatefulWidget {
  static const String route = '/tracking_history_play';

  @override
  _TrackingHistoryPlayState createState() => _TrackingHistoryPlayState();
}

class _TrackingHistoryPlayState extends State<TrackingHistoryPlay> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  double zoomIndex=13;
  late BitmapDescriptor myIcon;
  var coordinate=const LatLng(0, 0);
  bool setPlayTrack=false;
  var TrackingCoordinates;
  int fastSpeed=1600;
  int fastSpeedOptionIndex=0;
  bool videoEnd=false;
  var markerIcon;
  bool isReset=false;
  bool isPause=false;


  @override
  void initState() {
    // TODO: implement initState
    // addMarkers();

    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(70, 70)), 'assets/car.png')
        .then((onValue) {
      myIcon = onValue;
    });
    super.initState();
  }

  setMarkerIcon(BuildContext context) async{
    SharedPreferenceHelper sharedPreferenceHelper=getIt<SharedPreferenceHelper>();
    var icon=await sharedPreferenceHelper.markerSvg;
    markerIcon =  await MarkerIcon.fromSvgUrl(context,icon!);
  }

  playTrack(var coordinates)  async {
    setState(() {
      setPlayTrack=true;
      videoEnd=false;
    });
    var data = coordinates?.data!;
    print("FKDJFSJFKKFJ");
    print(data.length);
    for(int i=0;i<data.length;i++){
      print("FJDKJFJFJFFJSKJFJFF123 $isPause");
      if(isReset){
        i=0;
        setState(() {
          isReset=false;
        });
      }
      else if(isPause==true){
        await Future.delayed(const Duration(milliseconds: 1000), (){
          print("HH123");
          setState(() {
            i=--i;
          });
        });
      }
      else{
        await Future.delayed(Duration(milliseconds: fastSpeed), (){
          print("HH123");
          setState(() {
            coordinate=data[i].coordinate;
          });
        });
        if(data[i].coordinate==data!.last.coordinate){
          setState(() {
            videoEnd=true;
          });
        }
      }
    }
    // for(var i in data!){
    //   if(isReset){
    //     break;
    //   }
    //   else{
    //     await Future.delayed(Duration(milliseconds: fastSpeed), (){
    //       print("HH123");
    //       setState(() {
    //         coordinate=i.coordinate;
    //       });
    //     });
    //   }
    //   if(i==data.last){
    //     print("OKKKKKK DONEEEE");
    //     setState(() {
    //       videoEnd=true;
    //     });
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final args = ModalRoute.of(context)!.settings.arguments as TrackingHistoryPlayArguments;
    setMarkerIcon(context);
    // icon =  MarkerIcon.fromSvgUrl(context, args.markerSvg!);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppbarPage(
        title: translate('pp_bar.tracking_history'),
      ),
      body:
      MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  TrackingHistoryCubit(getIt<TrackingRepository>())),
          BlocProvider(create: (context) => LineTrackingHistoryCubit()),
        ],
        child:
        BlocConsumer<TrackingHistoryCubit, TrackingHistoryState>(
          listener: (context, state) {
            if (state.runtimeType == TrackingHistoryError) {
              print("TRACKING_HISTORY_ERROR");
              ShowSnackBar.showWithScaffold(scaffoldKey, context, 'Error');
            }
          },
          builder: (context, state) {
            switch (state.runtimeType) {
              case TrackingHistoryLoading:
              // return CircularProgressIndicator();
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case TrackingHistoryCompleted:
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  // Add Your Code here.
                  if(setPlayTrack==false){
                    var completed=state as TrackingHistoryCompleted;

                    playTrack(completed.trackingHistoryModel);

                    setState(() {
                      TrackingCoordinates=completed.trackingHistoryModel;
                    });
                  }
                });
                return pointAndPlaceView(
                    (state as TrackingHistoryCompleted), context, mediaQuery);
              case TrackingHistoryError:
                return Center(
                  child: Text((state as TrackingHistoryError).message),
                );

              case TrackingHistoryNoData:
                return Container(
                  child: const Center(
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 20, fontFamily: "Kanit"),
                    ),
                  ),
                );
              default:
                print('TRACKING_HISTORY_DEFAULT');
                fetchPoints(context, args.license!, args.date!);
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
      )
    );
  }

  void fetchPoints(BuildContext context, String license, String date) {
    print("FETCH_POINTS $license");
    Future.microtask(() {
      context.read<TrackingHistoryCubit>().fetchPoints(license, date);
    });
  }

  Widget pointAndPlaceView(TrackingHistoryCompleted completed,
      BuildContext context, MediaQueryData mediaQuery) {
    return pointsList(completed, context);
  }

  Widget pointsList(TrackingHistoryCompleted completed, BuildContext context) {
    final coordinates = completed.trackingHistoryModel;
    return BlocConsumer<LineTrackingHistoryCubit, LineTrackingHistoryState>(
      listener: (context, LineTrackingHistoryState state) {},
      builder: (context, state) {
        List<Marker> markers = [];
        int selectedLines = 0;
        if (state is LineTrackingHistoryStateMarkers) {
          markers = state.markers;
        }

        return
          Stack(
            children: [
              GoogleMap(
                zoomGesturesEnabled: true,
                onMapCreated: (controller) {
                  // controller!.animateCamera(CameraUpdate.newCameraPosition(
                  //     CameraPosition(target: markers.first.position, zoom: 15)));
                  context.read<LineTrackingHistoryCubit>().initMapControllerMarkers(
                      controller, context, coordinates!.data!);
                },

                polylines: {polylineCreate(markers, selectedLines)},
                // markers: Set.from(markers),

                markers: <Marker>{
                  Marker(
                      markerId: const MarkerId("markerID"),
                      position: coordinate,
                      icon:markerIcon
                  )
                },
                initialCameraPosition: CameraPosition(
                    target: coordinates!.data!.first.coordinate, zoom: zoomIndex),

                //additional add

                mapType: MapType.normal,

                rotateGesturesEnabled: false,

                tiltGesturesEnabled: false,

                mapToolbarEnabled: false,

                myLocationEnabled: false,

                myLocationButtonEnabled: false,

                zoomControlsEnabled: false,
              ),
              positionedVideoFunctions(),
            ],
          );
      },
    );
  }

  Polyline polylineCreate(List<Marker> markers, int selectedLines) {
    return Polyline(
      color: HexColor('#20BFB5'),
        width: 3,
        polylineId: PolylineId(markers.length.toString()),
        points: markers.map((e) => e.position).toList(),
        consumeTapEvents: true,
    );
  }

  Marker markerCreate(
      TrackingHistoryData e, BuildContext context, bool isSelected) {
    var uuid = const Uuid();
    return Marker(
      markerId: MarkerId(uuid.v4()),
      position: e.coordinate,
      icon: BitmapDescriptor.defaultMarkerWithHue(
          isSelected ? BitmapDescriptor.hueAzure : BitmapDescriptor.hueOrange),
    );
  }


  Positioned positionedVideoFunctions(){
    return
      Positioned(
        height: 70,
        bottom: 10,
        left: 20,
        right: 20,

        child:
            Container(
              // alignment: Alignment.center,
              // margin: EdgeInsets.only(left: 10,right: 10),
              color: Colors.white,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        fastSpeed=500;
                        fastSpeedOptionIndex=0;
                        isPause=false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left:30),
                      decoration: const BoxDecoration(
                        color: Colors.white,),
                      child: Icon(
                        Icons.fast_forward,
                        size: 30,
                        color: fastSpeedOptionIndex==0?Colors.black:Colors.black38,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        fastSpeed=1100;
                        fastSpeedOptionIndex=1;
                        isPause=false;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,),
                      child: Icon(
                        Icons.skip_next,size: 30,
                        color: fastSpeedOptionIndex==1?Colors.black:Colors.black38,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("ISS kfja $isPause");
                      setState(() {
                        fastSpeed=1600;
                        fastSpeedOptionIndex=2;
                        isPause=false;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,),
                      child: Icon(
                        Icons.play_arrow,
                        size: 30,
                        color: fastSpeedOptionIndex==2?Colors.black:Colors.black38,
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      setState(() {
                        isPause=true;
                        fastSpeedOptionIndex=3;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,),
                      child: Icon(
                        Icons.pause,
                        size: 30,
                        color: fastSpeedOptionIndex==3?Colors.black:Colors.black38,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if(videoEnd==true){
                        playTrack(TrackingCoordinates);
                      }
                      else{
                        setState(() {
                          isReset=true;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right:30),
                      decoration: const BoxDecoration(
                        color: Colors.white,),
                      child: const Icon(
                          Icons.replay,
                          size: 30,
                          color: Colors.black
                      ),
                    ),
                  ),
                ],
              ))
            );
  }
}
