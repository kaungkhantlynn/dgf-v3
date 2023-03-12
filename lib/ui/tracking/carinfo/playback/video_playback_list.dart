import 'package:fleetmanagement/bloc/video_playback/video_playback_bloc.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/di/components/service_locator.dart';
import 'package:fleetmanagement/models/video/playback/playback_data.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/components/channel_picker.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/in_app_webview_screen.dart';
import 'package:fleetmanagement/ui/tracking/carinfo/playback/single_playback.dart';
import 'package:fleetmanagement/ui/widgets/appbar_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoPlaybackList extends StatefulWidget {
  static const String route = '/video_playback';
  const VideoPlaybackList({Key? key}) : super(key: key);

  @override
  _VideoPlaybackListState createState() => _VideoPlaybackListState();
}

class Arguments {
  String? videoUrl;
  String? beginTime;
  String? endTime;

  Arguments(this.videoUrl, this.beginTime, this.endTime);
}

class _VideoPlaybackListState extends State<VideoPlaybackList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isPlayed = false;
  String videoUrl = '';

  @override
  void initState() {
    super.initState();
  }

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
          title: 'Video Playback',
        ),
        body: BlocBuilder<VideoPlaybackBloc, VideoPlaybackState>(
          builder: (context, state) {
            if (state is VideoPlaybackInitial) {
              print('VIDEO_PLAYBACK_INITIAL${args.channel!} ${args.cameraKey!} ${args.license!} ${args.date!}');
              BlocProvider.of<VideoPlaybackBloc>(context).add(GetVideoPlayback(
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
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          //
                          // Visibility(
                          //     visible: isPlayed,
                          //     child: SinglePlayback(videoUrl:videoUrl)
                          // ),
                          Expanded(child: _buildVideoList(state.playbackDatas))
                        ],
                      ),
                    )
                  : const Center(
                      child: Text('No Data'),
                    );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVideoList(List<PlaybackData>? playbackDatas) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: playbackDatas!.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              setState(() {
                isPlayed = true;
                videoUrl = '${playbackDatas[index].playbackUrl!}';
              });

              print("MYURL $videoUrl");

              Navigator.pushNamed(context, InAppWebViewScreen.route,
                  arguments: Arguments(
                      videoUrl,
                      playbackDatas[index].beginTime,
                      playbackDatas[index].endTime!));
            },
            leading: const Icon(Icons.movie),
            title: const Text(
              'Time',
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              '${playbackDatas[index].beginTime} - ${playbackDatas[index].endTime}',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          );
        });
  }

  @override
  void dispose() async {
    super.dispose();
  }
}
