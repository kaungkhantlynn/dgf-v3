part of 'video_playback_bloc.dart';

@immutable
abstract class VideoPlaybackEvent {
  const VideoPlaybackEvent();
}

class GetVideoPlayback extends VideoPlaybackEvent {
  String? license;
  String? channel;
  String? camera;
  int? cameraKey;
  String? date;
  GetVideoPlayback(
      {this.license, this.channel, this.camera, this.cameraKey, this.date});
}

class ShowVideoPlaybackLoading extends VideoPlaybackEvent {}

class RefreshVideoPlayback extends VideoPlaybackEvent {
  const RefreshVideoPlayback();
}
