import 'package:fleetmanagement/data/network/api/video/video_api.dart';
import 'package:fleetmanagement/data/sharedpref/shared_preference_helper.dart';
import 'package:fleetmanagement/models/video/camera_model.dart';
import 'package:fleetmanagement/models/video/channel_model.dart';
import 'package:fleetmanagement/models/video/live_video/live_video_model.dart';
import 'package:fleetmanagement/models/video/playback/playback_model.dart';

class VideoRepository {
  //api object
  final VideoApi _videoApi;

  //shared pref object
  final SharedPreferenceHelper _sharedPreferenceHelper;

  //constructor
  VideoRepository(this._videoApi, this._sharedPreferenceHelper);

  Future<ChannelModel> getChannels(String license) {
    return _videoApi.getChannel(license);
  }

  Future<CameraModel> getCameras(String license) {
    return _videoApi.getCamera(license);
  }

  Future<LiveVideoModel> getLiveVideo(
      String license, String channel, int cameraKey) {
    print('REPO_LIVE_VIDEO $channel');
    return _videoApi.getLiveVideo(license, channel, cameraKey);
  }

  Future<PlaybackModel> getPlaybackVideo(
      String license, String channel, int cameraKey, String date) {
    return _videoApi.getPlaybackVideo(license, channel, cameraKey, date);
  }
}
