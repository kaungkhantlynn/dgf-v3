import 'dart:typed_data';

import 'package:fleetmanagement/bloc/live_video/live_video_bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/video/live_video/live_video_data.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/livevideo/multi_channel.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/livevideo/single_channel.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class LiveVideoIndex extends StatefulWidget {
  static const String route = '/live_video_index';
  const LiveVideoIndex({Key? key}) : super(key: key);

  @override
  _LiveVideoIndexState createState() => _LiveVideoIndexState();
}

class _LiveVideoIndexState extends State<LiveVideoIndex> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as ChannelNumberArgs;
    return BlocProvider(
      create: (BuildContext context) {
        return LiveVideoBloc(getIt<VideoRepository>());
      },
      child: Scaffold(
          appBar: AppbarPage(
            title: 'Live Video',
          ),
          body: BlocBuilder<LiveVideoBloc, LiveVideoState>(
            builder: (context, state) {
              if (state is LiveVideoInitial) {
                print('LIVE_VIDEO_INITIAL${args.channel!} ${args.cameraKey!} ${args.license!}');
                BlocProvider.of<LiveVideoBloc>(context).add(GetLiveVideo(
                    license: args.license,
                    channel: args.channel!,
                    cameraKey: args.cameraKey));
              }
              if (state is LiveVideoLoaded) {
                print('LIVE_VIDEO_LOADED');
                return SafeArea(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Builder(
                        builder: (BuildContext context) {
                          if (args.channel == '1') {
                            return Screenshot(controller: screenshotController, child: SingleChannel(
                              liveVideoDatas: state.liveVideoDatas,
                            ));
                          } else {
                            return Screenshot(controller: screenshotController, child: multiChannelLive(
                                context, mediaQuery, state.liveVideoDatas));
                          }
                        },
                      ),
                      Container(
                        width: mediaQuery.size.width,
                        height: 70,
                        margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.5),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(3.0, 3.0),
                                  blurRadius: 5.0,
                                  spreadRadius: 2.0,
                                  color: Colors.black12),
                            ]),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showMaterialModalBottomSheet(
                                      clipBehavior: Clip.hardEdge,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(17)),
                                      elevation: 12,
                                      isDismissible: true,
                                      context: context,
                                      builder: (context) => ChannelPicker(
                                            license: args.license,
                                            date: '',
                                            fromWidget: Strings.liveVideo,
                                          )
                                  );
                                },
                                icon: const Icon(Icons.grid_view),
                              ),
                              IconButton(
                                onPressed: () {
                                  screenshotController
                                      .capture(delay: const Duration(milliseconds: 10))
                                      .then((capturedImage) async {
                                    if (capturedImage != null) {
                                      saved(capturedImage);

                                      /// Share Plugin
                                      // await Share.shareFiles([imagePath.path]);
                                    }
                                  }).catchError((onError) {
                                    print(onError);
                                  });

                                },
                                icon: const Icon(Icons.camera_alt),
                              ),
                              IconButton(
                                onPressed: () {
                                  ShowSnackBar.showWithScaffold(_scaffoldKey,
                                      context, Strings.commingSoon,
                                      color: Colors.blueGrey.shade700);
                                },
                                icon: const Icon(Icons.movie_sharp),
                              ),
                              InkWell(
                                onTap: () {
                                  ShowSnackBar.showWithScaffold(_scaffoldKey,
                                      context, Strings.commingSoon,
                                      color: Colors.blueGrey.shade700);
                                },
                                child: const Text(
                                  'SD',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      fontFamily: 'Kanit'),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ));
              }
              if (state is LiveVideoError) {
                return Container(
                  child: Center(
                    child: Text(
                      state.error!,
                      style: const TextStyle(fontFamily: 'Kanit', fontSize: 16),
                    ),
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }

  Widget multiChannelLive(BuildContext context, MediaQueryData mediaQuery,
      List<LiveVideoData>? liveVideoDatas) {
    print('LIVE_VIDEO_DATA_LENGTH ${liveVideoDatas!.length}');
    return GridView.builder(
        itemCount: liveVideoDatas.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return MultiChannel(
            subUrl: liveVideoDatas[index].suburl!,
          );
        });
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

    ShowSnackBar.showWithScaffold(_scaffoldKey,
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
