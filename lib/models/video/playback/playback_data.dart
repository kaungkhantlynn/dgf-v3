class PlaybackData {
  int? id;
  String? name;
  String? downloadUrl;
  String? playbackUrl;
  String? beginTime;
  String? endTime;

  PlaybackData(
      {this.id,
      this.name,
      this.downloadUrl,
      this.playbackUrl,
      this.beginTime,
      this.endTime});

  PlaybackData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    downloadUrl = json['download_url'];
    playbackUrl = json['playback_url'];
    beginTime = json['beginTime'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['download_url'] = downloadUrl;
    data['playback_url'] = playbackUrl;
    data['beginTime'] = beginTime;
    data['endTime'] = endTime;
    return data;
  }
}
