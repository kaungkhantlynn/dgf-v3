part of 'live_video_bloc.dart';

@immutable
abstract class LiveVideoEvent {
  const LiveVideoEvent();
}

class GetLiveVideo extends LiveVideoEvent {
  String? license;
  String? channel;
  int? cameraKey;
  GetLiveVideo({this.license, this.channel, this.cameraKey});
}

class ShowLiveVideoLoading extends LiveVideoEvent {}

class RefreshLiveVideo extends LiveVideoEvent {
  const RefreshLiveVideo();
}
