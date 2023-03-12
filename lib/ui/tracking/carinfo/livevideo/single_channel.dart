import 'package:fleetmanagement/models/video/live_video/live_video_data.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class SingleChannel extends StatefulWidget {
  List<LiveVideoData>? liveVideoDatas;
  SingleChannel({Key? key, this.liveVideoDatas}) : super(key: key);

  @override
  _SingleChannelState createState() => _SingleChannelState();
}

class _SingleChannelState extends State<SingleChannel> {
  // VlcPlayerController? _vlcOneChannelController;
  bool showLoading = false;

  @override
  void initState() {
    print("HEVCURL MAIN ${widget.liveVideoDatas![0].mainurl}");
    print("HEVCURL  SUB ${widget.liveVideoDatas![0].mainurl}");
    // _vlcOneChannelController = VlcPlayerController.network(
    //   widget.liveVideoDatas![0].suburl!,
    //   hwAcc: HwAcc.auto,
    //   autoInitialize: true,
    //   autoPlay: true,
    //   options: VlcPlayerOptions(
    //     advanced: VlcAdvancedOptions([
    //       VlcAdvancedOptions.networkCaching(2000),
    //
    //     ]),
    //     http: VlcHttpOptions([
    //       VlcHttpOptions.httpReconnect(true),
    //     ]),
    //   ),
    // );
    //
    // _vlcOneChannelController!.setMediaFromNetwork(
    //   widget.liveVideoDatas![0].suburl!,
    //   hwAcc: HwAcc.full,
    // );
    // _vlcOneChannelController!.addOnInitListener(() async {
    //   await _vlcOneChannelController!.startRendererScanning();
    // });

    playerInitTime();
  }

  playerInitTime() async {
    setState(() {
      showLoading = true;
    });
    await Future.delayed(const Duration(seconds: 16));
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    // return oneChannelLive(context, mediaQuery, widget.liveVideoDatas);
    return Stack(
      children: [
        // oneChannelLive(context, mediaQuery),
        Visibility(
            visible: showLoading,
            child: Positioned.fill(
                child: Center(
                    child: SizedBox.fromSize(
              size: const Size(50, 50),
              child: LiquidCircularProgressIndicator(
                value: 0.7, // Defaults to 0.5.
                valueColor: const AlwaysStoppedAnimation(Colors
                    .blue), // Defaults to the current Theme's accentColor.
                backgroundColor: Colors
                    .white, // Defaults to the current Theme's backgroundColor.

                direction: Axis
                    .vertical, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
              ),
            ))))
      ],
    );
  }

  // Widget oneChannelLive(BuildContext context, MediaQueryData mediaQuery) {
  //   // print("ONECHANNEL_RTSP "+ liveVideoDatas![0].suburl!);
  //
  //   return Container(
  //       color: Colors.grey.shade200,
  //       width: mediaQuery.size.width,
  //       height: mediaQuery.size.height / 2.35,
  //       child: Center(
  //           // _vlcOneChannelController.value.aspectRatio
  //           child: VlcPlayer(
  //         controller: _vlcOneChannelController!,
  //         aspectRatio: _vlcOneChannelController!.value.aspectRatio,
  //       )));
  // }

  @override
  void dispose() async {
    super.dispose();
    // await _vlcOneChannelController!.dispose();
  }
}
