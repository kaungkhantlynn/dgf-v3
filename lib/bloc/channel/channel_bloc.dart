import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/models/video/channel_data.dart';
import 'package:fleetmanagement/models/video/channel_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'channel_event.dart';
part 'channel_state.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  VideoRepository videoRepository;

  ChannelBloc(this.videoRepository) : super(ChannelInitial());
  @override
  // TODO: implement initialState
  ChannelState get initialState => ChannelInitial();

  @override
  Stream<ChannelState> mapEventToState(
    ChannelEvent event,
  ) async* {
    final currentState = state;
    if (event is GetChannel) {

      bool isConnected = await InternetConnectionChecker().hasConnection;

      if (isConnected) {
        try {
          int pageToFetch = 1;
          List<ChannelData> channelModel = [];

          if (currentState is ChannelLoaded) {
            // pageToFetch = currentState.page! + 1;
            channelModel = currentState.channelDatas!;
            print(channelModel);
          }

          ChannelModel allChannelModel =
          await videoRepository.getChannels(event.license!);

          bool hasReachMax = true;
          channelModel.addAll(allChannelModel.data!);

          yield ChannelLoaded(
              channelDatas: channelModel,
              page: pageToFetch,
              hasReachedMax: hasReachMax);
        } catch (e) {
          print("CHANNEL_EE$e");
          ChannelError(error: e.toString());
        }
      }  else {
        yield FailedInternetConnection();
      }


    }
  }
}
