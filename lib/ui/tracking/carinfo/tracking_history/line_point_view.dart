import 'dart:async';
import 'package:fleetmanagement/bloc/cubit/tracking_history/line_tracking_history_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_history/line_tracking_history_state.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_history/tracking_history_cubit.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/trackinghistory/tracking_history_data.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_alarm_report.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/tracking_history/tracking_history_play.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:uuid/uuid.dart';

class LinePointView extends StatefulWidget {
  String? license;
  String? date;

  LinePointView({this.license, this.date});

  @override
  _LinePointViewState createState() => _LinePointViewState();
}

class TharArguments {
  String? license;
  String? date;

  TharArguments({this.license, this.date});
}

class TrackingHistoryPlayArguments {
  String? license;
  String? date;

  TrackingHistoryPlayArguments({this.license, this.date});
}

class _LinePointViewState extends State<LinePointView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final Completer<GoogleMapController> _controller = Completer();
  double zoomIndex=13;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppbarPage(
        title: 'Tracking History',
      ),
      body:
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
              print("TRACKING_HISTORY_LOADING");
              return const Center(
                child: CircularProgressIndicator(),
              );
            case TrackingHistoryCompleted:
              print("TRACKING_HISTORY_COMPLETED");

              var completed=state as TrackingHistoryCompleted;
              var data=completed.trackingHistoryModel!.data;
              SharedPreferenceHelper sharedPreferenceHelper=getIt<SharedPreferenceHelper>();
              sharedPreferenceHelper.persistMarkerSvg(data![0].icon.toString());

              return pointAndPlaceView(
                  state, context, mediaQuery);
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
              fetchPoints(context, widget.license!, widget.date!);
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
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
    return Stack(
      children: [
        pointsList(completed, context),
        trackingButton(context, mediaQuery),
        playButton(context, mediaQuery)
      ],
    );
  }

  Positioned trackingButton(BuildContext context, MediaQueryData mediaQuery) {
    return Positioned(
        right: 7,
        top: (mediaQuery.size.height / 2) - 86,
        bottom: (mediaQuery.size.height / 2) - 86,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, TrackingHistoryAlarmReport.route,
                arguments:
                    TharArguments(license: widget.license, date: widget.date));
          },
          child: Container(
            padding: const EdgeInsets.all(15.5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.5)),
            child: Icon(
              Icons.notifications,
              color: Colors.grey.shade800,
            ),
          ),
        ));
  }
  Positioned playButton(BuildContext context, MediaQueryData mediaQuery) {
    return Positioned(
        right: 7,
        top: (mediaQuery.size.height / 2) - 162,
        bottom: (mediaQuery.size.height / 2) - 6,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, TrackingHistoryPlay.route,
                arguments:
                TrackingHistoryPlayArguments(license: widget.license, date: widget.date));
          },
          child: Container(
            padding: const EdgeInsets.all(15.5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5.5)),
            child: Icon(
              Icons.play_arrow,
              color: Colors.grey.shade800,
            ),
          ),
        ));
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
        // else if (state is MapsMarkerChange) {
        //
        //   selectedLines = state.currentIndex;
        //   markers = context.watch<LineTrackingHistoryCubit>().markers;
        // }

        return GoogleMap(
            // zoomGesturesEnabled: true,
            // onMapCreated: (GoogleMapController controller) {
            //   _controller.complete(controller);
            // },
          onMapCreated: (controller) {
            context.read<LineTrackingHistoryCubit>().initMapControllerMarkers(
                controller, context, coordinates!.data!);
          },
          polylines: {polylineCreate(markers, selectedLines)},
          markers: Set.from(markers),

          // markers: <Marker>[
          //   Marker(
          //     markerId: MarkerId("0"),
          //     position: coordinates!.data!.first.coordinate,
          //     icon: BitmapDescriptor.defaultMarkerWithHue(
          //         BitmapDescriptor.hueAzure ),
          //     onTap: (){
          //       print("JDKJFDSLKJFKDSJFKF");
          //     }
          //   )
          // ].toSet(),
          // onTap: (value){
          //   print("THISISDJIF12 ${coordinates}");
          // },
          initialCameraPosition: CameraPosition(
              target: coordinates!.data!.first.coordinate, zoom: zoomIndex),

          // mapType: MapType.normal,
          // zoomControlsEnabled:true
        );
      },
    );
  }

  Polyline polylineCreate(List<Marker> markers, int selectedLines) {
    return Polyline(
        color: HexColor('#20BFB5'),
      // color: Colors.green,
        width: 3,
        polylineId: PolylineId(markers.length.toString()),
        points: markers.map((e) => e.position).toList(),
        consumeTapEvents: true,
        onTap: (){
          print("FDSKFJDSFJ fklsjgsdj");
          for(var marker in markers){
            _cameraMove(marker.position.latitude, marker.position.longitude);
          }
        }
        // onTap: () {
        //   final GoogleMapController controller =  _controller.future;
        //   print("FDSKFJDSFJ fklsjgsdj");
        // setState(() {
        //   zoomIndex=20;
        // });
        // for(var marker in markers){
        //   controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(marker.position.latitude, marker.position.longitude), 14));
        // }
        // }
    );
  }

  Future<void> _cameraMove(lat, lon) async {
    print("HFDJFSDJFK Lat $lat  Lon $lon");
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lon), 14));

    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
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
}
