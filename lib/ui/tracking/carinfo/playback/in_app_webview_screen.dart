import 'dart:collection';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/web_uri.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/video_playback_list.dart';

import '../../../widgets/appbar_page.dart';


class InAppWebViewScreen extends StatefulWidget {

  String? videoUrl;
  static const String route = '/in_app_webview_screen';
  InAppWebViewScreen({Key? key, this.videoUrl}) : super(key: key);

  @override
  _InAppWebViewScreenState createState() =>
      new _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  // InAppWebViewSettings settings = InAppWebViewSettings(
  //     mediaPlaybackRequiresUserGesture: false,
  //     allowsInlineMediaPlayback: true,
  //     iframeAllow: "camera; microphone",
  //     iframeAllowFullscreen: true
  // );

  Arguments? args;

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as Arguments;
      });
      print('PLAYBACKURL');
      print('https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/tracking/video/web_view?playback_url=${args!.videoUrl}');
    });




  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
        appBar: AppbarPage(
          title: '${translate('app_bar.playing')} ' +
              args!.beginTime! +
              ' - ' +
              args!.endTime!,
        ),

        body: SafeArea(
            child: Column(children: <Widget>[

             Container(
               color: Colors.grey.shade200,
               width: mediaQuery.size.width,
               height: mediaQuery.size.height / 2.35,
               child:  Stack(
                 children: [
                   InAppWebView(
                     key: webViewKey,
                     initialUrlRequest:
                     URLRequest(url: WebUri('https://fmwebplt-p4-stage.ap-southeast-1.elasticbeanstalk.com/tracking/video/web_view?playback_url=${args!.videoUrl!.replaceAll('&', '%26')}')),
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
               ),
             ),

            Container(
              margin: EdgeInsets.only(top: 6.6,left: 5,right: 5,bottom: 5),
              padding: EdgeInsets.all(5.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.5),
                border: Border.all(color: Colors.grey.shade300)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                    Icon(Icons.camera),
                    Icon(Icons.video_call_outlined),
                    InkWell(
                      onTap: (){
                        showMaterialModalBottomSheet(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(17)),
                            elevation: 12,
                            isDismissible: true,
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: new Icon(Icons.drive_file_move_sharp),
                                  title: new Text('Harddisk'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.cloud),
                                  title: new Text('Cloud Server'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ));
                      },
                      child: Icon(Icons.source),
                    ),
                    InkWell(
                      onTap: (){
                        showMaterialModalBottomSheet(
                            clipBehavior: Clip.hardEdge,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(17)),
                            elevation: 12,
                            isDismissible: true,
                            context: context,
                            builder: (context) => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: new Icon(Icons.list),
                                  title: new Text('SD'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: new Icon(Icons.list),
                                  title: new Text('HD'),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ));
                      },
                      child: Text('HD',style: TextStyle(color: Colors.grey.shade900,fontWeight: FontWeight.w600,fontSize: 18),)
                    ),
                ],
              )
            )


            ])));
  }
}
