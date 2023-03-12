import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_state.dart';
import 'package:fleetmanagement/bloc/cubit/tracking_vehicle/maps_tracking_state.dart';
import 'package:fleetmanagement/models/vehicles_detail/vehicles_detail_model.dart';
import 'package:fleetmanagement/ui/tracking/maps/view/widget/alarm_list.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../../bloc/cubit/live_video_link/live_video_link_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/maps_tracking_cubit.dart';
import '../../../../constants/strings.dart';
import '../../carinfo/components/channel_picker.dart';
import 'widget/street_view.dart';
import 'package:fleetmanagement/ui/tracking/maps/marker_icon.dart';

class TrackingPointView extends StatefulWidget {
  // LiveTrackData? liveTrackData;
  bool? alarmVisible;
  String? license;
  VehiclesDetailModel? vehiclesDetailModel;
  TrackingPointView({this.alarmVisible,this.license, this.vehiclesDetailModel});

  @override
  _TrackingPointViewState createState() => _TrackingPointViewState();
}

class _TrackingPointViewState extends State<TrackingPointView> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey globalKey = GlobalKey();

  bool? isVisibleStreetView = true;
  bool? isVisibleMap = true;
  var  markerIconCustom = BitmapDescriptor.defaultMarker;

  late Animation<double> _animation;
  late AnimationController _animationController;

  int zoom = 18;

  @override
  void initState() {
    addCustomIcon();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  void addCustomIcon() async{
    markerIconCustom =  await MarkerIcon.fromSvgUrl(context, widget.vehiclesDetailModel!.vehiclesDetailData!.mapIcon!);
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
    print('ISVISIBLE_ALARM ${widget.alarmVisible}');
    print('INIT_STREETVIEW ${widget.vehiclesDetailModel!.vehiclesDetailData!.coordinate.latitude},${widget.vehiclesDetailModel!.vehiclesDetailData!.coordinate.longitude}');
    var mediaQuery = MediaQuery.of(context);
    // print("TRACKINGMAP "+trackingmap!.vehiclesDetailData!.status!);
    // context
    //     .read<StreetViewTrackingCubit>()
    //     .animatePosition(widget.vehiclesDetailModel);

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
              generateLiveVideoLink(context,widget.license!);
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
              generateLiveVideoLink(context,widget.license!);
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
    return Scaffold(
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
                translate('app_bar.tracking'),
                style: TextStyle(color: Colors.grey.shade800),
              ),
            )),
        actions: [
          isVisibleStreetView! && isVisibleMap!? InkWell(
            onTap: (){
              setState(() {
                isVisibleMap = false;
                isVisibleStreetView = true;
              });
            },
            child:   Container(
                padding: EdgeInsets.all(4.4),
                margin: EdgeInsets.only(right: 3),
                child : Icon(Icons.streetview)
            ),
          ) : Container(),

          !isVisibleMap! && isVisibleStreetView! ? InkWell(
            onTap: (){
              setState(() {
                isVisibleMap = true;
                isVisibleStreetView = true;
              });
            },
            child:   Container(
                padding: EdgeInsets.all(4.4),
                margin: EdgeInsets.only(right: 3),
                child : Icon(Icons.streetview,color: Colors.green,)
            ),
          ) : Container(),
          isVisibleMap! && isVisibleStreetView!?   InkWell(
            onTap: (){
              setState(() {
                isVisibleStreetView = false;
                isVisibleMap = true;
              });
            },
            child: Container(
                padding: EdgeInsets.all(4.4),
                margin: EdgeInsets.only(right: 20),
                child : Icon(Icons.map)
            ),
          ) : Container(),
          !isVisibleStreetView! && isVisibleMap! ?
          InkWell(
            onTap: (){
              setState(() {
                isVisibleMap = true;
                isVisibleStreetView = true;
              });
            },
            child: Container(
                padding: EdgeInsets.all(4.4),
                margin: EdgeInsets.only(right: 20),
                child : Icon(Icons.map,color: Colors.green,)
            ),
          ) : Container()
        ],
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: isVisibleStreetView!,
                  child: Expanded(

                      child: StreetView(
                    latitude: widget.vehiclesDetailModel!.vehiclesDetailData!
                        .coordinate.latitude,
                    longitude: widget.vehiclesDetailModel!.vehiclesDetailData!
                        .coordinate.longitude,
                    vehiclesDetailModel: widget.vehiclesDetailModel,
                  )
                  ),
                ),
                Visibility(
                  visible: isVisibleMap!,
                  child: Expanded(

                      child: trackingMapView(
                          widget.vehiclesDetailModel!, mediaQuery, context)),
                )
              ],
            ),
            // Visibility(
            //   visible:
            //       !checkControlVisible(isVisibleMap!, isVisibleStreetView!),
            //   child: Positioned(
            //       top: (mediaQuery.size.height / 2) - 110,
            //       bottom: (mediaQuery.size.height / 2) - 110,
            //       child: Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           InkWell(
            //             onTap: () {
            //               setState(() {
            //                 isVisibleMap = false;
            //                 isVisibleStreetView = true;
            //               });
            //             },
            //             child: Container(
            //               padding: const EdgeInsets.only(
            //                   left: 12, right: 12, top: 1.5, bottom: 1.5),
            //               decoration: const BoxDecoration(
            //                   color: Colors.white70,
            //                   borderRadius: BorderRadius.only(
            //                       topLeft: Radius.circular(12),
            //                       topRight: Radius.circular(12))),
            //               child: const Icon(Icons.keyboard_arrow_up),
            //             ),
            //           ),
            //           InkWell(
            //             onTap: () {
            //               isVisibleStreetView = false;
            //               isVisibleMap = true;
            //             },
            //             child: Container(
            //               padding: const EdgeInsets.only(
            //                   left: 12, right: 12, top: 1.5, bottom: 1.5),
            //               decoration: const BoxDecoration(
            //                   color: Colors.white70,
            //                   borderRadius: BorderRadius.only(
            //                       bottomLeft: Radius.circular(12),
            //                       bottomRight: Radius.circular(12))),
            //               child: const Icon(Icons.keyboard_arrow_down),
            //             ),
            //           )
            //         ],
            //       )),
            // ),
            // Visibility(
            //   visible: checkControlVisible(isVisibleMap!, isVisibleStreetView!),
            //   child: Positioned(
            //       top: 0.0,
            //       child: InkWell(
            //         onTap: () {
            //           setState(() {
            //             isVisibleMap = true;
            //             isVisibleStreetView = true;
            //           });
            //         },
            //         child: Container(
            //           padding: const EdgeInsets.only(
            //               left: 12, right: 12, top: 1.5, bottom: 1.5),
            //           decoration: const BoxDecoration(
            //               color: Colors.white70,
            //               borderRadius: BorderRadius.only(
            //                   bottomLeft: Radius.circular(12),
            //                   bottomRight: Radius.circular(12))),
            //           child: const Icon(Icons.keyboard_arrow_down),
            //         ),
            //       )),
            // ),

            //noticard
        // widget.vehiclesDetailModel!.vehiclesDetailData!.alarms!.isNotEmpty && widget.alarmVisible!?
        // Positioned(
        //   top: 30,
        //   left: 15,
        //   right: 15,
        //   child: Container(
        //     padding: const EdgeInsets.all(20),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(30),
        //         color: HexColor( widget.vehiclesDetailModel!.vehiclesDetailData!.alarms![0].color!)),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.start,
        //       crossAxisAlignment: CrossAxisAlignment.end,
        //       children: [
        //         const Icon(Icons.more_vert,color: Colors.white,),
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.start,
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Column(
        //               mainAxisAlignment: MainAxisAlignment.start,
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //
        //                 Text(
        //                   widget.vehiclesDetailModel!.vehiclesDetailData!.alarms![0].name!,
        //                   style: const TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w600,
        //                       fontSize: 17),
        //                 ),
        //                 const Padding(padding: EdgeInsets.all(5.5)),
        //                 Text(
        //                   widget.vehiclesDetailModel!.vehiclesDetailData!.alarms![0].description!,
        //                   style: const TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w500,
        //                       fontSize: 17),
        //                 ),
        //                 Text(
        //                   widget.vehiclesDetailModel!.vehiclesDetailData!.alarms![0].startTime!,
        //                   style: const TextStyle(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w500,
        //                       fontSize: 17),
        //                 ),
        //                 const Padding(padding: EdgeInsets.all(1.5)),
        //
        //               ],
        //             ),
        //
        //           ],
        //         )
        //       ],
        //     ),
        //   ),
        // ) : Container(),

            //vehicle card
            Positioned(
              bottom: 30,
              left: 15,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:
                        checkControlVisible(isVisibleMap!, isVisibleStreetView!)
                            ? Colors.white70
                            : Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.more_vert),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(

                              children:  [
                                const Icon(Icons.location_on),
                               BlocBuilder<LongdoLocationCubit,LongdoLocationState>(
                                   builder: (context,state){

                                     if (state is LongdoLocationCompleted) {
                                       // var province = state.longdoLocation![0].province!
                                       return Container(
                                         padding: const EdgeInsets.only(bottom: 30),
                                         width: 150,
                                         child: Text(
                                           // 'N/A',
                                           ' ${state.longdoLocation![0].province!} ${state.longdoLocation![0].subdistrict!} ${state.longdoLocation![0].district!}' ,

                                           style: const TextStyle(
                                               fontWeight: FontWeight.w600,
                                               fontSize: 17),
                                           maxLines: 2,
                                         ),
                                       );
                                     }
                                     return const Text('--');
                                   })
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(1.5)),
                            Wrap(
                              spacing: 5.5,
                              children: [
                                const Icon(Icons.local_taxi),
                                Text(
                                  widget.license!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.all(1.5)),
                            Wrap(
                              spacing: 5.5,
                              children:  [
                                const Icon(Icons.credit_card),
                                Container(
                                  width: 150,
                                  child: Text(

                                    widget.vehiclesDetailModel!.vehiclesDetailData!.driverName !=null ? widget.vehiclesDetailModel!.vehiclesDetailData!.driverName! : 'N/A',
                                    style: const TextStyle(

                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(10)),
                        Wrap(
                          runAlignment: WrapAlignment.start,
                          spacing: 30,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.vehiclesDetailModel!
                                      .vehiclesDetailData!.speed
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'km/hr',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.vehiclesDetailModel!
                                      .vehiclesDetailData!.temp
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                 '°C',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.vehiclesDetailModel!
                                      .vehiclesDetailData!.fuel
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'L',
                                  style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.all(10))
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget trackingMapView(VehiclesDetailModel trackingmap,
      MediaQueryData mediaQuery, BuildContext context) {
    print('UPDATE_LIVE_TRACKING');
    context.read<MapsTrackingCubit>().changeMarker(trackingmap);

    return Stack(
      children: [
        GoogleMap(
          compassEnabled: true,
          // onMapCreated: (controller) {
          //   context.read<MapsTrackingCubit>().initMapController(
          //       controller, context, trackingmap.vehiclesDetailData!);
          // },

          markers: {
            Marker(
              markerId:MarkerId( trackingmap.vehiclesDetailData!.id!.toString()),
              position: LatLng(trackingmap.vehiclesDetailData!.lat!, trackingmap.vehiclesDetailData!.lon!),
              draggable: true,
              icon:  markerIconCustom
            )
          },
          onCameraMove: (position) => context
              .read<MapsTrackingCubit>()
              .changeMarker(trackingmap),
          initialCameraPosition: CameraPosition(
              target: trackingmap.vehiclesDetailData!.coordinate, zoom: 12),
        ),
        Positioned(
            right: 13,
            top: mediaQuery.size.height / 12,
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    showMaterialModalBottomSheet(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17)),
                        elevation: 12,
                        isDismissible: true,
                        context: context,
                        builder: (context) => AlarmList(vehiclesDetailModel: widget.vehiclesDetailModel)
                    );
                  },
                  child: Stack(
                    children : [
                      Container(
                        padding: const EdgeInsets.all(11.5),
                        margin: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.5)),
                        child: Icon(
                          Icons.notifications,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: -1,
                        child:  Container(
                            padding: EdgeInsets.all(5.5),

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                            ),
                            child: Text(widget.vehiclesDetailModel!.vehiclesDetailData!.alarms!.length.toString(),style:TextStyle(color:Colors.white))
                        ),),
                    ]
                  )
                ),
                InkWell(
                  onTap: (){
                    showMaterialModalBottomSheet(
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17)),
                        elevation: 12,
                        isDismissible: true,
                        context: context,
                        builder: (context) => ChannelPicker(
                          license:  widget.license,
                          date: '',
                          fromWidget: Strings.liveVideo,
                        ));
                  },
                  child:  Container(
                    padding: const EdgeInsets.all(11.5),
                    margin: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.5)),
                    child: Icon(
                      Icons.videocam,
                      color: Colors.grey.shade800,
                    ),
                  ),
                )
              ],
            ))
      ],
    );

    // return BlocConsumer<MapsTrackingCubit, MapsTrackingState>(
    //     listener: (context, state) {
    //   if (state is MapsTrackingUpdate) {
    //     print('TrackingMapsClusterUpdateLISTENER');
    //   }
    // }, builder: (context, state) {
    //   // Set<Marker> markers = <Marker>{};
    //   var markers = <Marker>{};
    //
    //   if (state is MapsTrackingLoad) {
    //     print("MapsTrackingLoaded");
    //   } else if (state is MapsTrackingUpdate) {
    //     print('MapsClusterUpdate STRMAP');
    //
    //     print('MapsTrackingCluster ${state.mapMarkers.length}');
    //     markers = state.mapMarkers;
    //
    //     // print('SETTRACKINGMARKER '+ state.mapMarkers.first.icon.toString());
    //     // return Center(child: Text('This is Google Map'),);
    //   }
    //
    //
    // });
  }

  bool checkControlVisible(bool isVisibleMap, bool isVisibleStreetView) {
    if (isVisibleMap && !isVisibleStreetView) {
      return true;
    } else if (!isVisibleMap && isVisibleStreetView) {
      return true;
    } else {
      return false;
    }
  }
}
