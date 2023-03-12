part of 'channel_bloc.dart';

@immutable
abstract class ChannelEvent {
  const ChannelEvent();
}

class GetChannel extends ChannelEvent {
  String? license;
  GetChannel({this.license});
}

class ShowChannelLoading extends ChannelEvent {}

class RefreshChannel extends ChannelEvent {
  const RefreshChannel();
}
