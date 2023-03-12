import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:video_player/video_player.dart';

class MultiChannel extends StatefulWidget {
  String? subUrl;
  MultiChannel({Key? key, this.subUrl}) : super(key: key);

  @override
  _MultiChannelState createState() => _MultiChannelState();
}

class _MultiChannelState extends State<MultiChannel> {
  VideoPlayer? _vlcMultiController;
  bool showLoading = false;

  @override
  void initState() {
    print("SUB_URL ${widget.subUrl!}");
    // _vlcMultiController = VlcPlayerController.network(
    //   widget.subUrl!,
    //   hwAcc: HwAcc.auto,
    //   autoInitialize: true,
    //   autoPlay: true,
    //   options: VlcPlayerOptions(
    //     advanced: VlcAdvancedOptions([
    //       VlcAdvancedOptions.networkCaching(2000),
    //     ]),
    //     http: VlcHttpOptions([
    //       VlcHttpOptions.httpReconnect(true),
    //     ]),
    //   ),
    // );

    // _vlcMultiController!.setMediaFromNetwork(
    //   widget.subUrl!,
    //   hwAcc: HwAcc.full,
    // );

    playerInitTime();
  }

  playerInitTime() async {
    setState(() {
      showLoading = true;
    });
    await Future.delayed(const Duration(seconds: 17));
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Stack(
      children: [
        // videoPlayer(context, mediaQuery),
        Visibility(
            visible: showLoading,
            child: Positioned.fill(
                child: Center(
                    child: SizedBox.fromSize(
              size: const Size(50, 50),
              child: LiquidCircularProgressIndicator(
                value: 0.15, // Defaults to 0.5.
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

  // Widget videoPlayer(BuildContext context, MediaQueryData mediaQuery) {
  //   print("PLAYING_STATE_ERROR ${_vlcMultiController!.value.errorDescription}");
  //   print("PLAYING_STATE_HAS_ERROR ${_vlcMultiController!.value.hasError}");
  //   print(
  //       "PLAYING_STATE ${_vlcMultiController!.value.playingState}");
  //   return Container(
  //       color: Colors.grey.shade200,
  //       width: mediaQuery.size.width,
  //       height: mediaQuery.size.height / 2.35,
  //       child: Center(
  //           // _vlcOneChannelController.value.aspectRatio
  //           child: VlcPlayer(
  //         controller: _vlcMultiController!,
  //         aspectRatio: _vlcMultiController!.value.aspectRatio,
  //       )));
  // }

  @override
  void dispose() async {
    super.dispose();
    // await _vlcMultiController!.dispose();
  }
}
