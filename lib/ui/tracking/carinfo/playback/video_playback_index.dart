import 'package:fleetmanagement/bloc/video_playback/video_playback_bloc.dart';
import 'package:fleetmanagement/constants/strings.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/video/playback/playback_data.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:fleetmanagement/ui/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
// import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class VideoPlaybackIndex extends StatefulWidget {
  static const String route = '/video_playback';
  const VideoPlaybackIndex({Key? key}) : super(key: key);

  @override
  _VideoPlaybackIndexState createState() => _VideoPlaybackIndexState();
}

class _VideoPlaybackIndexState extends State<VideoPlaybackIndex> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final args =
        ModalRoute.of(context)!.settings.arguments as ChannelNumberArgs;
    return BlocProvider(
      create: (BuildContext context) {
        return VideoPlaybackBloc(getIt<VideoRepository>());
      },
      child: Scaffold(
          appBar: AppbarPage(
            title: translate('app_bar.video_playback'),
          ),
          body: BlocBuilder<VideoPlaybackBloc, VideoPlaybackState>(
            builder: (context, state) {
              if (state is FailedInternetConnection) {
                ShowSnackBar.showWithScaffold(_scaffoldKey, context, translate('check_internet_connection'),
                    color: Colors.redAccent);
              }

              if (state is VideoPlaybackInitial) {
                print('VIDEO_PLAYBACK_INITIAL${args.channel!} ${args.cameraKey!} ${args.license!} ${args.date!}');
                BlocProvider.of<VideoPlaybackBloc>(context).add(
                    GetVideoPlayback(
                        license: args.license,
                        channel: args.channel!,
                        camera: args.camera!,
                        cameraKey: args.cameraKey!,
                        date: args.date));
              }
              if (state is VideoPlaybackLoaded) {
                print('VIDEO_PLAYBACK_LOAD');
                return state.playbackDatas!.isNotEmpty
                    ? SafeArea(
                        child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Builder(
                            //   builder: (BuildContext context) {
                            //     if (args.channel == '1') {
                            //       // return oneChannelLive(context, mediaQuery,
                            //       //     state.playbackDatas!);
                            //     } else {
                            //       // return multiChannelLive(
                            //       //     context, mediaQuery, state.playbackDatas);
                            //     }
                            //   },
                            // ),
                            Container(
                              width: mediaQuery.size.width,
                              height: 70,
                              margin:
                                  const EdgeInsets.only(top: 30, left: 10, right: 10),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                  fromWidget:
                                                      Strings.playbackVideo,
                                                ));
                                      },
                                      icon: const Icon(Icons.grid_view),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ShowSnackBar.showWithScaffold(
                                            _scaffoldKey,
                                            context,
                                            Strings.commingSoon,
                                            color: Colors.blueGrey.shade700);
                                      },
                                      icon: const Icon(Icons.camera_alt),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ShowSnackBar.showWithScaffold(
                                            _scaffoldKey,
                                            context,
                                            Strings.commingSoon,
                                            color: Colors.blueGrey.shade700);
                                      },
                                      icon: const Icon(Icons.movie_sharp),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        ShowSnackBar.showWithScaffold(
                                            _scaffoldKey,
                                            context,
                                            Strings.commingSoon,
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
                      ))
                    : const Center(
                        child: Text('No Data'),
                      );
              }

              if (state is VideoPlaybackError) {
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

  // Widget oneChannelLive(BuildContext context, MediaQueryData mediaQuery,
  //     List<PlaybackData>? playbackDatas) {
  //   VlcPlayerController vlcOneChannelController = VlcPlayerController.network(
  //     '${playbackDatas![0].downloadUrl!}.mp4',
  //     autoPlay: true,
  //   );
  //   return Container(
  //       color: Colors.grey.shade200,
  //       width: mediaQuery.size.width,
  //       height: mediaQuery.size.height / 2.35,
  //       child: Center(
  //           // _vlcOneChannelController.value.aspectRatio
  //           child: VlcPlayer(
  //         controller: vlcOneChannelController,
  //         aspectRatio: vlcOneChannelController.value.aspectRatio,
  //         placeholder: Container(
  //           child: const Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //       )));
  // }

  // Widget multiChannelLive(BuildContext context, MediaQueryData mediaQuery,
  //     List<PlaybackData>? playbackDatas) {
  //   print('PLAYBACK_LENGTH ${playbackDatas!.length}');
  //   return GridView.builder(
  //       itemCount: playbackDatas.length,
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //       ),
  //       itemBuilder: (context, index) {
  //         return videoPlayer(
  //             context, mediaQuery, playbackDatas[index].playbackUrl!);
  //       });
  // }
  //
  // Widget videoPlayer(
  //     BuildContext context, MediaQueryData mediaQuery, String mainUrl) {
  //   VlcPlayerController vlcMultiController = VlcPlayerController.network(
  //     '$mainUrl.mp4',
  //     autoPlay: true,
  //   );
  //   return Container(
  //       color: Colors.grey.shade200,
  //       width: mediaQuery.size.width,
  //       height: mediaQuery.size.height / 2.35,
  //       child: Center(
  //           // _vlcOneChannelController.value.aspectRatio
  //           child: VlcPlayer(
  //         controller: vlcMultiController,
  //         aspectRatio: vlcMultiController.value.aspectRatio,
  //         placeholder: Container(
  //           child: const Center(
  //             child: CircularProgressIndicator(),
  //           ),
  //         ),
  //       )));
  // }
}
