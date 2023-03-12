import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../data/sharedpref/shared_preference_helper.dart';
import '../../../../di/components/service_locator.dart';

class WebVideoTest extends StatefulWidget {
  static const String route = '/live_video_web';
  const WebVideoTest({Key? key}) : super(key: key);

  @override
  State<WebVideoTest> createState() => _WebVideoTestState();
}

class _WebVideoTestState extends State<WebVideoTest> {
  var loadingPercentage = 0;
  var token ='';
  var videoLink = '';
  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
      token = getIt<SharedPreferenceHelper>().loggedinToken!;
      videoLink = 'https://dgfmdvr.com/808gps/open/player/video.html?lang=en&devIdno=111111111114&jsession=a6c97fdcc3d14fa18023e507d810535a';
      print(token);
      print('VIDDEOLINK');
      print(videoLink);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Video Player'),
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: 'http://dgftestnet.com/808gps/open/player/video.html?lang=en&devIdno=5055&jsession=dbe21283d2f04215a6519d2c7c90f8c4',
            onPageStarted: (url) {
              setState(() {
                loadingPercentage = 0;
              });
            },
            javascriptMode: JavascriptMode.unrestricted,
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy
                .require_user_action_for_all_media_types,
            allowsInlineMediaPlayback: true,
            gestureNavigationEnabled: true,
            onProgress: (progress) {
              setState(() {
                loadingPercentage = progress;
              });
            },
            onPageFinished: (url) {
              setState(() {
                loadingPercentage = 100;
              });
            },
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      )
    );
  }
}
