import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/models/video/live_video/live_video_data.dart';
import 'package:fleetmanagement/models/video/live_video/live_video_model.dart';
import 'package:meta/meta.dart';

part 'live_video_event.dart';
part 'live_video_state.dart';

class LiveVideoBloc extends Bloc<LiveVideoEvent, LiveVideoState> {
  VideoRepository videoRepository;

  LiveVideoBloc(this.videoRepository) : super(LiveVideoInitial());

  @override
  Stream<LiveVideoState> mapEventToState(
    LiveVideoEvent event,
  ) async* {
    final currentState = state;
    if (event is GetLiveVideo) {
      print('GETLIVEVIDEO');
      try {
        int pageToFetch = 1;
        List<LiveVideoData> liveVideoModel = [];

        if (currentState is LiveVideoLoaded) {
          //pageToFetch = currentState.page! + 1;
          liveVideoModel = currentState.liveVideoDatas!;
          print(liveVideoModel);
        }
        print('GETLIVE_CHANNEL ${event.channel!}');
        LiveVideoModel allliveVideoModel = await videoRepository.getLiveVideo(
            event.license!, event.channel!, event.cameraKey!);

        bool hasReachMax = true;
        liveVideoModel.addAll(allliveVideoModel.data!);

        yield LiveVideoLoaded(
            liveVideoDatas: liveVideoModel,
            page: pageToFetch,
            hasReachedMax: hasReachMax);
      } on NoInternetConnectionException catch (error) {
        print("LiveVideoEE${error.message}");
        yield LiveVideoError(error: error.message);
      } on BadRequestException catch (error ) {
        yield LiveVideoError(error: error.message);
      } on InternalServerErrorException catch (error) {
        print("LiveVideoEE${error.message}");
        yield LiveVideoError(error: error.message);
      } on UnauthorizedException catch (error) {
        print("LiveVideoEE${error.message}");
        yield LiveVideoError(error: error.message);
      } on NoQueryResultException catch (error) {
        print("VIDEO_PLAYBACK_EE${error.message}");
        yield LiveVideoError(error: error.message);
      } catch (e) {
        print("LiveVideoEE$e");
        LiveVideoError(error: e.toString());
      }
    }
  }

  @override
  // TODO: implement initialState
  LiveVideoState get initialState => LiveVideoInitial();
}
