import 'package:bloc/bloc.dart';
import 'package:fleetmanagement/data/network/app_interceptors.dart';
import 'package:fleetmanagement/data/video_repository.dart';
import 'package:fleetmanagement/models/video/playback/playback_data.dart';
import 'package:fleetmanagement/models/video/playback/playback_model.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';

part 'video_playback_event.dart';
part 'video_playback_state.dart';

class VideoPlaybackBloc extends Bloc<VideoPlaybackEvent, VideoPlaybackState> {
  VideoRepository videoRepository;

  VideoPlaybackBloc(this.videoRepository) : super(VideoPlaybackInitial());

  @override
  Stream<VideoPlaybackState> mapEventToState(
    VideoPlaybackEvent event,
  ) async* {
    final currentState = state;
    if (event is GetVideoPlayback) {
      bool isConnected = await InternetConnectionChecker().hasConnection;

      if (isConnected) {
        try {
          int pageToFetch = 1;
          List<PlaybackData> playbackModel = [];

          if (currentState is VideoPlaybackLoaded) {
            // pageToFetch = currentState.page! + 1;
            playbackModel = currentState.playbackDatas!;
            print(playbackModel);
          }

          PlaybackModel allPlaybackModel = await videoRepository.getPlaybackVideo(
              event.license!, event.channel!, event.cameraKey!, event.date!);

          bool hasReachMax = true;
          playbackModel.addAll(allPlaybackModel.data!);

          yield VideoPlaybackLoaded(
              playbackDatas: playbackModel,
              page: pageToFetch,
              hasReachedMax: hasReachMax);
        } on NoInternetConnectionException catch (error) {
          print("VIDEO_PLAYBACK_EE${error.message}");
        }on BadRequestException catch (error ) {
          yield VideoPlaybackError(error: error.message);
        }  on InternalServerErrorException catch (error) {
          print("VIDEO_PLAYBACK_EE${error.message}");
          yield VideoPlaybackError(error: error.message);
        } on UnauthorizedException catch (error) {
          print("VIDEO_PLAYBACK_EE${error.message}");
          yield VideoPlaybackError(error: error.message);
        } on NoQueryResultException catch (error) {
          print("VIDEO_PLAYBACK_EE${error.message}");
          yield VideoPlaybackError(error: error.message);
        } catch (e) {
          print("VIDEO_PLAYBACK_EE$e");
          yield VideoPlaybackError(error: e.toString());
        }
      }  else {
        yield FailedInternetConnection();
      }


    }
  }

  @override
  // TODO: implement initialState
  VideoPlaybackState get initialState => VideoPlaybackInitial();
}
