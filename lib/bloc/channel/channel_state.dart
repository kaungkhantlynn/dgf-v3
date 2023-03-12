part of 'channel_bloc.dart';

@immutable
abstract class ChannelState {
  const ChannelState();
}

class FailedInternetConnection extends ChannelState {}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelLoaded extends ChannelState {
  List<ChannelData>? channelDatas;
  int? page;
  bool? hasReachedMax;

  ChannelLoaded({this.channelDatas, this.page, this.hasReachedMax});

  @override
  String toString() =>
      'ChannelLoaded { events: ${channelDatas!.length}, hasReachedMax: $hasReachedMax }';
}

class ChannelError extends ChannelState {
  final String? error;

  const ChannelError({this.error});
}
