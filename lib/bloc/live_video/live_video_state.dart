part of 'live_video_bloc.dart';

@immutable
abstract class LiveVideoState {
  const LiveVideoState();
}

class LiveVideoInitial extends LiveVideoState {}

class LiveVideoLoading extends LiveVideoState {}

class LiveVideoLoaded extends LiveVideoState {
  List<LiveVideoData>? liveVideoDatas;
  int? page;
  bool? hasReachedMax;
  LiveVideoLoaded({this.liveVideoDatas, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'LiveVideoLoaded { events: ${liveVideoDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class LiveVideoError extends LiveVideoState {
  final String? error;

  const LiveVideoError({this.error});
}
