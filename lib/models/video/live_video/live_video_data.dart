class LiveVideoData {
  String? channel;
  String? mainurl;
  String? suburl;

  LiveVideoData({this.channel, this.mainurl, this.suburl});

  LiveVideoData.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    mainurl = json['mainurl'];
    suburl = json['suburl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channel'] = channel;
    data['mainurl'] = mainurl;
    data['suburl'] = suburl;
    return data;
  }
}
