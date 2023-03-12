part of 'video_playback_bloc.dart';

@immutable
abstract class VideoPlaybackState {
  const VideoPlaybackState();
}

class FailedInternetConnection extends VideoPlaybackState {}

class VideoPlaybackInitial extends VideoPlaybackState {}

class VideoPlaybackLoading extends VideoPlaybackState {}

class VideoPlaybackLoaded extends VideoPlaybackState {
  List<PlaybackData>? playbackDatas;
  int? page;
  bool? hasReachedMax;
  VideoPlaybackLoaded({this.playbackDatas, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'VideoPlaybackLoaded { events: ${playbackDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class VideoPlaybackError extends VideoPlaybackState {
  final String? error;

  const VideoPlaybackError({this.error});
}
