import 'package:fleetmanagement/data/network/constants/endpoints.dart';
import 'package:fleetmanagement/data/network/dio_client.dart';
import 'package:fleetmanagement/data/network/rest_client.dart';
import 'package:fleetmanagement/models/video/camera_model.dart';
import 'package:fleetmanagement/models/video/channel_model.dart';
import 'package:fleetmanagement/models/video/live_video/live_video_model.dart';
import 'package:fleetmanagement/models/video/playback/playback_model.dart';

class VideoApi {
  //dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  VideoApi(this._dioClient, this._restClient);

  Future<ChannelModel> getChannel(String license) async {
    final res = await _dioClient.get('${Endpoints.channel}/$license');
    return ChannelModel.fromJson(res);
  }

  Future<CameraModel> getCamera(String license) async {
    final res = await _dioClient.get('${Endpoints.camera}/$license');
    return CameraModel.fromJson(res);
  }

  Future<LiveVideoModel> getLiveVideo(
      String license, String channel, int cameraKey) async {
    final res = await _dioClient.get('${Endpoints.livestreaming}/$license',
        queryParameters: {'channel': channel, 'camera': cameraKey});

    return LiveVideoModel.fromJson(res);
  }

  Future<PlaybackModel> getPlaybackVideo(
      String license, String channel, int cameraKey, String date) async {
    final res = await _dioClient.get('${Endpoints.playback}/$license',
        queryParameters: {
          'channel': channel,
          'camera': cameraKey,
          'date': date
        });

    return PlaybackModel.fromJson(res);
  }
}
