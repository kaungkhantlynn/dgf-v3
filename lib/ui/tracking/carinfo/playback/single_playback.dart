import 'package:fleetmanagement/ui/tracking/carinfo/playback/video_playback_list.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SinglePlayback extends StatefulWidget {
  String? videoUrl;
  static const String route = '/playback_playing';
  SinglePlayback({Key? key, this.videoUrl}) : super(key: key);

  @override
  _SinglePlaybackState createState() => _SinglePlaybackState();
}

class _SinglePlaybackState extends State<SinglePlayback> {
  // VlcPlayerController? _controller;
  late VideoPlayerController _vediocontroller;
  bool showLoading = false;
  var loadingPercentage = 0;
  Arguments? args;
  @override
  void initState() {


    Future.delayed(Duration.zero, () {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as Arguments;
      });

    print('PLAYBACKURL');
    print('https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/tracking/video/web_view?playback_url=${args!.videoUrl}');

      // _controller = VlcPlayerController.network(
      //   'https://dgfmdvr.com:16611/3/5?DownType=5&jsession=&DevIDNO=5057&FILELOC=2&FILESVR=7&FILECHN=0&FILEBEG=35638&FILEEND=35938&PLAYIFRM=0&PLAYFILE=E:/gStorage/RECORD_FILE/5057/2023-01-06/1THP-5057_0-230106-095358-095858-20010100.mp4&PLAYBEG=0&PLAYEND=0&PLAYCHN=0&YEAR=23&MON=1&DAY=6',
      //   hwAcc: HwAcc.full,
      //   autoInitialize: true,
      //   autoPlay: true,
      //   options: VlcPlayerOptions(
      //
      //     // http: VlcHttpOptions([
      //     //   VlcHttpOptions.httpReconnect(true),
      //     // ]),
      //   ),
      // );

      // _vediocontroller= VideoPlayerController.network(
      //   'https://dgfmdvr.com:16611/3/5?DownType=5&jsession=&DevIDNO=5057&FILELOC=2&FILESVR=7&FILECHN=0&FILEBEG=35638&FILEEND=35938&PLAYIFRM=0&PLAYFILE=E:/gStorage/RECORD_FILE/5057/2023-01-06/1THP-5057_0-230106-095358-095858-20010100.mp4&PLAYBEG=0&PLAYEND=0&PLAYCHN=0&YEAR=23&MON=1&DAY=6')
      //   ..initialize().then((_) {
      //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //     setState(() {});
      //   });

      // playerInitTime();
    });

    //
    // _controller!.addOnInitListener(() async {
    //   await _controller!.startRendererScanning();
    // });
  }

  playerInitTime() async {
    setState(() {
      showLoading = true;
    });
    await Future.delayed(const Duration(seconds: 6));
    setState(() {
      showLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppbarPage(
        title: translate('app_bar.playing'),
      ),
      body: Stack(
        children: [
          oneChannelPlayback(context, mediaQuery),
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
      ),
    );
  }

  Widget oneChannelPlayback(BuildContext context, MediaQueryData mediaQuery) {
    return Container(
        color: Colors.grey.shade200,
        width: mediaQuery.size.width,
        height: mediaQuery.size.height / 2.35,
        // child: Center(
        //   child: _vediocontroller.value.isInitialized
        //       ? AspectRatio(
        //     aspectRatio: _vediocontroller.value.aspectRatio,
        //     child: VideoPlayer(_vediocontroller),
        //   )
        //       : Container(),
        // ),
        // child: Center(
        //     // _vlcOneChannelController.value.aspectRatio
        //     child: VlcPlayer(
        //   controller: _controller!,
        //   aspectRatio: _controller!.value.aspectRatio,
        // ))
      child: InAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse("https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/tracking/video/web_view?playback_url=https://dgfmdvr.com:16611/3/5?DownType=5%26jsession=%26DevIDNO=5057%26FILELOC=2%26FILESVR=7%26FILECHN=0%26FILEBEG=35945%26FILEEND=36245%26PLAYIFRM=0%26PLAYFILE=E:/gStorage/RECORD_FILE/5057/2023-01-06/1THP-5057_0-230106-095905-100405-20010100.mp4%26PLAYBEG=0%26PLAYEND=0%26PLAYCHN=0%26YEAR=23%26MON=1%26DAY=6")
        ),
        // onReceivedServerTrustAuthRequest: (controller, challenge) async {
        //   print(challenge);
        //   return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
        // },
      ),

      // child: WebView(
      //   initialUrl: 'https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/tracking/video/web_view?playback_url=https://dgfmdvr.com:16611/3/5?DownType=5%26jsession=%26DevIDNO=5057%26FILELOC=2%26FILESVR=7%26FILECHN=0%26FILEBEG=35945%26FILEEND=36245%26PLAYIFRM=0%26PLAYFILE=E:/gStorage/RECORD_FILE/5057/2023-01-06/1THP-5057_0-230106-095905-100405-20010100.mp4%26PLAYBEG=0%26PLAYEND=0%26PLAYCHN=0%26YEAR=23%26MON=1%26DAY=6',
      //   onPageStarted: (url) {
      //     setState(() {
      //       loadingPercentage = 0;
      //     });
      //   },
      //   javascriptMode: JavascriptMode.unrestricted,
      //   initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy
      //       .require_user_action_for_all_media_types,
      //   debuggingEnabled: true,
      //   allowsInlineMediaPlayback: true,
      //   gestureNavigationEnabled: true,
      //   onProgress: (progress) {
      //     setState(() {
      //       loadingPercentage = progress;
      //     });
      //   },
      //   onPageFinished: (url) {
      //     setState(() {
      //       loadingPercentage = 100;
      //     });
      //   },
      // ),
    );
  }

  @override
  void dispose() async {
    super.dispose();
    // await _controller!.dispose();
  }
}
