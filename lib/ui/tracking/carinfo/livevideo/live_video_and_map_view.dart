import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:fleetmanagement/bloc/cubit/cluster/longdo_location_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/jsession_for_live_video/jsession_cubit.dart';
import 'package:fleetmanagement/bloc/cubit/jsession_for_live_video/jsession_state.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:url_launcher/url_launcher.dart';


import '../../../../bloc/cubit/cluster/longdo_location_state.dart';
import '../../../../bloc/cubit/live_video_link/live_video_link_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/maps_tracking_cubit.dart';
import '../../../../bloc/cubit/tracking_vehicle/maps_tracking_state.dart';
import '../../../../constants/strings.dart';
import '../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../di/components/service_locator.dart';
import '../../../../models/vehicles_detail/vehicles_detail_model.dart';
import '../../../widgets/appbar_page.dart';
import '../../../widgets/snackbar.dart';
import '../../maps/marker_icon.dart';
import '../../maps/view/widget/alarm_list.dart';
import '../components/channel_picker.dart';
import '../playback/web_uri.dart';

class LiveVideoAndMapView extends StatefulWidget {
  bool? alarmVisible;
  String? license;
  String? deviceId;
  VehiclesDetailModel? vehiclesDetailModel;
  String? status;
  String? speed;
  String? speedUnit;
  String? temperature;
  String? temperatureUnit;
  String? oil;
  String? oilUnit;
  String? mapIcon;
  String? channel;

  LiveVideoAndMapView({Key? key,this.alarmVisible,this.license,this.deviceId, this.vehiclesDetailModel,this.status,this.speed,this.speedUnit,this.temperature,this.temperatureUnit,this.oil,this.oilUnit,this.mapIcon,this.channel}) : super(key: key);

  @override
  State<LiveVideoAndMapView> createState() => _LiveVideoAndMapViewState();
}

class _LiveVideoAndMapViewState extends State<LiveVideoAndMapView> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();
  final GlobalKey globalKey = GlobalKey();

  bool? isVisibleStreetView = true;
  bool? isVisibleMap = true;


  var loadingPercentage = 0;
  var token ='';
  var videoLink = '';
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  PullToRefreshController? pullToRefreshController;

  late Animation<double> _animation;
  late AnimationController _animationController;

  int zoom = 18;

  @override
  void initState() {
    if (Platform.isAndroid) {
      // WebView.platform = SurfaceAndroidWebView();
      token = getIt<SharedPreferenceHelper>().loggedinToken!;
      // videoLink = 'http://dgftestnet.com/808gps/open/player/video.html?lang=en&devIdno=${widget.deviceId}&channel=${widget.channel!}&jsession=2f95bc2b6035436ca5f88c034348baca';

      _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 260),
      );
      final curvedAnimation = CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
      _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
    }
    fetchJsession(context);
    addCustomIcon();
    super.initState();
  }

  var  markerIconCustom = BitmapDescriptor.defaultMarker;


  void generateLiveVideoLink(BuildContext contextX, String license) async{

    print('LICENSE LIVELINK');
    Future.microtask(() {
      contextX
          .read<LiveVideoLinkCubit>()
          .fetchLiveVideoLink(license);
    });
  }



  void addCustomIcon() async{
    markerIconCustom =  await MarkerIcon.fromSvgUrl(context, widget.vehiclesDetailModel!.vehiclesDetailData!.mapIcon!);
  }
  void fetchJsession(BuildContext context) {
    // timer = Timer.periodic(Duration(seconds: 2), (timer) {
    //     Future.microtask((){
    //         context.read<LiveTrackingCubit>().fetchLivePoint(license);
    //     });
    // });
    Future.microtask(() {
      context.read<JsessionCubit>().fetchJsession();
    });
  }
  Center get buildCenterLoading => const Center(child: CircularProgressIndicator());
  @override
  Widget build(BuildContext context) {
    print('ISVISIBLE_ALARM ${widget.alarmVisible}');
    print('INIT_STREETVIEW ${widget.vehiclesDetailModel!.vehiclesDetailData!.coordinate.latitude},${widget.vehiclesDetailModel!.vehiclesDetailData!.coordinate.longitude}');
    var mediaQuery = MediaQuery.of(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
                translate('app_bar.live_video_and_map'),
                style: TextStyle(color: Colors.grey.shade800),
              ),
            )),
        actions: [
         // InkWell(
         //   onTap: (){
         //     webViewController?.takeScreenshot().then((value) async{
         //       if(value !=null){
         //         saved(value);
         //       }
         //     });
         //     // screenshotController
         //     //     .capture(delay: const Duration(milliseconds: 10))
         //     //     .then((capturedImage) async {
         //     //   // if (capturedImage != null) {
         //     //   //   saved(capturedImage);
         //     //   //
         //     //   //   /// Share Plugin
         //     //   //   // await Share.shareFiles([imagePath.path]);
         //     //   // }
         //     //
         //     //   ShowCapturedWidget(context, capturedImage!);
         //     // }).catchError((onError) {
         //     //   print(onError);
         //     // });
         //   },
         //   child:  Container(
         //       padding: EdgeInsets.all(4.4),
         //       margin: EdgeInsets.only(right: 3),
         //       child : Icon(Icons.camera_alt)
         //   )
         // ),
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
              child : Icon(Icons.video_camera_back_outlined)
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
              child : Icon(Icons.video_camera_back_outlined,color: Colors.green,)
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
      body:Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                visible: isVisibleStreetView!,
                child: Expanded(

                    child:Container(
                      child: Center(
                          child: BlocConsumer<JsessionCubit,JsessionState>(
                            listener: (context, state) {},
                            builder: (context,state){
                              switch(state.runtimeType) {
                                case JsessionInitial:
                                  print('JSESSION INITIOAL');
                                  fetchJsession(context);
                                  return buildCenterLoading;
                                case JsessionCompleted:
                                  var data = (state as JsessionCompleted);
                                  print('JSESSION ${data.jsessionModel.data!.jession}');
                                  videoLink = 'https://dgfmdvr.com/808gps/open/player/video.html?lang=en&devIdno=${widget.deviceId}&channel=${widget.channel!}&jsession=${data.jsessionModel.data!.jession}';
                                  print(videoLink);
                                  return   Stack(
                                    children: [
                                      InAppWebView(
                                        key: webViewKey,
                                        initialUrlRequest:
                                        URLRequest(url: WebUri(videoLink)),
                                        // initialUrlRequest:
                                        // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
                                        // initialFile: "assets/index.html",
                                        initialUserScripts: UnmodifiableListView<UserScript>([]),

                                        // contextMenu: contextMenu,
                                        pullToRefreshController: pullToRefreshController,
                                        onWebViewCreated: (controller) async {
                                          webViewController = controller;
                                          print(await controller.getUrl());
                                        },
                                        onLoadStart: (controller, url) async {
                                          setState(() {
                                            this.url = url.toString();
                                            urlController.text = this.url;
                                          });
                                        },

                                        onReceivedServerTrustAuthRequest: (controller, challenge) async {
                                          return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                                        },
                                        // onPermissionRequest: (controller, request) async {
                                        //   return PermissionResponse(
                                        //       resources: request.resources,
                                        //       action: PermissionResponseAction.GRANT);
                                        // },
                                        shouldOverrideUrlLoading:
                                            (controller, navigationAction) async {
                                          var uri = navigationAction.request.url!;

                                          if (![
                                            "http",
                                            "https",
                                            "file",
                                            "chrome",
                                            "data",
                                            "javascript",
                                            "about"
                                          ].contains(uri.scheme)) {
                                            if (await canLaunchUrl(uri)) {
                                              // Launch the App
                                              await launchUrl(
                                                uri,
                                              );
                                              // and cancel the request
                                              return NavigationActionPolicy.CANCEL;
                                            }
                                          }

                                          return NavigationActionPolicy.ALLOW;
                                        },
                                        onLoadStop: (controller, url) async {
                                          pullToRefreshController?.endRefreshing();
                                          setState(() {
                                            this.url = url.toString();
                                            urlController.text = this.url;
                                          });

                                        },
                                        // onReceivedError: (controller, request, error) {
                                        //   pullToRefreshController?.endRefreshing();
                                        // },
                                        onProgressChanged: (controller, progress) {
                                          if (progress == 100) {
                                            pullToRefreshController?.endRefreshing();
                                          }
                                          setState(() {
                                            this.progress = progress / 100;
                                            urlController.text = this.url;
                                          });
                                        },
                                        onUpdateVisitedHistory: (controller, url, isReload) {
                                          setState(() {
                                            this.url = url.toString();
                                            urlController.text = this.url;
                                          });
                                        },
                                        onConsoleMessage: (controller, consoleMessage) {
                                          print(consoleMessage);
                                        },
                                      ),
                                      progress < 1.0
                                          ? LinearProgressIndicator(value: progress)
                                          : Container(),
                                    ],
                                  );
                                default:{
                                  return buildCenterLoading;
                                }
                              }

                            },
                          )
                      ),),
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
          //   !checkControlVisible(isVisibleMap!, isVisibleStreetView!),
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
          //         IconButton(onPressed: (){
          //             setState(() {
          //               widget.alarmVisible = false;
          //             });
          //         }, icon: Icon(Icons.close,color: Colors.white,),),
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

        ],
      )
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
                  child:  Stack(
                    clipBehavior: Clip.none,
                    children: [

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
                    ],
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


  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  saved(Uint8List unit8list) async {
    var result = await ImageGallerySaver.saveImage(unit8list,
        quality: 80,
        name: DateFormat("dd MMMM yyyy hh:mm").format(DateTime.now()));

    print(result);

    ShowSnackBar.showWithScaffold(scaffoldKey,
        context,'Image saved to Gallery',
        color: Colors.blueGrey.shade700);
  }

  Future<void> handleStorage() async {
    Map<Permission, PermissionStatus> statuses =
    await [Permission.storage].request();

    switch (statuses[Permission.storage]) {
      case PermissionStatus.granted:
        break;
      case PermissionStatus.denied:
        print("denied");
        break;
      case PermissionStatus.permanentlyDenied:
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Permission Denied"),
            content: const Text("You need to give a permission"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Open Setting"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        );
        break;
      case PermissionStatus.restricted:
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Permission Denied"),
            content: const Text("You need to give a permission"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Open Setting"),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Container(
                  color: Colors.green,
                  padding: const EdgeInsets.all(14),
                  child: const Text("Close"),
                ),
              ),


            ],
          ),
        );
        break;
      default:
    }
  }


}
